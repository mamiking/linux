#!/bin/bash


## bash for  centos 7
## create by whc  at 20190412


## download the rpm

wget https://dev.mysql.com/get/mysql57-community-release-el7-9.noarch.rpm

## repos 安装：/etc/yum.repos.d  下安装 mysql-community.repo mysql-community-source.repo
rpm -ivh mysql57-community-release-el7-9.noarch.rpm


## yum  安装
yum install mysql-server



## mysql 配置
systemctl enable mysqld
systemctl start mysqld

# 获取临时密码 
# 如果没有临时密码，就先删除 rm -rf /var/lib/mysql  然后再次启动 mysql  : systemctl restart mysqld ，再次获取临时密码
grep 'temporary password' /var/log/mysqld.log   


# 用临时密码登录
mysql -u root -p

# 设置新密码,授权，新建用户
set password=password("Cms@123456");
grant all privileges on *.* to root@"%" identified by "Cms@123456";
create user  ctl   IDENTIFIED by 'Dev@1234';
grant select on *.* to ctl@'%';
flush privileges;



## 如果远程不能连接数据库，需要关闭防火墙
systemctl disable firewalld
systemctl stop firewalld