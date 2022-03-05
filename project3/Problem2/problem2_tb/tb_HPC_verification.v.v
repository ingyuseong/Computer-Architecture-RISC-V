//========================================
//  COMMIT (Compiler & Micro-architecture)
//========================================

`define NULL 0
module tb_HPC_verification;

reg clk;
reg rst_x;
//------------------------------------------------
//  Clock & Reset
//------------------------------------------------

parameter FREQ   = 100;
parameter CKP    = 1000.0/FREQ;
initial  forever #(CKP/2)    clk  = ~clk;
initial  begin 
   clk = 1'b1;
end


initial begin
   rst_x = 1'b1;
   repeat (5) @(posedge clk);
   #(CKP/2) rst_x = 1'b0;
   $display ("Reset disable... Simulation Start !!! ");    
end


//task define
task wait_clocks;
   input integer num_clocks;
   integer cnt_clocks;
   for(cnt_clocks = 0; cnt_clocks < num_clocks; cnt_clocks = cnt_clocks + 1) begin
     @ (posedge clk);
   end
endtask 

//------------------------------------------------
//  Test Input Trace
//------------------------------------------------
parameter TRACE_SIZE = 100;

integer               file_decsriptor; // file handler
integer               file_io; // file handler
integer               i;
integer               start;

reg [31:0]   in_inst[0:TRACE_SIZE-1];

initial begin
  file_decsriptor = $fopen("input_inst.dat", "r");
  if (file_decsriptor == `NULL) begin
    $display("file_decsriptor was NULL");
    $finish;
  end
  for( i =0; i< TRACE_SIZE; i=i+1) begin
    file_io = $fscanf(file_decsriptor,"%x\n", in_inst[i]); 
  end
   $display ("File Read Done!");
end

//------------------------------------------------
//  Test Logic
//------------------------------------------------

//inputs
reg          rst_cpu_i;
// instruction write port
reg  [  3:0]  tb_inst_we_i;
reg  [ 31:0]  tb_inst_addr_i;
reg  [ 31:0]  tb_inst_data_i;

riscv_tcm_top 
#( 
    .CORE_ID            (0),
    .MEM_CACHE_ADDR_MIN (0),
    .MEM_CACHE_ADDR_MAX (32'hffffffff)
)
UUT_RISCV_SOC
(
    // Inputs
    .clk_i           (clk)
    ,.rst_i           (rst_x)
    ,.rst_cpu_i       (rst_cpu_i       )
    // Outputs

    // instruction write
    ,.tb_inst_we_i    (tb_inst_we_i    )
    ,.tb_inst_addr_i  (tb_inst_addr_i  )
    ,.tb_inst_data_i  (tb_inst_data_i  )
);

//==========================
//  debugging variables
//==========================
integer      j, cycle_tick;
integer      debug_pc_trace;

wire [31:0]  debug_inst;
wire [31:0]  debug_cnt_Rtype;
wire [31:0]  debug_cnt_Itype;
wire [31:0]  debug_cnt_Stype;
wire [31:0]  debug_cnt_Btype;
wire [31:0]  debug_cnt_Utype;
wire [31:0]  debug_cnt_Jtype;

assign debug_inst             = UUT_RISCV_SOC.u_core.u_fetch.icache_inst_i;
assign debug_cnt_Rtype        = UUT_RISCV_SOC.u_core.u_issue.u_pipe_ctrl.u_HPC.HPC_req_Rtype;
assign debug_cnt_Itype        = UUT_RISCV_SOC.u_core.u_issue.u_pipe_ctrl.u_HPC.HPC_req_Itype;
assign debug_cnt_Stype        = UUT_RISCV_SOC.u_core.u_issue.u_pipe_ctrl.u_HPC.HPC_req_Stype;
assign debug_cnt_Btype        = UUT_RISCV_SOC.u_core.u_issue.u_pipe_ctrl.u_HPC.HPC_req_Btype;
assign debug_cnt_Utype        = UUT_RISCV_SOC.u_core.u_issue.u_pipe_ctrl.u_HPC.HPC_req_Utype;
assign debug_cnt_Jtype        = UUT_RISCV_SOC.u_core.u_issue.u_pipe_ctrl.u_HPC.HPC_req_Jtype;

wire check_Rtype;
wire check_Itype;
wire check_Stype;
wire check_Btype;
wire check_Utype;
wire check_Jtype;

assign check_Rtype  = (debug_cnt_Rtype == 32'h0000_0000)?1'b1:1'b0;
assign check_Itype  = (debug_cnt_Itype == 32'h0000_0011)?1'b1:1'b0;
assign check_Stype  = (debug_cnt_Stype == 32'h0000_0005)?1'b1:1'b0;
assign check_Btype  = (debug_cnt_Btype == 32'h0000_0001)?1'b1:1'b0;
assign check_Utype  = (debug_cnt_Utype == 32'h0000_0002)?1'b1:1'b0;
assign check_Jtype  = (debug_cnt_Jtype == 32'h0000_0003)?1'b1:1'b0;

wire [5:0] check_sum = {check_Rtype,  
                        check_Itype,
                        check_Stype,
                        check_Btype,
                        check_Utype,
                        check_Jtype
                          };

task INIT_MEM_WRITE;
  input [31:0] req_pc;
  input [31:0] req_instruction;
  begin
    tb_inst_we_i           = 4'hf;
    tb_inst_addr_i         = req_pc;
    tb_inst_data_i         = req_instruction;
    wait_clocks(1);
    tb_inst_we_i           = 4'b0;
  end
endtask

task CHECK_INST;
  input check_inst_cnt;
  begin
    if(check_inst_cnt)         $display ("Pass");
    else                       $display ("Fail");
  end
endtask


initial begin
  start   = 0;
  $display ("Request enqueue start!");
  start   = 1;
  wait_clocks(1);

  for( j =0; j< TRACE_SIZE; j=j+1) begin 
  INIT_MEM_WRITE(j * 4, in_inst[j]);
  end
  wait_clocks(1);

  $display ("Request enqueue end!");
  wait_clocks(1);


  rst_cpu_i = 1'b1;
  wait_clocks(1);
  rst_cpu_i = 1'b0; 


  //Execution Phase
  wait_clocks(1);
  $display ("Core reset");
  
  //====================
  //  Main Sequence 
  //====================
  debug_pc_trace = $fopen ("debug_pc_trace.txt", "w");



    wait_clocks(1);
   for(cycle_tick = 0; cycle_tick<40000; cycle_tick=cycle_tick+1)begin
     wait_clocks(1);
     $fwrite(debug_pc_trace,"Cycle[%d], PC=%x\n",cycle_tick, debug_inst);
    if(debug_inst == 32'h0000_8067) 
    begin
      wait_clocks(4);
      $display ("Check type: R-type");
      CHECK_INST(check_sum[5]);
      wait_clocks(1);
      $display ("Check type: I-type");
      CHECK_INST(check_sum[4]);
      wait_clocks(1);
      $display ("Check type: S-type");
      CHECK_INST(check_sum[3]);
      wait_clocks(1);

      $display ("Check type: B-type");
      CHECK_INST(check_sum[2]);
      wait_clocks(1);
      $display ("Check type: U-type");
      CHECK_INST(check_sum[1]);
      wait_clocks(1);
      $display ("Check type: J-type");
      CHECK_INST(check_sum[0]);
      wait_clocks(1);

     $finish();
    end
   end
    

end  




endmodule