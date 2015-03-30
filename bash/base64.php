<?php
/*
 * base64 decode
 */

$str = $argv[1];
$str_utf8 = base64_decode($str);
$str_gb2312 = mb_convert_encoding($str_utf8,"gb2312","utf-8");

echo $str_gb2312;
?>
