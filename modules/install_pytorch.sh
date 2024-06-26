#!/bin/bash

# pytorch重装
pytorch_reinstall()
{
    if (dialog --erase-on-exit \
        --title "Term-SD" \
        --backtitle "PyTorch 重装选项" \
        --yes-label "是" --no-label "否" \
        --yesno "是否重新安装 PyTorch ?" \
        $term_sd_dialog_height $term_sd_dialog_width) then

        # 安装前的准备
        download_mirror_select # 下载镜像源选择
        pytorch_version_select # pytorch版本选择
        pip_install_mode_select # 安装方式选择
        pip_force_reinstall_select # 强制重装选择
        term_sd_install_confirm "是否重新安装 PyTorch ?" # 安装前确认

        if [ $? = 0 ];then
            # 开始安装pytorch
            term_sd_print_line "PyTorch 安装"
            term_sd_tmp_disable_proxy
            create_venv
            enter_venv
            install_pytorch
            exit_venv
            term_sd_tmp_enable_proxy
            term_sd_echo "PyTorch 安装结束"
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
    # local ipex_win_url="--find-links https://www.modelscope.cn/api/v1/studio/hanamizukiai/resolver/gradio/pypi-index/torch.html"
    local ipex_win_url
    local ipex_url_cn="--extra-index-url https://pytorch-extension.intel.com/release-whl/stable/xpu/cn"
    local ipex_url_us="--extra-index-url https://pytorch-extension.intel.com/release-whl/stable/xpu/us"
    local torch_ipex_ver
    local torch_ver
    local xformers_ver
    local ipex_type
    if [ ! -z "$pytorch_install_version" ];then
        if grep ipex <<<$pytorch_install_version &> /dev/null ;then
            torch_ipex_ver=$(echo $pytorch_install_version | awk '{print$2}')
            if grep "Core_Ultra" <<<$pytorch_install_version &> /dev/null ;then
                ipex_type="Core_Ultra"
            else
                ipex_type="Arc"
            fi
            pytorch_install_version= # 清除PyTorch版本选择
            term_sd_echo "将要安装的 PyTorch 版本组合:"
            term_sd_echo "PyTorch: PyTorch IPEX $torch_ipex_ver $ipex_type"
            term_sd_echo "开始安装 PyTorch"
            if is_windows_platform ;then
                # Windows平台
                # IPEX(Windows): https://arc.nuullll.com/resource/
                case $HF_ENDPOINT in # 选择镜像源
                    "https://hf-mirror.com")
                        ipex_win_url="--find-links https://licyk.github.io/t/pypi/index_hf_mirror.html"
                        ;;
                    "https://huggingface.sukaka.top")
                        ipex_win_url="--find-links https://licyk.github.io/t/pypi/index_sk_mirror.html"
                        ;;
                    *)
                        ipex_win_url="--find-links https://licyk.github.io/t/pypi/index.html"
                        ;;
                esac
                    
                case $torch_ipex_ver in
                    2.0.0)
                        install_python_package torch==2.0.0a0+gite9ebda2 torchvision==0.15.2a0+fa99a53 intel_extension_for_pytorch==2.0.110+gitc6ea20b $ipex_win_url
                        ;;
                    2.1.0)
                        if [ $ipex_type = "Core_Ultra" ] ;then # 核显
                            install_python_package torch==2.1.0a0+git7bcf7da torchvision==0.16.0+fbb4cc5 torchaudio==2.1.0+6ea1133 intel_extension_for_pytorch==2.1.20+git4849f3b $ipex_win_url
                        else # 独显
                            install_python_package torch==2.1.0a0+cxx11.abi torchvision==0.16.0a0+cxx11.abi torchaudio==2.1.0a0+cxx11.abi intel_extension_for_pytorch==2.1.10+xpu $ipex_win_url
                        fi
                        ;;
                esac
            else
                # 其他平台
                # IPEX: https://intel.github.io/intel-extension-for-pytorch/#installation
                if [ $use_pip_mirror = 0 ];then # 国内镜像
                    case $torch_ipex_ver in
                        2.0.0)
                            install_python_package torch==2.0.1a0 torchvision==0.15.2a0 intel-extension-for-pytorch==2.0.120+xpu $ipex_url_cn
                            ;;
                        2.1.0)
                            install_python_package torch==2.1.0.post0 torchvision==0.16.0.post0 torchaudio==2.1.0.post0 intel-extension-for-pytorch==2.1.20 $ipex_url_cn
                            ;;
                    esac
                else
                    case $torch_ipex_ver in
                        2.0.0)
                            install_python_package torch==2.0.1a0 torchvision==0.15.2a0 intel-extension-for-pytorch==2.0.120+xpu $ipex_url_us
                            ;;
                        2.1.0)
                            install_python_package torch==2.1.0.post0 torchvision==0.16.0.post0 torchaudio==2.1.0.post0 intel-extension-for-pytorch==2.1.20 $ipex_url_us                            ;;
                    esac
                fi
            fi
            if [ $? = 0 ];then
                term_sd_echo "PyTorch 安装成功"
            else
                term_sd_echo "PyTorch 安装失败"
                return 1
            fi
        else
            torch_ver=$(echo $pytorch_install_version | awk '{print $1 " " $2 " " $3}')
            xformers_ver=$(echo $pytorch_install_version | awk '{print $4}')
            term_sd_echo "将要安装的 PyTorch 版本组合:"
            term_sd_echo "PyTorch: $torch_ver"
            term_sd_echo "xFormers: $([ ! -z "$xformers_ver" ] && echo $xformers_ver || echo "无")"
            pytorch_install_version= # 清除PyTorch版本选择
            # 安装PyTorch
            term_sd_echo "开始安装 PyTorch"
            install_python_package $torch_ver
            if [ $? = 0 ];then
                term_sd_echo "PyTorch 安装成功"
            else
                term_sd_echo "PyTorch 安装失败, 未进行安装 xFormers"
                return 1
            fi
            # 安装xFormers
            if [ ! -z "$xformers_ver" ];then
                if term_sd_pip freeze | grep -q xformers ;then # 将原有的xFormers卸载
                    term_sd_echo "卸载原有版本的 xFormers"
                    term_sd_try term_sd_pip uninstall xformers -y
                fi
                term_sd_echo "开始安装 xFormers"

                if [ $use_pip_mirror = 0 ];then # 镜像源
                    if grep cu121 <<<$torch_ver &> /dev/null ;then # cuda12.1
                        PIP_EXTRA_INDEX_URL="https://mirror.sjtu.edu.cn/pytorch-wheels/cu121" \
                        PIP_FIND_LINKS="https://mirror.sjtu.edu.cn/pytorch-wheels/cu121/torch_stable.html" \
                        term_sd_try term_sd_pip install $xformers_ver $pip_index_mirror $pip_break_system_package $pip_install_mode $pip_force_reinstall_mode --prefer-binary --no-deps
                    else # cuda<12.1
                        term_sd_try term_sd_pip install $xformers_ver $pip_index_mirror $pip_extra_index_mirror $pip_find_mirror $pip_break_system_package $pip_install_mode $pip_force_reinstall_mode --prefer-binary --no-deps
                    fi
                else # 官方源
                    if grep cu121 <<<$torch_ver &> /dev/null ;then # cuda12.1
                        PIP_EXTRA_INDEX_URL="https://download.pytorch.org/whl/cu121" \
                        PIP_FIND_LINKS="https://download.pytorch.org/whl/cu121/torch_stable.html" \
                        term_sd_try term_sd_pip install $xformers_ver $pip_index_mirror $pip_break_system_package $pip_install_mode $pip_force_reinstall_mode --prefer-binary --no-deps
                    else # cuda<12.1
                        term_sd_try term_sd_pip install $xformers_ver $pip_index_mirror $pip_extra_index_mirror $pip_find_mirror $pip_break_system_package $pip_install_mode $pip_force_reinstall_mode --prefer-binary --no-deps
                    fi
                fi
            fi
            if [ $? = 0 ];then
                term_sd_echo "xFormers 安装成功"
            else
                term_sd_echo "xFormers 安装失败"
                return 1
            fi
        fi
        
    else
        term_sd_echo "未指定 PyTorch 版本, 跳过安装"
    fi
}