#!/bin/bash

# sd-web启动分支判断
sd_webui_launch()
{
    local sd_webui_branch

    if [ ! -f "./term-sd-launch.conf" ]; then # 找不到启动配置时默认生成一个
        term_sd_echo "未找到启动配置文件,创建中"
        echo "launch.py --theme dark --autolaunch --xformers --skip-load-model-at-start" > term-sd-launch.conf
    fi

    term_sd_echo "检测stable-diffusion-webui分支中"
    sd_webui_branch=$(git remote -v 2> /dev/null | awk 'NR==1 {print $2}')
    if [ ! -z "$(echo $sd_webui_branch | grep stable-diffusion-webui)" ];then
        a1111_sd_webui_launch
    elif [ ! -z "$(echo $sd_webui_branch | grep automatic)" ];then
        vlad_sd_webui_launch
    elif [ ! -z "$(echo $sd_webui_branch | grep stable-diffusion-webui-directml)" ];then
        sd_webui_directml_launch
    else
        a1111_sd_webui_launch
    fi
}

