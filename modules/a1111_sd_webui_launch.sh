#!/bin/bash

#a1111-sd-webui启动脚本生成部分
function generate_a1111_sd_webui_launch()
{
    #清空启动参数
    a1111_sd_webui_launch_option=""

    #展示启动参数选项
    a1111_sd_webui_launch_option_dialog=$(
        dialog --clear --title "A1111-SD-Webui管理" --backtitle "A1111-SD-Webui启动参数选项" --separate-output --notags --ok-label "确认" --cancel-label "取消" --checklist "请选择A1111-Stable-Diffusion-Webui启动参数" 25 70 10 \
        "1" "skip-torch-cuda-test" OFF \
        "2" "no-half" OFF \
        "3" "no-half-vae" OFF \
        "4" "medvram" OFF \
        "5" "lowvram" OFF \
        "6" "lowram" OFF \
        "7" "enable-insecure-extension-access" OFF \
        "8" "theme dark" ON \
        "9" "autolaunch" ON \
        "10" "xformers" ON \
        "11" "listen" OFF \
        "12" "precision full" OFF \
        "13" "force-enable-xformers" OFF \
        "14" "xformers-flash-attention" OFF \
        "15" "api" OFF \
        "16" "ui-debug-mode" OFF \
        "17" "share" OFF \
        "18" "opt-split-attention-invokeai" OFF \
        "19" "opt-split-attention-v1" OFF \
        "20" "opt-sdp-attention" OFF \
        "21" "opt-sdp-no-mem-attention" OFF \
        "22" "disable-opt-split-attention" OFF \
        "23" "use-cpu all" OFF \
        "24" "opt-channelslast" OFF \
        "25" "no-gradio-queue" OFF \
        "26" "no-hashing" OFF \
        "27" "backend directml" OFF \
        "28" "opt-sub-quad-attention" OFF \
        "29" "medvram-sdxl" OFF \
        3>&1 1>&2 2>&3)

    #根据菜单得到的数据设置变量
    if [ $? = 0 ];then
        if [ ! -z "$a1111_sd_webui_launch_option_dialog" ]; then
            for a1111_sd_webui_launch_option_dialog_ in $a1111_sd_webui_launch_option_dialog; do
            case "$a1111_sd_webui_launch_option_dialog_" in
            "1")
            a1111_sd_webui_launch_option="--skip-torch-cuda-test $a1111_sd_webui_launch_option"
            ;;
            "2")
            a1111_sd_webui_launch_option="--no-half $a1111_sd_webui_launch_option"
            ;;
            "3")
            a1111_sd_webui_launch_option="--no-half-vae $a1111_sd_webui_launch_option"
            ;;
            "4")
            a1111_sd_webui_launch_option="--medvram $a1111_sd_webui_launch_option"
            ;;
            "5")
            a1111_sd_webui_launch_option="--lowvram $a1111_sd_webui_launch_option"
            ;;
            "6")
            a1111_sd_webui_launch_option="--lowram $a1111_sd_webui_launch_option"
            ;;
            "7")
            a1111_sd_webui_launch_option="--enable-insecure-extension-access $a1111_sd_webui_launch_option"
            ;;
            "8")
            a1111_sd_webui_launch_option="--theme dark $a1111_sd_webui_launch_option"
            ;;
            "9")
            a1111_sd_webui_launch_option="--autolaunch $a1111_sd_webui_launch_option"
            ;;
            "10")
            a1111_sd_webui_launch_option="--xformers $a1111_sd_webui_launch_option"
            ;;
            "11")
            a1111_sd_webui_launch_option="--listen $a1111_sd_webui_launch_option"
            ;;
            "12")
            a1111_sd_webui_launch_option="--precision full $a1111_sd_webui_launch_option"
            ;;
            "13")
            a1111_sd_webui_launch_option="--force-enable-xformers $a1111_sd_webui_launch_option"
            ;;
            "14")
            a1111_sd_webui_launch_option="--xformers-flash-attention $a1111_sd_webui_launch_option"
            ;;
            "15")
            a1111_sd_webui_launch_option="--api $a1111_sd_webui_launch_option"
            ;;
            "16")
            a1111_sd_webui_launch_option="--ui-debug-mode $a1111_sd_webui_launch_option"
            ;;
            "17")
            a1111_sd_webui_launch_option="--share $a1111_sd_webui_launch_option"
            ;;
            "18")
            a1111_sd_webui_launch_option="--opt-split-attention-invokeai $a1111_sd_webui_launch_option"
            ;;
            "19")
            a1111_sd_webui_launch_option="--opt-split-attention-v1 $a1111_sd_webui_launch_option"
            ;;
            "20")
            a1111_sd_webui_launch_option="--opt-sdp-attention $a1111_sd_webui_launch_option"
            ;;
            "21")
            a1111_sd_webui_launch_option="--opt-sdp-no-mem-attention $a1111_sd_webui_launch_option"
            ;;
            "22")
            a1111_sd_webui_launch_option="--disable-opt-split-attention $a1111_sd_webui_launch_option"
            ;;
            "23")
            a1111_sd_webui_launch_option="--use-cpu all $a1111_sd_webui_launch_option"
            ;;
            "24")
            a1111_sd_webui_launch_option="--opt-channelslast $a1111_sd_webui_launch_option"
            ;;
            "25")
            a1111_sd_webui_launch_option="--no-gradio-queue $a1111_sd_webui_launch_option"
            ;;
            "26")
            a1111_sd_webui_launch_option="--no-hashing $a1111_sd_webui_launch_option"
            ;;
            "27")
            a1111_sd_webui_launch_option="--backend directml $a1111_sd_webui_launch_option"
            ;;
            "28")
            a1111_sd_webui_launch_option="--opt-sub-quad-attention $a1111_sd_webui_launch_option"
            ;;
            "29")
            a1111_sd_webui_launch_option="--medvram-sdxl $a1111_sd_webui_launch_option"
            ;;
            *)
            exit 1
            ;;    
            esac
            done
        fi
    
        #生成启动脚本
        term_sd_notice "设置启动参数> $a1111_sd_webui_launch_option"
        echo "launch.py $a1111_sd_webui_launch_option" > term-sd-launch.conf
    fi
}

