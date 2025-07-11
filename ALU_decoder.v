module ALU_decoder(
    input  [1:0] alu_op,   // Tín hiệu điều khiển từ bộ điều khiển chính (Main Control)
    input  [2:0] funct3,    // 3-bit funct3 từ lệnh
    input        funct7b5,   // Bit thứ 5 của funct7 (bit 30 của lệnh R-type)
    output logic [3:0] alu_control   // Đầu ra điều khiển cho ALU (chọn phép toán)
);
    always_comb begin
        alu_control = 4'b0010; // ADD mặc định (load/store)
        case (alu_op)
            2'b00: alu_control = 4'b0010; // ADD
            2'b01: alu_control = 4'b0110; // SUB (branch)
            2'b10: begin // R-type/I-type
                case (funct3)
                    3'b000: alu_control = (funct7b5 ? 4'b0110 : 4'b0010); // SUB : ADD
                    3'b111: alu_control = 4'b0000; // AND
                    3'b110: alu_control = 4'b0001; // OR
                    3'b010: alu_control = 4'b0111; // SLT
                    default: alu_control = 4'b0010;
                endcase
            end
            default: alu_control = 4'b0010;
        endcase
    end
endmodule