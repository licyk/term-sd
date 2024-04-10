#!/bin/bash

# 自定义ai软件安装路径设置
custom_install_path_setting()
{
    local custom_install_path_setting_dialog
    local custom_install_path
    while true
    do
        custom_install_path_setting_dialog=$(dialog --erase-on-exit --notags \
            --title "Term-SD" \
            --backtitle "自定义安装路径设置界面" \
            --ok-label "确认" --cancel-label "取消" \
            --menu "该功能用于自定义 AI 软件的安装路径, 当保持默认时, AI 软件的安装路径与 Term-SD 所在路径同级\n当前 Term-SD 所在路径: ${start_path}/term-sd\n注: 路径最好使用绝对路径" \
            $term_sd_dialog_height $term_sd_dialog_width $term_sd_dialog_menu_height \
            "0" "> 返回" \
            "1" "> Stable-Diffusion-WebUI 安装路径设置 (当前配置: $([ -f term-sd/config/sd-webui-path.conf ] && echo "自定义" || echo 默认))" \
            "2" "> ComfyUI 安装路径设置 (当前配置: $([ -f term-sd/config/comfyui-path.conf ] && echo "自定义" || echo 默认))" \
            "3" "> InvokeAI 安装路径设置 (当前配置: $([ -f term-sd/config/invokeai-path.conf ] && echo "自定义" || echo 默认))" \
            "4" "> Fooocus 安装路径设置 (当前配置: $([ -f term-sd/config/fooocus-path.conf ] && echo "自定义" || echo 默认))" \
            "5" "> lora-scripts 安装路径设置 (当前配置: $([ -f term-sd/config/lora-scripts-path.conf ] && echo "自定义" || echo 默认))" \
            "6" "> kohya_ss 安装路径设置 (当前配置: $([ -f term-sd/config/kohya_ss-path.conf ] && echo "自定义" || echo 默认))" \
            3>&1 1>&2 2>&3)

        case $custom_install_path_setting_dialog in
            1)
                sd_webui_custom_install_path_setting
                ;;
            2)
                comfyui_custom_install_path_setting
                ;;
            3)
                invokeai_custom_install_path_setting
                ;;
            4)
                fooocus_custom_install_path_setting
                ;;
            5)
                lora_scripts_custom_install_path_setting
                ;;
            6)
                kohya_ss_custom_install_path_setting
                ;;
            *)
                break
                ;;
        esac
    done
}

