module PC(
    input clk,
    input reset,
    input [31:0] next_pc,  // 来自 IF 阶段的下一个 PC 值
    input beq_taken, // 分支指令是否被采取
    input [31:0] branch_imm, // 传入立即数
    output reg [31:0] pc_out // 输出当前 PC 值
);
    always @(*) begin
        if (reset) begin
            pc_out = 32'b0; // 重置 PC 值为 0
        end 
        else begin
        pc_out = next_pc; // 更新 PC 值
        if (beq_taken) begin
            pc_out = pc_out + branch_imm; // 如果分支被采取，跳转到分支目标地址
        end
         end
    end
endmodule