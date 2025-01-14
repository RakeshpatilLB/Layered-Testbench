`timescale 1ns / 1ps

program test(intf vif);

    environment env;

    initial begin
        env = new(vif);
        env.gen.repeat_count = 1000;
        env.run();
    end

endprogram
