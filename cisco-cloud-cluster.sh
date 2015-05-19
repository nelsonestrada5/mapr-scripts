heat_template_version: 2013-05-23
description: Template to deploy a 5 node compute cluster with 2 edge nodes
parameters:
  network_id:
    type: string
    label: nerwork id
    description: Network ids to be used for the instances

  public_net:
    type: string
    label: nerwork id
    description: Network ids to be used for the instances

###################################         Edge Node 1        #######################################
resources:
  maprtempedge1_np1:
    type: OS::Neutron::Port
    properties:
      network_id: {get_param: network_id}

  maprtempedge1:
    type: OS::Nova::Server
    properties:
      key_name: mapr-key-001
      image: centos-6.5_x86_64-2015-01-27-v6
      flavor: CO2-Large
      networks:
          - port: { get_resource: maprtempedge1_np1 }
      user_data:
        str_replace:
           template: |
              #!/bin/bash -v
              echo "StrictHostKeyChecking no" > /root/.ssh/config
              echo "IdentityFile ~/.ssh/key.pem" >> /root/.ssh/config
              chmod 644 /root/.ssh/config
              (
              cat << EOF
              -----BEGIN RSA PRIVATE KEY-----
              MIIEpQIBAAKCAQEA1FFbtYCeh9ckuOP7eUelbohi1hJm2aPu40dFaTYAcbaq6VQO
              641qDW6Ysk97qdTPZEKMRpK+WX6IzChv10+s10A8T6J/QlQXC8G4M8C4K89Hsa9E
              CJ/w/6oEQsE0fjTmwRhE9z8K8c+pAgI7U0I85YtTstENs9ZhMic1x5OVLyrsPdXC
              fFbVdgvJ3CZRKVKEkbyEtdfislpE3y2ytYcnX72lc/IDY0FGLSaiD6P9Eg4WO9Ya
              CP174zJ6TykNjSWcNEje3E/mUXRNUNyast+Ahob0W3h/UopGdaC44pqva2lcMeX9
              TaSiJ5P+oW5s7TfxzKxhTYQHuqdTlps6mm2QWQIDAQABAoIBAQDEwfjZRS6k+G4h
              obVkeU8IFgByHm+N9evmWCAtFkxnFT9iJ/IDvPOxKvL7G8mgY4Umhr10kX0xdp/T
              gw3SXRXyDKdXrWF92GvbC1VnMIv8nYT1V1UXIRG3/JkiO+Ynp2LJQ3J2Jsg/u5AG
              Ooc760CAARQ5vJ6UMHG2hrvCDjTMlavoRguh5t7y4X0+k55ipYiB64xsG49ryw3t
              FVz3o+9Rsmfyf32mlyAwXZShnTDC/4DALJTh0Oqlx+/T5Z30ApJFc/UpjZkf81gC
              1rVqrz61kXRaHRLUvfKLvX+bYL3jbhRPWn02vFTa1ssNdkCmKAI4eTbNeBNrOha8
              hSlBGYuZAoGBAPSiF+BAq8bPajR2Y9sbLh9U8pEvAN+QEypQXV3Gd97t5BuODUmy
              0uh6rLn9aTgEm6RA05j67PZgehmOU93xUzytOfuxdkY/q5VHdE/wk0sQUILnGViC
              KIUx4jx5xma5/xohnEU2a4dt7U+FhB2xZbx2fvyjlzOaVDYFR2Kt6VLnAoGBAN4u
              39DRBiRZ7myjHpLtdWekcki9nGp3M51CWK6CShaKGsgRJIy/V0OS+Tcbln0gD1DG
              eb6x5eEtfzBoH8Kbkzin4mgytC8SqtEu6zQeNZwp3BA0n/nUyZ44ucJm2ueeVnCT
              ULSR9dduLU5wVphSYtGHh7WD1XCCbdS6aIg5QNq/AoGAOgOu0dnEYvORZjulVrLN
              b1S/6bpR5LLQOLqySajliJK2A+reL9oetk9RYxI7v7MoDf3psF/hjlQ24JSmQv4W
              FU+nbo8ZU3OKB27YoJSW+bg2v7R6iEjlvyCjXGAssvPtEY9i9e7/9TAWlUM+n6QQ
              Um9vkg5hrzUsP1tlIHvJ14UCgYEAzFuC4zcOlirdgLC8M1oTzaNUtpEoKEjBgZh/
              pusRqA+YuIIEAy0O34l0jfpi/W2aiKo1Wm+YR/gn72cmJ0IfNFI+jaZtUoqx8Ltd
              /M74ck2SKpmstwa/9zanrSYbnERnrx3gcmV6II8nPulWzL2iRKSK7yp2DAj7almW
              Qg2fGFMCgYEAzgUXSwgqpi4FUC/zRAc+QwJxoHPesMhDJKOuheVw7nwrEM1/5bsf
              RWNCKjiO9S5p2ElmvFFd683j/hSYKrHlu97cr/gq8rOqpjRiOtnLDmgftvr9Ad0K
              Sn0EjlHirvwc9VakeqV0odYkLrQCQcwxLVVooxwyO64dApCI+g/iePo=
              -----END RSA PRIVATE KEY-----
              EOF
              )>/root/.ssh/key.pem
              chmod 600 /root/.ssh/key.pem
              (
              cat << EOF
              export OS_TENANT_NAME=CCS-MapR-IoT-US-TEXAS-1
              export OS_AUTH_URL='https://us-texas-1.cisco.com:5000/v2.0/'
              export OS_USERNAME=ilab22
              export OS_PASSWORD=BhjzEKFz
              EOF
              )>/root/openrc
              chmod 755 /root/openrc
              (
              cat << EOF
              [epel]
              name=Extra Packages for Enterprise Linux 6 
              baseurl=http://www.muug.mb.ca/pub/epel/6/x86_64/
              enabled=1
              gpgcheck=0
              EOF
              )>/root/epel.repo
              (
              cat << EOF
              [MapR]
              name=MapR Version 4.0.1
              baseurl=http://package.mapr.com/releases/v4.0.1/redhat/
              enabled=1
              gpgcheck=0
              [MapR_ecosystem]
              name=MapR Ecosystem Components
              baseurl=http://archive.mapr.com/releases/ecosystem-4.x/redhat/
              http://archive.mapr.com/releases/ecosystem-4.x/redhat/
              enabled=1
              gpgcheck=0
              EOF
              )>/root/401.repo
              (
              cat << EOF
              [MapR]
              name=MapR Version 4.0.2
              baseurl=http://package.mapr.com/releases/v4.0.2/redhat/
              enabled=1
              gpgcheck=0
              [MapR_ecosystem]
              name=MapR Ecosystem Components
              baseurl=http://archive.mapr.com/releases/ecosystem-4.x/redhat/
              http://archive.mapr.com/releases/ecosystem-4.x/redhat/
              enabled=1
              gpgcheck=0
              EOF
              )>/root/402.repo
              cp /root/epel.repo /etc/yum.repos.d
              yum clean all
              yum -y install python-devel gcc git
              easy_install pip
              pip install python-novaclient
              git init
              cat /root/openrc >> /root/.bashrc
              source /root/.bashrc
              yum -y install clustershell privoxy 
              sed -i 's/all:.*/all: mapr[1-5]/g' /etc/clustershell/groups
              sed -i 's/^listen-address.*/listen-address 0.0.0.0:8118/g' /etc/privoxy/config
              chkconfig privoxy on
              service privoxy start
              cp /root/.bashrc /tmp/bashrc
              nova list | egrep 'maprtempedge' | awk -F\| '{print $7}' | grep , | awk -F, '{print $2,"edge-ext"}' >> /etc/hosts
              #nova list | egrep 'edge' | awk -F\| '{print $7}' | grep , | awk -F, '{print $1,"edge1"}'  | sed 's/maprtemp=//g' >> /etc/hosts
              nova list | egrep 'maprtempedge' | awk -F\| '{print $7}' | awk -F, '{print $1,"edge1"}'  | sed 's/^.*=//g' >> /etc/hosts
              nova list | egrep 'maprtemp' |grep -v 'edge' | awk -F\| '{print $7}' | grep -v , | sed 's/^.*=//g' | awk 'BEGIN{i=0}{i++;}{print $1,"mapr"i}END{}' >> /etc/hosts

              # Ensure all hosts online
              try=1
              while [ $try -le 10 ] ; do
                  echo "Checking host connectivity"
                  clush -aS date
                  if [ "$?" == "0" ] ; then
                      break
                  fi
                  let try+=1
                  sleep 3
              done
              clush -a -c /etc/hosts --dest /etc/hosts
              echo "set http_proxy=http://edge1:8118" >> /tmp/bashrc
              clush -a -c /tmp/bashrc --dest /root/.bashrc
              clush -a -c /root/epel.repo --dest /etc/yum.repos.d/epel.repo
              yum -y install wget lsof showmount java-1.7.0-openjdk-devel screen xauth 
              ##yum -y install wget lsof showmount java-1.7.0-openjdk-devel screen xauth firefox
              ##yum -y group install "X Window System"
              clush -a yum -y install wget lsof showmount java-1.7.0-openjdk-devel
              sed -i 's/^HOSTNAME=.*/HOSTNAME=edge1/g' /etc/sysconfig/network
              hostname edge1
              nova rename `nova list | grep maprtempedge1 | awk -F\| '{print $3}'` `nova list | grep maprtempedge1 | awk -F\| '{print $3}' | sed -e 's/maprtemp//g'`

              ic="`nova list |grep maprtemp |wc --lines`"
              for i in `seq $ic` ; do
                  ssh mapr$i "sed -i 's/^HOSTNAME=.*/HOSTNAME=mapr'$i'/g' /etc/sysconfig/network"
                  ssh mapr$i "hostname mapr$i"
                  nova rename `nova list | grep maprtemp$i | awk -F\| '{print $3}'` `nova list | grep maprtemp$i | awk -F\| '{print $3}' | sed -e 's/maprtemp/mapr/g'`
                  ###nova rename `nova list | grep maprtemp$i | awk -F\| '{print $3}'` mapr$i
              done
              ##ssh mapr1 "sed -i 's/^HOSTNAME=.*/HOSTNAME=mapr1/g' /etc/sysconfig/network"
              ##ssh mapr2 "sed -i 's/^HOSTNAME=.*/HOSTNAME=mapr2/g' /etc/sysconfig/network"
              ##ssh mapr3 "sed -i 's/^HOSTNAME=.*/HOSTNAME=mapr3/g' /etc/sysconfig/network"
              ##ssh mapr4 "sed -i 's/^HOSTNAME=.*/HOSTNAME=mapr4/g' /etc/sysconfig/network"
              ##ssh mapr5 "sed -i 's/^HOSTNAME=.*/HOSTNAME=mapr5/g' /etc/sysconfig/network"
              #rename instances
              ##nova rename `nova list | grep maprtemp1 | awk -F\| '{print $3}'` mapr1
              ##nova rename `nova list | grep maprtemp2 | awk -F\| '{print $3}'` mapr2
              ##nova rename `nova list | grep maprtemp3 | awk -F\| '{print $3}'` mapr3
              ##nova rename `nova list | grep maprtemp4 | awk -F\| '{print $3}'` mapr4
              ##nova rename `nova list | grep maprtemp5 | awk -F\| '{print $3}'` mapr5
              clush -a useradd mapr
              clush -a -c /root/epel.repo --dest /etc/yum.repos.d

  #maprtempedge1_fp1:
  #   type: OS::Neutron::FloatingIP
  #   properties:
  #      floating_network_id: { get_param: public_net }

  #maprtempedge1_fp1_assoc:
  #   type: OS::Neutron::FloatingIPAssociation
  #   properties:
  #       fixed_ip_address: { get_attr: [maprtempedge1, first_address] }
  #       floatingip_id: { get_resource : maprtempedge1_fp1 }
  #       port_id: { get_resource : maprtempedge1_np1 }

  maprtempedge1_v1:
    type: OS::Cinder::Volume
    properties:
      description: volume 1
      size: 150

  maprtempedge1_volume_attachment_1:
    type: OS::Cinder::VolumeAttachment
    properties:
      volume_id: { get_resource: maprtempedge1_v1 }
      instance_uuid: { get_resource: maprtempedge1 }
      mountpoint: /dev/vdb

