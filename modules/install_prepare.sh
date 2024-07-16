#!/bin/bash

# 安装前镜像选择
# 后面加上 auto_github_mirrror 参数将自动勾选 "Github 镜像源自动选择"
# 该函数需要使用 TERM_SD_PIP_INDEX_URL_ARG, TERM_SD_PIP_EXTRA_INDEX_URL_ARG, TERM_SD_PIP_FIND_LINKS_ARG 变量
# 用于设置其他参数
# 选择后将设置以下变量:
# PIP_INDEX_MIRROR, PIP_EXTRA_INDEX_MIRROR, PIP_FIND_LINKS_MIRROR
# USE_PIP_MIRROR, PIP_BREAK_SYSTEM_PACKAGE_ARG, TERM_SD_ENABLE_ONLY_PROXY
# USE_MODELSCOPE_MODEL_SRC, GITHUB_MIRROR, GITHUB_MIRROR_NAME
download_mirror_select() {
    local dialog_arg
    local auto_select_github_mirror=0
    local use_env_pip_mirror=0
    local use_global_github_mirror=0
    local use_global_pip_mirror=0
    PIP_INDEX_MIRROR="--index-url https://pypi.python.org/simple"
    unset PIP_EXTRA_INDEX_MIRROR
    PIP_FIND_LINKS_MIRROR="--find-links https://download.pytorch.org/whl/torch_stable.html"
    USE_PIP_MIRROR=0
    unset PIP_BREAK_SYSTEM_PACKAGE_ARG
    TERM_SD_ENABLE_ONLY_PROXY=0
    USE_MODELSCOPE_MODEL_SRC=0
    GITHUB_MIRROR="https://github.com/term_sd_git_user/term_sd_git_repo"
    GITHUB_MIRROR_NAME="官方源 (github.com)"

    dialog_arg=$(dialog --erase-on-exit --notags \
        --title "Term-SD" \
        --backtitle "安装镜像选项" \
        --title "Term-SD" \
        --ok-label "确认" --no-cancel \
        --checklist "请选择镜像\n注:\n1、当同时启用多个 Github 镜像源时, 优先选择最下面的 Github 镜像源; 勾选 \"Github 镜像源自动选择\" 时, 将覆盖手动设置的 Github 镜像源\n2、\"强制使用 Pip\"一般情况下不选" \
        $(get_dialog_size_menu) \
        "1" "启用 Pip 镜像源 (使用 Pip 国内镜像源下载 Python 软件包)" OFF \
        "2" "使用全局 Pip 镜像源配置 (使用 Term-SD 设置中配置的 Pip 镜像源)" ON \
        "3" "强制使用 Pip (无视系统警告强制使用 Pip 安装 Python 软件包)" OFF \
        "4" "使用 ModelScope 模型下载源 (将 HuggingFace下载源改为 ModelScope 下载源)" ON \
        "5" "Huggingface / Github 下载源独占代理 (仅在下载 Huggingface / Github 上的文件时启用代理)" ON \
        "6" "使用全局 Github 镜像源配置 (当设置了全局 Github 镜像源时禁用 Github 镜像自动选择)" ON \
        "7" "Github 镜像源自动选择 (测试可用的镜像源并选择自动选择)" $([[ "$1" == "auto_github_mirrror" ]] && echo "ON" || echo "OFF") \
        "8" "启用 Github 镜像源1 (使用 mirror.ghproxy.com 镜像站下载 Github 上的源码)" $([[ "$1" == "auto_github_mirrror" ]] && echo "OFF" || echo "ON") \
        "9" "启用 Github 镜像源2 (使用 gitclone.com 镜像站下载 Github 上的源码)" OFF  \
        "10" "启用 Github 镜像源3 (使用 gh-proxy.com 镜像站下载 Github 上的源码)" OFF \
        "11" "启用 Github 镜像源4 (使用 ghps.cc 镜像站下载 Github 上的源码)" OFF \
        "12" "启用 Github 镜像源5 (使用 gh.idayer.com 镜像站下载 Github 上的源码)" OFF \
        "13" "启用 Github 镜像源6 (使用 ghproxy.net 镜像站下载 Github 上的源码)" OFF \
        3>&1 1>&2 2>&3)

    for i in ${dialog_arg}; do
        case "${i}" in
            1)
                USE_PIP_MIRROR=1
                PIP_INDEX_MIRROR=$TERM_SD_PIP_INDEX_URL_ARG
                PIP_EXTRA_INDEX_MIRROR=$TERM_SD_PIP_EXTRA_INDEX_URL_ARG
                PIP_FIND_LINKS_MIRROR=$TERM_SD_PIP_FIND_LINKS_ARG
                ;;
            2)
                use_global_pip_mirror=1
                ;;
            3)
                PIP_BREAK_SYSTEM_PACKAGE_ARG="--break-system-packages"
                ;;
            4)
                USE_MODELSCOPE_MODEL_SRC=1
                ;;
            5)
                TERM_SD_ENABLE_ONLY_PROXY=1
                ;;
            6)
                if [[ -f "${START_PATH}/term-sd/config/set-global-github-mirror.conf" ]]; then
                    use_global_github_mirror=1
                fi
                ;;
            7)
                auto_select_github_mirror=1
                ;;
            8)
                GITHUB_MIRROR="https://mirror.ghproxy.com/https://github.com/term_sd_git_user/term_sd_git_repo"
                GITHUB_MIRROR_NAME="镜像源1 (mirror.ghproxy.com)"
                ;;
            9)
                GITHUB_MIRROR="https://gitclone.com/github.com/term_sd_git_user/term_sd_git_repo"
                GITHUB_MIRROR_NAME="镜像源2 (gitclone.com)"
                ;;
            10)
                GITHUB_MIRROR="https://gh-proxy.com/https://github.com/term_sd_git_user/term_sd_git_repo"
                GITHUB_MIRROR_NAME="镜像源3 (gh-proxy.com)"
                ;;
            11)
                GITHUB_MIRROR="https://ghps.cc/https://github.com/term_sd_git_user/term_sd_git_repo"
                GITHUB_MIRROR_NAME="镜像源4 (ghps.cc)"
                ;;
            12)
                GITHUB_MIRROR="https://gh.idayer.com/https://github.com/term_sd_git_user/term_sd_git_repo"
                GITHUB_MIRROR_NAME="镜像源5 (gh.idayer.com)"
                ;;
            13)
                GITHUB_MIRROR="https://ghproxy.net/https://github.com/term_sd_git_user/term_sd_git_repo"
                GITHUB_MIRROR_NAME="镜像源6 (ghproxy.net)"
                ;;
        esac
    done

    if [[ "${use_global_pip_mirror}" == 1 ]]; then
        if [[ ! -z "${PIP_INDEX_URL}" ]]; then # 确保存在镜像源
            use_env_pip_mirror=1
        elif [ ! -z "$(term_sd_pip config list | grep -E "global.index-url")" ] && [ ! -z "$(term_sd_pip config list | grep -E "global.find-links")" ]; then
            use_env_pip_mirror=1
        else
            use_env_pip_mirror=0
        fi

        if [[ "${use_env_pip_mirror}" == 1 ]]; then
            term_sd_echo "使用全局 Pip 镜像源配置"
            unset PIP_INDEX_MIRROR
            unset PIP_EXTRA_INDEX_MIRROR
            unset PIP_FIND_LINKS_MIRROR
            if [[ ! "${PIP_INDEX_URL}" == "https://pypi.python.org/simple" ]]; then
                term_sd_echo "使用 Pip 镜像源"
                USE_PIP_MIRROR=1
            elif [[ "${PIP_INDEX_URL}" == "https://pypi.python.org/simple" ]]; then
                term_sd_echo "使用 Pip 官方源"
                USE_PIP_MIRROR=0
            elif term_sd_pip config list | grep -E "global.index-url" | grep "https://pypi.python.org/simple" &> /dev/null; then
                term_sd_echo "使用 Pip 官方源"
                USE_PIP_MIRROR=0
            else
                term_sd_echo "使用 Pip 镜像源"
                USE_PIP_MIRROR=1
            fi
        else
            term_sd_echo "未设置任何镜像源，默认使用 Pip 国内镜像源"
            USE_PIP_MIRROR=1
            PIP_INDEX_MIRROR=$TERM_SD_PIP_INDEX_URL_ARG
            PIP_EXTRA_INDEX_MIRROR=$TERM_SD_PIP_EXTRA_INDEX_URL_ARG
            PIP_FIND_LINKS_MIRROR=$TERM_SD_PIP_FIND_LINKS_ARG
        fi
    fi

    if [[ "${auto_select_github_mirror}" == 1 ]]; then # 测试可用的镜像源
        if [[ "${use_global_github_mirror}" == 1 ]]; then
            term_sd_echo "使用全局 Github 镜像源"
            GITHUB_MIRROR="https://github.com/term_sd_git_user/term_sd_git_repo"
            GITHUB_MIRROR_NAME="全局镜像源 ($(cat "${START_PATH}/term-sd/config/set-global-github-mirror.conf" | awk '{sub("/https://github.com","") sub("/github.com","")}1'))"
        else
            term_sd_echo "测试可用的 Github 镜像源中"
            github_mirror=$(github_mirror_test)
            GITHUB_MIRROR_NAME="镜像源 ($(echo ${github_mirror} | awk '{sub("https://","")}1' | awk -F '/' '{print$NR}'))"
            term_sd_echo "镜像源测试结束, 镜像源选择: ${GITHUB_MIRROR_NAME}"
        fi
    fi
}

