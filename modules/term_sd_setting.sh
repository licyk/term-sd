#!/bin/bash

# 设置
term_sd_setting()
{
    local term_sd_setting_dialog
    local pip_mirror_setup_info
    local venv_setup_info
    local http_proxy_setup_info
    local github_mirror_setup_info
    local term_sd_cmd_retry_setup_info
    local term_sd_install_mode_setup_info
    local aria2_thread_setup_info
    local term_sd_path_redirect_setup_info
    local cuda_memory_alloc_setup_info

    while true
    do
        if [ $venv_setup_status = 0 ];then
            venv_setup_info="启用"
        else
            venv_setup_info="禁用"
        fi

        if [ -z "$PIP_INDEX_URL" ];then
            pip_mirror_setup_info="未设置"
        elif [ ! -z $(echo $PIP_INDEX_URL | grep "pypi.python.org") ];then
            pip_mirror_setup_info="官方源"
        else
            pip_mirror_setup_info="国内镜像源"
        fi

        if [ -z $http_proxy ];then
            http_proxy_setup_info="无"
        else
            http_proxy_setup_info="代理地址: $(echo $http_proxy | awk '{print substr($1,1,40)}')"
        fi

        if [ -f "term-sd/config/set-global-github-mirror.conf" ];then
            github_mirror_setup_info="镜像源: $(cat term-sd/config/set-global-github-mirror.conf)"
        else
            github_mirror_setup_info="未设置"
        fi

        if [ -f "term-sd/config/set-global-huggingface-mirror.conf" ];then
            huggingface_mirror_setup_info="镜像源: $HF_ENDPOINT"
        else
            huggingface_mirror_setup_info="未设置"
        fi

        if [ -f "term-sd/config/term-sd-watch-retry.conf" ];then
            term_sd_cmd_retry_setup_info="启用(重试次数: $(cat term-sd/config/term-sd-watch-retry.conf))"
        else
            term_sd_cmd_retry_setup_info="禁用"
        fi

        if [ ! -f "term-sd/config/term-sd-disable-strict-install-mode.lock" ];then
            term_sd_install_mode_setup_info="严格模式"
        else
            term_sd_install_mode_setup_info="宽容模式"
        fi

        if [ -f "term-sd/config/aria2-thread.conf" ];then
            aria2_thread_setup_info="启用 (线程数: $(cat term-sd/config/aria2-thread.conf | awk '{sub("-x ","")}1'))"
        else
            aria2_thread_setup_info="禁用"
        fi

        if [ ! -f "term-sd/config/disable-cache-path-redirect.lock" ];then
            term_sd_path_redirect_setup_info="启用"
        else
            term_sd_path_redirect_setup_info="禁用"
        fi

        if [ -f "term-sd/config/cuda-memory-alloc.conf" ];then
            cuda_memory_alloc_setup_info=$([ ! -z $(cat term-sd/config/cuda-memory-alloc.conf | grep cudaMallocAsync) ] && echo "CUDA内置异步分配器" || echo "PyTorch原生分配器")
        else
            cuda_memory_alloc_setup_info="未设置"
        fi

        term_sd_setting_dialog=$(dialog --erase-on-exit --notags \
            --title "Term-SD" \
            --backtitle "Term-SD 设置选项" \
            --ok-label "确认" \
            --cancel-label "取消" \
            --menu "请选择 Term-SD 设置" \
            $term_sd_dialog_height $term_sd_dialog_width $term_sd_dialog_menu_height \
            "0" "> 返回" \
            "1" "> 虚拟环境设置 ($venv_setup_info)" \
            "2" "> Pip 镜像源设置 (配置文件)" \
            "3" "> Pip 镜像源设置 (环境变量)($pip_mirror_setup_info)" \
            "4" "> Pip 缓存清理" \
            "5" "> 代理设置 ($http_proxy_setup_info)" \
            "6" "> Github 镜像源设置 ($github_mirror_setup_info)" \
            "7" "> HuggingFace 镜像源设置 ($huggingface_mirror_setup_info)" \
            "8" "> 命令执行监测设置 ($term_sd_cmd_retry_setup_info)" \
            "9" "> Term-SD 安装模式 ($term_sd_install_mode_setup_info)" \
            "10" "> Aria2 线程设置 ($aria2_thread_setup_info)" \
            "11" "> 缓存重定向设置 ($term_sd_path_redirect_setup_info)" \
            "12" "> CUDA 内存分配设置 ($cuda_memory_alloc_setup_info)" \
            "13" "> 自定义安装路径" \
            "14" "> 空间占用分析" \
            "15" "> 网络连接测试" \
            "16" "> 卸载 Term-SD" \
            3>&1 1>&2 2>&3)

        case $term_sd_setting_dialog in
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
                term_sd_install_mode_setting
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
                custom_install_path_setting
                ;;
            14)
                term_sd_disk_space_stat
                ;;
            15)
                term_sd_network_test
                ;;
            16)
                term_sd_uninstall_interface
                ;;
            *)
                break
                ;;
        esac
    done
}

