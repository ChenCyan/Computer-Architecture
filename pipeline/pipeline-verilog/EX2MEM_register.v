module EX2MEM_register (
    input clk,
    input reset,
    input [31:0] alu_result_in,
    input [5:0] opcode_in,
    input [31:0] rs2_data_in,
    output reg [31:0] alu_result_out,
    output reg [5:0] opcode_out
);
always @(posedge clk or posedge reset) begin
    if (reset) begin
        alu_result_out <= 32'b0; // Reset ALU result to zero
        opcode_out <= 6'b0; // Reset opcode to zero
    end else begin
        alu_result_out <= alu_result_in; // Pass ALU result
        opcode_out <= opcode_in; // Pass opcode
    end
end
endmodule
// This module serves as a register to hold the results from the EX stage
// and pass them to the MEM stage. It includes the ALU result, rs2 data,
// rd value, and memory read/write signals. The reset functionality ensures
// that all outputs are set to zero when the reset signal is high, allowing 