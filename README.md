# Nano Processor Project – Team 10

## Overview

This repository contains the implementation of a custom 4-bit Nano Processor designed for the **Computer Organization and Digital Design** module in Semester 2. The processor was implemented entirely in **VHDL**, simulated using **Xilinx Vivado 2018**, and practically tested on the **Basys 3 FPGA development board**.

The repository contains two major implementations:

1. **Main Nano Processor** – Basic processor implementation with core datapath and control logic.
2. **Extended Nano Processor** – Enhanced version with additional processor capabilities including a stack unit and expanded ALU operations.

Both implementations are organized into separate branches in the repository.

---

# Team Members

- Selith Rubasinghe
- Shanuka Rathnayake
- Thiseni Rathnayake
- Anuhas Ranasinghe

---

# Development Environment

| Component | Technology |
|---|---|
| Hardware Description Language | VHDL |
| FPGA Board | Basys 3 |
| FPGA Toolchain | Xilinx Vivado 2018 |
| Simulation Method | Behavioral Simulation |
| Architecture Style | Structural + Behavioral Modeling |

---

# Repository Structure

```text
.
├── src/                  # Main VHDL source files
├── sim/                  # Testbench files
├── constraints/          # FPGA pin constraints (Basys 3)
├── scripts/              # Vivado reconstruction scripts
├── README.md
└── .gitignore
```

---

# Nano Processor Architecture

The processor follows a simplified CPU architecture consisting of:

- Program Counter (PC)
- Program ROM
- Instruction Decoder
- Register Bank
- Arithmetic Logic Unit (ALU)
- Multiplexers
- Data Bus
- Control Unit
- Seven Segment Display Interface
- Stack Unit (Extended Version)

The processor is designed as a small educational CPU architecture to demonstrate:

- Instruction execution
- Register-based operations
- Arithmetic datapath design
- Control signal generation
- Conditional branching
- Stack-based memory operations
- FPGA implementation workflow

---

# Processor Specifications

| Feature | Specification |
|---|---|
| Data Width | 4-bit |
| Instruction Width | 12-bit |
| Register Count | 8 Registers |
| Address Width | 3-bit |
| Program Memory Size | 8 Instructions |
| Processor Type | Register-Based Nano Processor |
| Clocking | Synchronous |

---

# Register Architecture

The processor contains 8 general-purpose registers:

| Register | Width |
|---|---|
| R0 | 4-bit |
| R1 | 4-bit |
| R2 | 4-bit |
| R3 | 4-bit |
| R4 | 4-bit |
| R5 | 4-bit |
| R6 | 4-bit |
| R7 | 4-bit |

R7 is commonly used as the final output register in the basic implementation.

---

# Main Nano Processor

## Features

The main implementation contains the core functionality required for a basic nano processor.

### Implemented Components

- 3-bit Program Counter
- 8-word Program ROM
- Instruction Decoder
- 8x4 Register Bank
- 4-bit Ripple Carry Adder
- 4-bit Add/Subtract Unit
- Multiplexer Network
- Seven Segment Display Decoder
- Overflow Detection
- Zero Flag Generation
- Conditional Jump Logic

---

## Datapath Overview

The execution flow in the basic processor is:

```text
Program Counter
       ↓
Program ROM
       ↓
Instruction Decoder
       ↓
Register Selection + Control Signals
       ↓
MUX Network
       ↓
ALU
       ↓
Register Bank Write Back
```

---

## Supported Instructions (Basic Processor)

### 1. MOVI – Move Immediate

Loads an immediate value into a register.

Example:

```text
MOVI R1, 1
```

---

### 2. ADD – Register Addition

Adds two register values.

Example:

```text
ADD R1, R2
```

---

### 3. SUB – Register Subtraction

Subtracts one register from another.

---

### 4. JZR – Jump If Zero

Conditional branch instruction based on the zero flag.

Example:

```text
JZR R0, 6
```

This is used to implement loops and processor halting behavior.

---

## Example Program in ROM

The basic implementation contains a sample hardcoded program in the program ROM:

```text
MOVI R1, 1
MOVI R2, 2
MOVI R3, 3
ADD R1, R2
ADD R1, R3
ADD R7, R1
JZR R0, 6
```

Expected result:

```text
R7 = 6
```

---

# Extended Nano Processor

The extended implementation builds on top of the original processor and introduces several additional architectural features.

---

## Additional Features Added

### Enhanced ALU

The upgraded ALU supports:

| Operation | Description |
|---|---|
| ADD | Addition |
| SUB | Subtraction |
| AND | Bitwise AND |
| OR | Bitwise OR |
| XOR | Bitwise XOR |

The ALU also produces:

- Zero Flag
- Overflow Flag

---

## Stack Unit

One of the major enhancements added to the processor is a dedicated stack implementation.

### Stack Features