###################################         Edge Node 2        #######################################
resources:
  maprtempedge2_np1:
    type: OS::Neutron::Port
    properties:
      network_id: {get_param: network_id}

  maprtempedge2:
    type: OS::Nova::Server
    properties:
      key_name: mapr-key-001
      image: centos-6.5_x86_64-2015-01-27-v6
      flavor: CO2-Large
      networks:
          - port: { get_resource: maprtempedge2_np1 }
      user_data:
        str_replace:
           template: |
              #!/bin/bash -v
              echo "StrictHostKeyChecking no" > /root/.ssh/config
              echo "IdentityFile ~/.ssh/key.pem" >> /root/.ssh/config
              chmod 644 /root/.ssh/config
              (
              cat << EOF
              -----BEGIN RSA PRIVATE KEY-----
              MIIEpQIBAAKCAQEA1FFbtYCeh9ckuOP7eUelbohi1hJm2aPu40dFaTYAcbaq6VQO
              641qDW6Ysk97qdTPZEKMRpK+WX6IzChv10+s10A8T6J/QlQXC8G4M8C4K89Hsa9E
              CJ/w/6oEQsE0fjTmwRhE9z8K8c+pAgI7U0I85YtTstENs9ZhMic1x5OVLyrsPdXC
              fFbVdgvJ3CZRKVKEkbyEtdfislpE3y2ytYcnX72lc/IDY0FGLSaiD6P9Eg4WO9Ya
              CP174zJ6TykNjSWcNEje3E/mUXRNUNyast+Ahob0W3h/UopGdaC44pqva2lcMeX9
              TaSiJ5P+oW5s7TfxzKxhTYQHuqdTlps6mm2QWQIDAQABAoIBAQDEwfjZRS6k+G4h
              obVkeU8IFgByHm+N9evmWCAtFkxnFT9iJ/IDvPOxKvL7G8mgY4Umhr10kX0xdp/T
              gw3SXRXyDKdXrWF92GvbC1VnMIv8nYT1V1UXIRG3/JkiO+Ynp2LJQ3J2Jsg/u5AG
              Ooc760CAARQ5vJ6UMHG2hrvCDjTMlavoRguh5t7y4X0+k55ipYiB64xsG49ryw3t
              FVz3o+9Rsmfyf32mlyAwXZShnTDC/4DALJTh0Oqlx+/T5Z30ApJFc/UpjZkf81gC
              1rVqrz61kXRaHRLUvfKLvX+bYL3jbhRPWn02vFTa1ssNdkCmKAI4eTbNeBNrOha8
              hSlBGYuZAoGBAPSiF+BAq8bPajR2Y9sbLh9U8pEvAN+QEypQXV3Gd97t5BuODUmy
              0uh6rLn9aTgEm6RA05j67PZgehmOU93xUzytOfuxdkY/q5VHdE/wk0sQUILnGViC
              KIUx4jx5xma5/xohnEU2a4dt7U+FhB2xZbx2fvyjlzOaVDYFR2Kt6VLnAoGBAN4u
              39DRBiRZ7myjHpLtdWekcki9nGp3M51CWK6CShaKGsgRJIy/V0OS+Tcbln0gD1DG
              eb6x5eEtfzBoH8Kbkzin4mgytC8SqtEu6zQeNZwp3BA0n/nUyZ44ucJm2ueeVnCT
              ULSR9dduLU5wVphSYtGHh7WD1XCCbdS6aIg5QNq/AoGAOgOu0dnEYvORZjulVrLN
              b1S/6bpR5LLQOLqySajliJK2A+reL9oetk9RYxI7v7MoDf3psF/hjlQ24JSmQv4W
              FU+nbo8ZU3OKB27YoJSW+bg2v7R6iEjlvyCjXGAssvPtEY9i9e7/9TAWlUM+n6QQ
              Um9vkg5hrzUsP1tlIHvJ14UCgYEAzFuC4zcOlirdgLC8M1oTzaNUtpEoKEjBgZh/
              pusRqA+YuIIEAy0O34l0jfpi/W2aiKo1Wm+YR/gn72cmJ0IfNFI+jaZtUoqx8Ltd
              /M74ck2SKpmstwa/9zanrSYbnERnrx3gcmV6II8nPulWzL2iRKSK7yp2DAj7almW
              Qg2fGFMCgYEAzgUXSwgqpi4FUC/zRAc+QwJxoHPesMhDJKOuheVw7nwrEM1/5bsf
              RWNCKjiO9S5p2ElmvFFd683j/hSYKrHlu97cr/gq8rOqpjRiOtnLDmgftvr9Ad0K
              Sn0EjlHirvwc9VakeqV0odYkLrQCQcwxLVVooxwyO64dApCI+g/iePo=
              -----END RSA PRIVATE KEY-----
              EOF
              )>/root/.ssh/key.pem
              chmod 600 /root/.ssh/key.pem
              (
              cat << EOF
              export OS_TENANT_NAME=CCS-MapR-IoT-US-TEXAS-1
              export OS_AUTH_URL='https://us-texas-1.cisco.com:5000/v2.0/'
              export OS_USERNAME=ilab22
              export OS_PASSWORD=BhjzEKFz
              EOF
              )>/root/openrc
              chmod 755 /root/openrc
              (
              cat << EOF
              [epel]
              name=Extra Packages for Enterprise Linux 6 
              baseurl=http://www.muug.mb.ca/pub/epel/6/x86_64/
              enabled=1
              gpgcheck=0
              EOF
              )>/root/epel.repo
              (
              cat << EOF
              [MapR]
              name=MapR Version 4.0.1
              baseurl=http://package.mapr.com/releases/v4.0.1/redhat/
              enabled=1
              gpgcheck=0
              [MapR_ecosystem]
              name=MapR Ecosystem Components
              baseurl=http://archive.mapr.com/releases/ecosystem-4.x/redhat/
              http://archive.mapr.com/releases/ecosystem-4.x/redhat/
              enabled=1
              gpgcheck=0
              EOF
              )>/root/401.repo
              (
              cat << EOF
              [MapR]
              name=MapR Version 4.0.2
              baseurl=http://package.mapr.com/releases/v4.0.2/redhat/
              enabled=1
              gpgcheck=0
              [MapR_ecosystem]
              name=MapR Ecosystem Components
              baseurl=http://archive.mapr.com/releases/ecosystem-4.x/redhat/
              http://archive.mapr.com/releases/ecosystem-4.x/redhat/
              enabled=1
              gpgcheck=0
              EOF
              )>/root/402.repo
              cp /root/epel.repo /etc/yum.repos.d
              yum clean all
              yum -y install python-devel gcc git
              easy_install pip
              pip install python-novaclient
              git init
              cat /root/openrc >> /root/.bashrc
              source /root/.bashrc
              yum -y install clustershell privoxy 
              sed -i 's/all:.*/all: mapr[1-5]/g' /etc/clustershell/groups
              sed -i 's/^listen-address.*/listen-address 0.0.0.0:8118/g' /etc/privoxy/config
              chkconfig privoxy on
              service privoxy start
              cp /root/.bashrc /tmp/bashrc
              nova list | egrep 'maprtempedge' | awk -F\| '{print $7}' | grep , | awk -F, '{print $2,"edge-ext"}' >> /etc/hosts
              #nova list | egrep 'edge' | awk -F\| '{print $7}' | grep , | awk -F, '{print $1,"edge2"}'  | sed 's/maprtemp=//g' >> /etc/hosts
              nova list | egrep 'maprtempedge' | awk -F\| '{print $7}' | awk -F, '{print $1,"edge2"}'  | sed 's/^.*=//g' >> /etc/hosts
              nova list | egrep 'maprtemp' |grep -v 'edge' | awk -F\| '{print $7}' | grep -v , | sed 's/^.*=//g' | awk 'BEGIN{i=0}{i++;}{print $1,"mapr"i}END{}' >> /etc/hosts

              # Ensure all hosts online
              try=1
              while [ $try -le 10 ] ; do
                  echo "Checking host connectivity"
                  clush -aS date
                  if [ "$?" == "0" ] ; then
                      break
                  fi
                  let try+=1
                  sleep 3
              done
              ### clush -a -c /etc/hosts --dest /etc/hosts
              echo "set http_proxy=http://edge2:8118" >> /tmp/bashrc
              clush -a echo "set http_proxy=http://edge2:8118" >> /root/.bashrc # nelson added this
              ### clush -a -c /tmp/bashrc --dest /root/.bashrc
              ### clush -a -c /root/epel.repo --dest /etc/yum.repos.d/epel.repo
              yum -y install wget lsof showmount java-1.7.0-openjdk-devel screen xauth 
              ##yum -y install wget lsof showmount java-1.7.0-openjdk-devel screen xauth firefox
              ##yum -y group install "X Window System"
              ### clush -a yum -y install wget lsof showmount java-1.7.0-openjdk-devel
              sed -i 's/^HOSTNAME=.*/HOSTNAME=edge2/g' /etc/sysconfig/network
              hostname edge2
              nova rename `nova list | grep maprtempedge2 | awk -F\| '{print $3}'` `nova list | grep maprtempedge2 | awk -F\| '{print $3}' | sed -e 's/maprtemp//g'`

              ic="`nova list |grep maprtemp |wc --lines`"
              for i in `seq $ic` ; do
                  ###ssh mapr$i "sed -i 's/^HOSTNAME=.*/HOSTNAME=mapr'$i'/g' /etc/sysconfig/network"
                  ssh mapr$i "hostname mapr$i"
                  ### nova rename `nova list | grep maprtemp$i | awk -F\| '{print $3}'` `nova list | grep maprtemp$i | awk -F\| '{print $3}' | sed -e 's/maprtemp/mapr/g'`
                  ###nova rename `nova list | grep maprtemp$i | awk -F\| '{print $3}'` mapr$i
              done
              ##ssh mapr1 "sed -i 's/^HOSTNAME=.*/HOSTNAME=mapr1/g' /etc/sysconfig/network"
              ##ssh mapr2 "sed -i 's/^HOSTNAME=.*/HOSTNAME=mapr2/g' /etc/sysconfig/network"
              ##ssh mapr3 "sed -i 's/^HOSTNAME=.*/HOSTNAME=mapr3/g' /etc/sysconfig/network"
              ##ssh mapr4 "sed -i 's/^HOSTNAME=.*/HOSTNAME=mapr4/g' /etc/sysconfig/network"
              ##ssh mapr5 "sed -i 's/^HOSTNAME=.*/HOSTNAME=mapr5/g' /etc/sysconfig/network"
              #rename instances
              ##nova rename `nova list | grep maprtemp1 | awk -F\| '{print $3}'` mapr1
              ##nova rename `nova list | grep maprtemp2 | awk -F\| '{print $3}'` mapr2
              ##nova rename `nova list | grep maprtemp3 | awk -F\| '{print $3}'` mapr3
              ##nova rename `nova list | grep maprtemp4 | awk -F\| '{print $3}'` mapr4
              ##nova rename `nova list | grep maprtemp5 | awk -F\| '{print $3}'` mapr5
              ### clush -a useradd mapr
              ### clush -a -c /root/epel.repo --dest /etc/yum.repos.d

  #maprtempedge2_fp1:
  #   type: OS::Neutron::FloatingIP
  #   properties:
  #      floating_network_id: { get_param: public_net }

  #maprtempedge2_fp1_assoc:
  #   type: OS::Neutron::FloatingIPAssociation
  #   properties:
  #       fixed_ip_address: { get_attr: [maprtempedge2, first_address] }
  #       floatingip_id: { get_resource : maprtempedge2_fp1 }
  #       port_id: { get_resource : maprtempedge2_np1 }

  maprtempedge2_v1:
    type: OS::Cinder::Volume
    properties:
      description: volume 1
      size: 150

  maprtempedge2_volume_attachment_1:
    type: OS::Cinder::VolumeAttachment
    properties:
      volume_id: { get_resource: maprtempedge2_v1 }
      instance_uuid: { get_resource: maprtempedge2 }
      mountpoint: /dev/vdb


