#!/bin/bash

# invokeai启动界面
invokeai_launch()
{
    invokeai_launch_dialog=$(
        dialog --erase-on-exit --title "InvokeAI管理" --backtitle "InvokeAI启动参数选项" --ok-label "确认" --cancel-label "取消" --menu "请选择InvokeAI启动参数" 25 80 10 \
        "1" "(invokeai-configure)启动配置界面" \
        "2" "(invokeai-web)启动webui界面" \
        "3" "(invokeai-web --host)启动webui界面" \
        "4" "(invokeai-ti --gui)启动模型训练界面" \
        "5" "(invokeai-merge --gui)启动模型合并界面" \
        "6" "返回" \
        3>&1 1>&2 2>&3)

    case $invokeai_launch_dialog in
        1)
            print_line_to_shell "$term_sd_manager_info 启动"
            invokeai-configure --root ./invokeai
            print_line_to_shell
            invokeai_launch
            ;;
        2)
            print_line_to_shell "$term_sd_manager_info 启动"
            term_sd_notice "提示:可以使用\"Ctrl+C\"终止ai软件的运行"
            invokeai-web --root ./invokeai
            term_sd_echo "运行结束"
            print_line_to_shell
            invokeai_launch
            ;;
        3)
            print_line_to_shell "$term_sd_manager_info 启动"
            term_sd_notice "提示:可以使用\"Ctrl+C\"终止ai软件的运行"
            invokeai-web --host 0.0.0.0 --root ./invokeai
            term_sd_echo "运行结束"
            print_line_to_shell
            invokeai_launch
            ;;
        4)
            print_line_to_shell "$term_sd_manager_info 启动"
            invokeai-ti --gui --root ./invokeai
            print_line_to_shell
            invokeai_launch
            ;;
        5)
            print_line_to_shell "$term_sd_manager_info 启动"
            invokeai-merge --gui --root ./invokeai
            print_line_to_shell
            invokeai_launch
            ;;
    esac
}