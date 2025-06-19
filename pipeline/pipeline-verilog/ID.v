module ID (
    input wire clk,
    input wire reset,
    input wire [31:0] instruction,
    input wire [31:0] rs_data,
    input wire [31:0] rt_data,
    input wire [31:0] rd_data,

    output wire [4:0] rs,
    output wire [4:0] rt,
    output wire [4:0] rd,
    output reg [4:0] rd_out,
    output reg [31:0] imm,
    output wire [5:0] opcode,
    output reg [31:0] rs_data_temp,
    output reg [31:0] rt_data_temp,
    output reg [31:0] rd_data_temp,
    output reg mem_write,
    output reg mem_read,
    output reg reg_write,
    output reg beq_taken,
    output reg [31:0] beq_imm,
    output reg behind_beq_flag
);
    assign opcode = instruction[31:26];
    assign rs     = instruction[25:21];
    assign rt     = instruction[20:16];
    assign rd     = instruction[15:11];
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
        beq_imm       = 0;
        case (opcode)
            6'b000000: begin  // R-type
                rd_out        = rd;
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
                rd_data_temp  = rt_data;
                mem_write     = 1;
            end
            6'b000100: begin  // beqz
                if (rs_data == rt_data) begin
                    beq_taken = 1;
                    beq_imm   = imm_ext;
                end else begin
                    beq_taken = 0;
                    beq_imm   = 0;
                end
            end
        endcase
        //if (behind_beq_flag) begin
        //rd_out        = 5'b0;
        //imm           = 32'b0;
        //rs_data_temp  = 32'b0;
        //rt_data_temp  = 32'b0;
        //rd_data_temp  = 32'b0;
        //mem_read      = 0;
        //mem_write     = 0;
        //reg_write     = 0;
        //beq_taken     = 0;
        //behind_beq_flag = 0;
        //beq_imm       = 0;
        //end

    end
    //always @(posedge clk or reset) begin
       //if (opcode == 000100) behind_beq_flag <=1;
    //end

endmodule
