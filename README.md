BootPXE
======
**BootPXE** is a Makefile system to prepare a ready to use boot PXE server. The usage is explained like this:

```
$ make help
$
```

To use these Makefiles, you must deploy a tftp server binary (depending on your
distribution). atftp or similar will do the job.
You must also configure your DHCP server to allow bootp protocol, fill in your
"next-server" variable with the tftp server's IP address, and the boot file's
filename to send as the boot binary for the PXE clients.

## Software requirements

- GNU make
- wget

## Version
* Version X.Y

## Customisation

If you want to have specific configurations, you must copy default (or default_serial) to a file named using the MAC address of the computer MAC controller and change the option from that file.

## Contact
#### Developer : Sylvain Leroy
* Homepage: http://www.unmondelibre.fr
* e-mail: sylvain@unmondelibre.fr
