#!/bin/bash

#该功能在a1111-sd-webui,comfyui,lora-script中共用的
#版本切换模块
function git_checkout_manager()
{
    echo "获取版本信息"
    commit_lists=$(git log --date=short --pretty=format:"%H %cd" --date=format:"%Y-%m-%d|%H:%M:%S" | awk -F  ' ' ' {print $1 " " $2} ')

    commit_selection=$(
        dialog --clear --title "Term-SD" --backtitle "项目切换版本选项" --ok-label "确认" --cancel-label "取消" \
        --menu "请选择要切换的版本\n当前版本:\n$(git show -s --format="%H %cd" --date=format:"%Y-%m-%d %H:%M:%S")" 23 70 12 \
        $commit_lists \
        3>&1 1>&2 2>&3)

    if [ $? = 0 ];then
        git checkout $commit_selection
    fi
    cd ..
}