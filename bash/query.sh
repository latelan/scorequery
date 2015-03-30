#!bin/bash

user_id="$1"
user_pass="$2"
xuenian="2014-2015"
xueqi="1"
host="http://222.24.19.202"

#get cookie
url="$host/default_ysdx.aspx"
curl -s -c cookie.txt $url > /dev/null

##login
post_data="__VIEWSTATE=dDw1MjQ2ODMxNzY7Oz799QJ05KLrvCwm73IGbcfJPI91Aw==&TextBox1=$user_id&TextBox2=$user_pass&RadioButtonList1=%D1%A7%EF%BF%BD%EF%BF%BD&Button1=++%EF%BF%BD%EF%BF%BD%C2%BC++"
url="$host/default_ysdx.aspx"
curl -s -b cookie.txt -d $post_data $url > /dev/null

##get name
url="$host/xs_main.aspx?xh=$user_id"
get_data=`curl -s -b cookie.txt $url`
encode_user_name=`echo $get_data | awk -F '<span id=\"xhxm\">' '{print $2}' | awk -F '<\/span>' '{print $1}' | tr -d '\n' | xxd -plain | sed 's/\(..\)/%\1/g' | sed 's/%cd%ac%d1%a7//g'`

##get cjcx
url="$host/xscjcx.aspx?xh=$user_id&xm=$encode_user_name&gnmkdm=N121605"
content_data=`curl -s -b cookie.txt $url`
viewstate=`echo $content_data | grep "__VIEWSTATE\" value=" | awk -F 'value' '{print $5}' | awk -F '\"' '{print $2}'`

##convert '+' to '%2B' and '/' to '%2F'
viewstate_noplus=`echo $viewstate | sed 's/+/%2B/g' | sed 's/\//%2F/g'`

#query score
post_data="__EVENTTARGET=&__EVENTARGUMENT=&__VIEWSTATE=$viewstate_noplus&hidLanguage=&ddlXN=$xuenian&ddlXQ=$xueqi&ddl_kcxz=&btn_xq=%D1%A7%C6%DA%B3%C9%BC%A8"
url="$host/xscjcx.aspx?xh=$user_id&xm=$encode_user_name&gnmkdm=N121605"
content=`curl -s -b cookie.txt -d $post_data $url`

##search string
data_all=`echo $content | awk -F '\/>' '{print $3}' | awk -F '\"' '{print $2}'`
data_all=`echo $content | awk -F '\/>' '{print $3}' | awk -F '\"' '{print $6}'`
data=`php base64.php $data_all`

##get score
data_score=`echo $data | awk -F 'b<' '{print $2}' | awk -F '>' '{print $1}'`


data_score_decode=`php base64.php $data_score`
score_list=`echo $data_score_decode | sed 's/\r//g' | sed 's/ //g'`
score_list=`echo $score_list | awk -F '<NewDataSet>' '{print $2}'`

php get_score.php $score_list
