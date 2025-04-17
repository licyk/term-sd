#!/bin/bash

# 自定义 AI 软件安装路径设置
# SD WebUI 自定义安装路径配置保存在 <Start Path>/term-sd/config/sd-webui-path.conf
# ComfyUI 自定义安装路径配置保存在 <Start Path>/term-sd/config/comfyui-path.conf
# InvokeAI 自定义安装路径配置保存在 <Start Path>/term-sd/config/invokeai-path.conf
# Fooocus 自定义安装路径配置保存在 <Start Path>/term-sd/config/fooocus-path.conf
# lora-scripts 自定义安装路径配置保存在 <Start Path>/term-sd/config/lora-scripts-path.conf
# kohya_ss 自定义安装路径配置保存在 <Start Path>/term-sd/config/kohya_ss-path.conf
custom_install_path_setting() {
    local dialog_arg
    local custom_install_path
    local sd_webui_info
    local comfyui_info
    local invokeai_info
    local fooocus_info
    local lora_scripts_info
    local kohya_ss_info

    while true; do
        if [[ -f "${START_PATH}/term-sd/config/sd-webui-path.conf" ]]; then
            sd_webui_info="自定义"
        else
            sd_webui_info="默认"
        fi

        if [[ -f "${START_PATH}/term-sd/config/comfyui-path.conf" ]]; then
            comfyui_info="自定义"
        else
            comfyui_info="默认"
        fi

        if [[ -f "${START_PATH}/term-sd/config/invokeai-path.conf" ]]; then
            invokeai_info="自定义"
        else
            invokeai_info="默认"
        fi

        if [[ -f "${START_PATH}/term-sd/config/fooocus-path.conf" ]]; then
            fooocus_info="自定义"
        else
            fooocus_info="默认"
        fi

        if [[ -f "${START_PATH}/term-sd/config/lora-scripts-path.conf" ]]; then
            lora_scripts_info="自定义"
        else
            lora_scripts_info="默认"
        fi

        if [[ -f "${START_PATH}/term-sd/config/kohya_ss-path.conf" ]]; then
            kohya_ss_info="自定义"
        else
            kohya_ss_info="默认"
        fi

        dialog_arg=$(dialog --erase-on-exit --notags \
            --title "Term-SD" \
            --backtitle "自定义安装路径设置界面" \
            --ok-label "确认" --cancel-label "取消" \
            --menu "该功能用于自定义 AI 软件的安装路径, 当保持默认时, AI 软件的安装路径与 Term-SD 所在路径同级\n当前 Term-SD 所在路径: ${START_PATH}/term-sd\n注: 路径最好使用绝对路径" \
            $(get_dialog_size_menu) \
            "0" "> 返回" \
            "1" "> Stable-Diffusion-WebUI 安装路径设置 (当前配置: ${sd_webui_info})" \
            "2" "> ComfyUI 安装路径设置 (当前配置: ${comfyui_info})" \
            "3" "> InvokeAI 安装路径设置 (当前配置: ${invokeai_info})" \
            "4" "> Fooocus 安装路径设置 (当前配置: ${fooocus_info})" \
            "5" "> lora-scripts 安装路径设置 (当前配置: ${lora_scripts_info})" \
            "6" "> kohya_ss 安装路径设置 (当前配置: ${kohya_ss_info})" \
            3>&1 1>&2 2>&3)

        case "${dialog_arg}" in
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

# SD WebUI 安装路径设置
sd_webui_custom_install_path_setting() {
    local custom_install_path
    local dialog_arg
    local path_info
    local install_path

    while true; do
        if [[ -f "${START_PATH}/term-sd/config/sd-webui-path.conf" ]];then
            path_info=$(cat "${START_PATH}/term-sd/config/sd-webui-path.conf")
            install_path=$path_info
        else
            path_info="默认"
            unset install_path
        fi

        dialog_arg=$(dialog --erase-on-exit --notags \
            --title "Term-SD" \
            --backtitle "Stable-Diffusion-WebUI 安装路径设置界面" \
            --ok-label "确认" --cancel-label "取消" \
            --menu "请选择配置选项\n当前自定义安装路径: ${path_info}" \
            $(get_dialog_size_menu) \
            "0" "> 返回" \
            "1" "> 设置安装路径" \
            "2" "> 恢复默认安装路径设置" \
            3>&1 1>&2 2>&3)

        case "${dialog_arg}" in
            1)
                custom_install_path=$(dialog --erase-on-exit \
                    --title "Term-SD" \
                    --backtitle "Stable-Diffusion-WebUI 安装路径设置界面" \
                    --ok-label "确认" --cancel-label "取消" \
                    --inputbox "请输入 Stable-Diffusion-WebUI 安装路径\n注: 请使用绝对路径" \
                    $(get_dialog_size) \
                    "${install_path}" \
                    3>&1 1>&2 2>&3)

                if [[ "$?" == 0 ]] && [[ ! -z "${custom_install_path}" ]]; then
                    if [[ "${custom_install_path}" == "/" ]]; then
                        dialog --erase-on-exit \
                            --title "Term-SD" \
                            --backtitle "Stable-Diffusion-WebUI 安装路径设置界面" \
                            --ok-label "确认" \
                            --msgbox "禁止将根目录设置为安装路径" \
                            $(get_dialog_size)

                    elif [[ "${custom_install_path}" == "${COMFYUI_ROOT_PATH}" ]] \
                        || [[ "${custom_install_path}" == "${INVOKEAI_ROOT_PATH}" ]] \
                        || [[ "${custom_install_path}" == "${FOOOCUS_ROOT_PATH}" ]] \
                        || [[ "${custom_install_path}" == "${LORA_SCRIPTS_ROOT_PATH}" ]] \
                        || [[ "${custom_install_path}" == "${KOHYA_SS_ROOT_PATH}" ]]; then

                        dialog --erase-on-exit \
                            --title "Term-SD" \
                            --backtitle "Stable-Diffusion-WebUI 安装路径设置界面" \
                            --ok-label "确认" \
                            --msgbox "安装路径和其他 AI 软件的安装目录相同, 请重新设置" \
                            $(get_dialog_size)

                    else
                        SD_WEBUI_ROOT_PATH=$custom_install_path
                        SD_WEBUI_FOLDER=$(basename "${SD_WEBUI_ROOT_PATH}")
                        SD_WEBUI_PARENT_PATH=$(dirname "${SD_WEBUI_ROOT_PATH}")
                        echo "${custom_install_path}" > "${START_PATH}/term-sd/config/sd-webui-path.conf"

                        dialog --erase-on-exit \
                            --title "Term-SD" \
                            --backtitle "Stable-Diffusion-WebUI 安装路径设置界面" \
                            --ok-label "确认" \
                            --msgbox "Stable-Diffusion-WebUI 安装路径设置成功\n安装路径: ${custom_install_path}\n$(custom_install_path_is_rel_path_warning "${custom_install_path}")" \
                            $(get_dialog_size)
                    fi
                fi
                ;;
            2)
                if (dialog --erase-on-exit \
                    --title "Term-SD" \
                    --backtitle "Stable-Diffusion-WebUI 安装路径设置界面" \
                    --yes-label "是" --no-label "否" \
                    --yesno "是否重置 Stable-Diffusion-WebUI 安装路径 ?" \
                    $(get_dialog_size)); then

                    rm -f "${START_PATH}/term-sd/config/sd-webui-path.conf"
                    SD_WEBUI_ROOT_PATH="${START_PATH}/stable-diffusion-webui"
                    SD_WEBUI_FOLDER="stable-diffusion-webui"
                    SD_WEBUI_PARENT_PATH=$START_PATH

                    dialog --erase-on-exit \
                        --title "Term-SD" \
                        --backtitle "Stable-Diffusion-WebUI 安装路径设置界面" \
                        --ok-label "确认" \
                        --msgbox "重置 Stable-Diffusion-WebUI 安装路径成功" \
                        $(get_dialog_size)
                fi
                ;;
            *)
                break
                ;;
        esac
    done
}

