#!/bin/bash
##�����(10.9.40.129)��

#��װ����
yum -y install nfs-utils
systemctl enable nfs
systemctl start nfs
systemctl enable rpcbind


#�༭nfs����Ŀ¼���ͻ���Ȩ��
vim  /etc/exports


/data/files 10.9.40.132(rw,no_root_squash,no_all_squash,sync)    


#��������
systemctl restart nfs


## �鿴
rpcinfo -p 10.9.40.129
showmount -e localhost


##�ͻ���(10.9.40.132)��
yum -y install nfs-utils
systemctl enable nfs
systemctl start nfs

#soft ����ģʽ��ʹ�÷���˹ػ�������£��ͻ��˲����ڿ���

mount -t nfs  -o rw,intr,soft,timeo=30,retry=3  10.9.40.129:/data/files  /data/files


## ����һ����Чû��
touch /data/files/abc

�ӷ���˼��ɲ鿴�Ƿ��Ѿ������ļ� /data/files/abc

#��������
vim /etc/fstab
10.9.40.129:/data/files  /data/files   nfs rw,soft,intr 0 0

