
module InstructionMemory (
    input [31:0] pc,
    output reg [31:0] instruction
);

    reg [31:0] memory [0:255]; // 256 个 32 位字的内存

    initial begin
        // 示例指令加载
        memory[3] = 32'b100011_00000_00001_0000000000000000; // lw x1,0(x0) 
        memory[4] = 32'b100011_00000_00010_0000000000000001; // lw x2,1(x0)
        memory[5] = 32'b000000_00000_00000_0000000000000000; // nope
        memory[6] = 32'b000000_00000_00000_0000000000000000; // nope
        memory[7] = 32'b000000_00000_00000_0000000000000000; // nope
        memory[8] = 32'b000000_00000_00000_0000000000000000; // nope
        memory[9] = 32'b000000_00001_00010_00011_00000100000; // add x1, x2, x3
        // 可根据需要添加更多指令
    end

    always @(*) begin
        instruction = memory[pc[9:2]]; // 等价于 pc >> 2，取字对齐
    end

endmodule
