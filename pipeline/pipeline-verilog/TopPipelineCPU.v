module PipelinedCPU(
    input clk,
    input reset
);

// PC相关信号
wire [31:0] pc_current;
reg [31:0] pc_next;
wire beq_taken;
wire [31:0] branch_imm;

// IF阶段
wire [31:0] instruction;

// 寄存器堆接口
wire [4:0] rs = instruction[25:21];
wire [4:0] rt = instruction[20:16];
wire [4:0] rd = instruction[15:11];

// 寄存器堆读数据
wire [31:0] rs_data;
wire [31:0] rt_data;
wire [31:0] rd_data;  // 一般情况下WB写回的寄存器数据

// ID阶段输出信号
wire [4:0] id_rd_out;
wire [31:0] id_imm;
wire [5:0] id_opcode;
wire [31:0] id_rs_data;
wire [31:0] id_rt_data;
wire [31:0] id_rd_data;
wire id_mem_write;
wire id_mem_read;
wire id_reg_write;
wire id_beq_taken;

// ID2EX寄存器输出信号
wire [31:0] ex_rs_data;
wire [31:0] ex_rt_data;
wire [31:0] ex_rd_data;
wire [4:0] ex_rd_out;
wire [31:0] ex_imm;
wire [5:0] ex_opcode;
wire ex_mem_read;
wire ex_mem_write;
wire ex_reg_write;

// EX阶段输出信号
wire [31:0] ex_alu_result;
wire [5:0] ex_opcode_out;
wire [4:0] ex_rd_out_out;
wire ex_mem_read_out;
wire ex_mem_write_out;
wire [31:0] ex_rd_data_out;
wire ex_reg_write_out;

// EX2MEM寄存器输出信号
wire [4:0] mem_rd_out;
wire [31:0] mem_alu_result_out;
wire [5:0] mem_opcode_out;
wire mem_mem_read_out;
wire mem_mem_write_out;
wire [31:0] mem_rd_data_out;
wire mem_reg_write_out;

// MEM阶段输出信号
wire mem_reg_write_out_wb;
wire [31:0] mem_alu_result_out_wb;
wire [4:0] mem_rd_out_wb;
wire [31:0] mem_mem_data_out;

// MEM2WB寄存器输出信号
wire [31:0] wb_mem_data_out;
wire [4:0] wb_rd_out;
wire [31:0] wb_alu_result_out;
wire wb_reg_write_out;

// 写回阶段写入寄存器信号
wire reg_write_enable_wb;
wire [4:0] rd_wb;
wire [31:0] write_data_wb;

// PC模块实例化
PC pc_module (
    .clk(clk),
    .reset(reset),
    .next_pc(pc_next),
    .beq_taken(beq_taken),
    .branch_imm(branch_imm),
    .pc_out(pc_current)
);

// IF阶段指令存储器（你自己实现或替换）
InstructionMemory imem (
    .pc(pc_current),
    .instruction(instruction)
);

// 寄存器堆实例化
register_file regfile (
    .clk(clk),
    .reset(reset),
    .rs1(rs),
    .rs2(rt),
    .rd(rd_wb),
    .reg_write_enable(reg_write_enable_wb),
    .write_data(write_data_wb),
    .read_data1(rs_data),
    .read_data2(rt_data),
    .read_data3(rd_data)
);

// ID阶段实例化
ID id_stage (
    .clk(clk),
    .reset(reset),
    .instruction(instruction),
    .rs_data(rs_data),
    .rt_data(rt_data),
    .rd_data(rd_data),
    .rd_out(id_rd_out),
    .imm(id_imm),
    .opcode(id_opcode),
    .rs_data_temp(id_rs_data),
    .rt_data_temp(id_rt_data),
    .rd_data_temp(id_rd_data),
    .mem_write(id_mem_write),
    .mem_read(id_mem_read),
    .reg_write(id_reg_write),
    .beq_taken(id_beq_taken)
);

// PC_next逻辑，根据是否分支决定PC下一值
always @(*) begin
    if (id_beq_taken) begin
        // PC跳转 = 当前PC + 分支立即数（你可以根据实际指令修改此逻辑）
        pc_next = pc_current + (id_imm << 2); // 左移2表示字地址转换
    end else begin
        pc_next = pc_current + 4; // 默认顺序执行
    end
end

assign branch_imm = (id_imm << 2); // 传给PC模块，供计算