# 代理设置
term_sd_proxy_setting()
{
    local term_sd_proxy_config
    local term_sd_proxy_setting_dialog
    local proxy_address_available
    export http_proxy
    export https_proxy
    export term_sd_proxy

    while true
    do
        if [ ! -z "$http_proxy" ];then
            term_sd_echo "测试代理地址连通性中"
            curl -s --connect-timeout 1 "$http_proxy"
            if [ $? = 0 ];then
                proxy_address_available="(可用 ✓)"
            else
                proxy_address_available="(连接异常 ×)"
            fi
        fi

        term_sd_proxy_setting_dialog=$(dialog --erase-on-exit --notags \
            --title "Term-SD" \
            --backtitle "代理设置界面" \
            --ok-label "确认" --cancel-label "取消" \
            --menu "该功能用于设置代理服务器, 解决 AI 软件和 Term-SD 因网络环境导致无法连接上服务器, 而出现报错的问题\n当前代理设置: $([ -z $http_proxy ] && echo "无" || echo "$http_proxy ${proxy_address_available}")\n请选择要设置的代理协议" \
            $term_sd_dialog_height $term_sd_dialog_width $term_sd_dialog_menu_height \
            "0" "> 返回" \
            "1" "> Http 协议" \
            "2" "> Socks 协议" \
            "3" "> Socks5 协议" \
            "4" "> 自定义协议" \
            "5" "> 删除代理参数" \
            3>&1 1>&2 2>&3)

        case $term_sd_proxy_setting_dialog in
            1)
                term_sd_proxy_config=$(dialog --erase-on-exit \
                    --title "Term-SD" \
                    --backtitle "代理参数设置界面" \
                    --ok-label "确认" --cancel-label "取消" \
                    --inputbox "请输入代理地址\n格式: <ip>:<port>" \
                    $term_sd_dialog_height $term_sd_dialog_width \
                    "$(echo $http_proxy | awk -F'://' '{print $NF}')" \
                    3>&1 1>&2 2>&3)

                if [ $? = 0 ] && [ ! -z "$term_sd_proxy_config" ];then
                    term_sd_proxy_config=$(echo $term_sd_proxy_config | awk '{gsub(/[：]/, ":") ; gsub(/[。]/, ".")}1') # 防止用户输入中文冒号,句号后导致错误
                    http_proxy="http://$term_sd_proxy_config"
                    https_proxy="http://$term_sd_proxy_config"
                    term_sd_proxy=$https_proxy
                    echo "http://$term_sd_proxy_config" > term-sd/config/proxy.conf

                    dialog --erase-on-exit \
                        --title "Term-SD" \
                        --backtitle "代理参数设置界面" \
                        --ok-label "确认" \
                        --msgbox "代理地址: \"$http_proxy\"\n代理协议: \"$(echo $http_proxy | awk -F '://' '{print$NR}')\"\n设置代理完成" \
                        $term_sd_dialog_height $term_sd_dialog_width
                fi
                ;;
            2)
                term_sd_proxy_config=$(dialog --erase-on-exit \
                    --title "Term-SD" \
                    --backtitle "代理参数设置界面" \
                    --ok-label "确认" --cancel-label "取消" \
                    --inputbox "请输入代理地址\n格式: <ip>:<port>" \
                    $term_sd_dialog_height $term_sd_dialog_width "$(echo $http_proxy | awk -F'://' '{print $NF}')" \
                    3>&1 1>&2 2>&3)

                if [ $? = 0 ] && [ ! -z "$term_sd_proxy_config" ];then
                    term_sd_proxy_config=$(echo $term_sd_proxy_config | awk '{gsub(/[：]/, ":") ; gsub(/[。]/, ".")}1') # 防止用户输入中文冒号,句号后导致错误
                    http_proxy="socks://$term_sd_proxy_config"
                    https_proxy="socks://$term_sd_proxy_config"
                    term_sd_proxy=$https_proxy
                    echo "socks://$term_sd_proxy_config" > term-sd/config/proxy.conf

                    dialog --erase-on-exit \
                        --title "Term-SD" \
                        --backtitle "代理参数设置界面" \
                        --ok-label "确认" \
                        --msgbox "代理地址: \"$http_proxy\"\n代理协议: \"$(echo $http_proxy | awk -F '://' '{print$NR}')\"\n设置代理完成" \
                        $term_sd_dialog_height $term_sd_dialog_width
                fi
                ;;
            3)
                term_sd_proxy_config=$(dialog --erase-on-exit \
                    --title "Term-SD" \
                    --backtitle "代理参数设置界面" \
                    --ok-label "确认" --cancel-label "取消" \
                    --inputbox "请输入代理地址\n格式: <ip>:<port>" \
                    $term_sd_dialog_height $term_sd_dialog_width "$(echo $http_proxy | awk -F'://' '{print $NF}')" \
                    3>&1 1>&2 2>&3)

                if [ $? = 0 ] && [ ! -z "$term_sd_proxy_config" ];then
                    term_sd_proxy_config=$(echo $term_sd_proxy_config | awk '{gsub(/[：]/, ":") ; gsub(/[。]/, ".")}1') # 防止用户输入中文冒号,句号后导致错误
                    http_proxy="socks5://$term_sd_proxy_config"
                    https_proxy="socks5://$term_sd_proxy_config"
                    term_sd_proxy=$https_proxy
                    echo "socks5://$term_sd_proxy_config" > term-sd/config/proxy.conf

                    dialog --erase-on-exit \
                        --title "Term-SD" \
                        --backtitle "代理参数设置界面" \
                        --ok-label "确认" \
                        --msgbox "代理地址: \"$http_proxy\"\n代理协议: \"$(echo $http_proxy | awk -F '://' '{print$NR}')\"\n设置代理完成" \
                        $term_sd_dialog_height $term_sd_dialog_width
                fi
                ;;
            4)
                term_sd_proxy_config=$(dialog --erase-on-exit \
                    --title "Term-SD" \
                    --backtitle "代理参数设置界面" \
                    --ok-label "确认" --cancel-label "取消" \
                    --inputbox "请输入代理地址\n格式: <protocol>://<ip>:<port>" \
                    $term_sd_dialog_height $term_sd_dialog_width "$(echo $http_proxy)" \
                    3>&1 1>&2 2>&3)

                if [ $? = 0 ] && [ ! -z "$term_sd_proxy_config" ];then
                    term_sd_proxy_config=$(echo $term_sd_proxy_config | awk '{gsub(/[：]/, ":") ; gsub(/[。]/, ".")}1') # 防止用户输入中文冒号,句号后导致错误
                    http_proxy="$term_sd_proxy_config"
                    https_proxy="$term_sd_proxy_config"
                    term_sd_proxy=$https_proxy
                    echo "$term_sd_proxy_config" > term-sd/config/proxy.conf

                    dialog --erase-on-exit \
                        --title "Term-SD" \
                        --backtitle "代理参数设置界面" \
                        --ok-label "确认" \
                        --msgbox "代理地址: \"$http_proxy\"\n代理协议: \"$(echo $http_proxy | awk -F '://' '{print$NR}')\"\n设置代理完成" \
                        $term_sd_dialog_height $term_sd_dialog_width
                fi
                ;;
            5)
                if (dialog --erase-on-exit \
                    --title "Term-SD" \
                    --backtitle "代理参数删除界面" \
                    --yes-label "是" --no-label "否" \
                    --yesno "是否删除代理配置?" \
                    $term_sd_dialog_height $term_sd_dialog_width) then

                    http_proxy=
                    https_proxy=
                    term_sd_proxy=
                    rm -f term-sd/config/proxy.conf

                    dialog --erase-on-exit \
                        --title "Term-SD" \
                        --backtitle "代理参数设置界面" \
                        --ok-label "确认" \
                        --msgbox "清除设置代理完成" \
                        $term_sd_dialog_height $term_sd_dialog_width
                fi
                ;;
            *)
                break
                ;;
        esac
    done
}

