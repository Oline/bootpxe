# define current location for git files
TOPDIR      = $(shell \pwd)/pxe_repository
# define local temporary file because ACL when launching on nfs 
TMP_CFG     = /tmp/cfg_pxe_alix2d3.tar.gz
# define local temporary file for creating a git archive 
TMP_CFG_GIT = /tmp/cfg_pxe_alix2d3_git_archive.git.tar.gz
# Warning, following line extracted for correct config in xinetd ...
# Please verify in your configuration
XINETD_SRV  = /srv/tftp

NETBOOT_CONFIG = /tmp/debian_netboot_squeeze_i386.tar.gz

help:
	@echo 'version 1.1 alix2d3 configuration Makefile '
	@echo "Documentation and available targets"
	@echo ""
	@echo "help:    this documentation"
	@echo "clean:   suppress all unused files (*~)"
	@echo "list:    list all file and type in Pxe configuration"
	@echo "install: install configuration in directory server "
	@echo "         for ftpd daemon"
	@echo "download: download original files from Debian squeeze release"
	@echo "deliver: create a tar gz file with all code.."
	@echo "doc    : list of major doc on the net for Alix board"
	@echo "git_arch : create git archive in tar gz format"

clean:
	@rm -rf $(TOPDIR)/*~


download:
	wget \
		http://ftp.fr.debian.org/debian/dists/squeeze/main/installer-i386/current/images/netboot/netboot.tar.gz \
		-O $(NETBOOT_CONFIG)

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

install:
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
