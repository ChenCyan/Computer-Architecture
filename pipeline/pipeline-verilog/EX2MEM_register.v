module EX2MEM_register (
    input clk,
    input reset,
    
    input [31:0] alu_result_in,
    input [5:0] opcode_in,
    input [4:0] rd_in,
    input mem_read,
    input mem_write,
    input [31:0] rd_data_in,
    input reg_write,

    output reg [4:0] rd_out,
    output reg [31:0] alu_result_out,
    output reg [5:0] opcode_out,
    output reg mem_read_out,
    output reg mem_write_out,
    output reg [31:0] rd_data_out,
    output reg reg_write_out
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            alu_result_out <= 32'b0;
            opcode_out     <= 6'b0;
            rd_out         <= 5'b0;
            mem_read_out   <= 1'b0;
            mem_write_out  <= 1'b0;
            rd_data_out    <= 32'b0;
            reg_write_out  <= 1'b0;
        end else begin
            alu_result_out <= alu_result_in;
            opcode_out     <= opcode_in;
            rd_out         <= rd_in;
            mem_read_out   <= mem_read;
            mem_write_out  <= mem_write;
            rd_data_out    <= rd_data_in;
            reg_write_out  <= reg_write;
        end
    end

endmodule
