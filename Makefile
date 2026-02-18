# Makefile for running GHDL simulations of tb unit tests

SRCDIR = rtl
TBDIR = tb
WRKDIR = bin

GHDL = ghdl
STD = 08
GHDLFLAGS = --std=$(STD) --workdir=$(WRKDIR)

VHDL_SRCS = $(SRCDIR)/types_pkg.vhd $(filter-out $(SRCDIR)/types_pkg.vhd,$(wildcard $(SRCDIR)/*.vhd)) $(wildcard $(SRCDIR)/*/*.vhd)
VHDL_TB = $(wildcard $(TBDIR)/*.vhd)

.PHONY: all analyze sim alu_tb exec_tb clean

all: sim

analyze:
	$(GHDL) -a $(GHDLFLAGS) $(VHDL_SRCS) $(VHDL_TB)

alu_tb: analyze
	$(GHDL) -e $(GHDLFLAGS) -o $(WRKDIR)/ALU_tb ALU_tb 
	./$(WRKDIR)/ALU_tb --vcd=$(TBDIR)/ALU_tb.vcd --stop-time=200ns

exec_tb: analyze
	$(GHDL) -e $(GHDLFLAGS) -o $(WRKDIR)/execution_stage_tb execution_stage_tb 
	./$(WRKDIR)/execution_stage_tb --vcd=$(TBDIR)/execution_stage_tb.vcd --stop-time=200ns

RAM_tb: analyze
	$(GHDL) -e $(GHDLFLAGS) -o $(WRKDIR)/DP_RAM_tb DP_RAM_tb 
	./$(WRKDIR)/DP_RAM_tb --vcd=$(TBDIR)/DP_RAM_tb.vcd --stop-time=200ns

sim: alu_tb exec_tb RAM_tb

clean:
	rm -rf $(WRKDIR)/*
	rm -f *.cf *.vcd $(TBDIR)/*.vcd *.o

