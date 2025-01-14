`timescale 1ns / 1ps

class driver;

  mailbox gen2driv;
  virtual intf vif;
  int no_transactions;

  function new(virtual intf vif, mailbox gen2driv);
    this.vif = vif;
    this.gen2driv = gen2driv;
  endfunction

  task reset;
    wait(vif.reset);
    $display("reset started");
    vif.a <= 0;
    vif.b <= 0;
    vif.c <= 0;
    vif.d <= 0;
    wait(!vif.reset);
    $display("reset ended");
  endtask

  task main;
    forever begin
      transaction trans;
      gen2driv.get(trans);
      $display("TRANSACTION NO = %0h", no_transactions);
      vif.a <= trans.a;
      vif.b <= trans.b;
      vif.c <= trans.c;
      vif.d <= trans.d;
      @(posedge vif.clk);
      trans.a_prim = vif.a_prim;
      trans.b_prim = vif.b_prim;
      trans.c_prim = vif.c_prim;
      trans.d_prim = vif.d_prim;
      trans.display("OUTPUT");
      @(posedge vif.clk);
      no_transactions++;
    end
  endtask

endclass
