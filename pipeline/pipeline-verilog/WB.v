module WB (
    input clk,
    input reset,
    input [31:0] alu_result_in,    // 从MEM2WB_register输入
    input [31:0] mem_data_in,      // 从MEM2WB_register输入
    input [4:0] rd_in,             // 写回目标寄存器
    input reg_write_in,            // 是否写回

    output reg [4:0] rd_out,           // 输出给register_file的寄存器地址
    output reg [31:0] rd_data_out,     // 输出给register_file的写回数据
    output reg reg_write_out           // 输出给register_file的写使能
);

always @(*) begin
        rd_out = rd_in;
        reg_write_out = reg_write_in;

        // 写回数据来源优先级：优先选择非0的mem_data，其次是alu_result
        if (mem_data_in != 32'b0)
            rd_data_out = mem_data_in;
        else
            rd_data_out = alu_result_in;
end

endmodule