#a1111-sd-webui启动界面
function a1111_sd_webui_launch()
{
    a1111_sd_webui_launch_dialog=$(dialog --clear --title "A1111-SD-Webui管理" --backtitle "A1111-SD-Webui启动选项" --ok-label "确认" --cancel-label "取消" --menu "请选择启动A1111-SD-Webui/修改A1111-SD-Webui启动参数\n当前启动参数:\n"$python_cmd" $(cat ./term-sd-launch.conf)" 25 70 10 \
        "1" "启动" \
        "2" "选择预设启动参数" \
        "3" "自定义启动参数" \
        "4" "返回" \
        3>&1 1>&2 2>&3)
    
    if [ $? = 0 ];then
        if [ $a1111_sd_webui_launch_dialog = 1 ];then
            term_sd_launch
            a1111_sd_webui_launch
        elif [ $a1111_sd_webui_launch_dialog = 2 ];then
            generate_a1111_sd_webui_launch
            a1111_sd_webui_launch
        elif [ $a1111_sd_webui_launch_dialog = 3 ];then
            a1111_sd_webui_manual_launch
            a1111_sd_webui_launch
        fi
    fi
}

#a1111-sd-webui手动输入启动参数界面
function a1111_sd_webui_manual_launch()
{
    a1111_sd_webui_manual_launch_parameter=$(dialog --clear --title "A1111-SD-Webui管理" --backtitle "A1111-SD-Webui自定义启动参数选项" --ok-label "确认" --cancel-label "取消" --inputbox "请输入A1111-SD-Webui启动参数" 25 70 "$(cat ./term-sd-launch.conf | awk '{sub("launch.py ","")}1')" 3>&1 1>&2 2>&3)

    if [ $? = 0 ];then
        term_sd_notice "设置启动参数> $a1111_sd_webui_manual_launch_parameter"
        echo "launch.py $a1111_sd_webui_manual_launch_parameter" > term-sd-launch.conf
    fi
}
