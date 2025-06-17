module MEM(
    input [31:0] alu_result,
    input [4:0] rd,
    input reg_write,
    output [4:0] rd_out,
    output reg_write_out,
    output [31:0] alu_result_out
);

    assign alu_result_out = alu_result;
    assign rd_out = rd;
    assign reg_write_out = reg_write;
   

endmodule
