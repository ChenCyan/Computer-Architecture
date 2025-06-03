module EX(
    input clk,
    input reset,
    input [31:0] rs_data,
    input [31:0] rt_data,
    input [31:0] imm,
    input [4:0] rd,
    input [5:0]opcode,
    output reg [31:0] alu_result,
    output reg [5:0] opcode_out,
    output reg [4:0] rd_out
);

always @(*) begin
    opcode_out = opcode;
    rd_out = rd;
    case(opcode)
        6'b 000000: alu_result = rs_data + rt_data; // ADD
        6'b 100011: alu_result = rs_data + imm; // LW
        6'b 101011: alu_result = rs_data + imm; // SW
        6'b 000100: begin   
            alu_result = (rs_data == rt_data) ? 1 : 0; // BEQ
            rd_out = 0;
        end
        default: alu_result = 32'b0; // 默认情况
    endcase
end
endmodule