module IF (
    input wire clk,
    input wire reset,
    input wire [31:0] pc,
    output reg [31:0] instruction,
    output reg [31:0] next_pc
);

    wire [31:0] instruction_pc;  // 改为wire，表示由instMem输出
    InstructionMemory instMem (
        .pc(pc),
        .instruction(instruction_pc)
    );

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            instruction <= 32'b0;
            next_pc <= 32'b0;
        end else begin
            instruction <= instruction_pc;
            next_pc <= pc + 4; // 假设每条指令长度为4字节
        end
    end

endmodule