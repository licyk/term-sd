#!/bin/bash

if [ -d "./kohya_ss" ];then
    term_sd_echo "开始修复kohya_ss环境的bitsandbytes"
    cd kohya_ss
    create_venv
    enter_venv
    term_sd_pip install bitsandbytes==0.41.1 --force --index-url https://jihulab.com/api/v4/projects/140618/packages/pypi/simple
    if [ $? = 0 ];then
        term_sd_echo "bitsandbytes-for-windows安装成功"
    else
        term_sd_echo "bitsandbytes-for-windows安装失败"
    fi
    exit_venv
else
    term_sd_echo "kohya_ss未安装"
fi