# sd-webui安装路径设置
sd_webui_custom_install_path_setting()
{
    local custom_install_path
    local sd_webui_custom_install_path_setting_dialog

    while true
    do
        sd_webui_custom_install_path_setting_dialog=$(dialog --erase-on-exit --notags \
            --title "Term-SD" \
            --backtitle "Stable-Diffusion-WebUI 安装路径设置界面" \
            --ok-label "确认" --cancel-label "取消" \
            --menu "请选择配置选项\n当前自定义安装路径: $([ -f term-sd/config/sd-webui-path.conf ] && cat term-sd/config/sd-webui-path.conf || echo 默认)" \
            $term_sd_dialog_height $term_sd_dialog_width $term_sd_dialog_menu_height \
            "0" "> 返回" \
            "1" "> 设置安装路径" \
            "2" "> 恢复默认安装路径设置" \
            3>&1 1>&2 2>&3)

        case $sd_webui_custom_install_path_setting_dialog in
            1)
                custom_install_path=$(dialog --erase-on-exit \
                    --title "Term-SD" \
                    --backtitle "Stable-Diffusion-WebUI 安装路径设置界面" \
                    --ok-label "确认" --cancel-label "取消" \
                    --inputbox "请输入 Stable-Diffusion-WebUI 安装路径\n注: 请使用绝对路径" \
                    $term_sd_dialog_height $term_sd_dialog_width \
                    "$([ -f term-sd/config/sd-webui-path.conf ] && cat term-sd/config/sd-webui-path.conf)" \
                    3>&1 1>&2 2>&3)

                if [ $? = 0 ] && [ ! -z "$custom_install_path" ];then
                    if [ "$custom_install_path" = "/" ];then
                        dialog --erase-on-exit \
                            --title "Term-SD" \
                            --backtitle "Stable-Diffusion-WebUI 安装路径设置界面" \
                            --ok-label "确认" \
                            --msgbox "禁止将根目录设置为安装路径" \
                            $term_sd_dialog_height $term_sd_dialog_width

                    elif [ "$custom_install_path" = "$comfyui_path" ] ||\
                    [ "$custom_install_path" = "$invokeai_path" ] ||\
                    [ "$custom_install_path" = "$fooocus_path" ] ||\
                    [ "$custom_install_path" = "$lora_scripts_path" ] ||\
                    [ "$custom_install_path" = "$kohya_ss_path" ];then

                        dialog --erase-on-exit \
                            --title "Term-SD" \
                            --backtitle "Stable-Diffusion-WebUI 安装路径设置界面" \
                            --ok-label "确认" \
                            --msgbox "安装路径和其他 AI 软件的安装目录相同, 请重新设置" \
                            $term_sd_dialog_height $term_sd_dialog_width

                    else
                        export sd_webui_path=$custom_install_path
                        export sd_webui_folder=$(basename "$sd_webui_path")
                        export sd_webui_parent_path=$(dirname "$sd_webui_path")
                        echo "$custom_install_path" > term-sd/config/sd-webui-path.conf

                        dialog --erase-on-exit \
                            --title "Term-SD" \
                            --backtitle "Stable-Diffusion-WebUI 安装路径设置界面" \
                            --ok-label "确认" \
                            --msgbox "Stable-Diffusion-WebUI 安装路径设置成功\n安装路径: $custom_install_path\n$([ ! $(echo $custom_install_path | awk '{print substr($0,1,1)}') = "/" ] && [ ! "$OS" = "Windows_NT" ] && echo "检测到安装路径不是绝对路径, 可能会导致一些问题")" \
                            $term_sd_dialog_height $term_sd_dialog_width
                    fi
                fi
                ;;
            2)
                if (dialog --erase-on-exit \
                    --title "Term-SD" \
                    --backtitle "Stable-Diffusion-WebUI 安装路径设置界面" \
                    --yes-label "是" --no-label "否" \
                    --yesno "是否重置 Stable-Diffusion-WebUI 安装路径?" \
                    $term_sd_dialog_height $term_sd_dialog_width) then

                    rm -f term-sd/config/sd-webui-path.conf
                    export sd_webui_path="$start_path/stable-diffusion-webui"
                    export sd_webui_folder="stable-diffusion-webui"
                    export sd_webui_parent_path=$start_path

                    dialog --erase-on-exit \
                        --title "Term-SD" \
                        --backtitle "Stable-Diffusion-WebUI 安装路径设置界面" \
                        --ok-label "确认" \
                        --msgbox "重置 Stable-Diffusion-WebUI 安装路径成功" \
                        $term_sd_dialog_height $term_sd_dialog_width
                fi
                ;;
            *)
                break
                ;;
        esac
    done
}

