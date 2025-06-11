module MEM(
    input clk,
    input reset,
    input [31:0] alu_result,
    input [5:0] opcode,
    input [4:0] rd,
    input [31:0] rd_data,
    input mem_read,
    input mem_write,
    input reg_write,

    output [31:0] mem_data_out,      // 来自 DataMemory 的读结果，送 MEM2WB
    output [4:0] rd_out,
    output reg_write_out,
    output [31:0] alu_result_out,
    output mem_read_out,
    output mem_write_out,
    output [31:0] rd_data_out
);

    // wire连接 DataMemory
    wire [31:0] data_memory_output;

    assign alu_result_out = alu_result;
    assign rd_out = rd;
    assign reg_write_out = reg_write;
    assign mem_read_out = mem_read;
    assign mem_data_out = data_memory_output;
    assign rd_data_out = rd_data;
    assign mem_write_out = mem_write;

    DataMemory data_mem (
        .clk(clk),
        .reset(reset),
        .mem_read_enable(mem_read),
        .mem_write_enable(mem_write),
        .address(alu_result),
        .write_data(rd_data),
        .data(data_memory_output)
    );

endmodule
