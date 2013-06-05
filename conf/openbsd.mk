############################################################################################
################################# OpenBSD ##################################################
############################################################################################

CUR_VER=51

openbsd_help:
	@echo "############################################################################################"
	@echo "### OpenBSD"
	@echo "############################################################################################"
	@echo ""
	@echo "Preparation directives for OpenBSD 5.1"
	@echo ""
	@echo "If you want to install another version, you may use openbsdXX_ACTION patern, where XX is the version number: 5.1 -> 51"
	@echo ""
	@echo "Available version: 5.1"
	@echo ""
	@echo "openbsd_init: create the initial directory structure in the tftp server root directory"
	@echo "openbsd_get: create the initial directory structure in the tftp server root directory"
	@echo "openbsd_clean: create the initial directory structure in the tftp server root directory"
	@echo "openbsd_distclean: create the initial directory structure in the tftp server root directory"
	@echo ""

openbsd: openbsd$(CUR_VER)

openbsd_init: openbsd$(CUR_VER)_init

openbsd_get: openbsd$(CUR_VER)_get

openbsd_clean: openbsd$(CUR_VER)_clean

openbsd_distclean: openbsd$(CUR_VER)_distclean

### 5.1

openbsd51: openbsd51_init openbsd51_get

# openbsd51_serial:

# openbsd51_vga: openbsd51_init openbsd51_get

openbsd51_init:

openbsd51_get: openbsd51_init
# may add a check here if any file already exist, warn about it and don't do anything
	wget -O $(DIR_TFTP_DISTRIB)/openbsd51 http://ftp.fr.openbsd.org/pub/OpenBSD/5.1/i386/pxeboot
	wget -O $(DIR_TFTP_DISTRIB)/bsd.rd http://ftp.fr.openbsd.org/pub/OpenBSD/5.1/i386/bsd.rd
	wget -O $(DIR_TFTP_DISTRIB)/openbsd51_64 http://ftp.fr.openbsd.org/pub/OpenBSD/5.1/amd64/pxeboot
	wget -O $(DIR_TFTP_DISTRIB)/bsd.rd64 http://ftp.fr.openbsd.org/pub/OpenBSD/5.1/amd64/bsd.rd

openbsd51_clean:
	rm -f $(DIR_TFTP_DISTRIB)/openbsd51
	rm -f $(DIR_TFTP_DISTRIB)/bsd.rd
	rm -f $(DIR_TFTP_DISTRIB)/openbsd5164
	rm -f $(DIR_TFTP_DISTRIB)/bsd.rd64

openbsd51_distclean: openbsd51_clean

openbsd_doc:
	@echo "http://www.openbsd.org/cgi-bin/man.cgi?query=pxeboot&sektion=8&arch=i386"

############################################################################################