# 安装模式设置
term_sd_install_mode_setting()
{
    local term_sd_install_mode_setting_dialog
    export term_sd_install_mode

    while true
    do
        term_sd_install_mode_setting_dialog=$(dialog --erase-on-exit --notags \
            --title "Term-SD" \
            --backtitle "安装模式设置界面" \
            --ok-label "确认" --cancel-label "取消" \
            --menu "该功能用于设置 Term-SD 安装 AI 软件的工作模式。当启用 \"严格模式\" 后, Term-SD 在安转 AI 软件时出现执行失败的命令时将停止安装进程 (Term-SD支持断点恢复, 可恢复上次安装进程中断的位置), 而 \"宽容模式\" 在安转AI软件时出现执行失败的命令时忽略执行失败的命令继续执行完成安装任务\n当前安装模式: $([ ! -f "term-sd/config/term-sd-disable-strict-install-mode.lock" ] && echo "严格模式" || echo "宽容模式")\n请选择要设置的安装模式 (默认启用严格模式)" \
            $term_sd_dialog_height $term_sd_dialog_width $term_sd_dialog_menu_height \
            "0" "> 返回" \
            "1" "> 严格模式" \
            "2" "> 宽容模式" \
            3>&1 1>&2 2>&3)

        case $term_sd_install_mode_setting_dialog in
            1)
                term_sd_install_mode=0
                rm -f term-sd/config/term-sd-disable-strict-install-mode.lock

                dialog --erase-on-exit \
                    --title "Term-SD" \
                    --backtitle "安装模式设置界面" \
                    --ok-label "确认" \
                    --msgbox "启用严格模式成功" \
                    $term_sd_dialog_height $term_sd_dialog_width
                ;;
            2)
                term_sd_install_mode=1
                touch term-sd/config/term-sd-disable-strict-install-mode.lock

                dialog --erase-on-exit \
                    --title "Term-SD" \
                    --backtitle "安装模式设置界面" \
                    --ok-label "确认" \
                    --msgbox "启用宽容模式成功" \
                    $term_sd_dialog_height $term_sd_dialog_width
                ;;
            *)
                break
                ;;
        esac
    done
}

