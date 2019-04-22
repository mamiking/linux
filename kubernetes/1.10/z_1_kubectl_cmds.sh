#!/bin/bash
## kubectl 常用命令集合

####################get######################

## 获得所有namespace
kubectl get ns

## 在指定的namespace下获取资源：
kubectl  -n {}

## 获取所有节点
kubectl get nodes

## 获取所有容器
kubectl get pods

## 查看某个容器的详细信息
# 容器列表
kubectl get deployments






# 容器信息
kubectl describe deployments ctl-exam
kubectl describe  pods ctl-exam-769785594-7p7sm


## 获取所有容器的镜像（排重）
kubectl describe pods $(kubectl get pods|grep -v consul|grep -v NAME|awk '{print $1}')|grep Image:|awk '{print $2}' | uniq

## 获取所有服务及其版本
kubectl describe pods $(kubectl get pods|grep -v consul|grep -v NAME|awk '{print $1}')|grep Image:|awk '{print $2}'|cut -d \/ -f 3 | uniq

################# 容器操作
## 进入容器
kubectl exec -it PODNAME  bash
## eg
kubectl exec -it ctl-battle-5896857d65-p6crk bash


## 将容器内文件拷贝到本地
kubectl cp PODNAME:PATH  LOCALPATH
## eg
kubectl cp ctl-battle-5896857d65-p6crk:/program/app.jar ./app.jar





## 查看容器服务日志
kubectl logs -f  ctl-exam-769785594-7p7sm
kubectl logs -f --tail=100  ctl-exam-769785594-7p7sm
