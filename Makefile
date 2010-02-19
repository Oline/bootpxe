# define current location for git files
TOPDIR      = $(shell \pwd)/pxe_repository
# define local temporary file because ACL when launching on nfs 
TMP_CFG     = /tmp/cfg_pxe.tar.gz
# Warning, following line extracted for correct config in xinetd ...
# Please verify in your configuration
XINETD_SRV  = /srv/tftp


help:
	@echo 'version 1.0'
	@echo "Documentation and available targets"
	@echo ""
	@echo "help:    this documentation"
	@echo "list:    list all file and type in Pxe configuration"
	@echo "install: install configuration in directory server "
	@echo "         for ftpd daemon"


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