# aria2线程设置
aria2_multi_threaded_setting()
{
    local aria2_multi_threaded_setting_dialog
    local aria2_multi_threaded_value
    export aria2_multi_threaded

    while true
    do
        aria2_multi_threaded_setting_dialog=$(dialog --erase-on-exit --notags \
            --title "Term-SD" \
            --backtitle "Aria2线程设置界面" \
            --ok-label "确认" --cancel-label "取消" \
            --menu "该功能用于增加 Term-SD 在使用 Aria2 下载模型时的线程数, 在一定程度上提高下载速度\n当前状态: $([ -f "term-sd/config/aria2-thread.conf" ] && echo "启用 (线程数: $(cat term-sd/config/aria2-thread.conf | awk '{sub("-x ","")}1'))" || echo "禁用")\n是否启用 Aria2 多线程下载?" \
            $term_sd_dialog_height $term_sd_dialog_width $term_sd_dialog_menu_height \
            "0" "> 返回" \
            "1" "> 启用" \
            "2" "> 禁用" \
            3>&1 1>&2 2>&3)

        case $aria2_multi_threaded_setting_dialog in
            1)
                aria2_multi_threaded_value=$(dialog --erase-on-exit \
                    --title "Term-SD" \
                    --backtitle "Aria2 线程设置界面" \
                    --ok-label "确认" --cancel-label "取消" \
                    --inputbox "请输入线程数 (仅输入数字, 不允许输入负数和其他非数字的字符)" \
                    $term_sd_dialog_height $term_sd_dialog_width \
                    "$(cat term-sd/config/aria2-thread.conf | awk '{sub("-x ","")}1')" \
                    3>&1 1>&2 2>&3)

                if [ ! -z "$(echo $aria2_multi_threaded_value | awk '{gsub(/[0-9]/, "")}1')" ] || [ $aria2_multi_threaded_value = 0 ] ;then
                    dialog --erase-on-exit \
                        --title "Term-SD" \
                        --backtitle "Aria2 线程设置界面" \
                        --ok-label "确认" \
                        --msgbox "输入格式错误, 线程数只能为数字且不能为负数" \
                        $term_sd_dialog_height $term_sd_dialog_width

                else
                    if [ ! -z "$aria2_multi_threaded_value" ];then
                        if [ $aria2_multi_threaded_value -le 16 ];then
                            echo "-x $aria2_multi_threaded_value" > term-sd/config/aria2-thread.conf
                            aria2_multi_threaded="-x $aria2_multi_threaded_value"

                            dialog --erase-on-exit \
                                --title "Term-SD" \
                                --backtitle "Aria2 线程设置界面" \
                                --ok-label "确认" \
                                --msgbox "启用成功, Aria2线程数: $aria2_multi_threaded" \
                                $term_sd_dialog_height $term_sd_dialog_width
                        else
                            echo "-x 16" > term-sd/config/aria2-thread.conf
                            aria2_multi_threaded="-x 16"

                            dialog --erase-on-exit \
                                --title "Term-SD" \
                                --backtitle "Aria2 线程设置界面" \
                                --ok-label "确认" \
                                --msgbox "启用成功, Aria2线程数: $aria2_multi_threaded" \
                                $term_sd_dialog_height $term_sd_dialog_width
                        fi
                    else

                        dialog --erase-on-exit \
                            --title "Term-SD" \
                            --backtitle "Aria2 线程设置界面" \
                            --ok-label "确认" \
                            --msgbox "未输入, 请重试" \
                            $term_sd_dialog_height $term_sd_dialog_width
                    fi
                fi
                ;;
            2)
                rm -rf term-sd/config/aria2-thread.conf
                aria2_multi_threaded=

                dialog --erase-on-exit \
                    --title "Term-SD" \
                    --backtitle "Aria2 线程设置界面" \
                    --ok-label "确认" \
                    --msgbox "禁用成功" \
                    $term_sd_dialog_height $term_sd_dialog_width
                ;;
            *)
                break
                ;;
        esac
    done
}

