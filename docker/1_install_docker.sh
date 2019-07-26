#!/bin/bash
## 安装Docker
# 如果之前已经安装过不同版本的docker，先remove,很重要，不删除会出很多问题
yum remove  docker*
rm -rf /var/lib/docker    

yum install -y --nogpgcheck \
    http://mirrors.aliyun.com/docker-engine/yum/repo/main/centos/7/Packages/docker-engine-selinux-1.13.1-1.el7.centos.noarch.rpm \
    http://mirrors.aliyun.com/docker-engine/yum/repo/main/centos/7/Packages/docker-engine-1.13.1-1.el7.centos.x86_64.rpm