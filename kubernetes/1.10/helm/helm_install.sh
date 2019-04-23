#!/bin/bash

## install helm   �ͻ���

#�ӹ����������°汾�Ķ����ư�װ�������أ�https://github.com/kubernetes/helm/releases
wget https://storage.googleapis.com/kubernetes-helm/helm-v2.13.1-linux-amd64.tar.gz

tar -zxvf helm-v2.13.1-linux-amd64.tar.gz
cp linux-amd64/helm /usr/local/bin/helm
helm help
helm version  # v2.13.1


###  ================= ��װTiller ������helm�ķ���ˣ�===============

## k8 master �ͼ���׶ζ�Ҫ��װ socat
yum install -y socat

# ��������Դ
helm init --client-only --stable-repo-url https://aliacs-app-catalog.oss-cn-hangzhou.aliyuncs.com/charts/
helm repo add incubator https://aliacs-app-catalog.oss-cn-hangzhou.aliyuncs.com/charts-incubator/
helm repo update

# ��������ˣ�ע��汾����� helm һ�� v2.13.1
helm init --service-account tiller --upgrade -i registry.cn-hangzhou.aliyuncs.com/google_containers/tiller:v2.13.1  --stable-repo-url https://kubernetes.oss-cn-hangzhou.aliyuncs.com/charts


# ����TLS��֤����ˣ��ο���ַ��https://github.com/gjmzj/kubeasz/blob/master/docs/guide/helm.md
helm init --service-account tiller --upgrade -i registry.cn-hangzhou.aliyuncs.com/google_containers/tiller:v2.13.1 --tiller-tls-cert /etc/kubernetes/ssl/tiller001.pem --tiller-tls-key /etc/kubernetes/ssl/tiller001-key.pem --tls-ca-cert /etc/kubernetes/ssl/ca.pem --tiller-namespace kube-system --stable-repo-url https://kubernetes.oss-cn-hangzhou.aliyuncs.com/charts


############======Titller ��Ȩ #######################
## ���������˺ţ��󶨽�ɫ
kubectl create serviceaccount --namespace kube-system tiller
kubectl create clusterrolebinding tiller-cluster-rule --clusterrole=cluster-admin --serviceaccount=kube-system:tiller



# ʹ�� kubectl patch ���� API ����
kubectl patch deploy --namespace kube-system tiller-deploy -p '{"spec":{"template":{"spec":{"serviceAccount":"tiller"}}}}'

# �鿴��Ȩ�Ƿ�ɹ�
kubectl get deploy --namespace kube-system   tiller-deploy  --output yaml|grep  serviceAccount

## ��֤ Tiller �Ƿ�װ�ɹ�

kubectl -n kube-system get pods|grep tiller 

#########################Iiller ��ж��
helm reset
# or
helm reset --force