# comfyui安装路径设置
comfyui_custom_install_path_setting()
{
    local custom_install_path
    local comfyui_custom_install_path_setting_dialog

    while true
    do
        comfyui_custom_install_path_setting_dialog=$(
            dialog --erase-on-exit --notags \
            --title "Term-SD" \
            --backtitle "ComfyUI 安装路径设置界面" \
            --ok-label "确认" \
            --cancel-label "取消" \
            --menu "请选择配置选项\n当前自定义安装路径: $([ -f term-sd/config/comfyui-path.conf ] && cat term-sd/config/comfyui-path.conf || echo 默认)" \
            $term_sd_dialog_height $term_sd_dialog_width $term_sd_dialog_menu_height \
            "0" "> 返回" \
            "1" "> 设置安装路径" \
            "2" "> 恢复默认安装路径设置" \
            3>&1 1>&2 2>&3)

        case $comfyui_custom_install_path_setting_dialog in
            1)
                custom_install_path=$(dialog --erase-on-exit \
                    --title "Term-SD" \
                    --backtitle "ComfyUI 安装路径设置界面" \
                    --ok-label "确认" --cancel-label "取消" \
                    --inputbox "请输入 ComfyUI 安装路径\n注: 请使用绝对路径" \
                    $term_sd_dialog_height $term_sd_dialog_width \
                    "$([ -f term-sd/config/comfyui-path.conf ] && cat term-sd/config/comfyui-path.conf)" \
                    3>&1 1>&2 2>&3)

                if [ $? = 0 ] && [ ! -z "$custom_install_path" ];then
                    if [ "$custom_install_path" = "/" ];then
                        dialog --erase-on-exit \
                            --title "Term-SD" \
                            --backtitle "ComfyUI 安装路径设置界面" \
                            --ok-label "确认" \
                            --msgbox "禁止将根目录设置为安装路径" \
                            $term_sd_dialog_height $term_sd_dialog_width

                    elif [ "$custom_install_path" = "$sd_webui_path" ] ||\
                    [ "$custom_install_path" = "$invokeai_path" ] ||\
                    [ "$custom_install_path" = "$fooocus_path" ] ||\
                    [ "$custom_install_path" = "$lora_scripts_path" ] ||\
                    [ "$custom_install_path" = "$kohya_ss_path" ];then

                        dialog --erase-on-exit \
                            --title "Term-SD" \
                            --backtitle "ComfyUI 安装路径设置界面" \
                            --ok-label "确认" \
                            --msgbox "安装路径和其他 AI 软件的安装目录相同, 请重新设置" \
                            $term_sd_dialog_height $term_sd_dialog_width

                    else
                        export comfyui_path=$custom_install_path
                        export comfyui_folder=$(basename "$comfyui_path")
                        export comfyui_parent_path=$(dirname "$comfyui_path")
                        echo "$custom_install_path" > term-sd/config/comfyui-path.conf

                        dialog --erase-on-exit \
                            --title "Term-SD" \
                            --backtitle "ComfyUI 安装路径设置界面" \
                            --ok-label "确认" \
                            --msgbox "ComfyUI 安装路径设置成功\n安装路径: $custom_install_path\n$([ ! $(echo $custom_install_path | awk '{print substr($0,1,1)}') = "/" ] && [ ! "$OS" = "Windows_NT" ] && echo "检测到安装路径不是绝对路径, 可能会导致一些问题")" \
                            $term_sd_dialog_height $term_sd_dialog_width
                    fi
                fi
                ;;
            2)
                if (dialog --erase-on-exit \
                    --title "Term-SD" \
                    --backtitle "ComfyUI安装路径设置界面" \
                    --yes-label "是" --no-label "否" \
                    --yesno "是否重置 ComfyUI 安装路径?" \
                    $term_sd_dialog_height $term_sd_dialog_width) then

                    rm -f term-sd/config/comfyui-path.conf
                    export comfyui_path="$start_path/ComfyUI"
                    export comfyui_folder="ComfyUI"
                    export comfyui_parent_path=$start_path

                    dialog --erase-on-exit \
                        --title "Term-SD" \
                        --backtitle "ComfyUI 安装路径设置界面" \
                        --ok-label "确认" \
                        --msgbox "重置 ComfyUI 安装路径成功" \
                        $term_sd_dialog_height $term_sd_dialog_width
                fi
                ;;
            *)
                break
                ;;
        esac
    done
}

