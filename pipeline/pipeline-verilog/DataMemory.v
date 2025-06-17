`timescale 1ns/1ps
module DataMemory(
    input clk,                  // 时钟（仅用于复位同步）
    input reset,                // 异步复位
    input mem_read_enable,      // 异步读使能
    input mem_write_enable,     // 异步写使能
    input [31:0] address,       // 字地址（直接索引，0-7）
    input [31:0] write_data,    // 写入数据
    output reg [31:0] data      // 读出数据
);

    reg [31:0] memory [0:7];    // 8x32-bit 存储器

    // 存储器初始化
    initial begin
        memory[0] = 32'h04030201;
        memory[1] = 32'h08070605;
        memory[2] = 32'h03030003;
        memory[3] = 32'h00000004;
        memory[4] = 32'h00000005;
        memory[5] = 32'h00000005;
        memory[6] = 32'h00000006;
        memory[7] = 32'h00000007;
    end

    // 异步写逻辑（无时钟依赖）
    always @(mem_write_enable or write_data or address) begin
        if (mem_write_enable) begin
            memory[address] <= write_data;
        end
    end

    // 异步读逻辑（无时钟依赖）
    always @(mem_read_enable or address) begin
        if (mem_read_enable) begin
            data <= memory[address];
        end else begin
            data <= 32'b0;
        end
    end

    // 异步复位逻辑（覆盖其他操作）
    always @(posedge reset) begin
        if (reset) begin
            data <= 32'b0;
            // 可选：同时复位存储器内容
            // memory[0] <= 32'h04030201;
            // memory[1] <= 32'h08070605;
            // ...
        end
    end

endmodule