#!/bin/bash

## bash for  centos 7
## create by whc  at 20190412

## 查看 selinux 状态
sestatus

## 关闭 selinux
sed -i "s/=enforcing/=disabled/g" /etc/selinux/config




## 配置安装源，软件包(epel)  以及更新
mv  /etc/yum.repos.d/CentOS-Base.repo  /etc/yum.repos.d/CentOS-Base.repo.backup
wget    -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo
#wget   -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.163.com/.help/CentOS7-Base-163.repo

yum clear all
yum makecache
yum install -y epel-release
yum update -y

## 安装常规软件
yum install git zip unzip wget curl vim telnet ntp -y






## 修改主机名
# hostnamectl set-hostname whc


## 设定时间，并同步网络
## timezone

# timedatectl set-timezone Asia/Shanghai
# yum install -y ntp
# systemctl enable ntpd
# systemctl start ntpd
# ntpdate -u cn.pool.ntp.org


