#!/bin/bash

# 启动ai软件
term_sd_launch()
{
    term_sd_print_line "$term_sd_manager_info 启动"
    term_sd_echo "提示:可以使用\"Ctrl+C\"终止ai软件的运行"
    enter_venv
    term_sd_python $(cat ./term-sd-launch.conf)
    term_sd_pause
}

# 进程监测
term_sd_watch()
{
    if [ $term_sd_cmd_retry = 0 ];then
        "$@" # 执行输入的命令
    else
        count=0
        while (( $count <= $term_sd_cmd_retry ));do  
            count=$(( $count + 1 ))
            "$@" # 执行输入的命令
            if [ $? = 0 ];then
                break # 运行成功并中断循环
            else
                if [ $count -gt $term_sd_cmd_retry ];then
                    term_sd_echo "超出重试次数,终止重试"
                    term_sd_echo "执行失败的命令:\"$@\""
                    return 1
                    break # 超出重试次数后终端循环
                fi
                term_sd_echo "[$count/$term_sd_cmd_retry]命令执行失败,重试中"
            fi
        done
    fi
}

# aria2下载工具
# 使用格式: aria2_download <下载链接> <下载路径> <文件名>
aria2_download()
{
    local model_url=$1
    local local_file_path="${2}/${3}"
    local local_aria_cache_path="${2}/${3}.aria2"

    if [ ! -f "$local_file_path" ];then
        term_sd_echo "下载$(echo ${3} | awk -F '/' '{print$NF}')中"
        term_sd_watch aria2c $aria2_multi_threaded $model_url -d ${2} -o ${3}
    else
        if [ -f "$local_aria_cache_path" ];then
            term_sd_echo "恢复下载$(echo ${3} | awk -F '/' '{print$NF}')中"
            term_sd_watch aria2c $aria2_multi_threaded $model_url -d ${2} -o ${3}
        else
            term_sd_echo "$(echo ${3} | awk -F '/' '{print$NF}')文件已存在,跳过下载该文件"
        fi
    fi
}

# 显示版本信息
term_sd_version()
{
    term_sd_echo "统计版本信息中"
    dialog --erase-on-exit --title "Term-SD" --backtitle "Term-SD开始界面" --ok-label "确认" --msgbox "版本信息:\n\n
系统: $([ ! -z $OS ] && [ $OS = "Windows_NT" ] && echo Windows || uname -o)\n
Term-SD: $term_sd_version_info\n
python:$(term_sd_python --version | awk 'NR==1'| awk -F  ' ' ' {print  " " $2} ')\n
pip:$(term_sd_pip --version | awk 'NR==1'| awk -F  ' ' ' {print  " " $2} ')\n
aria2:$(aria2c --version | awk 'NR==1'| awk -F  ' ' ' {print  " " $3} ')\n
git:$(git --version | awk 'NR==1'| awk -F  ' ' ' {print  " " $3} ')\n
dialog:$(dialog --version | awk 'NR==1'| awk -F  ' ' ' {print  " " $2} ')\n
\n
提示:\n
使用方向键、Tab键移动光标,方向键翻页(鼠标滚轮无法翻页),Enter进行选择,Space键勾选或取消勾选,(已勾选时显示[*]),Ctrl+Shift+V粘贴文本,Ctrl+C可中断指令的运行,鼠标左键可点击按钮(右键无效)\n
第一次使用Term-SD时先在主界面选择“帮助”查看使用说明,参数说明和注意的地方,内容不定期更新" $term_sd_dialog_height $term_sd_dialog_width
}

