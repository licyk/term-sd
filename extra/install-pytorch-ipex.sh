#!/bin/bash

source ./term-sd/modules/term_sd_manager.sh
source ./term-sd/modules/python_venv.sh
source ./term-sd/modules/term_sd_python_cmd.sh

install_pytorch_repo_select()
{
    term_sd_echo "请选择pytorch ipex的安装位置"
    term_sd_echo "1、Stable-Diffusion-WebUI"
    term_sd_echo "2、ComfyUI"
    term_sd_echo "3、Fooocus"
    term_sd_echo "4、InvokeAI"
    term_sd_echo "5、lora-scripts"
    term_sd_echo "6、kohya_ss"
    term_sd_echo "提示:输入数字并回车,或者输入exit回车退出"
    case $(term_sd_read) in
        1)
            return 1
            ;;
        2)
            return 2
            ;;
        3)
            return 3
            ;;
        4)
            return 4
            ;;
        5)
            return 5
            ;;
        exit)
            return 128
            ;;
        *)
            term_sd_echo "输入有误,请重试"
            install_pytorch_repo_select
            ;;
    esac
}

install_pytorch_ipex()
{
    if [ -d "./$@" ];then
        cd "$@"
        create_venv
        enter_venv
        cd ..
        get_pytorch_whl
        if [ $? = 0 ];then
            term_sd_echo "开始安装pytorch ipex"
            term_sd_watch term_sd_pip install ./term-sd/task/pytorch-ipex/intel_extension_for_pytorch-2.0.110+gitc6ea20b-cp310-cp310-win_amd64.whl ./term-sd/task/pytorch-ipex/torch-2.0.0a0+gite9ebda2-cp310-cp310-win_amd64.whl ./term-sd/task/pytorch-ipex/torchvision-0.15.2a0+fa99a53-cp310-cp310-win_amd64.whl
            term_sd_echo "安装结束"
        else
            term_sd_echo "下载pytorch ipex失败"
        fi
        term_sd_echo "清理安装包"
        rm -rf ./term-sd/task/pytorch-ipex
        exit_venv
    else
        term_sd_echo "未安装${@}"
    fi
}

get_pytorch_whl()
{
    local req=0
    term_sd_watch aria2c https://gitcode.net/rubble7343/nuullll-intel-extension-for-pytorch/-/raw/master/intel_extension_for_pytorch-2.0.110+gitc6ea20b-cp310-cp310-win_amd64.whl?inline=false -d ./term-sd/task/pytorch-ipex -o intel_extension_for_pytorch-2.0.110+gitc6ea20b-cp310-cp310-win_amd64.whl || req=1
    term_sd_watch aria2c https://gitcode.net/rubble7343/nuullll-intel-extension-for-pytorch/-/raw/master/torch-2.0.0a0+gite9ebda2-cp310-cp310-win_amd64.whl?inline=false -d ./term-sd/task/pytorch-ipex -o torch-2.0.0a0+gite9ebda2-cp310-cp310-win_amd64.whl || req=1
    term_sd_watch aria2c https://gitcode.net/rubble7343/nuullll-intel-extension-for-pytorch/-/raw/master/torchvision-0.15.2a0+fa99a53-cp310-cp310-win_amd64.whl?inline=false -d ./term-sd/task/pytorch-ipex -o torchvision-0.15.2a0+fa99a53-cp310-cp310-win_amd64.whl || req=1
    return $req
}

#############################

[ -d "./term-sd/task/pytorch-ipex" ] && rm -rf ./term-sd/task/pytorch-ipex
install_pytorch_repo_select
case $? in
    1)
        install_pytorch_ipex stable-diffusion-webui
        ;;
    2)
        install_pytorch_ipex ComfyUI
        ;;
    3)
        install_pytorch_ipex InvokeAI
        ;;
    4)
        install_pytorch_ipex Fooocus
        ;;
    5)
        install_pytorch_ipex lora-scripts
        ;;
    6)
        install_pytorch_ipex kohya_ss
        ;;
    *)
        term_sd_echo "取消安装pytorch ipex"
        ;;
esac