# ComfyUI 安装路径设置
comfyui_custom_install_path_setting() {
    local custom_install_path
    local dialog_arg
    local path_info
    local install_path

    while true; do
        if [[ -f "${START_PATH}/term-sd/config/comfyui-path.conf" ]];then
            path_info=$(cat "${START_PATH}/term-sd/config/comfyui-path.conf")
            install_path=$path_info
        else
            path_info="默认"
            unset install_path
        fi

        dialog_arg=$(
            dialog --erase-on-exit --notags \
            --title "Term-SD" \
            --backtitle "ComfyUI 安装路径设置界面" \
            --ok-label "确认" \
            --cancel-label "取消" \
            --menu "请选择配置选项\n当前自定义安装路径: ${path_info}" \
            $(get_dialog_size_menu) \
            "0" "> 返回" \
            "1" "> 设置安装路径" \
            "2" "> 恢复默认安装路径设置" \
            3>&1 1>&2 2>&3)

        case "${dialog_arg}" in
            1)
                custom_install_path=$(dialog --erase-on-exit \
                    --title "Term-SD" \
                    --backtitle "ComfyUI 安装路径设置界面" \
                    --ok-label "确认" --cancel-label "取消" \
                    --inputbox "请输入 ComfyUI 安装路径\n注: 请使用绝对路径" \
                    $(get_dialog_size) \
                    "${install_path}" \
                    3>&1 1>&2 2>&3)

                if [[ "$?" == 0 ]] && [[ ! -z "${custom_install_path}" ]]; then
                    if [[ "${custom_install_path}" == "/" ]]; then
                        dialog --erase-on-exit \
                            --title "Term-SD" \
                            --backtitle "ComfyUI 安装路径设置界面" \
                            --ok-label "确认" \
                            --msgbox "禁止将根目录设置为安装路径" \
                            $(get_dialog_size)

                    elif [[ "${custom_install_path}" == "${SD_WEBUI_ROOT_PATH}" ]] \
                        || [[ "${custom_install_path}" == "${INVOKEAI_ROOT_PATH}" ]] \
                        || [[ "${custom_install_path}" == "${FOOOCUS_ROOT_PATH}" ]] \
                        || [[ "${custom_install_path}" == "${LORA_SCRIPTS_ROOT_PATH}" ]] \
                        || [[ "${custom_install_path}" == "${KOHYA_SS_ROOT_PATH}" ]]; then

                        dialog --erase-on-exit \
                            --title "Term-SD" \
                            --backtitle "ComfyUI 安装路径设置界面" \
                            --ok-label "确认" \
                            --msgbox "安装路径和其他 AI 软件的安装目录相同, 请重新设置" \
                            $(get_dialog_size)

                    else
                        COMFYUI_ROOT_PATH=$custom_install_path
                        COMFYUI_FOLDER=$(basename "${COMFYUI_ROOT_PATH}")
                        COMFYUI_PARENT_PATH=$(dirname "${COMFYUI_ROOT_PATH}")
                        echo "${custom_install_path}" > "${START_PATH}/term-sd/config/comfyui-path.conf"

                        dialog --erase-on-exit \
                            --title "Term-SD" \
                            --backtitle "ComfyUI 安装路径设置界面" \
                            --ok-label "确认" \
                            --msgbox "ComfyUI 安装路径设置成功\n安装路径: ${custom_install_path}\n$(custom_install_path_is_rel_path_warning "${custom_install_path}")" \
                            $(get_dialog_size)
                    fi
                fi
                ;;
            2)
                if (dialog --erase-on-exit \
                    --title "Term-SD" \
                    --backtitle "ComfyUI安装路径设置界面" \
                    --yes-label "是" --no-label "否" \
                    --yesno "是否重置 ComfyUI 安装路径 ?" \
                    $(get_dialog_size)); then

                    rm -f "${START_PATH}/term-sd/config/comfyui-path.conf"
                    COMFYUI_ROOT_PATH="${START_PATH}/ComfyUI"
                    COMFYUI_FOLDER="ComfyUI"
                    COMFYUI_PARENT_PATH=$START_PATH

                    dialog --erase-on-exit \
                        --title "Term-SD" \
                        --backtitle "ComfyUI 安装路径设置界面" \
                        --ok-label "确认" \
                        --msgbox "重置 ComfyUI 安装路径成功" \
                        $(get_dialog_size)
                fi
                ;;
            *)
                break
                ;;
        esac
    done
}

