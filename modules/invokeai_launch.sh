#!/bin/bash

#invokeai启动界面（第一层）
function generate_invokeai_launch()
{
    generate_invokeai_launch_dialog=$(
        dialog --erase-on-exit --title "InvokeAI管理" --backtitle "InvokeAI启动参数选项" --ok-label "确认" --cancel-label "取消" --menu "请选择InvokeAI启动参数" 25 80 10 \
        "1" "(invokeai-configure)启动配置界面" \
        "2" "(invokeai --web)启动webui界面" \
        "3" "(invokeai-ti --gui)启动模型训练界面" \
        "4" "(invokeai-merge --gui)启动模型合并界面" \
        "5" "自定义启动参数" \
        "6" "返回" \
        3>&1 1>&2 2>&3 )

    if [ $? = 0 ];then
        case $generate_invokeai_launch_dialog in
            1)
                print_line_to_shell "$term_sd_manager_info 启动"
                invokeai-configure --root ./invokeai
                print_line_to_shell
                generate_invokeai_launch
                ;;
            2)
                print_line_to_shell "$term_sd_manager_info 启动"
                invokeai-web --root ./invokeai
                print_line_to_shell
                generate_invokeai_launch
                ;;
            3)
                print_line_to_shell "$term_sd_manager_info 启动"
                invokeai-ti --gui --root ./invokeai
                print_line_to_shell
                generate_invokeai_launch
                ;;
            4)
                print_line_to_shell "$term_sd_manager_info 启动"
                invokeai-merge --gui --root ./invokeai
                print_line_to_shell
                generate_invokeai_launch
                ;;
            5)
                invokeai_launch
                generate_invokeai_launch
                ;;
        esac
    fi
}

#invokeai命令行参数即将在invokeai3.4中移除
#invokeai自定义启动参数生成
function generate_invokeai_launch_custom()
{
    custom_invokeai_launch_option=""

    generate_invokeai_launch_custom_dialog=$(
        dialog --erase-on-exit --title "InvokeAI管理" --backtitle "InvokeAI自定义启动参数选项" --separate-output --notags --ok-label "确认" --cancel-label "取消" --checklist "请选择InvokeAI启动参数,确认之后将覆盖原有启动参数配置" 25 80 10 \
        "1" "(web)启用webui界面" ON \
        "2" "(free_gpu_mem)生图完成后释放显存" OFF \
        "3" "(precision auto)自动设置模型精度" ON \
        "4" "(precision fp32)强制使用fp32模型精度" OFF\
        "5" "(precision fp16)强制使用fp16模型精度" OFF \
        "6" "(no-xformers)禁用xformers优化" OFF \
        "7" "(xformers)使用xformers优化" ON \
        "8" "(patchmatch)启用优化补丁" OFF \
        "9" "(no-patchmatch)禁用优化补丁" OFF \
        "10" "(safety-checker)启用图像NSFW检查" OFF \
        "11" "(ckpt_convert)将内存中的模型自动转换为扩散器格式" OFF \
        "12" "(host)启用远程连接" OFF \
        3>&1 1>&2 2>&3)

    if [ $? = 0 ];then
        for i in $generate_invokeai_launch_custom_dialog; do
            case $i in
                1)
                    custom_invokeai_launch_option="--web $custom_invokeai_launch_option"
                    ;;
                2)
                    custom_invokeai_launch_option="--free_gpu_mem $custom_invokeai_launch_option"
                    ;;
                3)
                    custom_invokeai_launch_option="--precision auto $custom_invokeai_launch_option"
                    ;;
                4)
                    custom_invokeai_launch_option="--precision fp32 $custom_invokeai_launch_option"
                    ;;
                5)
                    custom_invokeai_launch_option="--precision fp16 $custom_invokeai_launch_option"
                    ;;
                6)
                    custom_invokeai_launch_option="--no-xformers $custom_invokeai_launch_option"
                    ;;
                7)
                    custom_invokeai_launch_option="--xformers $custom_invokeai_launch_option"
                    ;;
                8)
                    custom_invokeai_launch_option="--patchmatch $custom_invokeai_launch_option"
                    ;;
                9)
                    custom_invokeai_launch_option="--no-patchmatch $custom_invokeai_launch_option"
                    ;;
                10)
                    custom_invokeai_launch_option="--safety-checker $custom_invokeai_launch_option"
                    ;;
                11)
                    custom_invokeai_launch_option="--ckpt_convert $custom_invokeai_launch_option"
                    ;;
                12)
                    custom_invokeai_launch_option="--host 0.0.0.0 $custom_invokeai_launch_option"
                    ;;
            esac
        done

        #生成启动脚本
        term_sd_notice "设置启动参数> $custom_invokeai_launch_option"
        echo "--root ./invokeai $custom_invokeai_launch_option" > term-sd-launch.conf
    fi
}

#invokeai启动选项（第二层）
function invokeai_launch()
{
    invokeai_launch_dialog=$(dialog --erase-on-exit --title "InvokeAI管理" --backtitle "InvokeAI启动选项" --ok-label "确认" --cancel-label "取消" --menu "请选择启动InvokeAI/修改InvokeAI启动参数\n当前启动参数:\ninvokeai $(cat ./term-sd-launch.conf)" 25 80 10 \
        "1" "启动" \
        "2" "选择预设启动参数" \
        "3" "自定义启动参数" \
        "4" "返回" \
        3>&1 1>&2 2>&3)

    if [ $? = 0 ];then
        case $invokeai_launch_dialog in
            1)
                term_sd_launch
                invokeai_launch
                ;;
            2)
                generate_invokeai_launch_custom
                invokeai_launch
                ;;
            3)
                invokeai_manual_launch
                invokeai_launch
                ;;
        esac
    fi
}

#invokeai手动输入启动参数界面
function invokeai_manual_launch()
{
    invokeai_manual_launch_parameter=$(dialog --erase-on-exit --title "InvokeAI管理" --backtitle "InvokeAI自定义启动参数选项" --ok-label "确认" --cancel-label "取消" --inputbox "请输入InvokeAI启动参数" 25 80 "$(cat ./term-sd-launch.conf | awk '{sub("--root ./invokeai ","")}1')" 3>&1 1>&2 2>&3)

    if [ $? = 0 ];then
        term_sd_notice "设置启动参数> $invokeai_manual_launch_parameter"
        echo "--root ./invokeai $invokeai_manual_launch_parameter" > term-sd-launch.conf
    fi
}