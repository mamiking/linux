#!/bin/bash

## bash for  centos 7
## create by whc  at 20190412

## �鿴 selinux ״̬
sestatus

## �ر� selinux
sed -i "s/=enforcing/=disabled/g" /etc/selinux/config




## ���ð�װԴ�������(epel)  �Լ�����
mv  /etc/yum.repos.d/CentOS-Base.repo  /etc/yum.repos.d/CentOS-Base.repo.backup
wget    -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo
#wget   -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.163.com/.help/CentOS7-Base-163.repo

yum clear all
yum makecache
yum install -y epel-release
yum update -y

## ��װ�������
yum install git zip unzip wget curl vim telnet ntp -y






## �޸�������
# hostnamectl set-hostname whc


## �趨ʱ�䣬��ͬ������
## timezone

# timedatectl set-timezone Asia/Shanghai
# yum install -y ntp
# systemctl enable ntpd
# systemctl start ntpd
# ntpdate -u cn.pool.ntp.org


