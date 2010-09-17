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
	@echo "deliver:  create a tar gz file with all code..."
	@echo "            BUT without external download (please use make download)"
	@echo "doc    :  list of major doc on the Internet for Alix board"
	@echo ""

clean:
	@rm -rf $(TOPDIR)/*~ $(DIR_DOWNLOAD) $(DIR_TFTP_DISTRIB)


load:
	mkdir -p $(DIR_DISTRIB)
	wget \
		http://ftp.fr.debian.org/debian/dists/squeeze/main/installer-i386/current/images/netboot/netboot.tar.gz \
		-O $(NETBOOT_SQUEEZE)
	wget \
		http://ftp.fr.debian.org/debian/dists/lenny/main/installer-i386/current/images/netboot/netboot.tar.gz \
		-O $(NETBOOT_LENNY)
	ls -altr $(DIR_DISTRIB)


deliver: clean
	@echo "step 1/3 creating $(TMP_CFG) in progress..."
	@rm -f $(TMP_CFG)
	cd $(TOPDIR) && \
		tar \
			--exclude=$(DIR_DISTRIB) \
			--create \
			--gzip \
			--file  \
			$(TMP_CFG) .
	@echo "step 2/3 testing $(TMP_CFG) in progress..."
	@tar --verbose --gzip --list --file $(TMP_CFG)
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
# default Debian config file with my test file ...
	@echo "step 3/6 patching local install dir in progress...."
	@cp $(DIR_TFTP)/default $(DIR_TFTP_DISTRIB)/lenny/pxelinux.cfg/default
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
