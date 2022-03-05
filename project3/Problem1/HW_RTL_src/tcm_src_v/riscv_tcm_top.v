//-----------------------------------------------------------------
//                         RISC-V Top
//                            V0.6
//                     Ultra-Embedded.com
//                     Copyright 2014-2019
//
//                   admin@ultra-embedded.com
//
//                       License: BSD
//-----------------------------------------------------------------
//
// Copyright (c) 2014, Ultra-Embedded.com
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

//-----------------------------------------------------------------
//                          Generated File
//-----------------------------------------------------------------
module riscv_tcm_top
//-----------------------------------------------------------------
// Params
//-----------------------------------------------------------------
#(
     parameter BOOT_VECTOR      = 32'h00000000
    //  parameter BOOT_VECTOR      = 32'h00002000
    ,parameter CORE_ID          = 0
    ,parameter TCM_MEM_BASE     = 32'h00010000
    // ,parameter TCM_MEM_BASE     = 32'h00000100
    ,parameter MEM_CACHE_ADDR_MIN = 0
    ,parameter MEM_CACHE_ADDR_MAX = 32'hffffffff
)
//-----------------------------------------------------------------
// Ports
//-----------------------------------------------------------------
(
    // Inputs
     input           clk_i
    ,input           rst_i
    ,input           rst_cpu_i
    ,input           axi_i_awready_i
    ,input           axi_i_wready_i
    ,input           axi_i_bvalid_i
    ,input  [  1:0]  axi_i_bresp_i
    ,input           axi_i_arready_i
    ,input           axi_i_rvalid_i
    ,input  [ 31:0]  axi_i_rdata_i
    ,input  [  1:0]  axi_i_rresp_i
    ,input           axi_t_awvalid_i
    ,input  [ 31:0]  axi_t_awaddr_i
    ,input  [  3:0]  axi_t_awid_i
    ,input  [  7:0]  axi_t_awlen_i
    ,input  [  1:0]  axi_t_awburst_i
    ,input           axi_t_wvalid_i
    ,input  [ 31:0]  axi_t_wdata_i
    ,input  [  3:0]  axi_t_wstrb_i
    ,input           axi_t_wlast_i
    ,input           axi_t_bready_i
    ,input           axi_t_arvalid_i
    ,input  [ 31:0]  axi_t_araddr_i
    ,input  [  3:0]  axi_t_arid_i
    ,input  [  7:0]  axi_t_arlen_i
    ,input  [  1:0]  axi_t_arburst_i
    ,input           axi_t_rready_i
    ,input  [ 31:0]  intr_i

    // Outputs
    ,output          axi_i_awvalid_o
    ,output [ 31:0]  axi_i_awaddr_o
    ,output          axi_i_wvalid_o
    ,output [ 31:0]  axi_i_wdata_o
    ,output [  3:0]  axi_i_wstrb_o
    ,output          axi_i_bready_o
    ,output          axi_i_arvalid_o
    ,output [ 31:0]  axi_i_araddr_o
    ,output          axi_i_rready_o
    ,output          axi_t_awready_o
    ,output          axi_t_wready_o
    ,output          axi_t_bvalid_o
    ,output [  1:0]  axi_t_bresp_o
    ,output [  3:0]  axi_t_bid_o
    ,output          axi_t_arready_o
    ,output          axi_t_rvalid_o
    ,output [ 31:0]  axi_t_rdata_o
    ,output [  1:0]  axi_t_rresp_o
    ,output [  3:0]  axi_t_rid_o
    ,output          axi_t_rlast_o

    // instruction write
    ,input  [  3:0]  tb_inst_we_i
    ,input  [ 31:0]  tb_inst_addr_i
    ,input  [ 31:0]  tb_inst_data_i

);

// wires

