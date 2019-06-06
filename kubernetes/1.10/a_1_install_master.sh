#!/bin/bash

## bash for  centos 7
## create by whc  at 20190412
## ��װk8-master

## �鿴 selinux ״̬
sestatus

## �ر� selinux
sed -i "s/=enforcing/=disabled/g" /etc/selinux/config


yum install -y epel-release
yum update -y

## ��װ�������
yum install git zip unzip wget curl vim telnet ntp -y


## �޸�������
hostnamectl set-hostname k8-master-dev


## �رշ���ǽ������ڵ���ܼ��벻����
systemctl disable firewalld
systemctl stop firewalld

## reboot ʹ�û�����Ч
reboot


## ��װDocker
# ���֮ǰ�Ѿ���װ����ͬ�汾��docker����remove,����Ҫ����ɾ������ܶ�����
yum remove  docker*
rm -rf /var/lib/docker    

yum install -y --nogpgcheck \
    http://mirrors.aliyun.com/docker-engine/yum/repo/main/centos/7/Packages/docker-engine-selinux-1.13.1-1.el7.centos.noarch.rpm \
    http://mirrors.aliyun.com/docker-engine/yum/repo/main/centos/7/Packages/docker-engine-1.13.1-1.el7.centos.x86_64.rpm

## ��װKubelet
yum install -y --nogpgcheck \
    http://mirrors.aliyun.com/kubernetes/yum/pool/1eed768852fa3e497e1b7bdf4e93afbe3b4b0fdcb59fda801d817736578b9838-kubectl-1.10.5-0.x86_64.rpm \
    http://mirrors.aliyun.com/kubernetes/yum/pool/94d062f2d86b8f4f55f4d23a3610af25931da9168b7f651967c269273955a5a2-kubelet-1.10.5-0.x86_64.rpm \
    http://mirrors.aliyun.com/kubernetes/yum/pool/fe33057ffe95bfae65e2f269e1b05e99308853176e24a4d027bc082b471a07c0-kubernetes-cni-0.6.0-0.x86_64.rpm \
    http://mirrors.aliyun.com/kubernetes/yum/pool/3ea9c50d098c50a7e968c35915d3d8af7f54c58c0cedb0f9603674720743de4e-kubeadm-1.10.5-0.x86_64.rpm

	
# ����Docker
sed -i "s/\/usr\/bin\/dockerd/\/usr\/bin\/dockerd --exec-opt native.cgroupdriver=systemd/g" /lib/systemd/system/docker.service




#���� Docker ����
cat <<EOF > /etc/docker/daemon.json
{   
  "api-enable-cors": true, 
  "api-cors-header": "*", 
  "hosts": ["unix:///var/run/docker.sock", "tcp://0.0.0.0:2375"],
  "registry-mirrors": ["https://4ssmxahm.mirror.aliyuncs.com"],
  "insecure-registries": ["registry.dev.chelizitech.com"]
}
EOF

# ����k8����
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



# ����Kubelet,ע��IP��ַ
# Environment="KUBELET_DNS_ARGS=--cluster-dns=172.21.0.10 --cluster-domain=cluster.local"
# ���IP����172.21 �� serviceSubnet ��  clusterCIDR ����һ��
sed -i "s/\/usr\/bin\/kubelet/\/usr\/bin\/kubelet --pod-infra-container-image=registry.cn-hangzhou.aliyuncs.com\/k10\/pause-amd64:3.1 --fail-swap-on=false/g" /etc/systemd/system/kubelet.service.d/10-kubeadm.conf

vim  /etc/systemd/system/kubelet.service.d/10-kubeadm.conf

# ����Docker �� kubelet
systemctl daemon-reload
systemctl enable docker
systemctl enable kubelet
systemctl restart docker
systemctl restart kubelet



## ��ʼ��k8-master
## �������ܹ����ɿͻ���config�� ����ڵ���뼯Ⱥ��  �������
kubeadm init --config=k8sconfig.yaml --ignore-preflight-errors="Swap"

## ���ݳ�ʼ��master ��ʾ�����ͻ���config
mkdir -p $HOME/.kube
  sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
  sudo chown $(id -u):$(id -g) $HOME/.kube/config

## ����һ��
## ����ȴ�һ��ʱ���k8-mater-dev  �ڵ��� NotReady �Ļ�������ͨ�� journalctl -f -u kubelet �鿴�����޸����޸��� Ҫ����kubelet

kubectl get nodes

# ɾ���ڵ�  kubectl drain nodeName

## ���ݳ�ʼ��master���õ��ڵ�����������
## ���������token��ʹ��������������ȡ�� kubeadm token create --print-join-command 
# kubeadm join 10.9.40.60:6443 --token 8s7ofe.c8p7sj3jv2u43w76 --discovery-token-ca-cert-hash sha256:8d96611839648a79877f62e8316dd78b6cc274b77ea1435f731b33964a5bc21e


## ���ü�Ⱥ����  flannel.yaml : Network
# ����������ݱȽϳ���ֻ��Ҫ��ȷ Network ��IP�θ� k8sconfig.yaml �е� podSubnet  ����һ�¼���
kubectl apply -f flannel.yaml

# ��Ҫע����ǣ��ڵ�ip������֮���IP����ͬ���Σ�����


## ��������
## 1 ��װ����
kubectl apply -f admin.yaml

##  2 ��װ����ڵ�ڵ� �����  install_node.sh
## gotodo at node vm

##  3 ��װconsul ����� consul.sh

##  4 ����consul��agent����ΪDaemonSet���������нڵ�֮��
##  acl_agent_token ��retry_join��consul������IP��ַ��  �����ؼ�����������ȷ
kubectl apply -f consul.yaml


## 5  ����k8-master ��web����Ӧ��
kubectl apply -f dashboard.yaml

## 6  �����µ�certs��master����token
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
# �����С��������������ɾ��������
# kubectl delete secret regcred


kubectl get secrets --all-namespaces
kubectl describe secrets kube-admin-token-49w75 -n kube-system

### ʹ������õ���token ��¼  https://10.9.40.60:30001
















