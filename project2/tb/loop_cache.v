//========================================
//  COMMIT (Compiler & Micro-architecture)
//========================================

`define NULL 0
module tb_tcm_riscv_top;

reg clk;
reg rst_x;
//------------------------------------------------
//  Clock & Reset
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
//  Test Input Trace
//------------------------------------------------
parameter TRACE_SIZE = 100;

integer               file_decsriptor; // file handler
integer               file_io; // file handler
integer               i,j;
integer               start;
integer               mul_result_file_descriptor;

reg [31:0]   in_inst[0:TRACE_SIZE-1];

initial begin
  file_decsriptor = $fopen("input_inst2.dat", "r");
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

integer      debug_cache_hit_count_trace;
integer      cycle_tick;
wire [31:0]  debug_inst;

wire [31:0]      debug_cache_state_q;
wire [31:0]      debug_cache_mem_accept_r;
wire [31:0]      debug_cache_tag_hit_any_m_w;
wire [31:0]      debug_cache_wr_i;
wire [31:0]      debug_cache_rd_i;

integer      debug_cache_access_counter;
integer      debug_cache_hit_counter;

//=========================
// debugging cache 
//=========================

assign debug_inst                   = UUT_RISCV_SOC.u_core.u_fetch.icache_inst_i;

assign debug_cache_state_q          = UUT_RISCV_SOC.u_dcache.u_core.state_q;
assign debug_cache_mem_accept_r     = UUT_RISCV_SOC.u_dcache.u_core.mem_accept_r;
assign debug_cache_tag_hit_any_m_w  = UUT_RISCV_SOC.u_dcache.u_core.tag_hit_any_m_w;
assign debug_cache_wr_i             = UUT_RISCV_SOC.u_dcache.u_core.mem_wr_i;
assign debug_cache_rd_i             = UUT_RISCV_SOC.u_dcache.u_core.mem_rd_i;


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
  debug_cache_access_counter = 0;
  debug_cache_hit_counter = 0;
  $display ("Instruction enqueue start");
  debug_cache_hit_count_trace = $fopen ("debug_cache_hit_count.txt", "w");
  
  //Execution Phase
  wait_clocks(1);
  $display ("Core reset");
  
  //====================
  //  Main Sequence 
  //====================

  //Debug Phase
  for(cycle_tick = 0; ; cycle_tick=cycle_tick+1)begin
    if((debug_cache_mem_accept_r == 1) 
        && (debug_cache_tag_hit_any_m_w == 1)
        && (debug_cache_state_q == 3)
        && ((debug_cache_rd_i != 0) || (debug_cache_wr_i != 0))
    )begin
      debug_cache_access_counter = debug_cache_access_counter + 1;
      debug_cache_hit_counter = debug_cache_hit_counter + 1;
    end
    if((debug_cache_mem_accept_r == 1) 
        && (debug_cache_tag_hit_any_m_w == 0)
        && (debug_cache_state_q == 3)
        && ((debug_cache_rd_i != 0) || (debug_cache_wr_i != 0))
    ) begin
      debug_cache_access_counter = debug_cache_access_counter + 1;
    end

    wait_clocks(1);
    
    if(debug_inst == 32'h0000_8067)begin
      $fwrite(debug_cache_hit_count_trace,"cache_access_count=%d,\tcache_hit_count=%d\n", debug_cache_access_counter, debug_cache_hit_counter);

      wait_clocks(5);
      $finish();
    end  

  end

end




endmodule