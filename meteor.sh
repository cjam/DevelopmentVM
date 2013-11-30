#!/bin/bash
echo "Installing mongoDB...."
echo [10gen] > /etc/yum.repos.d/10gen.repo
echo name=10gen Repository >> /etc/yum.repos.d/10gen.repo
echo baseurl=http://downloads-distro.mongodb.org/repo/redhat/os/x86_64 >> /etc/yum.repos.d/10gen.repo
echo gpgcheck=0 >> /etc/yum.repos.d/10gen.repo
echo enabled=1 >> /etc/yum.repos.d/10gen.repo
yum update -y
yum install -y mongo-10gen mongo-10gen-server
service mongod start
echo "Installing meteor.js..."
curl https://install.meteor.com | /bin/sh

