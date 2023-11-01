#!/bin/bash

#term-sd帮助功能

#帮助选择
function help_option()
{
    help_option_dialog=$(dialog --erase-on-exit --title "Term-SD" --backtitle "Term-SD帮助选项" --ok-label "确认" --cancel-label "取消" --menu "请选择帮助" 25 80 10 \
        "1" "关于Term-SD" \
        "2" "Term-SD使用方法" \
        "3" "Term-SD注意事项" \
        "4" "Term-SD功能说明" \
        "5" "目录说明" \
        "6" "Term-SD扩展脚本说明" \
        "7" "sd-webui插件说明" \
        "8" "ComfyUI插件/自定义节点说明" \
        "9" "返回" \
        3>&1 1>&2 2>&3 )

    if [ $? = 0 ];then
        case $help_option_dialog in
            1)
                dialog --erase-on-exit --title "Term-SD" --backtitle "Term-SD帮助选项" --ok-label "确认" --msgbox "$(cat ./term-sd/help/about.md)" 25 80
                help_option
                ;;
            2)
                dialog --erase-on-exit --title "Term-SD" --backtitle "Term-SD帮助选项" --ok-label "确认" --msgbox "$(cat ./term-sd/help/how_to_use_term_sd.md)" 25 80
                help_option
                ;;
            3)
                dialog --erase-on-exit --title "Term-SD" --backtitle "Term-SD帮助选项" --ok-label "确认" --msgbox "$(cat ./term-sd/help/term_sd_note.md)" 25 80
                help_option
                ;;
            4)
                dialog --erase-on-exit --title "Term-SD" --backtitle "Term-SD帮助选项" --ok-label "确认" --msgbox "$(cat ./term-sd/help/term_sd_function_introduce.md)" 25 80
                help_option
                ;;
            5)
                dialog --erase-on-exit --title "Term-SD" --backtitle "Term-SD帮助选项" --ok-label "确认" --msgbox "$(cat ./term-sd/help/directory_description.md)" 25 80
                help_option
                ;;
            6)
                dialog --erase-on-exit --title "Term-SD" --backtitle "Term-SD帮助选项" --ok-label "确认" --msgbox "$(cat ./term-sd/help/term_sd_extension_script_description.md)" 25 80
                help_option
                ;;
            7)
                dialog --erase-on-exit --title "Term-SD" --backtitle "Term-SD帮助选项" --ok-label "确认" --msgbox "$(cat ./term-sd/help/sd_webui_extension_description.md)" 25 80
                help_option
                ;;
            8)
                dialog --erase-on-exit --title "Term-SD" --backtitle "Term-SD帮助选项" --ok-label "确认" --msgbox "$(cat ./term-sd/help/comfyui_extension_description.md)" 25 80
                help_option
                ;;
        esac
    fi
}