module ID (
    input wire clk,
    input wire reset,
    input wire [31:0] instruction,
    input wire [31:0] rs_data,
    input wire [31:0] rt_data,
    input wire [31:0] rd_data,

    output reg [4:0] rd_out,
    output reg [31:0] imm,
    output wire [5:0] opcode,
    output reg [31:0] rs_data_temp,
    output reg [31:0] rt_data_temp,
    output reg [31:0] rd_data_temp,
    output reg mem_write,
    output reg mem_read,
    output reg reg_write,
    output reg beq_taken
);

    assign opcode = instruction[31:26];
    wire [4:0] rs     = instruction[25:21];
    wire [4:0] rt     = instruction[20:16];
    wire [4:0] rd_w   = instruction[15:11];
    wire [15:0] imm16 = instruction[15:0];
    wire [31:0] imm_ext = {{16{imm16[15]}}, imm16}; // 有符号扩展

    always @(*) begin
        // 默认值（防止 latch）
        rd_out        = 5'b0;
        imm           = 32'b0;
        rs_data_temp  = 32'b0;
        rt_data_temp  = 32'b0;
        rd_data_temp  = 32'b0;
        mem_read      = 0;
        mem_write     = 0;
        reg_write     = 0;
        beq_taken     = 0;
        case (opcode)
            6'b000000: begin  // R-type
                rd_out        = rd_w;
                rs_data_temp  = rs_data;
                rt_data_temp  = rt_data;
                reg_write     = 1;
            end
            6'b100011: begin  // lw
                rd_out        = rt;
                imm           = imm_ext;
                rs_data_temp  = rs_data;
                mem_read      = 1;
                reg_write     = 1;
            end
            6'b101011: begin  // sw
                rd_out        = rt;
                imm           = imm_ext;
                rs_data_temp  = rs_data;
                rd_data_temp  = rd_data;
                mem_write     = 1;
            end
            6'b000100: begin  // beqz
                imm           = imm_ext;
                rs_data_temp  = rs_data;
                rt_data_temp  = 32'b0;
                beq_taken     = (rs_data == 32'b0) ? 1 : 0; // 如果 rs_data 为 0，则 beq_taken 为 1
                // 不写寄存器、不读内存
            end
        endcase
    end

endmodule
