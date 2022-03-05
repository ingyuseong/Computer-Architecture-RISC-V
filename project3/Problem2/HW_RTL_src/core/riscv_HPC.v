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

    always @ (posedge clk or posedge rst_i)
    begin
        if (rst_i)
        begin
            HPC_req_Rtype <= 32'h0000_0000;
            HPC_req_Itype <= 32'h0000_0000;
            HPC_req_Stype <= 32'h0000_0000;
            HPC_req_Btype <= 32'h0000_0000;
            HPC_req_Utype <= 32'h0000_0000;
            HPC_req_Jtype <= 32'h0000_0000;
        end
        else if (req_inst_valid)
        begin
            if (req_inst_opcode[6:0] == 7'b0110011)
                HPC_req_Rtype <= HPC_req_Rtype + 32'd1;
            else if (req_inst_opcode[6:0] == 7'b1100111 || req_inst_opcode[6:0] == 7'b0000011 || req_inst_opcode[6:0] == 7'b0010011)
                HPC_req_Itype <= HPC_req_Itype + 32'd1;
            else if (req_inst_opcode[6:0] == 7'b0100011)
                HPC_req_Stype <= HPC_req_Stype + 32'd1;
            else if (req_inst_opcode[6:0] == 7'b1100011)
                HPC_req_Btype <= HPC_req_Btype + 32'd1;
            else if (req_inst_opcode[6:0] == 7'b0110111 || req_inst_opcode[6:0] == 7'b0010111)
                HPC_req_Utype <= HPC_req_Utype + 32'd1;
            else if (req_inst_opcode[6:0] == 7'b1101111)
                HPC_req_Jtype <= HPC_req_Jtype + 32'd1;
        end
    end

    
/*
Project 4
*/

    


endmodule