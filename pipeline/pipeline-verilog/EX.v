module EX(
    input clk,
    input reset,
    input [31:0] rs_data,
    input [31:0] rt_data,
    input [31:0] rd_data,
    input [31:0] imm,
    input [4:0] rd,
    input [5:0] opcode,
    input mem_read,
    input mem_write,
    input reg_write,
    
    output reg [31:0] alu_result,
    output reg [5:0] opcode_out,
    output reg [4:0] rd_out,
    output reg mem_read_out,
    output reg mem_write_out,
    output reg [31:0] rd_data_out,
    output reg reg_write_out
);

always @(*) begin
    // 默认赋值，防止综合 latch
    alu_result      = 32'b0;
    opcode_out      = opcode;
    rd_out          = rd;
    mem_read_out    = mem_read;
    mem_write_out   = mem_write;
    rd_data_out     = rd_data;
    reg_write_out   = reg_write;

    case(opcode)
        6'b000000: begin // ADD
            alu_result = rs_data + rt_data;
        end
        6'b100011: begin // LW
            alu_result = rs_data + imm;
        end
        6'b101011: begin // SW
            alu_result = rs_data + imm;
        end
        default: begin
            alu_result = 32'b0;
        end
    endcase
end

endmodule
