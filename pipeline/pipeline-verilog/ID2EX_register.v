module ID2EX_register (
    input clk,
    input reset,
    input [5:0] opcode_in,
    input [31:0] rs_data_in,
    input [31:0] rt_data_in,
    input [4:0] rd_in,
    input [31:0] imm_in,
    output reg [31:0] rs_data_out,
    output reg [31:0] rt_data_out,
    output reg [4:0] rd_out,
    output reg [31:0] imm_out,
    output reg [5:0] opcode_out
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        rs_data_out <= 32'b0; // Reset rs to zero
        rt_data_out <= 32'b0; // Reset rt to zero
        rd_out <= 5'b0;   // Reset rd to zero
        imm_out <= 32'b0; // Reset immediate value to zero
        opcode_out <= 5'b0; // Reset opcode to zero
    end else begin
        rs_data_out <= rs_data_in; // Pass rs value
        rt_data_out <= rt_data_in; // Pass rt value
        rd_out <= rd_in;   // Pass rd value
        imm_out <= imm_in; // Pass immediate value
        opcode_out <= opcode_in; // Pass opcode value
    end
end



endmodule