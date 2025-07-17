# Directories
RTL_DIR       := project/rtl
TB_DIR        := project/test
BUILD_DIR     := build

# Files
# DESIGN_FILES  := $(wildcard $(RTL_DIR)/*.sv)
# TB_FILES      := $(wildcard $(TB_DIR)/*.sv)
DESIGN_FILES  := $(wildcard $(RTL_DIR)/alu.sv)
TB_FILES      := $(wildcard $(TB_DIR)/tb_alu.sv)

# Tools
VLOG          := vlog
VSIM          := vsim

# Top module
TOP_MODULE    := tb_alu

# Simulation flags (ENABLE VCD DUMPING)
VSIM_FLAGS    := -c -do "run -all; quit -f" -voptargs="+acc" +vcdfile=$(VCD_FILE)

# Default target
all: run

# Compile RTL & Testbench (with SystemVerilog support)
compile:
	@if [ ! -d $(BUILD_DIR) ]; then mkdir -p $(BUILD_DIR); fi
	$(VLOG) -work $(BUILD_DIR) +acc -sv $(DESIGN_FILES) $(TB_FILES)

# Run simulation (force VCD dump)
sim: compile
	$(VSIM) -work $(BUILD_DIR) $(VSIM_FLAGS) $(TOP_MODULE)


# Full flow: compile → simulate
run: clean sim

# Clean build artifacts
clean:
	rm -rf $(BUILD_DIR) transcript *.vcd *.wlf *.png *.pgm *.txt
