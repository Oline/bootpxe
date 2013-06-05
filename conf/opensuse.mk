############################################################################################
################################# OpenSuse #################################################
############################################################################################

opensuse_help:
	@echo "############################################################################################"
	@echo "### OpenSuse"
	@echo "############################################################################################"
	@echo ""
	@echo "Preparation directives for OpenSuse 12.1"
	@echo ""
	@echo "If you want to install another version, you may use opensuseXXX_ACTION patern, where XXX is the version number: 12.1 -> 121"
	@echo ""
	@echo "Available version: 12.1"
	@echo ""
	@echo "opensuse_init: create the initial directory structure in the tftp server root directory"
	@echo "opensuse_get: create the initial directory structure in the tftp server root directory"
	@echo "opensuse_clean: create the initial directory structure in the tftp server root directory"
	@echo "opensuse_distclean: create the initial directory structure in the tftp server root directory"
	@echo ""

opensuse: opensuse121

opensuse_init: opensuse121_init

opensuse_get: opensuse121_get

opensuse_clean: opensuse121_clean

opensuse_distclean: opensuse121_distclean

### 12.1

opensuse121: opensuse121_init opensuse121_get

opensuse121_init: #opensuse121_clean
	mkdir -p $(DIR_TFTP_DISTRIB)/opensuse-installer/12.1/i386/
	mkdir -p $(DIR_TFTP_DISTRIB)/opensuse-installer/12.1/x86_64/

opensuse121_get: opensuse121_init
# may add a check here if any file already exist, warn about it and don't do anything
	wget -O $(DIR_TFTP_DISTRIB)/opensuse-installer/12.1/i386/initrd http://download.opensuse.org/distribution/12.1/repo/oss/boot/i386/loader/initrd
	wget -O $(DIR_TFTP_DISTRIB)/opensuse-installer/12.1/i386/linux http://download.opensuse.org/distribution/12.1/repo/oss/boot/i386/loader/linux
	wget -O $(DIR_TFTP_DISTRIB)/opensuse-installer/12.1/x86_64/initrd http://download.opensuse.org/distribution/12.1/repo/oss/boot/x86_64/loader/initrd
	wget -O $(DIR_TFTP_DISTRIB)/opensuse-installer/12.1/x86_64/linux http://download.opensuse.org/distribution/12.1/repo/oss/boot/x86_64/loader/linux

opensuse121_clean:
	rm -f $(DIR_TFTP_DISTRIB)/opensuse-installer/12.1/i386/initrd
	rm -f $(DIR_TFTP_DISTRIB)/opensuse-installer/12.1/i386/linux
	rm -f $(DIR_TFTP_DISTRIB)/opensuse-installer/12.1/x86_64/initrd
	rm -f $(DIR_TFTP_DISTRIB)/opensuse-installer/12.1/x86_64/linux

opensuse121_distclean: opensuse121_clean
	rm -rf $(DIR_TFTP_DISTRIB)/opensuse-installer

############################################################################################
