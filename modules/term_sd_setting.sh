#!/bin/bash

# Term-SD 设置
term_sd_setting() {
    local dialog_arg
    local pip_mirror_setup_info
    local venv_setup_info
    local proxy_setup_info
    local github_mirror_setup_info
    local term_sd_cmd_retry_setup_info
    local term_sd_enable_strict_install_mode_setup_info
    local aria2_thread_setup_info
    local term_sd_path_redirect_setup_info
    local cuda_memory_alloc_setup_info
    local env_check_setup_info

    while true; do
        if is_use_venv; then
            venv_setup_info="启用"
        else
            venv_setup_info="禁用"
        fi

        if [[ -z "${PIP_INDEX_URL}" ]]; then
            pip_mirror_setup_info="未设置"
        elif [[ ! -z "$(echo ${PIP_INDEX_URL} | grep "pypi.python.org")" ]]; then
            pip_mirror_setup_info="官方源"
        else
            pip_mirror_setup_info="国内镜像源"
        fi

        if [[ -z "${HTTP_PROXY}" ]]; then
            proxy_setup_info="无"
        else
            proxy_setup_info="代理地址: $(echo ${HTTP_PROXY} | awk '{print substr($1,1,40)}')"
        fi

        if [[ -f "${START_PATH}/term-sd/config/set-global-github-mirror.conf" ]]; then
            github_mirror_setup_info="镜像源: $(cat "${START_PATH}/term-sd/config/set-global-github-mirror.conf")"
        else
            github_mirror_setup_info="未设置"
        fi

        if [[ -f "${START_PATH}/term-sd/config/set-global-huggingface-mirror.conf" ]]; then
            huggingface_mirror_setup_info="镜像源: ${HF_ENDPOINT}"
        else
            huggingface_mirror_setup_info="未设置"
        fi

        if [[ -f "${START_PATH}/term-sd/config/term-sd-watch-retry.conf" ]]; then
            term_sd_cmd_retry_setup_info="启用(重试次数: $(cat "${START_PATH}/term-sd/config/term-sd-watch-retry.conf"))"
        else
            term_sd_cmd_retry_setup_info="禁用"
        fi

        if [[ ! -f "${START_PATH}/term-sd/config/term-sd-disable-strict-install-mode.lock" ]]; then
            term_sd_enable_strict_install_mode_setup_info="严格模式"
        else
            term_sd_enable_strict_install_mode_setup_info="宽容模式"
        fi

        if [[ -f "${START_PATH}/term-sd/config/set-aria2-thread.conf" ]]; then
            aria2_thread_setup_info="启用 (线程数: $(cat "${START_PATH}/term-sd/config/set-aria2-thread.conf"))"
        else
            aria2_thread_setup_info="禁用"
        fi

        if [[ ! -f "${START_PATH}/term-sd/config/disable-cache-path-redirect.lock" ]]; then
            term_sd_path_redirect_setup_info="启用"
        else
            term_sd_path_redirect_setup_info="禁用"
        fi

        if [[ -f "${START_PATH}/term-sd/config/set-cuda-memory-alloc.lock" ]]; then
            cuda_memory_alloc_setup_info="启用"
        else
            cuda_memory_alloc_setup_info="禁用"
        fi

        if [[ ! -f "${START_PATH}/term-sd/config/disable-env-check.lock" ]]; then
            env_check_setup_info="启用"
        else
            env_check_setup_info="禁用"
        fi

        dialog_arg=$(dialog --erase-on-exit --notags \
            --title "Term-SD" \
            --backtitle "Term-SD 设置选项" \
            --ok-label "确认" \
            --cancel-label "取消" \
            --menu "请选择 Term-SD 设置" \
            $(get_dialog_size_menu) \
            "0" "> 返回" \
            "1" "> 虚拟环境设置 (${venv_setup_info})" \
            "2" "> PyPI 镜像源设置 (配置文件, 已弃用)" \
            "3" "> PyPI 镜像源设置 (环境变量)(${pip_mirror_setup_info})" \
            "4" "> Pip 缓存清理" \
            "5" "> 代理设置 (${proxy_setup_info})" \
            "6" "> Github 镜像源设置 (${github_mirror_setup_info})" \
            "7" "> HuggingFace 镜像源设置 (${huggingface_mirror_setup_info})" \
            "8" "> 命令执行监测设置 (${term_sd_cmd_retry_setup_info})" \
            "9" "> Term-SD 安装模式 (${term_sd_enable_strict_install_mode_setup_info})" \
            "10" "> Aria2 线程设置 (${aria2_thread_setup_info})" \
            "11" "> 缓存重定向设置 (${term_sd_path_redirect_setup_info})" \
            "12" "> CUDA 内存分配设置 (${cuda_memory_alloc_setup_info})" \
            "13" "> 运行环境检测设置 (${env_check_setup_info})" \
            "14" "> 自定义安装路径" \
            "15" "> 空间占用分析" \
            "16" "> 网络连接测试" \
            "17" "> 卸载 Term-SD" \
            3>&1 1>&2 2>&3)

        case "${dialog_arg}" in
            1)
                python_venv_setting
                ;;
            2)
                pip_mirrors_setting
                ;;
            3)
                pip_mirrors_env_setting
                ;;
            4)
                pip_cache_clean
                ;;
            5)
                term_sd_proxy_setting
                ;;
            6)
                term_sd_git_global_mirror_setting
                ;;
            7)
                term_sd_huggingface_global_mirror_setting
                ;;
            8)
                term_sd_try_setting
                ;;
            9)
                term_sd_enable_strict_install_mode_setting
                ;;
            10)
                aria2_multi_threaded_setting
                ;;
            11)
                term_sd_cache_redirect_setting
                ;;
            12)
                cuda_memory_alloc_setting
                ;;
            13)
                env_check_setting
                ;;
            14)
                custom_install_path_setting
                ;;
            15)
                term_sd_disk_space_stat
                ;;
            16)
                term_sd_network_test
                ;;
            17)
                term_sd_uninstall_interface
                ;;
            *)
                break
                ;;
        esac
    done
}

