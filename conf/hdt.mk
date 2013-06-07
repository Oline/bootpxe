############################################################################################
########################## HDT (Hardware Detection Tool) ###################################
############################################################################################

CUR_VER=052
VER_052_URL=http://www.hdt-project.org/raw-attachment/wiki/hdt-0.5.0/hdt_0_5_2.c32
VER_052_LOCAL_NAME=hdt.c32

############################################################################################

hdt_help:
	@echo "############################################################################################"
	@echo "### HDT (Hardware Detection Tool)"
	@echo "############################################################################################"
	@echo ""
	@echo "Preparation directives for HDT (Hardware Detection Tool)"
	@echo ""
	@echo "HDT (for 'Hardware Detection Tool') is a Syslinux com32 module designed to display low-level information for any x86 compatible system."
	@echo ""
	@echo "If you want to install another version, you may use hdtXXX_ACTION patern, where XXX is the version number: 0.5.2 -> 052"
	@echo ""
	@echo "Available version: 052"
	@echo ""
	@echo "hdt_init: create the initial directory structure in the tftp server root directory"
	@echo "hdt_get: create the initial directory structure in the tftp server root directory"
	@echo "hdt_clean: create the initial directory structure in the tftp server root directory"
	@echo "hdt_distclean: create the initial directory structure in the tftp server root directory"
	@echo ""

hdt: hdt$(CUR_VER)

hdt_init: hdt$(CUR_VER)_init

hdt_get: hdt$(CUR_VER)_get

hdt_clean: hdt$(CUR_VER)_clean

hdt_distclean: hdt$(CUR_VER)_distclean

############################################################################################
### Online documentation used to build/understand this file
############################################################################################

hdt_doc:
	@echo "http://www.hdt-project.org/"

############################################################################################
### Version 052
############################################################################################

hdt052: hdt052_init hdt052_get

# hdt052_serial:

# hdt052_vga: hdt052_init hdt052_get

hdt052_init:
	mkdir -p $(DIR_TFTP_TOOLS)/hdt/version_052/

hdt052_get: hdt052_init
# may add a check here if any file already exist, warn about it and don't do anything
	wget -O $(DIR_TFTP_TOOLS)/hdt/version_052/$(VER_052_LOCAL_NAME) $(VER_052_URL)

hdt052_clean:
	rm -f $(DIR_TFTP_TOOLS)/hdt/version_052/$(VER_052_LOCAL_NAME)

hdt052_distclean: hdt052_clean
	rmdir $(DIR_TFTP_TOOLS)/hdt/version_052/
# should find a way to clean the top level if no version at all are distcleaned

############################################################################################
