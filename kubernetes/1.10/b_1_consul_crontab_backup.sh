#!/bin/bash

#输入参数：文件名
filename=consul_backup_
#源文件目录
#备份文件目录
backupdir=/root/consul/backup

#删除备份文件函数（备份文件数量设有有上限，超过上限会删除更早之前的备份文件）
function deleteFiles() {
        #列出所有同名文件，按文件更新时间倒序排序
        files=`ls -t $backupdir | grep "$filename"`
        index=1
        #保留的最大备份文件数量
	maxFileCount=30
        for file in $files
        do
		#当前备份文件数量大于最大备份文件数量，则删除历史的备份文件
                if [ $index -gt $maxFileCount ]; then
                        echo "==========>backup files count > $maxFileCount, delete history file $backupdir/$file"
			rm -rf $backupdir/$file
                fi
                index=$[$index+1]
        done
        echo "==========>fileCount:$index"
}

#文件备份函数
function backup() {
    backupFile=$backupdir/$filename`date +%Y%m%d_%H%M%S`
    /usr/local/bin/consul kv export -token=2e302b35-63dd-27a7-73e6-2c40da2d734a > $backupFile
    deleteFiles
}

echo "==========> do backup"
backup
echo "==========> backup finish"


#####  恢复备份数据
## cat uat.consul.bak | consul kv import -token=2e302b35-63dd-27a7-73e6-2c40da2d734a -

