#!/bin/bash

#vlad-sd-webui启动参数生成
function generate_vlad_sd_webui_launch()
{
    #清空启动参数
    vlad_sd_webui_launch_option=""

    #展示启动参数选项
    vlad_sd_webui_launch_option_dialog=$(
        dialog --clear --title "A1111-SD-Webui管理" --backtitle "Vlad-SD-Webui启动参数选项" --separate-output --notags --ok-label "确认" --cancel-label "取消" --checklist "请选择Vlad-Stable-Diffusion-Webui启动参数" 25 70 10 \
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
        for i in $vlad_sd_webui_launch_option_dialog; do
            case $i in
                1)
                    vlad_sd_webui_launch_option="--skip-torch-cuda-test $vlad_sd_webui_launch_option"
                    ;;
                2)
                    vlad_sd_webui_launch_option="--no-half $vlad_sd_webui_launch_option"
                    ;;
                3)
                    vlad_sd_webui_launch_option="--no-half-vae $vlad_sd_webui_launch_option"
                    ;;
                4)
                    vlad_sd_webui_launch_option="--medvram $vlad_sd_webui_launch_option"
                    ;;
                5)
                    vlad_sd_webui_launch_option="--lowvram $vlad_sd_webui_launch_option"
                    ;;
                6)
                    vlad_sd_webui_launch_option="--lowram $vlad_sd_webui_launch_option"
                    ;;
                7)
                    vlad_sd_webui_launch_option="--enable-insecure-extension-access $vlad_sd_webui_launch_option"
                    ;;
                8)
                    vlad_sd_webui_launch_option="--theme dark $vlad_sd_webui_launch_option"
                    ;;
                9)
                    vlad_sd_webui_launch_option="--autolaunch $vlad_sd_webui_launch_option"
                    ;;
                10)
                    vlad_sd_webui_launch_option="--xformers $vlad_sd_webui_launch_option"
                    ;;
                11)
                    vlad_sd_webui_launch_option="--listen $vlad_sd_webui_launch_option"
                    ;;
                12)
                    vlad_sd_webui_launch_option="--precision full $vlad_sd_webui_launch_option"
                    ;;
                13)
                    vlad_sd_webui_launch_option="--force-enable-xformers $vlad_sd_webui_launch_option"
                    ;;
                14)
                    vlad_sd_webui_launch_option="--xformers-flash-attention $vlad_sd_webui_launch_option"
                    ;;
                15)
                    vlad_sd_webui_launch_option="--api $vlad_sd_webui_launch_option"
                    ;;
                16)
                    vlad_sd_webui_launch_option="--ui-debug-mode $vlad_sd_webui_launch_option"
                    ;;
                17)
                    vlad_sd_webui_launch_option="--share $vlad_sd_webui_launch_option"
                    ;;
                18)
                    vlad_sd_webui_launch_option="--opt-split-attention-invokeai $vlad_sd_webui_launch_option"
                    ;;
                19)
                    vlad_sd_webui_launch_option="--opt-split-attention-v1 $vlad_sd_webui_launch_option"
                    ;;
                20)
                    vlad_sd_webui_launch_option="--opt-sdp-attention $vlad_sd_webui_launch_option"
                    ;;
                21)
                    vlad_sd_webui_launch_option="--opt-sdp-no-mem-attention $vlad_sd_webui_launch_option"
                    ;;
                22)
                    vlad_sd_webui_launch_option="--disable-opt-split-attention $vlad_sd_webui_launch_option"
                    ;;
                23)
                    vlad_sd_webui_launch_option="--use-cpu all $vlad_sd_webui_launch_option"
                    ;;
                24)
                    vlad_sd_webui_launch_option="--opt-channelslast $vlad_sd_webui_launch_option"
                    ;;
                25)
                    vlad_sd_webui_launch_option="--no-gradio-queue $vlad_sd_webui_launch_option"
                    ;;
                26)
                    vlad_sd_webui_launch_option="--no-hashing $vlad_sd_webui_launch_option"
                    ;;
                27)
                    vlad_sd_webui_launch_option="--backend directml $vlad_sd_webui_launch_option"
                    ;;
                28)
                    vlad_sd_webui_launch_option="--opt-sub-quad-attention $vlad_sd_webui_launch_option"
                    ;;
                29)
                    vlad_sd_webui_launch_option="--medvram-sdxl $vlad_sd_webui_launch_option"
                    ;;  
            esac
        done
    
        #生成启动脚本
        term_sd_notice "设置启动参数> $vlad_sd_webui_launch_option"
        echo "launch.py $vlad_sd_webui_launch_option" > term-sd-launch.conf
    fi
}

#vlad-sd-webui启动界面
function vlad_sd_webui_launch()
{
    vlad_sd_webui_launch_dialog=$(dialog --clear --title "A1111-SD-Webui管理" --backtitle "Vlad-SD-Webui启动选项" --ok-label "确认" --cancel-label "取消" --menu "请选择启动Vlad-SD-Webui/修改Vlad-SD-Webui启动参数\n当前启动参数:\n$([ $venv_active = 0 ] && echo python || echo "$term_sd_python_path") $(cat ./term-sd-launch.conf)" 25 70 10 \
        "1" "启动" \
        "2" "选择预设启动参数" \
        "3" "自定义启动参数" \
        "4" "返回" \
        3>&1 1>&2 2>&3)
    
    if [ $? = 0 ];then
        case $vlad_sd_webui_launch_dialog in
            1)
                term_sd_launch
                vlad_sd_webui_launch
                ;;
            2)
                generate_vlad_sd_webui_launch
                vlad_sd_webui_launch
                ;;
            3)
                vlad_sd_webui_manual_launch
                vlad_sd_webui_launch
                ;;
        esac
    fi
}

#vlad-sd-webui手动输入启动参数界面
function vlad_sd_webui_manual_launch()
{
    vlad_sd_webui_manual_launch_parameter=$(dialog --clear --title "A1111-SD-Webui管理" --backtitle "Vlad-SD-Webui自定义启动参数选项" --ok-label "确认" --cancel-label "取消" --inputbox "请输入Vlad-SD-Webui启动参数" 25 70 "$(cat ./term-sd-launch.conf)" 3>&1 1>&2 2>&3)

    if [ -z $vlad_sd_webui_manual_launch_parameter ];then
        term_sd_notice "设置启动参数> $vlad_sd_webui_manual_launch_parameter"
        echo "launch.py $vlad_sd_webui_manual_launch_parameter" > term-sd-launch.conf 
    fi
}
