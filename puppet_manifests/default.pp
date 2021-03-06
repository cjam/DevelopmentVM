# Puppet provisioning for Virtual Machine for Nodejs / meteorjs development 
 
# Good resource for using classes inside the manifest
# http://docs.puppetlabs.com/puppet/2.7/reference/lang_classes.html#declaring-a-class-with-include
 
# Disable firewall since this is a DEV box, but this should be changed for production obviously
service { "iptables":
	ensure => "stopped",
	enable => "false",
}
  
# Create the Group and user associated with our developer account
group { "developer":
	ensure => "present",
}
  
user { "developer":
	ensure => "present",
	managehome => "true",
	password => sha1("devpass"),
	gid => "developer",
	require => Group["developer"]
}

# Create the directory for holding the web projects to be worked on
file { "/www/":
	ensure => "directory",
	owner => "vagrant",
	group => "vagrant",
	mode => 755,
	#require => [ User["developer"], Group["developer"] ]
}

# Set up samba to serve that directory to everyone ___OPENS SAMBA TO THE WORLD WITH NO PASSWORD___
class { 'samba::server':
  workgroup            => 'SAMBA',
  server_string        => 'Development Web Directory',
  netbios_name         => 'WebDev',
  interfaces           => [ 'lo', 'eth1' ],
  hosts_allow          => [ '127.', '192.168.' ],
  map_to_guest         => 'Bad User',
  shares => {
    'WWW' => [
      'comment = Web Directory',
	  'create mask: 664',
	  'directory mask: 0775',
	  'path = /www/',
      'browseable = yes',
      'writable = yes',
	  'guest ok = no',
	  'valid users = vagrant, developer',
	  'follow symlinks = yes',
	  'wide links = yes',
	  'available = yes',
    ],
  },
}

# Creates a samba user for the developer account... we don't really need this since we opened samba up to everyone,
# but maybe we could figure out how to add user auth
exec { "create_samba_user":
    command => "/usr/bin/smbpasswd -a vagrant",
	require => [Class["samba::server"]]
}

exec { "enable_samba_user":
	command => "/usr/bin/smbpasswd -e vagrant",
	require => Exec["create_samba_user"],
}

package{"git":
	ensure => present,
	before => Class["epel"],
}

package{"subversion":
	ensure => present,
	before => Class["epel"],
}

class{"epel":
	require => Class["samba::server"],
}

# Create the directory for holding the mongo database
#file{ "/data/":
#	ensure => "directory",
#	owner => "mongod",
#	group => "mongod",
#	mode => 755,
#

#file { "/data/db/":
#	ensure => "directory",
#	owner => "mongod",
#	group => "mongod",
#	mode => 755,
#	require => File["/data/"]
#}

# Installs MongoDB Server & client
#class {'::mongodb::globals':
#  manage_package_repo => true,
#}->
#class {'::mongodb::server':
#}->
#class {'::mongodb::client': }

# install nodejs
class{"nodejs":
	require => Class["epel"],
}

# Test runner
package { 'karma':
  ensure => present,
  provider => 'npm',
  require => Class["nodejs"],
}

# Test Suite
package { 'mocha':
  ensure => present,
  provider => 'npm',
  require => Class["nodejs"],
}

### Phantom JS
package { 'phantomjs':
  ensure => present,
  provider => 'npm',
  require => Class["nodejs"],
}

package{"freetype":
	ensure => present,
	before => Package["phantomjs"],
}

package{"fontconfig":
	ensure => present,
	before => Package["phantomjs"],
}

### Task Runner
package { 'grunt-cli':
  ensure   => present,
  provider => 'npm',
  require => Class["nodejs"],
}

### node debugging
package { 'node-inspector':
  ensure   => present,
  provider => 'npm',
  require => Class["nodejs"],
}

### Istanbul Code Coverage
package { 'istanbul':
  ensure   => present,
  provider => 'npm',
  require => Class["nodejs"],
}

### Install postgres module
package { 'pg':
	ensure => present,
	provider => 'npm',
	require => Class["nodejs"],
	before => Class["postgresql::globals"],
}


### POSTGRES DATABASE ###

# Install PostgreSQL 9.3 server from the PGDG repository
class {'postgresql::globals':
  manage_package_repo => true,
  encoding => 'UTF8',
  locale  => 'it_IT.utf8',
}->
class { 'postgresql::server':
  ensure => 'present',
  listen_addresses => '*',
  manage_firewall => true,
  postgres_password => '4Devel0pment',
}

# Install contrib modules
class { 'postgresql::server::contrib':
  package_ensure => 'present',
}

# Setup Dev database
postgresql::server::db { 'devdb':
  user     => 'devuser',
  password => postgresql_password('devuser', 'devpassword'),
}