# 安装模式设置
# 使用 TERM_SD_ENABLE_STRICT_INSTALL_MODE 全局变量保存 Term-SD 安装模式的选择情况
# 使用 <Start Path>/term-sd/config/term-sd-disable-strict-install-mode.lock 文件保存安装模式配置
term_sd_enable_strict_install_mode_setting() {
    local dialog_arg
    export TERM_SD_ENABLE_STRICT_INSTALL_MODE
    local enable_strict_mode_info

    while true; do
        if [[ ! -f "${START_PATH}/term-sd/config/term-sd-disable-strict-install-mode.lock" ]]; then
            enable_strict_mode_info="严格模式"
        else
            enable_strict_mode_info="宽容模式"
        fi

        dialog_arg=$(dialog --erase-on-exit --notags \
            --title "Term-SD" \
            --backtitle "安装模式设置界面" \
            --ok-label "确认" --cancel-label "取消" \
            --menu "该功能用于设置 Term-SD 安装 AI 软件的工作模式。当启用 \"严格模式\" 后, Term-SD 在安转 AI 软件时出现执行失败的命令时将停止安装进程 (Term-SD 支持断点恢复, 可恢复上次安装进程中断的位置), 而 \"宽容模式\" 在安转 AI 软件时出现执行失败的命令时忽略执行失败的命令, 继续执行完成安装任务\n当前安装模式: $()\n请选择要设置的安装模式 (默认启用严格模式)" \
            $(get_dialog_size_menu) \
            "0" "> 返回" \
            "1" "> 严格模式" \
            "2" "> 宽容模式" \
            3>&1 1>&2 2>&3)

        case $dialog_arg in
            1)
                TERM_SD_ENABLE_STRICT_INSTALL_MODE=1
                rm -f "${START_PATH}/term-sd/config/term-sd-disable-strict-install-mode.lock"

                dialog --erase-on-exit \
                    --title "Term-SD" \
                    --backtitle "安装模式设置界面" \
                    --ok-label "确认" \
                    --msgbox "启用严格模式完成" \
                    $(get_dialog_size)
                ;;
            2)
                TERM_SD_ENABLE_STRICT_INSTALL_MODE=0
                touch "${START_PATH}/term-sd/config/term-sd-disable-strict-install-mode.lock"

                dialog --erase-on-exit \
                    --title "Term-SD" \
                    --backtitle "安装模式设置界面" \
                    --ok-label "确认" \
                    --msgbox "启用宽容模式完成" \
                    $(get_dialog_size)
                ;;
            *)
                break
                ;;
        esac
    done
}

