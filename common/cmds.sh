#!/bin/bash

## bash for  centos 7
## create by whc  at 20190412

## ====ssh 免密码登录 和执行
ssh-copy-id  root@10.9.40.111
## 初次访问 10.9.40.111或者执行10.9.40.111上的脚本，会要求 确认是否信任
## 免除这种确认的方法
ssh -o "StrictHostKeyChecking no" root@10.9.40.212 "/root/deploy/prod/deploy.py"

# or
ssh  -o StrictHostKeyChecking=no  root@192.168.0.110   /root/bin/gitUpdate

### or 修改 /etc/ssh/ssh_config 加入
Host *
 StrictHostKeyChecking no
## 然后执行
ssh  root@192.168.0.110   /root/bin/gitUpdate

### git hooks  post-receive 
ssh -p 22 root@10.9.40.102 '/root/bin/gitupdate'
 


## =========查看centos版本
cat /etc/redhat-release
lsb_release -a

## ==========查看服务器cpu信息
cat /proc/cpuinfo | grep name | cut -f2 -d: | uniq -c

## =========批量删除10天前的日志  .log 或者  .ab
find ./ -mtime +10 -type f -name '*.log[ab]' -exec rm -f {} \;
find /data/logs/*/ -mtime +10 -type f -name '*.log[ab]' -exec rm -f {} \;


# ==========批量删除文件
rm -f $(find ./  -name ver.txt|awk '{print $1}')
## 删除某个文件夹下的文件
rm -f $(find ./  -name ver.txt|grep ctl-exam|awk '{print $1}')


## ===========杀死某个进程 ：eg-> killpro  nginx

# killpro bash shell
# !/bin/bash
ps -ef | grep $1 | grep -v grep | awk '{print $2}' | xargs kill -9


## ============替换多个文件中的字符串
# 将当前目录（包括子目录）下所有文件 中的字符串  172.16.1.213  替换成  172.16.1.112
sed -i  's/172.16.1.213/172.16.1.112/g'  `grep -rl 172.16.1.213  ./`

# 将所有应用部署份数修改为2个
sed -i  's/replicas: 1/replicas: 2/g'  `grep -rl replicas:  ./deploy`

### =========  批量备份 或者 改名
# 将含有某个字符串的文件备份
grep -ir "172.16.1.113" ./ |awk -F: '{print "cp "$1 $1".bak"}'|sh

# 将目录下所有deploy.yml 文件改名为 deploy.yml.json
find ./  -name  deploy.yml|awk -F: '{print "mv "$1 " "  $1".json"}'|sh


## 获取本机出口IP地址
curl 200019.ip138.com