
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
        memory[4] = 32'b00000001001010100101100000100000; // add x9, x10, x11
        memory[5] = 32'b10001111101010000000000000000100; // lw x8,4(x29)
        memory[6] = 32'b10101100000000100000000000000000; // sw x2,0(x0)
        // 可根据需要添加更多指令
    end

    always @(*) begin
        instruction = memory[pc[9:2]]; // 等价于 pc >> 2，取字对齐
    end

endmodule
