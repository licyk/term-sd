#!/bin/bash

#invokeai启动界面（第一层）
function generate_invokeai_launch()
{
    generate_invokeai_launch_dialog=$(
        dialog --clear --title "InvokeAI管理" --backtitle "InvokeAI启动参数选项" --ok-label "确认" --cancel-label "取消" --menu "请选择InvokeAI启动参数" 25 70 10 \
        "1" "invokeai-configure" \
        "2" "invokeai" \
        "3" "invokeai --web" \
        "4" "invokeai-ti --gui" \
        "5" "invokeai-merge --gui" \
        "6" "自定义启动参数" \
        "7" "返回" \
        3>&1 1>&2 2>&3 )
    if [ $? = 0 ];then
        if [ $generate_invokeai_launch_dialog = 1 ]; then
            print_line_to_shell "$term_sd_manager_info 启动"
            invokeai-configure --root ./invokeai
            print_line_to_shell
            generate_invokeai_launch
        elif [ $generate_invokeai_launch_dialog = 2 ]; then
            print_line_to_shell "$term_sd_manager_info 启动"
            invokeai --root ./invokeai
            print_line_to_shell
            generate_invokeai_launch
        elif [ $generate_invokeai_launch_dialog = 3 ]; then
            print_line_to_shell "$term_sd_manager_info 启动"
            invokeai --web --root ./invokeai
            print_line_to_shell
            generate_invokeai_launch
        elif [ $generate_invokeai_launch_dialog = 4 ]; then
            print_line_to_shell "$term_sd_manager_info 启动"
            invokeai-ti --gui --root ./invokeai
            print_line_to_shell
            generate_invokeai_launch
        elif [ $generate_invokeai_launch_dialog = 5 ]; then
            print_line_to_shell "$term_sd_manager_info 启动"
            invokeai-merge --gui --root ./invokeai
            print_line_to_shell
            generate_invokeai_launch
        elif [ $generate_invokeai_launch_dialog = 6 ]; then
            invokeai_launch
            generate_invokeai_launch
        fi
    fi
}

#invokeai自定义启动参数生成
function generate_invokeai_launch_custom()
{
    custom_invokeai_launch_option=""

    generate_invokeai_launch_custom_dialog=$(
        dialog --clear --title "InvokeAI管理" --backtitle "InvokeAI自定义启动参数选项" --separate-output --notags --ok-label "确认" --no-cancel --checklist "请选择InvokeAI启动参数" 25 70 10 \
        "1" "web" ON \
        "2" "free_gpu_mem" OFF \
        "3" "precision auto" ON \
        "4" "precision fp32" OFF\
        "5" "precision fp16" OFF \
        "6" "no-xformers_enabled" OFF \
        "7" "xformers_enabled" ON \
        "8" "no-patchmatch" OFF \
        "9" "always_use_cpu" OFF \
        "10" "no-esrgan" OFF \
        "11" "no-internet_available" OFF \
        "12" "host" OFF \
        3>&1 1>&2 2>&3)

    if [ $? = 0 ];then
        if [ ! -z "$generate_invokeai_launch_custom_dialog" ]; then
            for generate_invokeai_launch_custom_dialog_ in $generate_invokeai_launch_custom_dialog; do
            case "$generate_invokeai_launch_custom_dialog_" in
            "1")
            custom_invokeai_launch_option="--web $custom_invokeai_launch_option"
            ;;
            "2")
            custom_invokeai_launch_option="--free_gpu_mem $custom_invokeai_launch_option"
            ;;
            "3")
            custom_invokeai_launch_option="--precision auto $custom_invokeai_launch_option"
            ;;
            "4")
            custom_invokeai_launch_option="--precision fp32 $custom_invokeai_launch_option"
            ;;
            "5")
            custom_invokeai_launch_option="--precision fp16 $custom_invokeai_launch_option"
            ;;
            "6")
            custom_invokeai_launch_option="--no-xformers_enabled $custom_invokeai_launch_option"
            ;;
            "7")
            custom_invokeai_launch_option="--xformers_enabled $custom_invokeai_launch_option"
            ;;
            "8")
            custom_invokeai_launch_option="--no-patchmatch $custom_invokeai_launch_option"
            ;;
            "9")
            custom_invokeai_launch_option="--always_use_cpu $custom_invokeai_launch_option"
            ;;
            "10")
            custom_invokeai_launch_option="--no-esrgan $custom_invokeai_launch_option"
            ;;
            "11")
            custom_invokeai_launch_option="--no-internet_available $custom_invokeai_launch_option"
            ;;
            "12")
            custom_invokeai_launch_option="--host 0.0.0.0 $custom_invokeai_launch_option"
            ;;
            *)
            exit 1
            ;;    
            esac
            done

            #生成启动脚本
            term_sd_notice "设置启动参数> $custom_invokeai_launch_option"
            echo "--root ./invokeai $custom_invokeai_launch_option" > term-sd-launch.conf
        fi
    fi
}

#invokeai启动选项（第二层）
function invokeai_launch()
{
    invokeai_launch_dialog=$(dialog --clear --title "InvokeAI管理" --backtitle "InvokeAI启动选项" --ok-label "确认" --cancel-label "取消" --menu "请选择启动InvokeAI/修改InvokeAI启动参数\n当前启动参数:\ninvokeai $(cat ./term-sd-launch.conf)" 25 70 10 \
        "1" "启动" \
        "2" "修改启动参数" \
        "3" "自定义启动参数" \
        "4" "返回" \
        3>&1 1>&2 2>&3)

    if [ $? = 0 ];then
        if [ $invokeai_launch_dialog = 1 ];then
            term_sd_launch
            invokeai_launch
        elif [ $invokeai_launch_dialog = 2 ];then
            generate_invokeai_launch_custom
            invokeai_launch
        elif [ $invokeai_launch_dialog = 3 ];then
            invokeai_manual_launch
            invokeai_launch
        fi
    fi
}

#invokeai手动输入启动参数界面
function invokeai_manual_launch()
{
    invokeai_manual_launch_parameter=$(dialog --clear --title "InvokeAI管理" --backtitle "InvokeAI自定义启动参数选项" --ok-label "确认" --cancel-label "取消" --inputbox "请输入InvokeAI启动参数" 25 70 "$(cat ./term-sd-launch.conf | awk '{sub("--root ./invokeai","")}1')" 3>&1 1>&2 2>&3)

    if [ $? = 0 ];then
        term_sd_notice "设置启动参数> $invokeai_manual_launch_parameter"
        echo "$invokeai_manual_launch_parameter --root ./invokeai" > term-sd-launch.conf
    fi
}