#!/bin/bash

##  #################################更换仓库

helm repo list

# 移除原先的 stable
helm repo remove stable

# 添加新的仓库地址
helm repo add stable https://kubernetes.oss-cn-hangzhou.aliyuncs.com/charts

# 更新仓库
helm repo update

############查看在存储库中可用的所有 Helm charts

helm search

########### 安装charts：
## Monocular是一个开源软件，用于管理kubernetes上以Helm Charts形式创建的服务，可以通过它的web页面来安装helm Charts
## 安装Nginx Ingress controller，如果安装的k8s集群启用了RBAC，则一定要加rbac.create=true参数
## helm install stable/nginx-ingress --set controller.hostNetwork=true ,rbac.create=true
helm install stable/nginx-ingress --set controller.hostNetwork=true

## 查看nginx服务状态
kubectl --namespace default get services -o wide -w youngling-arachnid-nginx-ingress-controller

# 添加新的源
helm repo add monocular https://helm.github.io/monocular
helm install monocular/monocular -f custom_repos.yaml

# 查看已经安装的charts
helm list

## 删除 charts
helm delete chartname




