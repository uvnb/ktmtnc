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

module ALU(A,B,Result,ALUControl,OverFlow,Carry,Zero,Negative);

    input [31:0]A,B;
    input [3:0]ALUControl;
    output Carry,OverFlow,Zero,Negative;
    output [31:0]Result;

    wire Cout;
    wire [31:0]Sum;

    assign Sum = (ALUControl[0] == 1'b0) ? A + B :
                                          (A + ((~B)+1)) ;
    assign {Cout,Result} = (ALUControl == 4'b0000) ? Sum :
                           (ALUControl == 4'b0001) ? Sum :
                           (ALUControl == 4'b0010) ? A & B :
                           (ALUControl == 4'b0011) ? A | B :
                           (ALUControl == 4'b0100) ? A ^ B :
                           (ALUControl == 4'b0101) ? {{32{1'b0}},(Sum[31])} :
                           (ALUControl == 4'b0110) ? {1'b0, (A * B)} :
                           (ALUControl == 4'b0111) ? {1'b0, (A / B)} :
                           (ALUControl == 4'b1000) ? {1'b0, (A << B[4:0])} :
                           (ALUControl == 4'b1001) ? {1'b0, (A >> B[4:0])} :
                           (ALUControl == 4'b1010) ? {1'b0, ($signed(A) >>> B[4:0])} :
                           (ALUControl == 4'b1011) ? {{32{1'b0}}, (A < B)} :
                           {33{1'b0}};
    assign OverFlow = ((Sum[31] ^ A[31]) & 
                      (~(ALUControl[0] ^ B[31] ^ A[31])) &
                      (~ALUControl[1]));
    assign Carry = ((~ALUControl[1]) & Cout);
    assign Zero = &(~Result);
    assign Negative = Result[31];

endmodule