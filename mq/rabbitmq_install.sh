wget http://www.rabbitmq.com/releases/rabbitmq-server/v3.6.6/rabbitmq-server-3.6.6-1.el7.noarch.rpm
yum install -y rabbitmq-server-3.6.6-1.el7.noarch.rpm
systemctl enable rabbitmq-server
systemctl start rabbitmq-server

netstat -tpnl
cd /etc/rabbitmq/

## user
rabbitmqctl add_user mqadmin js2019
rabbitmqctl set_user_tags mqadmin administrator

# vim rabbitmq.config
echo [{rabbit, [{loopback_users, []}]}]. >rabbitmq.config

## permission and plugins
rabbitmqctl list_users
rabbitmqctl list_user_permissions guest
rabbitmqctl list_user_permissions mqadmin
rabbitmqctl set_permissions -p / mqadmin ".*" ".*" ".*"
rabbitmqctl list_user_permissions mqadmin
rabbitmq-plugins enable rabbitmq_management



systemctl restart rabbitmq-server