# 缓存重定向设置
term_sd_cache_redirect_setting()
{
    local term_sd_cache_redirect_setting_dialog
    export CACHE_HOME
    export HF_HOME
    export MATPLOTLIBRC
    export MODELSCOPE_CACHE
    export MS_CACHE_HOME
    export SYCL_CACHE_DIR
    export TORCH_HOME
    export U2NET_HOME
    export XDG_CACHE_HOME
    export PIP_CACHE_DIR
    export PYTHONPYCACHEPREFIX

    while true
    do
        term_sd_cache_redirect_setting_dialog=$(dialog --erase-on-exit --notags \
            --title "Term-SD" \
            --backtitle "缓存重定向设置界面" \
            --ok-label "确认" \
            --cancel-label "取消" \
            --menu "该功能将会把 AI 软件产生的缓存重定向至 Term-SD 中 (便于清理)\n当前状态: $([ ! -f "term-sd/config/disable-cache-path-redirect.lock" ] && echo "启用" || echo "禁用")\n是否启用缓存重定向?" \
            $term_sd_dialog_height $term_sd_dialog_width $term_sd_dialog_menu_height \
            "0" "> 返回" \
            "1" "> 启用" \
            "2" "> 禁用" \
            3>&1 1>&2 2>&3)

        case $term_sd_cache_redirect_setting_dialog in
            1)
                rm -f term-sd/config/disable-cache-path-redirect.lock
                CACHE_HOME="$start_path/term-sd/cache"
                HF_HOME="$start_path/term-sd/cache/huggingface"
                MATPLOTLIBRC="$start_path/term-sd/cache"
                MODELSCOPE_CACHE="$start_path/term-sd/cache/modelscope/hub"
                MS_CACHE_HOME="$start_path/term-sd/cache/modelscope/hub"
                SYCL_CACHE_DIR="$start_path/term-sd/cache/libsycl_cache"
                TORCH_HOME="$start_path/term-sd/cache/torch"
                U2NET_HOME="$start_path/term-sd/cache/u2net"
                XDG_CACHE_HOME="$start_path/term-sd/cache"
                PIP_CACHE_DIR="$start_path/term-sd/cache/pip"
                PYTHONPYCACHEPREFIX="$start_path/term-sd/cache/pycache"

                dialog --erase-on-exit \
                    --title "Term-SD" \
                    --backtitle "缓存重定向设置界面" \
                    --ok-label "确认" \
                    --msgbox "启用成功" \
                    $term_sd_dialog_height $term_sd_dialog_width
                ;;
            2)
                touch -f term-sd/config/disable-cache-path-redirect.lock
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

                dialog --erase-on-exit \
                    --title "Term-SD" \
                    --backtitle "缓存重定向设置界面" \
                    --ok-label "确认" \
                    --msgbox "禁用成功" \
                    $term_sd_dialog_height $term_sd_dialog_width
                ;;
            *)
                break
                ;;
        esac
    done
}

