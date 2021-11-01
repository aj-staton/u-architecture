# RISC-V Microarchitecture

Implements a 32-bit RISC-V processor with a three stage pipeline, using a subset of the RV32I instruction set. Project was used 
in CSCE 611, Advanced Digital Design, at the University of South Carolina.

The three stages of the pipeline are broken up into:
 * Instrucion Fetch
 * Instruction Decoding, Memory Read, and Execute
 * Memory Write

This design was broken up into components: the ALU, Control Unit, Memory and Instruction Decoder. All of these
are tied together in `rtl/cpu.sv`. The CPU was finalized by using it to run an assembly program `bin2dec.asm`, which
converted a binary input to decimal, then wrote the decimal output to 8-bit hex displays using control and status registers. 

# Installation
This project depends on Go (for the simulated hardware), Python 3, C, Cpp, and Verilator. Execute the CPU
with:

```bash
make gui # Runs `program.rom` and pulls up the simulated hardware
```
```bash 
make test # Runs end-to-end tests
```
```bash
make testbench # Synthesizes the testbenches and runs them
```

## Testing
Components of the CPU were much easier to test exhausively than the full, 32-bit processor. These component tests (and thier 
associated vectors) are kept in `testbench/`. End-to-end the CPU involved writing assembly to test 
each instruction, along with an associated final output vector for each register in memory. These small programs
are found inside the Python scripts in `tests/`. 

### Credit
This course was taught by Dr. Jason. D. Bakos in the Fall of 2021; the Teaching Assistants 
were Charles Daniels and Philip Conrad. The simulated hardware, configs, interfaces, ALU and 32x32-bit
memory vectors were provided as course materials.
