#!/bin/bash

## bash for  centos 7
## create by whc  at 20190412
## 安装k8-master

## 查看 selinux 状态
sestatus

## 关闭 selinux
sed -i "s/=enforcing/=disabled/g" /etc/selinux/config


yum install -y epel-release
yum update -y

## 安装常规软件
yum install git zip unzip wget curl vim telnet ntp -y


## 修改主机名
hostnamectl set-hostname k8-master-dev


## 关闭防火墙，否则节点可能加入不进来
systemctl disable firewalld
systemctl stop firewalld

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

# 创建k8配置
cat <<EOF > k8sconfig.yaml
apiVersion: kubeadm.k8s.io/v1alpha1
kind: MasterConfiguration
kubernetesVersion: "v1.10.5"
imageRepository: registry.cn-hangzhou.aliyuncs.com/k10
networking:
  podSubnet: 172.20.0.0/16
  serviceSubnet: 172.21.0.0/16
kubeProxy:
  config:
    mode: "ipvs"
    featureGates: 
      SupportIPVSProxyMode: true
    clusterCIDR: 172.21.0.0/16
apiServerCertSANs:
featureGates:
  CoreDNS: true
EOF



# 配置Kubelet,注意IP地址
# Environment="KUBELET_DNS_ARGS=--cluster-dns=172.21.0.10 --cluster-domain=cluster.local"
# 这个IP段是172.21 与 serviceSubnet 和  clusterCIDR 保持一致
sed -i "s/\/usr\/bin\/kubelet/\/usr\/bin\/kubelet --pod-infra-container-image=registry.cn-hangzhou.aliyuncs.com\/k10\/pause-amd64:3.1 --fail-swap-on=false/g" /etc/systemd/system/kubelet.service.d/10-kubeadm.conf

vim  /etc/systemd/system/kubelet.service.d/10-kubeadm.conf

# 重启Docker 和 kubelet
systemctl daemon-reload
systemctl enable docker
systemctl enable kubelet
systemctl restart docker
systemctl restart kubelet



## 初始化k8-master
## 该命令能够生成客户端config和 计算节点加入集群的  命令参数
kubeadm init --config=k8sconfig.yaml --ignore-preflight-errors="Swap"

## 依据初始化master 提示创建客户端config
mkdir -p $HOME/.kube
  sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
  sudo chown $(id -u):$(id -g) $HOME/.kube/config

## 尝试一下
## 如果等待一段时间后，k8-mater-dev  节点是 NotReady 的话，可以通过 journalctl -f -u kubelet 查看报错并修复，修复后 要重启kubelet

kubectl get nodes

# 删除节点  kubectl drain nodeName

## 根据初始化master，得到节点加入命令参数
## 如果忘记了token，使用命令重生并获取： kubeadm token create --print-join-command 
# kubeadm join 10.9.40.60:6443 --token 8s7ofe.c8p7sj3jv2u43w76 --discovery-token-ca-cert-hash sha256:8d96611839648a79877f62e8316dd78b6cc274b77ea1435f731b33964a5bc21e


## 配置集群网络  flannel.yaml : Network
# 这个配置内容比较长，只需要明确 Network 的IP段跟 k8sconfig.yaml 中的 podSubnet  保持一致即可
kubectl apply -f flannel.yaml

# 需要注意的是，节点ip和容器之间的IP不是同网段，所以


## 后续工作
## 1 安装管理
kubectl apply -f admin.yaml

##  2 安装计算节点节点 详情见  install_node.sh
## gotodo at node vm

##  3 安装consul 详情见 consul.sh

##  4 部署consul的agent，作为DaemonSet运行在所有节点之上
##  acl_agent_token ，retry_join（consul服务器IP地址）  两个关键参数必须正确
kubectl apply -f consul.yaml


## 5  部署k8-master 的web管理应用
kubectl apply -f dashboard.yaml

## 6  生成新的certs和master管理token
cd ~ && mkdir certs && cd certs
openssl genrsa -des3 -passout pass:x -out dashboard.pass.key 2048
openssl rsa -passin pass:x -in dashboard.pass.key -out dashboard.key
openssl req -new -key dashboard.key -out dashboard.csr
openssl x509 -req -sha256 -days 365 -in dashboard.csr -signkey dashboard.key -out dashboard.crt
kubectl delete secret kubernetes-dashboard-certs -n kube-system
kubectl create secret generic kubernetes-dashboard-certs --from-file=$HOME/certs -n kube-system
kubectl get pods -o wide -n kube-system
kubectl delete pod kubernetes-dashboard-d7f7b7776-lsk68 -n kube-system
kubectl get pods -o wide -n kube-system



kubectl create secret docker-registry regcred --docker-server=http://registry.dev.chelizitech.com --docker-username=saas --docker-password=Abcd1234 --docker-email=r@y.cn
# 如果不小心配错参数，可以删除后重来
# kubectl delete secret regcred


kubectl get secrets --all-namespaces
kubectl describe secrets kube-admin-token-49w75 -n kube-system

### 使用上面得到的token 登录  https://10.9.40.60:30001
















