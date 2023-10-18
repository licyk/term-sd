#!/bin/bash

#该功能在a1111-sd-webui,comfyui,lora-script中共用的
#版本切换模块
function git_checkout_manager()
{
    term_sd_notice "获取版本信息"

    commit_selection=$(
        dialog --clear --title "Term-SD" --backtitle "项目切换版本选项" --ok-label "确认" --cancel-label "取消" \
        --menu "请选择要切换的版本\n当前版本:\n$(git show -s --format="%H %cd" --date=format:"%Y-%m-%d %H:%M:%S")" 25 70 10 \
        $(git log --date=short --pretty=format:"%H %cd" --date=format:"%Y-%m-%d|%H:%M:%S" | awk -F  ' ' ' {print $1 " " $2} ') \
        3>&1 1>&2 2>&3)

    if [ $? = 0 ];then
        term_sd_notice "切换$(git remote -v | awk 'NR==1 {print $2}' | awk -F "/" '{print $NF}' | awk '{sub(".git","")}1')版本中"
        git checkout $commit_selection
    fi
}