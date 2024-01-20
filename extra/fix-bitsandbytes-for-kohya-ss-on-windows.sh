#!/bin/bash

. ./term-sd/modules/term_sd_manager.sh
. ./term-sd/modules/python_venv.sh
. ./term-sd/modules/term_sd_python_cmd.sh

if [ -d "$kohya_ss_path" ];then
    if [ ! -z $OS ] && [ $OS = "Windows_NT" ];then
        term_sd_echo "开始修复kohya_ss环境的bitsandbytes"
        create_venv "$kohya_ss_path"
        enter_venv "$kohya_ss_path"
        term_sd_watch term_sd_pip install bitsandbytes==0.41.1 --force-reinstall --index-url https://jihulab.com/api/v4/projects/140618/packages/pypi/simple
        if [ $? = 0 ];then
            term_sd_echo "bitsandbytes-for-windows安装成功"
        else
            term_sd_echo "bitsandbytes-for-windows安装失败"
        fi
        exit_venv
    else
        term_sd_echo "检测到当前系统不是Windows系统,无需修复bitsandbytes"
    fi
else
    term_sd_echo "kohya_ss未安装"
fi

cd "$start_path"