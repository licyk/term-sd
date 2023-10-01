#!/bin/bash

#invokeai安装处理部分
function process_install_invokeai()
{
    #安装前准备
    proxy_option #代理选择
    pytorch_version_select #pytorch选择
    pip_install_methon #安装方式选择
    final_install_check #安装前确认

    if [ $final_install_check_exec = 0 ];then
        #开始安装invokeai
        print_word_to_shell="invokeai 安装"
        print_line_to_shell
        echo "开始安装invokeai"
        tmp_disable_proxy #临时取消代理,避免一些不必要的网络减速
        if [ ! -d "./InvokeAI" ];then
            mkdir InvokeAI
        fi
        cd ./InvokeAI
        create_venv
        enter_venv
        if [ ! -d "./invokeai" ];then
            mkdir ./invokeai
        fi
        if [ ! -z "$(echo $pytorch_install_version | awk '{gsub(/[=+]/, "")}1')" ];then
            pip install $pytorch_install_version $pip_index_mirror $pip_extra_index_mirror $pip_find_mirror $force_pip $pip_install_methon_select --default-timeout=100 --retries 5
        fi
        pip install invokeai $pip_index_mirror $pip_extra_index_mirror $pip_find_mirror $force_pip $pip_install_methon_select --default-timeout=100 --retries 5
        tmp_enable_proxy #恢复原有的代理,保证能从huggingface下载模型
        aria2c $aria2_multi_threaded https://huggingface.co/licyk/sd-upscaler-models/resolve/main/invokeai/RealESRGAN_x4plus.pth -d ./invokeai/models/core/upscaling/realesrgan -o RealESRGAN_x4plus.pth
        aria2c $aria2_multi_threaded https://huggingface.co/licyk/sd-upscaler-models/resolve/main/invokeai/RealESRGAN_x4plus_anime_6B.pth -d ./invokeai/models/core/upscaling/realesrgan -o RealESRGAN_x4plus_anime_6B.pth
        aria2c $aria2_multi_threaded https://huggingface.co/licyk/sd-upscaler-models/resolve/main/invokeai/ESRGAN_SRx4_DF2KOST_official-ff704c30.pth -d ./invokeai/models/core/upscaling/realesrgan -o ESRGAN_SRx4_DF2KOST_official-ff704c30.pth
        aria2c $aria2_multi_threaded https://huggingface.co/licyk/sd-upscaler-models/resolve/main/invokeai/RealESRGAN_x2plus.pth -d ./invokeai/models/core/upscaling/realesrgan -o RealESRGAN_x2plus.pth
        echo "安装结束"
        exit_venv
        print_line_to_shell
        invokeai_option
    else
        mainmenu
    fi
}