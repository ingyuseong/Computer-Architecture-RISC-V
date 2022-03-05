//========================================
//  COMMIT (Compiler & Micro-architecture)
//========================================

`define NULL 0
module tb_tcm_riscv_top;

reg clk;
reg rst_x;
//------------------------------------------------
//Clock & Reset
//------------------------------------------------

parameter FREQ   = 1;
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
//Test Input Trace
//------------------------------------------------
parameter TRACE_SIZE = 100;

integer               file_decsriptor; // file handler
integer               file_io; // file handler
integer               i;
integer               start;
integer               mul_result_file_descriptor;

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
//Test Logic
//------------------------------------------------

//inputs
reg          rst_cpu_i;

//outputs

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

integer      debug_cache_eviction;
integer      j, cycle_tick;


wire [31:0]     debug_cache_eviction_addr;
wire [31:0]     debug_cache_eviction_data;
wire      debug_axi_wready;
wire      debug_axi_wvalid;

//=========================
// debugging cache 
//=========================
assign debug_cache_eviction_addr    = UUT_RISCV_SOC.u_dcache.axi_awaddr_o;
assign debug_cache_eviction_data    = UUT_RISCV_SOC.u_dcache.axi_wdata_o;
assign debug_axi_wready             = UUT_RISCV_SOC.u_dcache.axi_wready_i;
assign debug_axi_wvalid             = UUT_RISCV_SOC.u_dcache.axi_wvalid_o;


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

initial begin
  //wait_clocks(10);
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


  start   = 0;
  $display ("Instruction enqueue start");
  debug_cache_eviction = $fopen ("debug_cache_eviction_trace.txt", "w");
  
  //Execution Phase
  wait_clocks(1);
  $display ("Core reset");
  
  //====================
  //  Main Sequence 
  //====================

  //Debug Phase
  for(cycle_tick = 0; ; cycle_tick=cycle_tick+1)
  begin
    if(
      (debug_axi_wready == 1)
      && (debug_axi_wvalid == 1)
    ) begin
      $fwrite(debug_cache_eviction,"address=%x, data=%x\n", debug_cache_eviction_addr, debug_cache_eviction_data);
    end

    wait_clocks(1);
    

  end

end

endmodule