# PyTorch 安装版本选择
# 选择后设置 INSTALL_PYTORCH_VERSION 全局变量
pytorch_version_select() {
    local dialog_arg
    unset INSTALL_PYTORCH_VERSION

    dialog_arg=$(dialog --erase-on-exit --notags \
        --title "Term-SD" \
        --backtitle "PyTorch 安装版本选项" \
        --ok-label "确认" --no-cancel \
        --menu "请选择要安装的 PyTorch 版本" \
        $(get_dialog_size_menu) \
        "1" "> Torch + xFormers" \
        "2" "> Torch" \
        "3" "> Torch 2.0.0 (Directml)" \
        "4" "> Torch 2.2.1 + CPU" \
        "5" "> Torch 2.0.1 + RoCM 5.4.2" \
        "6" "> Torch 2.1.0 + RoCM 5.6" \
        "7" "> Torch 2.2.1 + RoCM 5.7" \
        "8" "> Torch 2.3.0 + RoCM 6.0" \
        "9" "> Torch 2.0.0 + IPEX (Arc)" \
        "10" "> Torch 2.1.0 + IPEX (Arc)" \
        "11" "> Torch 2.1.0 + IPEX (Core Ultra)" \
        "12" "> Torch 1.12.1 (CUDA11.3)+ xFormers 0.0.14" \
        "13" "> Torch 1.13.1 (CUDA11.7)+ xFormers 0.0.16" \
        "14" "> Torch 2.0.0 (CUDA11.8) + xFormers 0.0.18" \
        "15" "> Torch 2.0.1 (CUDA11.8) + xFormers 0.0.22" \
        "16" "> Torch 2.1.1 (CUDA11.8) + xFormers 0.0.23" \
        "17" "> Torch 2.1.1 (CUDA12.1) + xFormers 0.0.23" \
        "18" "> Torch 2.1.2 (CUDA11.8) + xFormers 0.0.23.post1" \
        "19" "> Torch 2.1.2 (CUDA12.1) + xFormers 0.0.23.post1" \
        "20" "> Torch 2.2.0 (CUDA11.8) + xFormers 0.0.24" \
        "21" "> Torch 2.2.0 (CUDA12.1) + xFormers 0.0.24" \
        "22" "> Torch 2.2.1 (CUDA11.8) + xFormers 0.0.25" \
        "23" "> Torch 2.2.1 (CUDA12.1) + xFormers 0.0.25" \
        "24" "> Torch 2.2.2 (CUDA11.8) + xFormers 0.0.25.post1" \
        "25" "> Torch 2.2.2 (CUDA12.1) + xFormers 0.0.25.post1" \
        "26" "> Torch 2.3.0 (CUDA11.8) + xFormers 0.0.26.post1" \
        "27" "> Torch 2.3.0 (CUDA12.1) + xFormers 0.0.26.post1" \
        "50" "> 跳过安装 PyTorch" \
        3>&1 1>&2 2>&3)

    case "${dialog_arg}" in
        50)
            unset INSTALL_PYTORCH_VERSION
            ;;
        1)
            INSTALL_PYTORCH_VERSION="torch torchvision torchaudio xformers"
            ;;
        2)
            INSTALL_PYTORCH_VERSION="torch torchvision torchaudio"
            ;;
        3)
            INSTALL_PYTORCH_VERSION="torch==2.0.0 torchvision==0.15.1 torchaudio==2.0.0 torch-directml"
            ;;
        4)
            INSTALL_PYTORCH_VERSION="torch==2.2.1+cpu torchvision==0.17.1+cpu torchaudio==2.2.1+cpu"
            ;;
        5)
            INSTALL_PYTORCH_VERSION="torch==2.0.1+rocm5.4.2 torchvision==0.15.2+rocm5.4.2 torchaudio==2.0.1+rocm5.4.2"
            ;;
        6)
            INSTALL_PYTORCH_VERSION="torch==2.1.0+rocm5.6 torchvision==0.16.0+rocm5.6 torchaudio==2.1.0+rocm5.6"
            ;;
        7)
            INSTALL_PYTORCH_VERSION="torch==2.2.1+rocm5.7 torchvision==0.17.1+rocm5.7 torchaudio==2.2.1+rocm5.7"
            ;;
        8)
            INSTALL_PYTORCH_VERSION="torch==2.3.0+rocm6.0 torchvision==0.18.0+rocm6.0 torchaudio==2.3.0+rocm6.0"
            ;;
        9)
            INSTALL_PYTORCH_VERSION="torch(ipex_Arc) 2.0.0"
            ;;
        10)
            INSTALL_PYTORCH_VERSION="torch(ipex_Arc) 2.1.0"
            ;;
        11)
            INSTALL_PYTORCH_VERSION="torch(ipex_Core_Ultra) 2.1.0"
            ;;
        12)
            INSTALL_PYTORCH_VERSION="torch==1.12.1+cu113 torchvision==0.13.1+cu113 torchaudio==1.12.1+cu113 xformers==0.0.14"
            ;;
        13)
            INSTALL_PYTORCH_VERSION="torch==1.13.1+cu117 torchvision==0.14.1+cu117 torchaudio==1.13.1+cu117 xformers==0.0.16"
            ;;
        14)
            INSTALL_PYTORCH_VERSION="torch==2.0.0+cu118 torchvision==0.15.1+cu118 torchaudio==2.0.0+cu118 xformers==0.0.18"
            ;;
        15)
            INSTALL_PYTORCH_VERSION="torch==2.0.1+cu118 torchvision==0.15.2+cu118 torchaudio==2.0.1+cu118 xformers==0.0.22"
            ;;
        16)
            INSTALL_PYTORCH_VERSION="torch==2.1.1+cu118 torchvision==0.16.1+cu118 torchaudio==2.1.1+cu118 xformers==0.0.23+cu118"
            ;;
        17)
            INSTALL_PYTORCH_VERSION="torch==2.1.1+cu121 torchvision==0.16.1+cu121 torchaudio==2.1.1+cu121 xformers==0.0.23"
            ;;
        18)
            INSTALL_PYTORCH_VERSION="torch==2.1.2+cu118 torchvision==0.16.2+cu118 torchaudio==2.1.2+cu118 xformers==0.0.23.post1+cu118"
            ;;
        19)
            INSTALL_PYTORCH_VERSION="torch==2.1.2+cu121 torchvision==0.16.2+cu121 torchaudio==2.1.2+cu121 xformers==0.0.23.post1"
            ;;
        20)
            INSTALL_PYTORCH_VERSION="torch==2.2.0+cu118 torchvision==0.17.0+cu118 torchaudio==2.2.0+cu118 xformers==0.0.24+cu118"
            ;;
        21)
            INSTALL_PYTORCH_VERSION="torch==2.2.0+cu121 torchvision==0.17.0+cu121 torchaudio==2.2.0+cu121 xformers==0.0.24"
            ;;
        22)
            INSTALL_PYTORCH_VERSION="torch==2.2.1+cu118 torchvision==0.17.1+cu118 torchaudio==2.2.1+cu118 xformers==0.0.25+cu118"
            ;;
        23)
            INSTALL_PYTORCH_VERSION="torch==2.2.1+cu121 torchvision==0.17.1+cu121 torchaudio==2.2.1+cu121 xformers==0.0.25"
            ;;
        24)
            INSTALL_PYTORCH_VERSION="torch==2.2.2+cu118 torchvision==0.17.2+cu118 torchaudio==2.2.2+cu118 xformers==0.0.25.post1+cu118"
            ;;
        25)
            INSTALL_PYTORCH_VERSION="torch==2.2.2+cu121 torchvision==0.17.2+cu121 torchaudio==2.2.2+cu121 xformers==0.0.25.post1"
            ;;
        26)
            INSTALL_PYTORCH_VERSION="torch==2.3.0+cu118 torchvision==0.18.0+cu118 torchaudio==2.3.0+cu118 xformers==0.0.26.post1+cu118"
            ;;
        27)
            INSTALL_PYTORCH_VERSION="torch==2.3.0+cu121 torchvision==0.18.0+cu121 torchaudio==2.3.0+cu121 xformers==0.0.26.post1"
            ;;
    esac
}

