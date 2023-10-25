#!/bin/bash

#comfyui插件选择
function comfyui_extension_option()
{
    #清空插件选择
    comfyui_extension_install_list=""

    comfyui_extension_list=$(
        dialog --clear --title "Term-SD" --backtitle "ComfyUI插件安装选项" --separate-output --notags --ok-label "确认" --no-cancel --checklist "请选择要安装的ComfyUI插件" 25 80 10 \
        "1" "ComfyUI-extensions" OFF \
        "2" "graphNavigator" OFF \
        3>&1 1>&2 2>&3)

    if [ $? = 0]; then
        for i in $comfyui_extension_list; do
            case $i in
                1)
                    comfyui_extension_install_list="https://github.com/diffus3/ComfyUI-extensions $comfyui_extension_install_list"
                    ;;
                2)
                    comfyui_extension_install_list="https://github.com/rock-land/graphNavigator $comfyui_extension_install_list"
                    ;;
            esac
        done
    fi
}