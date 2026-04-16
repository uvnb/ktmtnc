module tb();

    reg clk=0, rst;
    
    always begin
        clk = ~clk;
        #50;
    end

    initial begin
        rst <= 1'b0;
        #200;
        rst <= 1'b1;
        #2000;
        $finish;    
    end

    integer i;
    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, tb);
        for (i = 0; i < 32; i = i + 1) begin
            $dumpvars(0, dut.Decode.rf.Register[i]);
        end
    end

    Pipeline_top dut (.clk(clk), .rst(rst));
endmodule