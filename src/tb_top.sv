`timescale 1ns / 1ps

`include "transaction.sv"
`include "generator.sv"
`include "intf.sv"
`include "driver.sv"
`include "environment.sv"
`include "test.sv"
`include "chacha_qr.v"



module tb_top;

bit clk;
bit reset;
logic [31:0]a_pr,b_pr,c_pr,d_pr;
intf vif(clk,reset);
test t1(vif);
chacha_qr dut(.clk(vif.clk),
        .reset(vif.reset),
        .a(vif.a),
        .b(vif.b),
        .c(vif.c),
        .d(vif.d),
        .a_prim(vif.a_prim),
        .b_prim(vif.b_prim),
        .c_prim(vif.c_prim),
        .d_prim(vif.d_prim)
       
       );

always #5 clk = ~clk;
assign a_pr=vif.a_prim;
assign b_pr=vif.b_prim;
assign c_pr=vif.c_prim;
assign d_pr=vif.d_prim;

initial begin
  reset = 1;

  #5 reset = 0;

end



assum1: assume property (@(posedge clk) $stable(clk));
assum2: assume property (@(posedge clk) reset |-> ##1 !reset);


intl_res:assert property (@(posedge clk) reset |-> ##1 (dut.internal_a_prim == 0 && dut.internal_b_prim == 0 && dut.internal_c_prim == 0 && dut.internal_d_prim == 0))
          else $fatal("Assertion failed: Outputs not zeroed on reset");

no_ch:assert property (@(posedge clk) !reset && (vif.a == $past(vif.a)) && (vif.b == $past(vif.b)) && (vif.c == $past(vif.c)) && (vif.d == $past(vif.d)) |->  ##1 (vif.a_prim == $past(vif.a_prim) && vif.b_prim == $past(vif.b_prim) && vif.c_prim == $past(vif.c_prim) && vif.d_prim == $past(vif.d_prim)))
     else $fatal("Assertion failed: Outputs changed when inputs are stable");

stb:assert property(@(posedge clk) !reset && (vif.a != $past(vif.a)) && (vif.b != $past(vif.b)) && (vif.c != $past(vif.c)) && (vif.d != $past(vif.d)) |-> ##1 (vif.a_prim != $past(vif.a_prim) && vif.b_prim != $past(vif.b_prim) && vif.c_prim != $past(vif.c_prim) && vif.d_prim != $past(vif.d_prim)))
    else $fatal("Assertion failed: Outputs didnt change when inputs changed");

prop: assert property (@(posedge clk) reset |-> ##1 (a_pr==0 && b_pr==0 && c_pr==0 && d_pr==0 ));

 


endmodule