######################################################################################################
###################################        Cluster Nodes       #######################################
######################################################################################################


###################################           Node 1           #######################################
  maprtemp1_np1:
    type: OS::Neutron::Port
    properties:
      network_id: {get_param: network_id}

  maprtemp1:
    type: OS::Nova::Server
    properties:
      key_name: mapr-key-001
      image: centos-6.5_x86_64-2015-01-27-v6
      flavor: GP2-Xlarge
      networks:
          - port: { get_resource: maprtemp1_np1 }
      user_data:
        str_replace:
           template: |
              #!/bin/bash -v
              echo "StrictHostKeyChecking no" > /root/.ssh/config
              chmod 644 /root/.ssh/config

  maprtemp1_v1:
    type: OS::Cinder::Volume
    properties:
      description: volume 1
      size: 128 

  maprtemp1_vattachment_1:
    type: OS::Cinder::VolumeAttachment
    properties:
      volume_id: { get_resource: maprtemp1_v1 }
      instance_uuid: { get_resource: maprtemp1 }
      mountpoint: /dev/vdb

  maprtemp1_v2:
    type: OS::Cinder::Volume
    properties:
      description: volume 2
      size: 128

  maprtemp1_vattachment_2:
    type: OS::Cinder::VolumeAttachment
    properties:
      volume_id: { get_resource: maprtemp1_v2 }
      instance_uuid: { get_resource: maprtemp1 }
      mountpoint: /dev/vdc

  maprtemp1_v3:
    type: OS::Cinder::Volume
    properties:
      description: volume 3 
      size: 128

  maprtemp1_vattachment_3:
    type: OS::Cinder::VolumeAttachment
    properties:
      volume_id: { get_resource: maprtemp1_v3 }
      instance_uuid: { get_resource: maprtemp1 }
      mountpoint: /dev/vdd

