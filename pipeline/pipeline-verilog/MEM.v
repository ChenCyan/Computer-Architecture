module MEM(
    input [31:0] alu_result,
    input [5:0] opcode
);
reg mem_read,mem_write;

always @(*) begin
    case (opcode)
        6'b100011: begin // LW
            // Load word from memory at address alu_result
            // This would typically involve a memory read operation

        end
        6'b101011: begin // SW
            // Store word to memory at address alu_result
            // This would typically involve a memory write operation
        end
        default: begin
            // Other opcodes can be handled here if needed
        end
    endcase 
end




endmodule