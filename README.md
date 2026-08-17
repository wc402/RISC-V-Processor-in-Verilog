# RISC-V Processor in Verilog
RISC-V processor designed and simulated in Vivado 2025.2 using a 5-stage pipeline with hazard handling.

## About
This project implements a 32-bit RISC-V processor written in Verilog and designed on the Vivado 2025.2 software. This allowed for simulation without needing a physical FPGA board.

This project was built as a learning exercise and was inspired by the following YouTube video explaining RISC-V architecture.
  
[![Video title](https://img.youtube.com/vi/USFhmrBlFis/0.jpg)](https://www.youtube.com/watch?v=USFhmrBlFis)

I learnt about pipelining and hazarding handling and improved an initial design of the processor using Dr. Ben H. Juurlink's youtube series on computer architecture.

### Features
- RV32I instruction set
- 5-stage pipeline with hazard detection (solving load-use hazards) and data forwarding (solving data hazards)
- Supports R-type, I-type, S-type, B-type instructions
- Register file containing 32 general-purpose registers
- ALU supporting arithmetic, logic and comparison operations
  
### Tools used
- Vivado 2025.2
- C to RISC-V assembly code : https://godbolt.org/
- RISC-V assembly to machine code : https://riscvasm.lucasteske.dev/#


## Example Simulation
Shown is a waveform screenshot from a simple program calculating the fibonacci series. The machine code is available in the code for the instruction memory module. I selected this in order to test both the data forwarding and hazard detection.
  
<img width="1370" height="455" alt="waveform example fib" src="https://github.com/user-attachments/assets/a58e92ba-121b-4ef3-aeee-d5f9526e3b25" />


## Future improvements

In the future, this project could be improved by using:
- Instruction and data caches
- Support for J-type instructions
- Testing the design on an FPGA board
- Create an assembler 