# cuda内存分配设置
# 参考:
# https://blog.csdn.net/MirageTanker/article/details/127998036
# https://github.com/AUTOMATIC1111/stable-diffusion-webui/wiki/Optimizations
cuda_memory_alloc_setting()
{
    local cuda_memory_alloc_setting_dialog
    export PYTORCH_CUDA_ALLOC_CONF

    while true
    do
        cuda_memory_alloc_setting_dialog=$(dialog --erase-on-exit --notags \
            --title "Term-SD" \
            --backtitle "CUDA 内存分配设置界面" \
            --ok-label "确认" --cancel-label "取消" \
            --menu "该功能用于更换底层 CUDA 内存分配器 (仅支持 Nvidia 显卡, 且 CUDA 版本需要大于 11.4)\n当前内存分配器: $([ -f "term-sd/config/cuda-memory-alloc.conf" ] && echo $([ ! -z $(cat term-sd/config/cuda-memory-alloc.conf | grep cudaMallocAsync) ] && echo "CUDA 内置异步分配器" || echo "PyTorch 原生分配器") || echo "未设置")\n请选择 CUDA 内存分配器" \
            $term_sd_dialog_height $term_sd_dialog_width $term_sd_dialog_menu_height \
            "0" "> 返回" \
            "1" "> PyTorch 原生分配器" \
            "2" "> CUDA (11.4+) 内置异步分配器" \
            "3" "> 清除设置" \
            3>&1 1>&2 2>&3)

        case $cuda_memory_alloc_setting_dialog in
            1)
                PYTORCH_CUDA_ALLOC_CONF=garbage_collection_threshold:0.9,max_split_size_mb:512
                echo "garbage_collection_threshold:0.9,max_split_size_mb:512" > term-sd/config/cuda-memory-alloc.conf

                dialog --erase-on-exit \
                    --title "Term-SD" \
                    --backtitle "CUDA 内存分配设置界面" \
                    --ok-label "确认" \
                    --msgbox "设置 CUDA 内存分配器为 PyTorch 原生分配器成功" \
                    $term_sd_dialog_height $term_sd_dialog_width
                ;;
            2)
                PYTORCH_CUDA_ALLOC_CONF=backend:cudaMallocAsync
                echo "backend:cudaMallocAsync" > term-sd/config/cuda-memory-alloc.conf

                dialog --erase-on-exit \
                    --title "Term-SD" \
                    --backtitle "CUDA 内存分配设置界面" \
                    --ok-label "确认" \
                    --msgbox "设置 CUDA 内存分配器为 CUDA 内置异步分配器成功" \
                    $term_sd_dialog_height $term_sd_dialog_width
                ;;
            3)
                PYTORCH_CUDA_ALLOC_CONF=
                rm -f term-sd/config/cuda-memory-alloc.conf

                dialog --erase-on-exit \
                    --title "Term-SD" \
                    --backtitle "CUDA内存分配设置界面" \
                    --ok-label "确认" \
                    --msgbox "清除CUDA内存分配器设置成功" \
                    $term_sd_dialog_height $term_sd_dialog_width
                ;;
            *)
                break
                ;;
        esac
    done
}

