#!/bin/bash

#a1111_sd_webui虚拟环境重构部分
function a1111_sd_webui_venv_rebuild()
{
    #安装前的准备
    proxy_option #代理选择
    pytorch_version_select #pytorch选择
    pip_install_methon #安装方式选择
    final_install_check #安装前确认

    if [ $final_install_check_exec = 0 ];then
        print_line_to_shell "$term_sd_manager_info 虚拟环境重建"
        tmp_disable_proxy
        term_sd_notice "开始重构虚拟环境"
        term_sd_notice "删除原有虚拟环境中"
        rm -rf ./venv
        term_sd_notice "删除完成"
        create_venv
        enter_venv

        pip_cmd install $pytorch_install_version $pip_index_mirror $pip_extra_index_mirror $pip_find_mirror $force_pip $pip_install_methon_select --default-timeout=100 --retries 5 #"--default-timeout=100 --retries 5"在网络差导致下载中断时重试下载
        pip_cmd install git+"$github_proxy"https://github.com/openai/CLIP.git --prefer-binary $pip_index_mirror $pip_extra_index_mirror $pip_find_mirror $force_pip $pip_install_methon_select --default-timeout=100 --retries 5
        pip_cmd install -r ./repositories/CodeFormer/requirements.txt --prefer-binary $pip_index_mirror $pip_extra_index_mirror $pip_find_mirror $force_pip $pip_install_methon_select --default-timeout=100 --retries 5
        pip_cmd install -r ./requirements.txt --prefer-binary $pip_index_mirror $pip_extra_index_mirror $pip_find_mirror $force_pip $pip_install_methon_select --default-timeout=100 --retries 5 #安装stable-diffusion-webui的依赖

        term_sd_notice "重构结束"
        exit_venv
        tmp_enable_proxy
        print_line_to_shell
    fi
}

#comfyui虚拟环境重构部分
function comfyui_venv_rebuild()
{
    #安装前的准备
    proxy_option #代理选择
    pytorch_version_select #pytorch选择
    pip_install_methon #安装方式选择
    final_install_check #安装前确认

    if [ $final_install_check_exec = 0 ];then
        print_line_to_shell "$term_sd_manager_info 虚拟环境重建"
        tmp_disable_proxy
        term_sd_notice "开始重构虚拟环境"
        term_sd_notice "删除原有虚拟环境中"
        rm -rf ./venv
        term_sd_notice "删除完成"
        create_venv
        enter_venv

        pip_cmd install $pytorch_install_version $pip_index_mirror $pip_extra_index_mirror $pip_find_mirror $force_pip $pip_install_methon_select --default-timeout=100 --retries 5
        pip_cmd install -r ./requirements.txt  --prefer-binary $pip_index_mirror $pip_extra_index_mirror $pip_find_mirror $force_pip $pip_install_methon_select --default-timeout=100 --retries 5

        term_sd_notice "重构结束"
        exit_venv
        tmp_enable_proxy
        print_line_to_shell
    fi
}

#invokeai虚拟环境重构部分
function invokeai_venv_rebuild()
{
    #安装前的准备
    proxy_option #代理选择
    pytorch_version_select #pytorch选择
    pip_install_methon #安装方式选择
    final_install_check #安装前确认

    if [ $final_install_check_exec = 0 ];then
        print_line_to_shell "$term_sd_manager_info 虚拟环境重建"
        tmp_disable_proxy
        term_sd_notice "开始重构虚拟环境"
        term_sd_notice "删除原有虚拟环境中"
        rm -rf ./venv
        term_sd_notice "删除完成"
        create_venv
        enter_venv

        pip_cmd install $pytorch_install_version $pip_index_mirror $pip_extra_index_mirror $pip_find_mirror $force_pip $pip_install_methon_select --default-timeout=100 --retries 5
        pip_cmd install invokeai $pip_index_mirror $pip_extra_index_mirror $pip_find_mirror $force_pip $pip_install_methon_select --default-timeout=100 --retries 5

        term_sd_notice "重构结束"
        exit_venv
        tmp_enable_proxy
        print_line_to_shell
    fi
}

#lora_scripts虚拟环境重构部分
function lora_scripts_venv_rebuild()
{
    #安装前的准备
    proxy_option #代理选择
    pytorch_version_select #pytorch选择
    pip_install_methon #安装方式选择
    final_install_check #安装前确认

    if [ $final_install_check_exec = 0 ];then
        print_line_to_shell "$term_sd_manager_info 虚拟环境重建"
        tmp_disable_proxy
        term_sd_notice "开始重构虚拟环境"
        term_sd_notice "删除原有虚拟环境中"
        rm -rf ./venv
        term_sd_notice "删除完成"
        create_venv
        enter_venv

        pip_cmd install $pytorch_install_version $pip_index_mirror $pip_extra_index_mirror $pip_find_mirror $force_pip $pip_install_methon_select --default-timeout=100 --retries 5
        cd ./sd-scripts
        pip_cmd install $pip_index_mirror $pip_extra_index_mirror $pip_find_mirror $force_pip $pip_install_methon_select --upgrade -r requirements.txt --default-timeout=100 --retries 5 #sd-scripts目录下还有个_typos.toml，在安装requirements.txt里的依赖时会指向这个文件
        cd ..
        pip_cmd install $pip_index_mirror $pip_extra_index_mirror $pip_find_mirror $force_pip $pip_install_methon_select --upgrade lion-pytorch dadaptation prodigyopt lycoris-lora fastapi uvicorn wandb scipy --default-timeout=100 --retries 5
        pip_cmd install $pip_index_mirror $pip_extra_index_mirror $pip_find_mirror $force_pip $pip_install_methon_select --upgrade -r requirements.txt --default-timeout=100 --retries 5 #lora-scripts安装依赖

        term_sd_notice "重构结束"
        exit_venv
        tmp_enable_proxy
        print_line_to_shell
    fi
}

#fooocus虚拟环境重建部分
function fooocus_venv_rebuild()
{
    #安装前的准备
    proxy_option #代理选择
    pytorch_version_select #pytorch选择
    pip_install_methon #安装方式选择
    final_install_check #安装前确认

    if [ $final_install_check_exec = 0 ];then
        print_line_to_shell "$term_sd_manager_info 虚拟环境重建"
        tmp_disable_proxy
        term_sd_notice "开始重构虚拟环境"
        term_sd_notice "删除原有虚拟环境中"
        rm -rf ./venv
        term_sd_notice "删除完成"
        create_venv
        enter_venv

        pip_cmd install $pytorch_install_version $pip_index_mirror $pip_extra_index_mirror $pip_find_mirror $force_pip $pip_install_methon_select --default-timeout=100 --retries 5
        pip_cmd install $pip_index_mirror $pip_extra_index_mirror $pip_find_mirror $force_pip $pip_install_methon_select --upgrade -r requirements_versions.txt --default-timeout=100 --retries 5

        term_sd_notice "重构结束"
        exit_venv
        tmp_enable_proxy
        print_line_to_shell
    fi
}