`timescale 1ns/1ps

module alu_tb();
    // Khai báo tín hiệu đầu vào (dùng reg)
    reg [31:0] A, B;
    reg [2:0] ALUControl;
    
    // Khai báo tín hiệu đầu ra (dùng wire)
    wire Carry, OverFlow, Zero, Negative;
    wire [31:0] Result;

    // Instantiate (Khởi tạo) bộ ALU từ file ALU.v
    ALU uut (
        .A(A),
        .B(B),
        .ALUControl(ALUControl),
        .Result(Result),
        .OverFlow(OverFlow),
        .Carry(Carry),
        .Zero(Zero),
        .Negative(Negative)
    );

    initial begin
        // Tạo file VCD để vẽ sóng GTKWave (nếu cần)
        $dumpfile("alu.vcd");
        $dumpvars(0, alu_tb);

        // ----------------------------------------------------
        // Kịch bản 1: Test Phép Cộng (ADD) với 2 số dương nhỏ
        // ALUControl = 000 (Mã lệnh Cộng)
        // ----------------------------------------------------
        A = 32'd15; B = 32'd20; ALUControl = 3'b000;
        #10; // Đợi 10 đơn vị thời gian để mạch xử lý
        $display("Test 1 (ADD): %d + %d = %d", A, B, Result);

        // ----------------------------------------------------
        // Kịch bản 2: Test Phép Cộng (ADD) số dương với số âm
        // ----------------------------------------------------
        A = 32'd100; B = -32'd40; ALUControl = 3'b000;
        #10;
        $display("Test 2 (ADD Negative): %d + (%d) = %d", A, $signed(B), $signed(Result));

        // ----------------------------------------------------
        // Kịch bản 3: Test giới hạn (Cộng với số 0)
        // ----------------------------------------------------
        A = 32'd999; B = 32'd0; ALUControl = 3'b000;
        #10;
        $display("Test 3 (ADD Zero): %d + %d = %d", A, B, Result);

        // ----------------------------------------------------
        // Kịch bản mở rộng: Thử Phép Trừ (SUB) - Mã: 001
        // ----------------------------------------------------
        A = 32'd50; B = 32'd20; ALUControl = 3'b001;
        #10;
        $display("Test 4 (SUB): %d - %d = %d", A, B, Result);

        // Kết thúc mô phỏng
        $finish;
    end

endmodule