###################################           Node 2           #######################################
  maprtemp2_np1:
    type: OS::Neutron::Port
    properties:
      network_id: {get_param: network_id}

  maprtemp2:
    type: OS::Nova::Server
    properties:
      key_name: mapr-key-001
      image: centos-6.5_x86_64-2015-01-27-v6
      flavor: GP2-Xlarge
      networks:
          - port: { get_resource: maprtemp2_np1 }
      user_data:
        str_replace:
           template: |
              #!/bin/bash -v
              echo "StrictHostKeyChecking no" > /root/.ssh/config
              chmod 644 /root/.ssh/config

  maprtemp2_v1:
    type: OS::Cinder::Volume
    properties:
      description: volume 1
      size: 128 

  maprtemp2_vattachment_1:
    type: OS::Cinder::VolumeAttachment
    properties:
      volume_id: { get_resource: maprtemp2_v1 }
      instance_uuid: { get_resource: maprtemp2 }
      mountpoint: /dev/vdb

  maprtemp2_v2:
    type: OS::Cinder::Volume
    properties:
      description: volume 2
      size: 128

  maprtemp2_vattachment_2:
    type: OS::Cinder::VolumeAttachment
    properties:
      volume_id: { get_resource: maprtemp2_v2 }
      instance_uuid: { get_resource: maprtemp2 }
      mountpoint: /dev/vdc

  maprtemp2_v3:
    type: OS::Cinder::Volume
    properties:
      description: volume 3 
      size: 128

  maprtemp2_vattachment_3:
    type: OS::Cinder::VolumeAttachment
    properties:
      volume_id: { get_resource: maprtemp2_v3 }
      instance_uuid: { get_resource: maprtemp2 }
      mountpoint: /dev/vdd

