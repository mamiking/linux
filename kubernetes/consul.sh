#  3 安装consul 详情见 consul.sh
mkdir setup
cd setup
wget https://releases.hashicorp.com/consul/1.2.4/consul_1.2.4_linux_amd64.zip
unzip consul_1.2.4_linux_amd64.zip
mv consul /usr/local/bin/




## 修改consul配置,生成两个uuid，一个作为master，一个作为agent,advertise_addr为consul服务IP，不一定在k8master服务器上
uuidgen  #acl_master_token
uuidgen   #acl_agent_token
vim /etc/consul/config.json

{
  "datacenter": "uat",
  "acl_datacenter": "uat",
  "acl_master_token": "5bc181ad-e172-433b-b027-4b8aeab9e527",
  "acl_agent_token": "84e4cb16-8816-488e-af9d-38476ee9e3bf",
  "acl_default_policy": "deny",
  "data_dir": "/data/consul",
  "log_level": "WARN",
  "node_name": "n3",
  "server": true,
  "domain": "uat.local",
  "advertise_addr": "10.9.40.60",
  "addresses": {
    "https": "0.0.0.0"
  },
  "bootstrap_expect": 1,
  "client_addr":"0.0.0.0",
  "ui":true
}



cat <<EOF >  /etc/systemd/system/consul.service
[Unit]
Description="HashiCorp Consul - A service mesh solution"
Documentation=https://www.consul.io/
Requires=network-online.target
After=network-online.target
#ConditionFileNotEmpty=/etc/consul.d/consul.hcl

[Service]
User=root
Group=root
ExecStart=/usr/local/bin/consul agent -config-dir=/etc/consul
ExecReload=/usr/local/bin/consul reload
KillMode=process
Restart=on-failure
LimitNOFILE=65536

[Install]
WantedBy=multi-user.target

EOF


systemctl daemon-reload
systemctl enable consul
systemctl start consul



####  consul 的备份
