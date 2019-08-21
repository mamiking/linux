#!/bin/bash
##服务端(10.9.40.129)：

#安装服务
yum -y install nfs-utils
systemctl enable nfs
systemctl start nfs
systemctl enable rpcbind


#编辑nfs共享目录，客户端权限
vim  /etc/exports


/data/files 10.9.40.132(rw,no_root_squash,no_all_squash,sync)    


#重启服务
systemctl restart nfs


## 查看
rpcinfo -p 10.9.40.129
showmount -e localhost


##客户端(10.9.40.132)：
yum -y install nfs-utils
systemctl enable nfs
systemctl start nfs

#soft 挂载模式，使得服务端关机的情况下，客户端不至于卡死

mount -t nfs  -o rw,intr,soft,timeo=30,retry=3  10.9.40.129:/data/files  /data/files


## 尝试一下生效没有
touch /data/files/abc

从服务端即可查看是否已经生成文件 /data/files/abc

#开机挂载
vim /etc/fstab
10.9.40.129:/data/files  /data/files   nfs rw,soft,intr 0 0

