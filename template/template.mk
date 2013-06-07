############################################################################################
################################# Template Name ############################################
############################################################################################

CUR_VER=2

template_help:
	@echo "############################################################################################"
	@echo "### Template"
	@echo "############################################################################################"
	@echo ""
	@echo "Preparation directives for Template 2"
	@echo ""
	@echo "If you want to install another version, you may use templateX_ACTION patern, where X is the version number: 1 or 2"
	@echo ""
	@echo "Available version: 1, 2"
	@echo ""
	@echo "template_init: create the initial directory structure in the tftp server root directory"
	@echo "template_get: create the initial directory structure in the tftp server root directory"
	@echo "template_clean: create the initial directory structure in the tftp server root directory"
	@echo "template_distclean: create the initial directory structure in the tftp server root directory"
	@echo ""

template: template$(CUR_VER)

template_init: template$(CUR_VER)_init

template_get: template$(CUR_VER)_get

template_clean: template$(CUR_VER)_clean

template_distclean: template$(CUR_VER)_distclean

############################################################################################
### Online documentation used to build/understand this file
############################################################################################

template_doc:
	@echo "http://www.example.com/template.pdf"


############################################################################################
### Version 2
############################################################################################

template2: template2_init template2_get

# template2_serial:

# template2_vga: template2_init template2_get

template2_init:
	mkdir -p $(DIR_TFTP_DISTRIB)/template/version2/

template2_get: template2_init
# may add a check here if any file already exist, warn about it and don't do anything
	wget -O $(DIR_TFTP_DISTRIB)/template/version2/kernel http://ftp.template.org/pub/x86/pxeboot
	wget -O $(DIR_TFTP_DISTRIB)/template/version2/ramdisk http://ftp.template.org/pub/x86/disk.rd
	wget -O $(DIR_TFTP_DISTRIB)/template/version2/kernel64 http://ftp.template.org/pub/x86_64/pxeboot
	wget -O $(DIR_TFTP_DISTRIB)/template/version2/ramdisk64 http://ftp.template.org/pub/x86_64/disk64.rd

template1_clean:
	rm -f $(DIR_TFTP_DISTRIB)/template/version2/kernel
	rm -f $(DIR_TFTP_DISTRIB)/template/version2/ramdisk
	rm -f $(DIR_TFTP_DISTRIB)/template/version2/kernel64
	rm -f $(DIR_TFTP_DISTRIB)/template/version2/ramdisk64

template2_distclean: template2_clean
	rmdir $(DIR_TFTP_DISTRIB)/template/version2/
# should find a way to clean the top level if no version at all are distcleaned

############################################################################################
### Version 1
############################################################################################

template1: template1_init template1_get

# template1_serial:

# template1_vga: template1_init template1_get

template1_init:
	mkdir -p $(DIR_TFTP_DISTRIB)/template/version1/

template1_get: template1_init
# may add a check here if any file already exist, warn about it and don't do anything
	wget -O $(DIR_TFTP_DISTRIB)/template/version1/kernel http://ftp.template.org/pub/x86/pxeboot
	wget -O $(DIR_TFTP_DISTRIB)/template/version1/ramdisk http://ftp.template.org/pub/x86/disk.rd
	wget -O $(DIR_TFTP_DISTRIB)/template/version1/kernel64 http://ftp.template.org/pub/x86_64/pxeboot
	wget -O $(DIR_TFTP_DISTRIB)/template/version1/ramdisk64 http://ftp.template.org/pub/x86_64/disk64.rd

template1_clean:
	rm -f $(DIR_TFTP_DISTRIB)/template/version1/kernel
	rm -f $(DIR_TFTP_DISTRIB)/template/version1/ramdisk
	rm -f $(DIR_TFTP_DISTRIB)/template/version1/kernel64
	rm -f $(DIR_TFTP_DISTRIB)/template/version1/ramdisk64

template1_distclean: template1_clean
	rmdir $(DIR_TFTP_DISTRIB)/template/version1/
# should find a way to clean the top level if no version at all are distcleaned

############################################################################################