- 8-level stack memory
- Stack Pointer (SP)
- PUSH operation
- POP operation
- Stack Full detection
- Stack Empty detection

### Stack Signals

| Signal | Purpose |
|---|---|
| StackWrite | Writes data into stack |
| SP_inc | Increment stack pointer |
| SP_dec | Decrement stack pointer |
| StackFull | Detect stack overflow |
| StackEmpty | Detect empty stack |

---

## Additional Instruction Support

### PUSH

Pushes register data into the stack.

Example:

```text
PUSH R1
```

---

### POP

Pops stack data back into a register.

Example:

```text
POP R3
```

---

### NEG / Negative Related Control

The enhanced decoder introduces additional ALU control logic for more advanced operations and branching conditions.

---

## Extended Processor Execution Example

The ROM program in the extended implementation demonstrates stack operations.

### Program Sequence

```text
MOVI R1, 5
MOVI R2, 3
PUSH R1
PUSH R2
MOVI R3, 0
POP R3
POP R3
JZR R0, 7
```

### Expected Behavior

1. Values 5 and 3 are pushed into the stack.
2. POP retrieves the latest pushed value first.
3. Stack demonstrates LIFO behavior.
4. Processor halts using conditional jump logic.

---

# Major Hardware Modules

## Program Counter

Responsible for storing the current instruction address.

Functions:

- Sequential instruction execution
- Jump address loading
- Reset functionality

---

## Program ROM

Stores hardcoded machine instructions.

Characteristics:

- 8 instruction memory locations
- 12-bit instruction width
- Addressed using 3-bit PC

---

## Instruction Decoder

The control unit of the processor.

Responsibilities:

- Decode opcode fields
- Generate register select signals
- Generate ALU control signals
- Generate jump control signals
- Generate stack control signals
- Select write-back sources

---

## Register Bank

Implements 8 separate 4-bit registers.

Features:

- Synchronous writes
- Multiple register outputs
- Reset support
- Register enable logic

---

## ALU

Performs arithmetic and logical operations.

Core responsibilities:

- Arithmetic execution
- Logic operations
- Zero flag generation
- Overflow handling

---

## Multiplexer Network

The processor uses multiple multiplexers for datapath routing:

| Module | Purpose |
|---|---|
| 2-Way 4-bit MUX | ALU input selection |
| 3-Way 4-bit MUX | Write-back source selection |
| 8-Way 4-bit MUX | Register output selection |

---

## Seven Segment Display Interface

The processor output is mapped to the Basys 3 seven-segment display.

This allows:

- Real-time hardware visualization
- FPGA output verification
- Debugging processor results

---

# Simulation

Behavioral simulations were implemented using dedicated VHDL testbenches.

## Testbench Coverage

| Testbench | Purpose |
|---|---|
| tb_nanoprocessor.vhd | Full processor testing |
| tb_register_bank.vhd | Register bank verification |
| tb_instruction_decoder.vhd | Decoder validation |
| tb_program_counter.vhd | PC functionality |
| tb_add_sub_4bit.vhd | Arithmetic verification |
| tb_stack_unit.vhd | Stack behavior testing |
| tb_program_rom.vhd | ROM instruction validation |

---

# FPGA Implementation

The processor was synthesized and tested on the Basys 3 FPGA board.

## Hardware Verification

The following were verified on hardware:

- Register output behavior
- Arithmetic correctness
- Conditional jump execution
- Seven segment output
- Stack push/pop operations
- Clock synchronization
- Reset behavior

---

# Design Methodology

The project combines both:

- Structural VHDL Modeling
- Behavioral VHDL Modeling

This approach was used to:

- Improve modularity
- Simplify debugging
- Support hierarchical hardware design
- Enable independent component testing

---

# Educational Concepts Demonstrated

This project demonstrates several core digital design and computer architecture concepts:

- Processor datapath construction
- Control signal generation
- Finite hardware modularization
- Register transfer operations
- FPGA synthesis flow
- Instruction execution cycle
- Conditional branching
- Stack memory implementation
- ALU design
- Multiplexer-based routing
- Hardware simulation and verification

---

# Future Improvements

Potential future extensions include:

- Larger instruction memory
- Data memory support
- Load/store instructions
- Pipelining
- Interrupt handling
- Call/return instructions
- Expanded ALU operations
- UART debugging interface
- VGA or LCD output
- Cache memory support

---

# Conclusion

This project successfully implements a functional educational nano processor architecture using VHDL. The basic implementation demonstrates the fundamental concepts of processor design, while the extended implementation introduces more advanced architectural features such as logical ALU operations and stack-based execution.

The project provides practical experience in:

- Computer architecture
- FPGA-based digital design
- Hardware simulation
- Processor datapath development
- Control logic implementation
- Hardware debugging and testing

The implementation was successfully simulated in Vivado 2018 and verified on the Basys 3 FPGA platform.
