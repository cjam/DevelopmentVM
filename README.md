# Development Box


A ***CENTOS 6.4*** based virtual machine that is created and managed by Vagrant and provisioned using Puppet.
Made to provide a consistent development environment for all of the project I feel like working on.



## Requirements


You will need to install ***Vagrant***: (See below for OS specific versions)

[Vagrant](http://docs.vagrantup.com/v2/getting-started/)

You will then need to clone this repository into a folder on your machine and do the following:

### Windows

You'll need the following installed:

***Vagrant (Latest)***
***Virtual Box (Latest)*** 

- Open up command prompt as ***Administrator***
- Traverse into the root of the cloned project's folder
- Type into the command prompt:

    ***vagrant up***

- You can ssh into the machine using vagrant.  In the command prompt that you used to ***Vagrant up*** the vm, use the following command

    ***vagrant ssh***

#### File Access
	
- Vagrant automatically mounts the root folder that the vagrant file is on the vm that you've just built at the following location:
	`/vagrant` this file system is good but can do some strange things at times, so i've also set up the following samba share;
	
    ***\\192.168.7.7\WWW***  (User: vagrant, password: `blank`)
	
- Have fun :)

### Other OS

***Worked on Mac OSX when I tried it***

- I'm not sure, because I'm using Windows.. but its likely very similar and steps can be found on Vagrants website


## Current Provisioning


- Network address of VM: ***192.168.7.7***
- ***Disables the firewall*** since this is a development box
- Creates a ***WWW*** directory in the root file system
-- Sets the Owner and group to ***Vagrant***
- Installs and configures ***Samba***
-- Setup shares the ***WWW*** directory (User: vagrant, password: `blank`)
- Sets up ***EPEL*** repositories
//- Installs ***mongodb*** server & client from 10-gen repos
- Installs ***Nodejs***
- Installs ***NPM***
- Installs PostGres and configures a Database

Installs the following NPM packages Globally:

- Karma test runner
- Mocha test runner
- Instanbul javascript code coverage
- PhantomJS
- Grunt-cli
- node-inspector


## Future Improvements


I think it would be best if a separate user was created (i.e. Developer) and was used to install Nodejs, NPM and Meteor so that it 
correctly installs and sets permissions on the executables to be sandboxed to that user.  

I think it would also be prudent to create a Production style machine that has SELinux and firewalls enabled.  

More investigation is needed however to make this VM scalable in a cloud setting.. however, this is a good first step towards that.

It would also be good to throw a user name and password on the samba share of the vm, but it shouldn't matter right now since it is configured
with a host-only network adapter.



