#!/bin/bash

#sd-web启动分支选项
function sd_webui_launch()
{
    sd_webui_branch=$(git remote -v | awk 'NR==1' | awk '{print $2}')
    if [ ! -z "$(echo $sd_webui_branch | grep stable-diffusion-webui)" ];then
        a1111_sd_webui_launch
    elif [ ! -z "$(echo $sd_webui_branch | grep automatic)" ];then
        vlad_sd_webui_launch
    elif [ ! -z "$(echo $sd_webui_branch | grep stable-diffusion-webui-directml)" ];then
        sd_webui_directml_launch
    fi
}
