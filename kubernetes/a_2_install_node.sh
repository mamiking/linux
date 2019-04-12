#!/bin/bash

## bash for  centos 7
## create by whc  at 20190412
## 安装k8-node001
## 查看 selinux 状态
sestatus

## 关闭 selinux
sed -i "s/=enforcing/=disabled/g" /etc/selinux/config


yum install -y epel-release
yum update -y

## 安装常规软件
yum install git zip unzip wget curl vim telnet ntp -y


## 修改主机名
hostnamectl set-hostname k8-slave-node001


## reboot 使得环境生效
reboot


## 安装Docker
# 如果之前已经安装过不同版本的docker，先remove,很重要，不删除会出很多问题
yum remove  docker*
rm -rf /var/lib/docker    

yum install -y --nogpgcheck \
    http://mirrors.aliyun.com/docker-engine/yum/repo/main/centos/7/Packages/docker-engine-selinux-1.13.1-1.el7.centos.noarch.rpm \
    http://mirrors.aliyun.com/docker-engine/yum/repo/main/centos/7/Packages/docker-engine-1.13.1-1.el7.centos.x86_64.rpm

## 安装Kubelet
yum install -y --nogpgcheck \
    http://mirrors.aliyun.com/kubernetes/yum/pool/1eed768852fa3e497e1b7bdf4e93afbe3b4b0fdcb59fda801d817736578b9838-kubectl-1.10.5-0.x86_64.rpm \
    http://mirrors.aliyun.com/kubernetes/yum/pool/94d062f2d86b8f4f55f4d23a3610af25931da9168b7f651967c269273955a5a2-kubelet-1.10.5-0.x86_64.rpm \
    http://mirrors.aliyun.com/kubernetes/yum/pool/fe33057ffe95bfae65e2f269e1b05e99308853176e24a4d027bc082b471a07c0-kubernetes-cni-0.6.0-0.x86_64.rpm \
    http://mirrors.aliyun.com/kubernetes/yum/pool/3ea9c50d098c50a7e968c35915d3d8af7f54c58c0cedb0f9603674720743de4e-kubeadm-1.10.5-0.x86_64.rpm

	
# 配置Docker
sed -i "s/\/usr\/bin\/dockerd/\/usr\/bin\/dockerd --exec-opt native.cgroupdriver=systemd/g" /lib/systemd/system/docker.service




#创建 Docker 配置
cat <<EOF > /etc/docker/daemon.json
{   
  "api-enable-cors": true, 
  "api-cors-header": "*", 
  "hosts": ["unix:///var/run/docker.sock", "tcp://0.0.0.0:2375"],
  "registry-mirrors": ["https://4ssmxahm.mirror.aliyuncs.com"],
  "insecure-registries": ["registry.dev.chelizitech.com"]
}
EOF



# 配置Kubelet,注意IP地址
# Environment="KUBELET_DNS_ARGS=--cluster-dns=172.21.0.10 --cluster-domain=cluster.local"
# 这个IP段是172.21 与 serviceSubnet 和  clusterCIDR 保持一致
sed -i "s/\/usr\/bin\/kubelet/\/usr\/bin\/kubelet --pod-infra-container-image=registry.cn-hangzhou.aliyuncs.com\/k10\/pause-amd64:3.1 --fail-swap-on=false/g" /etc/systemd/system/kubelet.service.d/10-kubeadm.conf
vi /etc/systemd/system/kubelet.service.d/10-kubeadm.conf



# 重启Docker 和 kubelet
systemctl daemon-reload
systemctl enable docker
systemctl enable kubelet
systemctl restart docker
systemctl restart kubelet


## 注意 下面这个命令是通过 master的初始化得到的，一定要记住
## 如果忘记了，需要在master上 执行  kubeadm token create --print-join-command 重新生成并获取

kubeadm join 10.9.40.60:6443 --token 8s7ofe.c8p7sj3jv2u43w76 --discovery-token-ca-cert-hash sha256:8d96611839648a79877f62e8316dd78b6cc274b77ea1435f731b33964a5bc21e















