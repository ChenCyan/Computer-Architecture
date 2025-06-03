module IF2ID_register (
    input clk,
    input reset,
    input [31:0] instruction_in,
    output reg [31:0] instruction_out
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            instruction_out <= 32'b0; // Reset instruction to zero
        end else begin
            instruction_out <= instruction_in; // Pass instruction
        end
    end

endmodule   