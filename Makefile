# Abstract:
# This makefile is used to create a litle application in order to
# install a tftpd.in server for pxe boot.
#
# Author: Jean Marc LACROIX (jeanmarc.lacroix@free.fr)
# date: samedi 18 septembre 2010, 07:51:35 (UTC+0200)


# define current location for git files
TOPDIR      	= $(shell \pwd)
# define local temporary file because ACL when launching on nfs
TMP_CFG     	= /tmp/cfg_pxe_alix2d3.tar.gz
# Warning, following line extracted for correct config in xinetd ...
# Please verify in your configuration
XINETD_SRV  	= /srv/tftp

DIR_DOWNLOAD 	= $(TOPDIR)/download
DIR_DISTRIB 	= $(DIR_DOWNLOAD)/distrib
NETBOOT_SQUEEZE = $(DIR_DOWNLOAD)/debian_netboot_squeeze_i386.tar.gz
NETBOOT_LENNY 	= $(DIR_DOWNLOAD)/debian_netboot_lenny_i386.tar.gz
# internal build directory for server
DIR_TFTP        = $(TOPDIR)/srv_tftp_dir
DIR_TFTP_DISTRIB= $(TOPDIR)/srv_tftp_dir/distrib

help:
	@echo 'version 1.1 alix2d3 configuration Makefile '
	@echo "Documentation and available targets"
	@echo ""
	@echo "step -1- Please first update and/or download correct target"
	@echo "   make load"
	@echo ""
	@echo "step -2- install download netboot config on tftp server"
	@echo "  make tftp_srv"
	@echo ""
	@echo "help:     this documentation"
	@echo "clean:    suppress all unused files (*~) and download internal directory"
	@echo "tftp_srv: install configuration in directory server "
	@echo "            for ftpd daemon in: < $(XINETD_SRV) >"
	@echo "load:     download original files from Debian squeeze release"
	@echo "deliver:  create a tar gz file with all code and git archive..."
	@echo "            BUT without external download (please use make load)"
	@echo "doc    :  list of major doc on the Internet for Alix board"
	@echo ""

clean:
	@rm -rf $(TOPDIR)/*~ $(DIR_DOWNLOAD) $(DIR_TFTP_DISTRIB)

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
################################# OpenSuse #################################################
############################################################################################

opensuse: opensuse121

opensuse121: opensuse121_init opensuse121_get

opensuse121_init: #opensuse121_clean
	mkdir -p opensuse-installer/12.1/i386/
	mkdir -p opensuse-installer/12.1/x86_64/

opensuse121_get:
# may add a check here if any file already exist, warn about it and don't do anything
	wget -O opensuse-installer/12.1/i386/initrd http://download.opensuse.org/distribution/12.1/repo/oss/boot/i386/loader/initrd
	wget -O opensuse-installer/12.1/i386/linux http://download.opensuse.org/distribution/12.1/repo/oss/boot/i386/loader/linux
	wget -O opensuse-installer/12.1/x86_64/initrd http://download.opensuse.org/distribution/12.1/repo/oss/boot/x86_64/loader/initrd
	wget -O opensuse-installer/12.1/x86_64/linux http://download.opensuse.org/distribution/12.1/repo/oss/boot/x86_64/loader/linux

opensuse121_clean:
	rm -f opensuse-installer/12.1/i386/initrd
	rm -f opensuse-installer/12.1/i386/linux
	rm -f opensuse-installer/12.1/x86_64/initrd
	rm -f opensuse-installer/12.1/x86_64/linux

opensuse121_distclean: opensuse121_clean
	rm -rf opensuse-installer



############################################################################################
################################# FreeBSD ##################################################
############################################################################################

freebsd: freebsd90

freebsd90: freebsd90_vga

freebsd90_serial:

freebsd90_vga:

freebsd90_init:

freebsd90_get:

freebsd90_clean:

freebsd90_distclean: freebsd90_clean

############################################################################################
################################# OpenBSD ##################################################
############################################################################################

openbsd: openbsd51

openbsd51: openbsd51_vga

openbsd51_serial:

openbsd51_vga: openbsd51_init openbsd51_get

openbsd51_init:

openbsd51_get:
	wget -O pxeboot http://ftp.fr.openbsd.org/pub/OpenBSD/5.1/i386/pxeboot
	wget -O bsd.rd http://ftp.fr.openbsd.org/pub/OpenBSD/5.1/i386/bsd.rd
	wget -O pxeboot64 http://ftp.fr.openbsd.org/pub/OpenBSD/5.1/amd64/pxeboot
	wget -O bsd.rd64 http://ftp.fr.openbsd.org/pub/OpenBSD/5.1/amd64/bsd.rd

openbsd51_clean:
	rm -f pxeboot
	rm -f bsd.rd
	rm -f pxeboot64
	rm -f bsd.rd64

openbsd51_distclean: openbsd51_clean

openbsd_doc:
	@echo "http://www.openbsd.org/cgi-bin/man.cgi?query=pxeboot&sektion=8&arch=i386"

############################################################################################
