############################################################################################
################################# Debian ###################################################
############################################################################################

debian: debian6

debian_init:

debian_get:

debian_clean:

debian_distclean: debian_clean

### 6 - Squeze

debian6: debian6_init

debian6_init:

debian6_get:

debian6_clean:

debian6_distclean: debian6_clean

### 5 - Lenny

debian5: debian5_init

debian5_init:

debian5_get:
	wget http://ftp.fr.debian.org/debian/dists/squeeze/main/installer-i386/current/images/netboot/netboot.tar.gz -O $(NETBOOT_SQUEEZE)
	wget http://ftp.fr.debian.org/debian/dists/lenny/main/installer-i386/current/images/netboot/netboot.tar.gz -O $(NETBOOT_LENNY)

debian5_clean:

debian5_distclean: debian5_clean

############################################################################################
