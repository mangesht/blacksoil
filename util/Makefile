
# Relative path pointing to top of tree.
COMMONDIR = kxDvCommon
# Search for top path.  Top path is TOP/${COMMONDIR}.
TOP = ${shell \
	perl -e '\
		use File::Basename; \
		use Cwd; \
		$$localCurrPath = cwd (); \
		$$dotPath = "."; \
		while (-e "$$localCurrPath/${COMMONDIR}" == 0) { \
			$$dotPath = $$dotPath."/.."; \
			$$localCurrPath = dirname ($$localCurrPath); \
			if ("$$localCurrPath" eq "/") { exit 0; } \
		} \
		print $$dotPath; \
	' }
include ${TOP}/${COMMONDIR}/include/makefile.inc

MOD_TOP = .

chip := dhlags
Chip = $(shell echo $(chip) | tr du DU)
CHIP = $(shell echo $(chip) | tr '[a-z]' '[A-Z]')
dir := egr
Dir = $(shell echo $(dir) | tr ei EI)
DIR = $(shell echo $(dir) | tr '[a-z]' '[A-Z]')
layer := l2
LAYER = $(shell echo $(layer) | tr '[a-z]' '[A-Z]')
port := 48
skipNbyte := 0 004      
runtchk := 1
numOfEt := 7
ip := 0
addrWidth :=27
cpuAddrWidth :=27

all: rms_lib rtl env rms_ral ref_mdl

all_no_refmdl: rms_lib rtl env rms_ral 

standalone: rms_lib rtl_sa env rms_ral ref_mdl 

standalone_no_refmdl: rms_lib rtl_sa env rms_ral 

rms_lib:
	cd $(TOP)/k15DvCommon/c/src; gmake;

ref_mdl:
	cd $(MOD_TOP)/dv/sc/src; \
	if [ "$(dir)" == "egr" ]; then\
	gmake chip=$(chip) dir=$(dir) layer=$(layer) skip_byte=$(skipNbyte); \
	fi; \
	if [ "$(dir)" == "igr" ]; then\
	gmake chip=$(chip) dir=$(dir) layer=$(layer) skip_byte=$(skipNbyte); \
	fi;

env:
	cd $(MOD_TOP)/dv/sv/env/ags; gmake chip=$(chip) dir=$(dir) layer=$(layer) skip_byte=$(skipNbyte);

rtl: ./Makefile
	if [ "$(dir)" == "egr" ]; then\
	cd $(MOD_TOP)/design/top/rtl; gmake build chip=$(chip) ip=$(ip) layer=$(LAYER) port=$(port) Mod=$(Dir) addrWidth=$(addrWidth) cpuAddrWidth=$(cpuAddrWidth) egrBaseAddr=0x0  igrBaseAddr=0x900000 skipNbyte=$(skipNbyte) runtchk=$(runtchk); \
	fi; \
	if [ "$(dir)" == "igr" ]; then\
	cd $(MOD_TOP)/design/top/rtl; gmake build  chip=$(chip) ip=$(ip) layer=$(LAYER) port=$(port) Mod=$(Dir) addrWidth=$(addrWidth) cpuAddrWidth=$(cpuAddrWidth) egrBaseAddr=0x900000 igrBaseAddr=0x0 skipNbyte=$(skipNbyte) runtchk=$(runtchk); \
	fi;

rtl_sa: 
	if [ "$(dir)" == "egr" ]; then\
        cd $(MOD_TOP)/design/doc/Registers; gmake chip=$(chip) ip=$(ip) layer=$(LAYER) port=$(port) Mod=$(Dir) addrWidth=$(addrWidth) cpuAddrWidth=$(cpuAddrWidth) egrBaseAddr=0x0 igrBaseAddr=0x900000; \
        fi; \
        if [ "$(dir)" == "igr" ]; then\
        cd $(MOD_TOP)/design/doc/Registers; gmake chip=$(chip) ip=$(ip) layer=$(LAYER) port=$(port) Mod=$(Dir) addrWidth=$(addrWidth) cpuAddrWidth=$(cpuAddrWidth) egrBaseAddr=0x900000 igrBaseAddr=0x0; \
        fi;

rms_ral:
	cd $(MOD_TOP)/dv/rms; gmake chip=$(chip) layer=$(layer) ip=$(ip);

clean:
	cd $(MOD_TOP)/dv/rms; gmake clean
	cd $(MOD_TOP)/dv/sc/src; gmake clean
	cd $(MOD_TOP)/dv/sv/env/ags; gmake clean
	cd $(MOD_TOP)/design/top/rtl; gmake clean
	cd $(MOD_TOP)/design/doc/Registers; gmake clean
