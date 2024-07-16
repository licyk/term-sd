#!/bin/bash

# 加载模块
. "${START_PATH}"/term-sd/modules/term_sd_manager.sh
. "${START_PATH}"/term-sd/modules/term_sd_task_manager.sh
. "${START_PATH}"/term-sd/modules/get_modelscope_model.sh
. "${START_PATH}"/term-sd/modules/install_prepare.sh
. "${START_PATH}"/term-sd/modules/term_sd_proxy.sh
. "${START_PATH}"/term-sd/modules/term_sd_try.sh

# ai软件选择
sd_model_download_select() {
    local dialog_arg
    local file_manager_select

    while true; do
        dialog_arg=$(dialog --erase-on-exit --notags \
            --title "Term-SD" \
            --backtitle "Term-SD 模型下载" \
            --ok-label "确认" --cancel-label "取消" \
            --menu "请选择需要下载模型的 AI 软件" \
            $(get_dialog_size_menu) \
            "1" "> Stable-Diffusion-WebUI" \
            "2" "> ComfyUI" \
            "3" "> InvokeAI" \
            "4" "> Fooocus" \
            "5" "> lora-scripts" \
            "6" "> kohya_ss" \
            "7" "> 退出" \
            3>&1 1>&2 2>&3)

        case "${dialog_arg}" in
            1)
                file_manager_select="stable-diffusion-webui"
                ;;
            2)
                file_manager_select="ComfyUI"
                ;;
            3)
                file_manager_select="InvokeAI"
                ;;
            4)
                file_manager_select="Fooocus"
                ;;
            5)
                file_manager_select="lora-scripts"
                ;;
            6)
                file_manager_select="kohya_ss"
                ;;
            7)  
                break
                ;;
            *)
                break
                ;;
        esac
        if is_sd_folder_exist "${file_manager_select}"; then
            model_download_interface "${file_manager_select}"
            break
        else
            dialog --erase-on-exit \
                --title "Term-SD" \
                --backtitle "Term-SD 模型下载" \
                --ok-label "确认" \
                --msgbox "${file_manager_select} 未安装" \
                $(get_dialog_size)
        fi
    done
}

# 模型选择和下载
model_download_interface() {
    local dialog_arg
    local cmd_sum
    local cmd_point
    local install_cmd
    local name=$@

    download_mirror_select # 下载镜像源选择

    dialog_arg=$(dialog --erase-on-exit --notags \
        --title "Term-SD" \
        --backtitle "${name} 模型下载选项" \
        --ok-label "确认" --no-cancel \
        --checklist "请选择需要下载的 ${name} 模型" \
        $(get_dialog_size_menu) \
        $(cat "${START_PATH}"/term-sd/install/$(get_model_list_file_path ${name} dialog) | awk '{sub($3,"OFF")}1') \
        3>&1 1>&2 2>&3)

    if term_sd_install_confirm "是否下载 ${name} 模型 ?"; then
        term_sd_echo "生成任务队列"
        rm -f "${START_PATH}/term-sd/task/model_download.sh" # 删除上次未清除的任务列表

        # 代理
        if is_use_modelscope_src; then
            echo "__term_sd_task_sys term_sd_tmp_disable_proxy" >> "${START_PATH}/term-sd/task/model_download.sh"
        fi
        # 模型
        for i in ${dialog_arg}; do
            cat "${START_PATH}"/term-sd/install/"$(get_model_list_file_path ${name})" | grep -w ${i} >> "${START_PATH}/term-sd/task/model_download.sh"
        done

        term_sd_echo "任务队列生成完成"
        term_sd_echo "开始下载 ${name} 模型"

        cmd_sum=$(cat "${START_PATH}/term-sd/task/model_download.sh" | wc -l)
        for (( cmd_point=1; cmd_point<=cmd_sum; cmd_point++ )); do
            term_sd_echo "${name} 模型下载进度: [${cmd_point}/${cmd_sum}]"

            term_sd_exec_cmd "${START_PATH}/term-sd/task/model_download.sh" "${cmd_point}"
        done

        rm -f "${START_PATH}/term-sd/task/model_download.sh" # 删除任务文件
        term_sd_echo "${name} 模型下载结束"

    else
        term_sd_echo "取消下载模型"
    fi
}

# 获取模型列表路径
get_model_list_file_path() {
    local sd_name
    local download_source_name
    local name=$1
    local type=$2

    case ${name} in
        stable-diffusion-webui)
            sd_name="sd_webui"
            ;;
        ComfyUI)
            sd_name="comfyui"
            ;;
        InvokeAI)
            sd_name="invokeai"
            ;;
        Fooocus)
            sd_name="fooocus"
            ;;
        lora-scripts)
            sd_name="lora_scripts"
            ;;
        kohya_ss)
            sd_name="kohya_ss"
            ;;
    esac

    if is_use_modelscope_src; then
        download_source_name="ms"
    else
        download_source_name="hf"
    fi

    if [[ "${type}" == "dialog" ]]; then
        echo "${sd_name}/dialog_${sd_name}_${download_source_name}_model.sh"
    else
        echo "${sd_name}/${sd_name}_${download_source_name}_model.sh"
    fi
}

# 检测文件夹存在
is_sd_folder_exist() {
    case $@ in
        stable-diffusion-webui)
            [[ -d "${SD_WEBUI_PATH}" ]] && return 0 || return 1
            ;;
        ComfyUI)
            [[ -d "${COMFYUI_PATH}" ]] && return 0 || return 1
            ;;
        InvokeAI)
            [[ -d "${INVOKEAI_PATH}" ]] && return 0 || return 1
            ;;
        Fooocus)
            [[ -d "${FOOOCUS_PATH}" ]] && return 0 || return 1
            ;;
        lora-scripts)
            [[ -d "${LORA_SCRIPTS_PATH}" ]] && return 0 || return 1
            ;;
        kohya_ss)
            [[ -d "${KOHYA_SS_PATH}" ]] && return 0 || return 1
            ;;
    esac
}


#############################

sd_model_download_select