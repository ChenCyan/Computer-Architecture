module IF(clk,reset,pc,instruction);
    input clk,reset;
    input [31:0] pc;
    output reg[31:0] instruction;

    reg [31:0]instruction_pc;
    InstructionMemory instMem (
        .pc(pc),
        .instruction(instruction_pc)
    );
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            instruction <= 32'b0; // Reset instruction to zero
        end else begin
            instruction <= instruction_pc; // Fetch instruction based on PC
        end
    end

endmodule