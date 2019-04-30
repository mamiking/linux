#!/bin/bash

## bash for  centos 7
## create by whc  at 20190412

## =========�鿴centos�汾
cat /etc/redhat-release
lsb_release -a

## ==========�鿴������cpu��Ϣ
cat /proc/cpuinfo | grep name | cut -f2 -d: | uniq -c

## =========����ɾ��10��ǰ����־  .log ����  .ab
find ./ -mtime +10 -type f -name '*.log[ab]' -exec rm -f {} \;
find /data/logs/*/ -mtime +10 -type f -name '*.log[ab]' -exec rm -f {} \;


# ==========����ɾ���ļ�
rm -f $(find ./  -name ver.txt|awk '{print $1}')
## ɾ��ĳ���ļ����µ��ļ�
rm -f $(find ./  -name ver.txt|grep ctl-exam|awk '{print $1}')


## ===========ɱ��ĳ������ ��eg-> killpro  nginx

# killpro bash shell
# !/bin/bash
ps -ef | grep $1 | grep -v grep | awk '{print $2}' | xargs kill -9


## ============�滻����ļ��е��ַ���
# ����ǰĿ¼��������Ŀ¼���������ļ� �е��ַ���  172.16.1.213  �滻��  172.16.1.112
sed -i  's/172.16.1.213/172.16.1.112/g'  `grep -rl 172.16.1.213  ./`

# ������Ӧ�ò�������޸�Ϊ2��
sed -i  's/replicas: 1/replicas: 2/g'  `grep -rl replicas:  ./deploy`

### =========  �������� ���� ����
# ������ĳ���ַ������ļ�����
grep -ir "172.16.1.113" ./ |awk -F: '{print "cp "$1 $1".bak"}'|sh

# ��Ŀ¼������deploy.yml �ļ�����Ϊ deploy.yml.json
find ./  -name  deploy.yml|awk -F: '{print "mv "$1 " "  $1".json"}'|sh