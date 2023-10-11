#!/bin/bash

function disk_space_stat()
{
    term_sd_notice "统计空间占用中"
    dialog --clear --title "Term-SD" --backtitle "Term-SD空间占用分析" --ok-label "确认" --msgbox "当前目录剩余空间:$(df ./ -h |awk 'NR==2'|awk -F ' ' ' {print $4} ')\n
项目空间占用:\n
stable-diffusion-webui:$([ -d "./stable-diffusion-webui" ] && du -sh ./stable-diffusion-webui | awk -F ' ' ' {print $1} ' || echo "未安装")\n
ComfyUI:$([ -d "./ComfyUI" ] && du -sh ./ComfyUI | awk -F ' ' ' {print $1} ' || echo "未安装")\n
InvokeAI:$([ -d "./InvokeAI" ] && du -sh ./InvokeAI | awk -F ' ' ' {print $1} ' || echo "未安装")\n
lora-scripts:$([ -d "./lora-scripts" ] && du -sh ./lora-scripts | awk -F ' ' ' {print $1} ' || echo "未安装")\n
Fooocus:$([ -d "./Fooocus" ] && du -sh ./Fooocus | awk -F ' ' ' {print $1} ' || echo "未安装")\n
" 25 70
    mainmenu
}
