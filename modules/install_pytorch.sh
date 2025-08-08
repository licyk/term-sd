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
        # 检测是否使用 PyTorch IPEX Legacy 版本
        case "${PYTORCH_TYPE}" in
            ipex_legacy_arc|ipex_legacy_core_ultra)
                process_pytorch_ipex_legacy
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
# UV_INDEX_MIRROR UV_EXTRA_INDEX_MIRROR UV_FIND_LINKS_MIRROR
# PIP_BREAK_SYSTEM_PACKAGE_ARG PIP_USE_PEP517_ARG PIP_FORCE_REINSTALL_ARG
# PIP_UPDATE_PACKAGE_ARG
process_pytorch_ipex_legacy() {
    local torch_ipex_ver
    local torch_ipex_ver_info
    local ipex_type
    local torch_ver
    local ipex_win_url="--find-links https://licyk.github.io/t/pypi/index.html"
    local ipex_url_cn="--extra-index-url https://pytorch-extension.intel.com/release-whl/stable/xpu/cn"
    local ipex_url_us="--extra-index-url https://pytorch-extension.intel.com/release-whl/stable/xpu/us"
    local ipex_win_url_uv="--find-links https://licyk.github.io/t/pypi/index.html"
    local ipex_url_cn_uv="--index https://pytorch-extension.intel.com/release-whl/stable/xpu/cn"
    local ipex_url_us_uv="--index https://pytorch-extension.intel.com/release-whl/stable/xpu/us"

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
                        if term_sd_is_use_uv; then
                            install_python_package torch==2.0.0a0+gite9ebda2 torchvision==0.15.2a0+fa99a53 intel_extension_for_pytorch==2.0.110+gitc6ea20b ${ipex_win_url_uv}
                        else
                            install_python_package torch==2.0.0a0+gite9ebda2 torchvision==0.15.2a0+fa99a53 intel_extension_for_pytorch==2.0.110+gitc6ea20b ${ipex_win_url} --no-warn-conflicts
                        fi
                        ;;
                    2.1.0)
                        if [[ "${ipex_type}" == "Core_Ultra" ]]; then # 核显
                            if term_sd_is_use_uv; then
                                install_python_package torch==2.1.0a0+git7bcf7da torchvision==0.16.0+fbb4cc5 torchaudio==2.1.0+6ea1133 intel_extension_for_pytorch==2.1.20+git4849f3b ${ipex_win_url_uv}
                            else
                                install_python_package torch==2.1.0a0+git7bcf7da torchvision==0.16.0+fbb4cc5 torchaudio==2.1.0+6ea1133 intel_extension_for_pytorch==2.1.20+git4849f3b ${ipex_win_url} --no-warn-conflicts
                            fi
                        else # 独显
                            if term_sd_is_use_uv; then
                                install_python_package torch==2.1.0a0+cxx11.abi torchvision==0.16.0a0+cxx11.abi torchaudio==2.1.0a0+cxx11.abi intel_extension_for_pytorch==2.1.10+xpu ${ipex_win_url_uv}
                            else
                                install_python_package torch==2.1.0a0+cxx11.abi torchvision==0.16.0a0+cxx11.abi torchaudio==2.1.0a0+cxx11.abi intel_extension_for_pytorch==2.1.10+xpu ${ipex_win_url} --no-warn-conflicts
                            fi
                        fi
                        ;;
                esac
            else
                # 其他平台
                # IPEX: https://intel.github.io/intel-extension-for-pytorch/#installation
                if is_use_pip_mirror; then # 国内镜像
                    case "${torch_ipex_ver}" in
                        2.0.0)
                            if term_sd_is_use_uv; then
                                install_python_package torch==2.0.1a0 torchvision==0.15.2a0 intel-extension-for-pytorch==2.0.120+xpu ${ipex_url_cn_uv}
                            else
                                install_python_package torch==2.0.1a0 torchvision==0.15.2a0 intel-extension-for-pytorch==2.0.120+xpu ${ipex_url_cn} --no-warn-conflicts
                            fi
                            ;;
                        2.1.0)
                            if term_sd_is_use_uv; then
                                install_python_package torch==2.1.0.post0 torchvision==0.16.0.post0 torchaudio==2.1.0.post0 intel-extension-for-pytorch==2.1.20 ${ipex_url_cn_uv}
                            else
                                install_python_package torch==2.1.0.post0 torchvision==0.16.0.post0 torchaudio==2.1.0.post0 intel-extension-for-pytorch==2.1.20 ${ipex_url_cn} --no-warn-conflicts
                            fi
                            ;;
                    esac
                else
                    case "${torch_ipex_ver}" in
                        2.0.0)
                            if term_sd_is_use_uv; then
                                install_python_package torch==2.0.1a0 torchvision==0.15.2a0 intel-extension-for-pytorch==2.0.120+xpu ${ipex_url_us_uv}
                            else
                                install_python_package torch==2.0.1a0 torchvision==0.15.2a0 intel-extension-for-pytorch==2.0.120+xpu ${ipex_url_us} --no-warn-conflicts
                            fi
                            ;;
                        2.1.0)
                            if term_sd_is_use_uv; then
                                install_python_package torch==2.1.0.post0 torchvision==0.16.0.post0 torchaudio==2.1.0.post0 intel-extension-for-pytorch==2.1.20 ${ipex_url_us_uv}
                            else
                                install_python_package torch==2.1.0.post0 torchvision==0.16.0.post0 torchaudio==2.1.0.post0 intel-extension-for-pytorch==2.1.20 ${ipex_url_us} --no-warn-conflicts
                            fi
                            ;;
                    esac
                fi
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
# UV_INDEX_MIRROR UV_EXTRA_INDEX_MIRROR UV_FIND_LINKS_MIRROR
# PIP_BREAK_SYSTEM_PACKAGE_ARG PIP_USE_PEP517_ARG PIP_FORCE_REINSTALL_ARG
# PIP_UPDATE_PACKAGE_ARG
process_pytorch() {
    local torch_ver
    local xformers_ver
    local pypi_index_url
    local pypi_extra_index_url
    local pypi_find_links_url
    local with_pypi_mirror_env_value=0

    torch_ver=$INSTALL_PYTORCH_VERSION
    xformers_ver=$INSTALL_XFORMERS_VERSION

    term_sd_echo "将要安装的 PyTorch 版本组合:"
    term_sd_echo "PyTorch: ${torch_ver}"
    term_sd_echo "xFormers: $([[ ! -z "${xformers_ver}" ]] && echo ${xformers_ver} || echo "无")"

    # 配置 PyTorch 镜像源
    if is_use_pip_mirror; then # 镜像源
        case "${PYTORCH_TYPE}" in
            cu129)
                pypi_index_url="https://mirror.nju.edu.cn/pytorch/whl/cu129"
                pypi_extra_index_url=""
                pypi_find_links_url=""
                with_pypi_mirror_env_value=1
                ;;
            cu128)
                pypi_index_url="https://mirror.nju.edu.cn/pytorch/whl/cu128"
                pypi_extra_index_url=""
                pypi_find_links_url=""
                with_pypi_mirror_env_value=1
                ;;
            cu126)
                pypi_index_url="https://mirror.nju.edu.cn/pytorch/whl/cu126"
                pypi_extra_index_url=""
                pypi_find_links_url=""
                with_pypi_mirror_env_value=1
                ;;
            cu124)
                pypi_index_url="https://mirror.nju.edu.cn/pytorch/whl/cu124"
                pypi_extra_index_url=""
                pypi_find_links_url=""
                with_pypi_mirror_env_value=1
                ;;
            cu121)
                pypi_index_url="https://mirror.nju.edu.cn/pytorch/whl/cu121"
                pypi_extra_index_url=""
                pypi_find_links_url=""
                with_pypi_mirror_env_value=1
                ;;
            cu118)
                pypi_index_url="https://mirror.nju.edu.cn/pytorch/whl/cu118"
                pypi_extra_index_url=""
                pypi_find_links_url=""
                with_pypi_mirror_env_value=1
                ;;
            rocm61)
                pypi_index_url="https://mirror.nju.edu.cn/pytorch/whl/rocm6.1"
                pypi_extra_index_url=""
                pypi_find_links_url=""
                with_pypi_mirror_env_value=1
                ;;
            rocm62)
                pypi_index_url="https://mirror.nju.edu.cn/pytorch/whl/rocm6.2"
                pypi_extra_index_url=""
                pypi_find_links_url=""
                with_pypi_mirror_env_value=1
                ;;
            rocm624)
                pypi_index_url="https://mirror.nju.edu.cn/pytorch/whl/rocm6.2.4"
                pypi_extra_index_url=""
                pypi_find_links_url=""
                with_pypi_mirror_env_value=1
                ;;
            rocm63)
                pypi_index_url="https://mirror.nju.edu.cn/pytorch/whl/rocm6.3"
                pypi_extra_index_url=""
                pypi_find_links_url=""
                with_pypi_mirror_env_value=1
                ;;
            rocm64)
                pypi_index_url="https://mirror.nju.edu.cn/pytorch/whl/rocm6.4"
                pypi_extra_index_url=""
                pypi_find_links_url=""
                with_pypi_mirror_env_value=1
                ;;
            xpu)
                pypi_index_url="https://mirror.nju.edu.cn/pytorch/whl/xpu"
                pypi_extra_index_url=""
                pypi_find_links_url=""
                with_pypi_mirror_env_value=1
                ;;
            cpu)
                pypi_index_url="https://mirror.nju.edu.cn/pytorch/whl/cpu"
                pypi_extra_index_url=""
                pypi_find_links_url=""
                with_pypi_mirror_env_value=1
                ;;
            other)
                pypi_index_url="https://download.pytorch.org/whl"
                pypi_extra_index_url=""
                pypi_find_links_url=""
                with_pypi_mirror_env_value=1
                ;;
            *)
                true
                ;;
        esac
    else # 官方源
        case "${PYTORCH_TYPE}" in
            cu129)
                pypi_index_url="https://download.pytorch.org/whl/cu129"
                pypi_extra_index_url=""
                pypi_find_links_url=""
                with_pypi_mirror_env_value=1
                ;;
            cu128)
                pypi_index_url="https://download.pytorch.org/whl/cu128"
                pypi_extra_index_url=""
                pypi_find_links_url=""
                with_pypi_mirror_env_value=1
                ;;
            cu126)
                pypi_index_url="https://download.pytorch.org/whl/cu126"
                pypi_extra_index_url=""
                pypi_find_links_url=""
                with_pypi_mirror_env_value=1
                ;;
            cu124)
                pypi_index_url="https://download.pytorch.org/whl/cu124"
                pypi_extra_index_url=""
                pypi_find_links_url=""
                with_pypi_mirror_env_value=1
                ;;
            cu121)
                pypi_index_url="https://download.pytorch.org/whl/cu121"
                pypi_extra_index_url=""
                pypi_find_links_url=""
                with_pypi_mirror_env_value=1
                ;;
            cu118)
                pypi_index_url="https://download.pytorch.org/whl/cu118"
                pypi_extra_index_url=""
                pypi_find_links_url=""
                with_pypi_mirror_env_value=1
                ;;
            rocm61)
                pypi_index_url="https://download.pytorch.org/whl/rocm6.1"
                pypi_extra_index_url=""
                pypi_find_links_url=""
                with_pypi_mirror_env_value=1
                ;;
            rocm62)
                pypi_index_url="https://download.pytorch.org/whl/rocm6.2"
                pypi_extra_index_url=""
                pypi_find_links_url=""
                with_pypi_mirror_env_value=1
                ;;
            rocm624)
                pypi_index_url="https://download.pytorch.org/whl/rocm6.2.4"
                pypi_extra_index_url=""
                pypi_find_links_url=""
                with_pypi_mirror_env_value=1
                ;;
            rocm63)
                pypi_index_url="https://download.pytorch.org/whl/rocm6.3"
                pypi_extra_index_url=""
                pypi_find_links_url=""
                with_pypi_mirror_env_value=1
                ;;
            rocm64)
                pypi_index_url="https://download.pytorch.org/whl/rocm6.4"
                pypi_extra_index_url=""
                pypi_find_links_url=""
                with_pypi_mirror_env_value=1
                ;;
            xpu)
                pypi_index_url="https://download.pytorch.org/whl/xpu"
                pypi_extra_index_url=""
                pypi_find_links_url=""
                with_pypi_mirror_env_value=1
                ;;
            cpu)
                pypi_index_url="https://download.pytorch.org/whl/cpu"
                pypi_extra_index_url=""
                pypi_find_links_url=""
                with_pypi_mirror_env_value=1
                ;;
            other)
                pypi_index_url="https://download.pytorch.org/whl"
                pypi_extra_index_url=""
                pypi_find_links_url=""
                with_pypi_mirror_env_value=1
                ;;
            *)
                true
                ;;
        esac
    fi

    # 安装 PyTorch
    term_sd_echo "开始安装 PyTorch"
    if [[ "${with_pypi_mirror_env_value}" == 1 ]]; then
        # 使用临时镜像源环境变量进行安装
        if term_sd_is_use_uv; then
            UV_DEFAULT_INDEX=$pypi_index_url \
            UV_INDEX=$pypi_extra_index_url \
            UV_FIND_LINKS=$pypi_find_links_url \
            term_sd_try term_sd_uv_install ${torch_ver} \
            ${PIP_BREAK_SYSTEM_PACKAGE_ARG} ${PIP_FORCE_REINSTALL_ARG} ${PIP_UPDATE_PACKAGE_ARG}
            if check_uv_install_failed_and_warning; then
                PIP_INDEX_URL=$pypi_index_url \
                PIP_EXTRA_INDEX_URL=$pypi_extra_index_url \
                PIP_FIND_LINKS=$pypi_find_links_url \
                term_sd_try term_sd_pip install ${torch_ver} \
                ${PIP_BREAK_SYSTEM_PACKAGE_ARG} ${PIP_USE_PEP517_ARG} ${PIP_FORCE_REINSTALL_ARG} ${PIP_UPDATE_PACKAGE_ARG} --no-warn-conflicts
            fi
        else
            PIP_INDEX_URL=$pypi_index_url \
            PIP_EXTRA_INDEX_URL=$pypi_extra_index_url \
            PIP_FIND_LINKS=$pypi_find_links_url \
            term_sd_try term_sd_pip install ${torch_ver} \
            ${PIP_BREAK_SYSTEM_PACKAGE_ARG} ${PIP_USE_PEP517_ARG} ${PIP_FORCE_REINSTALL_ARG} ${PIP_UPDATE_PACKAGE_ARG} --no-warn-conflicts
        fi
    else
        if term_sd_is_use_uv; then
            term_sd_try term_sd_uv_install ${torch_ver} \
            ${UV_INDEX_MIRROR} ${UV_EXTRA_INDEX_MIRROR} ${UV_FIND_LINKS_MIRROR} ${PIP_BREAK_SYSTEM_PACKAGE_ARG} ${PIP_FORCE_REINSTALL_ARG} ${PIP_UPDATE_PACKAGE_ARG}
            if check_uv_install_failed_and_warning; then
                term_sd_try term_sd_pip install ${torch_ver} \
                ${PIP_INDEX_MIRROR} ${PIP_EXTRA_INDEX_MIRROR} ${PIP_FIND_LINKS_MIRROR} ${PIP_BREAK_SYSTEM_PACKAGE_ARG} ${PIP_USE_PEP517_ARG} ${PIP_FORCE_REINSTALL_ARG} ${PIP_UPDATE_PACKAGE_ARG} --no-warn-conflicts
            fi
        else
            term_sd_try term_sd_pip install ${torch_ver} \
            ${PIP_INDEX_MIRROR} ${PIP_EXTRA_INDEX_MIRROR} ${PIP_FIND_LINKS_MIRROR} ${PIP_BREAK_SYSTEM_PACKAGE_ARG} ${PIP_USE_PEP517_ARG} ${PIP_FORCE_REINSTALL_ARG} ${PIP_UPDATE_PACKAGE_ARG} --no-warn-conflicts
        fi
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

        if [[ "${with_pypi_mirror_env_value}" == 1 ]]; then
            # 使用临时镜像源环境变量进行安装
            if term_sd_is_use_uv; then
                UV_DEFAULT_INDEX=$pypi_index_url \
                UV_INDEX=$pypi_extra_index_url \
                UV_FIND_LINKS=$pypi_find_links_url \
                term_sd_try term_sd_uv_install ${xformers_ver} \
                ${PIP_BREAK_SYSTEM_PACKAGE_ARG} ${PIP_FORCE_REINSTALL_ARG} ${PIP_UPDATE_PACKAGE_ARG} --no-deps
                if check_uv_install_failed_and_warning; then
                    PIP_INDEX_URL=$pypi_index_url \
                    PIP_EXTRA_INDEX_URL=$pypi_extra_index_url \
                    PIP_FIND_LINKS=$pypi_find_links_url \
                    term_sd_try term_sd_pip install ${xformers_ver} \
                    ${PIP_BREAK_SYSTEM_PACKAGE_ARG} ${PIP_USE_PEP517_ARG} ${PIP_FORCE_REINSTALL_ARG} ${PIP_UPDATE_PACKAGE_ARG} --no-warn-conflicts --no-deps
                fi
            else
                PIP_INDEX_URL=$pypi_index_url \
                PIP_EXTRA_INDEX_URL=$pypi_extra_index_url \
                PIP_FIND_LINKS=$pypi_find_links_url \
                term_sd_try term_sd_pip install ${xformers_ver} \
                ${PIP_BREAK_SYSTEM_PACKAGE_ARG} ${PIP_USE_PEP517_ARG} ${PIP_FORCE_REINSTALL_ARG} ${PIP_UPDATE_PACKAGE_ARG} --no-warn-conflicts --no-deps
            fi
        else
            if term_sd_is_use_uv; then
                term_sd_try term_sd_uv_install ${xformers_ver} \
                ${UV_INDEX_MIRROR} ${UV_EXTRA_INDEX_MIRROR} ${UV_FIND_LINKS_MIRROR} ${PIP_BREAK_SYSTEM_PACKAGE_ARG} ${PIP_FORCE_REINSTALL_ARG} ${PIP_UPDATE_PACKAGE_ARG} --no-deps
                if check_uv_install_failed_and_warning; then
                    term_sd_try term_sd_pip install ${xformers_ver} \
                    ${PIP_INDEX_MIRROR} ${PIP_EXTRA_INDEX_MIRROR} ${PIP_FIND_LINKS_MIRROR} ${PIP_BREAK_SYSTEM_PACKAGE_ARG} ${PIP_USE_PEP517_ARG} ${PIP_FORCE_REINSTALL_ARG} ${PIP_UPDATE_PACKAGE_ARG} --no-warn-conflicts --no-deps
                fi
            else
                term_sd_try term_sd_pip install ${xformers_ver} \
                ${PIP_INDEX_MIRROR} ${PIP_EXTRA_INDEX_MIRROR} ${PIP_FIND_LINKS_MIRROR} ${PIP_BREAK_SYSTEM_PACKAGE_ARG} ${PIP_USE_PEP517_ARG} ${PIP_FORCE_REINSTALL_ARG} ${PIP_UPDATE_PACKAGE_ARG} --no-warn-conflicts --no-deps
            fi
        fi
    else
        return 0
    fi

    if [[ "$?" == 0 ]]; then
        term_sd_echo "xFormers 安装成功"
    else
        term_sd_echo "xFormers 安装失败"
        return 1
    fi
}
