#!/bin/bash

# 处理python命令
term_sd_python()
{
    # 检测是否在虚拟环境中
    if [ ! -z "$VIRTUAL_ENV" ];then # 当处在虚拟环境时
        # 检测使用哪种命令调用python
        # 调用虚拟环境的python
        if [ ! -z "$(python3 --version 2> /dev/null)" ];then
            python3 "$@" # 加双引号防止运行报错
        elif [ ! -z "$(python --version 2> /dev/null)" ];then
            python "$@"
        fi
    else # 不在虚拟环境时
        #调 用系统中存在的python
        "$term_sd_python_path" "$@"
    fi
}

# 处理pip命令
term_sd_pip()
{
    # 检测是否在虚拟环境中
    if [ ! -z "$VIRTUAL_ENV" ];then
        # 调用虚拟环境的pip
        pip "$@"
    else
        # 调用系统中存在的pip
        "$term_sd_pip_path" "$@"
    fi
}