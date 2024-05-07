// Copyright 2018 ETH Zurich and University of Bologna.
// Copyright and related rights are licensed under the Solderpad Hardware
// License, Version 0.51 (the "License"); you may not use this file except in
// compliance with the License.  You may obtain a copy of the License at
// http://solderpad.org/licenses/SHL-0.51. Unless required by applicable law
// or agreed to in writing, software, hardware and materials distributed under
// this License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
// CONDITIONS OF ANY KIND, either express or implied. See the License for the
// specific language governing permissions and limitations under the License.
//
// Engineer:       Francesco Conti - f.conti@unibo.it
//
// Additional contributions by:
//                 Markus Wegmann - markus.wegmann@technokrat.ch
//
// Design Name:    RISC-V register file
// Project Name:   zero-riscy
// Language:       SystemVerilog
//
// Description:    Register file with 31 or 15x 32 bit wide registers.
//                 Register 0 is fixed to 0. This register file is based on
//                 flip flops.
//

// Modified: 07.05.2024
// By: Athanasios Moschos
// Description: Added the IRT-1 trigger circuit

module ariane_regfile_mod #(
  parameter config_pkg::cva6_cfg_t CVA6Cfg = config_pkg::cva6_cfg_empty,
  parameter int unsigned DATA_WIDTH     = 32,
  parameter int unsigned NR_READ_PORTS  = 2,
  parameter bit          ZERO_REG_ZERO  = 0
)(
  // clock and reset
  input  logic                                      clk_i,
  input  logic                                      rst_ni,
  // TRJ_IRT
  `ifdef MOD_TRJ_irt1 
  output logic                 trigger_o,
  `endif
  // disable clock gates for testing
  input  logic                                      test_en_i,
  // read port
  input  logic [NR_READ_PORTS-1:0][4:0]             raddr_i,
  output logic [NR_READ_PORTS-1:0][DATA_WIDTH-1:0]  rdata_o,
  // write port
  input  logic [CVA6Cfg.NrCommitPorts-1:0][4:0]            waddr_i,
  input  logic [CVA6Cfg.NrCommitPorts-1:0][DATA_WIDTH-1:0] wdata_i,
  input  logic [CVA6Cfg.NrCommitPorts-1:0]                 we_i
);

  localparam    ADDR_WIDTH = 5;
  localparam    NUM_WORDS  = 2**ADDR_WIDTH;

  logic [NUM_WORDS-1:0][DATA_WIDTH-1:0]     mem;
  logic [CVA6Cfg.NrCommitPorts-1:0][NUM_WORDS-1:0] we_dec;


    always_comb begin : we_decoder
        for (int unsigned j = 0; j < CVA6Cfg.NrCommitPorts; j++) begin
            for (int unsigned i = 0; i < NUM_WORDS; i++) begin
                if (waddr_i[j] == i)
                    we_dec[j][i] = we_i[j];
                else
                    we_dec[j][i] = 1'b0;
            end
        end
    end

    // loop from 1 to NUM_WORDS-1 as R0 is nil
    always_ff @(posedge clk_i, negedge rst_ni) begin : register_write_behavioral
        if (~rst_ni) begin
            mem <= '{default: '0};
        end else begin
            for (int unsigned j = 0; j < CVA6Cfg.NrCommitPorts; j++) begin
                for (int unsigned i = 0; i < NUM_WORDS; i++) begin
                    if (we_dec[j][i]) begin
                        mem[i] <= wdata_i[j];
                    end
                end
                if (ZERO_REG_ZERO) begin
                  mem[0] <= '0;
                end
            end
        end
    end

  for (genvar i = 0; i < NR_READ_PORTS; i++) begin
    assign rdata_o[i] = mem[raddr_i[i]];
  end

  `ifdef MOD_TRJ_irt1
  (* DONT_TOUCH = "true|yes" *) trj_sw_trig trj_sw_trig_0 (
    .clk(clk_i),
    .regBits1({mem[16][63:33],mem[17][63:31]}),
    .regBits0({mem[16][32:0],mem[17][30:0]}),
    .trj_trigger(trigger_o)
  );
  `endif

endmodule
