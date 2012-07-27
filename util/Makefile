# $Id: Makefile,v 1.30 2010/08/28 16:57:38 sumsangh Exp $
#
# $Log: Makefile,v $
# Revision 1.30  2010/08/28 16:57:38  sumsangh
# pass runtchk parameter to the gmake build
#
# Revision 1.29  2010/08/26 12:54:04  mduntoor
# Added no of ET parameter to the makefile
#
# Revision 1.28  2010/08/26 08:03:55  mkujur
# pass skipnbyte to env also
#
# Revision 1.27  2010/08/26 07:51:35  mkujur
# pass skip byte to refMdl
#
# Revision 1.26  2010/08/26 07:45:22  mkujur
# skip byte default = 2
#
# Revision 1.25  2010/08/17 05:54:51  mduntoor
# Made skipNbyte as zero by default
#
# Revision 1.24  2010/08/16 09:29:02  mkujur
# added mode excluding rms compilation
#
# Revision 1.23  2010/08/13 10:55:52  mduntoor
# Passing of opaque hdr length
#
# Revision 1.22  2010/08/11 11:31:26  mkujur
# merge chip ip changes for argus tb evo release
#
# Revision 1.21  2010/08/10 08:15:06  mkujur
# ral updates for ip integration into chip
#
# Revision 1.20  2010/08/05 05:30:34  mduntoor
# Enable runt checking by default
#
# Revision 1.19  2010/07/23 13:58:38  mduntoor
# Added 'runtchk' variable. This controls the addition of runt checking logic in argus rtl code
#
# Revision 1.18  2010/07/21 05:17:24  mkujur
# ipp removed, only isp exists
#
# Revision 1.17  2010/07/20 11:45:44  sumsangh
# added parameters addrWidth and cpuAddrWidth
#
# Revision 1.16  2010/07/09 17:37:39  mkujur
# fix for shared obj refm
#
# Revision 1.15  2010/07/06 08:33:02  mkujur
# updates for chip integration
#
# Revision 1.14  2010/06/28 10:06:14  udy
# Modified and cleaned for dv_standalone mode
#
# Revision 1.13  2010/06/21 09:33:37  mkujur
# updated clean
#
# Revision 1.12  2010/06/10 08:54:01  sumsangh
#  added ip variable should set this to 1 when compiling from ups or dhl directory
#
# Revision 1.11  2010/05/25 10:45:47  udy
# Corrected typo.
#
# Revision 1.10  2010/05/25 09:15:14  mkujur
# added standalone mode
#
# Revision 1.9  2010/05/20 04:55:57  mkujur
# lib & tools
#
# Revision 1.8  2010/05/10 09:30:34  jporia
# Modified for error.
#
# Revision 1.7  2010/05/10 08:29:56  jporia
# Added baseaddress for rtl compilation.
#
# Revision 1.6  2010/05/10 04:59:07  jporia
# Removed copy of fifo locally.
#
# Revision 1.5  2010/04/30 11:02:54  jporia
# Corrected makefile.
#
# Revision 1.4  2010/04/29 18:05:17  mkujur
# update rtl make
#
# Revision 1.3  2010/04/29 14:31:34  mkujur
# chip support
#
# Revision 1.2  2010/03/23 08:31:34  udy
# removed calling dv/rms make file recursively
#
# Revision 1.1  2009/10/25 18:51:57  mkujur
# initial rev
#
# Revision 1.1  2009/02/05 21:15:14  yandra
# Top level makefile for ups.
#
#


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
