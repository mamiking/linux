#!/bin/bash

## 制作 Docker 镜像  有两种方式
# 1. 通过 Dockerfile 来自动编译生成镜像
# 2.通过容器内操作，并进行 Commit 来实现打包生成镜像
## 本文描述第二种方式 来创建 lnmp1.6 镜像


#  docker build lnmp images

docker pull  centos:lateast

docker run -it centos /bin/bash

# 新开一个宿主机进程，对比宿主date时间和容器date是否一致，不一致则
docker ps
docker cp /etc/localtime 2d04d60f19cf:/etc/

yum update -y & yum install  epel-lateast -y

yum install -y git zip unzip wget curl vim telnet

# 无人值守安装lnmp
wget http://soft.vpser.net/lnmp/lnmp1.6.tar.gz -cO lnmp1.6.tar.gz && tar zxf lnmp1.6.tar.gz && cd lnmp1.6 && LNMP_Auto="y" DBSelect="0" PHPSelect="5" SelectMalloc="1" CheckMirror="n" ./install.sh lnmp


chkconfig nginx on
chkconfig php-fpm on



# redis client
wget https://github.com/phpredis/phpredis/archive/2.2.8.tar.gz
tar -xzvf 2.2.8.tar.gz
cd phpredis-2.2.8
/usr/local/php/bin/phpize
./configure --with-php-config=/usr/local/php/bin/php-config
make && make install

##config:
vi /usr/local/php/etc/php.ini
## add->
extension_dir = "/usr/local/php/lib/php/extensions/no-debug-non-zts-20131226"
extension=redis.so


service php-fpn restart



# 在root目录下创建脚本 consul.sh,startup.sh
##==============consul.sh======================
#!/bin/bash
cd `dirname $0`
consul::getip() {
    host_ips=(`ip addr show|grep inet|grep -v 127.0.0.1|grep -v inet6|awk '{print $2}'|cut -f1 -d '/'`)
    if [ "${host_ips[0]}" == "" ]; then
        echo "[ERROR] get ip address error!"
        exit 1
    else
        echo "${host_ips[0]}"
    fi
}
consul::reg()
{
    local consul_addr=$SPRING_CLOUD_CONSUL_HOST 
    local consul_port=${SPRING_CLOUD_CONSUL_PORT:-"8500"}
    local consul_token=$SPRING_CLOUD_CONSUL_TOKEN
    local str_name=$1
    local str_path=$2
    local str_health=$2
    if [ "$3" != "" ] ;then
       str_health=$3
    fi
    local str_ip=$(consul::getip)
    local str_port=${CTL_SERVICE_PORT:-"80"}
    local srv_config=`cat <<EOF
    { 
        "id": "${str_name}-${str_ip//\./\-}",
        "name": "$str_name",
        "address": "$str_ip",
        "port": $str_port,
        "tags": ["contextPath=$str_path"],
        "checks": [
            {
                "DeregisterCriticalServiceAfter":"3m",
                "http": "http://$str_ip:$str_port$str_health",
                "interval": "15s",
                "timeout": "10s",
                "status": "passing"
            }
        ]
    }
EOF`
    echo "注册服务:consul $consul_addr:$consul_port,token $consul_token"
    echo "$srv_config" 
    curl -L --header "X-Consul-Token: $consul_token" http://$consul_addr:$consul_port/v1/agent/service/register -XPUT -d "${srv_config}"
}


sleep 3
consul::reg $1 $2 $3
##================consul.sh end========================

##=========startup.sh ======================
#!/bin/bash
cd `dirname $0`

nohup ./consul.sh $1 $2 $3 &

chown  www.www -R ./web

service nginx reload

##==================startup.sh end =======================


## 新开一个宿主机进程，commit 生成一个新的lnmp镜像
docker ps
docker commit 2d04d60f19cf  lnmp1.6