wire  [ 31:0]  ifetch_pc_w                  ;
wire  [ 31:0]  dport_tcm_data_rd_w          ;
wire           dport_tcm_cacheable_w        ;
wire           dport_flush_w                ;
wire  [  3:0]  dport_tcm_wr_w               ;
wire           ifetch_rd_w                  ;
wire           dport_axi_accept_w           ;
wire           dport_cacheable_w            ;
wire           dport_tcm_flush_w            ;
wire  [ 10:0]  dport_resp_tag_w             ;
wire  [ 10:0]  dport_axi_resp_tag_w         ;
wire           ifetch_accept_w              ;
wire  [ 31:0]  dport_data_rd_w              ;
wire           dport_tcm_invalidate_w       ;
wire           dport_ack_w                  ;
wire  [ 10:0]  dport_axi_req_tag_w          ;
wire  [ 31:0]  dport_data_wr_w              ;
wire           dport_invalidate_w           ;
wire  [ 10:0]  dport_tcm_req_tag_w          ;
wire  [ 31:0]  dport_tcm_addr_w             ;
wire           dport_axi_error_w            ;
wire           dport_tcm_ack_w              ;
wire           dport_tcm_rd_w               ;
wire  [ 10:0]  dport_tcm_resp_tag_w         ;
wire           dport_writeback_w            ;
wire  [ 31:0]  cpu_id_w = CORE_ID           ;
wire           dport_rd_w                   ;
wire           dport_axi_ack_w              ;
wire           dport_axi_rd_w               ;
wire  [ 31:0]  dport_axi_data_rd_w          ;
wire           dport_axi_invalidate_w       ;
wire  [ 31:0]  boot_vector_w = BOOT_VECTOR  ;
wire  [ 31:0]  dport_addr_w                 ;
wire           ifetch_error_w               ;
wire  [ 31:0]  dport_tcm_data_wr_w          ;
wire           ifetch_flush_w               ;
wire  [ 31:0]  dport_axi_addr_w             ;
wire           dport_error_w                ;
wire           dport_tcm_accept_w           ;
wire           ifetch_invalidate_w          ;
wire           dport_axi_writeback_w        ;
wire  [  3:0]  dport_wr_w                   ;
wire           ifetch_valid_w               ;
wire  [ 31:0]  dport_axi_data_wr_w          ;
wire  [ 10:0]  dport_req_tag_w              ;
wire  [ 31:0]  ifetch_inst_w                ;
wire           dport_axi_cacheable_w        ;
wire           dport_tcm_writeback_w        ;
wire  [  3:0]  dport_axi_wr_w               ;
wire           dport_axi_flush_w            ;
wire           dport_tcm_error_w            ;
wire           dport_accept_w               ;



wire           icache_valid_w               ;
wire           icache_flush_w               ;
wire           dcache_flush_w               ;
wire           dcache_invalidate_w          ;
wire           dcache_ack_w                 ;
wire  [ 10:0]  dcache_resp_tag_w            ;
wire  [ 31:0]  icache_inst_w                ;

wire           dcache_rd_w                  ;
wire  [ 31:0]  dcache_addr_w                ;
wire           dcache_accept_w              ;
wire           icache_invalidate_w          ;
wire           dcache_writeback_w           ;
wire  [ 10:0]  dcache_req_tag_w             ;
wire           dcache_cacheable_w           ;
wire           icache_error_w               ;
wire  [ 31:0]  dcache_data_rd_w             ;
wire           icache_accept_w              ;
wire  [  3:0]  dcache_wr_w                  ;
wire  [ 31:0]  icache_pc_w                  ;
wire           icache_rd_w                  ;
wire           dcache_error_w               ;
wire  [ 31:0]  dcache_data_wr_w             ;




//AXI in (inst cache)
wire           AXI_ic_awready     ;
wire           AXI_ic_wready      ;
wire           AXI_ic_bvalid      ;
wire  [  1:0]  AXI_ic_bresp       ;
wire  [  3:0]  AXI_ic_bid         ;
wire           AXI_ic_arready     ;
wire           AXI_ic_rvalid      ;
wire  [ 31:0]  AXI_ic_rdata       ;
wire  [  1:0]  AXI_ic_rresp       ;  
wire  [  3:0]  AXI_ic_rid         ;
wire           AXI_ic_rlast       ;

//AXI out (inst cache)
wire          AXI_ic_awvalid     ;
wire [ 31:0]  AXI_ic_awaddr      ;
wire [  3:0]  AXI_ic_awid        ;
wire [  7:0]  AXI_ic_awlen       ;
wire [  1:0]  AXI_ic_awburst     ;
wire          AXI_ic_wvalid      ;
wire [ 31:0]  AXI_ic_wdata       ;
wire [  3:0]  AXI_ic_wstrb       ;
wire          AXI_ic_wlast       ;
wire          AXI_ic_bready      ;
wire          AXI_ic_arvalid     ;
wire [ 31:0]  AXI_ic_araddr      ;
wire [  3:0]  AXI_ic_arid        ;
wire [  7:0]  AXI_ic_arlen       ;
wire [  1:0]  AXI_ic_arburst     ;
wire          AXI_ic_rready      ;