#主界面
term_sd_manager()
{
    local term_sd_manager_dialog
    export term_sd_manager_info=
    cd "$start_path" # 回到最初路径
    exit_venv # 确保进行下一步操作前已退出其他虚拟环境

    term_sd_manager_dialog=$(
        dialog --erase-on-exit --notags --title "Term-SD" --backtitle "主界面" --ok-label "确认" --cancel-label "取消" --menu "请选择Term-SD的功能\n当前虚拟环境状态:$([ $venv_setup_status = 0 ] && echo "启用" || echo "禁用")\n当前代理设置:$([ -z $http_proxy ] && echo "无" || echo $http_proxy)" $term_sd_dialog_height $term_sd_dialog_width $term_sd_dialog_menu_height \
        "0" "> Term-SD更新管理" \
        "1" "> AUTOMATIC1111-stable-diffusion-webui管理" \
        "2" "> ComfyUI管理" \
        "3" "> InvokeAI管理" \
        "4" "> Fooocus管理" \
        "5" "> lora-scripts管理" \
        "6" "> kohya_ss管理" \
        "7" "> 设置" \
        "8" "> 帮助" \
        "9" "> 退出" \
        3>&1 1>&2 2>&3 )

    case $term_sd_manager_dialog in
        0) # 选择Term-SD更新
            term_sd_update_manager
            ;;
        1) # 选择stable-diffusion-webui
            term_sd_install_task_manager stable-diffusion-webui
            ;;
        2) # 选择ComfyUI
            term_sd_install_task_manager ComfyUI
            ;;
        3) # 选择InvokeAI
            term_sd_install_task_manager InvokeAI
            ;;
        4) # 选择fooocus
            term_sd_install_task_manager Fooocus
            ;;
        5) # 选择lora-scripts
            term_sd_install_task_manager lora-scripts
            ;;
        6) # 选择kohya_ss
            term_sd_install_task_manager kohya_ss
            ;;
        7) # 选择设置
            term_sd_setting
            ;;
        8) # 选择帮助
            term_sd_help
            ;;
        *) # 选择退出
            term_sd_print_line
            term_sd_echo "退出Term-SD"
            exit 1
            ;;
    esac
}

# 帮助列表
term_sd_help()
{
    local term_sd_help_dialog

    term_sd_help_dialog=$(
        dialog --erase-on-exit --notags --title "Term-SD" --backtitle "Term-SD帮助选项" --ok-label "确认" --cancel-label "取消" --menu "请选择帮助" $term_sd_dialog_height $term_sd_dialog_width $term_sd_dialog_menu_height \
        "0" "> 返回" \
        "1" "> 关于Term-SD" \
        "2" "> Term-SD使用方法" \
        "3" "> Term-SD注意事项" \
        "4" "> 目录说明" \
        "5" "> Stable-Diffusion-WebUI插件说明" \
        "6" "> ComfyUI插件/自定义节点说明" \
        3>&1 1>&2 2>&3)

    case $term_sd_help_dialog in
        1)
            dialog --erase-on-exit --title "Term-SD" --backtitle "Term-SD帮助选项" --ok-label "确认" --msgbox "$(cat ./term-sd/help/about.md)" $term_sd_dialog_height $term_sd_dialog_width
            term_sd_help
            ;;
        2)
            dialog --erase-on-exit --title "Term-SD" --backtitle "Term-SD帮助选项" --ok-label "确认" --msgbox "$(cat ./term-sd/help/how_to_use_term_sd.md)" $term_sd_dialog_height $term_sd_dialog_width
            term_sd_help
            ;;
        3)
            dialog --erase-on-exit --title "Term-SD" --backtitle "Term-SD帮助选项" --ok-label "确认" --msgbox "$(cat ./term-sd/help/term_sd_note.md)" $term_sd_dialog_height $term_sd_dialog_width
            term_sd_help
            ;;
        4)
            dialog --erase-on-exit --title "Term-SD" --backtitle "Term-SD帮助选项" --ok-label "确认" --msgbox "$(cat ./term-sd/help/directory_description.md)" $term_sd_dialog_height $term_sd_dialog_width
            term_sd_help
            ;;
        5)
            dialog --erase-on-exit --title "Term-SD" --backtitle "Term-SD帮助选项" --ok-label "确认" --msgbox "$(cat ./term-sd/help/sd_webui_extension_description.md)" $term_sd_dialog_height $term_sd_dialog_width
            term_sd_help
            ;;
        6)
            dialog --erase-on-exit --title "Term-SD" --backtitle "Term-SD帮助选项" --ok-label "确认" --msgbox "$(cat ./term-sd/help/comfyui_extension_description.md)" $term_sd_dialog_height $term_sd_dialog_width
            term_sd_help
            ;;
    esac
}
