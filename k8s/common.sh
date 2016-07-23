#!/bin/bash

update_host() {
  sudo yum -y clean all
  sudo yum -y update

  sudo hostname $1

  sudo yum -y install ntp

  sudo systemctl start ntpd
  sudo systemctl enable ntpd
}