###################################           Node 3           #######################################
  maprtemp3_np1:
    type: OS::Neutron::Port
    properties:
      network_id: {get_param: network_id}

  maprtemp3:
    type: OS::Nova::Server
    properties:
      key_name: mapr-key-001
      image: centos-6.5_x86_64-2015-01-27-v6
      flavor: GP2-Xlarge
      networks:
          - port: { get_resource: maprtemp3_np1 }
      user_data:
        str_replace:
           template: |
              #!/bin/bash -v
              echo "StrictHostKeyChecking no" > /root/.ssh/config
              chmod 644 /root/.ssh/config

  maprtemp3_v1:
    type: OS::Cinder::Volume
    properties:
      description: volume 1
      size: 128 

  maprtemp3_vattachment_1:
    type: OS::Cinder::VolumeAttachment
    properties:
      volume_id: { get_resource: maprtemp3_v1 }
      instance_uuid: { get_resource: maprtemp3 }
      mountpoint: /dev/vdb

  maprtemp3_v2:
    type: OS::Cinder::Volume
    properties:
      description: volume 2
      size: 128

  maprtemp3_vattachment_2:
    type: OS::Cinder::VolumeAttachment
    properties:
      volume_id: { get_resource: maprtemp3_v2 }
      instance_uuid: { get_resource: maprtemp3 }
      mountpoint: /dev/vdc

  maprtemp3_v3:
    type: OS::Cinder::Volume
    properties:
      description: volume 3 
      size: 128

  maprtemp3_vattachment_3:
    type: OS::Cinder::VolumeAttachment
    properties:
      volume_id: { get_resource: maprtemp3_v3 }
      instance_uuid: { get_resource: maprtemp3 }
      mountpoint: /dev/vdd
      
 ###################################           Node 4           #######################################
  maprtemp4_np1:
    type: OS::Neutron::Port
    properties:
      network_id: {get_param: network_id}

  maprtemp4:
    type: OS::Nova::Server
    properties:
      key_name: mapr-key-001
      image: centos-6.5_x86_64-2015-01-27-v6
      flavor: GP2-Xlarge
      networks:
          - port: { get_resource: maprtemp4_np1 }
      user_data:
        str_replace:
           template: |
              #!/bin/bash -v
              echo "StrictHostKeyChecking no" > /root/.ssh/config
              chmod 644 /root/.ssh/config

  maprtemp4_v1:
    type: OS::Cinder::Volume
    properties:
      description: volume 1
      size: 128 

  maprtemp4_vattachment_1:
    type: OS::Cinder::VolumeAttachment
    properties:
      volume_id: { get_resource: maprtemp4_v1 }
      instance_uuid: { get_resource: maprtemp4 }
      mountpoint: /dev/vdb

  maprtemp4_v2:
    type: OS::Cinder::Volume
    properties:
      description: volume 2
      size: 128

  maprtemp4_vattachment_2:
    type: OS::Cinder::VolumeAttachment
    properties:
      volume_id: { get_resource: maprtemp4_v2 }
      instance_uuid: { get_resource: maprtemp4 }
      mountpoint: /dev/vdc

  maprtemp4_v3:
    type: OS::Cinder::Volume
    properties:
      description: volume 3 
      size: 128

  maprtemp4_vattachment_3:
    type: OS::Cinder::VolumeAttachment
    properties:
      volume_id: { get_resource: maprtemp4_v3 }
      instance_uuid: { get_resource: maprtemp4 }
      mountpoint: /dev/vdd
      