//AXI in (data cache)
wire           AXI_dc_awready     ;
wire           AXI_dc_wready      ;
wire           AXI_dc_bvalid      ;
wire  [  1:0]  AXI_dc_bresp       ;
wire  [  3:0]  AXI_dc_bid         ;
wire           AXI_dc_arready     ;
wire           AXI_dc_rvalid      ;
wire  [ 31:0]  AXI_dc_rdata       ;
wire  [  1:0]  AXI_dc_rresp       ;  
wire  [  3:0]  AXI_dc_rid         ;
wire           AXI_dc_rlast       ;

//AXI out (data cache)
wire          AXI_dc_awvalid     ;
wire [ 31:0]  AXI_dc_awaddr      ;
wire [  3:0]  AXI_dc_awid        ;
wire [  7:0]  AXI_dc_awlen       ;
wire [  1:0]  AXI_dc_awburst     ;
wire          AXI_dc_wvalid      ;
wire [ 31:0]  AXI_dc_wdata       ;
wire [  3:0]  AXI_dc_wstrb       ;
wire          AXI_dc_wlast       ;
wire          AXI_dc_bready      ;
wire          AXI_dc_arvalid     ;
wire [ 31:0]  AXI_dc_araddr      ;
wire [  3:0]  AXI_dc_arid        ;
wire [  7:0]  AXI_dc_arlen       ;
wire [  1:0]  AXI_dc_arburst     ;
wire          AXI_dc_rready      ;


riscv_core
#(
     .MEM_CACHE_ADDR_MIN(MEM_CACHE_ADDR_MIN)
    ,.MEM_CACHE_ADDR_MAX(MEM_CACHE_ADDR_MAX)
)
u_core
(
    // Inputs
     .clk_i                 (clk_i                  )
    ,.rst_i                 (rst_cpu_i              )
    // ,.rst_i                 (rst_i                  )
    ,.mem_d_data_rd_i       (dport_data_rd_w        )
    ,.mem_d_accept_i        (dport_accept_w         )
    ,.mem_d_ack_i           (dport_ack_w            )
    ,.mem_d_error_i         (dport_error_w          )
    ,.mem_d_resp_tag_i      (dport_resp_tag_w       )
    ,.mem_i_accept_i        (icache_accept_w        )
    ,.mem_i_valid_i         (icache_valid_w         )
    ,.mem_i_error_i         (icache_error_w         )
    ,.mem_i_inst_i          (icache_inst_w          )
    ,.intr_i                (intr_i                 )
    ,.reset_vector_i        (boot_vector_w          )
    ,.cpu_id_i              (cpu_id_w               )

    // Outputs
    ,.mem_d_addr_o          (dport_addr_w           )
    ,.mem_d_data_wr_o       (dport_data_wr_w        )
    ,.mem_d_rd_o            (dport_rd_w             )
    ,.mem_d_wr_o            (dport_wr_w             )
    ,.mem_d_cacheable_o     (dport_cacheable_w      )
    ,.mem_d_req_tag_o       (dport_req_tag_w        )
    ,.mem_d_invalidate_o    (dport_invalidate_w     )
    ,.mem_d_writeback_o     (dport_writeback_w      )
    ,.mem_d_flush_o         (dport_flush_w          )
    ,.mem_i_rd_o            (icache_rd_w            )
    ,.mem_i_flush_o         (icache_flush_w         )
    ,.mem_i_invalidate_o    (icache_invalidate_w    )
    ,.mem_i_pc_o            (icache_pc_w            )
);



