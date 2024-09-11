#!/bin/bash

# 安装任务管理
# 命令后面需加上 AI 软件名称
# 使用 TERM_SD_MANAGE_OBJECT 全局变量设置正在管理的 AI 软件名称
# 调用时将检测 <Start Path>/term-sd/task/ 中是否存在未完成的安装任务
# 如果存在, 则提示是否继续进行安装
# 如果不存在, 则进入管理界面
# 使用:
# term_sd_install_task_manager <AI 软件的名称>
# 可用名称: stable-diffusion-webui, ComfyUI, InvokeAI, Fooocus, lora-scripts, kohya_ss
# 对应的安装任务配置: sd_webui_install.sh, comfyui_install.sh, invokeai_install.sh, fooocus_install.sh, lora_scripts_install.sh, kohya_ss_install.sh
term_sd_install_task_manager() {
    local dialog_arg
    local install_task_file_path
    local install_exec_cmd
    local manager_exec_cmd
    local install_task_name

    case $@ in
        stable-diffusion-webui)
            install_task_file_path="${START_PATH}/term-sd/task/sd_webui_install.sh"
            install_exec_cmd="install_sd_webui"
            manager_exec_cmd="sd_webui_manager"
            install_task_name="Stable-Diffusion-WebUI"
            TERM_SD_MANAGE_OBJECT="stable-diffusion-webui"
            ;;
        ComfyUI)
            install_task_file_path="${START_PATH}/term-sd/task/comfyui_install.sh"
            install_exec_cmd="install_comfyui"
            manager_exec_cmd="comfyui_manager"
            install_task_name="ComfyUI"
            TERM_SD_MANAGE_OBJECT="ComfyUI"
            ;;
        InvokeAI)
            install_task_file_path="${START_PATH}/term-sd/task/invokeai_install.sh"
            install_exec_cmd="install_invokeai"
            manager_exec_cmd="invokeai_manager"
            install_task_name="InvokeAI"
            TERM_SD_MANAGE_OBJECT="InvokeAI"
            ;;
        Fooocus)
            install_task_file_path="${START_PATH}/term-sd/task/fooocus_install.sh"
            install_exec_cmd="install_fooocus"
            manager_exec_cmd="fooocus_manager"
            install_task_name="Fooocus"
            TERM_SD_MANAGE_OBJECT="Fooocus"
            ;;
        lora-scripts)
            install_task_file_path="${START_PATH}/term-sd/task/lora_scripts_install.sh"
            install_exec_cmd="install_lora_scripts"
            manager_exec_cmd="lora_scripts_manager"
            install_task_name="lora-scripts"
            TERM_SD_MANAGE_OBJECT="lora-scripts"
            ;;
        kohya_ss)
            install_task_file_path="${START_PATH}/term-sd/task/kohya_ss_install.sh"
            install_exec_cmd="install_kohya_ss"
            manager_exec_cmd="kohya_ss_manager"
            install_task_name="kohya_ss"
            TERM_SD_MANAGE_OBJECT="kohya_ss"
            ;;
    esac

    if [[ -f "${install_task_file_path}" ]]; then
        dialog_arg=$(dialog --erase-on-exit --notags \
            --title "Term-SD" \
            --backtitle "AI 软件安装提示界面" \
            --ok-label "确认" --cancel-label "取消" \
            --menu "检测到 ${install_task_name} 有未完成的安装任务, 是否继续进行 ?" \
            $(get_dialog_size_menu) \
            "0" "> 返回" \
            "1" "> 继续执行安装任务" \
            "2" "> 重新设置安装参数并进行安装" \
            "3" "> 删除安装任务并进入管理界面" \
            "4" "> 跳过安装任务并进入管理界面" \
            3>&1 1>&2 2>&3)

        case "${dialog_arg}" in
            1)
                # 寻找任务队列表并执行
                "${install_exec_cmd}"
                ;;
            2)
                # 删除原有的任务队列表并进入安装参数设置界面
                rm -f "${install_task_file_path}"
                "${install_exec_cmd}"
                ;;
            3)
                # 删除原有的任务队列表并进入管理界面
                rm -f "${install_task_file_path}"
                "${manager_exec_cmd}"
                ;;
            4)
                # 直接进入管理界面
                "${manager_exec_cmd}"
                ;;
        esac
    else
        "${manager_exec_cmd}"
    fi

    unset TERM_SD_MANAGE_OBJECT
}

