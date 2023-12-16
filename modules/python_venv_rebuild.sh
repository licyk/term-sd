#!/bin/bash

# sd-webui虚拟环境重构部分
sd_webui_venv_rebuild()
{
    # 安装前的准备
    download_mirror_select # 下载镜像源选择
    pytorch_version_select # pytorch版本选择
    pip_install_mode_select # 安装方式选择
    term_sd_install_confirm # 安装前确认

    if [ $? = 0 ];then
        term_sd_print_line "$term_sd_manager_info 虚拟环境重建"
        term_sd_tmp_disable_proxy
        term_sd_echo "开始重构虚拟环境"
        term_sd_echo "删除原有虚拟环境中"
        rm -rf venv
        term_sd_echo "删除完成"
        create_venv
        enter_venv

        install_pytorch # 安装pytorch #"--default-timeout=100 --retries 5"在网络差导致下载中断时重试下载
        term_sd_watch term_sd_pip install git+$(git_format_repository_url $github_mirror https://github.com/openai/CLIP) $pip_index_mirror $pip_extra_index_mirror $pip_find_mirror $pip_break_system_package $pip_install_mode --prefer-binary
        term_sd_watch term_sd_pip install -r repositories/CodeFormer/requirements.txt $pip_index_mirror $pip_extra_index_mirror $pip_find_mirror $pip_break_system_package $pip_install_mode --prefer-binary
        term_sd_watch term_sd_pip install -r requirements.txt $pip_index_mirror $pip_extra_index_mirror $pip_find_mirror $pip_break_system_package $pip_install_mode --prefer-binary #安装stable-diffusion-webui的依赖

        term_sd_echo "重构结束"
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
    term_sd_install_confirm # 安装前确认

    if [ $? = 0 ];then
        term_sd_print_line "$term_sd_manager_info 虚拟环境重建"
        term_sd_tmp_disable_proxy
        term_sd_echo "开始重构虚拟环境"
        term_sd_echo "删除原有虚拟环境中"
        rm -rf venv
        term_sd_echo "删除完成"
        create_venv
        enter_venv

        install_pytorch # 安装pytorch
        term_sd_watch term_sd_pip install -r requirements.txt $pip_index_mirror $pip_extra_index_mirror $pip_find_mirror $pip_break_system_package $pip_install_mode --prefer-binary

        term_sd_echo "重构结束"
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
    term_sd_install_confirm # 安装前确认

    if [ $? = 0 ];then
        term_sd_print_line "$term_sd_manager_info 虚拟环境重建"
        term_sd_tmp_disable_proxy
        term_sd_echo "开始重构虚拟环境"
        term_sd_echo "删除原有虚拟环境中"
        rm -rf venv
        term_sd_echo "删除完成"
        create_venv
        enter_venv

        install_pytorch # 安装pytorch
        term_sd_watch term_sd_pip install invokeai $pip_index_mirror $pip_extra_index_mirror $pip_find_mirror $pip_break_system_package $pip_install_mode --prefer-binary

        term_sd_echo "重构结束"
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
    term_sd_install_confirm # 安装前确认

    if [ $? = 0 ];then
        term_sd_print_line "$term_sd_manager_info 虚拟环境重建"
        term_sd_tmp_disable_proxy
        term_sd_echo "开始重构虚拟环境"
        term_sd_echo "删除原有虚拟环境中"
        rm -rf venv
        term_sd_echo "删除完成"
        create_venv
        enter_venv

        install_pytorch # 安装pytorch
        term_sd_watch term_sd_pip install $pip_index_mirror $pip_extra_index_mirror $pip_find_mirror $pip_break_system_package $pip_install_mode --prefer-binary --upgrade -r requirements_versions.txt

        term_sd_echo "重构结束"
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
    term_sd_install_confirm # 安装前确认

    if [ $? = 0 ];then
        term_sd_print_line "$term_sd_manager_info 虚拟环境重建"
        term_sd_tmp_disable_proxy
        term_sd_echo "开始重构虚拟环境"
        term_sd_echo "删除原有虚拟环境中"
        rm -rf venv
        term_sd_echo "删除完成"
        create_venv
        enter_venv

        install_pytorch # 安装pytorch
        cd sd-scripts
        term_sd_watch term_sd_pip install $pip_index_mirror $pip_extra_index_mirror $pip_find_mirror $pip_break_system_package $pip_install_mode --prefer-binary --upgrade -r requirements.txt # sd-scripts目录下还有个_typos.toml，在安装requirements.txt里的依赖时会指向这个文件
        cd ..
        term_sd_watch term_sd_pip install $pip_index_mirror $pip_extra_index_mirror $pip_find_mirror $pip_break_system_package $pip_install_mode --prefer-binary --upgrade lion-pytorch dadaptation prodigyopt lycoris-lora fastapi uvicorn wandb scipy
        term_sd_watch term_sd_pip install $pip_index_mirror $pip_extra_index_mirror $pip_find_mirror $pip_break_system_package $pip_install_mode --prefer-binary --upgrade -r requirements.txt # lora-scripts安装依赖
        if [ ! -z $OS ] && [ $OS = "Windows_NT" ];then # 如果是Windows系统则安装Windows版的bitsandbytes
            term_sd_watch term_sd_pip install bitsandbytes==0.41.1 --force-reinstall --index-url https://jihulab.com/api/v4/projects/140618/packages/pypi/simple $pip_extra_index_mirror $pip_find_mirror $pip_break_system_package $pip_install_mode
        fi

        term_sd_echo "重构结束"
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
    term_sd_install_confirm # 安装前确认

    if [ $? = 0 ];then
        term_sd_print_line "$term_sd_manager_info 虚拟环境重建"
        term_sd_tmp_disable_proxy
        term_sd_echo "开始重构虚拟环境"
        term_sd_echo "删除原有虚拟环境中"
        rm -rf venv
        term_sd_echo "删除完成"
        create_venv
        enter_venv

        install_pytorch # 安装pytorch
        term_sd_watch term_sd_pip install $pip_index_mirror $pip_extra_index_mirror $pip_find_mirror $pip_break_system_package $pip_install_mode --prefer-binary --upgrade lion-pytorch dadaptation prodigyopt lycoris-lora fastapi uvicorn wandb scipy bitsandbytes tensorflow tensorboard
        term_sd_watch term_sd_pip install $pip_index_mirror $pip_extra_index_mirror $pip_find_mirror $pip_break_system_package $pip_install_mode --prefer-binary --upgrade -r requirements.txt # kohya_ss安装依赖

        if [ ! -z $OS ] && [ $OS = "Windows_NT" ];then # 如果是Windows系统则安装Windows版的bitsandbytes
            term_sd_watch term_sd_pip install bitsandbytes==0.41.1 --force-reinstall --index-url https://jihulab.com/api/v4/projects/140618/packages/pypi/simple $pip_extra_index_mirror $pip_find_mirror $pip_break_system_package $pip_install_mode
        fi

        term_sd_echo "重构结束"
        exit_venv
        term_sd_tmp_enable_proxy
        term_sd_pause
    fi
}