`timescale 1ns/1ps
module register_file (
    input clk,reset,
    input [4:0] rs1,rs2,rd,
    input reg_write_enable,
    input [31:0] write_data,
    output [31:0] read_data1, read_data2,read_data3

);
integer i;
reg [31:0] registers [31:0]; // 32个寄存器，每个寄存器32位
initial begin
        // 示例指令加载
        #50 registers[8] = 32'h00000001;
        registers[9] = 32'h00000002;
        registers[10] = 32'h00000013;
        registers[3] = 32'h00000013;
        registers[2] = 32'h00000001;
        // 可根据需要添加更多指令
end
assign read_data1 = (rs1 == 5'b0) ? 32'b0 : registers[rs1]; // 如果是$zero寄存器，返回0
assign read_data2 = (rs2 == 5'b0) ? 32'b0 : registers[rs2]; // 如果是$zero寄存器，返回0
assign read_data3 = (rd == 5'b0) ? 32'b0 : registers[rd]; // 如果是$zero寄存器，返回0
always @(posedge clk or posedge reset) begin
    if (reset) begin
        // Reset all registers to zero
        for (i = 0; i < 32; i = i + 1) begin
            registers[i] <= 32'b0;
        end
    end else if (reg_write_enable && rd != 5'b0) begin
        // 写入数据到寄存器，除非是$zero寄存器
        registers[rd] <= write_data;
    end
end
endmodule