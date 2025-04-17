#!/bin/bash

# 安装前镜像选择
# 该函数需要使用 TERM_SD_PIP_INDEX_URL_ARG, TERM_SD_PIP_EXTRA_INDEX_URL_ARG, TERM_SD_PIP_FIND_LINKS_ARG 变量
# 用于设置其他参数
# 选择后将设置以下变量:
# PIP_INDEX_MIRROR, PIP_EXTRA_INDEX_MIRROR, PIP_FIND_LINKS_MIRROR
# USE_MODELSCOPE_MODEL_SRC, GITHUB_MIRROR, GITHUB_MIRROR_NAME
# USE_PIP_MIRROR, TERM_SD_ENABLE_ONLY_PROXY
download_mirror_select() {
    local dialog_arg
    local auto_select_github_mirror=0
    local use_env_pip_mirror=0
    local use_global_github_mirror=0
    local use_global_pip_mirror=0
    local i
    PIP_INDEX_MIRROR="--index-url https://pypi.python.org/simple"
    unset PIP_EXTRA_INDEX_MIRROR
    PIP_FIND_LINKS_MIRROR="--find-links https://download.pytorch.org/whl/torch_stable.html"
    USE_PIP_MIRROR=0
    TERM_SD_ENABLE_ONLY_PROXY=0
    USE_MODELSCOPE_MODEL_SRC=0
    GITHUB_MIRROR="https://github.com/term_sd_git_user/term_sd_git_repo"
    GITHUB_MIRROR_NAME="官方源 (github.com)"

    dialog_arg=$(dialog --erase-on-exit --notags \
        --title "Term-SD" \
        --backtitle "安装镜像选项" \
        --title "Term-SD" \
        --ok-label "确认" --no-cancel \
        --checklist "请选择镜像, 注:\n1. 当同时启用多个 Github 镜像源时, 优先选择最下面的 Github 镜像源; 勾选 \"Github 镜像源自动选择\" 时, 将覆盖手动设置的 Github 镜像源\n2. 启用全局镜像源后, 优先使用设置中的镜像源\n3. 如果需要保持安装全程使用代理, 需要将 \"Huggingface / Github 下载源独占代理\" 关闭\n4. 有些 Python 软件包的下载需要代理, 需要将 \"Huggingface / Github 下载源独占代理\" 关闭\n5. 通常情况下保持默认即可" \
        $(get_dialog_size_menu) \
        "1" "启用 PyPI 镜像源 (使用 PyPI 国内镜像源下载 Python 软件包)" OFF \
        "2" "使用全局 PyPI 镜像源配置 (使用 Term-SD 设置中配置的 PyPI 镜像源)" ON \
        "3" "使用 ModelScope 模型下载源 (将 HuggingFace 下载源改为 ModelScope 下载源)" ON \
        "4" "Huggingface / Github 下载源独占代理 (仅在下载 Huggingface / Github 上的文件时启用代理)" OFF \
        "5" "使用全局 Github 镜像源配置 (当设置了全局 Github 镜像源时禁用 Github 镜像自动选择)" ON \
        "6" "Github 镜像源自动选择 (测试可用的镜像源并选择自动选择)" ON \
        "7" "启用 Github 镜像源 1 (使用 ghfast.top 镜像站下载 Github 上的源码)" OFF \
        "8" "启用 Github 镜像源 2 (使用 mirror.ghproxy.com 镜像站下载 Github 上的源码)" OFF \
        "9" "启用 Github 镜像源 3 (使用 gitclone.com 镜像站下载 Github 上的源码)" OFF  \
        "10" "启用 Github 镜像源 4 (使用 gh-proxy.com 镜像站下载 Github 上的源码)" OFF \
        "11" "启用 Github 镜像源 5 (使用 ghps.cc 镜像站下载 Github 上的源码)" OFF \
        "12" "启用 Github 镜像源 6 (使用 gh.idayer.com 镜像站下载 Github 上的源码)" OFF \
        "13" "启用 Github 镜像源 7 (使用 ghproxy.net 镜像站下载 Github 上的源码)" OFF \
        "14" "启用 Github 镜像源 8 (使用 gh.api.99988866.xyz 镜像站下载 Github 上的源码)" OFF \
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
                USE_MODELSCOPE_MODEL_SRC=1
                ;;
            4)
                TERM_SD_ENABLE_ONLY_PROXY=1
                ;;
            5)
                if [[ -f "${START_PATH}/term-sd/config/set-global-github-mirror.conf" ]]; then
                    use_global_github_mirror=1
                fi
                ;;
            6)
                auto_select_github_mirror=1
                ;;
            7)
                GITHUB_MIRROR="https://ghfast.top/https://github.com/term_sd_git_user/term_sd_git_repo"
                GITHUB_MIRROR_NAME="镜像源 1 (ghfast.top)"
                ;;
            8)
                GITHUB_MIRROR="https://mirror.ghproxy.com/https://github.com/term_sd_git_user/term_sd_git_repo"
                GITHUB_MIRROR_NAME="镜像源 2 (mirror.ghproxy.com)"
                ;;
            9)
                GITHUB_MIRROR="https://gitclone.com/github.com/term_sd_git_user/term_sd_git_repo"
                GITHUB_MIRROR_NAME="镜像源 3 (gitclone.com)"
                ;;
            10)
                GITHUB_MIRROR="https://gh-proxy.com/https://github.com/term_sd_git_user/term_sd_git_repo"
                GITHUB_MIRROR_NAME="镜像源 4 (gh-proxy.com)"
                ;;
            11)
                GITHUB_MIRROR="https://ghps.cc/https://github.com/term_sd_git_user/term_sd_git_repo"
                GITHUB_MIRROR_NAME="镜像源 5 (ghps.cc)"
                ;;
            12)
                GITHUB_MIRROR="https://gh.idayer.com/https://github.com/term_sd_git_user/term_sd_git_repo"
                GITHUB_MIRROR_NAME="镜像源 6 (gh.idayer.com)"
                ;;
            13)
                GITHUB_MIRROR="https://ghproxy.net/https://github.com/term_sd_git_user/term_sd_git_repo"
                GITHUB_MIRROR_NAME="镜像源 7 (ghproxy.net)"
                ;;
            14)
                GITHUB_MIRROR="https://gh.api.99988866.xyz/https://github.com/term_sd_git_user/term_sd_git_repo"
                GITHUB_MIRROR_NAME="镜像源 8 (gh.api.99988866.xyz)"
                ;;
        esac
    done

    if [[ "${use_global_pip_mirror}" == 1 ]]; then
        if [[ ! -z "${PIP_INDEX_URL}" ]]; then # 确保存在镜像源
            use_env_pip_mirror=1
        # 已弃用
        # elif [ ! -z "$(term_sd_pip config list | grep -E "global.index-url")" ] && [ ! -z "$(term_sd_pip config list | grep -E "global.find-links")" ]; then
        #     use_env_pip_mirror=1
        else
            use_env_pip_mirror=0
        fi

        if [[ "${use_env_pip_mirror}" == 1 ]]; then
            term_sd_echo "使用全局 PyPI 镜像源配置"
            unset PIP_INDEX_MIRROR
            unset PIP_EXTRA_INDEX_MIRROR
            unset PIP_FIND_LINKS_MIRROR
            if [[ ! "${PIP_INDEX_URL}" == "https://pypi.python.org/simple" ]]; then
                term_sd_echo "使用 PyPI 镜像源"
                USE_PIP_MIRROR=1
            elif [[ "${PIP_INDEX_URL}" == "https://pypi.python.org/simple" ]]; then
                term_sd_echo "使用 PyPI 官方源"
                USE_PIP_MIRROR=0
            # 已弃用
            # elif term_sd_pip config list | grep -E "global.index-url" | grep "https://pypi.python.org/simple" &> /dev/null; then
            #     term_sd_echo "使用 PyPI 官方源"
            #     USE_PIP_MIRROR=0
            else
                term_sd_echo "使用 PyPI 镜像源"
                USE_PIP_MIRROR=1
            fi
        else
            term_sd_echo "未设置任何镜像源，默认使用 PyPI 国内镜像源"
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
# 选择后设置 INSTALL_PYTORCH_VERSION 全局变量保存 PyTorch 版本信息
# 设置 INSTALL_XFORMERS_VERSION 全局变量保存 xFormers 版本信息
# PYTORCH_TYPE 保存使用的 PyTorch 镜像源种类, 如果为空则使用默认的镜像源
pytorch_version_select() {
    local dialog_arg
    unset INSTALL_PYTORCH_VERSION
    unset INSTALL_XFORMERS_VERSION

    dialog_arg=$(dialog --erase-on-exit --notags \
        --title "Term-SD" \
        --backtitle "PyTorch 安装版本选项" \
        --ok-label "确认" --no-cancel \
        --menu "请选择要安装的 PyTorch 版本, 注:\n1. Nvidia 显卡选择 CUDA 的版本\n2. AMD 显卡选择 RoCM(Linux) / DirectML(Windows) 版本\n3. Intel 显卡选择 IPEX Arc(独显) / Core Ultra(核显) / Intel XPU\n4. Apple M 系列芯片选择无特殊标识版本\n5. 使用 CPU 运算选择 CPU 版本\n6. 标记为 Linux 的版本只能在 Linux 上安装\n当前 PyTorch 版本: $(get_pytorch_version)\n当前 xFormers 版本: $(get_xformers_version)" \
        $(get_dialog_size_menu) \
        "76" "> Torch 2.6.0 (CUDA 11.8) + xFormers 0.0.29.post3 (Linux)" \
        "75" "> Torch 2.6.0 (CUDA 12.4) + xFormers 0.0.29.post3" \
        "74" "> Torch 2.6.0 (CUDA 12.6) + xFormers 0.0.29.post3" \
        "73" "> Torch 2.6.0 (Intel XPU)" \
        "72" "> Torch 2.6.0 (RoCM 6.1) + xFormers 0.0.29.post3 (Linux)" \
        "71" "> Torch 2.6.0 (RoCM 6.2.4) + xFormers 0.0.29.post3 (Linux)" \
        "70" "> Torch 2.6.0 (CPU)" \
        "69" "> Torch 2.5.1 (CUDA 11.8) + xFormers 0.0.28.post3 (Linux)" \
        "68" "> Torch 2.5.1 (CUDA 12.1) + xFormers 0.0.28.post3 (Linux)" \
        "67" "> Torch 2.5.1 (CUDA 12.4) + xFormers 0.0.28.post3" \
        "66" "> Torch 2.5.1 (RoCM 6.1) + xFormers 0.0.28.post3 (Linux)" \
        "65" "> Torch 2.5.1 (RoCM 6.2) (Linux)" \
        "64" "> Torch 2.5.1 (CPU)" \
        "63" "> Torch 2.5.0 (CUDA 11.8) + xFormers 0.0.28.post2 (Linux)" \
        "62" "> Torch 2.5.0 (CUDA 12.1) + xFormers 0.0.28.post2 (Linux)" \
        "61" "> Torch 2.5.0 (CUDA 12.4) + xFormers 0.0.28.post2" \
        "60" "> Torch 2.5.0 (RoCM 6.1) + xFormers 0.0.28.post2 (Linux)" \
        "59" "> Torch 2.5.0 (RoCM 6.2) (Linux)" \
        "58" "> Torch 2.5.0 (CPU)" \
        "57" "> Torch 2.4.1 (CUDA 11.8) + xFormers 0.0.28.post1 (Linux)" \
        "56" "> Torch 2.4.1 (CUDA 12.1) + xFormers 0.0.28.post1 (Linux)" \
        "55" "> Torch 2.4.1 (CUDA 12.4) + xFormers 0.0.28.post1" \
        "54" "> Torch 2.4.1 (RoCM 6.1) + xFormers 0.0.28.post1 (Linux)" \
        "53" "> Torch 2.4.1 (CPU)" \
        "52" "> Torch 2.4.0 (CUDA 11.8) + xFormers 0.0.27.post2" \
        "51" "> Torch 2.4.0 (CUDA 12.1) + xFormers 0.0.27.post2" \
        "50" "> Torch 2.4.0 (CUDA 12.4)" \
        "49" "> Torch 2.4.0 (RoCM 6.0) (Linux)" \
        "48" "> Torch 2.4.0 (CPU)" \
        "47" "> Torch 2.3.1 (CUDA 11.8) + xFormers 0.0.27" \
        "46" "> Torch 2.3.1 (CUDA 12.1) + xFormers 0.0.27" \
        "45" "> Torch 2.3.1 (RoCM 6.0) (Linux)" \
        "44" "> Torch 2.3.1 (DirectML)" \
        "43" "> Torch 2.3.1 (CPU)" \
        "42" "> Torch 2.3.0 (CUDA 11.8) + xFormers 0.0.26.post1" \
        "41" "> Torch 2.3.0 (CUDA 12.1) + xFormers 0.0.26.post1" \
        "40" "> Torch 2.3.0 (RoCM 6.0) (Linux)" \
        "39" "> Torch 2.3.0 (CPU)" \
        "38" "> Torch 2.2.2 (CUDA 11.8) + xFormers 0.0.25.post1" \
        "37" "> Torch 2.2.2 (CUDA 12.1) + xFormers 0.0.25.post1" \
        "36" "> Torch 2.2.2 (RoCM 5.7) (Linux)" \
        "35" "> Torch 2.2.2 (CPU)" \
        "34" "> Torch 2.2.1 (CUDA 11.8) + xFormers 0.0.25" \
        "33" "> Torch 2.2.1 (CUDA 12.1) + xFormers 0.0.25" \
        "32" "> Torch 2.2.1 (RoCM 5.7) (Linux)" \
        "31" "> Torch 2.2.1 (DirectML)" \
        "30" "> Torch 2.2.1 (CPU)" \
        "29" "> Torch 2.2.0 (CUDA 11.8) + xFormers 0.0.24" \
        "28" "> Torch 2.2.0 (CUDA 12.1) + xFormers 0.0.24" \
        "27" "> Torch 2.2.0 (RoCM 5.7) (Linux)" \
        "26" "> Torch 2.2.0 (CPU)" \
        "25" "> Torch 2.1.2 (CUDA 11.8) + xFormers 0.0.23.post1" \
        "24" "> Torch 2.1.2 (CUDA 12.1) + xFormers 0.0.23.post1" \
        "23" "> Torch 2.1.2 (RoCM 5.6) (Linux)" \
        "22" "> Torch 2.1.2 (CPU)" \
        "21" "> Torch 2.1.1 (CUDA 11.8) + xFormers 0.0.23" \
        "20" "> Torch 2.1.1 (CUDA 12.1) + xFormers 0.0.23" \
        "19" "> Torch 2.1.1 (RoCM 5.6) (Linux)" \
        "18" "> Torch 2.1.1 (CPU)" \
        "17" "> Torch 2.1.0 (Intel Arc)" \
        "16" "> Torch 2.1.0 (Intel Core Ultra)" \
        "15" "> Torch 2.1.0 (RoCM 5.6) (Linux)" \
        "14" "> Torch 2.1.0 (CPU)" \
        "13" "> Torch 2.0.1 (CUDA 11.8) + xFormers 0.0.22" \
        "12" "> Torch 2.0.1 (RoCM 5.4.2) (Linux)" \
        "11" "> Torch 2.0.1 (CPU)" \
        "10" "> Torch 2.0.0 (CUDA 11.8) + xFormers 0.0.18" \
        "9" "> Torch 2.0.0 (Intel Arc)" \
        "8" "> Torch 2.0.0 (DirectML)" \
        "7" "> Torch 2.0.0 (CPU)" \
        "6" "> Torch 1.13.1 (CUDA 11.7) + xFormers 0.0.16" \
        "5" "> Torch 1.13.1 (DirectML)" \
        "4" "> Torch 1.13.1 (CPU)" \
        "3" "> Torch 1.12.1 (CUDA 11.3) + xFormers 0.0.14" \
        "2" "> Torch + xFormers" \
        "1" "> Torch" \
        "0" "> 跳过安装 PyTorch" \
        3>&1 1>&2 2>&3)

    case "${dialog_arg}" in
        0)
            unset INSTALL_PYTORCH_VERSION
            unset INSTALL_XFORMERS_VERSION
            ;;
        1)
            INSTALL_PYTORCH_VERSION="torch torchvision torchaudio"
            ;;
        2)
            INSTALL_PYTORCH_VERSION="torch torchvision torchaudio"
            INSTALL_XFORMERS_VERSION="xformers"
            ;;
        3)
            INSTALL_PYTORCH_VERSION="torch==1.12.1+cu113 torchvision==0.13.1+cu113 torchaudio==1.12.1+cu113"
            INSTALL_XFORMERS_VERSION="xformers==0.0.14"
            ;;
        4)
            INSTALL_PYTORCH_VERSION="torch==1.12.1+cpu torchvision==0.13.1+cpu torchaudio==1.12.1+cpu"
            PYTORCH_TYPE="cpu"
            ;;
        5)
            INSTALL_PYTORCH_VERSION="torch==1.13.1 torchvision==0.14.1 torch-directml==0.1.13.1.dev230413"
            ;;
        6)
            INSTALL_PYTORCH_VERSION="torch==1.13.1+cu117 torchvision==0.14.1+cu117 torchaudio==0.13.1+cu117"
            ;;
        7)
            INSTALL_PYTORCH_VERSION="torch==2.0.0+cpu torchvision==0.15.1+cpu torchaudio==2.0.0+cpu"
            PYTORCH_TYPE="cpu"
            ;;
        8)
            INSTALL_PYTORCH_VERSION="torch==2.0.0 torchvision==0.15.1 torch-directml==0.2.0.dev230426"
            ;;
        9)
            INSTALL_PYTORCH_VERSION="torch(ipex_Arc) 2.0.0"
            PYTORCH_TYPE="ipex_legacy_arc"
            ;;
        10)
            INSTALL_PYTORCH_VERSION="torch==2.0.0+cu118 torchvision==0.15.1+cu118 torchaudio==2.0.0+cu118"
            INSTALL_XFORMERS_VERSION="xformers==0.0.18"
            ;;
        11)
            INSTALL_PYTORCH_VERSION="torch==2.0.1+cpu torchvision==0.15.2+cpu torchaudio==2.0.1+cpu"
            PYTORCH_TYPE="cpu"
            ;;
        12)
            INSTALL_PYTORCH_VERSION="torch==2.0.1+rocm5.4.2 torchvision==0.15.2+rocm5.4.2 torchaudio==2.0.1+rocm5.4.2"
            ;;
        13)
            INSTALL_PYTORCH_VERSION="torch==2.0.1+cu118 torchvision==0.15.2+cu118 torchaudio==2.0.1+cu118"
            INSTALL_XFORMERS_VERSION="xformers==0.0.22"
            ;;
        14)
            INSTALL_PYTORCH_VERSION="torch==2.1.0+cpu torchvision==0.16.0+cpu torchaudio==2.1.0+cpu"
            PYTORCH_TYPE="cpu"
            ;;
        15)
            INSTALL_PYTORCH_VERSION="torch==2.1.0+rocm5.6 torchvision==0.16.0+rocm5.6 torchaudio==2.1.0+rocm5.6"
            ;;
        16)
            INSTALL_PYTORCH_VERSION="torch(ipex_Core_Ultra) 2.1.0"
            PYTORCH_TYPE="ipex_legacy_core_ultra"
            ;;
        17)
            INSTALL_PYTORCH_VERSION="torch(ipex_Arc) 2.1.0"
            PYTORCH_TYPE="ipex_legacy_arc"
            ;;
        18)
            INSTALL_PYTORCH_VERSION="torch==2.1.1+cpu torchvision==0.16.1+cpu torchaudio==2.1.1+cpu"
            PYTORCH_TYPE="cpu"
            ;;
        19)
            INSTALL_PYTORCH_VERSION="torch==2.1.1+rocm5.6 torchvision==0.16.1+rocm5.6 torchaudio==2.1.1+rocm5.6"
            ;;
        20)
            INSTALL_PYTORCH_VERSION="torch==2.1.1+cu121 torchvision==0.16.1+cu121 torchaudio==2.1.1+cu121"
            INSTALL_XFORMERS_VERSION="xformers==0.0.23"
            ;;
        21)
            INSTALL_PYTORCH_VERSION="torch==2.1.1+cu118 torchvision==0.16.1+cu118 torchaudio==2.1.1+cu118"
            INSTALL_XFORMERS_VERSION="xformers==0.0.23+cu118"
            PYTORCH_TYPE="cu118"
            ;;
        22)
            INSTALL_PYTORCH_VERSION="torch==2.1.2+cpu torchvision==0.16.2+cpu torchaudio==2.1.2+cpu"
            PYTORCH_TYPE="cpu"
            ;;
        23)
            INSTALL_PYTORCH_VERSION="torch==2.1.2+rocm5.6 torchvision==0.16.2+rocm5.6 torchaudio==2.1.2+rocm5.6"
            ;;
        24)
            INSTALL_PYTORCH_VERSION="torch==2.1.2+cu121 torchvision==0.16.2+cu121 torchaudio==2.1.2+cu121"
            INSTALL_XFORMERS_VERSION="xformers==0.0.23.post1"
            PYTORCH_TYPE="cu121"
            ;;
        25)
            INSTALL_PYTORCH_VERSION="torch==2.1.2+cu118 torchvision==0.16.2+cu118 torchaudio==2.1.2+cu118"
            INSTALL_XFORMERS_VERSION="xformers==0.0.23.post1+cu118"
            PYTORCH_TYPE="cu118"
            ;;
        26)
            INSTALL_PYTORCH_VERSION="torch==2.2.0+cpu torchvision==0.17.0+cpu torchaudio==2.2.0+cpu"
            PYTORCH_TYPE="cpu"
            ;;
        27)
            INSTALL_PYTORCH_VERSION="torch==2.2.0+rocm5.7 torchvision==0.17.0+rocm5.7 torchaudio==2.2.0+rocm5.7"
            ;;
        28)
            INSTALL_PYTORCH_VERSION="torch==2.2.0+cu121 torchvision==0.17.0+cu121 torchaudio==2.2.0+cu121"
            INSTALL_XFORMERS_VERSION="xformers==0.0.24"
            PYTORCH_TYPE="cu121"
            ;;
        29)
            INSTALL_PYTORCH_VERSION="torch==2.2.0+cu118 torchvision==0.17.0+cu118 torchaudio==2.2.0+cu118"
            INSTALL_XFORMERS_VERSION="xformers==0.0.24+cu118"
            PYTORCH_TYPE="cu118"
            ;;
        30)
            INSTALL_PYTORCH_VERSION="torch==2.2.1+cpu torchvision==0.17.1+cpu torchaudio==2.2.1+cpu"
            PYTORCH_TYPE="cpu"
            ;;
        31)
            INSTALL_PYTORCH_VERSION="torch==2.2.1 torchvision==0.17.1 torch-directml==0.2.1.dev240521"
            ;;
        32)
            INSTALL_PYTORCH_VERSION="torch==2.2.1+rocm5.7 torchvision==0.17.1+rocm5.7 torchaudio==2.2.1+rocm5.7"
            ;;
        33)
            INSTALL_PYTORCH_VERSION="torch==2.2.1+cu121 torchvision==0.17.1+cu121 torchaudio==2.2.1+cu121"
            INSTALL_XFORMERS_VERSION="xformers==0.0.25"
            PYTORCH_TYPE="cu121"
            ;;
        34)
            INSTALL_PYTORCH_VERSION="torch==2.2.1+cu118 torchvision==0.17.1+cu118 torchaudio==2.2.1+cu118"
            INSTALL_XFORMERS_VERSION="xformers==0.0.25+cu118"
            PYTORCH_TYPE="cu118"
            ;;
        35)
            INSTALL_PYTORCH_VERSION="torch==2.2.2+cpu torchvision==0.17.2+cpu torchaudio==2.2.2+cpu"
            PYTORCH_TYPE="cpu"
            ;;
        36)
            INSTALL_PYTORCH_VERSION="torch==2.2.2+rocm5.7 torchvision==0.17.2+rocm5.7 torchaudio==2.2.2+rocm5.7"
            ;;
        37)
            INSTALL_PYTORCH_VERSION="torch==2.2.2+cu121 torchvision==0.17.2+cu121 torchaudio==2.2.2+cu121"
            INSTALL_XFORMERS_VERSION="xformers==0.0.25.post1"
            PYTORCH_TYPE="cu121"
            ;;
        38)
            INSTALL_PYTORCH_VERSION="torch==2.2.2+cu118 torchvision==0.17.2+cu118 torchaudio==2.2.2+cu118"
            INSTALL_XFORMERS_VERSION="xformers==0.0.25.post1+cu118"
            PYTORCH_TYPE="cu118"
            ;;
        39)
            INSTALL_PYTORCH_VERSION="torch==2.3.0+cpu torchvision==0.18.0+cpu torchaudio==2.3.0+cpu"
            PYTORCH_TYPE="cpu"
            ;;
        40)
            INSTALL_PYTORCH_VERSION="torch==2.3.0+rocm6.0 torchvision==0.18.0+rocm6.0 torchaudio==2.3.0+rocm6.0"
            ;;
        41)
            INSTALL_PYTORCH_VERSION="torch==2.3.0+cu121 torchvision==0.18.0+cu121 torchaudio==2.3.0+cu121"
            INSTALL_XFORMERS_VERSION="xformers==0.0.26.post1"
            PYTORCH_TYPE="cu121"
            ;;
        42)
            INSTALL_PYTORCH_VERSION="torch==2.3.0+cu118 torchvision==0.18.0+cu118 torchaudio==2.3.0+cu118"
            INSTALL_XFORMERS_VERSION="xformers==0.0.26.post1+cu118"
            PYTORCH_TYPE="cu118"
            ;;
        43)
            INSTALL_PYTORCH_VERSION="torch==2.3.1+cpu torchvision==0.18.1+cpu torchaudio==2.3.1+cpu"
            PYTORCH_TYPE="cpu"
            ;;
        44)
            INSTALL_PYTORCH_VERSION="torch==2.3.1 torchvision==0.18.1 torch-directml==0.2.3.dev240715"
            ;;
        45)
            INSTALL_PYTORCH_VERSION="torch==2.3.1+rocm6.0 torchvision==0.18.1+rocm6.0 torchaudio==2.3.1+rocm6.0"
            ;;
        46)
            INSTALL_PYTORCH_VERSION="torch==2.3.1+cu121 torchvision==0.18.1+cu121 torchaudio==2.3.1+cu121"
            INSTALL_XFORMERS_VERSION="xformers==0.0.27"
            PYTORCH_TYPE="cu121"
            ;;
        47)
            INSTALL_PYTORCH_VERSION="torch==2.3.1+cu118 torchvision==0.18.1+cu118 torchaudio==2.3.1+cu118"
            INSTALL_XFORMERS_VERSION="xformers==0.0.27+cu118"
            PYTORCH_TYPE="cu118"
            ;;
        48)
            INSTALL_PYTORCH_VERSION="torch==2.4.0+cpu torchvision==0.19.0+cpu torchaudio==2.4.0+cpu"
            PYTORCH_TYPE="cpu"
            ;;
        49)
            INSTALL_PYTORCH_VERSION="torch==2.4.0+rocm6.0 torchvision==0.19.0+rocm6.0 torchaudio==2.4.0+rocm6.0"
            ;;
        50)
            INSTALL_PYTORCH_VERSION="torch==2.4.0+cu124 torchvision==0.19.0+cu124 torchaudio==2.4.0+cu124"
            PYTORCH_TYPE="cu124"
            ;;
        51)
            INSTALL_PYTORCH_VERSION="torch==2.4.0+cu121 torchvision==0.19.0+cu121 torchaudio==2.4.0+cu121"
            INSTALL_XFORMERS_VERSION="xformers==0.0.27.post2"
            PYTORCH_TYPE="cu121"
            ;;
        52)
            INSTALL_PYTORCH_VERSION="torch==2.4.0+cu118 torchvision==0.19.0+cu118 torchaudio==2.4.0+cu118"
            INSTALL_XFORMERS_VERSION="xformers==0.0.27.post2+cu118"
            PYTORCH_TYPE="cu118"
            ;;
        53)
            INSTALL_PYTORCH_VERSION="torch==2.4.1+cpu torchvision==0.19.1+cpu torchaudio==2.4.1+cpu"
            PYTORCH_TYPE="cpu"
            ;;
        54)
            INSTALL_PYTORCH_VERSION="torch==2.4.1+rocm6.1 torchvision==0.19.1+rocm6.1 torchaudio==2.4.1+rocm6.1"
            INSTALL_XFORMERS_VERSION="xformers===0.0.28.post1"
            PYTORCH_TYPE="rocm61"
            ;;
        55)
            INSTALL_PYTORCH_VERSION="torch==2.4.1+cu124 torchvision==0.19.1+cu124 torchaudio==2.4.1+cu124"
            INSTALL_XFORMERS_VERSION="xformers===0.0.28.post1"
            PYTORCH_TYPE="cu124"
            ;;
        56)
            INSTALL_PYTORCH_VERSION="torch==2.4.1+cu121 torchvision==0.19.1+cu121 torchaudio==2.4.1+cu121"
            INSTALL_XFORMERS_VERSION="xformers===0.0.28.post1"
            PYTORCH_TYPE="cu121"
            ;;
        57)
            INSTALL_PYTORCH_VERSION="torch==2.4.1+cu118 torchvision==0.19.1+cu118 torchaudio==2.4.1+cu118"
            INSTALL_XFORMERS_VERSION="xformers===0.0.28.post1"
            PYTORCH_TYPE="cu118"
            ;;
        58)
            INSTALL_PYTORCH_VERSION="torch==2.5.0+cpu torchvision==0.20.0+cpu torchaudio==2.5.0+cpu"
            PYTORCH_TYPE="cpu"
            ;;
        59)
            INSTALL_PYTORCH_VERSION="torch==2.5.0+rocm6.2 torchvision==0.20.0+rocm6.2 torchaudio==2.5.0+rocm6.2"
            PYTORCH_TYPE="rocm62"
            ;;
        60)
            INSTALL_PYTORCH_VERSION="torch==2.5.0+rocm6.1 torchvision==0.20.0+rocm6.1 torchaudio==2.5.0+rocm6.1"
            INSTALL_XFORMERS_VERSION="xformers==0.0.28.post2"
            PYTORCH_TYPE="rocm61"
            ;;
        61)
            INSTALL_PYTORCH_VERSION="torch==2.5.0+cu124 torchvision==0.20.0+cu124 torchaudio==2.5.0+cu124"
            INSTALL_XFORMERS_VERSION="xformers==0.0.28.post2"
            PYTORCH_TYPE="cu124"
            ;;
        62)
            INSTALL_PYTORCH_VERSION="torch==2.5.0+cu121 torchvision==0.20.0+cu121 torchaudio==2.5.0+cu121"
            INSTALL_XFORMERS_VERSION="xformers==0.0.28.post2"
            PYTORCH_TYPE="cu121"
            ;;
        63)
            INSTALL_PYTORCH_VERSION="torch==2.5.0+cu118 torchvision==0.20.0+cu118 torchaudio==2.5.0+cu118"
            INSTALL_XFORMERS_VERSION="xformers==0.0.28.post2"
            PYTORCH_TYPE="cu118"
            ;;
        64)
            INSTALL_PYTORCH_VERSION="torch==2.5.1+cpu torchvision==0.20.1+cpu torchaudio==2.5.1+cpu"
            PYTORCH_TYPE="cpu"
            ;;
        65)
            INSTALL_PYTORCH_VERSION="torch==2.5.1+rocm6.2 torchvision==0.20.1+rocm6.2 torchaudio==2.5.1+rocm6.2"
            PYTORCH_TYPE="rocm62"
            ;;
        66)
            INSTALL_PYTORCH_VERSION="torch==2.5.1+rocm6.1 torchvision==0.20.1+rocm6.1 torchaudio==2.5.1+rocm6.1"
            INSTALL_XFORMERS_VERSION="xformers==0.0.28.post3"
            PYTORCH_TYPE="rocm61"
            ;;
        67)
            INSTALL_PYTORCH_VERSION="torch==2.5.1+cu124 torchvision==0.20.1+cu124 torchaudio==2.5.1+cu124"
            INSTALL_XFORMERS_VERSION="xformers==0.0.28.post3"
            PYTORCH_TYPE="cu124"
            ;;
        68)
            INSTALL_PYTORCH_VERSION="torch==2.5.1+cu121 torchvision==0.20.1+cu121 torchaudio==2.5.1+cu121"
            INSTALL_XFORMERS_VERSION="xformers==0.0.28.post3"
            PYTORCH_TYPE="cu121"
            ;;
        69)
            INSTALL_PYTORCH_VERSION="torch==2.5.1+cu118 torchvision==0.20.1+cu118 torchaudio==2.5.1+cu118"
            INSTALL_XFORMERS_VERSION="xformers==0.0.28.post3"
            PYTORCH_TYPE="cu118"
            ;;
        70)
            INSTALL_PYTORCH_VERSION="torch==2.6.0+cpu torchvision==0.21.0+cpu torchaudio==2.6.0+cpu"
            INSTALL_XFORMERS_VERSION="xformers==0.0.29.post3"
            PYTORCH_TYPE="cpu"
            ;;
        71)
            INSTALL_PYTORCH_VERSION="torch==2.6.0+rocm6.2.4 torchvision==0.21.0+rocm6.2.4 torchaudio==2.6.0+rocm6.2.4"
            INSTALL_XFORMERS_VERSION="xformers==0.0.29.post3"
            PYTORCH_TYPE="rocm624"
            ;;
        72)
            INSTALL_PYTORCH_VERSION="torch==2.6.0+rocm6.1 torchvision==0.21.0+rocm6.1 torchaudio==2.6.0+rocm6.1"
            INSTALL_XFORMERS_VERSION="xformers==0.0.29.post3"
            PYTORCH_TYPE="rocm61"
            ;;
        73)
            INSTALL_PYTORCH_VERSION="torch==2.6.0+xpu torchvision==0.21.0+xpu torchaudio==2.6.0+xpu"
            PYTORCH_TYPE="ipex"
            ;;
        74)
            INSTALL_PYTORCH_VERSION="torch==2.6.0+cu126 torchvision==0.21.0+cu126 torchaudio==2.6.0+cu126"
            INSTALL_XFORMERS_VERSION="xformers==0.0.29.post3"
            PYTORCH_TYPE="cu126"
            ;;
        75)
            INSTALL_PYTORCH_VERSION="torch==2.6.0+cu124 torchvision==0.21.0+cu124 torchaudio==2.6.0+cu124"
            INSTALL_XFORMERS_VERSION="xformers==0.0.29.post3"
            PYTORCH_TYPE="cu124"
            ;;
        76)
            INSTALL_PYTORCH_VERSION="torch==2.6.0+cu118 torchvision==0.21.0+cu118 torchaudio==2.6.0+cu118"
            INSTALL_XFORMERS_VERSION="xformers==0.0.29.post3"
            PYTORCH_TYPE="cu118"
            ;;
    esac
}

