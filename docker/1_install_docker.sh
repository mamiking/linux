#!/bin/bash
## ��װDocker
# ���֮ǰ�Ѿ���װ����ͬ�汾��docker����remove,����Ҫ����ɾ������ܶ�����
yum remove  docker*
rm -rf /var/lib/docker    

yum install -y --nogpgcheck \
    http://mirrors.aliyun.com/docker-engine/yum/repo/main/centos/7/Packages/docker-engine-selinux-1.13.1-1.el7.centos.noarch.rpm \
    http://mirrors.aliyun.com/docker-engine/yum/repo/main/centos/7/Packages/docker-engine-1.13.1-1.el7.centos.x86_64.rpm