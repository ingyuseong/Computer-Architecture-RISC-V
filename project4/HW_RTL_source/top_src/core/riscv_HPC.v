module riscv_HPC (
    
    clk, 
    rst_i,

    //Request information from pipline controller
    req_pc,
    req_next_pc,
    req_inst_opcode,
    req_inst_valid,
    
    
    //Not used in Project 3, Interface for future use.
      // Committed & retired instruction 
      req_inst_commit,
      req_inst_retired,
      //ALU bound instruction info.
      req_inst_ALU,
      req_inst_div,
      req_inst_mul,
      stall_by_ALU,
      //Memory bound instruction info. 
      req_inst_load,
      req_inst_store,
      stall_by_MEM,
      //Control flow bound instruction info. 
      req_inst_branch,
      req_branch_taken,
      req_branch_inst_pc,
      req_branch_target

);


    input        clk;
    input        rst_i;

    input [31:0] req_pc;
    input [31:0] req_next_pc;
    input [31:0] req_inst_opcode;
    input        req_inst_valid;

    input        req_inst_commit;
    input        req_inst_retired;

    input        req_inst_ALU;
    input        req_inst_div;
    input        req_inst_mul;
    input        stall_by_ALU;

    input        req_inst_load;
    input        req_inst_store;
    input        stall_by_MEM;

    input        req_inst_branch;
    input        req_branch_taken;
    input [31:0] req_branch_inst_pc;
    input [31:0] req_branch_target;
    
    
/*
Project 3
*/

    reg [31:0]  HPC_req_Rtype;
    reg [31:0]  HPC_req_Itype;
    reg [31:0]  HPC_req_Stype;
    reg [31:0]  HPC_req_Btype;
    reg [31:0]  HPC_req_Utype;
    reg [31:0]  HPC_req_Jtype;

/*
Project 4
*/
    reg [31:0]   HPC_req_retired;
    reg [63:0]   HPC_exe_cycle;

    reg [31:0]   HPC_req_ALU;
    reg [31:0]   HPC_req_ALU_stall_cycle;
    reg [31:0]   HPC_req_MEM;
    reg [31:0]   HPC_req_MEM_stall_cycle;
    reg [31:0]   HPC_req_MEM_cause_stall;
    
//===============================================
//  Problem 1 related
//===============================================

//Retired instruction & execution cycle 
always @(posedge rst_i or posedge clk) begin
    if     (rst_i)            HPC_req_retired  <='b0;
    else if(req_inst_retired) HPC_req_retired  <= HPC_req_retired + 1'b1;
end

always @(posedge rst_i or posedge clk) begin
    if     (rst_i)            HPC_exe_cycle  <='b0;
    else                      HPC_exe_cycle  <= HPC_exe_cycle + 1'b1;
end

/*Hint/
// Notice that not all req_MEM cause memory stall! 
// You should check that which signal among memory instructions cause stall. 
// Below code make a control signal for counting number of instructions that cause memory stall. 
wire  stall_sig_rising_edge;
assign stall_sig_rising_edge = stall_by_MEM;
reg stall_sig_rising_edge_r;
 always @(posedge rst_i or posedge clk) begin
     if     (rst_i)                          stall_sig_rising_edge_r  <=1'b0;
     else                                    stall_sig_rising_edge_r  <=stall_sig_rising_edge;  
 end
wire stall_MEM_cause_sig;
assign stall_MEM_cause_sig = (stall_sig_rising_edge==1'b1)&&(stall_sig_rising_edge_r==1'b0);

always @(posedge rst_i or posedge clk) begin
    if     (rst_i)                          HPC_req_MEM_cause_stall  <='b0;
    else if(stall_MEM_cause_sig)            HPC_req_MEM_cause_stall  <= HPC_req_MEM_cause_stall + 1'b1;  
end

*/


//ALU bound instruction & stall cycle 
/*Write your own code below*/

//Memory bound instruction & stall cycle
/*Write your own code below*/




//===============================================
//  Problem 2 related
//===============================================

localparam FETCH_PC_BHT_INDEX_L     = 2;  
localparam FETCH_PC_BHT_INDEX_H     = 5;
`define FETCH_PC_BHT_INDEX  FETCH_PC_BHT_INDEX_H:FETCH_PC_BHT_INDEX_L

localparam STATE_STRONG_TAKEN      = 2'b00;
localparam STATE_WEAK_TAKEN        = 2'b01;
localparam STATE_WEAK_NOT_TAKEN    = 2'b10;
localparam STATE_STRONG_NOT_TAKEN  = 2'b11;

/* Branch History Table 

   BHT: Entry size 16
   Addr     Data
   0      |-----| 2-bit
   1      |-----| 2-bit
      ..
   15     |-----| 2-bit
*/

/*
    2 bit predictor state parameter definition
*/
reg  [1:0]  HPC_branch_history_table[0:15]; //Branch History Table
wire [1:0]  branch_history_on_PC_w;
reg  [3:0]  req_branch_history_index;
wire        branch_pred_out;
reg         req_inst_branch_r;
wire        branch_pred_result;

//reg [31:0]   HPC_req_BRANCH_taken;
//reg [31:0]   HPC_req_jalr;
wire         req_conditional_branch;
reg          req_conditional_branch_r;

/*Hint/
// Notice that not all req_branch is B-type instruction. 
// Jump and JALR instructions are also consider as branch_taken signal
    But BHT operates with only conditional branch, so need a req_conditional_branch signal
*/

assign req_conditional_branch = (req_inst_branch && req_inst_opcode[6:0] == 7'b110_0011);
always @(posedge rst_i or posedge clk) begin
    if(rst_i)                  req_conditional_branch_r <= 1'b0;
    else                       req_conditional_branch_r <= req_conditional_branch;
end

assign branch_pred_out = req_conditional_branch && (!HPC_branch_history_table[req_branch_inst_pc[`FETCH_PC_BHT_INDEX]][1]);
assign branch_pred_result = req_conditional_branch && (branch_pred_out == req_branch_taken);

// set initial state of BHT entries as 'STATE_WEAK_NOT_TAKEN'


/*Write your own code below */
















    


endmodule