# 在 Pip 中是否使用 --use-pep517 进行安装
# 选择后设置 PIP_USE_PEP517_ARG 全局变量
pip_install_mode_select() {
    local dialog_arg
    unset PIP_USE_PEP517_ARG

    dialog_arg=$(dialog --erase-on-exit --notags \
        --title "Term-SD" \
        --backtitle "Pip 安装模式选项" \
        --ok-label "确认" --no-cancel \
        --menu "请选择 Pip 安装方式\n1、常规安装可能会有问题, 但速度较快\n2、标准构建安装可解决一些报错问题, 但速度较慢 (对安装时间不在意的话推荐启用)" \
        $(get_dialog_size_menu) \
        "1" "> 常规安装 (setup.py)" \
        "2" "> 标准构建安装 (--use-pep517)" \
        3>&1 1>&2 2>&3)

    case "${dialog_arg}" in
        1)
            unset PIP_USE_PEP517_ARG
            ;;
        2)
            PIP_USE_PEP517_ARG="--use-pep517"
            ;;
    esac
}

# 在 Pip 中是否使用 --force-reinstall 参数进行强制重装
# 选择后设置 PIP_FORCE_REINSTALL_ARG 全局变量
pip_force_reinstall_select() {
    local dialog_arg
    unset PIP_FORCE_REINSTALL_ARG

    dialog_arg=$(dialog --erase-on-exit --notags \
        --title "Term-SD" \
        --backtitle "Pip 安装模式选项" \
        --ok-label "确认" --no-cancel \
        --menu "Pip 安装软件包时, 是否使用强制重新安装, 请选择" \
        $(get_dialog_size_menu) \
        "1" "> 安装" \
        "2" "> 强制重新安装" \
        3>&1 1>&2 2>&3)

    case "${dialog_arg}" in
        1)
            unset PIP_FORCE_REINSTALL_ARG
            ;;
        2)
            PIP_FORCE_REINSTALL_ARG="--force-reinstall"
            ;;
    esac
}

