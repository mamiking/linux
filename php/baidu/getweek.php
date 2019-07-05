<?php
//获取网站最近一周新增百度收录，主要是看首页
$sites=array();
$sites[]="www.a.cn";
$sites[]="www.b.com";
$sites[]="www.c.com";
$sites[]="www.d.cn";
$sites[]="www.e.cn";
$sites[]="www.f.cn";
$sites[]="www.g.cn";
$sites[]="www.h.com";
$sites[]="www.i.cn";
$sites[]="www.j.com";
$sites[]="www.k.com";
$sites[]="www.l.com";

foreach($sites as $site){
  echo "site:".$site." : ".get(0,$site)."\n";
}
function get($page,$site){
 $count=$page*10;
 $url="http://www.baidu.com/s?wd=site%3A$site&pn=$count&oq=site%3A$site&ct=2097152&tn=baiduhome_pg&ie=utf-8&si=$site&rsv_idx=2&rsv_pq=e3ed8e54000357f2&rsv_t=e103kG0JYC8HTyKbXVmMSDmBylGXkhHuO%2BqKy2Ah1xEZ8Yuq4PPJnZvNQrwubqR7S7%2FG&gpc=stf%3D1561716934%2C1562321734%7Cstftype%3D1&tfflag=1";

$strx="";
$cnt=file_get_contents($url);
preg_match_all ("/data-tools=\'(.*)\'>/U", $cnt, $arr);
 return count($arr[1]);
}
