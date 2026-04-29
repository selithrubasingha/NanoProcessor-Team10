

## `full_adder.vhd`

* __Description__: A single-bit full adder.  


* __Inputs__: A, B, Cin (each 1 bit).  


* __Outputs__: Sum, Cout (each 1 bit).  

* __What it does__: Performs standard 1-bit binary addition. It adds two individual bits (A and B) along with a carry-in bit (Cin), outputting the resulting binary Sum and pushing any overflow to the Cout (carry-out) pin.

This code perfectly follows the blueprint for your Layer 2 components, but there is one small typo in your port map based on the `rca_4bit` file we fixed earlier. 

In your `rca_4bit` instantiation, you mapped `C3 => open`. However, we named that output port `Overflow`, not `C3`. You just need to change that line to `Overflow => open` so Vivado doesn't throw a "port not found" error.



## **`adder_3bit.vhd`**
* **Description:** A 3-bit adder used exclusively to increment the Program Counter by 1[cite: 248].
* **Inputs:** `A(2:0)`, `B(2:0)`[cite: 250].
* **Outputs:** `Sum(2:0)`[cite: 251].
* **What it does:** Instantiates the existing `rca_4bit` module with a hardwired `Cin = '0'`[cite: 253]. It pads the 3-bit inputs with a leading zero to satisfy the 4-bit port requirements, computes the sum, and outputs only the lower 3 bits while ignoring any carry or overflow[cite: 254].


## **`rca_4bit.vhd`**
* **Description:** A 4-bit Ripple Carry Adder.
* **Inputs:** `A(3:0)`, `B(3:0)`, `Cin`.
* **Outputs:** `Sum(3:0)`, `Cout`, `C3`.
* **What it does:** Performs 4-bit binary addition by chaining four 1-bit full adders together. It passes the carry bit through each stage and deliberately exposes the carry out of the 3rd bit (`C3`) alongside the final carry out (`Cout`) to support downstream signed overflow calculation.

## **`add_sub_4bit.vhd`**
* **Description:** A 4-bit Arithmetic Logic Unit (ALU) capable of signed 2's complement addition and subtraction.
* **Inputs:** `A(3:0)`, `B(3:0)`, `AddSub`.
* **Outputs:** `Result(3:0)`, `Overflow`, `Zero`.
* **What it does:** Computes $A + B$ or $A - B$ based on the `AddSub` control signal. Subtraction is performed by taking the 2's complement of B (inverting B via XOR and passing `AddSub` into the carry-in of the underlying RCA). It also actively checks the result to assert a `Zero` flag and compares internal carry signals to assert a signed `Overflow` flag.


## **`d_flip_flop.vhd`**
* **Description:** A single-bit D flip-flop with an asynchronous active-high reset and a load/enable signal [cite: 202-203].
* **Inputs:** `D`, `Clk`, `Reset`, `Enable`[cite: 205].
* **Outputs:** `Q`[cite: 205].
* **What it does:** Acts as a 1-bit memory cell. On the rising edge of the clock, if `Enable` is '1', it latches the input `D` to the output `Q`[cite: 207, 209]. If `Reset` is asserted at any time, it immediately clears `Q` to '0' regardless of the clock[cite: 208]. If neither happens, it holds its current value[cite: 210].


## **`register_4bit.vhd`**
* **Description:** A 4-bit parallel-load register.
* **Inputs:** `D(3:0)`, `Clk`, `Reset`, `Enable`.
* **Outputs:** `Q(3:0)`.
* **What it does:** Instantiates four 1-bit D flip-flops that share common Clock, Reset, and Enable lines to synchronously store a 4-bit word.

## **`register_bank.vhd`**
* **Description:** The complete register file containing eight 4-bit registers (R0-R7).
* **Inputs:** `D(3:0)`, `RegSel(2:0)`, `RegEn`, `Clk`, `Reset`.
* **Outputs:** `R0(3:0)` through `R7(3:0)`.
* **What it does:** Uses a 3-to-8 decoder to route the master write enable signal to the correct target register. Instantiates seven `register_4bit` modules for R1-R7. Register R0 is hardwired to output "0000" and its write-enable is permanently disabled to serve as a constant zero source for NEG and JZR instructions.

## **`program_rom.vhd`**
* **Description:** Read-only memory storing the hardcoded 12-bit instruction sequence.
* **Inputs:** `Addr(2:0)`.
* **Outputs:** `Instruction(11:0)`.
* **What it does:** Acts as a pure combinational lookup table. Takes a 3-bit address from the Program Counter and outputs the corresponding 12-bit machine code instruction. Contains the hardcoded assembly to calculate the sum of integers 1 through 3.

## **`program_counter.vhd`**
* **Description:** A 3-bit register that tracks the current instruction address.
* **Inputs:** `NextAddr(2:0)`, `Clk`, `Reset`.
* **Outputs:** `CurrAddr(2:0)`.
* **What it does:** Built from three D flip-flops with their enable pins permanently tied high. On every rising clock edge, it latches the next instruction address. An asynchronous reset clears the counter to "000" to restart the program.



## **`decoder_2to4.vhd`**
* **Description:** A 2-to-4 binary decoder with an active-high enable.
* **Inputs:** `I(1:0)`, `EN`.
* **Outputs:** `Y(3:0)`.
* **What it does:** When enabled, translates a 2-bit binary input into a 4-bit one-hot output. If disabled, all outputs remain zero. Used structurally as a sub-component.

