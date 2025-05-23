#!/bin/bash

# PyTorch 重装功能
pytorch_reinstall() {
    if (dialog --erase-on-exit \
        --title "Term-SD" \
        --backtitle "PyTorch 重装选项" \
        --yes-label "是" --no-label "否" \
        --yesno "是否重新安装 PyTorch ?" \
        $(get_dialog_size)); then

        # 安装前的准备
        enter_venv
        download_mirror_select # 下载镜像源选择
        pytorch_version_select # PyTorch 版本选择
        pip_install_mode_select # 安装方式选择

        if term_sd_install_confirm "是否重新安装 PyTorch ?"; then
            # 开始安装 PyTorch
            term_sd_print_line "PyTorch 安装"
            term_sd_tmp_disable_proxy
            install_pytorch
            term_sd_tmp_enable_proxy
            clean_install_config # 清理安装参数
            term_sd_echo "PyTorch 安装结束"
            term_sd_pause
        else
            clean_install_config # 清理安装参数
        fi

        exit_venv
    fi
}

# PyTorch 安装
# 使用 INSTALL_PYTORCH_VERSION 全局变量读取需要安装的 PyTorch 版本
# 使用 PYTORCH_TYPE 判断 PyTorch 种类, 用于切换 PyTorch 镜像源
install_pytorch() {
    if [[ ! -z "${INSTALL_PYTORCH_VERSION}" ]]; then
        # 检测是否使用 PyTorch IPEX 版本
        case "${PYTORCH_TYPE}" in
            ipex|ipex_legacy_arc|ipex_legacy_core_ultra)
                process_pytorch_ipex
                ;;
            *)
                process_pytorch
                ;;
        esac
    else
        term_sd_echo "未指定 PyTorch 版本, 跳过安装"
    fi
}

