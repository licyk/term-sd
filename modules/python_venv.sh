#!/bin/bash

# 虚拟环境设置
venv_setting()
{
    local venv_setting_dialog
    export venv_setup_status

    venv_setting_dialog=$(
        dialog --erase-on-exit --title "Term-SD" --backtitle "虚拟环境设置界面" --ok-label "确认" --cancel-label "取消" --menu "是否启用虚拟环境?(推荐启用)\n当前虚拟环境状态:$([ $venv_setup_status = 0 ] && echo "启用" || echo "禁用")" 25 80 10 \
        "0" "返回" \
        "1" "启用" \
        "2" "禁用" \
        3>&1 1>&2 2>&3)

    case $venv_setting_dialog in
        1)
            venv_setup_status=0
            rm -rf ./term-sd/term-sd-venv-disable.lock
            ;;
        2)
            venv_setup_status=1
            touch ./term-sd/term-sd-venv-disable.lock
            ;;
    esac
}

# 虚拟环境创建功能
create_venv()
{
    if [ $venv_setup_status = 0 ];then
        if [ ! -z "$1" ] && [ $1 = "--fix" ];then
            if [ -d "./venv" ];then
                term_sd_echo "修复虚拟环境中"
                exit_venv # 先退出虚拟环境
                fix_venv # 再进行虚拟环境的修复
            else
                term_sd_echo "创建虚拟环境中"
                term_sd_python -m venv venv 2> /dev/null > /dev/null
                term_sd_echo "创建虚拟环境完成"
            fi
        else
            term_sd_echo "创建虚拟环境"
            term_sd_python -m venv venv 2> /dev/null > /dev/null
            term_sd_echo "创建虚拟环境完成"
        fi
    fi
}

# 修复虚拟环境功能(一种骚操作,修复完后只会丢失一些命令文件,而python的库调用依然正常)
fix_venv()
{
    mkdir ./term-sd-tmp
    # 判断虚拟环境的类型
    if [ -d "./venv/Scripts" ];then # Windows端的venv结构
        term_sd_echo "将虚拟环境的库转移到临时文件夹中"
        mv -f ./venv/Lib ./term-sd-tmp # 将依赖库转移到临时文件夹
        rm -rf ./venv # 删除原有虚拟环境
        term_sd_echo "重新创建新的虚拟环境"
        term_sd_python -m venv venv 2> /dev/null > /dev/null # 重新创建新的虚拟环境
        rm -rf ./venv/Lib # 删除新的虚拟环境中的库文件,为移入原有的库腾出空间
        term_sd_echo "恢复虚拟环境库文件中"
        mv -f ./term-sd-tmp/Lib ./venv # 移入原有的库
        rm -rf ./term-sd-tmp # 清理临时文件夹
        term_sd_echo "修复虚拟环境完成"
    elif [ -d "./venv/bin" ];then # Linux/MacOS端的venv结构
        term_sd_echo "将虚拟环境的库转移到临时文件夹中"
        mv -f ./venv/lib ./term-sd-tmp # 将依赖库转移到临时文件夹
        rm -rf ./venv # 删除原有虚拟环境
        term_sd_echo "重新创建新的虚拟环境"
        term_sd_python -m venv venv 2> /dev/null > /dev/null # 重新创建新的虚拟环境
        rm -rf ./venv/lib # 删除新的虚拟环境中的库文件,为移入原有的库腾出空间
        term_sd_echo "恢复虚拟环境库文件中"
        mv -f ./term-sd-tmp/lib ./venv # 移入原有的库
        rm -rf ./term-sd-tmp # 清理临时文件夹
        term_sd_echo "修复虚拟环境完成"
    else # 未判断出类型
        term_sd_echo "创建venv虚拟环境中"
        term_sd_python -m venv venv 2> /dev/null > /dev/null
        term_sd_echo "创建虚拟环境完成"
    fi
}

# 进入虚拟环境功能
enter_venv()
{
    if [ $venv_setup_status = 0 ];then
        if [ ! -z "$VIRTUAL_ENV" ];then # 检测到未退出虚拟环境
            exit_venv 2> /dev/null
        fi
        term_sd_echo "进入虚拟环境"

        if [ -f "./venv/Scripts/activate" ];then # 在Windows端的venv目录结构和linux,macos的不同,所以进入虚拟环境的方式有区别
            pip_package_manager_update
            source ./venv/Scripts/activate > /dev/null
        elif [ -f "./venv/bin/activate" ];then
            pip_package_manager_update
            source ./venv/bin/activate > /dev/null
        else
            false
            term_sd_echo "虚拟环境文件损坏"
        fi
    fi
}

# 退出虚拟环境功能(改了一下python官方的退出脚本)
exit_venv(){
    if [ ! -z "$VIRTUAL_ENV" ];then # 检测是否在虚拟环境中
        term_sd_echo "退出虚拟环境"
        # reset old environment variables
        if [ -n "${_OLD_VIRTUAL_PATH:-}" ] ; then
            PATH="${_OLD_VIRTUAL_PATH:-}"
            export PATH
            export _OLD_VIRTUAL_PATH=
        fi
        if [ -n "${_OLD_VIRTUAL_PYTHONHOME:-}" ] ; then
            PYTHONHOME="${_OLD_VIRTUAL_PYTHONHOME:-}"
            export PYTHONHOME
            export _OLD_VIRTUAL_PYTHONHOME=
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
            export _OLD_VIRTUAL_PS1=
        fi

        export VIRTUAL_ENV=
        export VIRTUAL_ENV_PROMPT=
        if [ ! "${1:-}" = "nondestructive" ] ; then
        # Self destruct!
            unset -f deactivate 2> /dev/null
        fi
        term_sd_echo "退出虚拟环境完成"
    fi
}

# venv-pip更新
pip_package_manager_update()
{
    if [ $pip_manager_update = 0 ];then
        term_sd_echo "开始更新pip包管理器"
        term_sd_python -m pip install --upgrade pip
        if [ $? = 0 ];then
            term_sd_echo "pip包管理器更新成功"
        else
            term_sd_echo "pip包管理器更新失败"
        fi
    fi
}