#!/bin/bash

# sd-webui虚拟环境重构部分
sd_webui_venv_rebuild()
{
    # 安装前的准备
    download_mirror_select # 下载镜像源选择
    pytorch_version_select # pytorch版本选择
    pip_install_mode_select # 安装方式选择
    term_sd_install_confirm "是否重新构建 Stable-Diffusion-WebUI 的虚拟环境?" # 安装前确认

    if [ $? = 0 ];then
        term_sd_print_line "$term_sd_manager_info 虚拟环境重建"
        term_sd_tmp_disable_proxy
        term_sd_echo "开始重新构建 Stable-Diffusion-WebUI 的虚拟环境"
        term_sd_echo "删除原有虚拟环境中"
        rm -rf venv
        term_sd_echo "删除完成"
        create_venv
        enter_venv

        install_pytorch # 安装pytorch
        install_python_package git+$(git_format_repository_url $github_mirror https://github.com/openai/CLIP)
        install_python_package -r requirements.txt # 安装stable-diffusion-webui的依赖

        term_sd_echo "重新构建 Stable-Diffusion-WebUI 的虚拟环境结束"
        exit_venv
        term_sd_tmp_enable_proxy
        term_sd_pause
    fi
}

# comfyui虚拟环境重构部分
comfyui_venv_rebuild()
{
    # 安装前的准备
    download_mirror_select # 下载镜像源选择
    pytorch_version_select # pytorch版本选择
    pip_install_mode_select # 安装方式选择
    term_sd_install_confirm "是否重新构建 ComfyUI 的虚拟环境?" # 安装前确认

    if [ $? = 0 ];then
        term_sd_print_line "$term_sd_manager_info 虚拟环境重建"
        term_sd_tmp_disable_proxy
        term_sd_echo "开始重新构建 ComfyUI 的虚拟环境"
        term_sd_echo "删除原有虚拟环境中"
        rm -rf venv
        term_sd_echo "删除完成"
        create_venv
        enter_venv

        install_pytorch # 安装pytorch
        install_python_package -r requirements.txt

        term_sd_echo "重新构建 ComfyUI 的虚拟环境结束"
        exit_venv
        term_sd_tmp_enable_proxy
        term_sd_pause
    fi
}

# invokeai虚拟环境重构部分
invokeai_venv_rebuild()
{
    # 安装前的准备
    download_mirror_select # 下载镜像源选择
    pytorch_version_select # pytorch版本选择
    pip_install_mode_select # 安装方式选择
    term_sd_install_confirm "是否重新构建 InvokeAI 的虚拟环境?" # 安装前确认

    if [ $? = 0 ];then
        term_sd_print_line "$term_sd_manager_info 虚拟环境重建"
        term_sd_tmp_disable_proxy
        term_sd_echo "开始重新构建 InvokeAI 的虚拟环境"
        term_sd_echo "删除原有虚拟环境中"
        rm -rf venv
        term_sd_echo "删除完成"
        create_venv
        enter_venv

        install_pytorch # 安装pytorch
        install_python_package invokeai

        term_sd_echo "重新构建 InvokeAI 的虚拟环境结束"
        exit_venv
        term_sd_tmp_enable_proxy
        term_sd_pause
    fi
}

# fooocus虚拟环境重建部分
fooocus_venv_rebuild()
{
    # 安装前的准备
    download_mirror_select # 下载镜像源选择
    pytorch_version_select # pytorch版本选择
    pip_install_mode_select # 安装方式选择
    term_sd_install_confirm "是否重新构建 Fooocus 的虚拟环境?" # 安装前确认

    if [ $? = 0 ];then
        term_sd_print_line "$term_sd_manager_info 虚拟环境重建"
        term_sd_tmp_disable_proxy
        term_sd_echo "开始重新构建 Fooocus 的虚拟环境"
        term_sd_echo "删除原有虚拟环境中"
        rm -rf venv
        term_sd_echo "删除完成"
        create_venv
        enter_venv

        install_pytorch # 安装pytorch
        install_python_package --upgrade -r requirements_versions.txt

        term_sd_echo "重新构建 Fooocus 的虚拟环境结束"
        exit_venv
        term_sd_tmp_enable_proxy
        term_sd_pause
    fi
}

# lora_scripts虚拟环境重构部分
lora_scripts_venv_rebuild()
{
    # 安装前的准备
    download_mirror_select # 下载镜像源选择
    pytorch_version_select # pytorch版本选择
    pip_install_mode_select # 安装方式选择
    term_sd_install_confirm "是否重新构建 lora-scripts 的虚拟环境?" # 安装前确认

    if [ $? = 0 ];then
        term_sd_print_line "$term_sd_manager_info 虚拟环境重建"
        term_sd_tmp_disable_proxy
        term_sd_echo "开始重新构建 lora-scripts 的虚拟环境"
        term_sd_echo "删除原有虚拟环境中"
        rm -rf venv
        term_sd_echo "删除完成"
        create_venv
        enter_venv

        install_pytorch # 安装pytorch
        cd sd-scripts
        install_python_package --upgrade -r requirements.txt # sd-scripts目录下还有个_typos.toml，在安装requirements.txt里的依赖时会指向这个文件
        cd ..
        install_python_package --upgrade -r requirements.txt # lora-scripts安装依赖
        install_python_package --upgrade bitsandbytes

        term_sd_echo "重新构建 lora-scripts 的虚拟环境结束"
        exit_venv
        term_sd_tmp_enable_proxy
        term_sd_pause
    fi
}

# kohya_ss虚拟环境重建部分
kohya_ss_venv_rebuild()
{
    # 安装前的准备
    download_mirror_select # 下载镜像源选择
    pytorch_version_select # pytorch版本选择
    pip_install_mode_select # 安装方式选择
    term_sd_install_confirm "是否重新构建 kohya_ss 的虚拟环境?" # 安装前确认

    if [ $? = 0 ];then
        term_sd_print_line "$term_sd_manager_info 虚拟环境重建"
        term_sd_tmp_disable_proxy
        term_sd_echo "开始重新构建 kohya_ss 的虚拟环境"
        term_sd_echo "删除原有虚拟环境中"
        rm -rf venv
        term_sd_echo "删除完成"
        create_venv
        enter_venv

        install_pytorch # 安装pytorch
        cd sd-scripts
        install_python_package --upgrade -r requirements.txt # sd-scripts目录下还有个_typos.toml，在安装requirements.txt里的依赖时会指向这个文件
        cd ..
        install_python_package --upgrade -r requirements.txt # kohya_ss安装依赖
        install_python_package --upgrade bitsandbytes

        term_sd_echo "重新构建 kohya_ss 的虚拟环境结束"
        exit_venv
        term_sd_tmp_enable_proxy
        term_sd_pause
    fi
}