############################################################################################
################################# memtest86+ ###############################################
############################################################################################

memtest: memtest_init memtest_get

memtest_init:
	mkdir -p $(DIR_TFTP_DISTRIB)

memtest_get: memtest_init
	wget http://www.memtest.org/download/4.20/memtest86+-4.20.bin.gz -O $(DIR_TFTP_DISTRIB)/memtest86+-4.20.bin.gz

memtest_install: memtest_get
	gunzip $(DIR_TFTP_DISTRIB)/memtest86+-4.20.bin.gz
	mv $(DIR_TFTP_DISTRIB)/memtest86+-4.20.bin $(DIR_TFTP_DISTRIB)/memtest86+-4.20

memtest_clean:
	rm -f $(DIR_TFTP_DISTRIB)/memtest86+-4.20

memtest_distclean: memtest_clean

memtest_doc:

############################################################################################
