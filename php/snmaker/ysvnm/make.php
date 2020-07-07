<?php
require_once("inc.php");


//=======================tctxcom==========================
$info=array(
	"key"=>"BA1B-5CAE-566B-B2B9",
	"type"=>"trialcopy",//trialcopy,legalcopy
	"deadline"=>"2018-02-17",
	"userid"=>"tctxcom",
	"username"=>"深圳市xxx有限公司",
	"softname"=>"xyz管理平台",
	"ver"=>"1.1.6",
	"softdesc"=>"基于WEB的xyz综合管理工具",
	"copy"=>"深圳市及锋科技有限公司",
);

if(!isset($argv[1])){
	echo "Usage:php make.php userid \r\n";
	fwrite(STDOUT, "Please enter the UserId(ID): "); 
	$id = trim(fgets(STDIN)); 
}else{
	$id=$argv[1];//$_GET["id"];
}

$file="src/".$id.".txt";
if(file_exists($file)){
	$infoSrc=file($file);
	foreach($infoSrc as $in){
		$in=trim($in);
		if($in){			
			$inArr=explode(":",$in);
			//print_r($inArr);
			$info[$inArr[0]]=$inArr[1];
			//print_r($info);
		}
	}
}else{
	echo "User info is not exists,please confirm the file src/$id.txt is exists?\r\n";
}


foreach($info as &$inx){
        $encode = mb_detect_encoding ( $inx, array ("ASCII", "UTF-8", "GB2312", "GBK", "BIG5", "EUC-CN" ) );		
		//  解决window执行命令 中文乱码的问题
		if ($encode == "EUC-CN"){
			$inx = iconv ('EUC-CN', 'UTF-8',  $inx );
		}
}





makelicense($info);
$licfile="out/".$info["userid"]."/".$info["type"]."/license.lic";
echo "parse license from file ".$licfile."\r\n";
print_r(parselicense($licfile,$info["key"]));