dport_mux
#(
     .TCM_MEM_BASE(TCM_MEM_BASE)
)
u_dmux
(
    // Inputs
     .clk_i                 (clk_i                  )
    ,.rst_i                 (rst_i                  )
    ,.mem_addr_i            (dport_addr_w           )
    ,.mem_data_wr_i         (dport_data_wr_w        )
    ,.mem_rd_i              (dport_rd_w             )
    ,.mem_wr_i              (dport_wr_w             )
    ,.mem_cacheable_i       (dport_cacheable_w      )
    ,.mem_req_tag_i         (dport_req_tag_w        )
    ,.mem_invalidate_i      (dport_invalidate_w     )
    ,.mem_writeback_i       (dport_writeback_w      )
    ,.mem_flush_i           (dport_flush_w          )

    ,.mem_tcm_data_rd_i     (dcache_data_rd_w       )
    ,.mem_tcm_accept_i      (dcache_accept_w        )
    ,.mem_tcm_ack_i         (dcache_ack_w           )
    ,.mem_tcm_error_i       (dcache_error_w         )
    ,.mem_tcm_resp_tag_i    (dcache_resp_tag_w      )

     ,.mem_ext_data_rd_i     (dport_axi_data_rd_w    )
     ,.mem_ext_accept_i      (dport_axi_accept_w     )
     ,.mem_ext_ack_i         (dport_axi_ack_w        )
     ,.mem_ext_error_i       (dport_axi_error_w      )
     ,.mem_ext_resp_tag_i    (dport_axi_resp_tag_w   )

    // Outputs
    ,.mem_data_rd_o         (dport_data_rd_w        )
    ,.mem_accept_o          (dport_accept_w         )
    ,.mem_ack_o             (dport_ack_w            )
    ,.mem_error_o           (dport_error_w          )
    ,.mem_resp_tag_o        (dport_resp_tag_w       )

    ,.mem_tcm_addr_o        (dcache_addr_w          )
    ,.mem_tcm_data_wr_o     (dcache_data_wr_w       )
    ,.mem_tcm_rd_o          (dcache_rd_w            )
    ,.mem_tcm_wr_o          (dcache_wr_w            )
    ,.mem_tcm_cacheable_o   (dcache_cacheable_w     )
    ,.mem_tcm_req_tag_o     (dcache_req_tag_w       )
    ,.mem_tcm_invalidate_o  (dcache_invalidate_w    )
    ,.mem_tcm_writeback_o   (dcache_writeback_w     )
    ,.mem_tcm_flush_o       (dcache_flush_w         )

     ,.mem_ext_addr_o        (dport_axi_addr_w       )
     ,.mem_ext_data_wr_o     (dport_axi_data_wr_w    )
     ,.mem_ext_rd_o          (dport_axi_rd_w         )
     ,.mem_ext_wr_o          (dport_axi_wr_w         )
     ,.mem_ext_cacheable_o   (dport_axi_cacheable_w  )
     ,.mem_ext_req_tag_o     (dport_axi_req_tag_w    )
     ,.mem_ext_invalidate_o  (dport_axi_invalidate_w )
     ,.mem_ext_writeback_o   (dport_axi_writeback_w  )
     ,.mem_ext_flush_o       (dport_axi_flush_w      )
);

