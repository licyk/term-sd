#!/bin/bash

#fooocus安装功能
function process_install_fooocus()
{
    #安装前的准备
    proxy_option #代理选择
    pytorch_version_select #pytorch选择
    pip_install_methon #安装方式选择
    final_install_check #安装前确认

    if [ $final_install_check_exec = 0 ];then
        #开始安装Fooocus
        print_line_to_shell "Fooocus 安装"
        term_sd_notice "开始安装Fooocus"
        tmp_disable_proxy #临时取消代理,避免一些不必要的网络减速
        git clone "$github_proxy"https://github.com/lllyasviel/Fooocus
        [ ! -d "./$term_sd_manager_info" ] && term_sd_notice "检测到"$term_sd_manager_info"框架安装失败,已终止安装进程" && sleep 3 && return 1 #防止继续进行安装导致文件散落,造成目录混乱
        if [ ! -d "./Fooocus/repositories" ];then
            mkdir ./Fooocus/repositories
        fi
        git clone "$github_proxy"https://github.com/comfyanonymous/ComfyUI ./Fooocus/repositories/ComfyUI-from-StabilityAI-Official
        cd ./Fooocus
        create_venv
        enter_venv
        cd ..

        if [ ! -z "$(echo $pytorch_install_version | awk '{gsub(/[=+]/, "")}1')" ];then
            "$pip_cmd" install $pytorch_install_version $pip_index_mirror $pip_extra_index_mirror $pip_find_mirror $force_pip $pip_install_methon_select --default-timeout=100 --retries 5
        fi
        "$pip_cmd" install -r ./Fooocus/requirements_versions.txt  --prefer-binary $pip_index_mirror $pip_extra_index_mirror $pip_find_mirror $force_pip $pip_install_methon_select --default-timeout=100 --retries 5

        term_sd_notice "下载模型中"
        tmp_enable_proxy #恢复原有的代理,保证能从huggingface下载模型
        aria2c $aria2_multi_threaded https://huggingface.co/stabilityai/stable-diffusion-xl-base-1.0/resolve/main/sd_xl_base_1.0_0.9vae.safetensors -d ./Fooocus/models/checkpoints/ -o sd_xl_base_1.0_0.9vae.safetensors
        aria2c $aria2_multi_threaded https://huggingface.co/stabilityai/stable-diffusion-xl-refiner-1.0/resolve/main/sd_xl_refiner_1.0_0.9vae.safetensors -d ./Fooocus/models/checkpoints/ -o sd_xl_refiner_1.0_0.9vae.safetensors
        aria2c $aria2_multi_threaded https://huggingface.co/lllyasviel/fooocus_inpaint/resolve/main/inpaint.fooocus.patch -d ./Fooocus/models/inpaint/ -o inpaint.fooocus.patch
        aria2c $aria2_multi_threaded https://huggingface.co/lllyasviel/misc/resolve/main/fooocus_expansion.bin -d ./Fooocus/models/prompt_expansion/fooocus_expansion/ -o pytorch_model.bin

        term_sd_notice "安装结束"
        exit_venv
        print_line_to_shell
        fooocus_option
    else
        mainmenu
    fi
}