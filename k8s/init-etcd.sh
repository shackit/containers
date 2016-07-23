#!/bin/bash

source ./common.sh

# Download etcd:
function download () {
  cd /tmp

  curl -L \
  https://github.com/coreos/etcd/releases/download/v3.0.1/etcd-v3.0.1-linux-amd64.tar.gz -O

  tar -xvf etcd-v3.0.1-linux-amd64.tar.gz

  sudo cp etcd-v3.0.1-linux-amd64/etcd* /usr/bin/
}

# Configure the etcd service:
function svc_config(){
	if [ ! -f /usr/lib/systemd/system/etcd.service ]
	then
		sudo tee -a /usr/lib/systemd/system/etcd.service<<-EOF
		[Unit]
		Description=Etcd Server
		Documentation=https://github.com/coreos
		After=network.target

		[Service]
		Type=simple
		WorkingDirectory=${etcd_data_dir}
		EnvironmentFile=-/etc/etcd/etcd.conf
		ExecStart=/usr/bin/etcd
		Restart=on-failure
		RestartSec=5

		[Install]
		WantedBy=multi-user.target
		EOF
	fi

}

# Configure etcd:
function etcd_config() {
	if [ ! -f /etc/etcd/etcd.conf ]
	then
		sudo tee -a /etc/etcd/etcd.conf <<-EOF
		# [member]
		ETCD_NAME=default
		ETCD_DATA_DIR="${etcd_data_dir}/default.etcd"
		ETCD_LISTEN_CLIENT_URLS="http://127.0.0.1:2379,http://192.168.1.20:2379"
		ETCD_ADVERTISE_CLIENT_URLS="http://192.168.1.20:2379"
		EOF
	fi
}

conf_dir=/etc/etcd
etcd_data_dir=/var/lib/etcd/

sudo mkdir -p ${conf_dir}
sudo mkdir -p ${etcd_data_dir}

update_host etcd # installs ntp and updates yum
download
etcd_config
svc_config

sudo systemctl daemon-reload
sudo systemctl enable etcd
sudo systemctl start etcd

#etcdctl mk /atomic.io/network/config '{"Network":"172.17.0.0/16"}'
