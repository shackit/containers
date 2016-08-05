#!/bin/bash

update_host() {
  sudo yum -y update
	sudo yum -y clean all

  sudo hostnamectl set-hostname $1

  sudo yum -y install ntp

	sudo systemctl stop firewalld
	sudo systemctl disable firewalld

  sudo systemctl start ntpd
  sudo systemctl enable ntpd
}
