#!/bin/bash

function disk_space_stat()
{
    echo "统计空间占用中"
    disk_space_stat_=$(du -sh ./stable-diffusion-webui ./ComfyUI ./InvokeAI ./lora-scripts 2> /dev/null)
    disk_space_stat_1=$(echo $disk_space_stat_ | grep stable-diffusion-webui | awk -F ' ' ' {print $1} ')
    disk_space_stat_2=$(echo $disk_space_stat_ | grep ComfyUI | awk -F ' ' ' {print $1} ')
    disk_space_stat_3=$(echo $disk_space_stat_ | grep InvokeAI | awk -F ' ' ' {print $1} ')
    disk_space_stat_4=$(echo $disk_space_stat_ | grep lora-scripts | awk -F ' ' ' {print $1} ')
    dialog --clear --title "Term-SD" --backtitle "Term-SD空间占用分析"  --ok-label "确定" --msgbox "当前目录剩余空间:$(df ./ -h |awk 'NR==2'|awk -F ' ' ' {print $4} ')\n
项目空间占用:\n
stable-diffusion-webui:$([ ! -z $disk_space_stat_1 ] && echo $disk_space_stat_1 || echo "未安装")\n
ComfyUI:$([ ! -z $disk_space_stat_2 ] && echo $disk_space_stat_2 || echo "未安装")\n
InvokeAI:$([ ! -z $disk_space_stat_3 ] && echo $disk_space_stat_3 || echo "未安装")\n
lora-scripts:$([ ! -z $disk_space_stat_4 ] && echo $disk_space_stat_4 || echo "未安装")\n
" 22 70
    mainmenu
}