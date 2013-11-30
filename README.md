Development Box
=============

A ***CENTOS 6.4*** based virtual machine that is created and managed by Vagrant and provisioned using Puppet.


Provisioning:
-----------

- Network address of VM: ***192.168.7.7***
- ***Disables the firewall*** since this is a development box
- Creates a ***WWW*** directory in the root file system
-- Sets the Owner and group to ***Vagrant***
- Installs and configures ***Samba***
-- Insecure setup which shares the ***WWW*** directory with everyone
- Sets up ***EPEL*** repositories
- Installs ***Nodejs***
- Installs ***NPM***
- Installs ***MeteorJS***


Future Improvements:
------------------

I think it would be best if a separate user was created (i.e. Developer) and was used
 to install Nodejs, NPM and Meteor so that it correctly installs and sets permissions on the executables to be sandboxed to that user. 


