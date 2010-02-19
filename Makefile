# define current location
TOPDIR   = $(shell \pwd)/pxe_repository

help:
	@echo 'version 1.0'
	@echo "Documentation and available targets"
	@echo ""
	@echo "help: this documentation"
	@echo "list: list all file and type in Pxe configuration"
	@echo ""

# define current location
list:
	du -s $(TOPDIR)
	find $(TOPDIR) -type f |xargs file