# invokeai安装路径设置
invokeai_custom_install_path_setting()
{
    local custom_install_path
    local invokeai_custom_install_path_setting_dialog

    while true
    do
        invokeai_custom_install_path_setting_dialog=$(dialog --erase-on-exit --notags \
            --title "Term-SD" \
            --backtitle "InvokeAI 安装路径设置界面" \
            --ok-label "确认" --cancel-label "取消" \
            --menu "请选择配置选项\n当前自定义安装路径: $([ -f term-sd/config/invokeai-path.conf ] && cat term-sd/config/invokeai-path.conf || echo 默认)" \
            $term_sd_dialog_height $term_sd_dialog_width $term_sd_dialog_menu_height \
            "0" "> 返回" \
            "1" "> 设置安装路径" \
            "2" "> 恢复默认安装路径设置" \
            3>&1 1>&2 2>&3)

        case $invokeai_custom_install_path_setting_dialog in
            1)
                custom_install_path=$(dialog --erase-on-exit \
                    --title "Term-SD" \
                    --backtitle "InvokeAI 安装路径设置界面" \
                    --ok-label "确认" --cancel-label "取消" \
                    --inputbox "请输入 InvokeAI 安装路径\n注: 请使用绝对路径" \
                    $term_sd_dialog_height $term_sd_dialog_width \
                    "$([ -f term-sd/config/invokeai-path.conf ] && cat term-sd/config/invokeai-path.conf)" \
                    3>&1 1>&2 2>&3)

                if [ $? = 0 ] && [ ! -z "$custom_install_path" ];then
                    if [ "$custom_install_path" = "/" ];then
                        dialog --erase-on-exit \
                            --title "Term-SD" \
                            --backtitle "InvokeAI 安装路径设置界面" \
                            --ok-label "确认" \
                            --msgbox "禁止将根目录设置为安装路径" \
                            $term_sd_dialog_height $term_sd_dialog_width

                    elif [ "$custom_install_path" = "$sd_webui_path" ] ||\
                    [ "$custom_install_path" = "$comfyui_path" ] ||\
                    [ "$custom_install_path" = "$fooocus_path" ] ||\
                    [ "$custom_install_path" = "$lora_scripts_path" ] ||\
                    [ "$custom_install_path" = "$kohya_ss_path" ];then

                        dialog --erase-on-exit \
                            --title "Term-SD" \
                            --backtitle "InvokeAI 安装路径设置界面" \
                            --ok-label "确认" \
                            --msgbox "安装路径和其他AI软件的安装目录相同, 请重新设置" \
                            $term_sd_dialog_height $term_sd_dialog_width

                    else
                        export invokeai_path=$custom_install_path
                        export invokeai_folder=$(basename "$invokeai_path")
                        export invokeai_parent_path=$(dirname "$invokeai_path")
                        echo "$custom_install_path" > term-sd/config/invokeai-path.conf

                        dialog --erase-on-exit \
                            --title "Term-SD" \
                            --backtitle "InvokeAI 安装路径设置界面" \
                            --ok-label "确认" \
                            --msgbox "InvokeAI 安装路径设置成功\n安装路径: $custom_install_path\n$([ ! $(echo $custom_install_path | awk '{print substr($0,1,1)}') = "/" ] && [ ! "$OS" = "Windows_NT" ] && echo "检测到安装路径不是绝对路径,可能会导致一些问题")" \
                            $term_sd_dialog_height $term_sd_dialog_width
                    fi
                fi
                ;;
            2)
                if (dialog --erase-on-exit \
                    --title "Term-SD" \
                    --backtitle "InvokeAI 安装路径设置界面" \
                    --yes-label "是" --no-label "否" \
                    --yesno "是否重置 InvokeAI 安装路径?" \
                    $term_sd_dialog_height $term_sd_dialog_width) then

                    rm -f term-sd/config/invokeai-path.conf
                    export invokeai_path="$start_path/InvokeAI"
                    export invokeai_folder="InvokeAI"
                    export invokeai_parent_path=$start_path

                    dialog --erase-on-exit \
                        --title "Term-SD" \
                        --backtitle "InvokeAI 安装路径设置界面" \
                        --ok-label "确认" \
                        --msgbox "重置 InvokeAI 安装路径成功" \
                        $term_sd_dialog_height $term_sd_dialog_width
                fi
                ;;
            *)
                break
                ;;
        esac
    done
}

