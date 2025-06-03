module pipeline (
);
    reg clk, reset;
    reg [31:0] pc;
    wire [31:0] instruction;
    wire [4:0] rs1, rs2, rd;
    wire [31:0] imm;
    wire [31:0] alu_result;
    wire [31:0] data_memory;
    wire [31:0] write_back_data;
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end
    IF IF_stage(
        .clk(clk),
        .reset(reset),
        .pc(pc),
        .instruction(instruction)
    );

    IF2ID_register IF2TD(
        .clk(clk),
        .reset(reset),
        .instruction_in(instruction),
        .instruction_out(instruction)
    );

    ID ID_stage(
        .clk(clk),
        .reset(reset),
        .instruction(instruction),
        .rs1(rs1),
        .rs2(rs2),
        .rd(rd),
        .imm(imm)
    );
    EX EX_stage(
        .clk(clk),
        .reset(reset),
        .rs1(rs1),
        .rs2(rs2),
        .imm(imm),
        .rd(rd),
        .alu_result(alu_result)
    );
    MEM MEM_stage(
        .clk(clk),
        .reset(reset),
        .alu_result(alu_result),
        .rd(rd),
        .data_memory(data_memory)
    );
    WB WB_stage(
        .clk(clk),
        .reset(reset),
        .data_memory(data_memory),
        .alu_result(alu_result),
        .rd(rd),
        .write_back_data(write_back_data)
    );
    
endmodule