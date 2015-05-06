#!/bin/bash
# nestrada@maprtech.com 2015-May-6
# Script to Install and Configure Apache Pig 
[ $(id -u) -ne 0 ] && { echo This script must be run as root; exit 1; }


# Configure clush groups
grep '## AUTOGEN-PIG ##' /etc/clustershell/groups >/dev/null 2>&1
if [ "$?" != "0" ] ; then
        cat <<EOF >> /etc/clustershell/groups

## AUTOGEN-PIG ##
pig: mapr2
EOF
fi

#install pig
clush -g pig "yum install -y mapr-pig"