# Aria2 线程设置
# 使用 ARIA2_MULTI_THREAD 全局变量设置 Aria2 线程数量
# Aria2 线程配置保存在 <Start Path>/term-sd/config/set-aria2-thread.conf
aria2_multi_threaded_setting() {
    local dialog_arg
    local aria2_multi_threaded_value
    local aria2_thread_info
    local aria2_config

    while true; do
        if [[ -f "${START_PATH}/term-sd/config/set-aria2-thread.conf" ]]; then
            aria2_thread_info="启用 (线程数: $(cat "${START_PATH}/term-sd/config/set-aria2-thread.conf"))"
        else
            aria2_thread_info="禁用"
        fi

        dialog_arg=$(dialog --erase-on-exit --notags \
            --title "Term-SD" \
            --backtitle "Aria2线程设置界面" \
            --ok-label "确认" --cancel-label "取消" \
            --menu "该功能用于增加 Term-SD 在使用 Aria2 下载模型时的线程数, 在一定程度上提高下载速度\n当前状态: ${aria2_thread_info}\n是否启用 Aria2 多线程下载 ?" \
            $(get_dialog_size_menu) \
            "0" "> 返回" \
            "1" "> 启用" \
            "2" "> 禁用" \
            3>&1 1>&2 2>&3)

        case "${dialog_arg}" in
            1)
                if [[ -f "${START_PATH}/term-sd/config/set-aria2-thread.conf" ]]; then
                    aria2_config=$(cat "${START_PATH}/term-sd/config/set-aria2-thread.conf")
                else
                    unset aria2_config
                fi

                aria2_multi_threaded_value=$(dialog --erase-on-exit \
                    --title "Term-SD" \
                    --backtitle "Aria2 线程设置界面" \
                    --ok-label "确认" --cancel-label "取消" \
                    --inputbox "请输入线程数 (仅输入数字, 不允许输入负数和其他非数字的字符)" \
                    $(get_dialog_size) \
                    "${aria2_config}" \
                    3>&1 1>&2 2>&3)

                if [[ ! -z "$(awk '{gsub(/[0-9]/, "")}1' <<< ${aria2_multi_threaded_value})" ]] \
                    || (( aria2_multi_threaded_value <= 0)); then
                    dialog --erase-on-exit \
                        --title "Term-SD" \
                        --backtitle "Aria2 线程设置界面" \
                        --ok-label "确认" \
                        --msgbox "输入格式错误, 线程数只能为数字且不能为负数" \
                        $(get_dialog_size)

                else
                    if [[ ! -z "${aria2_multi_threaded_value}" ]]; then
                        if (( $aria2_multi_threaded_value <= 16 )); then
                            echo "${aria2_multi_threaded_value}" > "${START_PATH}/term-sd/config/set-aria2-thread.conf"
                            ARIA2_MULTI_THREAD=$aria2_multi_threaded_value

                            dialog --erase-on-exit \
                                --title "Term-SD" \
                                --backtitle "Aria2 线程设置界面" \
                                --ok-label "确认" \
                                --msgbox "启用 Aria2 多线程下载成功, Aria2 线程数: ${ARIA2_MULTI_THREAD}" \
                                $(get_dialog_size)
                        else
                            echo "16" > "${START_PATH}/term-sd/config/set-aria2-thread.conf"
                            ARIA2_MULTI_THREAD=16

                            dialog --erase-on-exit \
                                --title "Term-SD" \
                                --backtitle "Aria2 线程设置界面" \
                                --ok-label "确认" \
                                --msgbox "启用 Aria2 多线程下载成功, Aria2 线程数: ${ARIA2_MULTI_THREAD}" \
                                $(get_dialog_size)
                        fi
                    else

                        dialog --erase-on-exit \
                            --title "Term-SD" \
                            --backtitle "Aria2 线程设置界面" \
                            --ok-label "确认" \
                            --msgbox "未输入, 请重试" \
                            $(get_dialog_size)
                    fi
                fi
                ;;
            2)
                rm -f "${START_PATH}/term-sd/config/set-aria2-thread.conf"
                ARIA2_MULTI_THREAD=1

                dialog --erase-on-exit \
                    --title "Term-SD" \
                    --backtitle "Aria2 线程设置界面" \
                    --ok-label "确认" \
                    --msgbox "禁用 Aria2 多线程下载成功" \
                    $(get_dialog_size)
                ;;
            *)
                break
                ;;
        esac
    done
}

