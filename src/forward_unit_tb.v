`timescale 1ns/1ps

module forward_unit_tb();

    // Khai báo tín hiệu
    reg rst, RegWriteM, RegWriteW;
    reg [4:0] RD_M, RD_W, Rs1_E, Rs2_E;
    wire [1:0] ForwardAE, ForwardBE;

    // Khởi tạo Hazard Unit
    hazard_unit uut (
        .rst(rst),
        .RegWriteM(RegWriteM), .RegWriteW(RegWriteW),
        .RD_M(RD_M), .RD_W(RD_W),
        .Rs1_E(Rs1_E), .Rs2_E(Rs2_E),
        .ForwardAE(ForwardAE), .ForwardBE(ForwardBE)
    );

    initial begin
        $dumpfile("forward_unit.vcd");
        $dumpvars(0, forward_unit_tb);

        // Reset ban đầu
        rst = 0; RegWriteM = 0; RegWriteW = 0;
        RD_M = 0; RD_W = 0; Rs1_E = 0; Rs2_E = 0;
        #10;
        rst = 1;

        // ---------------------------------------------------------
        // Test 1: Data Hazard từ lệnh Phép Cộng (ADD)
        // Kịch bản: Lệnh [ADD x3, x1, x2] đi trước đang ở tầng Execute.
        // Lệnh sau [SUB x4, x3, x5] đang cần biến x3 ở vị trí Rs1.
        // -> Kỳ vọng: Vượt trước (Forward) từ tầng Execute vào ngõ A.
        // ---------------------------------------------------------
        RegWriteM = 1; RD_M = 3;  
        RegWriteW = 0; RD_W = 0;
        Rs1_E = 3; Rs2_E = 5;     
        #10;
        $display("[Test 1 - ADD Hazard] ForwardAE = %b (Ky vong 10), ForwardBE = %b", ForwardAE, ForwardBE);

        // ---------------------------------------------------------
        // Test 2: Data Hazard từ lệnh Phép Trừ (SUB)
        // Kịch bản: Lệnh [SUB x6, x1, x2] đã chạy vào sâu tầng Memory.
        // Lệnh đi sau [ADD x7, x8, x6] cần biến x6 ở vị trí Rs2.
        // -> Kỳ vọng: Vượt trước từ tầng Memory vào ngõ B.
        // ---------------------------------------------------------
        RegWriteM = 0; RD_M = 0; 
        RegWriteW = 1; RD_W = 6;  
        Rs1_E = 8; Rs2_E = 6;     
        #10;
        $display("[Test 2 - SUB Hazard] ForwardAE = %b, ForwardBE = %b (Ky vong 01)", ForwardAE, ForwardBE);

        // ---------------------------------------------------------
        // Test 3: Xung đột kép (Double Hazard) của lệnh Nhân (MUL)
        // Kịch bản: Có 2 lệnh cùng ghi vào biến x9:
        // [DIV x9, x3, x4] ở tầng Memory (Cũ hơn)
        // [MUL x9, x1, x2] ở tầng Execute (Mới hơn) 
        // Lệnh sau cùng [ADD x5, x9, x7] cần đọc biến x9 ở Rs1.
        // -> Kỳ vọng: Mạch phải thông minh ưu tiên lấy kết quả từ MUL(tầng EX).
        // ---------------------------------------------------------
        RegWriteM = 1; RD_M = 9;  // MUL ghi x9 (EX)
        RegWriteW = 1; RD_W = 9;  // DIV ghi x9 (MEM)
        Rs1_E = 9; Rs2_E = 7;     
        #10;
        $display("[Test 3 - MUL Hazard (Double)] ForwardAE = %b (Ky vong 10), ForwardBE = %b", ForwardAE, ForwardBE);

        // ---------------------------------------------------------
        // Test 4: Lấy chéo từ lệnh Phép Chia (DIV) 
        // Kịch bản: Lệnh [DIV x10, x1, x2] đang ở tầng Execute tính ra x10.
        // Lệnh đi theo sau [ADD x11, x10, x10] cần x10 ở cả 2 ngõ Rs1 và Rs2!
        // -> Kỳ vọng: Phải Forward cả hai đường A và B từ tầng Execute.
        // ---------------------------------------------------------
        RegWriteM = 1; RD_M = 10; 
        RegWriteW = 0; RD_W = 0;
        Rs1_E = 10; Rs2_E = 10;   
        #10;
        $display("[Test 4 - DIV Hazard] ForwardAE = %b (Ky vong 10), ForwardBE = %b (Ky vong 10)", ForwardAE, ForwardBE);

        $finish;
    end
endmodule
