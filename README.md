# RISC-V Processor in Verilog
Single-cycle RISC-V processor designed and simulated in Vivado 2025.2

## About
This project implements a single-cycle 32-bit RISC-V processor written in Verilog and designed on the Vivado 2025.2 software. This allowed for simulation without needing a physical FPGA board.

This project was built as a learning exercise and was inspired by the following YouTube video explaining RISC-V architecture.

  
[![Video title](https://img.youtube.com/vi/USFhmrBlFis/0.jpg)](https://www.youtube.com/watch?v=USFhmrBlFis)

### Features
- RV32I instruction set
- Single-cycle datapath
- Supports R-type, I-type, S-type, B-type instructions
- Register file containing 32 general-purpose registers
- ALU supporting arithmetic, logic and comparison operations
  
### Tools used
- Vivado 2025.2
- C to RISC-V assembly code : https://godbolt.org/
- RISC-V assembly to machine code : https://riscvasm.lucasteske.dev/#


## Example Simulation
Shown is a waveform screenshot from a simple program calculating the fifth triangular number.
  
<img width="1347" height="222" alt="waveform example" src="https://github.com/user-attachments/assets/a89345ca-115f-4485-878c-605fe0677c7b" />


## Future improvements

In the future, this project could be improved by using:
- Pipelining to improve speed
- Instruction and data caches
- Support for J-type instructions
- Testing the design on an FPGA board
