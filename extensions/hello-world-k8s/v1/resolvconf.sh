#!/bin/bash
sudo apt -y update
sudo apt-get --assume-yes install resolvconf

DNSSERVERS=$(systemd-resolve --status | grep -A3 'DNS Servers' |  awk {'print $NF'} | tail -4) 
STRING='nameserver '

for NAMESERVER in ${DNSSERVERS[@]}
do    
  RESULT=$STRING$NAMESERVER   
  if grep -xq "$RESULT" /etc/resolvconf/resolv.conf.d/head
then
  echo "Nameserver is already in place"
else
  echo "$RESULT" >> /etc/resolvconf/resolv.conf.d/head
fi  
done

if grep -xq "search xcloud.com" /etc/resolvconf/resolv.conf.d/base
then
  echo "Domain setting is already in place"
else
  echo "search xcloud.com" >> /etc/resolvconf/resolv.conf.d/base
fi
systemctl restart resolvconf