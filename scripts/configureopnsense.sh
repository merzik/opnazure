#!/bin/sh
#OPNSense default configuration template
fetch https://raw.githubusercontent.com/dmauser/opnazure/master/scripts/$1
cp $1 /usr/local/etc/config.xml

# Re-bootstrap the updated version of pkg
env ASSUME_ALWAYS_YES=YES /usr/sbin/pkg bootstrap -f

# 1. Package to get root certificate bundle from the Mozilla Project (FreeBSD)
# 2. Install bash to support Azure Backup integration
env ASSUME_ALWAYS_YES=YES pkg install ca_root_nss && pkg install -y bash 

#Dowload OPNSense Bootstrap and Permit Root Remote Login
fetch https://raw.githubusercontent.com/opnsense/update/21.1.7/bootstrap/opnsense-bootstrap.sh
sed -i "" 's/#PermitRootLogin no/PermitRootLogin yes/' /etc/ssh/sshd_config

#OPNSense
sed -i "" "s/reboot/shutdown -r +1/g" opnsense-bootstrap.sh
sh ./opnsense-bootstrap.sh -y
#Adds support to LB probe from IP 168.63.129.16
fetch https://raw.githubusercontent.com/dmauser/opnazure/master/scripts/lb-conf.sh
sh ./lb-conf.sh