# InvokeAI 安装路径设置
invokeai_custom_install_path_setting() {
    local custom_install_path
    local dialog_arg
    local path_info
    local install_path

    while true; do
        if [[ -f "${START_PATH}/term-sd/config/invokeai-path.conf" ]];then
            path_info=$(cat "${START_PATH}/term-sd/config/invokeai-path.conf")
            install_path=$path_info
        else
            path_info="默认"
            unset install_path
        fi

        dialog_arg=$(dialog --erase-on-exit --notags \
            --title "Term-SD" \
            --backtitle "InvokeAI 安装路径设置界面" \
            --ok-label "确认" --cancel-label "取消" \
            --menu "请选择配置选项\n当前自定义安装路径: ${path_info}" \
            $(get_dialog_size_menu) \
            "0" "> 返回" \
            "1" "> 设置安装路径" \
            "2" "> 恢复默认安装路径设置" \
            3>&1 1>&2 2>&3)

        case "${dialog_arg}" in
            1)
                custom_install_path=$(dialog --erase-on-exit \
                    --title "Term-SD" \
                    --backtitle "InvokeAI 安装路径设置界面" \
                    --ok-label "确认" --cancel-label "取消" \
                    --inputbox "请输入 InvokeAI 安装路径\n注: 请使用绝对路径" \
                    $(get_dialog_size) \
                    "${install_path}" \
                    3>&1 1>&2 2>&3)

                if [[ "$?" == 0 ]] && [[ ! -z "${custom_install_path}" ]]; then
                    if [[ "${custom_install_path}" == "/" ]]; then
                        dialog --erase-on-exit \
                            --title "Term-SD" \
                            --backtitle "InvokeAI 安装路径设置界面" \
                            --ok-label "确认" \
                            --msgbox "禁止将根目录设置为安装路径" \
                            $(get_dialog_size)

                    elif [[ "${custom_install_path}" == "${SD_WEBUI_ROOT_PATH}" ]] \
                        || [[ "${custom_install_path}" == "${COMFYUI_ROOT_PATH}" ]] \
                        || [[ "${custom_install_path}" == "${FOOOCUS_ROOT_PATH}" ]] \
                        || [[ "${custom_install_path}" == "${LORA_SCRIPTS_ROOT_PATH}" ]] \
                        || [[ "${custom_install_path}" == "${KOHYA_SS_ROOT_PATH}" ]]; then

                        dialog --erase-on-exit \
                            --title "Term-SD" \
                            --backtitle "InvokeAI 安装路径设置界面" \
                            --ok-label "确认" \
                            --msgbox "安装路径和其他AI软件的安装目录相同, 请重新设置" \
                            $(get_dialog_size)

                    else
                        INVOKEAI_ROOT_PATH=$custom_install_path
                        INVOKEAI_FOLDER=$(basename "${INVOKEAI_ROOT_PATH}")
                        INVOKEAI_PARENT_PATH=$(dirname "${INVOKEAI_ROOT_PATH}")
                        echo "${custom_install_path}" > "${START_PATH}/term-sd/config/invokeai-path.conf"

                        dialog --erase-on-exit \
                            --title "Term-SD" \
                            --backtitle "InvokeAI 安装路径设置界面" \
                            --ok-label "确认" \
                            --msgbox "InvokeAI 安装路径设置成功\n安装路径: ${custom_install_path}\n$(custom_install_path_is_rel_path_warning "${custom_install_path}")" \
                            $(get_dialog_size)
                    fi
                fi
                ;;
            2)
                if (dialog --erase-on-exit \
                    --title "Term-SD" \
                    --backtitle "InvokeAI 安装路径设置界面" \
                    --yes-label "是" --no-label "否" \
                    --yesno "是否重置 InvokeAI 安装路径 ?" \
                    $(get_dialog_size)); then

                    rm -f "${START_PATH}/term-sd/config/invokeai-path.conf"
                    INVOKEAI_ROOT_PATH="${START_PATH}/InvokeAI"
                    INVOKEAI_FOLDER="InvokeAI"
                    INVOKEAI_PARENT_PATH=$START_PATH

                    dialog --erase-on-exit \
                        --title "Term-SD" \
                        --backtitle "InvokeAI 安装路径设置界面" \
                        --ok-label "确认" \
                        --msgbox "重置 InvokeAI 安装路径成功" \
                        $(get_dialog_size)
                fi
                ;;
            *)
                break
                ;;
        esac
    done
}