dcache
u_dcache
(
    // Inputs
     .clk_i                 (clk_i                  )
    ,.rst_i                 (rst_i                  )

    ,.mem_addr_i            (dcache_addr_w          )
    ,.mem_data_wr_i         (dcache_data_wr_w       )
    ,.mem_rd_i              (dcache_rd_w            )
    ,.mem_wr_i              (dcache_wr_w            )
    ,.mem_cacheable_i       (dcache_cacheable_w     )
    ,.mem_req_tag_i         (dcache_req_tag_w       )
    ,.mem_invalidate_i      (dcache_invalidate_w    )
    ,.mem_writeback_i       (dcache_writeback_w     )
    ,.mem_flush_i           (dcache_flush_w         )

    
    // AXI INPUT
    ,.axi_awready_i         (AXI_dc_awready         )
    ,.axi_wready_i          (AXI_dc_wready          )
    ,.axi_bvalid_i          (AXI_dc_bvalid          )
    ,.axi_bresp_i           (AXI_dc_bresp           )
    ,.axi_bid_i             (AXI_dc_bid             )
    ,.axi_arready_i         (AXI_dc_arready         )
    ,.axi_rvalid_i          (AXI_dc_rvalid          )
    ,.axi_rdata_i           (AXI_dc_rdata           )
    ,.axi_rresp_i           (AXI_dc_rresp           )
    ,.axi_rid_i             (AXI_dc_rid             )
    ,.axi_rlast_i           (AXI_dc_rlast           )



    // Outputs
    ,.mem_data_rd_o         (dcache_data_rd_w       )
    ,.mem_accept_o          (dcache_accept_w        )
    ,.mem_ack_o             (dcache_ack_w           )
    ,.mem_error_o           (dcache_error_w         )
    ,.mem_resp_tag_o        (dcache_resp_tag_w      )

    // AXI OUTPUT
    ,.axi_awvalid_o         (AXI_dc_awvalid         )
    ,.axi_awaddr_o          (AXI_dc_awaddr          )
    ,.axi_awid_o            (AXI_dc_awid            )
    ,.axi_awlen_o           (AXI_dc_awlen           )
    ,.axi_awburst_o         (AXI_dc_awburst         )
    ,.axi_wvalid_o          (AXI_dc_wvalid          )
    ,.axi_wdata_o           (AXI_dc_wdata           )
    ,.axi_wstrb_o           (AXI_dc_wstrb           )
    ,.axi_wlast_o           (AXI_dc_wlast           )
    ,.axi_bready_o          (AXI_dc_bready          )
    ,.axi_arvalid_o         (AXI_dc_arvalid         )
    ,.axi_araddr_o          (AXI_dc_araddr          )
    ,.axi_arid_o            (AXI_dc_arid            )
    ,.axi_arlen_o           (AXI_dc_arlen           )
    ,.axi_arburst_o         (AXI_dc_arburst         )
    ,.axi_rready_o          (AXI_dc_rready          )
);


icache
u_icache
(
    // Inputs
     .clk_i                 (clk_i                  )
    ,.rst_i                 (rst_i                  )
    ,.req_rd_i              (icache_rd_w            )
    ,.req_flush_i           (icache_flush_w         )
    ,.req_invalidate_i      (icache_invalidate_w    )
    ,.req_pc_i              (icache_pc_w            )


    // AXI INPUT
    ,.axi_awready_i         (AXI_ic_awready         )
    ,.axi_wready_i          (AXI_ic_wready          )
    ,.axi_bvalid_i          (AXI_ic_bvalid          )
    ,.axi_bresp_i           (AXI_ic_bresp           )
    ,.axi_bid_i             (AXI_ic_bid             )
    ,.axi_arready_i         (AXI_ic_arready         )
    ,.axi_rvalid_i          (AXI_ic_rvalid          )
    ,.axi_rdata_i           (AXI_ic_rdata           )
    ,.axi_rresp_i           (AXI_ic_rresp           )
    ,.axi_rid_i             (AXI_ic_rid             )
    ,.axi_rlast_i           (AXI_ic_rlast           )


    // Outputs
    ,.req_accept_o          (icache_accept_w        )
    ,.req_valid_o           (icache_valid_w         )
    ,.req_error_o           (icache_error_w         )
    ,.req_inst_o            (icache_inst_w          )

    // AXI OUTPUT
    ,.axi_awvalid_o         (AXI_ic_awvalid         )
    ,.axi_awaddr_o          (AXI_ic_awaddr          )
    ,.axi_awid_o            (AXI_ic_awid            )
    ,.axi_awlen_o           (AXI_ic_awlen           )
    ,.axi_awburst_o         (AXI_ic_awburst         )
    ,.axi_wvalid_o          (AXI_ic_wvalid          )
    ,.axi_wdata_o           (AXI_ic_wdata           )
    ,.axi_wstrb_o           (AXI_ic_wstrb           )
    ,.axi_wlast_o           (AXI_ic_wlast           )
    ,.axi_bready_o          (AXI_ic_bready          )
    ,.axi_arvalid_o         (AXI_ic_arvalid         )
    ,.axi_araddr_o          (AXI_ic_araddr          )
    ,.axi_arid_o            (AXI_ic_arid            )
    ,.axi_arlen_o           (AXI_ic_arlen           )
    ,.axi_arburst_o         (AXI_ic_arburst         )
    ,.axi_rready_o          (AXI_ic_rready          )
);




