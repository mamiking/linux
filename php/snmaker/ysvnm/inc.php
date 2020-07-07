<?php
//strtomd5bystr
	function tomd5bystr($str){
		$codeStr="codebywhc";
		return strtoupper(md5($codeStr.md5($codeStr.md5($str).$codeStr).$codeStr));
	}
	
function encrypt($data, $key)
{
	
	$key    =   tomd5bystr($key);
	//$key	=	md5($key);
    $x		=	0;
    $len	=	strlen($data);
    $l		=	strlen($key);
	$char="";
	 $str="";
    for ($i = 0; $i < $len; $i++)
    {
        if ($x == $l) 
        {
        	$x = 0;
        }
        $char .= $key{$x};
        $x++;
    }
    for ($i = 0; $i < $len; $i++)
    {
        $str .= chr(ord($data{$i}) + (ord($char{$i})) % 256);
    }
    return base64_encode($str);
}
function decrypt($data, $key)
{
	$key = tomd5bystr($key);
    $x = 0;
    $data = base64_decode($data);
    $len = strlen($data);
    $l = strlen($key);
	$char="";
	$str="";
    for ($i = 0; $i < $len; $i++)
    {
        if ($x == $l) 
        {
        	$x = 0;
        }
        $char .= substr($key, $x, 1);
        $x++;
    }
    for ($i = 0; $i < $len; $i++)
    {
        if (ord(substr($data, $i, 1)) < ord(substr($char, $i, 1)))
        {
            $str .= chr((ord(substr($data, $i, 1)) + 256) - ord(substr($char, $i, 1)));
        }
        else
        {
            $str .= chr(ord(substr($data, $i, 1)) - ord(substr($char, $i, 1)));
        }
    }
    return $str;
}

/*
 * $type:trialcopy  or   legalcopy
 * $info    data params
 * deadline:  trialcopy -> 30 days     legalcopy->2099-11-11
 */
function makelicense($info){	
	/*$data="type:$type;";
	$data.="userid:".$info['userid'].";";
	$data.="username:".$info['username'].";";	
	$data.="softname:YSVNM;";
	$data.="ver:1.1.0;";
	$data.="softdesc:基于WEB的SVN综合管理工具;";
	$data.="copy:深圳市耀泰明德科技有限公司;";	
	*/
	
	$data="";
	foreach ($info as $k=>$v){
		$data.="$k:$v;";
	}
	$data.="startdate:".date("Y-m-d").";";
	
	$type=$info["type"];
	$deadline=$info["deadline"];//$type=="trialcopy"?date("Y-m-d",strtotime("+65 days")):"2099-11-11";
	$data.="deadline:".$deadline;
	
	$dir="out/".$info['userid']."/".$type;
	@mkdir($dir,0755,true);
	
	$key=$info['key'];
	$filekey=$dir."/license.key";
	file_put_contents($filekey, $key);
	$filelic=$dir."/license.lic";
	file_put_contents($filelic, encrypt($data, $key));	

		$encode = mb_detect_encoding ( $data, array ("ASCII", "UTF-8", "GB2312", "GBK", "BIG5", "EUC-CN" ) );		
		//  解决window执行命令 中文乱码的问题
		if ($encode == "UTF-8"){
			//$data = iconv ( 'UTF-8','EUC-CN',  $data );
		}
		$filesrc=$dir."/license.src";
		file_put_contents($filesrc, $data);
}

function parselicense($licfile,$key){
	$data=trim(file_get_contents($licfile));
	$re=decrypt($data,$key);
	$reArr=explode(";", $re);
	$licArr=array();
	foreach ($reArr as $arr){
		$lic=explode(":", $arr);
		$licArr[$lic[0]]=$lic[1];
	}
	return $licArr;
}