# 储存占用分析
term_sd_disk_space_stat()
{
    term_sd_echo "统计空间占用中"
    term_sd_echo "统计当前目录剩余空间"
    local disk_free_space_stat=$(df  -h | awk 'NR==2{print$4}')
    term_sd_echo "统计 Term-SD 缓存目录空间占用"
    local term_sd_space_stat=$([ -d "term-sd/cache" ] && du -sh term-sd/cache | awk '{print $1}' || echo "无")
    term_sd_echo "统计 Stable-Diffusion-WebUI 占用"
    local sd_webui_space_stat=$([ -d "$sd_webui_path" ] && du -sh "$sd_webui_path" | awk '{print $1}' || echo "未安装")
    term_sd_echo "统计 ComfyUI 占用"
    local comfyui_space_stat=$([ -d "$comfyui_path" ] && du -sh "$comfyui_path" | awk '{print $1}' || echo "未安装")
    term_sd_echo "统计 InvokeAI 占用"
    local invokeai_space_stat=$([ -d "$invokeai_path" ] && du -sh "$invokeai_path" | awk '{print $1}' || echo "未安装")
    term_sd_echo "统计 Fooocus 占用"
    local fooocus_space_stat=$([ -d "$fooocus_path" ] && du -sh "$fooocus_path" | awk '{print $1}' || echo "未安装")
    term_sd_echo "统计 lora-scripts 占用"
    local lora_scripts_space_stat=$([ -d "$lora_scripts_path" ] && du -sh "$lora_scripts_path" | awk '{print $1}' || echo "未安装")
    term_sd_echo "统计 kohya_ss 占用"
    local kohya_ss_space_stat=$([ -d "$kohya_ss_path" ] && du -sh "$kohya_ss_path" | awk '{print $1}' || echo "未安装")

    dialog --erase-on-exit \
        --title "Term-SD" \
        --backtitle "Term-SD 空间占用分析" \
        --ok-label "确认" \
        --msgbox "项目空间占用分析:\n
当前目录剩余空间: $disk_free_space_stat\n
Term-SD (重定向) 缓存目录: $term_sd_space_stat\n
Stable-Diffusion-WebUI: $sd_webui_space_stat\n
ComfyUI: $comfyui_space_stat\n
InvokeAI: $invokeai_space_stat\n
Fooocus: $fooocus_space_stat\n
lora-scripts: $lora_scripts_space_stat\n
kohya_ss: $kohya_ss_space_stat\n
" $term_sd_dialog_height $term_sd_dialog_width
}

