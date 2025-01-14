`timescale 1ns / 1ps

class transaction;

  rand bit [31:0] a;
  rand bit [31:0] b;
  rand bit [31:0] c;
  rand bit [31:0] d;
  bit [31:0] a_prim;
  bit [31:0] b_prim;
  bit [31:0] c_prim;
  bit [31:0] d_prim;
 
  function void display(string name);
    $display("------------------------------------------------");
    $display("\t a = %0h, \t b = %0h, \t c = %0h, \t d = %0h", a, b, c, d);
    $display("\t a_prim = %0h, \t b_prim = %0h, \t c_prim = %0h, \t d_prim = %0h", a_prim, b_prim, c_prim, d_prim );
    $display("------------------------------------------------");
  endfunction

endclass
