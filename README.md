# RISC-V Processor in Verilog
Single-cycle RISC-V processor designed and simulated in Vivado 2025.2

## About
This project implements a single cycle 32-bit RISC-V processor written in Verilog and designed on the Vivado 2025.2 software which allowed for simulation without needing a physical FPGA board.

This project was built as a learning exercise and made taking inspiration from the following youtube video which describes how a RISC-V processor works.

  
[![Video title](https://img.youtube.com/vi/USFhmrBlFis/0.jpg)](https://www.youtube.com/watch?v=USFhmrBlFis)

### Features
- RISCV32I instruction set
- Single-cycle datapath
- Supports R-type, I-type, S-type, B-type instructions
- Register file with 32 general purpose registers
- ALU supports arithmetic, logic and comparison operations
  
### Tools used
- Vivado 2025.2
- C to RISC-V assembly code : https://godbolt.org/
- RISC-V assembly to machine code : https://riscvasm.lucasteske.dev/#

## Future improvements

In the future, this project could be improved by using:
- Pipelining to improve speed
- Instruction and data caches
- Support for J-type instructions
- Testing the design on a FPGA board
