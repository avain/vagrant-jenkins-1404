#!/bin/bash

# Many parts borrowed from varying-vagrant-vagrants https://github.com/Varying-Vagrant-Vagrants

# Provisioning script for Jenkins-CI server

sudo -i

# Quick fix to enable vbguest on VirtualBox 4.3.10
# See https://github.com/mitchellh/vagrant/issues/3341
if [ ! -e /usr/lib/VBoxGuestAdditions ]; then
		sudo ln -s /opt/VBoxGuestAdditions-4.3.10/lib/VBoxGuestAdditions \
		/usr/lib/VBoxGuestAdditions || true
fi

# Capture a basic ping result to Google's primary DNS server to determine if
# outside access is available to us. If this does not reply after 2 attempts,
# we try one of Level3's DNS servers as well. If neither IP replies to a ping,
# then we'll skip a few things further in provisioning rather than creating a
# bunch of errors.

ping_result="$(ping -c 2 8.8.4.4 2>&1)"
if [[ $ping_result != *bytes?from* ]]; then
	ping_result="$(ping -c 2 4.2.2.2 2>&1)"
fi

# Bash array that will contain packages to install with apt-get
apt_package_install_list=(

			# default web server will be apache
			apache2

			# misc items
			git-core
			zip
			unzip
			ngrep
			curl
			make
			vim

			g++

			# Java
			openjdk-7-jre

			# Jenkins
			jenkins

			# Ruby
			ruby2.1

	)

if [[ $ping_result == *bytes?from* ]]; then

	#Jenkins repo
	wget -q -O - http://pkg.jenkins-ci.org/debian/jenkins-ci.org.key | sudo apt-key add -
	sh -c 'echo deb http://pkg.jenkins-ci.org/debian binary/ > /etc/apt/sources.list.d/jenkins.list'

	# Ruby repo
	add-apt-repository ppa:brightbox/ruby-ng

	# Update the repos
	echo "Running apt-get update..."
		apt-get update --assume-yes

	# Install items in apt_package_install_list array
	echo "Installing apt-get packages..."
	apt-get install --assume-yes ${apt_package_install_list[@]}

	# Clear up apt caches
	apt-get clean
fi

# Nodejs Install
cd /tmp
wget http://nodejs.org/dist/v0.10.26/node-v0.10.26-linux-x64.tar.gz
tar -xzf node*
mv node-v0.10.26-linux-x64 /usr/local/nodejs
ln -s /usr/local/nodejs/bin/node /usr/local/bin/node
ln -s /usr/local/nodejs/bin/npm /usr/local/bin/npm

# Grunt install and config

echo "Installing Grunt CLI"
npm install -g grunt-cli &>/dev/null

# Capistrano install
gem install capistrano

# RESTART SERVICES
#
# Make sure the services we expect to be running are running.
echo -e "\nRestart services..."
service apache2 restart

echo "Server provisioned...done"













