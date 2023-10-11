#!/bin/bash

#fooocus启动脚本生成部分
function generate_fooocus_launch()
{
    fooocus_launch_option=""

    fooocus_launch_option_dialog=$(
        dialog --clear --title "Fooocus管理" --backtitle "Fooocus启动参数选项" --separate-output --notags --ok-label "确认" --no-cancel --checklist "请选择Fooocus启动参数" 25 70 10 \
        "1" "listen" OFF \
        "2" "directml" OFF \
        3>&1 1>&2 2>&3)

    if [ $? = 0 ];then
        if [ ! -z "$fooocus_launch_option_dialog" ]; then
            for fooocus_launch_option_dialog_ in $fooocus_launch_option_dialog; do
            case "$fooocus_launch_option_dialog_" in
            "1")
            fooocus_launch_option="--listen"
            ;;
            "2")    
            fooocus_launch_option="--directml"
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
        term_sd_notice "设置启动参数> $fooocus_launch_option"
        echo "launch.py $fooocus_launch_option" > term-sd-launch.conf
    fi
}

#fooocus启动界面
function fooocus_launch()
{
    fooocus_launch_dialog=$(dialog --clear --title "Fooocus管理" --backtitle "Fooocus启动选项" --ok-label "确认" --cancel-label "取消" --menu "请选择启动Fooocus/修改Fooocus启动参数\n当前启动参数:\n"$python_cmd" $(cat ./term-sd-launch.conf)" 25 70 10 \
        "1" "启动" \
        "2" "修改启动参数" \
        "3" "自定义启动参数" \
        "4" "返回" \
        3>&1 1>&2 2>&3)

    if [ $? = 0 ];then
        if [ $fooocus_launch_dialog = 1 ];then
            term_sd_launch
            fooocus_launch
        elif [ $fooocus_launch_dialog = 2 ];then
            generate_fooocus_launch
            fooocus_launch
        elif [ $fooocus_launch_dialog = 3 ];then
            fooocus_manual_launch
            fooocus_launch
        fi
    fi
}

#fooocus手动输入启动参数界面
function fooocus_manual_launch()
{
    fooocus_manual_launch_parameter=$(dialog --clear --title "Fooocus管理" --backtitle "Fooocus自定义启动参数选项" --ok-label "确认" --cancel-label "取消" --inputbox "请输入Fooocus启动参数" 25 70 "$(cat ./term-sd-launch.conf | awk '{sub("launch.py ","")}1')" 3>&1 1>&2 2>&3)

    if [ -z $fooocus_manual_launch_parameter ];then
        term_sd_notice "设置启动参数> $fooocus_manual_launch_parameter"
        echo "launch.py $fooocus_manual_launch_parameter" > term-sd-launch.conf
    fi
}