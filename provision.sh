wget -q -O - https://pkg.jenkins.io/debian/jenkins-ci.org.key | sudo apt-key add -
sudo sh -c 'echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
sudo apt-get --assume-yes update 
sudo apt-get --assume-yes install jenkins
sudo apt-get --assume-yes update 
sudo apt-get --assume-yes install jenkins