# 网络连接测试
term_sd_network_test()
{
    local http_return_code
    local req
    local i
    local network_test_url
    local count
    local sum
    count=1
    network_test_url="google.com huggingface.co modelscope.cn github.com mirror.ghproxy.com gitclone.com gh-proxy.com ghps.cc gh.idayer.com ghproxy.net hf-mirror.com huggingface.sukaka.top"
    sum=$(echo $network_test_url | wc -w)
    term_sd_echo "获取网络信息"
    [ -f "term-sd/task/ipinfo.sh" ] && rm -f term-sd/task/ipinfo.sh
    curl -s ipinfo.io >> term-sd/task/ipinfo.sh
    term_sd_echo "测试网络中"
    for i in $network_test_url; do
        term_sd_echo "[$count/$sum] 测试链接访问: $i"
        count=$(( $count + 1 ))
        http_return_code=$(curl --connect-timeout 10 -s -o /dev/null -w "%{http_code}" https://${i})
        case $http_return_code in
            200|301)
                req="$req $i: 成功 ✓\n"
                ;;
            *)
                req="$req $i: 失败 ×\n"
            ;;
        esac
    done

    dialog --erase-on-exit \
        --title "Term-SD" \
        --backtitle "Term-SD 网络测试" \
        --ok-label "确认" \
        --msgbox "网络测试结果:\n
${term_sd_delimiter}\n
网络信息:\n
$(cat term-sd/task/ipinfo.sh | grep \"ip\"\: | awk '{gsub(/[\\"]/,"") ; sub("ip:","IP: ")}1')\n
$(cat term-sd/task/ipinfo.sh | grep \"country\"\: | awk '{gsub(/[\\"]/,"") ; sub("country:","地址: ")}1')\
$(cat term-sd/task/ipinfo.sh | grep \"region\"\: | awk '{gsub(/[\\"]/,"") ; sub("region:","")}1')\
$(cat term-sd/task/ipinfo.sh | grep \"city\"\: | awk '{gsub(/[\\"]/,"") ; sub("city:","")}1')\n
$(cat term-sd/task/ipinfo.sh | grep \"org\"\: | awk '{gsub(/[\\"]/,"") ; sub("org:","网络提供商: ")}1')\n
${term_sd_delimiter}\n
网站访问:\n
$req\
${term_sd_delimiter}\n
" $term_sd_dialog_height $term_sd_dialog_width

    rm -f term-sd/task/ipinfo.sh
}

# 卸载选项
term_sd_uninstall_interface()
{
    if (dialog --erase-on-exit \
        --title "Term-SD" \
        --backtitle "Term-SD 卸载界面" \
        --yes-label "是" --no-label "否" \
        --yesno "警告: 该操作将永久删除 Term-SD 目录中的所有文件, 包括 AI 软件下载的部分模型文件 (存在于 Term-SD 目录中的 cache 文件夹, 如有必要, 请备份该文件夹)\n是否卸载 Term-SD ?" \
        $term_sd_dialog_height $term_sd_dialog_width) then

        term_sd_echo "请再次确认是否删除 Term-SD (yes/no)?"
        term_sd_echo "警告: 该操作将永久删除 Term-SD"
        term_sd_echo "提示: 输入 yes 或 no 后回车"
        case $(term_sd_read) in
            y|yes|YES|Y)
                term_sd_echo "开始卸载 Term-SD"
                rm -rf term-sd
                rm -f term-sd.sh
                user_shell=$(echo $SHELL | awk -F "/" '{print $NF}') # 读取用户所使用的shell
                if [ $user_shell = bash ] || [ $user_shell = zsh ];then
                    sed -i '/# Term-SD/d' ~/."$user_shell"rc
                    sed -i '/term_sd(){/d' ~/."$user_shell"rc
                    sed -i '/alias tsd/d' ~/."$user_shell"rc
                fi
                term_sd_echo "Term-SD 卸载完成"
                exec $SHELL
                exit 0
                ;;
            *)
                term_sd_echo "取消卸载操作"
                ;;
        esac
    else
        term_sd_echo "取消卸载操作"
    fi
}
