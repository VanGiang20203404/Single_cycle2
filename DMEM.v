module DMEM (
    input logic clk,
    input logic rst_n,
    input logic MemRead,
    input logic MemWrite,
    input logic [31:0] addr,
    input logic [31:0] WriteData,
    output logic [31:0] ReadData
);
    logic [31:0] memory [0:255]; // Định nghĩa bộ nhớ dữ liệu gồm 256 ô, mỗi ô 32-bit

    assign ReadData = (MemRead) ? memory[addr[9:2]] : 32'b0;  //bộ nhớ được truy cập theo từng word (4 byte = 2^2 => bỏ 2 bit cuối)

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (int i = 0; i < 256; i = i + 1)
                memory[i] <= 32'b0;   // Nếu reset hoạt động (mức thấp), khởi tạo tất cả ô nhớ về 0
        end else if (MemWrite) begin
            memory[addr[9:2]] <= WriteData;
        end
    end
    
    // Khối khởi tạo ban đầu: đọc dữ liệu từ file vào bộ nhớ nếu file tồn tại
    initial begin
        if ($fopen("./mem/dmem_init2.hex", "r"))
            $readmemh("./mem/dmem_init2.hex", memory);
        else if ($fopen("./mem/dmem_init.hex", "r"))
            $readmemh("./mem/dmem_init.hex", memory);
    end
endmodule