# fooocus安装路径设置
fooocus_custom_install_path_setting()
{
    local custom_install_path
    local fooocus_custom_install_path_setting_dialog

    while true
    do
        fooocus_custom_install_path_setting_dialog=$(dialog --erase-on-exit --notags \
            --title "Term-SD" \
            --backtitle "Fooocus 安装路径设置界面" \
            --ok-label "确认" --cancel-label "取消" \
            --menu "请选择配置选项\n当前自定义安装路径: $([ -f term-sd/config/fooocus-path.conf ] && cat term-sd/config/fooocus-path.conf || echo 默认)" \
            $term_sd_dialog_height $term_sd_dialog_width $term_sd_dialog_menu_height \
            "0" "> 返回" \
            "1" "> 设置安装路径" \
            "2" "> 恢复默认安装路径设置" \
            3>&1 1>&2 2>&3)

        case $fooocus_custom_install_path_setting_dialog in
            1)
                custom_install_path=$(dialog --erase-on-exit \
                    --title "Term-SD" \
                    --backtitle "Fooocus 安装路径设置界面" \
                    --ok-label "确认" --cancel-label "取消" \
                    --inputbox "请输入 Fooocus 安装路径\n注: 请使用绝对路径" \
                    $term_sd_dialog_height $term_sd_dialog_width \
                    "$([ -f term-sd/config/fooocus-path.conf ] && cat term-sd/config/fooocus-path.conf)" \
                    3>&1 1>&2 2>&3)

                if [ $? = 0 ] && [ ! -z "$custom_install_path" ];then
                    if [ "$custom_install_path" = "/" ];then
                        dialog --erase-on-exit \
                            --title "Term-SD" \
                            --backtitle "Fooocus 安装路径设置界面" \
                            --ok-label "确认" \
                            --msgbox "禁止将根目录设置为安装路径" \
                            $term_sd_dialog_height $term_sd_dialog_width

                    elif [ "$custom_install_path" = "$sd_webui_path" ] ||\
                    [ "$custom_install_path" = "$comfyui_path" ] ||\
                    [ "$custom_install_path" = "$invokeai_path" ] ||\
                    [ "$custom_install_path" = "$lora_scripts_path" ] ||\
                    [ "$custom_install_path" = "$kohya_ss_path" ];then

                        dialog --erase-on-exit \
                            --title "Term-SD" \
                            --backtitle "Fooocus 安装路径设置界面" \
                            --ok-label "确认" \
                            --msgbox "安装路径和其他 AI 软件的安装目录相同, 请重新设置" \
                            $term_sd_dialog_height $term_sd_dialog_width

                    else
                        export fooocus_path=$custom_install_path
                        export fooocus_folder=$(basename "$fooocus_path")
                        export fooocus_parent_path=$(dirname "$fooocus_path")
                        echo "$custom_install_path" > term-sd/config/fooocus-path.conf

                        dialog --erase-on-exit \
                            --title "Term-SD" \
                            --backtitle "Fooocus 安装路径设置界面" \
                            --ok-label "确认" \
                            --msgbox "Fooocus 安装路径设置成功\n安装路径: $custom_install_path\n$([ ! $(echo $custom_install_path | awk '{print substr($0,1,1)}') = "/" ] && [ ! "$OS" = "Windows_NT" ] && echo "检测到安装路径不是绝对路径,可能会导致一些问题")" \
                            $term_sd_dialog_height $term_sd_dialog_width
                    fi
                fi
                ;;
            2)
                if (dialog --erase-on-exit \
                --title "Term-SD" \
                --backtitle "Fooocus 安装路径设置界面" \
                --yes-label "是" --no-label "否" \
                --yesno "是否重置 Fooocus 安装路径?" \
                $term_sd_dialog_height $term_sd_dialog_width) then

                    rm -f term-sd/config/fooocus-path.conf
                    export fooocus_path="$start_path/Fooocus"
                    export fooocus_folder="Fooocus"
                    export fooocus_parent_path=$start_path

                    dialog --erase-on-exit \
                        --title "Term-SD" \
                        --backtitle "Fooocus 安装路径设置界面" \
                        --ok-label "确认" --msgbox "重置 Fooocus 安装路径成功" \
                        $term_sd_dialog_height $term_sd_dialog_width
                fi
                ;;
            *)
                break
                ;;
        esac
    done
}

