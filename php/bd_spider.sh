#!/bin/bash
# web站点被感染后，当百度蜘蛛采集数据的时候，就会采集到并不存在的内容，用户通过百度搜索能搜索到
# baidu目录下的php文件，通过执行 php  geturl.php / getcache.php 可以得到所有收录的url和快照
# 可以在  ziyuan.baidu.com/badlink/index 提交死联，或者在help.baidu.com 快照删除和更新， 
curl -H "User-Agent: Mozilla/5.0 (compatible; Baiduspider/2.0;+http://www.baidu.com/search/spider.html）" http://www.aaa.cn/hotcJnmt.htm