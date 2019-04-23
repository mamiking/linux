#!/bin/bash

## install helm   客户端

#从官网下载最新版本的二进制安装包到本地：https://github.com/kubernetes/helm/releases
wget https://storage.googleapis.com/kubernetes-helm/helm-v2.13.1-linux-amd64.tar.gz

tar -zxvf helm-v2.13.1-linux-amd64.tar.gz
cp linux-amd64/helm /usr/local/bin/helm
helm help
helm version  # v2.13.1


###  ================= 安装Tiller （这是helm的服务端）===============

## k8 master 和计算阶段都要安装 socat
yum install -y socat

# 更换镜像源
helm init --client-only --stable-repo-url https://aliacs-app-catalog.oss-cn-hangzhou.aliyuncs.com/charts/
helm repo add incubator https://aliacs-app-catalog.oss-cn-hangzhou.aliyuncs.com/charts-incubator/
helm repo update

# 创建服务端，注意版本必须跟 helm 一致 v2.13.1
helm init --service-account tiller --upgrade -i registry.cn-hangzhou.aliyuncs.com/google_containers/tiller:v2.13.1  --stable-repo-url https://kubernetes.oss-cn-hangzhou.aliyuncs.com/charts


# 创建TLS认证服务端，参考地址：https://github.com/gjmzj/kubeasz/blob/master/docs/guide/helm.md
helm init --service-account tiller --upgrade -i registry.cn-hangzhou.aliyuncs.com/google_containers/tiller:v2.13.1 --tiller-tls-cert /etc/kubernetes/ssl/tiller001.pem --tiller-tls-key /etc/kubernetes/ssl/tiller001-key.pem --tls-ca-cert /etc/kubernetes/ssl/ca.pem --tiller-namespace kube-system --stable-repo-url https://kubernetes.oss-cn-hangzhou.aliyuncs.com/charts


############======Titller 授权 #######################
## 创建服务账号，绑定角色
kubectl create serviceaccount --namespace kube-system tiller
kubectl create clusterrolebinding tiller-cluster-rule --clusterrole=cluster-admin --serviceaccount=kube-system:tiller



# 使用 kubectl patch 更新 API 对象
kubectl patch deploy --namespace kube-system tiller-deploy -p '{"spec":{"template":{"spec":{"serviceAccount":"tiller"}}}}'

# 查看授权是否成功
kubectl get deploy --namespace kube-system   tiller-deploy  --output yaml|grep  serviceAccount

## 验证 Tiller 是否安装成功

kubectl -n kube-system get pods|grep tiller 

#########################Iiller 的卸载
helm reset
# or
helm reset --force




