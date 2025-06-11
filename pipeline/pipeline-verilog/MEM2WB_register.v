module MEM2WB_register (
    input clk,
    input reset,

    input [31:0] mem_data_in,   // 来自 DataMemory 的输出
    input [4:0] rd_in,
    input [31:0] alu_result_in,
    input reg_write_in,

    output reg [31:0] mem_data_out,  // 送 WB 阶段
    output reg [4:0] rd_out,
    output reg [31:0] alu_result_out,
    output reg reg_write_out
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            mem_data_out <= 32'b0;
            rd_out <= 5'b0;
            alu_result_out <= 32'b0;
            reg_write_out <= 1'b0;
        end else begin
            mem_data_out <= mem_data_in;
            rd_out <= rd_in;
            alu_result_out <= alu_result_in;
            reg_write_out <= reg_write_in;
        end
    end

endmodule
