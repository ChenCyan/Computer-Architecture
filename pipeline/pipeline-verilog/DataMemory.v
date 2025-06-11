`timescale 1ns/1ps
module DataMemory(
    input clk,
    input reset,
    input mem_read_enable,
    input mem_write_enable,
    input [31:0] address,         // 字地址（byte 地址的高位）
    input [31:0] write_data,      // 要写入的数据
    output reg [31:0] data        // 读出的数据
);

    reg [31:0] memory [0:7]; // 8 words of 32 bits

    // 初始化 memory 内容
    initial begin
        #50 memory[0] = 32'h00000000;
        memory[1] = 32'h00000001;
        memory[2] = 32'h00000002;
        memory[3] = 32'h00000003;
        memory[4] = 32'h00000004;
        memory[5] = 32'h00000005;
        memory[6] = 32'h00000006;
        memory[7] = 32'h00000007;
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            data <= 32'b0;
        end else begin
            if (mem_write_enable) begin
                memory[address[4:2]] <= write_data; // 写入（地址对齐，按字寻址）
                data <= 32'b0;
            end
            if (mem_read_enable) begin
                data <= memory[address[4:2]]; // 读取

            end
            if (!mem_read_enable && !mem_write_enable)begin
            data <= 32'b0;
        end
        end
    end

endmodule