# Fooocus 安装路径设置
fooocus_custom_install_path_setting() {
    local custom_install_path
    local dialog_arg
    local path_info
    local install_path

    while true; do
        if [[ -f "${START_PATH}/term-sd/config/fooocus-path.conf" ]];then
            path_info=$(cat "${START_PATH}/term-sd/config/fooocus-path.conf")
            install_path=$path_info
        else
            path_info="默认"
            unset install_path
        fi

        dialog_arg=$(dialog --erase-on-exit --notags \
            --title "Term-SD" \
            --backtitle "Fooocus 安装路径设置界面" \
            --ok-label "确认" --cancel-label "取消" \
            --menu "请选择配置选项\n当前自定义安装路径: ${path_info}" \
            $(get_dialog_size_menu) \
            "0" "> 返回" \
            "1" "> 设置安装路径" \
            "2" "> 恢复默认安装路径设置" \
            3>&1 1>&2 2>&3)

        case "${dialog_arg}" in
            1)
                custom_install_path=$(dialog --erase-on-exit \
                    --title "Term-SD" \
                    --backtitle "Fooocus 安装路径设置界面" \
                    --ok-label "确认" --cancel-label "取消" \
                    --inputbox "请输入 Fooocus 安装路径\n注: 请使用绝对路径" \
                    $(get_dialog_size) \
                    "${install_path}" \
                    3>&1 1>&2 2>&3)

                if [[ "$?" == 0 ]] && [[ ! -z "${custom_install_path}" ]]; then
                    if [[ "${custom_install_path}" == "/" ]]; then
                        dialog --erase-on-exit \
                            --title "Term-SD" \
                            --backtitle "Fooocus 安装路径设置界面" \
                            --ok-label "确认" \
                            --msgbox "禁止将根目录设置为安装路径" \
                            $(get_dialog_size)

                    elif [[ "${custom_install_path}" == "${SD_WEBUI_ROOT_PATH}" ]] \
                        || [[ "${custom_install_path}" == "${COMFYUI_ROOT_PATH}" ]] \
                        || [[ "${custom_install_path}" == "${INVOKEAI_ROOT_PATH}" ]] \
                        || [[ "${custom_install_path}" == "${LORA_SCRIPTS_ROOT_PATH}" ]] \
                        || [[ "${custom_install_path}" == "${KOHYA_SS_ROOT_PATH}" ]]; then

                        dialog --erase-on-exit \
                            --title "Term-SD" \
                            --backtitle "Fooocus 安装路径设置界面" \
                            --ok-label "确认" \
                            --msgbox "安装路径和其他 AI 软件的安装目录相同, 请重新设置" \
                            $(get_dialog_size)

                    else
                        FOOOCUS_ROOT_PATH=$custom_install_path
                        FOOOCUS_FOLDER=$(basename "${FOOOCUS_ROOT_PATH}")
                        FOOOCUS_PARENT_PATH=$(dirname "${FOOOCUS_ROOT_PATH}")
                        echo "${custom_install_path}" > "${START_PATH}/term-sd/config/fooocus-path.conf"

                        dialog --erase-on-exit \
                            --title "Term-SD" \
                            --backtitle "Fooocus 安装路径设置界面" \
                            --ok-label "确认" \
                            --msgbox "Fooocus 安装路径设置成功\n安装路径: ${custom_install_path}\n$(custom_install_path_is_rel_path_warning "${custom_install_path}")" \
                            $(get_dialog_size)
                    fi
                fi
                ;;
            2)
                if (dialog --erase-on-exit \
                --title "Term-SD" \
                --backtitle "Fooocus 安装路径设置界面" \
                --yes-label "是" --no-label "否" \
                --yesno "是否重置 Fooocus 安装路径 ?" \
                $(get_dialog_size)); then

                    rm -f "${START_PATH}/term-sd/config/fooocus-path.conf"
                    FOOOCUS_ROOT_PATH="${START_PATH}/Fooocus"
                    FOOOCUS_FOLDER="Fooocus"
                    FOOOCUS_PARENT_PATH=$START_PATH

                    dialog --erase-on-exit \
                        --title "Term-SD" \
                        --backtitle "Fooocus 安装路径设置界面" \
                        --ok-label "确认" \
                        --msgbox "重置 Fooocus 安装路径成功" \
                        $(get_dialog_size)
                fi
                ;;
            *)
                break
                ;;
        esac
    done
}

