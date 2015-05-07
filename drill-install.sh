#!/bin/bash
# nestrada@maprtech.com 2015-May-7
# Script to Install and Configure Apache Drill
[ $(id -u) -ne 0 ] && { echo This script must be run as root; exit 1; }

# Configure clush groups
grep '## AUTOGEN-DRILL ##' /etc/clustershell/groups >/dev/null 2>&1
if [ "$?" != "0" ] ; then
        cat <<EOF >> /etc/clustershell/groups

## AUTOGEN-DRILL ##
drill: mapr[1-2]
EOF
fi

#install Drill
clush -g drill "yum install -y mapr-drill"

# run configure
clush -g drill "/opt/mapr/server/configure.sh -R"

sleep 5

NODES_IPS=$(clush -g drill "hostname -i" | cut -d " " -f 2)

# start drill bits
echo "Starting Drill Bits"
maprcli node services -name drill-bits -action start -nodes $NODES_IPS
