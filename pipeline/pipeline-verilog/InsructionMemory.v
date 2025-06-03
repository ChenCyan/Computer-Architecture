module InsturctionMemory(
    input [31:0] pc,
    output reg [31:0] instruction
);

reg [31:0] memory [0:255]; // 256 words of memory
initial begin
    // Load instructions into memory (example instructions)
    memory[0] = 32'h00000013; // NOP
    memory[1] = 32'h00000013; // NOP
    memory[2] = 32'h00000013; // NOP
    memory[3] = 32'h00000013; // NOP
    // Add more instructions as needed
end

always @(*) begin
    instruction = memory[pc >> 2]; // Fetch instruction based on PC (assuming PC is word-aligned)
end
endmodule