############################################################################################
################################# Netbsd ##################################################
############################################################################################

netbsd: netbsd60

netbsd_init: netbsd60_init

netbsd_get: netbsd60_get

netbsd_clean: netbsd60_clean

netbsd_distclean: netbsd60_distclean

### 6.0

netbsd60: netbsd60_init netbsd60_get

# netbsd60_serial:

# netbsd60_vga: netbsd60_init netbsd60_get

netbsd60_init:
	mkdir -p $(DIR_TFTP_DISTRIB)/netbsd-installer/6.0/i386/
#	mkdir -p $(DIR_TFTP_DISTRIB)/netbsd-installer/6.0/x86_64/

netbsd60_get: netbsd60_init
# may add a check here if any file already exist, warn about it and don't do anything
	wget -O $(DIR_TFTP_DISTRIB)/netbsd-installer/6.0/i386/netbsd.gz ftp://ftp.netbsd.org/pub/NetBSD/NetBSD-6.0/i386/binary/kernel/netbsd-INSTALL.gz
	wget -O $(DIR_TFTP_DISTRIB)/base.tgz ftp://iso.fr.netbsd.org/pub/NetBSD/NetBSD-6.0/i386/binary/sets/base.tgz
	tar -xzf $(DIR_TFTP_DISTRIB)/base.tgz -C $(DIR_TFTP_DISTRIB)/netbsd-installer/6.0/i386/ ./usr/mdec/pxeboot_ia32.bin
	mv $(DIR_TFTP_DISTRIB)/netbsd-installer/6.0/i386/usr/mdec/pxeboot_ia32.bin $(DIR_TFTP_DISTRIB)/netbsd-installer/6.0/i386/pxeboot_ia32.0
	rm -rf $(DIR_TFTP_DISTRIB)/netbsd-installer/6.0/i386/usr
#	tar -xf $(DIR_TFTP_DISTRIB)/base.tgz -C $(DIR_TFTP_DISTRIB)/netbsd-installer/6.0/i386/ ./usr/mdec/pxeboot_ia32_com0.bin
	rm -f $(DIR_TFTP_DISTRIB)/base.tgz

netbsd60_clean:
	rm -f $(DIR_TFTP_DISTRIB)/netbsd-installer/6.0/i386/pxeboot_ia32.bin
	rm -f $(DIR_TFTP_DISTRIB)/netbsd-installer/6.0/i386/netbsd.gz

netbsd60_distclean: netbsd60_clean
	rm -rf $(DIR_TFTP_DISTRIB)/netbsd-installer

netbsd_doc:
	@echo "http://www.netbsd.org/docs/network/netboot/intro.i386.html"
	@echo "http://www.thegibson.org/blog/archives/10"

############################################################################################
