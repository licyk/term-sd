#!/bin/bash

# SD WebUI 虚拟环境重构功能
# 使用 TERM_SD_MANAGE_OBJECT 全局变量显示要管理的 AI 软件名
# 使用 GITHUB_MIRROR 全局变量来使用 Github 镜像源
sd_webui_venv_rebuild() {
    # 安装前的准备
    download_mirror_select # 下载镜像源选择
    pytorch_version_select # pytorch版本选择
    pip_install_mode_select # 安装方式选择

    if term_sd_install_confirm "是否重新构建 Stable-Diffusion-WebUI 的虚拟环境 ?"; then
        term_sd_print_line "${TERM_SD_MANAGE_OBJECT} 虚拟环境重建"
        term_sd_tmp_disable_proxy
        term_sd_echo "开始重新构建 Stable-Diffusion-WebUI 的虚拟环境"
        term_sd_echo "删除原有虚拟环境中"
        rm -rf venv
        term_sd_echo "删除完成"
        create_venv
        enter_venv

        install_pytorch # 安装 PyTorch
        install_python_package git+$(git_format_repository_url "${GITHUB_MIRROR}" https://github.com/openai/CLIP)
        install_python_package -r requirements.txt # 安装stable-diffusion-webui的依赖

        term_sd_echo "重新构建 Stable-Diffusion-WebUI 的虚拟环境结束"
        exit_venv
        term_sd_tmp_enable_proxy
        term_sd_pause
    fi
    clean_install_config # 清理安装参数
}

# ComfyUI 虚拟环境重构功能
# 使用 TERM_SD_MANAGE_OBJECT 全局变量显示要管理的 AI 软件名
comfyui_venv_rebuild() {
    # 安装前的准备
    download_mirror_select # 下载镜像源选择
    pytorch_version_select # pytorch版本选择
    pip_install_mode_select # 安装方式选择

    if term_sd_install_confirm "是否重新构建 ComfyUI 的虚拟环境 ?"; then
        term_sd_print_line "${TERM_SD_MANAGE_OBJECT} 虚拟环境重建"
        term_sd_tmp_disable_proxy
        term_sd_echo "开始重新构建 ComfyUI 的虚拟环境"
        term_sd_echo "删除原有虚拟环境中"
        rm -rf venv
        term_sd_echo "删除完成"
        create_venv
        enter_venv

        install_pytorch # 安装 PyTorch
        install_python_package -r requirements.txt

        term_sd_echo "重新构建 ComfyUI 的虚拟环境结束"
        exit_venv
        term_sd_tmp_enable_proxy
        term_sd_pause
    fi
    clean_install_config # 清理安装参数
}

# InvokeAI 虚拟环境重构功能
# 使用 TERM_SD_MANAGE_OBJECT 全局变量显示要管理的 AI 软件名
invokeai_venv_rebuild() {
    # 安装前的准备
    download_mirror_select # 下载镜像源选择
    pytorch_version_select # pytorch版本选择
    pip_install_mode_select # 安装方式选择

    if term_sd_install_confirm "是否重新构建 InvokeAI 的虚拟环境 ?"; then
        term_sd_print_line "${TERM_SD_MANAGE_OBJECT} 虚拟环境重建"
        term_sd_tmp_disable_proxy
        term_sd_echo "开始重新构建 InvokeAI 的虚拟环境"
        term_sd_echo "删除原有虚拟环境中"
        rm -rf venv
        term_sd_echo "删除完成"
        create_venv
        enter_venv

        install_pytorch # 安装 PyTorch
        install_python_package invokeai

        term_sd_echo "重新构建 InvokeAI 的虚拟环境结束"
        exit_venv
        term_sd_tmp_enable_proxy
        term_sd_pause
    fi
    clean_install_config # 清理安装参数
}

# Fooocus 虚拟环境重建功能
# 使用 TERM_SD_MANAGE_OBJECT 全局变量显示要管理的 AI 软件名
fooocus_venv_rebuild() {
    # 安装前的准备
    download_mirror_select # 下载镜像源选择
    pytorch_version_select # pytorch版本选择
    pip_install_mode_select # 安装方式选择

    if term_sd_install_confirm "是否重新构建 Fooocus 的虚拟环境 ?"; then
        term_sd_print_line "${TERM_SD_MANAGE_OBJECT} 虚拟环境重建"
        term_sd_tmp_disable_proxy
        term_sd_echo "开始重新构建 Fooocus 的虚拟环境"
        term_sd_echo "删除原有虚拟环境中"
        rm -rf venv
        term_sd_echo "删除完成"
        create_venv
        enter_venv

        install_pytorch # 安装 PyTorch
        install_python_package --upgrade -r requirements_versions.txt

        term_sd_echo "重新构建 Fooocus 的虚拟环境结束"
        exit_venv
        term_sd_tmp_enable_proxy
        term_sd_pause
    fi
    clean_install_config # 清理安装参数
}

# lora-scripts 虚拟环境重构功能
# 使用 TERM_SD_MANAGE_OBJECT 全局变量显示要管理的 AI 软件名
lora_scripts_venv_rebuild() {
    # 安装前的准备
    download_mirror_select # 下载镜像源选择
    pytorch_version_select # pytorch版本选择
    pip_install_mode_select # 安装方式选择

    if term_sd_install_confirm "是否重新构建 lora-scripts 的虚拟环境 ?"; then
        term_sd_print_line "${TERM_SD_MANAGE_OBJECT} 虚拟环境重建"
        term_sd_tmp_disable_proxy
        term_sd_echo "开始重新构建 lora-scripts 的虚拟环境"
        term_sd_echo "删除原有虚拟环境中"
        rm -rf venv
        term_sd_echo "删除完成"
        create_venv
        enter_venv

        install_pytorch # 安装 PyTorch
        cd sd-scripts
        install_python_package --upgrade -r requirements.txt # sd-scripts 目录下还有个 _typos.toml, 在安装 requirements.txt 里的依赖时会指向这个文件
        cd ..
        install_python_package --upgrade -r requirements.txt # lora-scripts 安装依赖

        term_sd_echo "重新构建 lora-scripts 的虚拟环境结束"
        exit_venv
        term_sd_tmp_enable_proxy
        term_sd_pause
    fi
    clean_install_config # 清理安装参数
}

# kohya_ss 虚拟环境重建功能
# 使用 TERM_SD_MANAGE_OBJECT 全局变量显示要管理的 AI 软件名
kohya_ss_venv_rebuild() {
    # 安装前的准备
    download_mirror_select # 下载镜像源选择
    pytorch_version_select # pytorch版本选择
    pip_install_mode_select # 安装方式选择

    if term_sd_install_confirm "是否重新构建 kohya_ss 的虚拟环境 ?"; then
        term_sd_print_line "${TERM_SD_MANAGE_OBJECT} 虚拟环境重建"
        term_sd_tmp_disable_proxy
        term_sd_echo "开始重新构建 kohya_ss 的虚拟环境"
        term_sd_echo "删除原有虚拟环境中"
        rm -rf venv
        term_sd_echo "删除完成"
        create_venv
        enter_venv

        install_pytorch # 安装 PyTorch
        cd sd-scripts
        install_python_package --upgrade -r requirements.txt # sd-scripts 目录下还有个 _typos.toml, 在安装 requirements.txt 里的依赖时会指向这个文件
        cd ..
        install_python_package --upgrade -r requirements.txt # kohya_ss 安装依赖

        term_sd_echo "重新构建 kohya_ss 的虚拟环境结束"
        exit_venv
        term_sd_tmp_enable_proxy
        term_sd_pause
    fi
    clean_install_config # 清理安装参数
}