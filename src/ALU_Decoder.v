// Copyright 2023 MERL-DSU

//    Licensed under the Apache License, Version 2.0 (the "License");
//    you may not use this file except in compliance with the License.
//    You may obtain a copy of the License at

//        http://www.apache.org/licenses/LICENSE-2.0

//    Unless required by applicable law or agreed to in writing, software
//    distributed under the License is distributed on an "AS IS" BASIS,
//    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//    See the License for the specific language governing permissions and
//    limitations under the License.

module ALU_Decoder(ALUOp,funct3,funct7,op,ALUControl);

    input [1:0]ALUOp;
    input [2:0]funct3;
    input [6:0]funct7,op;
    output [3:0]ALUControl;

    // Method 1 
    // assign ALUControl = (ALUOp == 2'b00) ? 3'b000 :
    //                     (ALUOp == 2'b01) ? 3'b001 :
    //                     (ALUOp == 2'b10) ? ((funct3 == 3'b000) ? ((({op[5],funct7[5]} == 2'b00) | ({op[5],funct7[5]} == 2'b01) | ({op[5],funct7[5]} == 2'b10)) ? 3'b000 : 3'b001) : 
    //                                         (funct3 == 3'b010) ? 3'b101 : 
    //                                         (funct3 == 3'b110) ? 3'b011 : 
    //                                         (funct3 == 3'b111) ? 3'b010 : 3'b000) :
    //                                        3'b000;

    // Method 2
    assign ALUControl = (ALUOp == 2'b00) ? 4'b0000 :
                        (ALUOp == 2'b01) ? 4'b0001 :
                        ((ALUOp == 2'b10) & (funct3 == 3'b000) & (funct7 == 7'b0000001)) ? 4'b0110 : 
                        ((ALUOp == 2'b10) & (funct3 == 3'b100) & (funct7 == 7'b0000001)) ? 4'b0111 : 
                        ((ALUOp == 2'b10) & (funct3 == 3'b000) & ({op[5],funct7[5]} == 2'b11)) ? 4'b0001 : 
                        ((ALUOp == 2'b10) & (funct3 == 3'b000) & ({op[5],funct7[5]} != 2'b11)) ? 4'b0000 : 
                        ((ALUOp == 2'b10) & (funct3 == 3'b010)) ? 4'b0101 : 
                        ((ALUOp == 2'b10) & (funct3 == 3'b011)) ? 4'b1011 : 
                        ((ALUOp == 2'b10) & (funct3 == 3'b110)) ? 4'b0011 : 
                        ((ALUOp == 2'b10) & (funct3 == 3'b111)) ? 4'b0010 : 
                        ((ALUOp == 2'b10) & (funct3 == 3'b100)) ? 4'b0100 : 
                        ((ALUOp == 2'b10) & (funct3 == 3'b001)) ? 4'b1000 : 
                        ((ALUOp == 2'b10) & (funct3 == 3'b101) & (funct7[5] == 1'b0)) ? 4'b1001 : 
                        ((ALUOp == 2'b10) & (funct3 == 3'b101) & (funct7[5] == 1'b1)) ? 4'b1010 : 
                                                                  4'b0000 ;
endmodule