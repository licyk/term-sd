#!/bin/bash

#term-sd更新选项
function update_option()
{
    if (dialog --clear --title "Term-SD" --backtitle "Term-SD更新选项" --yes-label "是" --no-label "否" --yesno "更新Term-SD时是否使用代理" 20 60) then
        aria2c https://ghproxy.com/https://raw.githubusercontent.com/licyk/sd-webui-script/$term_sd_branch/term-sd.sh -d ./term-sd-update-tmp/
        if [ "$?"="0" ];then
            cp -fv ./term-sd-update-tmp/term-sd.sh ./
            rm -rfv ./term-sd-update-tmp
            chmod u+x term-sd.sh
            if (dialog --clear --title "Term-SD" --backtitle "Term-SD更新结果" --msgbox "Term-SD更新成功" 20 60);then
                source ./term-sd.sh
            fi
        else
            dialog --clear --title "Term-SD" --backtitle "Term-SD更新结果" --msgbox "Term-SD更新失败,请重试" 20 60
        fi
    else
        aria2c https://raw.githubusercontent.com/licyk/sd-webui-script/$term_sd_branch/term-sd.sh -d ./term-sd-update-tmp/
        if [ "$?"="0" ];then
            cp -fv ./term-sd-update-tmp/term-sd.sh ./
            rm -rfv ./term-sd-update-tmp
            chmod u+x term-sd.sh
            if (dialog --clear --title "Term-SD" --backtitle "Term-SD更新结果" --msgbox "Term-SD更新成功" 20 60);then
                source ./term-sd.sh
            fi
        else
            dialog --clear --title "Term-SD" --backtitle "Term-SD更新结果" --msgbox "Term-SD更新失败,请重试" 20 60
        fi
    fi
    mainmenu
}

#扩展脚本选项
function term_sd_extension()
{
    term_sd_extension_proxy=""
    term_sd_extension_option_1="1"
    term_sd_extension_option_2="1"
    term_sd_extension_option_3="1"

    if [ -f "./sd-webui-extension.sh" ];then
        term_sd_extension_1="ON"
    else
        term_sd_extension_1="OFF"
    fi

    if [ -f "./comfyui-extension.sh" ];then
        term_sd_extension_2="ON"
    else
        term_sd_extension_2="OFF"
    fi

    if [ -f "./venv-rebuild.sh" ];then
        term_sd_extension_3="ON"
    else
        term_sd_extension_3="OFF"
    fi

    term_sd_extension_select_=$(
        dialog --clear --title "Term-SD" --backtitle "Term-SD扩展脚本选项" --separate-output --ok-label "确认" --notags --checklist "Term-SD扩展脚本列表\n勾选以下载,如果脚本已下载,则会执行更新；取消勾选以删除\n下载的脚本将会放在term-sd脚本所在目录下\n推荐勾选\"下载代理\"" 20 60 10 \
            "1" "下载代理" ON \
            "2" "sd-webui-extension" "$term_sd_extension_1" \
            "3" "comfyui-extension" "$term_sd_extension_2" \
            "4" "venv-rebuild" "$term_sd_extension_3" \
            3>&1 1>&2 2>&3)
        
    if [ $? = 0 ];then
        for term_sd_extension_select in $term_sd_extension_select_;do
        case "$term_sd_extension_select" in
        "1")
        term_sd_extension_proxy="https://ghproxy.com"
        ;;
        "2")
        term_sd_extension_option_1="0"
        ;;
        "3")
        term_sd_extension_option_2="0"
        ;;
        "4")
        term_sd_extension_option_3="0"
        ;;
        *)
        exit 1
        ;;
        esac
        done

        if [ $term_sd_extension_option_1 = "0" ];then
            aria2c $term_sd_extension_proxy/https://raw.githubusercontent.com/licyk/sd-webui-script/$term_sd_branch/other/sd-webui-extension.sh -d ./term-sd-update-tmp/ -o sd-webui-extension.sh
            
            if [ $? = 0 ];then
                term_sd_extension_info_1="下载成功"
                cp -fv ./term-sd-update-tmp/sd-webui-extension.sh ./
                chmod +x ./sd-webui-extension.sh
                rm -rfv ./term-sd-update-tmp/
            else
                term_sd_extension_info_1="下载失败"
            fi
        else
            rm -rfv ./sd-webui-extension.sh
            term_sd_extension_info_1="已删除"
        fi

        if [ $term_sd_extension_option_2 = "0" ];then
            aria2c $term_sd_extension_proxy/https://raw.githubusercontent.com/licyk/sd-webui-script/$term_sd_branch/other/comfyui-extension.sh -d ./term-sd-update-tmp/ -o comfyui-extension.sh
            if [ $? = 0 ];then
                term_sd_extension_info_2="下载成功"
                cp -fv ./term-sd-update-tmp/comfyui-extension.sh ./
                chmod +x ./comfyui-extension.sh
                rm -rfv ./term-sd-update-tmp/
            else
                term_sd_extension_info_2="下载失败"
            fi
        else
            rm -rfv ./comfyui-extension.sh
            term_sd_extension_info_2="已删除"
        fi

        if [ $term_sd_extension_option_3 = "0" ];then
            aria2c $term_sd_extension_proxy/https://raw.githubusercontent.com/licyk/sd-webui-script/$term_sd_branch/other/venv-rebuild.sh -d ./term-sd-update-tmp/ -o venv-rebuild.sh
            if [ $? = 0 ];then
                term_sd_extension_info_3="下载成功"
                cp -fv ./term-sd-update-tmp/venv-rebuild.sh ./
                chmod +x ./venv-rebuild.sh
                rm -rfv ./term-sd-update-tmp/
            else
                term_sd_extension_info_3="下载失败"
            fi
        else
            rm -rfv ./venv-rebuild.sh
            term_sd_extension_info_3="已删除"
        fi

        dialog --clear --title "Term-SD" --backtitle "Term-SD扩展脚本选项" --msgbox "扩展脚本状态:\nsd-webui-extension:$term_sd_extension_info_1\ncomfyui-extension:$term_sd_extension_info_2\nvenv-rebuild:$term_sd_extension_info_3" 20 60
        term_sd_extension
    else
        mainmenu
    fi
}

source ./term-sd/modules/init.sh