# lora-scripts安装路径设置
lora_scripts_custom_install_path_setting()
{
    local custom_install_path
    local lora_scripts_custom_install_path_setting_dialog

    while true
    do
        lora_scripts_custom_install_path_setting_dialog=$(dialog --erase-on-exit --notags \
            --title "Term-SD" \
            --backtitle "lora-scripts 安装路径设置界面" \
            --ok-label "确认" --cancel-label "取消" \
            --menu "请选择配置选项\n当前自定义安装路径: $([ -f term-sd/config/lora-scripts-path.conf ] && cat term-sd/config/lora-scripts-path.conf || echo 默认)" \
            $term_sd_dialog_height $term_sd_dialog_width $term_sd_dialog_menu_height \
            "0" "> 返回" \
            "1" "> 设置安装路径" \
            "2" "> 恢复默认安装路径设置" \
            3>&1 1>&2 2>&3)

        case $lora_scripts_custom_install_path_setting_dialog in
            1)
                custom_install_path=$(dialog --erase-on-exit \
                    --title "Term-SD" \
                    --backtitle "lora-scripts 安装路径设置界面" \
                    --ok-label "确认" --cancel-label "取消" \
                    --inputbox "请输入 lora-scripts 安装路径\n注: 请使用绝对路径" \
                    $term_sd_dialog_height $term_sd_dialog_width \
                    "$([ -f term-sd/config/lora-scripts-path.conf ] && cat term-sd/config/lora-scripts-path.conf)" \
                    3>&1 1>&2 2>&3)

                if [ $? = 0 ] && [ ! -z "$custom_install_path" ];then
                    if [ "$custom_install_path" = "/" ];then
                        dialog --erase-on-exit \
                            --title "Term-SD" \
                            --backtitle "lora-scripts 安装路径设置界面" \
                            --ok-label "确认" \
                            --msgbox "禁止将根目录设置为安装路径" \
                            $term_sd_dialog_height $term_sd_dialog_width

                    elif [ "$custom_install_path" = "$sd_webui_path" ] ||\
                    [ "$custom_install_path" = "$comfyui_path" ] ||\
                    [ "$custom_install_path" = "$invokeai_path" ] ||\
                    [ "$custom_install_path" = "$fooocus_path" ] ||\
                    [ "$custom_install_path" = "$kohya_ss_path" ];then

                        dialog --erase-on-exit \
                            --title "Term-SD" \
                            --backtitle "lora-scripts 安装路径设置界面" \
                            --ok-label "确认" \
                            --msgbox "安装路径和其他 AI 软件的安装目录相同, 请重新设置" \
                            $term_sd_dialog_height $term_sd_dialog_width

                    else
                        export lora_scripts_path=$custom_install_path
                        export lora_scripts_folder=$(basename "$lora_scripts_path")
                        export lora_scripts_parent_path=$(dirname "$lora_scripts_path")
                        echo "$custom_install_path" > term-sd/config/lora-scripts-path.conf

                        dialog --erase-on-exit \
                            --title "Term-SD" \
                            --backtitle "lora-scripts 安装路径设置界面" \
                            --ok-label "确认" \
                            --msgbox "lora-scripts 安装路径设置成功\n安装路径: $custom_install_path\n$([ ! $(echo $custom_install_path | awk '{print substr($0,1,1)}') = "/" ] && [ ! "$OS" = "Windows_NT" ] && echo "检测到安装路径不是绝对路径,可能会导致一些问题")" \
                            $term_sd_dialog_height $term_sd_dialog_width
                    fi
                fi
                ;;
            2)
                if (dialog --erase-on-exit \
                    --title "Term-SD" \
                    --backtitle "lora-scripts 安装路径设置界面" \
                    --yes-label "是" --no-label "否" \
                    --yesno "是否重置 lora-scripts 安装路径?" \
                    $term_sd_dialog_height $term_sd_dialog_width) then

                    rm -f term-sd/config/lora-scripts-path.conf
                    export lora_scripts_path="$start_path/lora-scripts"
                    export lora_scripts_folder="lora-scripts"
                    export lora_scripts_parent_path=$start_path

                    dialog --erase-on-exit \
                        --title "Term-SD" \
                        --backtitle "lora-scripts 安装路径设置界面" \
                        --ok-label "确认" \
                        --msgbox "重置 lora-scripts 安装路径成功" \
                        $term_sd_dialog_height $term_sd_dialog_width
                fi
                ;;
            *)
                break
                ;;
        esac
    done
}

