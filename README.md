# RISCV_Pipeline_Core
This repository contains the design files of an extended RISC-V 5-Stage Pipeline Core.
It has been heavily customized to support **RV32M (Multiply/Divide)** and full **Group 1 Arithmetic/Logic instructions** (XOR, SLL, SRL, SRA, SLTU, ANDI, ORI, XORI, SLLI, etc.) with proper internal forwarding adjustments.

## How to Simulate
To run the various included simulations, use Icarus Verilog (`iverilog`) and GTKWave. **Make sure you are in the `src/` directory** before running these commands!

### 1. Test the entire Pipeline (Toplevel)
This will load and execute the RV32I / RV32M test machine codes compiled inside `memfile.hex`.
```bash
cd src
iverilog -o out.vvp pipeline_tb.v Pipeline_Top.v
vvp out.vvp
gtkwave dump.vcd pipeline.gtkw &
```

### 2. Test the ALU (Arithmetic Logic Unit)
Runs 4 targeted testcases covering mathematical logic (ADD, SUB, Zero edge cases):
```bash
cd src
iverilog -o alu.vvp alu_tb.v ALU.v
vvp alu.vvp
gtkwave alu.vcd &
```

### 3. Test the Forwarding Unit (Data Hazards)
Runs custom edge-case scenarios validating internal Register forwarding (including complex Double Hazards and Writeback conflicts) across the ADD, SUB, MUL, and DIV flows.
```bash
cd src
iverilog -o forward.vvp forward_unit_tb.v Hazard_unit.v
vvp forward.vvp
gtkwave forward_unit.vcd &
```

# TOP Architecture
![Screenshot from 2023-05-11 11-34-13](https://github.com/merldsu/RISCV_Pipeline_Core/assets/53592110/4caaeee5-e804-42ae-b0f0-264a62f2d385)


# LICENSE

   Copyright 2023 MERL-DSU

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
