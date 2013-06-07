# Abstract:
# This makefile is used to create a litle application in order to
# install a tftpd.in server for pxe boot.
#
# Authors: Jean Marc LACROIX (jeanmarc.lacroix@free.fr)
#          Sylvain LEROY (sylvain@unmondelibre.fr)
# date: mercredi 10 juin 2012, 21:20:35 (UTC+0200)

# Notes :
#  - verifier les droits des fichiers lors de leur installation sur le serveur
#  - ajouter un fichier "version.info" pour connaitre la version du projet en cours
#    d'utilisation, ainsi que les versions des distributions intallée (ou non).
#  - dans le cas d'un ajout d'une cible "update/upgrade" il serait peut-etre nécessaire
#    de conserver un autre fichier de version par distrib/pour tout le système.
#    (Un INDEX à la manière des ports FreeBSD).

############################################################################################
############################### Include variables ##########################################
############################################################################################

include makefile.vars

############################################################################################

help: $(CONF_HELP_TARGET)

clean:
	rm -rf $(TOPDIR)/*~
	rm -rf $(DIR_DOWNLOAD)
	rm -rf $(DIR_TFTP_DISTRIB)

distclean: clean

doc:
	@echo "http://www.pcengines.ch/alix.htm for main page"

test: dummy.img
	qemu -hda ./dummy.img -net nic -net user -boot n -tftp srv_tftp_dir/ -bootp /pxelinux.0

dummy.img:
	dd if=/dev/zero of=dummy.img bs=1M count=5

############################################################################################
########################### Include Configuration files ####################################
############################################################################################

include conf/*.mk

############################################################################################


# # define local temporary file because ACL when launching on nfs
# TMP_CFG     	= /tmp/cfg_pxe_alix2d3.tar.gz
# # Warning, following line extracted for correct config in xinetd ...
# # Please verify in your configuration
# XINETD_SRV  	= /srv/tftp

# DIR_DOWNLOAD 	= $(TOPDIR)/download
# DIR_DISTRIB 	= $(DIR_DOWNLOAD)/distrib
# NETBOOT_SQUEEZE = $(DIR_DOWNLOAD)/debian_netboot_squeeze_i386.tar.gz
# NETBOOT_LENNY 	= $(DIR_DOWNLOAD)/debian_netboot_lenny_i386.tar.gz

# load:
# 	@mkdir -p $(DIR_DISTRIB)
# 	wget http://ftp.fr.debian.org/debian/dists/squeeze/main/installer-i386/current/images/netboot/netboot.tar.gz -O $(NETBOOT_SQUEEZE)
# 	wget http://ftp.fr.debian.org/debian/dists/lenny/main/installer-i386/current/images/netboot/netboot.tar.gz -O $(NETBOOT_LENNY)
# 	ls -altr $(DIR_DISTRIB)

# deliver: clean
# 	@echo "step 1/3 creating $(TMP_CFG) in progress..."
# 	@rm -f $(TMP_CFG)
# 	@cd $(TOPDIR) && \
# 		tar \
# 			--exclude=$(DIR_DISTRIB) \
# 			--create \
# 			--gzip \
# 			--file  \
# 			$(TMP_CFG) .
# 	@echo "step 2/3 testing $(TMP_CFG) in progress..."
# 	@tar --gzip --list --file $(TMP_CFG)
# 	@echo "step 3/3 file $(TMP_CFG) is available"

# # define current location, only for debug operation
# list:
# 	@du -s $(TOPDIR)
# 	@find $(TOPDIR) -type f |xargs file

# # install now all code in correct location, it is assume that
# # xinetd and in.tftpd are already installed
# tftp_srv:
# 	@rm -rf $(DIR_TFTP_DISTRIB)
# 	@mkdir -p $(DIR_TFTP_DISTRIB)/lenny
# 	@mkdir -p $(DIR_TFTP_DISTRIB)/squeeze
# # assume all files are already download...
# 	@echo "step 1/6 extracted file from $(NETBOOT_LENNY) in progress...."
# 	@cd $(DIR_TFTP_DISTRIB)/lenny && tar xfz $(NETBOOT_LENNY)
# 	@echo "step 2/6 extracted file from $(NETBOOT_SQUEEZE) in progress...."
# 	@cd $(DIR_TFTP_DISTRIB)/squeeze && tar xfz $(NETBOOT_SQUEEZE)
# # Alix runs with console, so we must enable console, then overlap
# # default Debian config file with my default file ...
# 	@echo "step 3/6 patching local install dir in progress...."
# 	@cp $(DIR_TFTP)/default $(DIR_TFTP_DISTRIB)/lenny/pxelinux.cfg/default
# # never forget binarybootstrap
# 	@cd $(DIR_TFTP_DISTRIB) && ln -s lenny/pxelinux.0 pxelinux.0
# # assuming we are working on nfs with  root squashing ACL, then first
# # make a local copy  in user (non  root) access  in /tmp, and  second,
# # copy local file in correct  destination.   Sorry, the first  release
# # consist to make only one simple configuration  file in order to test
# # Alix boot in  pxe mode, so we assume  that only Debian Lenny must me
# # installed
# 	@echo "step 4/6 creating internal tar.gz file in progress...."
# 	@cd $(DIR_TFTP_DISTRIB) && tar czf $(TMP_CFG) .
# 	@sudo rm -rf $(XINETD_SRV)
# 	@sudo mkdir $(XINETD_SRV)
# 	@echo "step 5/6 installing internal tar.gz file in $(XINETD_SRV) in progress...."
# 	@cd $(XINETD_SRV) && sudo tar xzf $(TMP_CFG)
# 	@sudo chown -R nobody.nogroup $(XINETD_SRV)
# 	@find $(XINETD_SRV) -type d |xargs sudo chmod a-rw,u+rwx,g+rx,o+rx
# 	@find $(XINETD_SRV) -type f |xargs sudo chmod a-rw,u+rw,g+r,o+r
# 	@rm $(TMP_CFG)
# 	@sync
# 	@echo "step 6/6 server in.tftpd is available now...."
# # in order to test it, please use atftp Debian package with following
# # command
# #  atftp --get --remote-file  pxelinux.0 --local-file  /tmp/ttt --verbose  srvtftp-2