# kohya_ss安装路径设置
kohya_ss_custom_install_path_setting()
{
    local custom_install_path
    local kohya_ss_custom_install_path_setting_dialog

    while true
    do
        kohya_ss_custom_install_path_setting_dialog=$(dialog --erase-on-exit --notags \
            --title "Term-SD" \
            --backtitle "kohya_ss 安装路径设置界面" \
            --ok-label "确认" --cancel-label "取消" \
            --menu "请选择配置选项\n当前自定义安装路径: $([ -f term-sd/config/kohya_ss-path.conf ] && cat term-sd/config/kohya_ss-path.conf || echo 默认)" \
            $term_sd_dialog_height $term_sd_dialog_width $term_sd_dialog_menu_height \
            "0" "> 返回" \
            "1" "> 设置安装路径" \
            "2" "> 恢复默认安装路径设置" \
            3>&1 1>&2 2>&3)

        case $kohya_ss_custom_install_path_setting_dialog in
            1)
                custom_install_path=$(dialog --erase-on-exit \
                    --title "Term-SD" \
                    --backtitle "kohya_ss 安装路径设置界面" \
                    --ok-label "确认" --cancel-label "取消" \
                    --inputbox "请输入 kohya_ss 安装路径\n注: 请使用绝对路径" \
                    $term_sd_dialog_height $term_sd_dialog_width \
                    "$([ -f term-sd/config/kohya_ss-path.conf ] && cat term-sd/config/kohya_ss-path.conf)" \
                    3>&1 1>&2 2>&3)

                if [ $? = 0 ] && [ ! -z "$custom_install_path" ];then
                    if [ "$custom_install_path" = "/" ];then
                        dialog --erase-on-exit \
                            --title "Term-SD" \
                            --backtitle "kohya_ss 安装路径设置界面" \
                            --ok-label "确认" \
                            --msgbox "禁止将根目录设置为安装路径" \
                            $term_sd_dialog_height $term_sd_dialog_width

                    elif [ "$custom_install_path" = "$sd_webui_path" ] ||\
                    [ "$custom_install_path" = "$comfyui_path" ] ||\
                    [ "$custom_install_path" = "$invokeai_path" ] ||\
                    [ "$custom_install_path" = "$fooocus_path" ] ||\
                    [ "$custom_install_path" = "$lora_scripts_path" ];then

                        dialog --erase-on-exit \
                            --title "Term-SD" \
                            --backtitle "kohya_ss 安装路径设置界面" \
                            --ok-label "确认" \
                            --msgbox "安装路径和其他AI软件的安装目录相同, 请重新设置" \
                            $term_sd_dialog_height $term_sd_dialog_width

                    else
                        export kohya_ss_path=$custom_install_path
                        export kohya_ss_folder=$(basename "$kohya_ss_path")
                        export kohya_ss_parent_path=$(dirname "$kohya_ss_path")
                        echo "$custom_install_path" > term-sd/config/kohya_ss-path.conf

                        dialog --erase-on-exit \
                            --title "Term-SD" \
                            --backtitle "kohya_ss 安装路径设置界面" \
                            --ok-label "确认" \
                            --msgbox "kohya_ss 安装路径设置成功\n安装路径: $custom_install_path\n$([ ! $(echo $custom_install_path | awk '{print substr($0,1,1)}') = "/" ] && [ ! "$OS" = "Windows_NT" ] && echo "检测到安装路径不是绝对路径,可能会导致一些问题")" \
                            $term_sd_dialog_height $term_sd_dialog_width
                    fi
                fi
                ;;
            2)
                if (dialog --erase-on-exit \
                    --title "Term-SD" \
                    --backtitle "kohya_ss 安装路径设置界面" \
                    --yes-label "是" --no-label "否" \
                    --yesno "是否重置 kohya_ss 安装路径?" \
                    $term_sd_dialog_height $term_sd_dialog_width) then

                    rm -f term-sd/config/kohya_ss-path.conf
                    export kohya_ss_path="$start_path/kohya_ss"
                    export kohya_ss_folder="kohya_ss"
                    export kohya_ss_parent_path=$start_path

                    dialog --erase-on-exit \
                        --title "Term-SD" \
                        --backtitle "kohya_ss 安装路径设置界面" \
                        --ok-label "确认" \
                        --msgbox "重置 kohya_ss 安装路径成功" \
                        $term_sd_dialog_height $term_sd_dialog_width
                fi
                ;;
            *)
                break
                ;;
        esac
    done
}