# 缓存重定向设置
# 通过以下环境变量设置缓存路径:
# CACHE_HOME, HF_HOME, MATPLOTLIBRC
# MODELSCOPE_CACHE, MS_CACHE_HOME, SYCL_CACHE_DIR
# TORCH_HOME, U2NET_HOME, XDG_CACHE_HOME, PIP_CACHE_DIR, PYTHONPYCACHEPREFIX
# 缓存重定向的配置保存在 <Start Path>/term-sd/config/disable-cache-path-redirect.lock
term_sd_cache_redirect_setting() {
    local dialog_arg
    local cache_redirect_info

    while true; do
        if [[ ! -f "${START_PATH}/term-sd/config/disable-cache-path-redirect.lock" ]]; then
            cache_redirect_info="启用"
        else
            cache_redirect_info="禁用"
        fi

        dialog_arg=$(dialog --erase-on-exit --notags \
            --title "Term-SD" \
            --backtitle "缓存重定向设置界面" \
            --ok-label "确认" \
            --cancel-label "取消" \
            --menu "该功能将会把 AI 软件产生的缓存重定向至 Term-SD 中 (便于清理)\n当前状态: ${cache_redirect_info}\n是否启用缓存重定向 ?" \
            $(get_dialog_size_menu) \
            "0" "> 返回" \
            "1" "> 启用" \
            "2" "> 禁用" \
            3>&1 1>&2 2>&3)

        case "${dialog_arg}" in
            1)
                rm -f "${START_PATH}/term-sd/config/disable-cache-path-redirect.lock"
                export CACHE_HOME="${START_PATH}/term-sd/cache"
                export HF_HOME="${START_PATH}/term-sd/cache/huggingface"
                export MATPLOTLIBRC="${START_PATH}/term-sd/cache"
                export MODELSCOPE_CACHE="${START_PATH}/term-sd/cache/modelscope/hub"
                export MS_CACHE_HOME="${START_PATH}/term-sd/cache/modelscope/hub"
                export SYCL_CACHE_DIR="${START_PATH}/term-sd/cache/libsycl_cache"
                export TORCH_HOME="${START_PATH}/term-sd/cache/torch"
                export U2NET_HOME="${START_PATH}/term-sd/cache/u2net"
                export XDG_CACHE_HOME="${START_PATH}/term-sd/cache"
                export PIP_CACHE_DIR="${START_PATH}/term-sd/cache/pip"
                export PYTHONPYCACHEPREFIX="${START_PATH}/term-sd/cache/pycache"
                export TORCHINDUCTOR_CACHE_DIR="${START_PATH}/term-sd/cache/torchinductor"
                export TRITON_CACHE_DIR="${START_PATH}/term-sd/cache/triton"

                dialog --erase-on-exit \
                    --title "Term-SD" \
                    --backtitle "缓存重定向设置界面" \
                    --ok-label "确认" \
                    --msgbox "启用成功" \
                    $(get_dialog_size)
                ;;
            2)
                touch -f "${START_PATH}/term-sd/config/disable-cache-path-redirect.lock"
                unset CACHE_HOME
                unset HF_HOME
                unset MATPLOTLIBRC
                unset MODELSCOPE_CACHE
                unset MS_CACHE_HOME
                unset SYCL_CACHE_DIR
                unset TORCH_HOME
                unset U2NET_HOME
                unset XDG_CACHE_HOME
                unset PIP_CACHE_DIR
                unset PYTHONPYCACHEPREFIX
                unset TORCHINDUCTOR_CACHE_DIR
                unset TRITON_CACHE_DIR

                dialog --erase-on-exit \
                    --title "Term-SD" \
                    --backtitle "缓存重定向设置界面" \
                    --ok-label "确认" \
                    --msgbox "禁用成功" \
                    $(get_dialog_size)
                ;;
            *)
                break
                ;;
        esac
    done
}

