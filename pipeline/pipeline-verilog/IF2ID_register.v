module IF2ID_register (
    input clk,
    input reset,
    input [31:0] instruction_in,
    input beq_taken,
    output reg [31:0] instruction_out
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            instruction_out <= 32'b0; // Reset instruction to zero
        end else if(!beq_taken) begin
            instruction_out <= instruction_in; // Pass instruction
        end
            else if (beq_taken) begin
            instruction_out <= 32'b0; // If branch taken, reset instruction
        end
    end

endmodule   