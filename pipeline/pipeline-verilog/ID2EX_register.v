module ID2EX_register (
    input clk,
    input reset,
    input [5:0] opcode_in,
    input [31:0] rs_data_in,
    input [31:0] rt_data_in,
    input [31:0] rd_data_in,
    input [4:0] rd_in,
    input [31:0] imm_in,
    input mem_read,
    input mem_write,
    input reg_write,
    
    output reg [31:0] rs_data_out,
    output reg [31:0] rt_data_out,
    output reg [31:0] rd_data_out,
    output reg [4:0] rd_out,
    output reg [31:0] imm_out,
    output reg [5:0] opcode_out,
    output reg mem_read_out,
    output reg mem_write_out,
    output reg reg_write_out
);

    // ID -> EX 流水线寄存器
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            rs_data_out <= 32'b0;
            rt_data_out <= 32'b0;
            rd_data_out <= 32'b0;
            rd_out      <= 5'b0;
            imm_out     <= 32'b0;
            opcode_out  <= 6'b0;  // 修复位宽问题
            mem_read_out  <= 0;
            mem_write_out <= 0;
            reg_write_out <= 0;
        end else begin
            rs_data_out <= rs_data_in;
            rt_data_out <= rt_data_in;
            rd_data_out <= rd_data_in;
            rd_out      <= rd_in;
            imm_out     <= imm_in;
            opcode_out  <= opcode_in;
            mem_read_out  <= mem_read;
            mem_write_out <= mem_write;
            reg_write_out <= reg_write;
        end
    end

endmodule