# 处理 PyTorch IPEX 的安装
# 使用 INSTALL_PYTORCH_VERSION 全局变量读取需要安装的 PyTorch 版本
# 使用 PYTORCH_TYPE 判断 PyTorch 种类, 用于切换 PyTorch 镜像源
# 接受 Pip 参数:
# PIP_INDEX_MIRROR PIP_EXTRA_INDEX_MIRROR PIP_FIND_LINKS_MIRROR
# PIP_BREAK_SYSTEM_PACKAGE_ARG PIP_USE_PEP517_ARG PIP_FORCE_REINSTALL_ARG
# PIP_UPDATE_PACKAGE_ARG
process_pytorch_ipex() {
    local torch_ipex_ver
    local torch_ipex_ver_info
    local ipex_type
    local torch_ver
    local ipex_win_url="--find-links https://licyk.github.io/t/pypi/index.html"
    local ipex_url_cn="--extra-index-url https://pytorch-extension.intel.com/release-whl/stable/xpu/cn"
    local ipex_url_us="--extra-index-url https://pytorch-extension.intel.com/release-whl/stable/xpu/us"

    if [[ "${PYTORCH_TYPE}" == "ipex_legacy_core_ultra" ]]; then
        ipex_type="Core_Ultra"
    elif [[ "${PYTORCH_TYPE}" == "ipex_legacy_arc" ]]; then
        ipex_type="Arc"
    else
        ipex_type="Core_Ultra"
    fi

    case "${PYTORCH_TYPE}" in
        ipex_legacy_arc|ipex_legacy_core_ultra)
            torch_ipex_ver=$(awk '{print $2}' <<< ${INSTALL_PYTORCH_VERSION})
            torch_ipex_ver_info="PyTorch $(awk '{print $2}' <<< ${INSTALL_PYTORCH_VERSION}) (IPEX ${ipex_type})"
            ;;
        ipex)
            torch_ipex_ver_info="${INSTALL_PYTORCH_VERSION} (Inter XPU)"
            ;;
    esac

    torch_ver=$INSTALL_PYTORCH_VERSION

    term_sd_echo "将要安装的 PyTorch 版本组合:"
    term_sd_echo "PyTorch: ${torch_ipex_ver_info}"
    term_sd_echo "开始安装 PyTorch"

    case "${PYTORCH_TYPE}" in
        ipex_legacy_arc|ipex_legacy_core_ultra)
            if is_windows_platform; then
                # Windows 平台
                # IPEX(Windows): https://arc.nuullll.com/resource/

                case "${torch_ipex_ver}" in
                    2.0.0)
                        install_python_package torch==2.0.0a0+gite9ebda2 torchvision==0.15.2a0+fa99a53 intel_extension_for_pytorch==2.0.110+gitc6ea20b ${ipex_win_url}
                        ;;
                    2.1.0)
                        if [[ "${ipex_type}" == "Core_Ultra" ]]; then # 核显
                            install_python_package torch==2.1.0a0+git7bcf7da torchvision==0.16.0+fbb4cc5 torchaudio==2.1.0+6ea1133 intel_extension_for_pytorch==2.1.20+git4849f3b ${ipex_win_url}
                        else # 独显
                            install_python_package torch==2.1.0a0+cxx11.abi torchvision==0.16.0a0+cxx11.abi torchaudio==2.1.0a0+cxx11.abi intel_extension_for_pytorch==2.1.10+xpu ${ipex_win_url}
                        fi
                        ;;
                esac
            else
                # 其他平台
                # IPEX: https://intel.github.io/intel-extension-for-pytorch/#installation
                if is_use_pip_mirror; then # 国内镜像
                    case "${torch_ipex_ver}" in
                        2.0.0)
                            install_python_package torch==2.0.1a0 torchvision==0.15.2a0 intel-extension-for-pytorch==2.0.120+xpu ${ipex_url_cn}
                            ;;
                        2.1.0)
                            install_python_package torch==2.1.0.post0 torchvision==0.16.0.post0 torchaudio==2.1.0.post0 intel-extension-for-pytorch==2.1.20 ${ipex_url_cn}
                            ;;
                    esac
                else
                    case "${torch_ipex_ver}" in
                        2.0.0)
                            install_python_package torch==2.0.1a0 torchvision==0.15.2a0 intel-extension-for-pytorch==2.0.120+xpu ${ipex_url_us}
                            ;;
                        2.1.0)
                            install_python_package torch==2.1.0.post0 torchvision==0.16.0.post0 torchaudio==2.1.0.post0 intel-extension-for-pytorch==2.1.20 ${ipex_url_us}
                            ;;
                    esac
                fi
            fi
            ;;
        ipex)
            if is_use_pip_mirror; then
                PIP_INDEX_URL="https://download.pytorch.org/whl/xpu" \
                PIP_EXTRA_INDEX_URL="" \
                PIP_FIND_LINKS="" \
                term_sd_try term_sd_pip install ${torch_ver} \
                ${PIP_BREAK_SYSTEM_PACKAGE_ARG} ${PIP_USE_PEP517_ARG} ${PIP_FORCE_REINSTALL_ARG} ${PIP_UPDATE_PACKAGE_ARG}
            else
                PIP_INDEX_URL="https://download.pytorch.org/whl/xpu" \
                PIP_EXTRA_INDEX_URL="" \
                PIP_FIND_LINKS="" \
                term_sd_try term_sd_pip install ${torch_ver} \
                ${PIP_BREAK_SYSTEM_PACKAGE_ARG} ${PIP_USE_PEP517_ARG} ${PIP_FORCE_REINSTALL_ARG} ${PIP_UPDATE_PACKAGE_ARG}
            fi
            ;;
    esac

    if [[ "$?" == 0 ]]; then
        term_sd_echo "PyTorch 安装成功"
    else
        term_sd_echo "PyTorch 安装失败"
        return 1
    fi
}

