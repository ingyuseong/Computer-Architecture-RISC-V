//-----------------------------------------------------------------
//                         RISC-V Core
//                            V1.0
//                     Ultra-Embedded.com
//                     Copyright 2014-2019
//
//                   admin@ultra-embedded.com
//
//                       License: BSD
//-----------------------------------------------------------------
//
// Copyright (c) 2014-2019, Ultra-Embedded.com
// All rights reserved.
// 
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions 
// are met:
//   - Redistributions of source code must retain the above copyright
//     notice, this list of conditions and the following disclaimer.
//   - Redistributions in binary form must reproduce the above copyright
//     notice, this list of conditions and the following disclaimer 
//     in the documentation and/or other materials provided with the 
//     distribution.
//   - Neither the name of the author nor the names of its contributors 
//     may be used to endorse or promote products derived from this 
//     software without specific prior written permission.
// 
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS 
// "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT 
// LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR 
// A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE AUTHOR BE 
// LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR 
// CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF 
// SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR 
// BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF 
// LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
// (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF 
// THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF 
// SUCH DAMAGE.
//-----------------------------------------------------------------

module riscv_mmu
//-----------------------------------------------------------------
// Params
//-----------------------------------------------------------------
#(
     parameter MEM_CACHE_ADDR_MIN = 32'h80000000
    ,parameter MEM_CACHE_ADDR_MAX = 32'h8fffffff
    ,parameter SUPPORT_MMU      = 0
)
//-----------------------------------------------------------------
// Ports
//-----------------------------------------------------------------
(
    // Inputs
     input           clk_i
    ,input           rst_i
    ,input  [  1:0]  priv_d_i
    ,input           sum_i
    ,input           mxr_i
    ,input           flush_i
    ,input  [ 31:0]  satp_i
    ,input           fetch_in_rd_i
    ,input           fetch_in_flush_i
    ,input           fetch_in_invalidate_i
    ,input  [ 31:0]  fetch_in_pc_i
    ,input  [  1:0]  fetch_in_priv_i
    ,input           fetch_out_accept_i
    ,input           fetch_out_valid_i
    ,input           fetch_out_error_i
    ,input  [ 31:0]  fetch_out_inst_i
    ,input  [ 31:0]  lsu_in_addr_i
    ,input  [ 31:0]  lsu_in_data_wr_i
    ,input           lsu_in_rd_i
    ,input  [  3:0]  lsu_in_wr_i
    ,input           lsu_in_cacheable_i
    ,input  [ 10:0]  lsu_in_req_tag_i
    ,input           lsu_in_invalidate_i
    ,input           lsu_in_writeback_i
    ,input           lsu_in_flush_i
    ,input  [ 31:0]  lsu_out_data_rd_i
    ,input           lsu_out_accept_i
    ,input           lsu_out_ack_i
    ,input           lsu_out_error_i
    ,input  [ 10:0]  lsu_out_resp_tag_i

    // Outputs
    ,output          fetch_in_accept_o
    ,output          fetch_in_valid_o
    ,output          fetch_in_error_o
    ,output [ 31:0]  fetch_in_inst_o
    ,output          fetch_out_rd_o
    ,output          fetch_out_flush_o
    ,output          fetch_out_invalidate_o
    ,output [ 31:0]  fetch_out_pc_o
    ,output          fetch_in_fault_o
    ,output [ 31:0]  lsu_in_data_rd_o
    ,output          lsu_in_accept_o
    ,output          lsu_in_ack_o
    ,output          lsu_in_error_o
    ,output [ 10:0]  lsu_in_resp_tag_o
    ,output [ 31:0]  lsu_out_addr_o
    ,output [ 31:0]  lsu_out_data_wr_o
    ,output          lsu_out_rd_o
    ,output [  3:0]  lsu_out_wr_o
    ,output          lsu_out_cacheable_o
    ,output [ 10:0]  lsu_out_req_tag_o
    ,output          lsu_out_invalidate_o
    ,output          lsu_out_writeback_o
    ,output          lsu_out_flush_o
    ,output          lsu_in_load_fault_o
    ,output          lsu_in_store_fault_o
);



//-----------------------------------------------------------------
// Includes
//-----------------------------------------------------------------
`include "riscv_defs.v"

//-----------------------------------------------------------------
// Local defs
//-----------------------------------------------------------------
localparam  STATE_W            = 2;
localparam  STATE_IDLE         = 0;
localparam  STATE_LEVEL_FIRST  = 1;
localparam  STATE_LEVEL_SECOND = 2;
localparam  STATE_UPDATE       = 3;

//-----------------------------------------------------------------
// Basic MMU support
//-----------------------------------------------------------------
generate
if (SUPPORT_MMU)
begin
end
//-----------------------------------------------------------------
// No MMU support
//-----------------------------------------------------------------
else
begin
    assign fetch_out_rd_o         = fetch_in_rd_i;
    assign fetch_out_pc_o         = fetch_in_pc_i;
    assign fetch_out_flush_o      = fetch_in_flush_i;
    assign fetch_out_invalidate_o = fetch_in_invalidate_i;
    assign fetch_in_accept_o      = fetch_out_accept_i;
    assign fetch_in_valid_o       = fetch_out_valid_i;
    assign fetch_in_error_o       = fetch_out_error_i;
    assign fetch_in_fault_o       = 1'b0;
    assign fetch_in_inst_o        = fetch_out_inst_i;

    assign lsu_out_rd_o           = lsu_in_rd_i;
    assign lsu_out_wr_o           = lsu_in_wr_i;
    assign lsu_out_addr_o         = lsu_in_addr_i;
    assign lsu_out_data_wr_o      = lsu_in_data_wr_i;
    assign lsu_out_invalidate_o   = lsu_in_invalidate_i;
    assign lsu_out_writeback_o    = lsu_in_writeback_i;
    assign lsu_out_cacheable_o    = lsu_in_cacheable_i;
    assign lsu_out_req_tag_o      = lsu_in_req_tag_i;
    assign lsu_out_flush_o        = lsu_in_flush_i;
    
    assign lsu_in_ack_o           = lsu_out_ack_i;
    assign lsu_in_resp_tag_o      = lsu_out_resp_tag_i;
    assign lsu_in_error_o         = lsu_out_error_i;
    assign lsu_in_data_rd_o       = lsu_out_data_rd_i;
    assign lsu_in_store_fault_o   = 1'b0;
    assign lsu_in_load_fault_o    = 1'b0;

    assign lsu_in_accept_o        = lsu_out_accept_i;
end
endgenerate

endmodule
