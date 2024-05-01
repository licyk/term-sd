#!/bin/bash

# 虚拟环境创建功能
create_venv()
{
    if [ $venv_setup_status = 0 ];then
        if [ ! -z "$@" ];then # 指定路径创建虚拟环境
            term_sd_echo "创建虚拟环境"
            term_sd_python -m venv "$@"/venv &> /dev/null
            term_sd_echo "创建虚拟环境完成"
        else
            term_sd_echo "创建虚拟环境"
            term_sd_python -m venv venv &> /dev/null
            term_sd_echo "创建虚拟环境完成"
        fi
    fi
}

# 修复虚拟环境功能(一种骚操作,修复完后只会丢失一些命令文件,而python的库调用依然正常)
fix_venv()
{
    local term_sd_venv_path

    # 虚拟环境路径
    if [ ! -z "$@" ];then
        term_sd_venv_path="$(term_sd_win2unix_path "$@")/venv"
    else
        term_sd_venv_path="$(pwd)/venv"
    fi

    if [ $venv_setup_status = 0 ];then
        if [ -d "$term_sd_venv_path" ];then
            term_sd_echo "修复虚拟环境中"
            # 判断虚拟环境的类型
            if [ -d "$term_sd_venv_path/Scripts" ];then # Windows端的venv结构
                term_sd_echo "将虚拟环境的库转移到临时文件夹中"
                mkdir term-sd-tmp
                mv -f "$term_sd_venv_path"/Lib term-sd-tmp # 将依赖库转移到临时文件夹
                rm -rf venv # 删除原有虚拟环境
                term_sd_echo "重新创建新的虚拟环境"
                term_sd_python -m venv "$term_sd_venv_path" &> /dev/null # 重新创建新的虚拟环境
                rm -rf "$term_sd_venv_path"/Lib # 删除新的虚拟环境中的库文件,为移入原有的库腾出空间
                term_sd_echo "恢复虚拟环境库文件中"
                mv -f term-sd-tmp/Lib venv # 移入原有的库
                rm -rf term-sd-tmp # 清理临时文件夹
                term_sd_echo "修复虚拟环境完成"
            elif [ -d "$term_sd_venv_path/bin" ];then # Linux/MacOS端的venv结构
                term_sd_echo "将虚拟环境的库转移到临时文件夹中"
                mkdir term-sd-tmp
                mv -f "$term_sd_venv_path"/lib term-sd-tmp # 将依赖库转移到临时文件夹
                rm -rf "$term_sd_venv_path" # 删除原有虚拟环境
                term_sd_echo "重新创建新的虚拟环境"
                term_sd_python -m venv "$term_sd_venv_path" &> /dev/null # 重新创建新的虚拟环境
                rm -rf "$term_sd_venv_path"/lib # 删除新的虚拟环境中的库文件,为移入原有的库腾出空间
                term_sd_echo "恢复虚拟环境库文件中"
                mv -f term-sd-tmp/lib venv # 移入原有的库
                rm -rf term-sd-tmp # 清理临时文件夹
                term_sd_echo "修复虚拟环境完成"
            else # 未判断出类型
                term_sd_echo "创建venv虚拟环境中"
                term_sd_python -m venv "$term_sd_venv_path" &> /dev/null
                term_sd_echo "创建虚拟环境完成"
            fi
        else
            term_sd_echo "创建venv虚拟环境中"
            term_sd_python -m venv "$term_sd_venv_path" &> /dev/null
            term_sd_echo "创建虚拟环境完成"
        fi
    fi
}

# 进入虚拟环境功能
enter_venv()
{
    local term_sd_venv_path
    local term_sd_venv_status=0

    # 虚拟环境路径
    if [ ! -z "$@" ];then
        term_sd_venv_path="$(term_sd_win2unix_path "$@")/venv"
    else
        term_sd_venv_path="$(pwd)/venv"
    fi

    if [ $venv_setup_status = 0 ];then
        if [ ! -z "$VIRTUAL_ENV" ];then # 检测到未退出虚拟环境
            exit_venv &> /dev/null
        fi
        term_sd_echo "进入虚拟环境"

        if [ -f "$term_sd_venv_path/Scripts/activate" ];then # 在Windows端的venv目录结构和linux,macos的不同,所以进入虚拟环境的方式有区别
            . "$term_sd_venv_path"/Scripts/activate &> /dev/null
        elif [ -f "$term_sd_venv_path/bin/activate" ];then
            . "$term_sd_venv_path"/bin/activate &> /dev/null
        else
            term_sd_echo "虚拟环境文件损坏"
            term_sd_venv_status=1
        fi

        # 检测虚拟环境是否有问题
        if [ ! -d "$VIRTUAL_ENV" ] || [ ! "$(term_sd_win2unix_path "$VIRTUAL_ENV")" = "$term_sd_venv_path" ] || [ $term_sd_venv_status = 1 ];then
            term_sd_echo "检测虚拟环境出现异常, 尝试修复中"
            exit_venv &> /dev/null
            fix_venv "$@" # 修复虚拟环境

            # 重新进入虚拟环境
            if [ -f "$term_sd_venv_path/Scripts/activate" ];then # 在Windows端的venv目录结构和linux,macos的不同,所以进入虚拟环境的方式有区别
                . "$term_sd_venv_path"/Scripts/activate &> /dev/null
            elif [ -f "$term_sd_venv_path/bin/activate" ];then
                . "$term_sd_venv_path"/bin/activate &> /dev/null
            fi
        fi
        pip_package_manager_update
    fi
}

# 退出虚拟环境功能(功能来自python官方的退出虚拟环境脚本)
exit_venv()
{
    if [ ! -z "$VIRTUAL_ENV" ];then # 检测是否在虚拟环境中
        term_sd_echo "退出虚拟环境"
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
            unset -f deactivate
        fi
        term_sd_echo "退出虚拟环境完成"
    fi
}

# venv-pip更新
pip_package_manager_update()
{
    if [ $pip_manager_update = 0 ];then
        term_sd_echo "开始更新 Pip 包管理器"
        term_sd_python -m pip install --upgrade pip
        if [ $? = 0 ];then
            term_sd_echo "Pip 包管理器更新成功"
        else
            term_sd_echo "Pip 包管理器更新失败"
        fi
    fi
}