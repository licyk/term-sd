#!bin/bash

. ./term-sd/modules/term_sd_manager.sh
. ./term-sd/modules/python_venv.sh
. ./term-sd/modules/term_sd_python_cmd.sh
. ./term-sd/modules/term_sd_try.sh

if [ -d "$sd_webui_path" ] && ! term_sd_test_empty_dir "$sd_webui_path" ;then
    term_sd_echo "检测到 stable-diffusion-webui 已安装"
    enter_venv "$sd_webui_path"
    term_sd_echo "检测 setuptools 版本"
    setuptools_ver=$(term_sd_pip show setuptools | grep -i "version" | awk -F ':' '{print $NF}' | awk -F '.' '{print $1}')
    if [ $setuptools_ver -gt 65 ];then
        term_sd_echo "检测到 setuptools 版本大于 65, 进行降级中"
        term_sd_try term_sd_pip install setuptools==65.5.0
        if [ $? = 0 ];then
            term_sd_echo "setuptools 降级成功"
        else
            term_sd_echo "setuptools 降级失败, 启动 stable-diffusion-webui 可能会出现 \"ImportError: cannot import name 'packaging' from 'pkg_resources'\" 的问题"
        fi
    else
        term_sd_echo "setuptools 版本低于 65, 无需降级"
    fi
else
    term_sd_echo "stable-diffusion-webui 未安装"
fi