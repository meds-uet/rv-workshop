# Build your own RISC-V Processor in a Day
## Workshop by Maktab e Digital Systems (MEDS)

### Overview
This workshop provides a comprehensive introduction to RISC-V processor design, taking you from basic ISA concepts to a fully functional single-cycle processor implementation in SystemVerilog.

### Prerequisites
- Basic knowledge of SystemVerilog
- Understanding of digital logic design
- Familiarity with simulation tools (ModelSim, Vivado, etc.)

### Learning Objectives
By the end of this workshop, you will be able to:
- Understand RISC-V ISA fundamentals
- Convert C code to RISC-V assembly
- Generate machine code from assembly
- Design a single-cycle processor datapath
- Implement control logic
- Write comprehensive testbenches
- Verify processor functionality

### Workshop Structure (10 hours)

#### Session 1: Introduction to RISC-V (2 hours)
- **Duration**: 2 hours
- **Content**: 
  - What is RISC-V?
  - RISC-V ISA basics
  - Register file and instruction formats
  - Basic RV32I instructions subset

#### Session 2: Assembly Programming (2 hours)
- **Duration**: 2 hours
- **Content**:
  - C to Assembly conversion
  - Hands-on examples
  - Assembly to machine code
  - Creating instruction memory

#### Session 3: Processor Architecture (2 hours)
- **Duration**: 2 hours
- **Content**:
  - Single-cycle datapath design
  - Control unit design
  - Instruction fetch, decode, execute cycle

#### Session 4: RTL Implementation (2 hours)
- **Duration**: 2 hours
- **Content**:
  - SystemVerilog implementation
  - Module-by-module coding
  - Integration techniques

#### Session 5: Verification & Testing (2 hours)
- **Duration**: 2 hours
- **Content**:
  - Testbench development
  - Individual module testing
  - Complete processor verification
  - Debug techniques

### Repository Structure
```
rv-workshop/
├── slides/
│   └── workshop_slides.tex
├── project_(student name)/
│   ├── rtl/
│   │   ├── processor.sv
│   │   ├── datapath.sv
│   │   ├── control_unit.sv
│   │   ├── alu.sv
│   │   ├── register_file.sv
│   │   ├── instruction_memory.sv
│   │   └── data_memory.sv
│   └── testbenches/
│       ├── tb_processor.sv
│       ├── tb_datapath.sv
│       ├── tb_control_unit.sv
│       ├── tb_alu.sv
│       ├── tb_register_file.sv
│       └── tb_memory.sv
├── examples/
│   ├── assembly_examples/
│   ├── c_to_assembly/
│   └── machine_code/
└── README.md
```

### Getting Started

#### Branch Structure
- `main`: Contains this README and general information

#### Setup Instructions
1. Clone the repository:
   ```bash
   git clone https://github.com/your-username/risc-v-workshop.git
   cd risc-v-workshop
   ```

### Supported Instructions
This workshop implements a subset of RV32I instructions:
- **R-type**: `add`, `sub`, `and`, `or`, `xor`, `sll`, `srl`, `sra`, `slt`, `sltu`
- **I-type**: `addi`, `andi`, `ori`, `xori`, `slli`, `srli`, `srai`, `slti`, `sltiu`, `lw`
- **S-type**: `sw`
- **B-type**: `beq`, `bne`, `blt`, `bge`, `bltu`, `bgeu`
- **U-type**: `lui`, `auipc`
- **J-type**: `jal`, `jalr`

### Tools Required
- SystemVerilog simulator (ModelSim, Vivado, Icarus Verilog, etc.)
- Text editor or IDE
- Git

### Workshop Schedule
- **9:00-10:00**: Session 1 - RISC-V Introduction
- **10:00-10:15**: Break
- **10:15-12:15**: Session 2 - Assembly Programming
- **12:15-12:45**: Break
- **12:45-13:45**: Session 3 - Processor Architecture
- **13:45-14:45**: Session 4 - RTL Implementation
- **14:45-15:00**: Break
- **15:00-16:00**: Session 5 - Verification & Testing

### Resources
- [RISC-V ISA Manual](https://riscv.org/technical/specifications/)
- [SystemVerilog Reference](https://www.systemverilog.io/)
- [Workshop Slides](slides/workshop_slides.pdf)

### Troubleshooting
Common issues and solutions:
1. **Simulation errors**: Check signal declarations and module instantiations
2. **Timing issues**: Verify clock and reset signals
3. **Assembly errors**: Check instruction syntax and register usage
4. **Memory issues**: Verify address calculations and data alignment

### Contributing
If you find issues or have improvements, please:
1. Fork the repository
2. Create a feature branch
3. Submit a pull request

### License
This workshop material is provided under the Apache License Version 2.0

### Contact
For questions or support:
- Email: [umershahid@uet.edu.pk]
- GitHub Issues

### Acknowledgments
- RISC-V Foundation for the open ISA specification
- Contributors to the RISC-V ecosystem

---
*Workshop developed by Maktab e Digital Systems (MEDS)*