# 储存占用分析
term_sd_disk_space_stat() {
    local disk_free_space_stat
    local term_sd_space_stat
    local sd_webui_space_stat
    local comfyui_space_stat
    local invokeai_space_stat
    local fooocus_space_stat
    local lora_scripts_space_stat
    local kohya_ss_space_stat

    term_sd_echo "统计空间占用中"
    term_sd_echo "统计当前目录剩余空间"
    disk_free_space_stat=$(df  -h | awk 'NR==2{print$4}')
    term_sd_echo "统计 Term-SD 缓存目录空间占用"
    term_sd_space_stat=$([ -d "term-sd/cache" ] && du -sh term-sd/cache | awk '{print $1}' || echo "无")
    term_sd_echo "统计 Stable-Diffusion-WebUI 占用"
    sd_webui_space_stat=$([ -d "${SD_WEBUI_PATH}" ] && du -sh "${SD_WEBUI_PATH}" | awk '{print $1}' || echo "未安装")
    term_sd_echo "统计 ComfyUI 占用"
    comfyui_space_stat=$([ -d "${COMFYUI_PATH}" ] && du -sh "${COMFYUI_PATH}" | awk '{print $1}' || echo "未安装")
    term_sd_echo "统计 InvokeAI 占用"
    invokeai_space_stat=$([ -d "${INVOKEAI_PATH}" ] && du -sh "${INVOKEAI_PATH}" | awk '{print $1}' || echo "未安装")
    term_sd_echo "统计 Fooocus 占用"
    fooocus_space_stat=$([ -d "${FOOOCUS_PATH}" ] && du -sh "${FOOOCUS_PATH}" | awk '{print $1}' || echo "未安装")
    term_sd_echo "统计 lora-scripts 占用"
    lora_scripts_space_stat=$([ -d "${LORA_SCRIPTS_PATH}" ] && du -sh "${LORA_SCRIPTS_PATH}" | awk '{print $1}' || echo "未安装")
    term_sd_echo "统计 kohya_ss 占用"
    kohya_ss_space_stat=$([ -d "${KOHYA_SS_PATH}" ] && du -sh "${KOHYA_SS_PATH}" | awk '{print $1}' || echo "未安装")

    dialog --erase-on-exit \
        --title "Term-SD" \
        --backtitle "Term-SD 空间占用分析" \
        --ok-label "确认" \
        --msgbox "项目空间占用分析:\n
当前目录剩余空间: ${disk_free_space_stat}\n
Term-SD (重定向) 缓存目录: ${term_sd_space_stat}\n
Stable-Diffusion-WebUI: ${sd_webui_space_stat}\n
ComfyUI: ${comfyui_space_stat}\n
InvokeAI: ${invokeai_space_stat}\n
Fooocus: ${fooocus_space_stat}\n
lora-scripts: ${lora_scripts_space_stat}\n
kohya_ss: ${kohya_ss_space_stat}\n
" $(get_dialog_size)
}

