#!/bin/bash

#comfyui启动脚本生成部分
function generate_comfyui_launch()
{
    comfyui_launch_option=""

    comfyui_launch_option_select=$(
        dialog --clear --title "ComfyUI管理" --backtitle "ComfyUI启动参数选项" --separate-output --notags --ok-label "确认" --no-cancel --checklist "请选择ComfyUI启动参数" 23 70 12 \
        "1" "listen" OFF \
        "2" "auto-launch" OFF \
        "3" "dont-upcast-attention" OFF \
        "4" "force-fp32" OFF\
        "5" "use-split-cross-attention" OFF \
        "6" "use-pytorch-cross-attention" OFF \
        "7" "disable-xformers" OFF \
        "8" "gpu-only" OFF \
        "9" "highvram" OFF \
        "10" "normalvram" OFF \
        "11" "lowvram" OFF \
        "12" "novram" OFF \
        "13" "cpu" OFF \
        "14" "quick-test-for-ci" OFF \
        "15" "directml" OFF \
        3>&1 1>&2 2>&3)

    if [ $? = 0 ];then
        if [ ! -z "$comfyui_launch_option_select" ]; then
            for comfyui_launch_option_select_ in $comfyui_launch_option_select; do
            case "$comfyui_launch_option_select_" in
            "1")
            comfyui_launch_option="--listen"
            ;;
            "2")    
            comfyui_launch_option="--auto-launch"
            ;;
            "3")
            comfyui_launch_option="--dont-upcast-attention"
            ;;
            "4")
            comfyui_launch_option="--force-fp32"
            ;;
            "5")
            comfyui_launch_option="--use-split-cross-attention"
            ;;
            "6")
            comfyui_launch_option="--use-pytorch-cross-attention"
            ;;
            "7")
            comfyui_launch_option="--disable-xformers"
            ;;
            "8")
            comfyui_launch_option="--gpu-only"
            ;;
            "9")
            comfyui_launch_option="--highvram"
            ;;
            "10")
            comfyui_launch_option="--normalvram"
            ;;
            "11")
            comfyui_launch_option="--lowvram"
            ;;
            "12")
            comfyui_launch_option="--novram"
            ;;
            "13")
            comfyui_launch_option="--cpu"
            ;;
            "14")
            comfyui_launch_option="--quick-test-for-ci"
            ;;
            "15")
            comfyui_launch_option="--directml"
            ;;
            *)
            exit 1
            ;;    
            esac
            done
        fi

        if [ -f "./term-sd-launch.conf" ];then
            rm -v ./term-sd-launch.conf
        fi
        echo "设置启动参数> $comfyui_launch_option"
        echo "main.py $comfyui_launch_option" > term-sd-launch.conf
    fi
}

#comfyui启动界面
function comfyui_launch()
{
    comfyui_launch_=$(dialog --clear --title "ComfyUI管理" --backtitle "ComfyUI启动选项" --ok-label "确认" --cancel-label "取消" --menu "请选择启动ComfyUI/修改ComfyUI启动参数\n当前启动参数:\n$python_cmd $(cat ./term-sd-launch.conf)" 23 70 12 \
        "1" "启动" \
        "2" "修改启动参数" \
        "5" "返回" \
        3>&1 1>&2 2>&3)

    if [ $? = 0 ];then
        if [ $comfyui_launch_ = 1 ];then
            term_sd_launch
        elif [ $comfyui_launch_ = 2 ];then
            generate_comfyui_launch
            term_sd_launch
        fi
    fi
}