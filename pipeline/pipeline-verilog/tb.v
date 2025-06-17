`timescale 1ns/1ps
module testbench();
    reg clk, reset;
    PipelinedCPU cpu0(.clk(clk), .reset(reset));

    initial begin
        // 指定波形文件名
        $dumpfile("wave.vcd");
        // 记录整个模块层次的所有信号
        $dumpvars(0, testbench);

        clk = 0; 
        #10 reset = 1;
        #20 reset = 0;
        #1000 $finish; // 模拟时间结束
    end

    always #5 clk = ~clk; // 10ns一个时钟周期
endmodule
