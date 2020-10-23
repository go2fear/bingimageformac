#!/bin/sh
#检查是否连接网络
net_status=`curl -I -s --connect-timeout 5 www.baidu.com -w %{http_code} |tail -n1`

if [ $net_status -eq 200 ];then
  #有网络，继续。
  sleep 1
else
  #没有网络，退出。
  sleep 1
  exit 1
fi

#确定文件名为当前日期，设置本地文件夹
today=$(date +%F)
localpath="/Users/$USER/Pictures"
pic="$localpath/bing-$today.jpg"

#判断今天是否已经下载了
if [ -s "$pic" ];then
  echo "今日份壁纸已设置，退出。"
  exit
fi

#提取壁纸图片URL
url=$(expr "$(curl  -L -e  '; auto' https://www.bing.com/?mkt=zh-CN | grep g_img=)" : ".*g_img={url:\"\(.*\)\"};.*")

#去除url中的斜杠“\”
url="http://www.bing.com${url//\\/}"

#替换&符号
url=${url/\u0026/&}

#下载图片至本地
curl -o $pic  $url

#调用Finder应用切换桌面壁纸
osascript -e "tell application \"Finder\" to set desktop picture to POSIX file \"$pic\""

#删除之前下载的文件
find $localpath/bing* -type f -mtime +1 -exec rm {} \;
