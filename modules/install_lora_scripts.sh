#!/bin/bash

#lora-scipts安装处理部分
function process_install_lora_scripts()
{
    #安装前的准备
    proxy_option #代理选择
    pytorch_version_select #pytorch选择
    pip_install_methon #安装方式选择
    final_install_check #安装前确认

    #参考lora-scripts里的install.bash写的
    echo "开始安装lora-scipts"
    git clone "$github_proxy"https://github.com/Akegarasu/lora-scripts.git #lora-scripts本体
    git clone "$github_proxy"https://github.com/kohya-ss/sd-scripts.git ./lora-scripts/sd-scripts #lora-scripts后端
    git clone "$github_proxy"https://github.com/hanamizuki-ai/lora-gui-dist ./lora-scripts/frontend #lora-scripts前端
    cd ./lora-scripts
    git submodule init
    git submodule update
    git submodule
    create_venv
    enter_venv
    pip install $pytorch_install_version $pip_mirror $extra_pip_mirror $force_pip $pip_install_methon_select --default-timeout=100 --retries 5
    cd ./sd-scripts
    pip install $pip_mirror $extra_pip_mirror $force_pip $pip_install_methon_select --upgrade -r requirements.txt --default-timeout=100 --retries 5 #sd-scripts目录下还有个_typos.toml,在安装requirements.txt里的依赖时会指向这个文件
    cd ..
    pip install $pip_mirror $extra_pip_mirror $force_pip $pip_install_methon_select --upgrade lion-pytorch dadaptation prodigyopt lycoris-lora fastapi uvicorn wandb scipy --default-timeout=100 --retries 5
    pip install $pip_mirror $extra_pip_mirror $force_pip $pip_install_methon_select --upgrade -r requirements.txt --default-timeout=100 --retries 5 #lora-scripts安装依赖
    cd ..
    aria2c $aria2_multi_threaded https://huggingface.co/runwayml/stable-diffusion-v1-5/resolve/main/v1-5-pruned-emaonly.ckpt -d ./lora-scripts/sd-models/ -o model.ckpt
    echo "安装结束"
    exit_venv
}