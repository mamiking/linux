#!/bin/bash

##  #################################�����ֿ�

helm repo list

# �Ƴ�ԭ�ȵ� stable
helm repo remove stable

# ����µĲֿ��ַ
helm repo add stable https://kubernetes.oss-cn-hangzhou.aliyuncs.com/charts

# ���²ֿ�
helm repo update

############�鿴�ڴ洢���п��õ����� Helm charts

helm search

########### ��װcharts��
## Monocular��һ����Դ��������ڹ���kubernetes����Helm Charts��ʽ�����ķ��񣬿���ͨ������webҳ������װhelm Charts
## ��װNginx Ingress controller�������װ��k8s��Ⱥ������RBAC����һ��Ҫ��rbac.create=true����
## helm install stable/nginx-ingress --set controller.hostNetwork=true ,rbac.create=true
helm install stable/nginx-ingress --set controller.hostNetwork=true

## �鿴nginx����״̬
kubectl --namespace default get services -o wide -w youngling-arachnid-nginx-ingress-controller

# ����µ�Դ
helm repo add monocular https://helm.github.io/monocular
helm install monocular/monocular -f custom_repos.yaml

# �鿴�Ѿ���װ��charts
helm list

## ɾ�� charts
helm delete chartname




