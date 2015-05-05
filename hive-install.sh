#!/bin/bash
# nestrada@maprtech.com 2015-May-1
# Script to Install and Configure MySQL, Hive, Hive Metastore, and HiveServer2
# hive-site.xml used below merges the configuration properties from both John Benninghoff's & Dmitry Gomerman' files

# Configure clush groups
grep '## AUTOGEN-HIVE ##' /etc/clustershell/groups >/dev/null 2>&1
if [ "$?" != "0" ] ; then
        cat <<EOF >> /etc/clustershell/groups

## AUTOGEN-HIVE ##
mysql: mapr2
hivemeta: mapr2
hs2: mapr2
EOF
fi

# Install mysql, hive, hive metastore, and hiveserver2
clush -g mysql "yum install -y mysql-server"
clush -g hivemeta "yum install -y mapr-hive  mapr-hivemetastore mysql"
clush -g hs2 "yum install -y mapr-hiveserver2 mysql"

# Initial mysql configuration
clush -g mysql "/etc/init.d/mysqld start"
# Set mysql root password
ROOT_PASSWORD=mapr
clush -g mysql "mysqladmin -u root password $ROOT_PASSWORD"

# Node variables needed for mysql and hive-site.xml configuration
MYSQL_NODE=$(nodeset -e @mysql)
METASTORE_NODE=$(nodeset -e @hivemeta)
HS2_NODE=$(nodeset -e @hs2)
ZK_NODES=$(nodeset -S, -e @zk)

# Set up mysql database, users, and privileges
DATABASE=hive
USER=hive
PASSWORD=mapr
clush -g mysql mysql -u root -p$ROOT_PASSWORD << EOF
create database $DATABASE;
create user '$USER'@'%' identified by '$PASSWORD';
grant all privileges on $DATABASE.* to '$USER'@'%' with grant option;
create user '$USER'@'localhost' IDENTIFIED BY '$PASSWORD';
grant all privileges on $DATABASE.* to '$USER'@'localhost' with grant option;
create user '$USER'@'$METASTORE_NODE' IDENTIFIED BY '$PASSWORD';
grant all privileges on $DATABASE.* to '$USER'@'$METASTORE_NODE' with grant option;
create user '$USER'@'$HS2_NODE' IDENTIFIED BY '$PASSWORD';
grant all privileges on $DATABASE.* to '$USER'@'$HS2_NODE' with grant option;
flush privileges;
EOF

# The driver for the MySQL JDBC connector (a jar file) is part of the MapR distribution under /opt/mapr/lib/.
# Link this jar file into the Hive lib directory.
clush -g mysql "ln -s /opt/mapr/lib/mysql-connector-java-5.1.25-bin.jar /opt/mapr/hive/hive-0.13/lib/mysql-connector-java-5.1.25-bin.jar"

# Create or overwrite the hive-site.xml
clush -g hivemeta,hs2 "cat - << EOF > /opt/mapr/hive/hive-0.13/conf/hive-site.xml
<?xml version=\"1.0\"?>
<?xml-stylesheet type=\"text/xsl\" href=\"configuration.xsl\"?>
<!--
   Licensed to the Apache Software Foundation (ASF) under one or more
   contributor license agreements.  See the NOTICE file distributed with
   this work for additional information regarding copyright ownership.
   The ASF licenses this file to You under the Apache License, Version 2.0
   (the "License"); you may not use this file except in compliance with
   the License.  You may obtain a copy of the License at
       http://www.apache.org/licenses/LICENSE-2.0
   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
-->

<configuration>
<!-- Hive client, metastore and server configuration all contained in this config file as of Hive 0.13 -->


<!-- Client Configuration ========================  -->
<property>
    <name>hive.metastore.uris</name>
    <value>thrift://$METASTORE_NODE:9083</value>
    <description>Use blank(no value) to enable local metastore, use a URI to connect to a 'remote'(networked) metastore.</description>
</property>


<!-- MetaStore Configuration ========================  -->
<!-- https://cwiki.apache.org/confluence/display/Hive/Configuration+Properties#ConfigurationProperties-MetaStore -->
<property>
    <name>javax.jdo.option.ConnectionURL</name>
    <value>jdbc:mysql://$MYSQL_NODE:3306/hive?createDatabaseIfNotExist=true</value>
    <description>JDBC connect string for a JDBC metastore such as MySQL</description>
