#!/bin/bash

#venv虚拟环境处理

function venv_option()
{
    if (dialog --clear --title "Term-SD" --backtitle "venv虚拟环境选项" --yes-label "启用" --no-label "禁用" --yesno "是否启用venv虚拟环境?(推荐启用)\n当前虚拟环境状态:$([ $venv_active = 0 ] && echo "启用" || echo "禁用")" 22 70) then
        export venv_active="0"
        export dialog_button_5=""18" "重新生成venv虚拟环境"" #在启用venv后显示这些dialog按钮
        export dialog_button_6=""19" "重新构建venv虚拟环境""
        rm -rf ./term-sd/term-sd-venv-disable.lock
    else
        export venv_active="1"
        export dialog_button_5=""
        export dialog_button_6=""
        touch ./term-sd/term-sd-venv-disable.lock
    fi
    mainmenu
}

function create_venv()
{
    if [ "$venv_active" = "0" ];then
        echo "创建venv虚拟环境"
        $python_cmd -m venv venv
    fi
}

function enter_venv()
{
    if [ "$venv_active" = "0" ];then
        echo "进入venv虚拟环境"
        if [ -f "./venv/Scripts/activate" ];then #在Windows端的venv目录结构和linux,macos的不同,所以进入虚拟环境的方式有区别
            source ./venv/Scripts/activate
        elif [ -f "./venv/bin/activate" ];then
            source ./venv/bin/activate
        else
            echo "虚拟环境文件损坏"
        fi
    fi
}

function exit_venv()
{
    if which deactivate 2> /dev/null ;then #检测到未退出虚拟环境
        echo "退出venv虚拟环境"
        deactivate
    fi
}
