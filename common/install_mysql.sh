#!/bin/bash


## bash for  centos 7
## create by whc  at 20190412


## download the rpm

wget https://dev.mysql.com/get/mysql57-community-release-el7-9.noarch.rpm

## repos ��װ��/etc/yum.repos.d  �°�װ mysql-community.repo mysql-community-source.repo
rpm -ivh mysql57-community-release-el7-9.noarch.rpm


## yum  ��װ
yum install mysql-server



## mysql ����
systemctl enable mysqld
systemctl start mysqld

# ��ȡ��ʱ���� 
# ���û����ʱ���룬����ɾ�� rm -rf /var/lib/mysql  Ȼ���ٴ����� mysql  : systemctl restart mysqld ���ٴλ�ȡ��ʱ����
grep 'temporary password' /var/log/mysqld.log   


# ����ʱ�����¼
mysql -u root -p

# ����������,��Ȩ���½��û�
set password=password("Cms@123456");
grant all privileges on *.* to root@"%" identified by "Cms@123456";
create user  ctl   IDENTIFIED by 'Dev@1234';
grant select on *.* to ctl@'%';
flush privileges;



## ���Զ�̲����������ݿ⣬��Ҫ�رշ���ǽ
systemctl disable firewalld
systemctl stop firewalld