// ID2EX寄存器实例化
ID2EX_register id2ex (
    .clk(clk),
    .reset(reset),
    .opcode_in(id_opcode),
    .rs_data_in(id_rs_data),
    .rt_data_in(id_rt_data),
    .rd_data_in(id_rd_data),
    .rd_in(id_rd_out),
    .imm_in(id_imm),
    .mem_read(id_mem_read),
    .mem_write(id_mem_write),
    .reg_write(id_reg_write),
    .rs_data_out(ex_rs_data),
    .rt_data_out(ex_rt_data),
    .rd_data_out(ex_rd_data),
    .rd_out(ex_rd_out),
    .imm_out(ex_imm),
    .opcode_out(ex_opcode),
    .mem_read_out(ex_mem_read),
    .mem_write_out(ex_mem_write),
    .reg_write_out(ex_reg_write)
);

// EX阶段实例化
EX ex_stage (
    .clk(clk),
    .reset(reset),
    .rs_data(ex_rs_data),
    .rt_data(ex_rt_data),
    .rd_data(ex_rd_data),
    .imm(ex_imm),
    .rd(ex_rd_out),
    .opcode(ex_opcode),
    .mem_read(ex_mem_read),
    .mem_wtire(ex_mem_write), // 注意你之前拼写为mem_wtire，这里保持一致
    .reg_write(ex_reg_write),
    .alu_result(ex_alu_result),
    .opcode_out(ex_opcode_out),
    .rd_out(ex_rd_out_out),
    .mem_read_out(ex_mem_read_out),
    .mem_wtire_out(ex_mem_write_out),
    .rd_data_out(ex_rd_data_out),
    .reg_write_out(ex_reg_write_out)
);

// EX2MEM寄存器实例化
EX2MEM_register ex2mem (
    .clk(clk),
    .reset(reset),
    .alu_result_in(ex_alu_result),
    .opcode_in(ex_opcode_out),
    .rd_in(ex_rd_out_out),
    .mem_read(ex_mem_read_out),
    .mem_write(ex_mem_write_out),
    .rd_data_in(ex_rd_data_out),
    .reg_write(ex_reg_write_out),
    .rd_out(mem_rd_out),
    .alu_result_out(mem_alu_result_out),
    .opcode_out(mem_opcode_out),
    .mem_read_out(mem_mem_read_out),
    .mem_write_out(mem_mem_write_out),
    .rd_data_out(mem_rd_data_out),
    .reg_write_out(mem_reg_write_out)
);

// DataMemory实例化
wire [31:0] mem_data_out;
DataMemory datamemory (
    .clk(clk),
    .reset(reset),
    .mem_read_enable(mem_mem_read_out),
    .mem_write_enable(mem_mem_write_out),
    .address(mem_alu_result_out),
    .write_data(mem_rd_data_out),
    .data(mem_data_out)
);

// MEM阶段实例化
MEM mem_stage (
    .alu_result(mem_alu_result_out),
    .opcode(mem_opcode_out),
    .rd(mem_rd_out),
    .rd_data(mem_rd_data_out),
    .mem_read(mem_mem_read_out),
    .mem_write(mem_mem_write_out),
    .reg_write(mem_reg_write_out),
    .reg_write_out(mem_reg_write_out_wb),
    .alu_result_out(mem_alu_result_out_wb),
    .rd_out(mem_rd_out_wb),
    .rd_out_data(mem_mem_data_out)
);

// MEM2WB寄存器实例化
MEM2WB_register mem2wb (
    .clk(clk),
    .reset(reset),
    .mem_data_in(mem_mem_data_out),
    .rd_in(mem_rd_out_wb),
    .alu_result_in(mem_alu_result_out_wb),
    .reg_write_in(mem_reg_write_out_wb),
    .mem_data_out(wb_mem_data_out),
    .rd_out(wb_rd_out),
    .alu_result_out(wb_alu_result_out),
    .reg_write_out(wb_reg_write_out)
);

// WB阶段写入寄存器的逻辑
assign reg_write_enable_wb = wb_reg_write_out;
assign rd_wb = wb_rd_out;

// 根据指令类型选择写入数据（LW 写入内存数据，R型写入 ALU 结果）
assign write_data_wb = (wb_mem_data_out !== 32'bx && wb_mem_data_out !== 32'b0) ? wb_mem_data_out : wb_alu_result_out;

endmodule
