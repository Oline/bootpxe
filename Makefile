# Abstract:
# This makefile is used to create a litle application in order to
# install a tftpd.in server for pxe boot.
#
# Authors: Jean Marc LACROIX (jeanmarc.lacroix@free.fr)
#          Sylvain LEROY (sylvain@unmondelibre.fr)
# date: mercredi 10 juin 2012, 21:20:35 (UTC+0200)

# Notes :
#  - verifier les droits des fichiers lors de leur installation sur le serveur
#  - ajouter un fichier "version.info" pour connaitre la version du projet en cours
#    d'utilisation, ainsi que les versions des distributions intallée (ou non).
#  - dans le cas d'un ajout d'une cible "update/upgrade" il serait peut-etre nécessaire
#    de conserver un autre fichier de version par distrib/pour tout le système.
#    (Un INDEX à la manière des ports FreeBSD).

include makefile.vars

#	 @echo 'version 1.1 alix2d3 configuration Makefile '
#	 @echo "Documentation and available targets"
#	 @echo ""
#	 @echo "step -1- Please first update and/or download correct target"
#	 @echo "   make load"
#	 @echo ""
#	 @echo "step -2- install download netboot config on tftp server"
#	 @echo "  make tftp_srv"
#	 @echo ""
#	 @echo "help:     this documentation"
#	 @echo "clean:    suppress all unused files (*~) and download internal directory"
#	 @echo "tftp_srv: install configuration in directory server "
#	 @echo "            for ftpd daemon in: < $(XINETD_SRV) >"
#	 @echo "load:     download original files from Debian squeeze release"
#	 @echo "deliver:  create a tar gz file with all code and git archive..."
#	 @echo "            BUT without external download (please use make load)"
#	 @echo "doc    :  list of major doc on the Internet for Alix board"
#	 @echo ""

help:
	@echo "### Debian"
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
	@echo "### OpenSuse"
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
	@echo "### OpenBSD"
	@echo ""
	@echo "Preparation directives for OpenBSD 5.6"
	@echo ""
	@echo "If you want to install another version, you may use openbsdXX_ACTION patern, where XX is the version number: 5.1 -> 51"
	@echo ""
	@echo "Available version: 5.6"
	@echo ""
	@echo "openbsd_init: create the initial directory structure in the tftp server root directory"
	@echo "openbsd_get: create the initial directory structure in the tftp server root directory"
	@echo "openbsd_clean: create the initial directory structure in the tftp server root directory"
	@echo "openbsd_distclean: create the initial directory structure in the tftp server root directory"
	@echo ""
	@echo "### memtest86+"
	@echo ""
	@echo "Preparation directives for memtest86+ v4.20"
	@echo ""
	@echo "memtest_init: create the initial directory structure in the tftp server root directory"
	@echo "memtest_get: get the binary fils from internet and move it in the tftp server root directory"
	@echo "memtest_clean: create the initial directory structure in the tftp server root directory"
	@echo "memtest_distclean: create the initial directory structure in the tftp server root directory"
	@echo ""

clean:
	rm -rf $(TOPDIR)/*~
	rm -rf $(DIR_DOWNLOAD)
	rm -rf $(DIR_TFTP_DISTRIB)

load:
	@mkdir -p $(DIR_DISTRIB)
	wget http://ftp.fr.debian.org/debian/dists/squeeze/main/installer-i386/current/images/netboot/netboot.tar.gz -O $(NETBOOT_SQUEEZE)
	wget http://ftp.fr.debian.org/debian/dists/lenny/main/installer-i386/current/images/netboot/netboot.tar.gz -O $(NETBOOT_LENNY)
	ls -altr $(DIR_DISTRIB)

deliver: clean
	@echo "step 1/3 creating $(TMP_CFG) in progress..."
	@rm -f $(TMP_CFG)
	@cd $(TOPDIR) && \
		tar \
			--exclude=$(DIR_DISTRIB) \
			--create \
			--gzip \
			--file  \
			$(TMP_CFG) .
	@echo "step 2/3 testing $(TMP_CFG) in progress..."
	@tar --gzip --list --file $(TMP_CFG)
	@echo "step 3/3 file $(TMP_CFG) is available"

# define current location, only for debug operation
list:
	@du -s $(TOPDIR)
	@find $(TOPDIR) -type f |xargs file

# install now all code in correct location, it is assume that
# xinetd and in.tftpd are already installed
tftp_srv:
	@rm -rf $(DIR_TFTP_DISTRIB)
	@mkdir -p $(DIR_TFTP_DISTRIB)/lenny
	@mkdir -p $(DIR_TFTP_DISTRIB)/squeeze
# assume all files are already download...
	@echo "step 1/6 extracted file from $(NETBOOT_LENNY) in progress...."
	@cd $(DIR_TFTP_DISTRIB)/lenny && tar xfz $(NETBOOT_LENNY)
	@echo "step 2/6 extracted file from $(NETBOOT_SQUEEZE) in progress...."
	@cd $(DIR_TFTP_DISTRIB)/squeeze && tar xfz $(NETBOOT_SQUEEZE)
# Alix runs with console, so we must enable console, then overlap
# default Debian config file with my default file ...
	@echo "step 3/6 patching local install dir in progress...."
	@cp $(DIR_TFTP)/default $(DIR_TFTP_DISTRIB)/lenny/pxelinux.cfg/default
# never forget binarybootstrap
	@cd $(DIR_TFTP_DISTRIB) && ln -s lenny/pxelinux.0 pxelinux.0
# assuming we are working on nfs with  root squashing ACL, then first
# make a local copy  in user (non  root) access  in /tmp, and  second,
# copy local file in correct  destination.   Sorry, the first  release
# consist to make only one simple configuration  file in order to test
# Alix boot in  pxe mode, so we assume  that only Debian Lenny must me
# installed
	@echo "step 4/6 creating internal tar.gz file in progress...."
	@cd $(DIR_TFTP_DISTRIB) && tar czf $(TMP_CFG) .
	@sudo rm -rf $(XINETD_SRV)
	@sudo mkdir $(XINETD_SRV)
	@echo "step 5/6 installing internal tar.gz file in $(XINETD_SRV) in progress...."
	@cd $(XINETD_SRV) && sudo tar xzf $(TMP_CFG)
	@sudo chown -R nobody.nogroup $(XINETD_SRV)
	@find $(XINETD_SRV) -type d |xargs sudo chmod a-rw,u+rwx,g+rx,o+rx
	@find $(XINETD_SRV) -type f |xargs sudo chmod a-rw,u+rw,g+r,o+r
	@rm $(TMP_CFG)
	@sync
	@echo "step 6/6 server in.tftpd is available now...."
# in order to test it, please use atftp Debian package with following
# command
#  atftp --get --remote-file  pxelinux.0 --local-file  /tmp/ttt --verbose  srvtftp-2


doc:
	@echo "http://www.pcengines.ch/alix.htm for main page"

############################################################################################
################################# Debian ###################################################
############################################################################################

-include debian.mk

############################################################################################
################################# OpenSuse #################################################
############################################################################################

-include opensuse.mk

############################################################################################
################################# NetBSD ###################################################
############################################################################################

-include netbsd.mk

############################################################################################
################################# FreeBSD ##################################################
############################################################################################

-include freebsd.mk

############################################################################################
################################# OpenBSD ##################################################
############################################################################################

-include openbsd.mk

############################################################################################
################################# memtest86+ ###############################################
############################################################################################

-include memtest86.mk

############################################################################################
