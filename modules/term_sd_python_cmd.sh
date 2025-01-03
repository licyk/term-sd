#!/bin/bash

# 处理 Python 命令
# 使用 TERM_SD_PYTHON_PATH 全局变量读取 Python 的路径
term_sd_python() {
    # 检测是否在虚拟环境中
    if [[ ! -z "${VIRTUAL_ENV}" ]]; then # 当处在虚拟环境时
        # 检测使用哪种命令调用python
        # 调用虚拟环境的python
        if [[ ! -z "$(python --version 2> /dev/null)" ]]; then
            python "$@" # 加双引号防止运行报错
        elif [[ ! -z "$(python3 --version 2> /dev/null)" ]]; then
            python3 "$@"
        fi
    else # 不在虚拟环境时
        #调 用系统中存在的python
        "${TERM_SD_PYTHON_PATH}" "$@"
    fi
}

# 处理 Pip 命令
# 使用 TERM_SD_PYTHON_PATH 全局变量读取 Python 的路径
term_sd_pip() {
    # 检测是否在虚拟环境中
    if [[ ! -z "${VIRTUAL_ENV}" ]]; then
        # 调用虚拟环境的pip
        if [[ ! -z "$(python --version 2> /dev/null)" ]]; then
            python -m pip "$@"
        elif [[ ! -z "$(python3 --version 2> /dev/null)" ]]; then
            python3 -m pip "$@"
        fi
    else
        # 调用系统中存在的pip
        "${TERM_SD_PYTHON_PATH}" -m pip "$@"
    fi
}