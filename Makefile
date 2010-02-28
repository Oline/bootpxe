# define current location for git files
TOPDIR      = $(shell \pwd)/pxe_repository
# define local temporary file because ACL when launching on nfs 
TMP_CFG     = /tmp/cfg_pxe_alix2d3.tar.gz
# Warning, following line extracted for correct config in xinetd ...
# Please verify in your configuration
XINETD_SRV  = /srv/tftp


help:
	@echo 'version 1.1 alix2d3 configuration Makefile '
	@echo "Documentation and available targets"
	@echo ""
	@echo "help:    this documentation"
	@echo "clean:   suppress all unused files (*~)"
	@echo "list:    list all file and type in Pxe configuration"
	@echo "install: install configuration in directory server "
	@echo "         for ftpd daemon"
	@echo "deliver: create a tar gz file with all code.."

clean:
	@rm -rf $(TOPDIR)/*~

deliver: clean
	@cd $(TOPDIR) && tar --create --gzip --file  $(TMP_CFG) .
	@echo " ====> file $(TMP_CFG) is available....."

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
