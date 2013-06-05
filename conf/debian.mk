############################################################################################
################################# Debian ###################################################
############################################################################################

debian_help:
	@echo "############################################################################################"
	@echo "### Debian"
	@echo "############################################################################################"
	@echo ""
	@echo "Preparation directives for Debian 6: Squeeze"
	@echo ""
	@echo "If you want to install another version, you may use debianX_ACTION patern, where X is the version number: 6"
	@echo ""
	@echo "Available version: 5, 6, 7" # may use oldstable, stable, testing and unstable
	@echo ""
	@echo "debian_init: create the initial directory structure in the tftp server root directory"
	@echo "debian_get: create the initial directory structure in the tftp server root directory"
	@echo "debian_clean: create the initial directory structure in the tftp server root directory"
	@echo "debian_distclean: create the initial directory structure in the tftp server root directory"
	@echo ""

debian: debian6

debian_init:

debian_get:

debian_clean:

debian_distclean: debian_clean

### 6 - Squeze

debian6: debian6_init

debian6_init:

debian6_get:

debian6_clean:

debian6_distclean: debian6_clean

### 5 - Lenny

debian5: debian5_init

debian5_init:

debian5_get:
	wget http://ftp.fr.debian.org/debian/dists/squeeze/main/installer-i386/current/images/netboot/netboot.tar.gz -O $(NETBOOT_SQUEEZE)
	wget http://ftp.fr.debian.org/debian/dists/lenny/main/installer-i386/current/images/netboot/netboot.tar.gz -O $(NETBOOT_LENNY)

debian5_clean:

debian5_distclean: debian5_clean

############################################################################################
