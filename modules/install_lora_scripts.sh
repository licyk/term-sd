#!/bin/bash

#lora-scipts安装处理部分
function process_install_lora_scripts()
{
    #安装前的准备
    proxy_option #代理选择
    pytorch_version_select #pytorch选择
    pip_install_methon #安装方式选择
    final_install_check #安装前确认

    if [ $final_install_check_exec = 0 ];then
        #参考lora-scripts里的install.bash写的
        print_line_to_shell "lora-scipts 安装"
        term_sd_notice "开始安装lora-scipts"
        tmp_disable_proxy #临时取消代理,避免一些不必要的网络减速
        git clone "$github_proxy"https://github.com/Akegarasu/lora-scripts #lora-scripts本体
        [ ! -d "./$term_sd_manager_info" ] && term_sd_notice "检测到"$term_sd_manager_info"框架安装失败,已终止安装进程" && sleep 3 && return 1 #防止继续进行安装导致文件散落,造成目录混乱
        git clone "$github_proxy"https://github.com/kohya-ss/sd-scripts ./lora-scripts/sd-scripts #lora-scripts后端
        git clone "$github_proxy"https://github.com/hanamizuki-ai/lora-gui-dist ./lora-scripts/frontend #lora-scripts前端
        cd ./lora-scripts
        git submodule init
        git submodule update
        git submodule
        create_venv
        enter_venv
        if [ ! -z "$(echo $pytorch_install_version | awk '{gsub(/[=+]/, "")}1')" ];then
            "$pip_cmd" install $pytorch_install_version $pip_index_mirror $pip_extra_index_mirror $pip_find_mirror $force_pip $pip_install_methon_select --default-timeout=100 --retries 5
        fi
        cd ./sd-scripts
        "$pip_cmd" install $pip_index_mirror $pip_extra_index_mirror $pip_find_mirror $force_pip $pip_install_methon_select --upgrade -r requirements.txt --default-timeout=100 --retries 5 #sd-scripts目录下还有个_typos.toml,在安装requirements.txt里的依赖时会指向这个文件
        cd ..
        "$pip_cmd" install $pip_index_mirror $pip_extra_index_mirror $pip_find_mirror $force_pip $pip_install_methon_select --upgrade lion-pytorch dadaptation prodigyopt lycoris-lora fastapi uvicorn wandb scipy --default-timeout=100 --retries 5
        "$pip_cmd" install $pip_index_mirror $pip_extra_index_mirror $pip_find_mirror $force_pip $pip_install_methon_select --upgrade -r requirements.txt --default-timeout=100 --retries 5 #lora-scripts安装依赖
        cd ..
        tmp_enable_proxy #恢复原有的代理,保证能从huggingface下载模型
        aria2c $aria2_multi_threaded https://huggingface.co/runwayml/stable-diffusion-v1-5/resolve/main/v1-5-pruned-emaonly.ckpt -d ./lora-scripts/sd-models/ -o model.ckpt
        term_sd_notice "安装结束"
        exit_venv
        print_line_to_shell
        lora_scripts_option
    else
        mainmenu
    fi
}