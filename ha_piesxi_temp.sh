#!/bin/bash

SCRIPTDIR=$( dirname "${BASH_SOURCE[0]}" )
echo "Reading config....${SCRIPTDIR}/ha_piesxi_config.ini"
. ${SCRIPTDIR}/ha_piesxi_config.ini

for thisline in $servers
do 
 thisnode="`echo $thisline | cut -f 1 -d :`"
 thisout="`echo $thisline | cut -f 2 -d :`"
 echo "processing {$thisnode} {$thisout} " 
 ssh -i ${privkey} -o BatchMode=yes -o ConnectionAttempts=1 -o ConnectTimeout=10 -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o PasswordAuthentication=no $thisnode "python ${ESXIPYSCRIPT}" | grep FirmwareRev  > ${HASSIOSHARE}/.${thisout}.json.new 2>/dev/null
 mv ${HASSIOSHARE}/.${thisout}.json.new ${HASSIOSHARE}/${thisout}.json
done 