# 设置 Pip 的安装模式
# 选择后设置 PIP_UPDATE_PACKAGE_ARG, PIP_USE_PEP517_ARG, PIP_FORCE_REINSTALL_ARG, PIP_BREAK_SYSTEM_PACKAGE_ARG 全局变量
# 使用:
# pip_install_mode_select <要默认启用的参数>
# 参数对应的选项:
# upgrade: 更新软件包 (--upgrade)
# pep517: 标准构建安装 (--use-pep517)
# force_reinstall: 强制重新安装 (--force-reinstall)
# break_system_package: 强制使用 Pip 安装 (--break-system-packages)
pip_install_mode_select() {
    local dialog_arg
    local i
    local use_upgrade="OFF"
    local use_pep517="OFF"
    local use_force_reinstall="OFF"
    local use_break_system_package="OFF"
    unset PIP_UPDATE_PACKAGE_ARG
    unset PIP_USE_PEP517_ARG
    unset PIP_FORCE_REINSTALL_ARG
    unset PIP_BREAK_SYSTEM_PACKAGE_ARG

    # 界面预设
    for i in $@; do
        case "${i}" in
            upgrade)
                use_upgrade="ON"
                ;;
            pep517)
                use_pep517="ON"
                ;;
            force_reinstall)
                use_force_reinstall="ON"
                ;;
            break_system_package)
                use_break_system_package="ON"
                ;;
        esac
    done

    dialog_arg=$(dialog --erase-on-exit --notags \
        --title "Term-SD" \
        --backtitle "Pip 安装模式选项" \
        --ok-label "确认" --no-cancel \
        --checklist "请选择 Pip 安装方式, 注:\n1. 安装时更新软件包\n2. 标准构建安装可解决一些报错问题, 但速度较慢\n3. 软件包存在时将重新安装\n4. 忽略系统警告强制使用 Pip 安装软件包" \
        $(get_dialog_size_menu) \
        "1" "> 更新软件包 (--upgrade)" "${use_upgrade}" \
        "2" "> 标准构建安装 (--use-pep517)" "${use_pep517}" \
        "3" "> 强制重新安装 (--force-reinstall)" "${use_force_reinstall}" \
        "4" "> 强制使用 Pip 安装 (--break-system-packages)" "${use_break_system_package}" \
        3>&1 1>&2 2>&3)

    for i in ${dialog_arg}; do
        case "${i}" in
            1)
                PIP_UPDATE_PACKAGE_ARG="--upgrade"
                ;;
            2)
                PIP_USE_PEP517_ARG="--use-pep517"
                ;;
            3)
                PIP_FORCE_REINSTALL_ARG="--force-reinstall"
                ;;
            4)
                PIP_BREAK_SYSTEM_PACKAGE_ARG="--break-system-packages"
                ;;
        esac
    done
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
    local xformers_ver_info
    local use_break_system_package_info
    local use_pep517_info
    local use_force_reinstall_info
    local use_upgrade_info
    local use_prefer_binary_info

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

    if [[ ! -z "${INSTALL_XFORMERS_VERSION}" ]]; then
        xformers_ver_info=$INSTALL_XFORMERS_VERSION
    else
        xformers_ver_info="无"
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

    if [[ ! -z "${PIP_UPDATE_PACKAGE_ARG}" ]]; then
        use_upgrade_info="启用"
    else
        use_upgrade_info="禁用"
    fi

    if (dialog --erase-on-exit \
        --title "Term-SD" \
        --backtitle "安装确认选项" \
        --yes-label "是" --no-label "否" \
        --yesno "$@\n
PyPI 镜像源: ${use_pip_info}\n
Github 镜像: ${use_github_mirror_info}\n
Huggingface / Github 下载源独占代理: ${enable_only_proxy_info}\n
使用 ModelScope 模型下载源: ${use_modelscope_src_info}\n
强制使用 Pip: ${use_break_system_package_info}\n
PyTorch 版本: ${pytorch_ver_info}\n
xFormers 版本: ${xformers_ver_info}\n
Pip 安装方式: ${use_pep517_info}\n
Pip 强制重装: ${use_force_reinstall_info}\n
Pip 更新软件包: ${use_upgrade_info}\
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
        term_sd_echo "INSTALL_XFORMERS_VERSION: ${INSTALL_XFORMERS_VERSION}"
        term_sd_echo "PIP_USE_PEP517_ARG: ${PIP_USE_PEP517_ARG}"
        term_sd_echo "PIP_FORCE_REINSTALL_ARG: ${PIP_FORCE_REINSTALL_ARG}"
        term_sd_echo "PIP_UPDATE_PACKAGE_ARG: ${PIP_UPDATE_PACKAGE_ARG}"
        term_sd_echo "PYTORCH_TYPE: ${PYTORCH_TYPE}"
        term_sd_echo "SD_WEBUI_REPO: ${SD_WEBUI_REPO}"
        term_sd_echo "SD_WEBUI_BRANCH: ${SD_WEBUI_BRANCH}"
    fi

    unset PIP_INDEX_MIRROR # 指定 PyPI 镜像源的参数
    unset PIP_EXTRA_INDEX_MIRROR
    unset PIP_FIND_LINKS_MIRROR
    unset USE_PIP_MIRROR # 是否启用 Pip 镜像
    unset PIP_BREAK_SYSTEM_PACKAGE_ARG # 是否在 Pip 使用 --break-system-package 参数
    unset TERM_SD_ENABLE_ONLY_PROXY # 是否启用 Github / HuggingFace 独占代理功能
    unset USE_MODELSCOPE_MODEL_SRC # 是否使用 ModelScope 模型站下载模型
    unset GITHUB_MIRROR # Github 镜像的格式, 如: "https://github.com/term_sd_git_user/term_sd_git_repo", 需进行处理后才能使用
    unset GITHUB_MIRROR_NAME # 展示 Github 镜像源的名称
    unset INSTALL_PYTORCH_VERSION # 要安装的 PyTorch 版本
    unset INSTALL_XFORMERS_VERSION # 要安装的 xFormers 版本
    unset PIP_USE_PEP517_ARG # 是否在 Pip 使用 --use-pep517 参数
    unset PIP_FORCE_REINSTALL_ARG # 是否在 Pip 使用 --force-reinstall 参数
    unset PIP_UPDATE_PACKAGE_ARG # 是否更新软件包, 使用 --upgrade 参数
    unset PYTORCH_TYPE # PyTorch 种类, 用于切换 PyTorch 镜像源
    unset SD_WEBUI_REPO # SD WebUI 远程源地址, 用于安装 SD WebUI 时选择要安装的分支
    unset SD_WEBUI_BRANCH # SD WebUI 分支, 用于安装 SD WebUI 时选择要切换成的分支
}

# 如果启用了 PyPI 镜像源, 则返回0
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