tcm_mem
u_tcm_i
(
    // Inputs
     .clk_i             (clk_i               )
    ,.rst_i             (rst_i               )


    // AXI INTERFACE INPUT
    ,.axi_awvalid_i     (AXI_ic_awvalid      )
    ,.axi_awaddr_i      (AXI_ic_awaddr       )
    ,.axi_awid_i        (AXI_ic_awid         )
    ,.axi_awlen_i       (AXI_ic_awlen        )
    ,.axi_awburst_i     (AXI_ic_awburst      )
    ,.axi_wvalid_i      (AXI_ic_wvalid       )
    ,.axi_wdata_i       (AXI_ic_wdata        )
    ,.axi_wstrb_i       (AXI_ic_wstrb        )
    ,.axi_wlast_i       (AXI_ic_wlast        )
    ,.axi_bready_i      (AXI_ic_bready       )
    ,.axi_arvalid_i     (AXI_ic_arvalid      )
    ,.axi_araddr_i      (AXI_ic_araddr       )
    ,.axi_arid_i        (AXI_ic_arid         )
    ,.axi_arlen_i       (AXI_ic_arlen        )
    ,.axi_arburst_i     (AXI_ic_arburst      )
    ,.axi_rready_i      (AXI_ic_rready       )



    // AXI INTERFACE OUTPUT
    ,.axi_awready_o     (AXI_ic_awready      )
    ,.axi_wready_o      (AXI_ic_wready       )
    ,.axi_bvalid_o      (AXI_ic_bvalid       )
    ,.axi_bresp_o       (AXI_ic_bresp        )
    ,.axi_bid_o         (AXI_ic_bid          )
    ,.axi_arready_o     (AXI_ic_arready      )
    ,.axi_rvalid_o      (AXI_ic_rvalid       )
    ,.axi_rdata_o       (AXI_ic_rdata        )
    ,.axi_rresp_o       (AXI_ic_rresp        )
    ,.axi_rid_o         (AXI_ic_rid          )
    ,.axi_rlast_o       (AXI_ic_rlast        )


    // instruction write
    ,.tb_inst_we_i    (tb_inst_we_i    )
    ,.tb_inst_addr_i  (tb_inst_addr_i  )
    ,.tb_inst_data_i  (tb_inst_data_i  )    
);

tcm_mem
u_tcm_d
(
    // Inputs
     .clk_i(clk_i)
    ,.rst_i(rst_i)

    // AXI INTERFACE INPUT
    ,.axi_awvalid_i     (AXI_dc_awvalid      )
    ,.axi_awaddr_i      (AXI_dc_awaddr       )
    ,.axi_awid_i        (AXI_dc_awid         )
    ,.axi_awlen_i       (AXI_dc_awlen        )
    ,.axi_awburst_i     (AXI_dc_awburst      )
    ,.axi_wvalid_i      (AXI_dc_wvalid       )
    ,.axi_wdata_i       (AXI_dc_wdata        )
    ,.axi_wstrb_i       (AXI_dc_wstrb        )
    ,.axi_wlast_i       (AXI_dc_wlast        )
    ,.axi_bready_i      (AXI_dc_bready       )
    ,.axi_arvalid_i     (AXI_dc_arvalid      )
    ,.axi_araddr_i      (AXI_dc_araddr       )
    ,.axi_arid_i        (AXI_dc_arid         )
    ,.axi_arlen_i       (AXI_dc_arlen        )
    ,.axi_arburst_i     (AXI_dc_arburst      )
    ,.axi_rready_i      (AXI_dc_rready       )

    // AXI INTERFACE OUTPUT
    ,.axi_awready_o     (AXI_dc_awready      )
    ,.axi_wready_o      (AXI_dc_wready       )
    ,.axi_bvalid_o      (AXI_dc_bvalid       )
    ,.axi_bresp_o       (AXI_dc_bresp        )
    ,.axi_bid_o         (AXI_dc_bid          )
    ,.axi_arready_o     (AXI_dc_arready      )
    ,.axi_rvalid_o      (AXI_dc_rvalid       )
    ,.axi_rdata_o       (AXI_dc_rdata        )
    ,.axi_rresp_o       (AXI_dc_rresp        )
    ,.axi_rid_o         (AXI_dc_rid          )
    ,.axi_rlast_o       (AXI_dc_rlast        )


    // instruction write
    ,.tb_inst_we_i    (tb_inst_we_i    )
    ,.tb_inst_addr_i  (tb_inst_addr_i  )
    ,.tb_inst_data_i  (tb_inst_data_i  )    
);





endmodule