## **`decoder_3to8.vhd`**
* **Description:** A 3-to-8 binary decoder.
* **Inputs:** `A(2:0)`.
* **Outputs:** `Y(7:0)`.
* **What it does:** Structurally combines two 2-to-4 decoders to translate a 3-bit input into an 8-bit one-hot output. It derives internal enable signals using the Most Significant Bit (`A(2)`). Used to select the target register for write operations.

## **`mux_2way_3bit.vhd`**
* **Description:** A 2-way, 3-bit multiplexer.
* **Inputs:** `A(2:0)`, `B(2:0)`, `Sel`.
* **Outputs:** `Y(2:0)`.
* **What it does:** Routes one of two 3-bit inputs to the output based on the `Sel` pin. Used primarily to determine the next address for the Program Counter (sequential execution vs. jump execution).

## **`mux_2way_4bit.vhd`**
* **Description:** A 2-way, 4-bit multiplexer.
* **Inputs:** `A(3:0)`, `B(3:0)`, `Sel`.
* **Outputs:** `Y(3:0)`.
* **What it does:** Routes one of two 4-bit inputs to the output. Sits before the Register Bank to select between storing an ALU calculation result (`A`) or an immediate value (`B`).

## **`mux_8way_4bit.vhd`**
* **Description:** An 8-way, 4-bit multiplexer.
* **Inputs:** `I0(3:0)` through `I7(3:0)`, `Sel(2:0)`.
* **Outputs:** `Y(3:0)`.
* **What it does:** Uses a 3-bit select signal to route one of the eight register outputs into a single 4-bit data stream. Two instances are used to feed the A and B operands into the Arithmetic Logic Unit.



## **`instruction_decoder.vhd`**
* **Description:** The central control unit of the nanoprocessor.
* **Inputs:** `Instruction(11:0)`, `Zero`.
* **Outputs:** `RegSel(2:0)`, `RegEn`, `MuxA_Sel(2:0)`, `MuxB_Sel(2:0)`, `AddSub`, `ImmVal(3:0)`, `ImmMuxSel`, `JumpFlag`, `JumpAddr(2:0)`.
* **What it does:** Uses purely combinational logic to decode the 12-bit machine instruction. Extracts opcodes, register addresses, and immediate values, and generates the exact control signals required to configure the multiplexers, ALU, and register bank for the current clock cycle. Handles conditional jump logic by evaluating the ALU Zero flag.

## **`nanoprocessor.vhd`**
* **Description:** The top-level structural entity that integrates all sub-systems into a complete 4-bit microprocessor.
* **Inputs:** `Clk`, `Reset`.
* **Outputs:** `R7_Out(3:0)`, `Overflow`, `ZeroFlag`.
* **What it does:** Contains no internal behavioral logic. Instead, it declares internal signal buses and instantiates all Level 3 and Level 2 architectural modules (PC, ROM, Instruction Decoder, Register Bank, ALU, and Muxes), wiring their ports together to establish the complete processor datapath according to the high-level system diagram. Connects final R7 and flag outputs to physical board pins.


---

###  Detailed Explanations of the two High level components

#### 1. `instruction_decoder.vhd` (The Brain)
**The Inputs**
* **`Instruction` (12 bits):** The raw line of code coming from the ROM.
* **`Zero` (1 bit):** The error flag coming from the math unit, letting the decoder know if the last calculation (or register check) resulted in exactly `0000`.

**The Outputs**
* Nine separate control wires (like `RegEn`, `MuxA_Sel`, `JumpFlag`, etc.) that fan out across the entire processor to toggle switches and enable memory banks.

**The Logic**
This is purely combinational logic[cite: 519]. It uses aliases to slice the 12-bit instruction into smaller, readable chunks (Opcode, Register A, Register B, etc.). 
Inside the process, it looks strictly at the 2-bit `Opcode`. Based on those two bits, it locks in a specific "state" for the entire processor. For example, if it sees `10` (MOVI), it forcefully flips the `ImmMuxSel` switch to `1` so the immediate value bypasses the math unit, and it sends the `RegEn` signal to the Register Bank so the data is actually saved. If it sees `11` (JZR), it kills the `RegEn` switch so no memory gets overwritten, and checks the `Zero` flag to see if it needs to trigger the `JumpFlag`.

#### 2. `nanoprocessor.vhd` (The Top-Level Skeleton)
**The Inputs**
* **`Clk` & `Reset`:** The master timing and clear buttons wired to the physical board pushbuttons/oscillators.

**The Outputs**
* **`R7_Out` (4 bits):** Wired directly to the physical LEDs (LD0-LD3) to show the final answer.
* **`Overflow` & `ZeroFlag` (1 bit each):** Wired to LD15 and LD14 to show the status of the math unit.

**The Logic**
This file has absolutely no mathematical or behavioral logic of its own [cite: 429-430]. It acts exclusively as a circuit board. 
It declares internal `signals` which act as copper traces routing data between components. Then, it instantiates every single sub-system you've built (the PC, the ROM, the ALU, the Register Bank, the Muxes) and maps those internal signals to the correct input/output ports. This is where the processor physically comes together and data flows sequentially from the ROM, through the Decoder, into the ALU, and finally rests in the Register Bank [cite: 442-453].

---