# 网络连接测试
term_sd_network_test() {
    local http_return_code
    local req
    local i
    local network_test_url
    local count
    local sum
    local ip
    local country
    local region
    local city
    local org

    count=1
    network_test_url="google.com huggingface.co modelscope.cn github.com gh.api.99988866.xyz ghfast.top mirror.ghproxy.com gitclone.com gh-proxy.com ghps.cc gh.idayer.com ghproxy.net hf-mirror.com huggingface.sukaka.top"
    sum=$(echo ${network_test_url} | wc -w)
    term_sd_echo "获取网络信息"
    [ -f "term-sd/task/ipinfo.sh" ] && rm -f term-sd/task/ipinfo.sh
    curl -s ipinfo.io >> term-sd/task/ipinfo.sh
    term_sd_echo "测试网络中"
    for i in ${network_test_url}; do
        term_sd_echo "[${count}/${sum}] 测试链接访问: ${i}"
        count=$(( count + 1 ))
        http_return_code=$(curl --connect-timeout 10 -s -o /dev/null -w "%{http_code}" https://${i})
        case ${http_return_code} in
            200|301)
                req="${req} ${i}: 成功 ✓\n"
                ;;
            *)
                req="${req} ${i}: 失败 ×\n"
            ;;
        esac
    done

    ip=$(cat term-sd/task/ipinfo.sh | grep \"ip\"\: | awk '{gsub(/[\\"]/,"") ; sub("ip:","IP: ")}1')
    country=$(cat term-sd/task/ipinfo.sh | grep \"country\"\: | awk '{gsub(/[\\"]/,"") ; sub("country:","地址: ")}1')
    region=$(cat term-sd/task/ipinfo.sh | grep \"region\"\: | awk '{gsub(/[\\"]/,"") ; sub("region:","")}1')
    city=$(cat term-sd/task/ipinfo.sh | grep \"city\"\: | awk '{gsub(/[\\"]/,"") ; sub("city:","")}1')
    org=$(cat term-sd/task/ipinfo.sh | grep \"org\"\: | awk '{gsub(/[\\"]/,"") ; sub("org:","网络提供商: ")}1')

    dialog --erase-on-exit \
        --title "Term-SD" \
        --backtitle "Term-SD 网络测试" \
        --ok-label "确认" \
        --msgbox "网络测试结果:\n
${TERM_SD_DELIMITER}\n
网络信息:\n
${ip}\n
${country}\
${region}\
${city}\n
${org}\n
${TERM_SD_DELIMITER}\n
网站访问:\n
${req}\
${TERM_SD_DELIMITER}\n
" $(get_dialog_size)

    rm -f term-sd/task/ipinfo.sh
}

# 卸载 Term-SD 选项
term_sd_uninstall_interface() {
    if (dialog --erase-on-exit \
        --title "Term-SD" \
        --backtitle "Term-SD 卸载界面" \
        --yes-label "是" --no-label "否" \
        --yesno "警告: 该操作将永久删除 Term-SD 目录中的所有文件, 包括 AI 软件下载的部分模型文件 (存在于 Term-SD 目录中的 cache 文件夹, 如有必要, 请备份该文件夹)\n是否卸载 Term-SD ?" \
        $(get_dialog_size)); then

        term_sd_echo "请再次确认是否删除 Term-SD (yes/no) ?"
        term_sd_echo "警告: 该操作将永久删除 Term-SD"
        term_sd_echo "提示: 输入 yes 或 no 后回车"
        case $(term_sd_read) in
            y|yes|YES|Y)
                term_sd_echo "开始卸载 Term-SD"
                rm -rf term-sd
                rm -f term-sd.sh
                USER_SHELL=$(echo ${SHELL} | awk -F "/" '{print $NF}') # 读取用户所使用的shell
                if [ "${USER_SHELL}" = bash ] || [[ "${USER_SHELL}" == zsh ]]; then
                    sed -i '/# Term-SD/d' ~/."${USER_SHELL}"rc
                    sed -i '/term_sd(){/d' ~/."${USER_SHELL}"rc
                    sed -i '/alias tsd/d' ~/."${USER_SHELL}"rc
                fi
                term_sd_echo "Term-SD 卸载完成"
                exec ${SHELL}
                exit 0
                ;;
            *)
                term_sd_echo "取消卸载操作"
                ;;
        esac
    fi
}

# 是否启用了严格安装模式, 如果启用了则返回 0
term_sd_is_use_strict_install_mode() {
    if [[ "${TERM_SD_ENABLE_STRICT_INSTALL_MODE}" == 1 ]]; then
        return 0
    else
        return 1
    fi
}