# 安装前确认界面
# 加参数可修改提示内容
# 使用:
# term_sd_install_confirm <提示内容>
term_sd_install_confirm() {
    local input_text=$@
    local use_pip_info
    local use_github_mirror_info
    local enable_only_proxy_info
    local use_modelscope_src_info
    local pytorch_ver_info
    local use_break_system_package_info
    local use_pep517_info
    local use_force_reinstall_info

    if is_use_pip_mirror; then
        use_pip_info="启用"
    else
        use_pip_info="禁用"
    fi

    use_github_mirror_info=$GITHUB_MIRROR_NAME

    if is_use_modelscope_src; then
        use_modelscope_src_info="启用"
    else
        use_modelscope_src_info="禁用"
    fi

    if is_use_only_proxy; then
        enable_only_proxy_info="启用"
    else
        enable_only_proxy_info="禁用"
    fi

    if [[ ! -z "${PIP_BREAK_SYSTEM_PACKAGE_ARG}" ]]; then
        use_break_system_package_info="启用"
    else
        use_break_system_package_info="禁用"
    fi
    
    if [[ ! -z "${INSTALL_PYTORCH_VERSION}" ]]; then
        pytorch_ver_info=$INSTALL_PYTORCH_VERSION
    else
        pytorch_ver_info="无"
    fi

    if [[ ! -z "${PIP_USE_PEP517_ARG}" ]]; then
        use_pep517_info="标准构建安装 (--use-pep517)"
    else
        use_pep517_info="常规安装 (setup.py)"
    fi

    if [[ ! -z "${PIP_FORCE_REINSTALL_ARG}" ]]; then
        use_force_reinstall_info="启用"
    else
        use_force_reinstall_info="禁用"
    fi

    if (dialog --erase-on-exit \
        --title "Term-SD" \
        --backtitle "安装确认选项" \
        --yes-label "是" --no-label "否" \
        --yesno "$@\n
Pip 镜像源: ${use_pip_info}\n
Github 镜像: ${use_github_mirror_info}\n
Huggingface / Github 下载源独占代理: ${enable_only_proxy_info}\n
使用 ModelScope 模型下载源: ${use_modelscope_src_info}\n
强制使用 Pip: ${use_break_system_package_info}\n
PyTorch 版本: ${pytorch_ver_info}\n
Pip 安装方式: ${use_pep517_info}\n
Pip 强制重装: ${use_force_reinstall_info}\
" $(get_dialog_size)); then
        term_sd_echo "确认进行安装"
        return 0
    else
        term_sd_echo "取消安装"
        return 1
    fi
}

# Github 镜像源测试
# 镜像源不保证都可用, 已知 gitclone.com 提供的镜像克隆不完整, 易出现问题
# 测试完成后将输出可用的 Github 镜像源格式
github_mirror_test() {
    # 镜像源列表
    local mirror_list=$GITHUB_MIRROR_LIST
    local git_req
    local i
    local HTTP_PROXY
    local HTTPS_PROXY
    HTTP_PROXY= # 临时清除配置好的代理,防止干扰测试
    HTTPS_PROXY=
    [ -d "${START_PATH}/term-sd/task/github_mirror_test" ] && rm -rf "${START_PATH}/term-sd/task/github_mirror_test" &> /dev/null
    for i in ${mirror_list}; do
        git clone $(git_format_repository_url ${i} https://github.com/licyk/empty) "${START_PATH}/term-sd/task/github_mirror_test" --depth=1 &> /dev/null # 测试镜像源是否正常连接
        git_req=$?
        rm -rf "${START_PATH}/term-sd/task/github_mirror_test" &> /dev/null
        if [[ ${git_req} == 0 ]]; then
            echo ${i}
            return
        fi
    done
    echo "https://github.com/term_sd_git_user/term_sd_git_repo"
}


# 清理安装完成后留下的参数
# 每次执行完安装任务后需要执行该函数清理参数
clean_install_config() {
    if term_sd_is_debug; then
        term_sd_echo "待清理的用于安装的变量:"
        term_sd_echo "PIP_INDEX_MIRROR: ${PIP_INDEX_MIRROR}"
        term_sd_echo "PIP_EXTRA_INDEX_MIRROR: ${PIP_EXTRA_INDEX_MIRROR}"
        term_sd_echo "PIP_FIND_LINKS_MIRROR: ${PIP_FIND_LINKS_MIRROR}"
        term_sd_echo "USE_PIP_MIRROR: ${USE_PIP_MIRROR}"
        term_sd_echo "PIP_BREAK_SYSTEM_PACKAGE_ARG: ${PIP_BREAK_SYSTEM_PACKAGE_ARG}"
        term_sd_echo "TERM_SD_ENABLE_ONLY_PROXY: ${TERM_SD_ENABLE_ONLY_PROXY}"
        term_sd_echo "USE_MODELSCOPE_MODEL_SRC: ${USE_MODELSCOPE_MODEL_SRC}"
        term_sd_echo "GITHUB_MIRROR: ${GITHUB_MIRROR}"
        term_sd_echo "GITHUB_MIRROR_NAME: ${GITHUB_MIRROR_NAME}"
        term_sd_echo "INSTALL_PYTORCH_VERSION: ${INSTALL_PYTORCH_VERSION}"
        term_sd_echo "PIP_USE_PEP517_ARG: ${PIP_USE_PEP517_ARG}"
        term_sd_echo "PIP_FORCE_REINSTALL_ARG: ${PIP_FORCE_REINSTALL_ARG}"
    fi

    unset PIP_INDEX_MIRROR # 指定 Pip 镜像源的参数
    unset PIP_EXTRA_INDEX_MIRROR
    unset PIP_FIND_LINKS_MIRROR
    unset USE_PIP_MIRROR # 是否启用 Pip 镜像
    unset PIP_BREAK_SYSTEM_PACKAGE_ARG # 是否在 Pip 使用 --break-system-package 参数
    unset TERM_SD_ENABLE_ONLY_PROXY # 是否启用 Github / HuggingFace 独占代理功能
    unset USE_MODELSCOPE_MODEL_SRC # 是否使用 ModelScope 模型站下载模型
    unset GITHUB_MIRROR # Github 镜像的格式, 如: "https://github.com/term_sd_git_user/term_sd_git_repo", 需进行处理后才能使用
    unset GITHUB_MIRROR_NAME # 展示 Github 镜像源的名称
    unset INSTALL_PYTORCH_VERSION # 要安装的 PyTorch 版本和 xFormers 版本
    unset PIP_USE_PEP517_ARG # 是否在 Pip 使用 --use-pep517 参数
    unset PIP_FORCE_REINSTALL_ARG # 是否在 Pip 使用 --force-reinstall 参数
}

# 如果启用了 Pip 镜像源, 则返回0
is_use_pip_mirror() {
    if [[ "${USE_PIP_MIRROR}" == 1 ]]; then
        return 0
    else
        return 1
    fi
}

# 如果启用了 Github / HuggingFace 独占代理, 则返回0
is_use_only_proxy() {
    if [[ "${TERM_SD_ENABLE_ONLY_PROXY}" == 1 ]]; then
        return 0
    else
        return 1
    fi
}

# 如果使用了 ModelScope 模型下载源, 则返回0
is_use_modelscope_src() {
    if [[ "${USE_MODELSCOPE_MODEL_SRC}" == 1 ]]; then
        return 0
    else
        return 1
    fi
}
