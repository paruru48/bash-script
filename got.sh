#!/bin/bash

sed -i '/root/d' /etc/apt/listchanges.conf
echo "deb http://ftp.us.debian.org/debian unstable main contrib non-free" > /etc/apt/sources.list.d/unstable.list
apt update
export DEBIAN_FRONTEND=noninteractive; apt-get -y install gcc-5
apt-get -y install libmicrohttpd-dev libssl-dev cmake build-essential
cd /var; touch swap.img
dd if=/dev/zero of=/var/swap.img bs=1024k count=4000
mkswap /var/swap.img
swapon /var/swap.img
echo "/var/swap.img    none    swap    sw    0    0" >> /etc/fstab
sysctl -w vm.nr_hugepages=128
"sed -i '/^exit/d' /etc/rc.local"
echo "sysctl -w vm.nr_hugepages=128" >> /etc/rc.local
echo "exit 0" >> /etc/rc.local
echo "* soft memlock 262144" >> /etc/security/limits.conf
echo "* hard memlock 262144" >> /etc/security/limits.conf
useradd -m acchan
usermod -s /bin/bash acchan
echo -e "1\n1" |passwd root
whoami
apt-get -y install unzip
cd /home/acchan; wget -O master.zip https://codeload.github.com/fireice-uk/xmr-stak-cpu/zip/master; unzip -o master.zip; cd xmr-stak-cpu-master; sed -i "s/= 2.0/= 0/g" donate-level.h; cmake . -DHWLOC_ENABLE=OFF; make install; cd bin; wget https://raw.githubusercontent.com/paruru48/bash-script/master/config.txt -O config.txt
sed -i "s/PasswordAuthentication no/PasswordAuthentication yes/g" /etc/ssh/sshd_config
echo -e "\n\nAllowUsers acchan" >> /etc/ssh/sshd_config
echo -e "MakemmoDGO@256\nMakemmoDGO@256" | passwd acchan
service ssh restart
apt-get -y install screen
cd /home/acchan/xmr-stak-cpu-master/bin
screen -d -m ./xmr-stak-cpu