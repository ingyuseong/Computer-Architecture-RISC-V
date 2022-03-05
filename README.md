# Computer-Architecture-RISC-V
* RISC-V core design using VerilogHDL
* KECE343 Computer Architecture ([Prof. Seon Wook Kim](http://compiler.korea.ac.kr/?_ga=2.194478564.854245486.1646472198-316617093.1632121575))
* Use “real-world” examples to illustrate important concept of computer architecture
  * Four projects using RISC-V

## Overview
Use a 32-bit RISC-V core written in Verilog and an instruction set simulator supporting RV32IM ([reference](https://github.com/ultraembedded/riscv))
<br>

### RISC-V Core Architecture
![image](https://user-images.githubusercontent.com/37537248/156884274-9fe0f9ec-cccb-4a1e-9690-0c7d6edd57ae.png)
* 32-bit RISC-V ISA CPU core
* Support RISC-V integer(I), multiplication and division (M), and CSR instructions, (Z) extensions (RV32IMZicsr)
* Support for instruction / data cache, AXI bus interfaces or tightly coupled memories
  * [AXI interface documents](https://www.xilinx.com/support/documentation/ip_documentation/ug761_axi_reference_guide.pdf)

## Project 1: RISC-V core design using Verilog & Project environment setting
**GOAL: Project Environment Setting**
* Set project environment based on ModelSim-Intel FPGA Edition
* Write a simple test code and verify execution
* Analyze and draw block diagram of RISC-V core by referring to [the given code](https://github.com/ultraembedded/riscv)

## Project 2: Memory hierarchy & Cache design
**GOAL: Understand Memory Hierarchy and Cache Architecture**
* Analyze the operation of the cache in the form of waveform
* Modify cache size to given condition and analyze results (verify performance improvement)

## Project 3: HPC (Hardware Performance counter) design
**GOAL: Understand Performance Methodolgy & Metric of RISC-V core**
* Design HPC which measure performance metric
* Verify the operation of pipelining and analyze results (verify pipeline stall)

## Project 4: Instruction set extension design
**GOAL: Learn Data Path & Control Path of Instructions by each pipeline stages of RISC-V core**
* Understand RISC-V ISA
* Design extended ISA in RTL-level and verify it through testbench
