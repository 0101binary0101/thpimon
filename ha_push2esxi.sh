#!/bin/bash
# 
# author: jka 0101binary0101
# The hard work credit of the vib and the base python: Tom Hebel thebel1  
# Simple script that pushes the files I need over to my ESXI ready for use by HomeAssistant
# to monitor the temperatures remotely 
#
# The script assumes that you may have already setup a public / private key
# on the remote esxi host in the /etc/ssh/keys-root/authorized_keys file
#
#
defaultdstore="/vmfs/volumes/datastore1/ESXITOOLS/native"
esxihost=${1:-""}
if [ "${esxihost}" = "" ]; then
	echo "Please supply a target esxi host to copy the files to"
	echo " example: ${0} 192.168.1.20 "
        echo " Note that it assumes you have created a public / private key "
	echo " and added it to the /etc/ssh/keys-root/authorized_keys file " 
	exit 1
fi
ssh root@${esxihost} "mkdir -p ${defaultdstore}/"
	scp -rp ./build/vib/ root@${esxihost}:${defaultdstore}/pi-temp/
	scp -rp ./pyUtil/ root@${esxihost}:${defaultdstore}/

cat << -EOF-

 Now you need to install the vib file installed 

 1) Make sure that in the ESXI ui, manage -> Security & Users -> Acceptance Level = Community


 2) Install the VIB file by doing the following:

 logon to root@${esxihost}
 cd ${defaultdstore}/pi-temp/
 esxcli software vib install -v  ${defaultdstore}/pi-temp/thpimon-0.1.0-1OEM.701.1.0.40650718.aarch64.vib
 
 you should see:
   Installation Result
   Message: Operation finished successfully.
   Reboot Required: false
   VIBs Installed: THX_bootbank_thpimon_0.1.0-1OEM.701.1.0.40650718
   VIBs Removed:
   VIBs Skipped:


 3) Then shutdown VMs and reboot the ESXI server

 4) After the reboot and logon - 

   and ls -ltr /dev/ | grep vmfg

   Hopefully it should vmgfx32


-EOF-


