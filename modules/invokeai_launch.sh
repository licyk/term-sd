#!/bin/bash

# invokeai启动界面
invokeai_launch()
{
    if [ ! -f ""$start_path"/term-sd/config/invokeai-launch.conf" ]; then # 找不到启动配置时默认生成一个
        term_sd_echo "未找到启动配置文件,创建中"
        echo "" > "$start_path"/term-sd/config/invokeai-launch.conf
    fi

    invokeai_launch_dialog=$(
        dialog --erase-on-exit --notags --title "InvokeAI管理" --backtitle "InvokeAI启动参数选项" --ok-label "确认" --cancel-label "取消" --menu "请选择InvokeAI启动参数\n当前自定义启动参数:\ninvokeai-web $(cat "$start_path"/term-sd/config/invokeai-launch.conf)" $term_sd_dialog_height $term_sd_dialog_width $term_sd_dialog_menu_height \
        "0" "> 返回" \
        "1" "> (configure)启动配置界面" \
        "2" "> (configure --skip-sd-weights)启动配置程序并只下载核心模型" \
        "3" "> (web)启动webui界面" \
        "4" "> (web --host)启动带有远程连接webui界面" \
        "5" "> (web --ignore_missing_core_models)启动webui界面并禁用缺失模型检查" \
        "6" "> (ti --gui)启动模型训练界面" \
        "7" "> (merge --gui)启动模型合并界面" \
        "8" "> (自定义参数)启动webui界面" \
        "9" "> 配置预设启动参数" \
        "10" "> 修改自定义启动参数" \
        3>&1 1>&2 2>&3)

    case $invokeai_launch_dialog in
        1)
            term_sd_print_line "$term_sd_manager_info 启动"
            invokeai-configure --root ./invokeai
            term_sd_pause
            invokeai_launch
            ;;
        2)
            term_sd_print_line "$term_sd_manager_info 启动"
            invokeai-configure --skip-sd-weights --yes --root ./invokeai
            term_sd_pause
            invokeai_launch
            ;;
        3)
            term_sd_print_line "$term_sd_manager_info 启动"
            term_sd_echo "提示:可以使用\"Ctrl+C\"终止ai软件的运行"
            invokeai-web --root ./invokeai
            term_sd_pause
            invokeai_launch
            ;;
        4)
            term_sd_print_line "$term_sd_manager_info 启动"
            term_sd_echo "提示:可以使用\"Ctrl+C\"终止ai软件的运行"
            invokeai-web --host 0.0.0.0 --root ./invokeai
            term_sd_pause
            invokeai_launch
            ;;
        5)
            term_sd_print_line "$term_sd_manager_info 启动"
            term_sd_echo "提示:可以使用\"Ctrl+C\"终止ai软件的运行"
            invokeai-web --ignore_missing_core_models --root ./invokeai
            term_sd_pause
            invokeai_launch
            ;;
        
        6)
            term_sd_print_line "$term_sd_manager_info 启动"
            invokeai-ti --gui --root ./invokeai
            term_sd_pause
            invokeai_launch
            ;;
        7)
            term_sd_print_line "$term_sd_manager_info 启动"
            invokeai-merge --gui --root ./invokeai
            term_sd_pause
            invokeai_launch
            ;;
        8)
            term_sd_launch
            invokeai_launch
            ;;
        9)
            invokeai_launch_args_setting
            invokeai_launch
            ;;
        10)
            invokeai_manual_launch
            invokeai_launch
            ;;
    esac
}

