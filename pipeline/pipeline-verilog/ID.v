module ID(
    input clk,
    input reset,
    input [31:0] instruction,
    input [31:0] rs_data,
    input [31:0] rt_data,
    output reg [4:0] rs_out,
    output reg [4:0] rd_out,
    output reg [4:0] rt_out,
    output reg [31:0] imm,
    output reg [5:0] opcode,
    output reg [31:0] rs_data_temp,
    output reg [31:0] rt_data_temp
);
    wire [5:0] op     = instruction[31:26];
    wire [4:0] rs     = instruction[25:21];
    wire [4:0] rt     = instruction[20:16];
    wire [4:0] rd_w   = instruction[15:11];
    wire [15:0] imm16 = instruction[15:0];
    wire [31:0] imm_ext = {{16{imm16[15]}}, imm16}; // 有符号扩展
    /*register_file reg_file (
        .clk(clk),
        .reset(reset),
        .rs(rs),
        .rt(rt),
        .rd(rd_w),
        .reg_write_enable(1'b0), // 读取数据不需要写入
        .write_data(32'b0), // 写入数据不重要，因为我们只读
        .read_data1(rs_data_temp),
        .read_data2(rt_data_temp)
    );*/
    always @(*) begin
        opcode = op;
        rs_out = rs;
        rt_out = rt;
        // 根据操作码设置 rd 和 imm
        case (op)
            6'b000000: begin  // R-type: add
                rd_out  = rd_w;
                imm = 32'b0;
                rs_data_temp = rs_data; // rs_data_temp 用于传递 rs 的数据
                rt_data_temp = rt_data; // rt_data_temp 用于传递 rt 的数据
            end
            6'b100011: begin  // lw
                rd_out  = rt;      // rt是目的寄存器
                imm = imm_ext;
                rs_data_temp = rs_data; // rs_data_temp 用于传递 rs 的数据
                rt_data_temp = 32'b0;
            end
            6'b101011: begin  // sw
                rd_out  = rt;      // rt是目的寄存器
                imm = imm_ext;
                rs_data_temp = rs_data; // rs_data_temp 用于传递 rs 的数据
                rt_data_temp = 32'b0;
            end
            6'b000100: begin  // beq (用 beqz 模拟 beq rs, $zero, offset)
                rd_out  = 5'b0;
                imm = imm_ext;
                rs_data_temp = rs_data; // rs_data_temp 用于传递 rs 的数据
                rt_data_temp = rt_data;
            end
            default: begin
                rd_out  = 5'b0;
                imm = 32'b0;
                rs_data_temp = 32'b0; // 默认情况下，rs_data_temp 设置为零
                rt_data_temp = 32'b0; // 默认情况下，rt_data_temp 设置为零
            end
        endcase
    end

endmodule