</property>

<property>
    <name>javax.jdo.option.ConnectionDriverName</name>
    <value>com.mysql.jdbc.Driver</value>
    <description>Driver class name for a JDBC metastore</description>
</property>

<property>
    <name>javax.jdo.option.ConnectionUserName</name>
    <value>$USER</value>
    <description>username to use against metastore database</description>
</property>

<property>
    <name>javax.jdo.option.ConnectionPassword</name>
    <value>$PASSWORD</value>
    <description>password to use against metastore database</description>
</property>

<property>
    <name>hive.metastore.execute.setugi</name>
    <value>true</value>
    <description> Set this property to enable Hive Metastore service impersonation in unsecure mode. In unsecure mode, setting this property to true causes the metastore to execute DFS operations using the client's reported user and group permissions. Note that this property must be set on BOTH the client and server sides. Further note that its best effort. If client sets its to true and server sets it to false, client setting will be ignored. </description>
</property>


<!-- Hive Server Configuration ========================  -->
<!-- https://cwiki.apache.org/confluence/display/Hive/Configuration+Properties#ConfigurationProperties-HiveServer2 -->
<property>
    <name>hive.server2.thrift.port</name>
    <value>10001</value>
    <description>TCP port number for Hive Server to listen on, default 10000, conflict with webmin</description>
</property>

<property>
    <name>hive.server2.enable.impersonation</name>
    <value>true</value>
    <description>Set this property to enable impersonation in Hive Server 2, not in above URL?</description>
</property>

<property>
    <name>hive.server2.enable.doAs</name>
    <value>true</value>
    <description>Set this property to enable impersonation in Hive Server 2</description>
</property>


<!-- Misc Configuration ========================  -->
<!-- commented out
<property>
    <name>hive.support.concurrency</name>
    <value>true</value>
    <description>Enable Hive's Table Lock Manager Service, requires zookeeper config</description>
</property>

<property>
    <name>hive.zookeeper.quorum</name>
    <value>$ZK_NODES</value>
    <description>Zookeeper quorum used by Hive's Table Lock Manager</description>
</property>

<property>
    <name>hive.zookeeper.client.port</name>
    <value>5181</value>
    <description>The Zookeeper client port. The MapR default clientPort is 5181.</description>
</property>

<property>
    <name>datanucleus.autoCreateSchema</name>
    <value>true</value>
</property>

<property>
    <name>datanucleus.autoCreateTables</name>
    <value>true</value>
</property>

<property>
    <name>datanucleus.autoCreateColumns</name>
    <value>true</value>
</property>

<property>
    <name>datanucleus.fixedDatastore</name>
    <value>false</value>
</property>

<property>
    <name>datanucleus.autoStartMechanism</name>
    <value>SchemaTable</value>
</property>

<property>
    <name>hive.server2.authentication</name>
    <value>PAM</value>
</property>

<property>
    <name>hive.server2.authentication.pam.services</name>
    <value>login,sudo</value>
    <description>comma separated list of pam modules to verify</description>
</property>

<property>
    <name>hive.security.authorization.enabled</name>
    <value>false</value>
</property>

<property>
    <name>hive.security.authorization.manager</name>
    <value>org.apache.hadoop.hive.ql.security.authorization.StorageBasedAuthorizationProvider</value>
</property>

<property>
    <name>hive.metastore.pre.event.listeners</name>
    <value>org.apache.hadoop.hive.ql.security.authorization.AuthorizationPreEventListener</value>
</property>

<property>
    <name>hive.security.metastore.authorization.manager</name>
    <value>org.apache.hadoop.hive.ql.security.authorization.StorageBasedAuthorizationProvider</value>
</property>

<property>
  <name>hive.optimize.insert.dest.volume</name>
  <value>true</value>
  <description>For CREATE TABLE AS and INSERT queries create the scratch directory under the destination directory. This avoids the data move across volumes and improves performance.</description>
</property>
-->

</configuration>
EOF
"
clush -a "/opt/mapr/server/configure.sh -R"

sleep 5

#stop and start Metastore and HiveServer2
maprcli node services -name hivemeta -action start -nodes $METASTORE_NODE
maprcli node services -name hs2 -action start -nodes $HS2_NODE