# 处理 PyTorch 的安装
# 使用 INSTALL_PYTORCH_VERSION 全局变量读取需要安装的 PyTorch 版本
# 使用 INSTALL_XFORMERS_VERSION 全局变量读取需要安装的 xFormers 版本
# 使用 PYTORCH_TYPE 判断 PyTorch 种类, 用于切换 PyTorch 镜像源
# 接受 Pip 参数:
# PIP_INDEX_MIRROR PIP_EXTRA_INDEX_MIRROR PIP_FIND_LINKS_MIRROR
# PIP_BREAK_SYSTEM_PACKAGE_ARG PIP_USE_PEP517_ARG PIP_FORCE_REINSTALL_ARG
# PIP_UPDATE_PACKAGE_ARG
process_pytorch() {
    local torch_ver
    local xformers_ver

    torch_ver=$INSTALL_PYTORCH_VERSION
    xformers_ver=$INSTALL_XFORMERS_VERSION

    term_sd_echo "将要安装的 PyTorch 版本组合:"
    term_sd_echo "PyTorch: ${torch_ver}"
    term_sd_echo "xFormers: $([[ ! -z "${xformers_ver}" ]] && echo ${xformers_ver} || echo "无")"
    # 安装 PyTorch
    term_sd_echo "开始安装 PyTorch"
    if is_use_pip_mirror; then # 镜像源
        case "${PYTORCH_TYPE}" in
            cu128)
                PIP_INDEX_URL="https://mirror.nju.edu.cn/pytorch/whl/cu128" \
                PIP_EXTRA_INDEX_URL="" \
                PIP_FIND_LINKS="" \
                term_sd_try term_sd_pip install ${torch_ver} \
                ${PIP_BREAK_SYSTEM_PACKAGE_ARG} ${PIP_USE_PEP517_ARG} ${PIP_FORCE_REINSTALL_ARG} ${PIP_UPDATE_PACKAGE_ARG}
                ;;
            cu126)
                PIP_INDEX_URL="https://mirror.nju.edu.cn/pytorch/whl/cu126" \
                PIP_EXTRA_INDEX_URL="" \
                PIP_FIND_LINKS="" \
                term_sd_try term_sd_pip install ${torch_ver} \
                ${PIP_BREAK_SYSTEM_PACKAGE_ARG} ${PIP_USE_PEP517_ARG} ${PIP_FORCE_REINSTALL_ARG} ${PIP_UPDATE_PACKAGE_ARG}
                ;;
            cu124)
                PIP_INDEX_URL="https://mirror.nju.edu.cn/pytorch/whl/cu124" \
                PIP_EXTRA_INDEX_URL="" \
                PIP_FIND_LINKS="" \
                term_sd_try term_sd_pip install ${torch_ver} \
                ${PIP_BREAK_SYSTEM_PACKAGE_ARG} ${PIP_USE_PEP517_ARG} ${PIP_FORCE_REINSTALL_ARG} ${PIP_UPDATE_PACKAGE_ARG}
                ;;
            cu121)
                PIP_INDEX_URL="https://mirror.sjtu.edu.cn/pytorch-wheels/cu121" \
                PIP_EXTRA_INDEX_URL="" \
                PIP_FIND_LINKS="" \
                term_sd_try term_sd_pip install ${torch_ver} \
                ${PIP_BREAK_SYSTEM_PACKAGE_ARG} ${PIP_USE_PEP517_ARG} ${PIP_FORCE_REINSTALL_ARG} ${PIP_UPDATE_PACKAGE_ARG}
                ;;
            cu118)
                # PIP_FIND_LINKS="https://mirror.sjtu.edu.cn/pytorch-wheels/cu118/torch_stable.html" \
                PIP_INDEX_URL="https://mirror.nju.edu.cn/pytorch/whl/cu118" \
                PIP_EXTRA_INDEX_URL="" \
                PIP_FIND_LINKS="" \
                term_sd_try term_sd_pip install ${torch_ver} \
                ${PIP_BREAK_SYSTEM_PACKAGE_ARG} ${PIP_USE_PEP517_ARG} ${PIP_FORCE_REINSTALL_ARG} ${PIP_UPDATE_PACKAGE_ARG}
                ;;
            rocm61)
                PIP_INDEX_URL="https://mirror.nju.edu.cn/pytorch/whl/rocm6.1" \
                PIP_EXTRA_INDEX_URL="" \
                PIP_FIND_LINKS="" \
                term_sd_try term_sd_pip install ${torch_ver} \
                ${PIP_BREAK_SYSTEM_PACKAGE_ARG} ${PIP_USE_PEP517_ARG} ${PIP_FORCE_REINSTALL_ARG} ${PIP_UPDATE_PACKAGE_ARG}
                ;;
            rocm62)
                PIP_INDEX_URL="https://mirror.sjtu.edu.cn/pytorch-wheels/rocm6.2" \
                PIP_EXTRA_INDEX_URL="" \
                PIP_FIND_LINKS="" \
                term_sd_try term_sd_pip install ${torch_ver} \
                ${PIP_BREAK_SYSTEM_PACKAGE_ARG} ${PIP_USE_PEP517_ARG} ${PIP_FORCE_REINSTALL_ARG} ${PIP_UPDATE_PACKAGE_ARG}
                ;;
            rocm624)
                PIP_INDEX_URL="https://mirror.nju.edu.cn/pytorch/whl/rocm6.2.4" \
                PIP_EXTRA_INDEX_URL="" \
                PIP_FIND_LINKS="" \
                term_sd_try term_sd_pip install ${torch_ver} \
                ${PIP_BREAK_SYSTEM_PACKAGE_ARG} ${PIP_USE_PEP517_ARG} ${PIP_FORCE_REINSTALL_ARG} ${PIP_UPDATE_PACKAGE_ARG}
                ;;
            rocm63)
                PIP_INDEX_URL="https://mirror.nju.edu.cn/pytorch/whl/rocm6.3" \
                PIP_EXTRA_INDEX_URL="" \
                PIP_FIND_LINKS="" \
                term_sd_try term_sd_pip install ${torch_ver} \
                ${PIP_BREAK_SYSTEM_PACKAGE_ARG} ${PIP_USE_PEP517_ARG} ${PIP_FORCE_REINSTALL_ARG} ${PIP_UPDATE_PACKAGE_ARG}
                ;;
            cpu)
                PIP_INDEX_URL="https://mirror.nju.edu.cn/pytorch/whl/cpu" \
                PIP_EXTRA_INDEX_URL="" \
                PIP_FIND_LINKS="" \
                term_sd_try term_sd_pip install ${torch_ver} \
                ${PIP_BREAK_SYSTEM_PACKAGE_ARG} ${PIP_USE_PEP517_ARG} ${PIP_FORCE_REINSTALL_ARG} ${PIP_UPDATE_PACKAGE_ARG}
                ;;
            other)
                PIP_INDEX_URL="https://download.pytorch.org/whl" \
                PIP_EXTRA_INDEX_URL="" \
                PIP_FIND_LINKS="" \
                term_sd_try term_sd_pip install ${torch_ver} \
                ${PIP_BREAK_SYSTEM_PACKAGE_ARG} ${PIP_USE_PEP517_ARG} ${PIP_FORCE_REINSTALL_ARG} ${PIP_UPDATE_PACKAGE_ARG}
                ;;
            *)
                term_sd_try term_sd_pip install ${torch_ver} \
                ${PIP_INDEX_MIRROR} ${PIP_EXTRA_INDEX_MIRROR} ${PIP_FIND_LINKS_MIRROR} ${PIP_BREAK_SYSTEM_PACKAGE_ARG} ${PIP_USE_PEP517_ARG} ${PIP_FORCE_REINSTALL_ARG} ${PIP_UPDATE_PACKAGE_ARG}
                ;;
        esac
    else # 官方源
        case "${PYTORCH_TYPE}" in
            cu128)
                PIP_INDEX_URL="https://download.pytorch.org/whl/cu128" \
                PIP_EXTRA_INDEX_URL="" \
                PIP_FIND_LINKS="" \
                term_sd_try term_sd_pip install ${torch_ver} \
                ${PIP_BREAK_SYSTEM_PACKAGE_ARG} ${PIP_USE_PEP517_ARG} ${PIP_FORCE_REINSTALL_ARG} ${PIP_UPDATE_PACKAGE_ARG}
                ;;
            cu126)
                PIP_INDEX_URL="https://download.pytorch.org/whl/cu126" \
                PIP_EXTRA_INDEX_URL="" \
                PIP_FIND_LINKS="" \
                term_sd_try term_sd_pip install ${torch_ver} \
                ${PIP_BREAK_SYSTEM_PACKAGE_ARG} ${PIP_USE_PEP517_ARG} ${PIP_FORCE_REINSTALL_ARG} ${PIP_UPDATE_PACKAGE_ARG}
                ;;
            cu124)
                # PIP_FIND_LINKS="https://download.pytorch.org/whl/cu124/torch_stable.html" \
                PIP_INDEX_URL="https://download.pytorch.org/whl/cu124" \
                PIP_EXTRA_INDEX_URL="" \
                PIP_FIND_LINKS="" \
                term_sd_try term_sd_pip install ${torch_ver} \
                ${PIP_BREAK_SYSTEM_PACKAGE_ARG} ${PIP_USE_PEP517_ARG} ${PIP_FORCE_REINSTALL_ARG} ${PIP_UPDATE_PACKAGE_ARG}
                ;;
            cu121)
                # PIP_FIND_LINKS="https://download.pytorch.org/whl/cu121/torch_stable.html" \
                PIP_INDEX_URL="https://download.pytorch.org/whl/cu121" \
                PIP_EXTRA_INDEX_URL="" \
                PIP_FIND_LINKS="" \
                term_sd_try term_sd_pip install ${torch_ver} \
                ${PIP_BREAK_SYSTEM_PACKAGE_ARG} ${PIP_USE_PEP517_ARG} ${PIP_FORCE_REINSTALL_ARG} ${PIP_UPDATE_PACKAGE_ARG}
                ;;
            cu118)
                # PIP_FIND_LINKS="https://download.pytorch.org/whl/cu118/torch_stable.html" \
                PIP_INDEX_URL="https://download.pytorch.org/whl/cu118" \
                PIP_EXTRA_INDEX_URL="" \
                PIP_FIND_LINKS="" \
                term_sd_try term_sd_pip install ${torch_ver} \
                ${PIP_BREAK_SYSTEM_PACKAGE_ARG} ${PIP_USE_PEP517_ARG} ${PIP_FORCE_REINSTALL_ARG} ${PIP_UPDATE_PACKAGE_ARG}
                ;;
            rocm61)
                PIP_INDEX_URL="https://download.pytorch.org/whl/rocm6.1" \
                PIP_EXTRA_INDEX_URL="" \
                PIP_FIND_LINKS="" \
                term_sd_try term_sd_pip install ${torch_ver} \
                ${PIP_BREAK_SYSTEM_PACKAGE_ARG} ${PIP_USE_PEP517_ARG} ${PIP_FORCE_REINSTALL_ARG} ${PIP_UPDATE_PACKAGE_ARG}
                ;;
            rocm62)
                PIP_INDEX_URL="https://download.pytorch.org/whl/rocm6.2" \
                PIP_EXTRA_INDEX_URL="" \
                PIP_FIND_LINKS="" \
                term_sd_try term_sd_pip install ${torch_ver} \
                ${PIP_BREAK_SYSTEM_PACKAGE_ARG} ${PIP_USE_PEP517_ARG} ${PIP_FORCE_REINSTALL_ARG} ${PIP_UPDATE_PACKAGE_ARG}
                ;;
            rocm624)
                PIP_INDEX_URL="https://download.pytorch.org/whl/rocm6.2.4" \
                PIP_EXTRA_INDEX_URL="" \
                PIP_FIND_LINKS="" \
                term_sd_try term_sd_pip install ${torch_ver} \
                ${PIP_BREAK_SYSTEM_PACKAGE_ARG} ${PIP_USE_PEP517_ARG} ${PIP_FORCE_REINSTALL_ARG} ${PIP_UPDATE_PACKAGE_ARG}
                ;;
            rocm63)
                PIP_INDEX_URL="https://download.pytorch.org/whl/rocm6.3" \
                PIP_EXTRA_INDEX_URL="" \
                PIP_FIND_LINKS="" \
                term_sd_try term_sd_pip install ${torch_ver} \
                ${PIP_BREAK_SYSTEM_PACKAGE_ARG} ${PIP_USE_PEP517_ARG} ${PIP_FORCE_REINSTALL_ARG} ${PIP_UPDATE_PACKAGE_ARG}
                ;;
            cpu)
                PIP_INDEX_URL="https://download.pytorch.org/whl/cpu" \
                PIP_EXTRA_INDEX_URL="" \
                PIP_FIND_LINKS="" \
                term_sd_try term_sd_pip install ${torch_ver} \
                ${PIP_BREAK_SYSTEM_PACKAGE_ARG} ${PIP_USE_PEP517_ARG} ${PIP_FORCE_REINSTALL_ARG} ${PIP_UPDATE_PACKAGE_ARG}
                ;;
            other)
                PIP_INDEX_URL="https://download.pytorch.org/whl" \
                PIP_EXTRA_INDEX_URL="" \
                PIP_FIND_LINKS="" \
                term_sd_try term_sd_pip install ${torch_ver} \
                ${PIP_BREAK_SYSTEM_PACKAGE_ARG} ${PIP_USE_PEP517_ARG} ${PIP_FORCE_REINSTALL_ARG} ${PIP_UPDATE_PACKAGE_ARG}
                ;;
            *)
                term_sd_try term_sd_pip install ${torch_ver} \
                ${PIP_INDEX_MIRROR} ${PIP_EXTRA_INDEX_MIRROR} ${PIP_FIND_LINKS_MIRROR} ${PIP_BREAK_SYSTEM_PACKAGE_ARG} ${PIP_USE_PEP517_ARG} ${PIP_FORCE_REINSTALL_ARG} ${PIP_UPDATE_PACKAGE_ARG}
                ;;
        esac
    fi

    if [[ "$?" == 0 ]]; then
        term_sd_echo "PyTorch 安装成功"
    else
        term_sd_echo "PyTorch 安装失败, 未进行安装 xFormers"
        return 1
    fi

    # 安装 xFormers
    if [[ ! -z "${xformers_ver}" ]]; then
        if get_python_env_pkg | grep -q xformers; then # 将原有的 xFormers 卸载
            term_sd_echo "卸载原有版本的 xFormers"
            term_sd_try term_sd_pip uninstall xformers -y
        fi
        term_sd_echo "开始安装 xFormers"

        if is_use_pip_mirror; then # 镜像源
            case "${PYTORCH_TYPE}" in
                cu128)
                    PIP_INDEX_URL="https://mirror.nju.edu.cn/pytorch/whl/cu128" \
                    PIP_EXTRA_INDEX_URL="" \
                    PIP_FIND_LINKS="" \
                    term_sd_try term_sd_pip install ${xformers_ver} \
                    ${PIP_BREAK_SYSTEM_PACKAGE_ARG} ${PIP_USE_PEP517_ARG} ${PIP_FORCE_REINSTALL_ARG} ${PIP_UPDATE_PACKAGE_ARG} --no-deps
                    ;;
                cu126)
                    PIP_INDEX_URL="https://mirror.nju.edu.cn/pytorch/whl/cu126" \
                    PIP_EXTRA_INDEX_URL="" \
                    PIP_FIND_LINKS="" \
                    term_sd_try term_sd_pip install ${xformers_ver} \
                    ${PIP_BREAK_SYSTEM_PACKAGE_ARG} ${PIP_USE_PEP517_ARG} ${PIP_FORCE_REINSTALL_ARG} ${PIP_UPDATE_PACKAGE_ARG} --no-deps
                    ;;
                cu124)
                    PIP_INDEX_URL="https://mirror.nju.edu.cn/pytorch/whl/cu124" \
                    PIP_EXTRA_INDEX_URL="" \
                    PIP_FIND_LINKS="" \
                    term_sd_try term_sd_pip install ${xformers_ver} \
                    ${PIP_BREAK_SYSTEM_PACKAGE_ARG} ${PIP_USE_PEP517_ARG} ${PIP_FORCE_REINSTALL_ARG} ${PIP_UPDATE_PACKAGE_ARG} --no-deps
                    ;;
                cu121)
                    PIP_INDEX_URL="https://mirror.sjtu.edu.cn/pytorch-wheels/cu121" \
                    PIP_EXTRA_INDEX_URL="" \
                    PIP_FIND_LINKS="" \
                    term_sd_try term_sd_pip install ${xformers_ver} \
                    ${PIP_BREAK_SYSTEM_PACKAGE_ARG} ${PIP_USE_PEP517_ARG} ${PIP_FORCE_REINSTALL_ARG} ${PIP_UPDATE_PACKAGE_ARG} --no-deps
                    ;;
                cu118)
                    # PIP_FIND_LINKS="https://mirror.sjtu.edu.cn/pytorch-wheels/cu118/torch_stable.html" \
                    PIP_INDEX_URL="https://mirror.nju.edu.cn/pytorch/whl/cu118" \
                    PIP_EXTRA_INDEX_URL="" \
                    PIP_FIND_LINKS="" \
                    term_sd_try term_sd_pip install ${xformers_ver} \
                    ${PIP_BREAK_SYSTEM_PACKAGE_ARG} ${PIP_USE_PEP517_ARG} ${PIP_FORCE_REINSTALL_ARG} ${PIP_UPDATE_PACKAGE_ARG} --no-deps
                    ;;
                rocm61)
                    PIP_INDEX_URL="https://mirror.nju.edu.cn/pytorch/whl/rocm6.1" \
                    PIP_EXTRA_INDEX_URL="" \
                    PIP_FIND_LINKS="" \
                    term_sd_try term_sd_pip install ${xformers_ver} \
                    ${PIP_BREAK_SYSTEM_PACKAGE_ARG} ${PIP_USE_PEP517_ARG} ${PIP_FORCE_REINSTALL_ARG} ${PIP_UPDATE_PACKAGE_ARG} --no-deps
                    ;;
                rocm62)
                    PIP_INDEX_URL="https://mirror.sjtu.edu.cn/pytorch-wheels/rocm6.2" \
                    PIP_EXTRA_INDEX_URL="" \
                    PIP_FIND_LINKS="" \
                    term_sd_try term_sd_pip install ${xformers_ver} \
                    ${PIP_BREAK_SYSTEM_PACKAGE_ARG} ${PIP_USE_PEP517_ARG} ${PIP_FORCE_REINSTALL_ARG} ${PIP_UPDATE_PACKAGE_ARG} --no-deps
                    ;;
                rocm624)
                    PIP_INDEX_URL="https://mirror.nju.edu.cn/pytorch/whl/rocm6.2.4" \
                    PIP_EXTRA_INDEX_URL="" \
                    PIP_FIND_LINKS="" \
                    term_sd_try term_sd_pip install ${xformers_ver} \
                    ${PIP_BREAK_SYSTEM_PACKAGE_ARG} ${PIP_USE_PEP517_ARG} ${PIP_FORCE_REINSTALL_ARG} ${PIP_UPDATE_PACKAGE_ARG} --no-deps
                    ;;
                rocm63)
                    PIP_INDEX_URL="https://mirror.nju.edu.cn/pytorch/whl/rocm6.3" \
                    PIP_EXTRA_INDEX_URL="" \
                    PIP_FIND_LINKS="" \
                    term_sd_try term_sd_pip install ${xformers_ver} \
                    ${PIP_BREAK_SYSTEM_PACKAGE_ARG} ${PIP_USE_PEP517_ARG} ${PIP_FORCE_REINSTALL_ARG} ${PIP_UPDATE_PACKAGE_ARG} --no-deps
                    ;;
                cpu)
                    PIP_INDEX_URL="https://mirror.nju.edu.cn/pytorch/whl/cpu" \
                    PIP_EXTRA_INDEX_URL="" \
                    PIP_FIND_LINKS="" \
                    term_sd_try term_sd_pip install ${xformers_ver} \
                    ${PIP_BREAK_SYSTEM_PACKAGE_ARG} ${PIP_USE_PEP517_ARG} ${PIP_FORCE_REINSTALL_ARG} ${PIP_UPDATE_PACKAGE_ARG} --no-deps
                    ;;
                other)
                    PIP_INDEX_URL="https://download.pytorch.org/whl" \
                    PIP_EXTRA_INDEX_URL="" \
                    PIP_FIND_LINKS="" \
                    term_sd_try term_sd_pip install ${xformers_ver} \
                    ${PIP_BREAK_SYSTEM_PACKAGE_ARG} ${PIP_USE_PEP517_ARG} ${PIP_FORCE_REINSTALL_ARG} ${PIP_UPDATE_PACKAGE_ARG} --no-deps
                    ;;
                *)
                    term_sd_try term_sd_pip install ${xformers_ver} \
                    ${PIP_INDEX_MIRROR} ${PIP_EXTRA_INDEX_MIRROR} ${PIP_FIND_LINKS_MIRROR} ${PIP_BREAK_SYSTEM_PACKAGE_ARG} ${PIP_USE_PEP517_ARG} ${PIP_FORCE_REINSTALL_ARG} ${PIP_UPDATE_PACKAGE_ARG} --no-deps
                    ;;
            esac
        else # 官方源
            case "${PYTORCH_TYPE}" in
                cu128)
                    PIP_INDEX_URL="https://download.pytorch.org/whl/cu128" \
                    PIP_EXTRA_INDEX_URL="" \
                    PIP_FIND_LINKS="" \
                    term_sd_try term_sd_pip install ${xformers_ver} \
                    ${PIP_BREAK_SYSTEM_PACKAGE_ARG} ${PIP_USE_PEP517_ARG} ${PIP_FORCE_REINSTALL_ARG} ${PIP_UPDATE_PACKAGE_ARG} --no-deps
                    ;;
                cu126)
                    PIP_INDEX_URL="https://download.pytorch.org/whl/cu126" \
                    PIP_EXTRA_INDEX_URL="" \
                    PIP_FIND_LINKS="" \
                    term_sd_try term_sd_pip install ${xformers_ver} \
                    ${PIP_BREAK_SYSTEM_PACKAGE_ARG} ${PIP_USE_PEP517_ARG} ${PIP_FORCE_REINSTALL_ARG} ${PIP_UPDATE_PACKAGE_ARG} --no-deps
                    ;;
                cu124)
                    # PIP_FIND_LINKS="https://download.pytorch.org/whl/cu124/torch_stable.html" \
                    PIP_INDEX_URL="https://download.pytorch.org/whl/cu124" \
                    PIP_EXTRA_INDEX_URL="" \
                    PIP_FIND_LINKS="" \
                    term_sd_try term_sd_pip install ${xformers_ver} \
                    ${PIP_BREAK_SYSTEM_PACKAGE_ARG} ${PIP_USE_PEP517_ARG} ${PIP_FORCE_REINSTALL_ARG} ${PIP_UPDATE_PACKAGE_ARG} --no-deps
                    ;;
                cu121)
                    # PIP_FIND_LINKS="https://download.pytorch.org/whl/cu121/torch_stable.html" \
                    PIP_INDEX_URL="https://download.pytorch.org/whl/cu121" \
                    PIP_EXTRA_INDEX_URL="" \
                    PIP_FIND_LINKS="" \
                    term_sd_try term_sd_pip install ${xformers_ver} \
                    ${PIP_BREAK_SYSTEM_PACKAGE_ARG} ${PIP_USE_PEP517_ARG} ${PIP_FORCE_REINSTALL_ARG} ${PIP_UPDATE_PACKAGE_ARG} --no-deps
                    ;;
                cu118)
                    # PIP_FIND_LINKS="https://download.pytorch.org/whl/cu118/torch_stable.html" \
                    PIP_INDEX_URL="https://download.pytorch.org/whl/cu118" \
                    PIP_EXTRA_INDEX_URL="" \
                    PIP_FIND_LINKS="" \
                    term_sd_try term_sd_pip install ${xformers_ver} \
                    ${PIP_BREAK_SYSTEM_PACKAGE_ARG} ${PIP_USE_PEP517_ARG} ${PIP_FORCE_REINSTALL_ARG} ${PIP_UPDATE_PACKAGE_ARG} --no-deps
                    ;;
                rocm61)
                    PIP_INDEX_URL="https://download.pytorch.org/whl/rocm6.1" \
                    PIP_EXTRA_INDEX_URL="" \
                    PIP_FIND_LINKS="" \
                    term_sd_try term_sd_pip install ${xformers_ver} \
                    ${PIP_BREAK_SYSTEM_PACKAGE_ARG} ${PIP_USE_PEP517_ARG} ${PIP_FORCE_REINSTALL_ARG} ${PIP_UPDATE_PACKAGE_ARG} --no-deps
                    ;;
                rocm62)
                    PIP_INDEX_URL="https://download.pytorch.org/whl/rocm6.2" \
                    PIP_EXTRA_INDEX_URL="" \
                    PIP_FIND_LINKS="" \
                    term_sd_try term_sd_pip install ${xformers_ver} \
                    ${PIP_BREAK_SYSTEM_PACKAGE_ARG} ${PIP_USE_PEP517_ARG} ${PIP_FORCE_REINSTALL_ARG} ${PIP_UPDATE_PACKAGE_ARG} --no-deps
                    ;;
                rocm624)
                    PIP_INDEX_URL="https://download.pytorch.org/whl/rocm6.2.4" \
                    PIP_EXTRA_INDEX_URL="" \
                    PIP_FIND_LINKS="" \
                    term_sd_try term_sd_pip install ${xformers_ver} \
                    ${PIP_BREAK_SYSTEM_PACKAGE_ARG} ${PIP_USE_PEP517_ARG} ${PIP_FORCE_REINSTALL_ARG} ${PIP_UPDATE_PACKAGE_ARG} --no-deps
                    ;;
                rocm63)
                    PIP_INDEX_URL="https://download.pytorch.org/whl/rocm6.3" \
                    PIP_EXTRA_INDEX_URL="" \
                    PIP_FIND_LINKS="" \
                    term_sd_try term_sd_pip install ${xformers_ver} \
                    ${PIP_BREAK_SYSTEM_PACKAGE_ARG} ${PIP_USE_PEP517_ARG} ${PIP_FORCE_REINSTALL_ARG} ${PIP_UPDATE_PACKAGE_ARG} --no-deps
                    ;;
                cpu)
                    PIP_INDEX_URL="https://download.pytorch.org/whl/cpu" \
                    PIP_EXTRA_INDEX_URL="" \
                    PIP_FIND_LINKS="" \
                    term_sd_try term_sd_pip install ${xformers_ver} \
                    ${PIP_BREAK_SYSTEM_PACKAGE_ARG} ${PIP_USE_PEP517_ARG} ${PIP_FORCE_REINSTALL_ARG} ${PIP_UPDATE_PACKAGE_ARG} --no-deps
                    ;;
                other)
                    PIP_INDEX_URL="https://download.pytorch.org/whl" \
                    PIP_EXTRA_INDEX_URL="" \
                    PIP_FIND_LINKS="" \
                    term_sd_try term_sd_pip install ${xformers_ver} \
                    ${PIP_BREAK_SYSTEM_PACKAGE_ARG} ${PIP_USE_PEP517_ARG} ${PIP_FORCE_REINSTALL_ARG} ${PIP_UPDATE_PACKAGE_ARG} --no-deps
                    ;;
                *)
                    term_sd_try term_sd_pip install ${xformers_ver} \
                    ${PIP_INDEX_MIRROR} ${PIP_EXTRA_INDEX_MIRROR} ${PIP_FIND_LINKS_MIRROR} ${PIP_BREAK_SYSTEM_PACKAGE_ARG} ${PIP_USE_PEP517_ARG} ${PIP_FORCE_REINSTALL_ARG} ${PIP_UPDATE_PACKAGE_ARG} --no-deps
                    ;;
            esac
        fi
    fi

    if [[ "$?" == 0 ]]; then
        term_sd_echo "xFormers 安装成功"
    else
        term_sd_echo "xFormers 安装失败"
        return 1
    fi
}
