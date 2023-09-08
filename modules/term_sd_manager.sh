#!/bin/bash

#主界面
function mainmenu()
{
    cd "$start_path" #回到最初路径
    exit_venv #确保进行下一步操作前已退出其他虚拟环境
    mainmenu_select=$(
        dialog --clear --title "Term-SD" --backtitle "主界面" --ok-label "确认" --cancel-label "取消" --menu "请选择Term-SD的功能\n当前目录可用空间:$(df ./ -h |awk 'NR==2'|awk -F ' ' ' {print $4} ')\n当前虚拟环境状态:"$venv_info"" 20 60 10 \
        "0" "venv虚拟环境" \
        "1" "AUTOMATIC1111-stable-diffusion-webui" \
        "2" "ComfyUI" \
        "3" "InvokeAI" \
        "4" "lora-scripts" \
        "5" "更新脚本" \
        "6" "pip镜像源" \
        "7" "pip缓存清理" \
        "8" "帮助" \
        "9" "退出" \
        3>&1 1>&2 2>&3 )

    if [ $? = 0  ];then #选择确认
        if [ "${mainmenu_select}" == '0' ]; then #选择venv虚拟环境
            venv_option
        elif [ "${mainmenu_select}" == '1' ]; then #选择AUTOMATIC1111-stable-diffusion-webui
            a1111_sd_webui_option
        elif [ "${mainmenu_select}" == '2' ]; then #选择ComfyUI
            comfyui_option
        elif [ "${mainmenu_select}" == '3' ]; then #选择InvokeAI
            invokeai_option
        elif [ "${mainmenu_select}" == '4' ]; then #选择lora-scripts
            lora_scripts_option
        elif [ "${mainmenu_select}" == '5' ]; then #选择更新脚本
            term_sd_update_option
        elif [ "${mainmenu_select}" == '6' ]; then #选择pip镜像源
            set_proxy_option
        elif [ "${mainmenu_select}" == '7' ]; then #选择pip缓存清理
            pip_cache_clean
        elif [ "${mainmenu_select}" == '8' ]; then #选择帮助
            help_option
        elif [ "${mainmenu_select}" == '9' ]; then #选择退出
            echo "退出Term-SD"
            exit 1
        fi
    else #选择取消
        echo "退出Term-SD"
        exit 1
    fi
}

#启动项目功能
function term_sd_launch()
{
    enter_venv
    if [ $(uname -o) = "Msys" ];then #为了兼容windows系统
        python $(cat ./term-sd-launch.conf)
    else
        python3 $(cat ./term-sd-launch.conf)
    fi
}

#项目更新失败修复功能
function term_sd_fix_pointer_offset()
{
    git checkout $(git branch -a | grep HEAD | awk -F'/' '{print $NF}') #查询当前主分支并重新切换过去
    git reset --hard HEAD #回退版本,解决git pull异常
}

#显示版本信息
function term_sd_version()
{
    dialog --clear --title "Term-SD" --backtitle "Term-SD开始界面"  --ok-label "确定" --msgbox "版本信息:\n\n
系统:$(uname -o) \n
Term-SD:"$term_sd_version_" \n
python:$($test_python --version | awk 'NR==1'| awk -F  ' ' ' {print  " " $2} ') \n
pip:$(pip --version | awk 'NR==1'| awk -F  ' ' ' {print  " " $2} ') \n
aria2:$(aria2c --version | awk 'NR==1'| awk -F  ' ' ' {print  " " $3} ') \n
git:$(git --version | awk 'NR==1'| awk -F  ' ' ' {print  " " $3} ') \n
dialog:$(dialog --version | awk 'NR==1'| awk -F  ' ' ' {print  " " $2} ') \n
\n
提示: \n
使用方向键、Tab键移动光标,Enter进行选择,Space键勾选或取消勾选,(已勾选显示[*]),Ctrl+C可中断指令的运行 \n
第一次使用Term-SD时先在主界面选择“帮助”查看使用说明,参数说明和注意的地方,内容不定期更新" 20 60
    mainmenu
}