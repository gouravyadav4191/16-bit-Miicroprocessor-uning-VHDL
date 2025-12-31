# 16-bit-Miicroprocessor-using-VHDL
This project focuses on the design and simulation of a simplified 16-bit processor using VHDL. it consists of fundamental blocks such as Program Counter, Register File, ALU, Control Unit, and Status Flags. Each module is individually designed, tested using dedicated testbenches, and finally integrated into a top-level CPU design

Design and Simulation of a 16-Bit Processor using VHDL

1. Introduction
A microprocessor is the core component of any digital computing system. It performs arithmetic, logical, control, and data movement operations based on a set of instructions. With the advancement of hardware description languages, processors can be designed, simulated, and verified before physical implementation.
This project focuses on the design and simulation of a simplified 16-bit processor using VHDL. The processor is modular in nature and consists of fundamental building blocks such as the Program Counter, Register File, Arithmetic Logic Unit (ALU), Control Unit, and Status Flags. Each module is individually designed, tested using dedicated testbenches, and finally integrated into a top-level CPU design.
The complete design is simulated using ModelSim (Intel FPGA Edition) and verified for correct functionality.
________________________________________
2. Objectives of the Project
The main objectives of this project are:
•	To design a 16-bit processor architecture using VHDL
•	To implement core processor modules:
o	Program Counter
o	Register File
o	Arithmetic Logic Unit
o	Control Unit
o	Status Flags
•	To verify each module using self-checking testbenches
•	To integrate all modules into a single CPU top module
•	To simulate and analyze processor behavior using ModelSim
•	To understand processor data flow, control flow, and flag generation
________________________________________


3. Tools and Technologies Used
Tool / Technology	Description:
:VHDL	Hardware Description Language
:ModelSim (Intel FPGA 2020.1)	Simulation and waveform analysis
:IEEE Libraries	STD_LOGIC_1164, NUMERIC_STD
:Target Architecture	16-bit Processor
:Design Style	Modular & Structural
________________________________________
4. Overall Processor Architecture
The processor follows a single-cycle, synchronous architecture.
Main Blocks
1.	Program Counter (PC16) – Holds address of current instruction
2.	Control Unit (ControlUnit16) – Decodes opcode and generates control signals
3.	Register File (RegFile16x16) – Stores 16 general-purpose registers
4.	Arithmetic Logic Unit (ALU16) – Performs arithmetic and logical operations
5.	Status Flags – Indicates result conditions (Z, C, N, V)
6.	CPU16 (Top Module) – Integrates all modules
________________________________________
5. Module Descriptions
________________________________________
5.1 Program Counter (PC16)
Function:
The Program Counter stores the address of the current instruction and increments on each clock cycle.
Features:
•	16-bit counter
•	Synchronous increment
•	Asynchronous reset
•	Controlled using pc_inc signal
Verified using: tb_pc16.vhd
________________________________________
5.2 Register File (RegFile16x16)
Function:
Stores operands and intermediate results during execution.
Features:
•	16 registers × 16-bit each
•	Two asynchronous read ports
•	One synchronous write port
•	Write controlled using wr_en
•	Reset clears all registers
Verified using: tb_regfile16x16.vhd
________________________________________
5.3 Arithmetic Logic Unit (ALU16)
Function:
Performs arithmetic and logical operations.
Supported Operations:
alu_op	Operation
0000	    ADD
0001	    SUB
0010    	AND
0011    	OR
________________________________________
5.4 Status Flags
The ALU generates four status flags:
Flag	Description
Z (Zero)	Result equals zero
C (Carry)	Carry out from MSB
N (Negative)	MSB of result = 1
V (Overflow)	Signed arithmetic overflow
Flags are registered in CPU16 to preserve ALU status across clock cycles.
Verified using: Updated tb_alu16.vhd
________________________________________
5.5 Control Unit (ControlUnit16)
Function:
Decodes the opcode field of the instruction and generates control signals.
Opcode Mapping:
Opcode	Instruction	| reg_wr_en	| use_imm	| alu_op
0000	      ADD	          1        	0        0000
0001	      SUB	          1        	0        0001
1000	      ADDI        	1        	1        0000
Others	    NOP          	0        	0        0000
Note: pc_inc is always enabled.
Verified using: tb_controlunit16.vhd

5.6 CPU16 – Top-Level Processor
Function:
Integrates all modules to form a complete processor.
Responsibilities:
•	Instruction decoding
•	Operand selection
•	ALU operation
•	Register write-back
•	Program counter update
•	Status flag storage
Key Outputs:
•	pc_out – Program Counter value
•	debug – Register read data
•	flags_out – Status flags (Z C N V)
Verified using: tb_cpu16.vhd

6. Instruction Format
| 15–12  | 11–8 | 7–4 |    3–0          |
| opcode | Rd   | Rs1 | Rs2 / Immediate |

7. Testbench Strategy
Each module was tested using an independent, self-checking testbench with the following principles:
•	Proper signal initialization (no U values)
•	Clock-synchronized stimulus for sequential blocks
•	Assertions for correctness checking
•	Adequate simulation time
•	Clean waveform observation

Testbenches Implemented
•	tb_pc16.vhd
•	tb_regfile16x16.vhd
•	tb_alu16.vhd
•	tb_controlunit16.vhd
•	tb_cpu16.vhd
________________________________________
8. Simulation Results
Simulation results confirm:
•	Correct ALU operations and flag generation
•	Proper register write and read behavior
•	Correct opcode decoding by control unit
•	Program counter increments every clock cycle
•	CPU executes instructions correctly
•	Invalid opcode treated as NOP
•	Flags reflect ALU result accurately
All waveforms were analyzed using ModelSim, and no functional errors were observed after corrections.
________________________________________
9. Observations and Debugging Experience
During the project, common VHDL issues were identified and resolved:
•	Uninitialized signals causing U values
•	Reset synchronization problems
•	Incorrect VHDL-2002 constructs
•	Missing port connections
•	Insufficient simulation time
  These were corrected using:
•	Proper signal initialization
•	Synchronous reset handling
•	Internal signals instead of reading outputs
•	Clean testbench discipline
________________________________________
10. Applications
•	Educational processor design
•	VHDL learning and practice
•	Foundation for advanced CPU features
•	FPGA-based processor implementation
•	Digital system design labs
________________________________________
11. Limitations
•	No instruction memory
•	No data memory
•	No branching or jump instructions
•	No pipeline or multi-cycle execution
•	PC increments unconditionally
________________________________________
12. Future Enhancements
•	Add instruction memory and data memory
•	Implement branching using status flags
•	Add HALT instruction
•	Introduce pipeline stages
•	Extend instruction set
•	FPGA synthesis and hardware testing
________________________________________
13. Conclusion
This project successfully demonstrates the design and simulation of a 16-bit processor using VHDL. The processor was developed using a modular approach, verified thoroughly using testbenches, and integrated into a functional CPU. The project provides a strong foundation for understanding processor architecture, control logic, and hardware description languages.
________________________________________
14. References
1.	IEEE Standard VHDL Language Reference Manual
2.	ModelSim User Guide – Intel FPGA
3.	Digital Design and Computer Architecture – Harris & Harris
4.	FPGA-based System Design textbooks
