#!/bin/bash

# 虚拟环境创建功能
create_venv()
{
    if [ $venv_setup_status = 0 ];then
        if [ ! -z "$@" ];then # 指定路径创建虚拟环境
            term_sd_echo "创建虚拟环境"
            term_sd_python -m venv "$@"/venv > /dev/null 2>&1
            term_sd_echo "创建虚拟环境完成"
        else
            term_sd_echo "创建虚拟环境"
            term_sd_python -m venv venv > /dev/null 2>&1
            term_sd_echo "创建虚拟环境完成"
        fi
    fi
}

# 修复虚拟环境功能(一种骚操作,修复完后只会丢失一些命令文件,而python的库调用依然正常)
fix_venv()
{
    if [ $venv_setup_status = 0 ];then
        if [ -d "venv" ];then
            term_sd_echo "修复虚拟环境中"
            # 判断虚拟环境的类型
            if [ -d "venv/Scripts" ];then # Windows端的venv结构
                term_sd_echo "将虚拟环境的库转移到临时文件夹中"
                mkdir term-sd-tmp
                mv -f venv/Lib term-sd-tmp # 将依赖库转移到临时文件夹
                rm -rf venv # 删除原有虚拟环境
                term_sd_echo "重新创建新的虚拟环境"
                term_sd_python -m venv venv > /dev/null 2>&1 # 重新创建新的虚拟环境
                rm -rf venv/Lib # 删除新的虚拟环境中的库文件,为移入原有的库腾出空间
                term_sd_echo "恢复虚拟环境库文件中"
                mv -f term-sd-tmp/Lib venv # 移入原有的库
                rm -rf term-sd-tmp # 清理临时文件夹
                term_sd_echo "修复虚拟环境完成"
            elif [ -d "venv/bin" ];then # Linux/MacOS端的venv结构
                term_sd_echo "将虚拟环境的库转移到临时文件夹中"
                mkdir term-sd-tmp
                mv -f venv/lib term-sd-tmp # 将依赖库转移到临时文件夹
                rm -rf venv # 删除原有虚拟环境
                term_sd_echo "重新创建新的虚拟环境"
                term_sd_python -m venv venv > /dev/null 2>&1 # 重新创建新的虚拟环境
                rm -rf venv/lib # 删除新的虚拟环境中的库文件,为移入原有的库腾出空间
                term_sd_echo "恢复虚拟环境库文件中"
                mv -f term-sd-tmp/lib venv # 移入原有的库
                rm -rf term-sd-tmp # 清理临时文件夹
                term_sd_echo "修复虚拟环境完成"
            else # 未判断出类型
                term_sd_echo "创建venv虚拟环境中"
                term_sd_python -m venv venv > /dev/null 2>&1
                term_sd_echo "创建虚拟环境完成"
            fi
        else
            term_sd_echo "创建venv虚拟环境中"
            term_sd_python -m venv venv > /dev/null 2>&1
            term_sd_echo "创建虚拟环境完成"
        fi
    fi
}

# 进入虚拟环境功能
enter_venv()
{
    if [ $venv_setup_status = 0 ];then
        if [ ! -z "$VIRTUAL_ENV" ];then # 检测到未退出虚拟环境
            exit_venv > /dev/null 2>&1
        fi
        term_sd_echo "进入虚拟环境"

        if [ ! -z "$@" ];then # 进入指定路径的虚拟环境
            if [ -f "$@/venv/Scripts/activate" ];then # 在Windows端的venv目录结构和linux,macos的不同,所以进入虚拟环境的方式有区别
                pip_package_manager_update
                . "$@"/venv/Scripts/activate > /dev/null 2>&1
            elif [ -f "$@/venv/bin/activate" ];then
                pip_package_manager_update
                . "$@"/venv/bin/activate > /dev/null 2>&1
            else
                term_sd_echo "虚拟环境文件损坏"
            fi
        else
            if [ -f "venv/Scripts/activate" ];then # 在Windows端的venv目录结构和linux,macos的不同,所以进入虚拟环境的方式有区别
                pip_package_manager_update
                . ./venv/Scripts/activate > /dev/null 2>&1
            elif [ -f "venv/bin/activate" ];then
                pip_package_manager_update
                . ./venv/bin/activate > /dev/null 2>&1
            else
                term_sd_echo "虚拟环境文件损坏"
            fi
        fi
    fi
}

# 退出虚拟环境功能(改了一下python官方的退出脚本)
exit_venv()
{
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