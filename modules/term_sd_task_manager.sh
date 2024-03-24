#!/bin/bash

# 安装任务管理
# 命令后面需加上ai软件名称
term_sd_install_task_manager()
{
    local term_sd_install_task_manager_dialog
    local term_sd_install_task_file_path
    local term_sd_install_exec_cmd
    local term_sd_manager_exec_cmd
    local term_sd_install_task_info

    case $@ in
        stable-diffusion-webui)
            term_sd_install_task_file_path="$start_path/term-sd/task/sd_webui_install.sh"
            term_sd_install_exec_cmd="install_sd_webui"
            term_sd_manager_exec_cmd="sd_webui_manager"
            term_sd_install_task_info="Stable-Diffusion-WebUI"
            ;;
        ComfyUI)
            term_sd_install_task_file_path="$start_path/term-sd/task/comfyui_install.sh"
            term_sd_install_exec_cmd="install_comfyui"
            term_sd_manager_exec_cmd="comfyui_manager"
            term_sd_install_task_info="ComfyUI"
            ;;
        InvokeAI)
            term_sd_install_task_file_path="$start_path/term-sd/task/invokeai_install.sh"
            term_sd_install_exec_cmd="install_invokeai"
            term_sd_manager_exec_cmd="invokeai_manager"
            term_sd_install_task_info="InvokeAI"
            ;;
        Fooocus)
            term_sd_install_task_file_path="$start_path/term-sd/task/fooocus_install.sh"
            term_sd_install_exec_cmd="install_fooocus"
            term_sd_manager_exec_cmd="fooocus_manager"
            term_sd_install_task_info="Fooocus"
            ;;
        lora-scripts)
            term_sd_install_task_file_path="$start_path/term-sd/task/lora_scripts_install.sh"
            term_sd_install_exec_cmd="install_lora_scripts"
            term_sd_manager_exec_cmd="lora_scripts_manager"
            term_sd_install_task_info="lora-scripts"
            ;;
        kohya_ss)
            term_sd_install_task_file_path="$start_path/term-sd/task/kohya_ss_install.sh"
            term_sd_install_exec_cmd="install_kohya_ss"
            term_sd_manager_exec_cmd="kohya_ss_manager"
            term_sd_install_task_info="kohya_ss"
            ;;
    esac

    if [ -f "$term_sd_install_task_file_path" ];then
        term_sd_install_task_manager_dialog=$(dialog --erase-on-exit --notags \
            --title "Term-SD" \
            --backtitle "AI 软件安装提示界面" \
            --ok-label "确认" --cancel-label "取消" \
            --menu "检测到 ${term_sd_install_task_info} 有未完成的安装任务, 是否继续进行?" \
            $term_sd_dialog_height $term_sd_dialog_width $term_sd_dialog_menu_height \
            "0" "> 返回" \
            "1" "> 继续执行安装任务" \
            "2" "> 重新设置安装参数并进行安装" \
            "3" "> 删除安装任务并进入管理界面" \
            "4" "> 跳过安装任务并进入管理界面" \
            3>&1 1>&2 2>&3)

        case $term_sd_install_task_manager_dialog in
            1) # 寻找任务队列表并执行
                $term_sd_install_exec_cmd
                ;;
            2) # 删除原有的任务队列表并进入安装参数设置界面
                rm -f "$term_sd_install_task_file_path"
                $term_sd_install_exec_cmd
                ;;
            3) # 删除原有的任务队列表并进入管理界面
                rm -f "$term_sd_install_task_file_path"
                $term_sd_manager_exec_cmd
                ;;
            4) # 直接进入管理界面
                $term_sd_manager_exec_cmd
                ;;
        esac
    else
        $term_sd_manager_exec_cmd
    fi
}

# 安装任务命令队列格式处理(除去前面的标识)
term_sd_get_task_cmd()
{
    local task_cmd_sign
    local task_cmd
    task_cmd_sign=$(echo $@ | awk '{print $1}')
    task_cmd=$(echo $@ | awk '{sub("'$task_cmd_sign' ","")}1')
    echo $task_cmd
}

# 安装命令执行
# 用于执行"term-sd/task"下的"cache.sh"文件
# cache.sh为执行任务队列时产生
term_sd_exec_cmd()
{
    . "$start_path/term-sd/task/cache.sh"
}

# 安装任务命令标记修改(将未完成标记为已完成)
# 使用格式: term_sd_task_cmd_revise <文件路径> <指定行数>
term_sd_task_cmd_revise()
{
    sed -i ''$2's/__term_sd_task_pre_/__term_sd_task_done_/' $1 > /dev/null
}

# 设置安装时使用的环境变量
term_sd_set_install_env_value()
{
    echo "__term_sd_task_sys pip_index_mirror=\"$pip_index_mirror\""
    echo "__term_sd_task_sys pip_extra_index_mirror=\"$pip_extra_index_mirror\""
    echo "__term_sd_task_sys pip_find_mirror=\"$pip_find_mirror\""
    echo "__term_sd_task_sys pip_break_system_package=\"$pip_break_system_package\""
    echo "__term_sd_task_sys github_mirror=\"$github_mirror\""
    echo "__term_sd_task_sys pytorch_install_version=\"$pytorch_install_version\""
    echo "__term_sd_task_sys pip_install_mode=\"$pip_install_mode\""
    echo "__term_sd_task_sys term_sd_only_proxy=\"$term_sd_only_proxy\""
}

# 为安装命令列表添加空行
term_sd_add_blank_line()
{
    echo "" >> "$@"
}

# 在安装过程中检测ai软件是否下载下来,当检测到未下载下来时返回错误并终止,防止文件散落
is_sd_repo_exist()
{
    if [ ! -z "$@" ];then
        term_sd_echo "检测到核心未能成功下载, 为了防止接下来的安装操作产生的文件散落出来, Term-SD将终止安装进程"
        term_sd_echo "已终止安装进程"
        term_sd_echo "退出 Term-SD"
        exit 1
    else
        true
    fi
}