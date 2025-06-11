module InstructionMemory (
    input [31:0] pc,
    output reg [31:0] instruction
);

    reg [31:0] memory [0:255]; // 256 个 32 位字的内存

    initial begin
        // 示例指令加载
        memory[0] = 32'h00000013; // NOP
        memory[1] = 32'h00000013;
        memory[2] = 32'h00000013;
        memory[3] = 32'h00000013;
        // 可根据需要添加更多指令
    end

    always @(*) begin
        instruction = memory[pc[9:2]]; // 等价于 pc >> 2，取字对齐
    end

endmodule
