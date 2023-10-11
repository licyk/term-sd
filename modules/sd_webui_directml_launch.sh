#!/bin/bash

#sd-webui-directml启动参数生成功能
function generate_sd_webui_directml_launch()
{
    #清空启动参数
    sd_webui_directml_launch_option=""

    #展示启动参数选项
    sd_webui_directml_launch_option_dialog=$(
        dialog --clear --title "A1111-SD-Webui管理" --backtitle "SD-Webui-DirectML启动参数选项" --separate-output --notags --ok-label "确认" --no-cancel --checklist "请选择SD-Webui-DirectML启动参数" 25 70 10 \
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
        if [ ! -z "$sd_webui_directml_launch_option_dialog" ]; then
            for sd_webui_directml_launch_option_dialog_ in $sd_webui_directml_launch_option_dialog; do
            case "$sd_webui_directml_launch_option_dialog_" in
            "1")
            sd_webui_directml_launch_option="--skip-torch-cuda-test $sd_webui_directml_launch_option"
            ;;
            "2")
            sd_webui_directml_launch_option="--no-half $sd_webui_directml_launch_option"
            ;;
            "3")
            sd_webui_directml_launch_option="--no-half-vae $sd_webui_directml_launch_option"
            ;;
            "4")
            sd_webui_directml_launch_option="--medvram $sd_webui_directml_launch_option"
            ;;
            "5")
            sd_webui_directml_launch_option="--lowvram $sd_webui_directml_launch_option"
            ;;
            "6")
            sd_webui_directml_launch_option="--lowram $sd_webui_directml_launch_option"
            ;;
            "7")
            sd_webui_directml_launch_option="--enable-insecure-extension-access $sd_webui_directml_launch_option"
            ;;
            "8")
            sd_webui_directml_launch_option="--theme dark $sd_webui_directml_launch_option"
            ;;
            "9")
            sd_webui_directml_launch_option="--autolaunch $sd_webui_directml_launch_option"
            ;;
            "10")
            sd_webui_directml_launch_option="--xformers $sd_webui_directml_launch_option"
            ;;
            "11")
            sd_webui_directml_launch_option="--listen $sd_webui_directml_launch_option"
            ;;
            "12")
            sd_webui_directml_launch_option="--precision full $sd_webui_directml_launch_option"
            ;;
            "13")
            sd_webui_directml_launch_option="--force-enable-xformers $sd_webui_directml_launch_option"
            ;;
            "14")
            sd_webui_directml_launch_option="--xformers-flash-attention $sd_webui_directml_launch_option"
            ;;
            "15")
            sd_webui_directml_launch_option="--api $sd_webui_directml_launch_option"
            ;;
            "16")
            sd_webui_directml_launch_option="--ui-debug-mode $sd_webui_directml_launch_option"
            ;;
            "17")
            sd_webui_directml_launch_option="--share $sd_webui_directml_launch_option"
            ;;
            "18")
            sd_webui_directml_launch_option="--opt-split-attention-invokeai $sd_webui_directml_launch_option"
            ;;
            "19")
            sd_webui_directml_launch_option="--opt-split-attention-v1 $sd_webui_directml_launch_option"
            ;;
            "20")
            sd_webui_directml_launch_option="--opt-sdp-attention $sd_webui_directml_launch_option"
            ;;
            "21")
            sd_webui_directml_launch_option="--opt-sdp-no-mem-attention $sd_webui_directml_launch_option"
            ;;
            "22")
            sd_webui_directml_launch_option="--disable-opt-split-attention $sd_webui_directml_launch_option"
            ;;
            "23")
            sd_webui_directml_launch_option="--use-cpu all $sd_webui_directml_launch_option"
            ;;
            "24")
            sd_webui_directml_launch_option="--opt-channelslast $sd_webui_directml_launch_option"
            ;;
            "25")
            sd_webui_directml_launch_option="--no-gradio-queue $sd_webui_directml_launch_option"
            ;;
            "26")
            sd_webui_directml_launch_option="--no-hashing $sd_webui_directml_launch_option"
            ;;
            "27")
            sd_webui_directml_launch_option="--backend directml $sd_webui_directml_launch_option"
            ;;
            "28")
            sd_webui_directml_launch_option="--opt-sub-quad-attention $sd_webui_directml_launch_option"
            ;;
            "29")
            sd_webui_directml_launch_option="--medvram-sdxl $sd_webui_directml_launch_option"
            ;;
            *)
            exit 1
            ;;    
            esac
            done
        fi
    
        #生成启动脚本
        term_sd_notice "设置启动参数> $sd_webui_directml_launch_option"
        echo "launch.py $sd_webui_directml_launch_option" > term-sd-launch.conf
    fi
}

#a1111-sd-webui启动界面
function sd_webui_directml_launch()
{
    sd_webui_directml_launch_dialog=$(dialog --clear --title "A1111-SD-Webui管理" --backtitle "SD-Webui-DirectML启动选项" --ok-label "确认" --cancel-label "取消" --menu "请选择启动SD-Webui-DirectML/修改SD-Webui-DirectML启动参数\n当前启动参数:\n"$python_cmd" $(cat ./term-sd-launch.conf)" 25 70 10 \
        "1" "启动" \
        "2" "选择预设启动参数" \
        "3" "自定义启动参数" \
        "4" "返回" \
        3>&1 1>&2 2>&3)
    
    if [ $? = 0 ];then
        if [ $sd_webui_directml_launch_dialog = 1 ];then
            term_sd_launch
            sd_webui_directml_launch
        elif [ $sd_webui_directml_launch_dialog = 2 ];then
            generate_sd_webui_directml_launch
            sd_webui_directml_launch
        elif [ $sd_webui_directml_launch_dialog = 3 ];then
            sd_webui_directml_manual_launch
            sd_webui_directml_launch
        fi
    fi
}

#a1111-sd-webui手动输入启动参数界面
function sd_webui_directml_manual_launch()
{
    sd_webui_directml_manual_launch_parameter=$(dialog --clear --title "A1111-SD-Webui管理" --backtitle "SD-Webui-DirectML自定义启动参数选项" --ok-label "确认" --cancel-label "取消" --inputbox "请输入SD-Webui-DirectML启动参数" 25 70 "$(cat ./term-sd-launch.conf)" 3>&1 1>&2 2>&3)

    if [ -z $sd_webui_directml_manual_launch_parameter ];then
        term_sd_notice "设置启动参数> $sd_webui_directml_manual_launch_parameter"
        echo "launch.py $sd_webui_directml_manual_launch_parameter" > term-sd-launch.conf 
    fi
}
