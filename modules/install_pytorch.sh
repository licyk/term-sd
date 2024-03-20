#!/bin/bash

# pytorch重装
pytorch_reinstall()
{
    if (dialog --erase-on-exit --title "Term-SD" --backtitle "PyTorch重装选项" --yes-label "是" --no-label "否" --yesno "是否重新安装PyTorch?" $term_sd_dialog_height $term_sd_dialog_width);then
        # 安装前的准备
        download_mirror_select # 下载镜像源选择
        pytorch_version_select # pytorch版本选择
        pip_install_mode_select # 安装方式选择
        pip_force_reinstall_select # 强制重装选择
        term_sd_install_confirm "是否重新安装PyTorch?" # 安装前确认

        if [ $? = 0 ];then
            # 开始安装pytorch
            term_sd_print_line "PyTorch安装"
            term_sd_tmp_disable_proxy
            create_venv
            enter_venv
            install_pytorch
            exit_venv
            term_sd_tmp_enable_proxy
            term_sd_echo "PyTorch安装结束"
            term_sd_pause
        fi
    fi
}

# pytorch安装
install_pytorch()
{
    # local ipex_win_url_1="https://gitcode.net/rubble7343/nuullll-intel-extension-for-pytorch/-/raw/master/torch-2.0.0a0+gite9ebda2-cp310-cp310-win_amd64.whl https://gitcode.net/rubble7343/nuullll-intel-extension-for-pytorch/-/raw/master/torchvision-0.15.2a0+fa99a53-cp310-cp310-win_amd64.whl https://gitcode.net/rubble7343/nuullll-intel-extension-for-pytorch/-/raw/master/intel_extension_for_pytorch-2.0.110+gitc6ea20b-cp310-cp310-win_amd64.whl"
    # local ipex_win_url_2="https://gitcode.net/rubble7343/nuullll-intel-extension-for-pytorch/-/raw/master/torch-2.1.0a0+cxx11.abi-cp310-cp310-win_amd64.whl https://gitcode.net/rubble7343/nuullll-intel-extension-for-pytorch/-/raw/master/torchvision-0.16.0a0+cxx11.abi-cp310-cp310-win_amd64.whl https://gitcode.net/rubble7343/nuullll-intel-extension-for-pytorch/-/raw/master/intel_extension_for_pytorch-2.1.10+xpu-cp310-cp310-win_amd64.whl"
    # local ipex_win_url_3="https://gitcode.net/rubble7343/nuullll-intel-extension-for-pytorch/-/raw/master/torch-2.1.0a0+cxx11.abi-cp311-cp311-win_amd64.whl https://gitcode.net/rubble7343/nuullll-intel-extension-for-pytorch/-/raw/master/torchvision-0.16.0a0+cxx11.abi-cp311-cp311-win_amd64.whl https://gitcode.net/rubble7343/nuullll-intel-extension-for-pytorch/-/raw/master/intel_extension_for_pytorch-2.1.10+xpu-cp311-cp311-win_amd64.whl"
    local ipex_win_url="--find-links https://www.modelscope.cn/api/v1/studio/hanamizukiai/resolver/gradio/pypi-index/torch.html"
    local ipex_url="--find-links https://pytorch-extension.intel.com/release-whl/stable/xpu/us"
    local torch_ipex_ver
    local torch_ver
    local xformers_ver
    if [ ! -z "$pytorch_install_version" ];then
        if grep ipex <<<$pytorch_install_version > /dev/null 2>&1 ;then
            torch_ipex_ver=$(echo $pytorch_install_version | awk '{print$2}')
            case $OS in
                Windows_NT)
                    case $torch_ipex_ver in
                        2.0.0)
                            term_sd_try term_sd_pip install torch==2.0.0a0+gite9ebda2 torchvision==0.15.2a0+fa99a53 intel_extension_for_pytorch==2.0.110+gitc6ea20b $pip_index_mirror $pip_extra_index_mirror $pip_find_mirror $ipex_win_url $pip_break_system_package $pip_install_mode $pip_force_reinstall_mode --prefer-binary
                            ;;
                        2.1.0)
                            term_sd_try term_sd_pip install torch==2.1.0a0+cxx11.abi torchvision==0.16.0a0+cxx11.abi intel_extension_for_pytorch==2.1.10+xpu $pip_index_mirror $pip_extra_index_mirror $pip_find_mirror $ipex_win_url $pip_break_system_package $pip_install_mode $pip_force_reinstall_mode --prefer-binary
                            ;;
                    esac
                    ;;
                *)
                    case $torch_ipex_ver in
                        2.0.0)
                            term_sd_try term_sd_pip install torch==2.0.1a0 torchvision==0.15.2a0 intel-extension-for-pytorch $pip_index_mirror $pip_extra_index_mirror $pip_find_mirror $ipex_url $pip_break_system_package $pip_install_mode $pip_force_reinstall_mode --prefer-binary
                            ;;
                        2.1.0)
                            term_sd_try term_sd_pip install torch==2.1.0a0 torchvision==0.16.0a0 intel-extension-for-pytorch $pip_index_mirror $pip_extra_index_mirror $pip_find_mirror $ipex_url $pip_break_system_package $pip_install_mode $pip_force_reinstall_mode --prefer-binary
                            ;;
                    esac
                ;;
            esac
        else
            torch_ver=$(echo $pytorch_install_version | awk '{print $1 " " $2}')
            xformers_ver=$(echo $pytorch_install_version | awk '{print $3}')
            # 安装PyTorch
            term_sd_try term_sd_pip install $torch_ver $pip_index_mirror $pip_extra_index_mirror $pip_find_mirror $pip_break_system_package $pip_install_mode $pip_force_reinstall_mode --prefer-binary
            [ ! $? = 0 ] && return 1
            # 安装xFormers
            if [ ! -z "$xformers_ver" ];then
                if [ $use_pip_mirror = 0 ];then # 镜像源
                    if grep cu121 <<<$pytorch_install_version > /dev/null 2>&1 ;then # cuda12.1
                        PIP_EXTRA_INDEX_URL="https://mirror.sjtu.edu.cn/pytorch-wheels/cu121" \
                        PIP_FIND_LINKS="https://mirror.sjtu.edu.cn/pytorch-wheels/cu121/torch_stable.html" \
                        term_sd_try term_sd_pip install $xformers_ver $pip_index_mirror $pip_break_system_package $pip_install_mode $pip_force_reinstall_mode --prefer-binary
                    else # cuda<12.1
                        term_sd_try term_sd_pip install $xformers_ver $pip_index_mirror $pip_extra_index_mirror $pip_find_mirror $pip_break_system_package $pip_install_mode $pip_force_reinstall_mode --prefer-binary
                    fi
                    [ ! $? = 0 ] && return 1
                else # 官方源
                    if grep cu121 <<<$pytorch_install_version > /dev/null 2>&1 ;then # cuda12.1
                        PIP_EXTRA_INDEX_URL="https://download.pytorch.org/whl/cu121" \
                        PIP_FIND_LINKS="https://download.pytorch.org/whl/cu121/torch_stable.html" \
                        term_sd_try term_sd_pip install $xformers_ver $pip_index_mirror $pip_break_system_package $pip_install_mode $pip_force_reinstall_mode --prefer-binary
                    else # cuda<12.1
                        term_sd_try term_sd_pip install $xformers_ver $pip_index_mirror $pip_extra_index_mirror $pip_find_mirror $pip_break_system_package $pip_install_mode $pip_force_reinstall_mode --prefer-binary
                    fi
                    [ ! $? = 0 ] && return 1
                fi
            fi
        fi
    else
        term_sd_echo "未指定PyTorch版本,跳过安装"
    fi
}