# lora-scripts 安装路径设置
lora_scripts_custom_install_path_setting() {
    local custom_install_path
    local dialog_arg
    local path_info
    local install_path

    while true; do
        if [[ -f "${START_PATH}/term-sd/config/lora-scripts-path.conf" ]];then
            path_info=$(cat "${START_PATH}/term-sd/config/lora-scripts-path.conf")
            install_path=$path_info
        else
            path_info="默认"
            unset install_path
        fi

        dialog_arg=$(dialog --erase-on-exit --notags \
            --title "Term-SD" \
            --backtitle "lora-scripts 安装路径设置界面" \
            --ok-label "确认" --cancel-label "取消" \
            --menu "请选择配置选项\n当前自定义安装路径: ${path_info}" \
            $(get_dialog_size_menu) \
            "0" "> 返回" \
            "1" "> 设置安装路径" \
            "2" "> 恢复默认安装路径设置" \
            3>&1 1>&2 2>&3)

        case "${dialog_arg}" in
            1)
                custom_install_path=$(dialog --erase-on-exit \
                    --title "Term-SD" \
                    --backtitle "lora-scripts 安装路径设置界面" \
                    --ok-label "确认" --cancel-label "取消" \
                    --inputbox "请输入 lora-scripts 安装路径\n注: 请使用绝对路径" \
                    $(get_dialog_size) \
                    "${install_path}" \
                    3>&1 1>&2 2>&3)

                if [[ "$?" == 0 ]] && [[ ! -z "${custom_install_path}" ]]; then
                    if [[ "${custom_install_path}" == "/" ]]; then
                        dialog --erase-on-exit \
                            --title "Term-SD" \
                            --backtitle "lora-scripts 安装路径设置界面" \
                            --ok-label "确认" \
                            --msgbox "禁止将根目录设置为安装路径" \
                            $(get_dialog_size)

                    elif [[ "${custom_install_path}" == "${SD_WEBUI_ROOT_PATH}" ]] \
                        || [[ "${custom_install_path}" == "${COMFYUI_ROOT_PATH}" ]] \
                        || [[ "${custom_install_path}" == "${INVOKEAI_ROOT_PATH}" ]] \
                        || [[ "${custom_install_path}" == "${FOOOCUS_ROOT_PATH}" ]] \
                        || [[ "${custom_install_path}" == "${KOHYA_SS_ROOT_PATH}" ]]; then

                        dialog --erase-on-exit \
                            --title "Term-SD" \
                            --backtitle "lora-scripts 安装路径设置界面" \
                            --ok-label "确认" \
                            --msgbox "安装路径和其他 AI 软件的安装目录相同, 请重新设置" \
                            $(get_dialog_size)

                    else
                        LORA_SCRIPTS_ROOT_PATH=$custom_install_path
                        LORA_SCRIPTS_FOLDER=$(basename "${LORA_SCRIPTS_ROOT_PATH}")
                        LORA_SCRIPTS_PARENT_PATH=$(dirname "${LORA_SCRIPTS_ROOT_PATH}")
                        echo "${custom_install_path}" > "${START_PATH}/term-sd/config/lora-scripts-path.conf"

                        dialog --erase-on-exit \
                            --title "Term-SD" \
                            --backtitle "lora-scripts 安装路径设置界面" \
                            --ok-label "确认" \
                            --msgbox "lora-scripts 安装路径设置成功\n安装路径: ${custom_install_path}\n$(custom_install_path_is_rel_path_warning "${custom_install_path}")" \
                            $(get_dialog_size)
                    fi
                fi
                ;;
            2)
                if (dialog --erase-on-exit \
                    --title "Term-SD" \
                    --backtitle "lora-scripts 安装路径设置界面" \
                    --yes-label "是" --no-label "否" \
                    --yesno "是否重置 lora-scripts 安装路径 ?" \
                    $(get_dialog_size)); then

                    rm -f "${START_PATH}/term-sd/config/lora-scripts-path.conf"
                    LORA_SCRIPTS_ROOT_PATH="${START_PATH}/lora-scripts"
                    LORA_SCRIPTS_FOLDER="lora-scripts"
                    LORA_SCRIPTS_PARENT_PATH=$START_PATH

                    dialog --erase-on-exit \
                        --title "Term-SD" \
                        --backtitle "lora-scripts 安装路径设置界面" \
                        --ok-label "确认" \
                        --msgbox "重置 lora-scripts 安装路径成功" \
                        $(get_dialog_size)
                fi
                ;;
            *)
                break
                ;;
        esac
    done
}