# 启动参数预设选择
invokeai_launch_args_setting()
{
    local invokeai_launch_args_setting_dialog
    local invokeai_launch_args

    invokeai_launch_args_setting_dialog=$(
        dialog --erase-on-exit --notags --title "ComfyUI管理" --backtitle "ComfyUI启动参数选项" --ok-label "确认" --cancel-label "取消" --checklist "请选择ComfyUI启动参数,确认之后将覆盖原有启动参数配置" $term_sd_dialog_height $term_sd_dialog_width $term_sd_dialog_menu_height \
        "1" "(host)开放远程连接" OFF \
        "2" "(no-esrgan)禁用esrgan进行画面修复" OFF \
        "3" "(no-internet_available)启用离线模式" OFF \
        "4" "(log_tokenization)启用详细日志显示" OFF\
        "5" "(no-patchmatch)禁用图片修复模块" OFF \
        "6" "(ignore_missing_core_models)忽略下载核心模型" OFF \
        "7" "(log_format plain)使用纯文本格式日志" OFF \
        "8" "(log_format color)使用彩色格式日志" OFF \
        "9" "(log_format syslog)使用系统格式日志" OFF \
        "10" "(log_format legacy)使用传统格式日志" OFF \
        "11" "(log_sql)显示数据库查新日志" OFF \
        "12" "(dev_reload)启用开发者模式" OFF \
        "13" "(log_memory_usage)显示详细内存使用日志" OFF \
        "14" "(always_use_cpu)强制使用cpu" OFF \
        "15" "(tiled_decode)启用VAE解码,降低显存占用" OFF \
        3>&1 1>&2 2>&3)

    if [ $? = 0 ];then
        for i in $invokeai_launch_args_setting_dialog; do
            case $i in
                1)
                    invokeai_launch_args="--host 0.0.0.0 $invokeai_launch_args"
                    ;;
                2)
                    invokeai_launch_args="--no-esrgan $invokeai_launch_args"
                    ;;
                3)
                    invokeai_launch_args="--no-internet_available $invokeai_launch_args"
                    ;;
                4)
                    invokeai_launch_args="--log_tokenization $invokeai_launch_args"
                    ;;
                5)
                    invokeai_launch_args="--no-patchmatch $invokeai_launch_args"
                    ;;
                6)
                    invokeai_launch_args="--ignore_missing_core_models $invokeai_launch_args"
                    ;;
                7)
                    invokeai_launch_args="--log_format plain $invokeai_launch_args"
                    ;;
                8)
                    invokeai_launch_args="--log_format color $invokeai_launch_args"
                    ;;
                9)
                    invokeai_launch_args="--log_format syslog $invokeai_launch_args"
                    ;;
                10)
                    invokeai_launch_args="--log_format legacy $invokeai_launch_args"
                    ;;
                11)
                    invokeai_launch_args="--log_sql $invokeai_launch_args"
                    ;;
                12)
                    invokeai_launch_args="--dev_reload $invokeai_launch_args"
                    ;;
                13)
                    invokeai_launch_args="--log_memory_usage $invokeai_launch_args"
                    ;;
                14)
                    invokeai_launch_args="--always_use_cpu $invokeai_launch_args"
                    ;;
                15)
                    invokeai_launch_args="--tiled_decode $invokeai_launch_args"
                    ;;
            esac
        done

        term_sd_echo "设置启动参数:  $invokeai_launch_args"
        echo "$invokeai_launch_args" > "$start_path"/term-sd/config/invokeai-launch.conf
    fi
}

# 启动参数修改
invokeai_manual_launch()
{
    local invokeai_launch_args

    invokeai_launch_args=$(dialog --erase-on-exit --title "InvokeAI管理" --backtitle "InvokeAI自定义启动参数选项" --ok-label "确认" --cancel-label "取消" --inputbox "请输入Fooocus启动参数" $term_sd_dialog_height $term_sd_dialog_width "$(cat "$start_path"/term-sd/config/invokeai-launch.conf | awk '{sub("launch.py ","")}1')" 3>&1 1>&2 2>&3)

    if [ $? = 0 ];then
        term_sd_echo "设置启动参数:  $invokeai_launch_args"
        echo "launch.py $invokeai_launch_args" > "$start_path"/term-sd/config/invokeai-launch.conf
    fi
}