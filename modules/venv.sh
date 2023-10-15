#!/bin/bash

#venv虚拟环境处理

#虚拟环境设置
function venv_option()
{
    if (dialog --clear --title "Term-SD" --backtitle "venv虚拟环境选项" --yes-label "启用" --no-label "禁用" --yesno "是否启用venv虚拟环境?(推荐启用)\n当前虚拟环境状态:$([ $venv_active = 0 ] && echo "启用" || echo "禁用")" 25 70) then
        export venv_active="0"
        export dialog_recreate_venv_button=""18" "重新生成venv虚拟环境"" #在启用venv后显示这些dialog按钮
        export dialog_rebuild_venv_button=""19" "重新构建venv虚拟环境""
        rm -rf ./term-sd/term-sd-venv-disable.lock
    else
        export venv_active="1"
        export dialog_recreate_venv_button=""
        export dialog_rebuild_venv_button=""
        touch ./term-sd/term-sd-venv-disable.lock
    fi
    mainmenu
}

#虚拟环境创建功能
function create_venv()
{
    if [ $venv_active = 0 ];then
        if [ ! -z "$1" ] && [ $1 = "--fix" ];then
            if [ -d "./venv" ];then
                term_sd_notice "修复venv虚拟环境中"
                exit_venv #先退出虚拟环境
                fix_venv #再进行虚拟环境的修复
            else
                term_sd_notice "创建venv虚拟环境中"
                python_cmd -m venv venv 2> /dev/null > /dev/null
            fi
        else
            term_sd_notice "创建venv虚拟环境中"
            python_cmd -m venv venv 2> /dev/null > /dev/null
        fi

    fi
}

#修复虚拟环境功能
function fix_venv()
{
    mkdir ./term-sd-tmp
    #判断虚拟环境的类型
    if [ -d "./venv/Scripts" ];then
        term_sd_notice "将venv虚拟环境的库转移到临时文件夹中"
        mv -f ./venv/Lib ./term-sd-tmp #将依赖库转移到临时文件夹
        rm -rf ./venv #删除原有虚拟环境
        term_sd_notice "重新创建新的venv虚拟环境中"
        python_cmd -m venv venv 2> /dev/null > /dev/null #重新创建新的虚拟环境
        rm -rf ./venv/Lib #删除新的虚拟环境中的库文件,为移入原有的库腾出空间
        term_sd_notice "恢复venv虚拟环境的库中"
        mv -f ./term-sd-tmp/Lib ./venv #移入原有的库
        rm -rf ./term-sd-tmp #清理临时文件夹
        term_sd_notice "修复venv虚拟环境完成"
    elif [ -d "./venv/bin" ];then
        term_sd_notice "将venv虚拟环境的库转移到临时文件夹中"
        mv -f ./venv/lib ./term-sd-tmp #将依赖库转移到临时文件夹
        rm -rf ./venv #删除原有虚拟环境
        term_sd_notice "重新创建新的venv虚拟环境中"
        python_cmd -m venv venv 2> /dev/null > /dev/null #重新创建新的虚拟环境
        rm -rf ./venv/lib #删除新的虚拟环境中的库文件,为移入原有的库腾出空间
        term_sd_notice "恢复venv虚拟环境的库中"
        mv -f ./term-sd-tmp/lib ./venv #移入原有的库
        rm -rf ./term-sd-tmp #清理临时文件夹
        term_sd_notice "修复venv虚拟环境完成"
    else #未判断出类型
        term_sd_notice "创建venv虚拟环境中"
        python_cmd -m venv venv 2> /dev/null > /dev/null
    fi
}

#进入虚拟环境功能
function enter_venv()
{
    if [ $venv_active = 0 ];then
        term_sd_notice "进入venv虚拟环境"
        if [ ! -z "$VIRTUAL_ENV" ];then #检测到未退出虚拟环境
            exit_venv 2> /dev/null
        fi

        if [ -f "./venv/Scripts/activate" ];then #在Windows端的venv目录结构和linux,macos的不同,所以进入虚拟环境的方式有区别
            source ./venv/Scripts/activate > /dev/null
            if [ $pip_manager_update = 0 ];then
                python_cmd -m pip install --upgrade pip
                if [ $? = 0 ];then
                    term_sd_notice "pip包管理器更新成功"
                else
                    term_sd_notice "pip包管理器更新失败"
                fi
            fi
        elif [ -f "./venv/bin/activate" ];then
            source ./venv/bin/activate > /dev/null
            if [ $pip_manager_update = 0 ];then
                python_cmd -m pip install --upgrade pip
                if [ $? = 0 ];then
                    term_sd_notice "pip包管理器更新成功"
                else
                    term_sd_notice "pip包管理器更新失败"
                fi
            fi
        else
            term_sd_notice "虚拟环境文件损坏"
        fi
    fi
}

#退出虚拟环境功能(直接用了python官方的退出脚本)
function exit_venv(){
    if [ ! -z "$VIRTUAL_ENV" ];then #检测是否在虚拟环境中
        # reset old environment variables
        if [ -n "${_OLD_VIRTUAL_PATH:-}" ] ; then
            PATH="${_OLD_VIRTUAL_PATH:-}"
            export PATH
            unset _OLD_VIRTUAL_PATH
        fi
        if [ -n "${_OLD_VIRTUAL_PYTHONHOME:-}" ] ; then
            PYTHONHOME="${_OLD_VIRTUAL_PYTHONHOME:-}"
            export PYTHONHOME
            unset _OLD_VIRTUAL_PYTHONHOME
        fi

        # This should detect bash and zsh, which have a hash command that must
        # be called to get it to forget past commands.  Without forgetting
        # past commands the $PATH changes we made may not be respected
        if [ -n "${BASH:-}" -o -n "${ZSH_VERSION:-}" ] ; then
            hash -r 2> /dev/null
        fi

        if [ -n "${_OLD_VIRTUAL_PS1:-}" ] ; then
            PS1="${_OLD_VIRTUAL_PS1:-}"
            export PS1
            unset _OLD_VIRTUAL_PS1
        fi

        unset VIRTUAL_ENV
        unset VIRTUAL_ENV_PROMPT
        if [ ! "${1:-}" = "nondestructive" ] ; then
        # Self destruct!
            unset -f deactivate 2> /dev/null
        fi
    fi
}
