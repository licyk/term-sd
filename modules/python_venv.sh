#!/bin/bash

# 虚拟环境创建功能
create_venv() {
    if is_use_venv; then
        if [[ ! -z "$@" ]]; then # 指定路径创建虚拟环境
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

# 检测并修复虚拟环境的激活脚本中的现路径错误
# 使用:
# fix_activate_venv_script <虚拟环境的路径>
fix_activate_venv_script() {
    local status
    local venv_path=$@
    local venv_bin_path

    if [[ -d "${venv_path}/Scripts" ]]; then
        venv_bin_path="${venv_path}/Scripts"
    elif [[ -d "${venv_path}/bin" ]]; then
        venv_bin_path="${venv_path}/bin"
    else
        venv_bin_path="${venv_path}/bin"
    fi

    status=$(term_sd_python "${START_PATH}/term-sd/python_modules/check_venv_path_invalid.py" \
        --venv-bin-path "${venv_bin_path}"\
        --venv-path "${venv_path}"\
    )

    if [[ "${status}" == "True" ]]; then
        term_sd_echo "修正虚拟环境激活脚本中"
        python -m venv "${venv_path}"
    fi
}

# 修复虚拟环境功能(一种骚操作, 修复完后只会丢失一些命令文件, 而 Python 的库调用依然正常)
# 已知问题: 使用该方法修复虚拟环境后, PyTorch 可能会报错, 提示某个文件找不到, 需要使用 PyTorch 重装功能将 PyTorch 重新安装
# fix_venv <虚拟环境的路径>
fix_venv() {
    local venv_path

    # 虚拟环境路径
    if [[ ! -z "$@" ]]; then
        venv_path="$(term_sd_win2unix_path "$@")/venv"
    else
        venv_path="$(pwd)/venv"
    fi

    if is_use_venv; then
        if [[ -d "${venv_path}" ]]; then
            term_sd_echo "修复虚拟环境中"
            # 判断虚拟环境的类型
            if [[ -d "${venv_path}/Scripts" ]]; then # Windows 端的 venv 结构
                term_sd_echo "将虚拟环境的库转移到临时文件夹中"
                mkdir term-sd-tmp
                mv -f "${venv_path}"/Lib term-sd-tmp # 将依赖库转移到临时文件夹
                rm -rf venv # 删除原有虚拟环境
                term_sd_echo "重新创建新的虚拟环境"
                term_sd_python -m venv "${venv_path}" &> /dev/null # 重新创建新的虚拟环境
                rm -rf "${venv_path}"/Lib # 删除新的虚拟环境中的库文件, 为移入原有的库腾出空间
                term_sd_echo "恢复虚拟环境库文件中"
                mv -f term-sd-tmp/Lib "${venv_path}" # 移入原有的库
                rm -rf term-sd-tmp # 清理临时文件夹
                term_sd_python -m venv "${venv_path}" &> /dev/null
                term_sd_echo "修复虚拟环境完成"
            elif [[ -d "${venv_path}/bin" ]]; then # Linux / MacOS 端的 venv 结构
                term_sd_echo "将虚拟环境的库转移到临时文件夹中"
                mkdir term-sd-tmp
                mv -f "${venv_path}"/lib term-sd-tmp # 将依赖库转移到临时文件夹
                rm -rf "${venv_path}" # 删除原有虚拟环境
                term_sd_echo "重新创建新的虚拟环境"
                term_sd_python -m venv "${venv_path}" &> /dev/null # 重新创建新的虚拟环境
                rm -rf "${venv_path}"/lib # 删除新的虚拟环境中的库文件, 为移入原有的库腾出空间
                term_sd_echo "恢复虚拟环境库文件中"
                mv -f term-sd-tmp/lib "${venv_path}" # 移入原有的库
                rm -rf term-sd-tmp # 清理临时文件夹
                term_sd_python -m venv "${venv_path}" &> /dev/null
                term_sd_echo "修复虚拟环境完成"
            else # 未判断出类型
                term_sd_echo "创建虚拟环境中"
                term_sd_python -m venv "${venv_path}" &> /dev/null
                term_sd_echo "创建虚拟环境完成"
            fi
        else
            term_sd_echo "创建虚拟环境中"
            term_sd_python -m venv "${venv_path}" &> /dev/null
            term_sd_echo "创建虚拟环境完成"
        fi
    fi
}

# 进入虚拟环境功能
# 使用:
# enter_venv <虚拟环境的路径>
enter_venv() {
    local venv_path
    local is_venv_broken=0

    # 虚拟环境路径
    if [[ ! -z "$@" ]]; then
        venv_path="$(term_sd_win2unix_path "$@")/venv"
    else
        venv_path="$(pwd)/venv"
    fi

    if is_use_venv; then
        if [[ ! -z "${VIRTUAL_ENV}" ]]; then # 检测到未退出虚拟环境
            exit_venv &> /dev/null
        fi
        term_sd_echo "进入虚拟环境"

        fix_activate_venv_script "${venv_path}" # 检查虚拟环境激活脚本

        if [[ -f "${venv_path}/Scripts/activate" ]]; then # 在 Windows 端的 venv 目录结构和 Linux, MacoOS 的不同, 所以进入虚拟环境的方式有区别
            . "${venv_path}"/Scripts/activate &> /dev/null
        elif [[ -f "${venv_path}/bin/activate" ]]; then
            . "${venv_path}"/bin/activate &> /dev/null
        else
            term_sd_echo "虚拟环境文件损坏"
            is_venv_broken=1
        fi

        # 检测虚拟环境是否有问题
        if [[ ! -d "${VIRTUAL_ENV}" ]] \
            || [[ ! "$(term_sd_win2unix_path "${VIRTUAL_ENV}")" == "${venv_path}" ]] \
            || [[ "${is_venv_broken}" == 1 ]]; then
            term_sd_echo "检测虚拟环境出现异常, 尝试修复中"
            exit_venv &> /dev/null
            fix_venv "$@" # 修复虚拟环境

            # 重新进入虚拟环境
            if [[ -f "${venv_path}/Scripts/activate" ]]; then # 在 Windows 端的 venv 目录结构和 Linux, MacoOS 的不同, 所以进入虚拟环境的方式有区别
                . "${venv_path}"/Scripts/activate &> /dev/null
            elif [[ -f "${venv_path}/bin/activate" ]]; then
                . "${venv_path}"/bin/activate &> /dev/null
            fi
        fi
        pip_package_manager_update
    fi
}

# 退出虚拟环境功能(方法来自 Python 官方的退出虚拟环境脚本)
exit_venv() {
    if [[ ! -z "${VIRTUAL_ENV}" ]]; then # 检测是否在虚拟环境中
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

# 更新虚拟环境中的 Pip 包管理器
pip_package_manager_update() {
    if [[ "${ENABLE_PIP_VER_CHECK}" == 1 ]]; then
        term_sd_echo "开始更新 Pip 包管理器"
        term_sd_python -m pip install --upgrade pip
        if [[ "$?" == 0 ]]; then
            term_sd_echo "Pip 包管理器更新成功"
        else
            term_sd_echo "Pip 包管理器更新失败"
        fi
    fi
}

# 如果启用了虚拟环境, 则返回 0
is_use_venv() {
    if [[ "${ENABLE_VENV}" == 1 ]]; then
        return 0
    else
        return 1
    fi
}