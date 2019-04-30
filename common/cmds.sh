#!/bin/bash

## bash for  centos 7
## create by whc  at 20190412

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