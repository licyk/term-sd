#/bin/bash

#invokeai安装处理部分
function process_install_invokeai()
{
    #安装前准备
    proxy_option #代理选择
    pytorch_version_select #pytorch选择
    pip_install_methon #安装方式选择
    final_install_check #安装前确认

    #开始安装invokeai
    echo "开始安装invokeai"
    if [ ! -d "./InvokeAI" ];then
        mkdir InvokeAI
    fi
    cd ./InvokeAI
    create_venv
    enter_venv
    if [ ! -d "./invokeai" ];then
        mkdir ./invokeai
    fi
    pip install invokeai $pytorch_install_version $pip_mirror $extra_pip_mirror $force_pip $pip_install_methon_select --default-timeout=100 --retries 5
    aria2c $aria2_multi_threaded https://huggingface.co/licyk/sd-upscaler-models/resolve/main/invokeai/RealESRGAN_x4plus.pth -d ./invokeai/models/core/upscaling/realesrgan -o RealESRGAN_x4plus.pth
    aria2c $aria2_multi_threaded https://huggingface.co/licyk/sd-upscaler-models/resolve/main/invokeai/RealESRGAN_x4plus_anime_6B.pth -d ./invokeai/models/core/upscaling/realesrgan -o RealESRGAN_x4plus_anime_6B.pth
    aria2c $aria2_multi_threaded https://huggingface.co/licyk/sd-upscaler-models/resolve/main/invokeai/ESRGAN_SRx4_DF2KOST_official-ff704c30.pth -d ./invokeai/models/core/upscaling/realesrgan -o ESRGAN_SRx4_DF2KOST_official-ff704c30.pth
    aria2c $aria2_multi_threaded https://huggingface.co/licyk/sd-upscaler-models/resolve/main/invokeai/RealESRGAN_x2plus.pth -d ./invokeai/models/core/upscaling/realesrgan -o RealESRGAN_x2plus.pth
    echo "安装结束"
    exit_venv
}