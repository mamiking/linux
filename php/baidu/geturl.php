<?php
$site="www.aaa.cn";
$site="www.bbb.com";
$site="www.ccc.com";
$str="";
for($i=0;$i<74;$i++){
  $str.=get($i,$site);
}
$date=date("Ymd",time());
file_put_contents("data/$site-list-$date.txt",$str);

function get($page,$site){
 $count=$page*10;
 $url="http://www.baidu.com/s?wd=site%3A$site&pn=$count&oq=site%3A$site&ct=2097152&tn=baiduhome_pg&ie=utf-8&si=$site&rsv_idx=2&rsv_pq=e3ed8e54000357f2&rsv_t=e103kG0JYC8HTyKbXVmMSDmBylGXkhHuO%2BqKy2Ah1xEZ8Yuq4PPJnZvNQrwubqR7S7%2FG";

$strx="";

$cnt=file_get_contents($url);
preg_match_all ("/data-tools=\'(.*)\'>/U", $cnt, $arr);

foreach($arr[1] as $arrx){
 $js=json_decode($arrx);
  $curl= $js->url;
  $arrx=cget($curl);
  $strx.=$arrx[0]."\n";
};
echo "page:$page \n";
//echo $strx;
return $strx;
//file_put_contents("list/list$page.txt",$strx);
}



function cget($url) {
    $ch = curl_init();

    curl_setopt($ch, CURLOPT_HTTPGET, true);
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1); //TRUE ��curl_exec()��ȡ����Ϣ���ַ������أ�������ֱ�������

    $header = ['User-Agent: php test']; //����һ����������agent��header
    curl_setopt($ch, CURLOPT_HTTPHEADER, $header);

    curl_setopt($ch, CURLOPT_HEADER, 1); //����responseͷ����Ϣ
    curl_setopt($ch, CURLINFO_HEADER_OUT, true); //TRUE ʱ׷�پ���������ַ������� PHP 5.1.3 ��ʼ���á�����ܹؼ�������������鿴����header

    curl_setopt($ch, CURLOPT_URL, $url);
    $result = curl_exec($ch);

  //   echo curl_getinfo($ch, CURLINFO_HEADER_OUT); //�ٷ��ĵ������ǡ�����������ַ���������ʵ���������header���������ֱ�Ӳ鿴����header����Ϊ��������鿴

    curl_close($ch);


    preg_match_all ("/Location:(.*)\n/U", $result, $arr);
   return $arr[1];
   //print_r($arr[1]);
   $str=$arr[1][0];
   //print_r($str,true);
   return $str;

    return $result;
}