# 安装任务命令队列格式处理(除去前面的标识)
term_sd_get_task_cmd() {
    local task_cmd_sign
    local task_cmd
    task_cmd_sign=$(echo $@ | awk '{print $1}')
    task_cmd=$(echo $@ | awk '{sub("'${task_cmd_sign}' ","")}1')
    echo "${task_cmd}"
}

# 安装命令执行
# 使用:
# term_sd_exec_cmd <命令文件> <指定行数>
term_sd_exec_cmd() {
    local cmd_file=$1
    local cmd_point=$2
    local install_cmd
    local exec_req

    install_cmd=$(term_sd_get_task_cmd $(cat "${cmd_file}" | awk 'NR=='${cmd_point}' {print $0}'))

    if [ -z "$(cat "$cmd_file" | awk 'NR=='${cmd_point}' {print $1}' | grep -o __term_sd_task_done_ )" ]; then # 检测命令是否需要执行
        term_sd_is_debug && term_sd_echo "执行命令: \"${install_cmd}\""
        eval "${install_cmd}" # 执行命令
    else
        term_sd_is_debug && term_sd_echo "跳过执行命令: \"${install_cmd}\""
        true
    fi

    exec_req=$?

    if [[ "${exec_req}" == 0 ]]; then # 检测命令是否执行成功
        term_sd_task_cmd_revise "${cmd_file}" ${cmd_point} # 将执行成功的命令标记为完成
    fi

    return $exec_req
}

# 安装任务命令标记修改(将未完成标记为已完成)
# 使用格式: term_sd_task_cmd_revise <文件路径> <指定行数>
term_sd_task_cmd_revise() {
    sed -i ''$2's/__term_sd_task_pre_/__term_sd_task_done_/' "$1" > /dev/null
}

# 设置安装时使用的环境变量
# 变量来源于 modules/install_prepare.sh
term_sd_set_install_env_value() {
    cat<<EOF
__term_sd_task_sys PIP_INDEX_MIRROR="${PIP_INDEX_MIRROR}"
__term_sd_task_sys PIP_EXTRA_INDEX_MIRROR="${PIP_EXTRA_INDEX_MIRROR}"
__term_sd_task_sys PIP_FIND_LINKS_MIRROR="${PIP_FIND_LINKS_MIRROR}"
__term_sd_task_sys USE_PIP_MIRROR=${USE_PIP_MIRROR}
__term_sd_task_sys PIP_BREAK_SYSTEM_PACKAGE_ARG="${PIP_BREAK_SYSTEM_PACKAGE_ARG}"
__term_sd_task_sys PIP_USE_PEP517_ARG="${PIP_USE_PEP517_ARG}"
__term_sd_task_sys PIP_FORCE_REINSTALL_ARG="${PIP_FORCE_REINSTALL_ARG}"
__term_sd_task_sys PIP_UPDATE_PACKAGE_ARG="${PIP_UPDATE_PACKAGE_ARG}"
__term_sd_task_sys PIP_PREFER_BINARY_ARG="${PIP_PREFER_BINARY_ARG}"
__term_sd_task_sys GITHUB_MIRROR="${GITHUB_MIRROR}"
__term_sd_task_sys INSTALL_PYTORCH_VERSION="${INSTALL_PYTORCH_VERSION}"
__term_sd_task_sys PYTORCH_TYPE="${PYTORCH_TYPE}"
__term_sd_task_sys TERM_SD_ENABLE_ONLY_PROXY=${TERM_SD_ENABLE_ONLY_PROXY}
__term_sd_task_sys USE_MODELSCOPE_MODEL_SRC=${USE_MODELSCOPE_MODEL_SRC}
EOF
}

# 为安装命令列表添加空行
term_sd_add_blank_line() {
    echo "" >> "$@"
}

# 在安装过程中检测ai软件是否下载下来,当检测到未下载下来时返回错误并终止,防止文件散落
is_sd_repo_exist() {
    if [[ ! -d "$@" ]]; then
        term_sd_echo "检测到核心未能成功下载, 为了防止接下来的安装操作产生的文件散落出来, Term-SD 将终止安装进程"
        term_sd_echo "已终止安装进程"
        term_sd_echo "退出 Term-SD"
        exit 1
    else
        true
    fi
}
