#!/bin/bash

. ./term-sd/modules/term_sd_manager.sh
. ./term-sd/modules/python_venv.sh
. ./term-sd/modules/term_sd_python_cmd.sh

if [ -d "$sd_webui_path" ];then
    if [ ! -z $OS ] && [ $OS = "Windows_NT" ];then
        term_sd_echo "开始修复Stable-Diffusion-WebUI环境的bitsandbytes"
        term_sd_echo "提示:不建议在Stable-Diffusion-WebUI中进行模型训练,如需训练模型,请使用lora-scripts或者kohya_ss"
        create_venv "$sd_webui_path"
        enter_venv "$sd_webui_path"
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
    term_sd_echo "Stable-Diffusion-WebUI未安装"
fi

cd "$start_path"