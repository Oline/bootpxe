# define current location for git files
TOPDIR      	= $(shell \pwd)/pxe_repository
# define local temporary file because ACL when launching on nfs 
TMP_CFG     	= /tmp/cfg_pxe_alix2d3.tar.gz
# define local temporary file for creating a git archive 
TMP_CFG_GIT 	= /tmp/cfg_pxe_alix2d3_git_archive.git.tar.gz
# Warning, following line extracted for correct config in xinetd ...
# Please verify in your configuration
XINETD_SRV  	= /srv/tftp

DIR_DOWNLOAD 	= $(TOPDIR)/download
DIR_DISTRIB 	= $(TOPDIR)/distrib
NETBOOT_SQUEEZE = $(DIR_DOWNLOAD)/debian_netboot_squeeze_i386.tar.gz
NETBOOT_LENNY 	= $(DIR_DOWNLOAD)/debian_netboot_lenny_i386.tar.gz

help:
	@echo 'version 1.1 alix2d3 configuration Makefile '
	@echo "Documentation and available targets"
	@echo ""
	@echo "step -1- Please first update and/or download correct target"
	@echo "  with make download"
	@echo ""
	@echo "step -2- install download netboot config in tftp server"
	@echo "  with make tftp_srv"
	@echo ""
	@echo "help:    this documentation"
	@echo "clean:   suppress all unused files (*~)"
	@echo "tftp_srv: install configuration in directory server "
	@echo "          for ftpd daemon in: < $(XINETD_SRV) >"
	@echo "download: download original files from Debian squeeze release"
	@echo "deliver: create a tar gz file with all code.."
	@echo "doc    : list of major doc on the net for Alix board"
	@echo "git_arch : create git archive in tar gz format"

clean:
	@rm -rf $(TOPDIR)/*~


download:
	mkdir -p $(DIR_DOWNLOAD)
##	wget \
##		http://ftp.fr.debian.org/debian/dists/squeeze/main/installer-i386/current/images/netboot/netboot.tar.gz \
##		-O $(NETBOOT_SQUEEZE)
##	wget \
##		http://ftp.fr.debian.org/debian/dists/lenny/main/installer-i386/current/images/netboot/netboot.tar.gz \
##		-O $(NETBOOT_LENNY)
	ls -altr $(TOPDIR)/download
	mkdir -p $(DIR_DISTRIB)/lenny
	cd $(DIR_DISTRIB)/lenny && tar xvzf $(NETBOOT_LENNY)
	mkdir -p $(DIR_DISTRIB)/squeeze
	cd $(DIR_DISTRIB)/squeeze &&  tar xvzf $(NETBOOT_SQUEEZE)

git_arch: clean
	@echo "step 1/3 creating $(TMP_CFG_GIT) in progress..."
	@cd $(TOPDIR) && git archive \
		--format=tar \
		--prefix=cfg_pxe_alix2d3.git/  HEAD | gzip > $(TMP_CFG_GIT)
	@echo "step 2/3 testing $(TMP_CFG_GIT) in progress..."
	@tar --verbose --gzip --list --file $(TMP_CFG_GIT)
	@echo "step 3/3 file $(TMP_CFG_GIT) is available"


deliver: clean
	@echo "step 1/3 creating $(TMP_CFG) in progress..."
	@cd $(TOPDIR) && tar --create --gzip --file  $(TMP_CFG) .
	@echo "step 2/3 testing $(TMP_CFG) in progress..."
	@tar --verbose --gzip --list --file $(TMP_CFG)
	@echo "step 3/3 file $(TMP_CFG) is available"

# define current location
list:
	du -s $(TOPDIR)
	find $(TOPDIR) -type f |xargs file

tftp_srv:
	rm -f $(TMP_CFG)
	cd $(TOPDIR) && tar cvzf $(TMP_CFG) .
	sudo rm -rf $(XINETD_SRV)
	sudo mkdir $(XINETD_SRV)
	cd $(XINETD_SRV) && sudo tar xvzf $(TMP_CFG)
	sudo chown -R nobody.nogroup $(XINETD_SRV)	
	find $(XINETD_SRV) -type d |xargs sudo chmod a-rw,u+rwx,g+rx,o+rx
	find $(XINETD_SRV) -type f |xargs sudo chmod a-rw,u+rw,g+r,o+r
	rm $(TMP_CFG)
	sync

doc:
	@echo "http://www.pcengines.ch/alix.htm for main page"	
