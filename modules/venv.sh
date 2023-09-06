#/bin/bash

#venv虚拟环境处理

function venv_option()
{
    if (dialog --clear --title "Term-SD" --backtitle "venv虚拟环境选项" --yes-label "启用" --no-label "禁用" --yesno "是否启用venv虚拟环境?(推荐启用)" 20 60) then
        venv_active="0"
        venv_info="启用"
        rm -rf ./term-sd/term-sd-venv-disable.lock
    else
        venv_active="1"
        venv_info="禁用"
        touch ./term-sd/term-sd-venv-disable.lock
    fi
    mainmenu
}

function create_venv()
{
    if [ "$venv_active" = "0" ];then
        if [ $(uname -o) = "Msys" ];then #为了兼容windows系统
            echo "创建venv虚拟环境"
            python -m venv venv
        else
            echo "创建venv虚拟环境"
            python3 -m venv venv
        fi
    fi
}

function enter_venv()
{
    if [ "$venv_active" = "0" ];then
        if [ $(uname -o) = "Msys" ];then #为了兼容windows系统
            echo "进入venv虚拟环境"
            source ./venv/Scripts/activate
        else
            echo "进入venv虚拟环境"
            source ./venv/bin/activate
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
