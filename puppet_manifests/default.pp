# Puppet provisioning for Virtual Machine for Nodejs / meteorjs development 
 
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
	password => sha1('devpass'),
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
	  'guest ok = yes',
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

# install mongo
#class { 'mongodb':
#  use_10gen  => true,
#  before => Package["express"]
#}

include epel

# install nodejs
include nodejs


class meteor() {
	exec { "install_meteor":
		environment => ["HOME=/home/vagrant/"],
		command => "/usr/bin/curl https://install.meteor.com | /bin/sh",
		user => vagrant,
		require => [Package['npm'], Package['nodejs']]
	}
}

# use the meteor class defined above
include meteor




