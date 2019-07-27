#!/bin/bash

cd `dirname $0`

nohup ./consul.sh $1 $2 $3 &


php-fpm

#nginx
nginx -g "daemon off;"


