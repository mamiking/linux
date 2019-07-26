#!/bin/bash

## 制作 Docker 镜像  有两种方式
# 1. 通过 Dockerfile 来自动编译生成镜像
# 2.通过容器内操作，并进行 Commit 来实现打包生成镜像

## 描述第一种方法，生成基础linux+php+nginx 的镜像

mkdir lnmp5.6
cd lnmp5.6
vim Dockerfile
FROM centos:lateast

RUN rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
RUN rpm -Uvh https://mirror.webtatic.com/yum/el7/webtatic-release.rpm
RUN yum -y --nogpgcheck install nginx iproute net-tools awk zip unzip wget php56w php56w-cli php56w-common php56w-devel php56w-embedded php56w-fpm php56w-gd php56w-mbstring php56w-mysqlnd php56w-opcache php56w-pdo php56w-xml php56w-pecl-redis php56w-pecl-memcached


# 依据Dockerfile 制作镜像
docker build -t lnmp:5.6  .



## 描述第一种方法生成 应用镜像  exam

mkdir  exam
# exam目录下：localtime,conf/ app/ consul.sh startup.sh  Dockerfile


# 编辑Dockerfile

vim Dockerfile

FROM lnmp:5.6 

RUN mkdir /data

WORKDIR /data

COPY localtime /etc/

COPY conf/nginx/nginx.conf  /etc/nginx/nginx.conf

COPY conf/nginx/vhost.conf  /etc/nginx/conf.d/

COPY conf/php/php.ini  /etc/

COPY conf/php/www.conf /etc/php-fpm.d/www.conf

RUN  mkdir -p /data/logs
RUN  mkdir -p /data/web

COPY app /data/web/app

RUN chown nginx.nginx -R /data

COPY consul.sh  /data/
COPY startup.sh  /data/

RUN  chmod +x ./*.sh

CMD ["/data/startup.sh","serverName","context-path"]

# 生成镜像

docker build -t exam:1.0  .

# 运行 exam:1.0 容器
docker run -d exam:1.0

# 进入容器
docker ps
docker exec -it  towetyoe89 bash
netstat -tpnl

############### startup.sh #####################
#!/bin/bash

cd `dirname $0`

# 注册服务到 consul
nohup ./consul.sh $1 $2 $3 &

# 启动 php-fpm
php-fpm

#nginx 挂起
nginx -g "daemon off;"

############### startup.sh  end #####################









## 描述第二种方式 来创建 lnmp1.6 镜像

#  docker build lnmp images  用第二种方法

docker pull  centos:lateast

docker run -it centos /bin/bash

# 新开一个宿主机进程，对比宿主date时间和容器date是否一致，不一致则
docker ps
docker cp /etc/localtime 2d04d60f19cf:/etc/



# 更新源
rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
rpm -Uvh https://mirror.webtatic.com/yum/el7/webtatic-release.rpm


# 安装php5.6

## yum -y install php56w php56w-opcache php56w-fpm php56w-gd php56w-mysql php56w-gd php56w-snmp php56w-xml php56w-imap php56w-ldap php56w-mbstring
yum -y install php56w php56w-cli php56w-common php56w-devel php56w-embedded php56w-fpm php56w-gd php56w-mbstring php56w-mysqlnd php56w-opcache php56w-pdo php56w-xml php56w-pecl-redis php56w-pecl-memcached


# 或者安装php7.2
yum -y install php72w php72w-cli php72w-common php72w-devel php72w-embedded php72w-fpm php72w-gd php72w-mbstring php72w-mysqlnd php72w-opcache php72w-pdo php72w-xml php72w-pecl-redis php72w-pecl-memcached


## 安装nginx
yum install -y  nginx


## 新开一个宿主机进程，commit 生成一个新的lnmp镜像
docker ps
docker commit 2d04d60f19cf  lnmp1.6 


##  启动容器  docker run -d  imgTag CMD [ARG],必须有一个命令常驻挂起，容器才会一直运行，否则容器执行完毕直接退出
docker run -d  lnmp1.6  nginx -g "daemon off;"
## 进入容器
docker ps 
docker exec -it a55e29eb8c66 bash



