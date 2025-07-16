# Build your own RISC-V Processor in a Day
## Workshop by Maktab e Digital Systems (MEDS)

---

### Overview
This workshop provides a comprehensive hands-on introduction to RISC-V processor design. By the end of the day, you will have implemented and verified a working RV32I single-cycle processor in SystemVerilog.

---

### Prerequisites
- Basic SystemVerilog syntax
- Digital logic fundamentals (datapath, control)
- Familiarity with simulation tools (ModelSim, Vivado, Icarus Verilog, or EDAPlayground)

---

### 🧠 Learning Objectives
By the end of this workshop, you will be able to:
- Understand the RISC-V ISA (RV32I subset)
- Convert C code to RISC-V assembly and machine code
- Build a single-cycle processor datapath and control logic
- Simulate and verify processor behavior
- Write SystemVerilog testbenches

---

### 🏗️ Workshop Structure (10 Hours)

#### ⌛ Session Breakdown

| Time Slot        | Session                             | Content Summary                                      |
|------------------|-------------------------------------|------------------------------------------------------|
| 09:00 – 10:00    | Session 1 – RISC-V Introduction     | ISA basics, formats, instruction types               |
| 10:00 – 10:15    | Break                               |                                                      |
| 10:15 – 12:15    | Session 2 – Assembly Programming    | C to ASM, machine code, instruction memory           |
| 12:15 – 12:45    | Break                               |                                                      |
| 12:45 – 13:45    | Session 3 – Processor Architecture  | Datapath, control unit, signal flow                  |
| 13:45 – 14:45    | Session 4 – RTL Implementation      | RTL modules, integration, signal wiring              |
| 14:45 – 15:00    | Break                               |                                                      |
| 15:00 – 16:00    | Session 5 – Verification & Testing  | Testbenches, module testing, debugging techniques    |

---


###  Repository Structure
```

rv-workshop/
├── slides/
│   └── workshop\_slides.tex / .pdf
├── project\_(student\_name)/
│   ├── rtl/
│   │   ├── riscv\_processor.sv
│   │   ├── alu.sv
│   │   ├── branch\_unit.sv
│   │   ├── control.sv
│   │   ├── immgen.sv
│   │   ├── imem.sv
│   │   ├── dmem.sv
│   │   ├── pc.sv
│   │   └── register\_file.sv
│   └── testbenches/
│       ├── tb\_alu.sv
│       ├── tb\_register\_file.sv
│       ├── tb\_control.sv
│       ├── tb\_dmem.sv
│       ├── tb\_imem.sv
│       └── tb\_processor.sv
├── examples/
│   ├── assembly\_examples/
│   ├── c\_to\_assembly/
│   └── machine\_code/
└── README.md

````
> 📁 Each student should **rename** their folder to `project_<yourname>` before submission.

---

### Getting Started

#### Clone the repository
```bash
git clone https://github.com/meds-uet/rv-workshop.git
cd risc-v-workshop
````

---

### Running Simulations

#### ModelSim / QuestaSim

```tcl
vlog rtl/*.sv testbenches/tb_processor.sv
vsim tb_processor
run -all
```

#### 🐧 Icarus Verilog (iverilog)

```bash
iverilog -g2012 -o processor_tb rtl/*.sv testbenches/tb_processor.sv
vvp processor_tb
```

#### 🌐 EDAPlayground (Online)

To run on [EDAPlayground](https://www.edaplayground.com/):

1. Visit: [https://www.edaplayground.com/](https://www.edaplayground.com/)
2. Select **SystemVerilog (IEEE 1800-2012)** as language
3. Choose simulator: **Synopsys VCS**, **ModelSim**, or **Icarus Verilog**
4. Paste RTL code into the **left code editor** (create multiple tabs for each `.sv`)
5. Paste the corresponding testbench in the **right-hand testbench editor**
6. Click **"Run"**

> 💡 You can also use EDAPlayground's "Add Design File" button to organize modules.

---

### Student Tasks

During the workshop, you will:

* Complete the **skeleton RTL modules**
* Fill in missing logic in `alu`, `immgen`, `control`, and more
* Write or modify testbenches to test individual modules
* Run simulations and validate outputs
* Debug and improve your design

---

### Submission Checklist

Ensure the following before submission:

* [ ] All RTL modules compile and simulate correctly
* [ ] Testbenches verify core instructions
* [ ] Register file and memory behaviors are tested
* [ ] Your project folder is renamed to `project_<yourname>`
* [ ] You’ve tested at least 5 instructions end-to-end

---

### Supported RV32I Instructions

#### R-type:

`add`, `sub`, `and`, `or`, `xor`, `sll`, `srl`, `sra`, `slt`, `sltu`

#### I-type:

`addi`, `andi`, `ori`, `xori`, `slli`, `srli`, `srai`, `slti`, `sltiu`, `lw`

#### S-type:

`sw`

#### B-type:

`beq`, `bne`, `blt`, `bge`, `bltu`, `bgeu`

#### U-type:

`lui`, `auipc`

#### J-type:

`jal`, `jalr`

---

### Tools Required

* SystemVerilog simulator (ModelSim, Vivado, Icarus Verilog, or EDAPlayground)
* Code editor or IDE (VSCode, Sublime, etc.)
* Git (optional but recommended)

---

### 📚 Resources

* [RISC-V ISA Manual (Unprivileged)](https://riscv.org/technical/specifications/)
* [SystemVerilog Reference](https://www.systemverilog.io/)
* [EDAPlayground](https://www.edaplayground.com/)
* [Workshop Slides (PDF)](slides/workshop_slides.pdf)

---

### 🧩 Troubleshooting

| Issue                | Possible Cause        | Suggested Fix                            |
| -------------------- | --------------------- | ---------------------------------------- |
| ❌ Simulation error   | Missing wires/ports   | Double-check module interfaces           |
| ❌ Unexpected output  | Wrong control signals | Debug `control.sv`, verify testbench     |
| ❌ No register update | x0 register written   | Ensure `wa != 5'b00000` in register file |
| ❌ PC stuck           | PC not updating       | Verify reset & clock logic in `pc.sv`    |

---

### 🤝 Contributing

Found a bug or want to improve?

1. Fork the repo
2. Create a branch (`feature/my-fix`)
3. Submit a pull request

---

### 📜 License

This project is licensed under the **Apache License 2.0**. See `LICENSE` file for details.

---

### 📬 Contact

* **Instructor**: [Umer Shahid](mailto:umershahid@uet.edu.pk)
* **GitHub Issues**: Please raise questions or report issues on the workshop repo

---

### 🙏 Acknowledgments

* RISC-V International for the open architecture
* SystemVerilog and open-source tool communities
* Contributors and mentors who reviewed this material

---

*Workshop developed with ❤️ by Maktab e Digital Systems (MEDS)*

