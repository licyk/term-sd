#!/bin/bash

# invokeai启动界面
invokeai_launch()
{
    invokeai_launch_dialog=$(
        dialog --erase-on-exit --notags --title "InvokeAI管理" --backtitle "InvokeAI启动参数选项" --ok-label "确认" --cancel-label "取消" --menu "请选择InvokeAI启动参数" $term_sd_dialog_height $term_sd_dialog_width $term_sd_dialog_menu_height \
        "0" "> 返回" \
        "1" "> (configure)启动配置界面" \
        "2" "> (configure --skip-sd-weights)启动配置程序并只下载核心模型" \
        "3" "> (web)启动webui界面" \
        "4" "> (web --host)启动带有远程连接webui界面" \
        "5" "> (web --ignore_missing_core_models)启动webui界面并禁用缺失模型检查" \
        "6" "> (ti --gui)启动模型训练界面" \
        "7" "> (merge --gui)启动模型合并界面" \
        3>&1 1>&2 2>&3)

    case $invokeai_launch_dialog in
        1)
            term_sd_print_line "$term_sd_manager_info 启动"
            invokeai-configure --root ./invokeai
            term_sd_print_line
            invokeai_launch
            ;;
        2)
            term_sd_print_line "$term_sd_manager_info 启动"
            invokeai-configure --skip-sd-weights --yes --root ./invokeai
            term_sd_print_line
            invokeai_launch
            ;;
        3)
            term_sd_print_line "$term_sd_manager_info 启动"
            term_sd_echo "提示:可以使用\"Ctrl+C\"终止ai软件的运行"
            invokeai-web --root ./invokeai
            term_sd_echo "运行结束"
            term_sd_print_line
            invokeai_launch
            ;;
        4)
            term_sd_print_line "$term_sd_manager_info 启动"
            term_sd_echo "提示:可以使用\"Ctrl+C\"终止ai软件的运行"
            invokeai-web --host 0.0.0.0 --root ./invokeai
            term_sd_echo "运行结束"
            term_sd_print_line
            invokeai_launch
            ;;
        5)
            term_sd_print_line "$term_sd_manager_info 启动"
            term_sd_echo "提示:可以使用\"Ctrl+C\"终止ai软件的运行"
            invokeai-web --ignore_missing_core_models --root ./invokeai
            term_sd_echo "运行结束"
            term_sd_print_line
            invokeai_launch
            ;;
        
        6)
            term_sd_print_line "$term_sd_manager_info 启动"
            invokeai-ti --gui --root ./invokeai
            term_sd_print_line
            invokeai_launch
            ;;
        7)
            term_sd_print_line "$term_sd_manager_info 启动"
            invokeai-merge --gui --root ./invokeai
            term_sd_print_line
            invokeai_launch
            ;;
    esac
}