###################################           Node 5           #######################################
  maprtemp5_np1:
    type: OS::Neutron::Port
    properties:
      network_id: {get_param: network_id}

  maprtemp5:
    type: OS::Nova::Server
    properties:
      key_name: mapr-key-001
      image: centos-6.5_x86_64-2015-01-27-v6
      flavor: GP2-Xlarge
      networks:
          - port: { get_resource: maprtemp5_np1 }
      user_data:
        str_replace:
           template: |
              #!/bin/bash -v
              echo "StrictHostKeyChecking no" > /root/.ssh/config
              chmod 644 /root/.ssh/config

  maprtemp5_v1:
    type: OS::Cinder::Volume
    properties:
      description: volume 1
      size: 128 

  maprtemp5_vattachment_1:
    type: OS::Cinder::VolumeAttachment
    properties:
      volume_id: { get_resource: maprtemp5_v1 }
      instance_uuid: { get_resource: maprtemp5 }
      mountpoint: /dev/vdb

  maprtemp5_v2:
    type: OS::Cinder::Volume
    properties:
      description: volume 2
      size: 128

  maprtemp5_vattachment_2:
    type: OS::Cinder::VolumeAttachment
    properties:
      volume_id: { get_resource: maprtemp5_v2 }
      instance_uuid: { get_resource: maprtemp5 }
      mountpoint: /dev/vdc

  maprtemp5_v3:
    type: OS::Cinder::Volume
    properties:
      description: volume 3 
      size: 128

  maprtemp5_vattachment_3:
    type: OS::Cinder::VolumeAttachment
    properties:
      volume_id: { get_resource: maprtemp5_v3 }
      instance_uuid: { get_resource: maprtemp5 }
      mountpoint: /dev/vdd           
