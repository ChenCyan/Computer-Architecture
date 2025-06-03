module register_file (
    input clk,reset,
    input [4:0] rs1,rs2,rd,
    input reg_write_enable,
    input [31:0] write_data,
    output [31:0] read_data1, read_data2
);
integer i;
reg [31:0] registers [31:0]; // 32个寄存器，每个寄存器32位
assign read_data1 = (rs1 == 5'b0) ? 32'b0 : registers[rs1]; // 如果是$zero寄存器，返回0
assign read_data2 = (rs2 == 5'b0) ? 32'b0 : registers[rs2]; // 如果是$zero寄存器，返回0
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