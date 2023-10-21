#!/bin/bash

#fooocus启动脚本生成部分
function generate_fooocus_launch()
{
    fooocus_launch_option=""

    fooocus_launch_option_dialog=$(
        dialog --clear --title "Fooocus管理" --backtitle "Fooocus启动参数选项" --separate-output --notags --ok-label "确认" --cancel-label "取消" --checklist "请选择Fooocus启动参数" 25 70 10 \
        "1" "listen" OFF \
        "2" "directml" OFF \
        3>&1 1>&2 2>&3)

    if [ $? = 0 ];then
        for i in $fooocus_launch_option_dialog; do
            case $i in
                1)
                    fooocus_launch_option="--listen"
                    ;;
                2)    
                    fooocus_launch_option="--directml"
                    ;;
            esac
        done

        term_sd_notice "设置启动参数> $fooocus_launch_option"
        echo "launch.py $fooocus_launch_option" > term-sd-launch.conf
    fi
}

#fooocus启动界面
function fooocus_launch()
{
    fooocus_launch_dialog=$(dialog --clear --title "Fooocus管理" --backtitle "Fooocus启动选项" --ok-label "确认" --cancel-label "取消" --menu "请选择启动Fooocus/修改Fooocus启动参数\n当前启动参数:\n$([ $venv_active = 0 ] && echo python || echo "$term_sd_python_path") $(cat ./term-sd-launch.conf)" 25 70 10 \
        "1" "启动" \
        "2" "选择预设启动参数" \
        "3" "自定义启动参数" \
        "4" "返回" \
        3>&1 1>&2 2>&3)

    if [ $? = 0 ];then
        case $fooocus_launch_dialog in
            1)
                term_sd_launch
                fooocus_launch
                ;;
            2)
                generate_fooocus_launch
                fooocus_launch
                ;;
            3)
                fooocus_manual_launch
                fooocus_launch
                ;;
        esac
    fi
}

#fooocus手动输入启动参数界面
function fooocus_manual_launch()
{
    fooocus_manual_launch_parameter=$(dialog --clear --title "Fooocus管理" --backtitle "Fooocus自定义启动参数选项" --ok-label "确认" --cancel-label "取消" --inputbox "请输入Fooocus启动参数" 25 70 "$(cat ./term-sd-launch.conf | awk '{sub("launch.py ","")}1')" 3>&1 1>&2 2>&3)

    if [ $? = 0 ];then
        term_sd_notice "设置启动参数> $fooocus_manual_launch_parameter"
        echo "launch.py $fooocus_manual_launch_parameter" > term-sd-launch.conf
    fi
}