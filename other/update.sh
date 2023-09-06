#!/bin/bash
# 更新日期 2023/1/28
# Blog：https://www.ymhworld.cn
# B站：青空朝颜モー （https://space.bilibili.com/111516863）

function updatesd(){
#更新webui
printf "正在更新webui（显示“Already up to date.”为已更新到最新,无需更新）\n"
git pull || exit 1
printf "\n*-------------------------------------------------------*\n"

#更新插件
ls -l $PWD/extensions/ |grep -v ^- | awk '{print $9}' | grep -v '^$' > extlist.txt

pwdis=$PWD
while read rows
do
  printf "正在更新$rows插件\n位置在：$PWD/extensions/$rows \n"
  cd $PWD/extensions/$rows || printf "插件目录错误，已退出"
  git pull || exit 1
  cd $pwdis
  printf "\n*-------------------------------------------------------*\n"
done < extlist.txt

rm -f extlist.txt
printf "更新完成，退出代码为 $?\n"
}

clear
printf "*-------------------------------------------------------*\n"
printf "Linux sd-webui一键更新本体及插件脚本\nB站：青空朝颜モー （https://space.bilibili.com/111516863）\nBlog：www.ymhworld.cn\n"
printf "*-------------------------------------------------------*\n\n"
printf  "[1]==>使用git pull更新webui本体及全部插件（可能需要代理）\n\n[Ctrl+C] 退出\n\n"

IFCMD=0
while [ $IFCMD -ne 1 ]
do
	read -p "你要做什么？【输入对应数字】>>>" IFCMD
done
if [ $IFCMD -eq 1 ]; then
	updatesd
fi
