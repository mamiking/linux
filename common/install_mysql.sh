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
## ����Ҫ���ӣ����Կ��ǽ���������趨ΪLOW
set global validate_password_policy=LOW;

set password=password("Cms@123456");
grant all privileges on *.* to root@"%" identified by "Cms@123456";
create user  ctl   IDENTIFIED by 'Dev@1234';
grant select on *.* to ctl@'%';
flush privileges;


## my.cnf ����

## ע��Ĭ�����ݿ��ַΪ /var/lib/mysql,����޸� datadir����Ҫ����[mysqld] [client] ֮�²���socket·��һ��
### ����
vim /etc/my.cnf

[client]
socket=/tmp/mysql.sock

[mysqld]
datadir=/data/mysql
socket=/tmp/mysql.sock



sql_mode =''
character-set-client-handshake = FALSE
character-set-server = utf8mb4
collation-server = utf8mb4_unicode_ci
init_connect='SET NAMES utf8mb4'
max_connections=2000




## ���Զ�̲����������ݿ⣬��Ҫ�رշ���ǽ
systemctl disable firewalld
systemctl stop firewalld