############################################################################################
################################# memtest86+ ###############################################
############################################################################################

memtest86_help:
	@echo "############################################################################################"
	@echo "### memtest86+"
	@echo "############################################################################################"
	@echo ""
	@echo "Preparation directives for memtest86+ v4.20"
	@echo ""
	@echo "memtest86_init: create the initial directory structure in the tftp server root directory"
	@echo "memtest86_get: get the binary fils from internet and move it in the tftp server root directory"
	@echo "memtest86_clean: create the initial directory structure in the tftp server root directory"
	@echo "memtest86_distclean: create the initial directory structure in the tftp server root directory"
	@echo ""

memtest86: memtest86_init memtest86_get

memtest86_init:
	mkdir -p $(DIR_TFTP_DISTRIB)

memtest86_get: memtest86_init
	wget http://www.memtest.org/download/4.20/memtest86+-4.20.bin.gz -O $(DIR_TFTP_DISTRIB)/memtest86+-4.20.bin.gz

memtest86_install: memtest86_get
	gunzip $(DIR_TFTP_DISTRIB)/memtest86+-4.20.bin.gz
	mv $(DIR_TFTP_DISTRIB)/memtest86+-4.20.bin $(DIR_TFTP_DISTRIB)/memtest86+-4.20

memtest86_clean:
	rm -f $(DIR_TFTP_DISTRIB)/memtest86+-4.20

memtest86_distclean: memtest86_clean

memtest86_doc:

############################################################################################
