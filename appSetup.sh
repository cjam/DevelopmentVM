#!/bin/sh
for DIR in `find /vagrant/Apps/* -maxdepth 0 -type d`; do
	APP_NAME=`cat $DIR/package.json | egrep -m1 name | cut -d\" -f4`

	if [ -z $APP_NAME ]; then
		echo "Couldn't parse application name"
		exit 1
	else
		mrt create ~/$APP_NAME
		rm -rf /vagrant/Apps/$APP_NAME/.meteor && mkdir /vagrant/Apps/$APP_NAME/.meteor
		sudo mount --bind /home/vagrant/$APP_NAME/.meteor/ /vagrant/Apps/$APP_NAME/.meteor/
		echo "sudo mount --bind /home/vagrant/Apps/$APP_NAME/.meteor/ /vagrant/Apps/$APP_NAME/.meteor/" >> ~/.bashrc
	fi
done