# kohya_ss安装路径设置
kohya_ss_custom_install_path_setting() {
    local custom_install_path
    local dialog_arg
    local path_info
    local install_path

    while true; do
        if [[ -f "${START_PATH}/term-sd/config/lora-scripts-path.conf" ]];then
            path_info=$(cat "${START_PATH}/term-sd/config/lora-scripts-path.conf")
            install_path=$path_info
        else
            path_info="默认"
            unset install_path
        fi

        dialog_arg=$(dialog --erase-on-exit --notags \
            --title "Term-SD" \
            --backtitle "kohya_ss 安装路径设置界面" \
            --ok-label "确认" --cancel-label "取消" \
            --menu "请选择配置选项\n当前自定义安装路径: ${path_info}" \
            $(get_dialog_size_menu) \
            "0" "> 返回" \
            "1" "> 设置安装路径" \
            "2" "> 恢复默认安装路径设置" \
            3>&1 1>&2 2>&3)

        case "${dialog_arg}" in
            1)
                custom_install_path=$(dialog --erase-on-exit \
                    --title "Term-SD" \
                    --backtitle "kohya_ss 安装路径设置界面" \
                    --ok-label "确认" --cancel-label "取消" \
                    --inputbox "请输入 kohya_ss 安装路径\n注: 请使用绝对路径" \
                    $(get_dialog_size) \
                    "${install_path}" \
                    3>&1 1>&2 2>&3)

                if [[ "$?" == 0 ]] && [[ ! -z "${custom_install_path}" ]]; then
                    if [[ "${custom_install_path}" == "/" ]]; then
                        dialog --erase-on-exit \
                            --title "Term-SD" \
                            --backtitle "kohya_ss 安装路径设置界面" \
                            --ok-label "确认" \
                            --msgbox "禁止将根目录设置为安装路径" \
                            $(get_dialog_size)

                    elif [[ "${custom_install_path}" == "${SD_WEBUI_ROOT_PATH}" ]] \
                        || [[ "${custom_install_path}" == "${COMFYUI_ROOT_PATH}" ]] \
                        || [[ "${custom_install_path}" == "${INVOKEAI_ROOT_PATH}" ]] \
                        || [[ "${custom_install_path}" == "${FOOOCUS_ROOT_PATH}" ]] \
                        || [[ "${custom_install_path}" == "${LORA_SCRIPTS_ROOT_PATH}" ]]; then

                        dialog --erase-on-exit \
                            --title "Term-SD" \
                            --backtitle "kohya_ss 安装路径设置界面" \
                            --ok-label "确认" \
                            --msgbox "安装路径和其他AI软件的安装目录相同, 请重新设置" \
                            $(get_dialog_size)

                    else
                        KOHYA_SS_ROOT_PATH=$custom_install_path
                        KOHYA_SS_FOLDER=$(basename "${KOHYA_SS_ROOT_PATH}")
                        KOHYA_SS_PARENT_PATH=$(dirname "${KOHYA_SS_ROOT_PATH}")
                        echo "${custom_install_path}" > "${START_PATH}/term-sd/config/kohya_ss-path.conf"

                        dialog --erase-on-exit \
                            --title "Term-SD" \
                            --backtitle "kohya_ss 安装路径设置界面" \
                            --ok-label "确认" \
                            --msgbox "kohya_ss 安装路径设置成功\n安装路径: ${custom_install_path}\n$(custom_install_path_is_rel_path_warning "${custom_install_path}")" \
                            $(get_dialog_size)
                    fi
                fi
                ;;
            2)
                if (dialog --erase-on-exit \
                    --title "Term-SD" \
                    --backtitle "kohya_ss 安装路径设置界面" \
                    --yes-label "是" --no-label "否" \
                    --yesno "是否重置 kohya_ss 安装路径 ?" \
                    $(get_dialog_size)); then

                    rm -f "${START_PATH}/term-sd/config/kohya_ss-path.conf"
                    KOHYA_SS_ROOT_PATH="${START_PATH}/kohya_ss"
                    KOHYA_SS_FOLDER="kohya_ss"
                    KOHYA_SS_PARENT_PATH=$START_PATH

                    dialog --erase-on-exit \
                        --title "Term-SD" \
                        --backtitle "kohya_ss 安装路径设置界面" \
                        --ok-label "确认" \
                        --msgbox "重置 kohya_ss 安装路径成功" \
                        $(get_dialog_size)
                fi
                ;;
            *)
                break
                ;;
        esac
    done
}

# 检测是否为相对路径, 是相对路径则返回0, 不是则返回1
term_sd_is_rel_path() {
    if [[ ! "$(echo $@ | awk '{print substr($0,1,1)}')" == "/" ]]; then
        # 路径不是 "/"" 开头
        if is_windows_platform; then
            return 1
        else
            return 0
        fi
    else
        return 1
    fi
}

# 输入的自定义安装路径为相对路径时返回警告信息
custom_install_path_is_rel_path_warning() {
    if term_sd_is_rel_path "$@"; then
        echo "检测到安装路径不是绝对路径, 可能会导致一些问题, 建议将安装路径修改为绝对路径"
    fi
}