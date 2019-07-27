FROM registry.dev.xxx.com/public/centos7:php5.6

MAINTAINER chetailian

RUN mkdir /data

WORKDIR /data

COPY localtime /etc/

COPY conf/nginx/nginx.conf  /etc/nginx/nginx.conf

COPY conf/nginx/vhost.conf  /etc/nginx/conf.d/

COPY conf/php/php.ini  /etc/

COPY conf/php/www.conf /etc/php-fpm.d/www.conf

RUN  mkdir -p /data/logs
RUN  mkdir -p /data/web
RUN  mkdir -p /data/web/runtime/session
RUN  mkdir -p /data/web/runtime/wsdlcache

COPY app /data/web/app

RUN chown nginx.nginx -R /data

COPY consul.sh  /data/
COPY startup.sh  /data/

RUN  chmod +x ./*.sh

CMD ["./startup.sh","ctl-coach-exam","/exam/coach","/exam/coach/Mobile/CoachExam/health"]
