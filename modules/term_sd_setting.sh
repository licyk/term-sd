#!/bin/bash

# 设置
term_sd_setting()
{
    local term_sd_setting_dialog

    while true
    do
        term_sd_setting_dialog=$(dialog --erase-on-exit --notags \
            --title "Term-SD" \
            --backtitle "Term-SD 设置选项" \
            --ok-label "确认" \
            --cancel-label "取消" \
            --menu "请选择 Term-SD 设置" \
            $term_sd_dialog_height $term_sd_dialog_width $term_sd_dialog_menu_height \
            "0" "> 返回" \
            "1" "> 虚拟环境设置 ($([ $venv_setup_status = 0 ] && echo "启用" || echo "禁用"))" \
            "2" "> Pip 镜像源设置 (配置文件)" \
            "3" "> Pip 镜像源设置 (环境变量)($([ ! -z $(echo $PIP_INDEX_URL | grep "pypi.python.org") ] && echo "官方源" || echo "国内镜像源"))" \
            "4" "> Pip 缓存清理" \
            "5" "> 代理设置 ($([ -z $http_proxy ] && echo "无" || echo "代理地址:$(echo $http_proxy | awk '{print substr($1,1,40)}')"))" \
            "6" "> 命令执行监测设置 ($([ -f "term-sd/config/term-sd-watch-retry.conf" ] && echo "启用(重试次数:$(cat term-sd/config/term-sd-watch-retry.conf))" || echo "禁用"))" \
            "7" "> Term-SD 安装模式 ($([ ! -f "term-sd/config/term-sd-disable-strict-install-mode.lock" ] && echo "严格模式" || echo "宽容模式"))" \
            "8" "> Aria2 线程设置 ($([ -f "term-sd/config/aria2-thread.conf" ] && echo "启用(线程数:$(cat term-sd/config/aria2-thread.conf | awk '{sub("-x ","")}1'))" || echo "禁用"))" \
            "9" "> 缓存重定向设置 ($([ ! -f "term-sd/config/disable-cache-path-redirect.lock" ] && echo "启用" || echo "禁用"))" \
            "10" "> CUDA 内存分配设置 ($([ -f "term-sd/config/cuda-memory-alloc.conf" ] && echo $([ ! -z $(cat term-sd/config/cuda-memory-alloc.conf | grep cudaMallocAsync) ] && echo "CUDA内置异步分配器" || echo "PyTorch原生分配器") || echo "未设置"))" \
            "11" "> 自定义安装路径" \
            "12" "> 空间占用分析" \
            "13" "> 网络连接测试" \
            "14" "> 卸载 Term-SD" \
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
                term_sd_try_setting
                ;;
            7)
                term_sd_install_mode_setting
                ;;
            8)
                aria2_multi_threaded_setting
                ;;
            9)
                term_sd_cache_redirect_setting
                ;;
            10)
                cuda_memory_alloc_setting
                ;;
            11)
                custom_install_path_setting
                ;;
            12)
                term_sd_disk_space_stat
                ;;
            13)
                term_sd_network_test
                ;;
            14)
                term_sd_uninstall_interface
                ;;
            *)
                break
                ;;
        esac
    done
}

# 虚拟环境设置
python_venv_setting()
{
    local python_venv_setting_dialog
    export venv_setup_status

    while true
    do
        python_venv_setting_dialog=$(dialog --erase-on-exit --notags \
            --title "Term-SD" \
            --backtitle "虚拟环境设置界面" \
            --ok-label "确认" --cancel-label "取消" \
            --menu "该功能用于给 AI 软件启用虚拟环境, 隔离不同 AI 软件的 Python 库, 防止 Python 库中软件包版本和 AI 软件的版本要求不对应\n当前虚拟环境状态: $([ $venv_setup_status = 0 ] && echo "启用" || echo "禁用")\n是否启用虚拟环境? (推荐启用)" \
            $term_sd_dialog_height $term_sd_dialog_width $term_sd_dialog_menu_height \
            "0" "> 返回" \
            "1" "> 启用" \
            "2" "> 禁用" \
            3>&1 1>&2 2>&3)

        case $python_venv_setting_dialog in
            1)
                venv_setup_status=0
                rm -rf term-sd/config/term-sd-venv-disable.lock

                dialog --erase-on-exit \
                    --title "Term-SD" \
                    --backtitle "虚拟环境设置界面" \
                    --ok-label "确认" \
                    --msgbox "启用成功" \
                    $term_sd_dialog_height $term_sd_dialog_width
                ;;
            2)
                venv_setup_status=1
                touch term-sd/config/term-sd-venv-disable.lock

                dialog --erase-on-exit \
                    --title "Term-SD" \
                    --backtitle "虚拟环境设置界面" \
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

# pip镜像源选项(配置文件)
pip_mirrors_setting()
{
    local pip_mirrors_setting_dialog

    while true
    do
        term_sd_echo "获取 Pip 全局配置"
        pip_mirrors_setting_dialog=$(dialog --erase-on-exit --notags \
            --title "Term-SD" \
            --backtitle "Pip 镜像源 (配置文件) 选项" \
            --ok-label "确认" --cancel-label "取消" \
            --menu "该功能用于设置 Pip 镜像源 (环境变量) (优先级小于环境变量配置), 加速国内下载 Python 软件包的速度\n当前 Pip 全局配置:\n$(term_sd_pip config list | awk '{print$0}')\n请选择设置的 Pip 镜像源 (配置文件)" \
            $term_sd_dialog_height $term_sd_dialog_width $term_sd_dialog_menu_height \
            "0" "> 返回" \
            "1" "> 设置官方源" \
            "2" "> 设置国内镜像源" \
            "3" "> 删除镜像源配置" \
            3>&1 1>&2 2>&3)

        case $pip_mirrors_setting_dialog in
            1)
                term_sd_echo "设置 Pip 镜像源为官方源"
                term_sd_pip config set global.index-url "https://pypi.python.org/simple"
                term_sd_pip config unset global.extra-index-url
                term_sd_pip config set global.find-links "https://download.pytorch.org/whl/torch_stable.html"

                dialog --erase-on-exit \
                    --title "Term-SD" \
                    --backtitle "Pip 镜像源 (配置文件) 选项" \
                    --ok-label "确认" \
                    --msgbox "设置 Pip 镜像源为官方源成功" \
                    $term_sd_dialog_height $term_sd_dialog_width
                ;;
            2)
                term_sd_echo "设置 Pip 镜像源为国内镜像源"
                term_sd_pip config set global.index-url "https://mirrors.cloud.tencent.com/pypi/simple"
                term_sd_pip config set global.extra-index-url "https://mirror.baidu.com/pypi/simple https://mirrors.bfsu.edu.cn/pypi/web/simple https://mirror.nju.edu.cn/pypi/web/simple"
                term_sd_pip config set global.find-links "https://mirrors.aliyun.com/pytorch-wheels/torch_stable.html https://mirror.sjtu.edu.cn/pytorch-wheels/torch_stable.html"

                dialog --erase-on-exit \
                    --title "Term-SD" \
                    --backtitle "Pip 镜像源 (配置文件) 选项" \
                    --ok-label "确认" \
                    --msgbox "设置 Pip 镜像源为国内镜像源成功" \
                    $term_sd_dialog_height $term_sd_dialog_width
                ;;
            3)
                term_sd_echo "删除镜像源配置"
                term_sd_pip config unset global.extra-index-url
                term_sd_pip config unset global.index-url
                term_sd_pip config unset global.find-links

                dialog --erase-on-exit \
                    --title "Term-SD" \
                    --backtitle "Pip 镜像源 (配置文件) 选项" \
                    --ok-label "确认" \
                    --msgbox "删除镜像源配置成功" \
                    $term_sd_dialog_height $term_sd_dialog_width
                ;;
            *)
                break
                ;;
        esac
    done
}

# pip镜像源设置(环境变量)
pip_mirrors_env_setting()
{
    local pip_mirrors_env_setting_dialog
    export PIP_INDEX_URL
    export PIP_EXTRA_INDEX_URL
    export PIP_FIND_LINKS

    while true
    do
        pip_mirrors_env_setting_dialog=$(dialog --erase-on-exit --notags \
            --title "Term-SD" \
            --backtitle "Pip 镜像源 (环境变量) 选项" \
            --ok-label "确认" --cancel-label "取消" \
            --menu "该功能用于设置 Pip 镜像源 (环境变量) (优先级大于全局配置), 加速国内下载 Python 软件包的速度\n当前 Pip 环境变量配置: $([ ! -z $(echo $PIP_INDEX_URL | grep "pypi.python.org") ] && echo "官方源" || echo "国内镜像源")\n请选择设置的 Pip 镜像源 (环境变量)" \
            $term_sd_dialog_height $term_sd_dialog_width $term_sd_dialog_menu_height \
            "0" "> 返回" \
            "1" "> 设置官方源" \
            "2" "> 设置国内镜像源 (默认)" \
            3>&1 1>&2 2>&3)

        case $pip_mirrors_env_setting_dialog in
            1)
                PIP_INDEX_URL="https://pypi.python.org/simple"
                PIP_EXTRA_INDEX_URL=""
                PIP_FIND_LINKS="https://download.pytorch.org/whl/torch_stable.html"
                touch term-sd/config/disable-pip-mirror.lock

                dialog --erase-on-exit \
                    --title "Term-SD" \
                    --backtitle "Pip 镜像源 (环境变量) 选项" \
                    --ok-label "确认" \
                    --msgbox "设置 Pip 镜像源为官方源成功" \
                    $term_sd_dialog_height $term_sd_dialog_width
                ;;
            2)
                PIP_INDEX_URL="https://mirrors.cloud.tencent.com/pypi/simple"
                PIP_EXTRA_INDEX_URL="https://mirror.baidu.com/pypi/simple https://mirrors.bfsu.edu.cn/pypi/web/simple https://mirror.nju.edu.cn/pypi/web/simple"
                PIP_FIND_LINKS="https://mirrors.aliyun.com/pytorch-wheels/torch_stable.html https://mirror.sjtu.edu.cn/pytorch-wheels/torch_stable.html"
                rm -f term-sd/config/disable-pip-mirror.lock

                dialog --erase-on-exit \
                    --title "Term-SD" \
                    --backtitle "Pip 镜像源 (环境变量) 选项" \
                    --ok-label "确认" \
                    --msgbox "设置 Pip 镜像源为国内镜像源成功" \
                    $term_sd_dialog_height $term_sd_dialog_width
                ;;
            *)
                break
                ;;
        esac
    done
}

# pip缓存清理功能
pip_cache_clean()
{
    term_sd_echo "统计pip缓存信息"
    if (dialog --erase-on-exit \
        --title "Term-SD" \
        --backtitle "Pip缓存清理选项" \
        --yes-label "是" --no-label "否" \
        --yesno "Pip 缓存信息:\nPip缓存路径: $(term_sd_pip cache dir)\n包索引页面缓存大小: $(term_sd_pip cache info | grep "Package index page cache size" | awk -F ':'  '{print $2 $3 $4}')\n本地构建的 WHELL 包大小: $(term_sd_pip cache info | grep "Locally built wheels size" | awk -F ':'  '{print $2 $3 $4}')\n是否删除 Pip 缓存?" \
        $term_sd_dialog_height $term_sd_dialog_width) then
        term_sd_pip cache purge

        dialog --erase-on-exit \
            --title "Term-SD" \
            --backtitle "Pip 缓存清理选项" \
            --ok-label "确认" \
            --msgbox "清理 Pip 缓存完成" \
            $term_sd_dialog_height $term_sd_dialog_width
    fi
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

# 命令执行监测设置
term_sd_try_setting()
{
    local term_sd_try_setting_dialog
    local term_sd_try_value
    export term_sd_cmd_retry

    while true
    do
        term_sd_try_setting_dialog=$(
            dialog --erase-on-exit --notags \
            --title "Term-SD" \
            --backtitle "命令执行监测设置界面" \
            --ok-label "确认" --cancel-label "取消" \
            --menu "该功能用于监测命令的运行情况, 若设置了重试次数, Term-SD 将重试执行失败的命令 (有些命令需要联网, 在网络不稳定的时候容易导致命令执行失败), 保证命令执行成功\n当前状态: $([ -f "term-sd/config/term-sd-watch-retry.conf" ] && echo "启用 (重试次数: $(cat term-sd/config/term-sd-watch-retry.conf))" || echo "禁用")\n是否启用命令执行监测? (推荐启用)" \
            $term_sd_dialog_height $term_sd_dialog_width $term_sd_dialog_menu_height \
            "0" "> 返回" \
            "1" "> 启用" \
            "2" "> 禁用" \
            3>&1 1>&2 2>&3)

        case $term_sd_try_setting_dialog in
            1)
                term_sd_try_value=$(dialog --erase-on-exit \
                    --title "Term-SD" \
                    --backtitle "命令执行监测设置界面" \
                    --ok-label "确认" --cancel-label "取消" \
                    --inputbox "请输入重试次数 (仅输入数字, 不允许输入负数和其他非数字的字符)" \
                    $term_sd_dialog_height $term_sd_dialog_width \
                    "$(cat term-sd/config/term-sd-watch-retry.conf)" \
                    3>&1 1>&2 2>&3)

                if [ ! -z "$(echo $term_sd_try_value | awk '{gsub(/[0-9]/, "")}1')" ];then
                    dialog --erase-on-exit \
                        --title "Term-SD" \
                        --backtitle "命令执行监测设置界面" \
                        --ok-label "确认" \
                        --msgbox "输入格式错误,重试次数只能为数字且不能为负数" \
                        $term_sd_dialog_height $term_sd_dialog_width
                else
                    if [ ! -z "$term_sd_try_value" ];then
                        echo "$term_sd_try_value" > term-sd/config/term-sd-watch-retry.conf
                        term_sd_cmd_retry=$term_sd_try_value
                        dialog --erase-on-exit \
                            --title "Term-SD" \
                            --backtitle "命令执行监测设置界面" \
                            --ok-label "确认" \
                            --msgbox "启用成功, 重试次数: $term_sd_cmd_retry" \
                            $term_sd_dialog_height $term_sd_dialog_width
                    else
                        dialog --erase-on-exit \
                            --title "Term-SD" \
                            --backtitle "命令执行监测设置界面" \
                            --ok-label "确认" \
                            --msgbox "未输入,请重试" \
                            $term_sd_dialog_height $term_sd_dialog_width
                    fi
                fi
                ;;
            2)
                rm -rf term-sd/config/term-sd-watch-retry.conf
                term_sd_cmd_retry=0

                dialog --erase-on-exit \
                    --title "Term-SD" \
                    --backtitle "命令执行监测设置界面" \
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
                CACHE_HOME=
                HF_HOME=
                MATPLOTLIBRC=
                MODELSCOPE_CACHE=
                MS_CACHE_HOME=
                SYCL_CACHE_DIR=
                TORCH_HOME=
                U2NET_HOME=
                XDG_CACHE_HOME=
                PIP_CACHE_DIR=
                PYTHONPYCACHEPREFIX=

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
# 参考:https://blog.csdn.net/MirageTanker/article/details/127998036
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

# 自定义ai软件安装路径设置
custom_install_path_setting()
{
    local custom_install_path_setting_dialog
    local custom_install_path
    while true
    do
        custom_install_path_setting_dialog=$(dialog --erase-on-exit --notags \
            --title "Term-SD" \
            --backtitle "自定义安装路径设置界面" \
            --ok-label "确认" --cancel-label "取消" \
            --menu "该功能用于自定义 AI 软件的安装路径, 当保持默认时, AI 软件的安装路径与 Term-SD 所在路径同级\n当前 Term-SD 所在路径: ${start_path}/term-sd\n注:\n1、路径最好使用绝对路径\n2、如果是 Windows 系统, 请使用 MSYS2 可识别的路径格式\n如: \"D:\\Downloads\\webui\" 要写成 \"/d/Downloads/webui\"" \
            $term_sd_dialog_height $term_sd_dialog_width $term_sd_dialog_menu_height \
            "0" "> 返回" \
            "1" "> Stable-Diffusion-WebUI 安装路径设置 (当前配置: $([ -f term-sd/config/sd-webui-path.conf ] && echo "自定义" || echo 默认))" \
            "2" "> ComfyUI 安装路径设置 (当前配置: $([ -f term-sd/config/comfyui-path.conf ] && echo "自定义" || echo 默认))" \
            "3" "> InvokeAI 安装路径设置 (当前配置: $([ -f term-sd/config/invokeai-path.conf ] && echo "自定义" || echo 默认))" \
            "4" "> Fooocus 安装路径设置 (当前配置: $([ -f term-sd/config/fooocus-path.conf ] && echo "自定义" || echo 默认))" \
            "5" "> lora-scripts 安装路径设置 (当前配置: $([ -f term-sd/config/lora-scripts-path.conf ] && echo "自定义" || echo 默认))" \
            "6" "> kohya_ss 安装路径设置 (当前配置: $([ -f term-sd/config/kohya_ss-path.conf ] && echo "自定义" || echo 默认))" \
            3>&1 1>&2 2>&3)

        case $custom_install_path_setting_dialog in
            1)
                sd_webui_custom_install_path_setting
                ;;
            2)
                comfyui_custom_install_path_setting
                ;;
            3)
                invokeai_custom_install_path_setting
                ;;
            4)
                fooocus_custom_install_path_setting
                ;;
            5)
                lora_scripts_custom_install_path_setting
                ;;
            6)
                kohya_ss_custom_install_path_setting
                ;;
            *)
                break
                ;;
        esac
    done
}

# sd-webui安装路径设置
sd_webui_custom_install_path_setting()
{
    local custom_install_path
    local sd_webui_custom_install_path_setting_dialog

    while true
    do
        sd_webui_custom_install_path_setting_dialog=$(dialog --erase-on-exit --notags \
            --title "Term-SD" \
            --backtitle "Stable-Diffusion-WebUI 安装路径设置界面" \
            --ok-label "确认" --cancel-label "取消" \
            --menu "请选择配置选项\n当前自定义安装路径: $([ -f term-sd/config/sd-webui-path.conf ] && cat term-sd/config/sd-webui-path.conf || echo 默认)" \
            $term_sd_dialog_height $term_sd_dialog_width $term_sd_dialog_menu_height \
            "0" "> 返回" \
            "1" "> 设置安装路径" \
            "2" "> 恢复默认安装路径设置" \
            3>&1 1>&2 2>&3)

        case $sd_webui_custom_install_path_setting_dialog in
            1)
                custom_install_path=$(dialog --erase-on-exit \
                    --title "Term-SD" \
                    --backtitle "Stable-Diffusion-WebUI 安装路径设置界面" \
                    --ok-label "确认" --cancel-label "取消" \
                    --inputbox "请输入 Stable-Diffusion-WebUI 安装路径\n注: 请使用绝对路径" \
                    $term_sd_dialog_height $term_sd_dialog_width \
                    "$([ -f term-sd/config/sd-webui-path.conf ] && cat term-sd/config/sd-webui-path.conf)" \
                    3>&1 1>&2 2>&3)

                if [ $? = 0 ] && [ ! -z "$custom_install_path" ];then
                    if [ "$custom_install_path" = "/" ];then
                        dialog --erase-on-exit \
                            --title "Term-SD" \
                            --backtitle "Stable-Diffusion-WebUI 安装路径设置界面" \
                            --ok-label "确认" \
                            --msgbox "禁止将根目录设置为安装路径" \
                            $term_sd_dialog_height $term_sd_dialog_width

                    elif [ "$custom_install_path" = "$comfyui_path" ] ||\
                    [ "$custom_install_path" = "$invokeai_path" ] ||\
                    [ "$custom_install_path" = "$fooocus_path" ] ||\
                    [ "$custom_install_path" = "$lora_scripts_path" ] ||\
                    [ "$custom_install_path" = "$kohya_ss_path" ];then

                        dialog --erase-on-exit \
                            --title "Term-SD" \
                            --backtitle "Stable-Diffusion-WebUI 安装路径设置界面" \
                            --ok-label "确认" \
                            --msgbox "安装路径和其他 AI 软件的安装目录相同, 请重新设置" \
                            $term_sd_dialog_height $term_sd_dialog_width

                    else
                        export sd_webui_path=$custom_install_path
                        export sd_webui_folder=$(basename "$sd_webui_path")
                        export sd_webui_parent_path=$(dirname "$sd_webui_path")
                        echo "$custom_install_path" > term-sd/config/sd-webui-path.conf

                        dialog --erase-on-exit \
                            --title "Term-SD" \
                            --backtitle "Stable-Diffusion-WebUI 安装路径设置界面" \
                            --ok-label "确认" \
                            --msgbox "Stable-Diffusion-WebUI 安装路径设置成功\n安装路径: $custom_install_path\n$([ ! $(echo $custom_install_path | awk '{print substr($0,1,1)}') = "/" ] && echo "检测到安装路径不是绝对路径, 可能会导致一些问题")" \
                            $term_sd_dialog_height $term_sd_dialog_width
                    fi
                fi
                ;;
            2)
                if (dialog --erase-on-exit \
                    --title "Term-SD" \
                    --backtitle "Stable-Diffusion-WebUI 安装路径设置界面" \
                    --yes-label "是" --no-label "否" \
                    --yesno "是否重置 Stable-Diffusion-WebUI 安装路径?" \
                    $term_sd_dialog_height $term_sd_dialog_width) then

                    rm -f term-sd/config/sd-webui-path.conf
                    export sd_webui_path="$start_path/stable-diffusion-webui"
                    export sd_webui_folder="stable-diffusion-webui"
                    export sd_webui_parent_path=$start_path

                    dialog --erase-on-exit \
                        --title "Term-SD" \
                        --backtitle "Stable-Diffusion-WebUI 安装路径设置界面" \
                        --ok-label "确认" \
                        --msgbox "重置 Stable-Diffusion-WebUI 安装路径成功" \
                        $term_sd_dialog_height $term_sd_dialog_width
                fi
                ;;
            *)
                break
                ;;
        esac
    done
}

# comfyui安装路径设置
comfyui_custom_install_path_setting()
{
    local custom_install_path
    local comfyui_custom_install_path_setting_dialog

    while true
    do
        comfyui_custom_install_path_setting_dialog=$(
            dialog --erase-on-exit --notags \
            --title "Term-SD" \
            --backtitle "ComfyUI 安装路径设置界面" \
            --ok-label "确认" \
            --cancel-label "取消" \
            --menu "请选择配置选项\n当前自定义安装路径: $([ -f term-sd/config/comfyui-path.conf ] && cat term-sd/config/comfyui-path.conf || echo 默认)" \
            $term_sd_dialog_height $term_sd_dialog_width $term_sd_dialog_menu_height \
            "0" "> 返回" \
            "1" "> 设置安装路径" \
            "2" "> 恢复默认安装路径设置" \
            3>&1 1>&2 2>&3)

        case $comfyui_custom_install_path_setting_dialog in
            1)
                custom_install_path=$(dialog --erase-on-exit \
                    --title "Term-SD" \
                    --backtitle "ComfyUI 安装路径设置界面" \
                    --ok-label "确认" --cancel-label "取消" \
                    --inputbox "请输入 ComfyUI 安装路径\n注: 请使用绝对路径" \
                    $term_sd_dialog_height $term_sd_dialog_width \
                    "$([ -f term-sd/config/comfyui-path.conf ] && cat term-sd/config/comfyui-path.conf)" \
                    3>&1 1>&2 2>&3)

                if [ $? = 0 ] && [ ! -z "$custom_install_path" ];then
                    if [ "$custom_install_path" = "/" ];then
                        dialog --erase-on-exit \
                            --title "Term-SD" \
                            --backtitle "ComfyUI 安装路径设置界面" \
                            --ok-label "确认" \
                            --msgbox "禁止将根目录设置为安装路径" \
                            $term_sd_dialog_height $term_sd_dialog_width

                    elif [ "$custom_install_path" = "$sd_webui_path" ] ||\
                    [ "$custom_install_path" = "$invokeai_path" ] ||\
                    [ "$custom_install_path" = "$fooocus_path" ] ||\
                    [ "$custom_install_path" = "$lora_scripts_path" ] ||\
                    [ "$custom_install_path" = "$kohya_ss_path" ];then

                        dialog --erase-on-exit \
                            --title "Term-SD" \
                            --backtitle "ComfyUI 安装路径设置界面" \
                            --ok-label "确认" \
                            --msgbox "安装路径和其他 AI 软件的安装目录相同, 请重新设置" \
                            $term_sd_dialog_height $term_sd_dialog_width

                    else
                        export comfyui_path=$custom_install_path
                        export comfyui_folder=$(basename "$comfyui_path")
                        export comfyui_parent_path=$(dirname "$comfyui_path")
                        echo "$custom_install_path" > term-sd/config/comfyui-path.conf

                        dialog --erase-on-exit \
                            --title "Term-SD" \
                            --backtitle "ComfyUI 安装路径设置界面" \
                            --ok-label "确认" \
                            --msgbox "ComfyUI 安装路径设置成功\n安装路径: $custom_install_path\n$([ ! $(echo $custom_install_path | awk '{print substr($0,1,1)}') = "/" ] && echo "检测到安装路径不是绝对路径, 可能会导致一些问题")" \
                            $term_sd_dialog_height $term_sd_dialog_width
                    fi
                fi
                ;;
            2)
                if (dialog --erase-on-exit \
                    --title "Term-SD" \
                    --backtitle "ComfyUI安装路径设置界面" \
                    --yes-label "是" --no-label "否" \
                    --yesno "是否重置 ComfyUI 安装路径?" \
                    $term_sd_dialog_height $term_sd_dialog_width) then

                    rm -f term-sd/config/comfyui-path.conf
                    export comfyui_path="$start_path/ComfyUI"
                    export comfyui_folder="ComfyUI"
                    export comfyui_parent_path=$start_path

                    dialog --erase-on-exit \
                        --title "Term-SD" \
                        --backtitle "ComfyUI 安装路径设置界面" \
                        --ok-label "确认" \
                        --msgbox "重置 ComfyUI 安装路径成功" \
                        $term_sd_dialog_height $term_sd_dialog_width
                fi
                ;;
            *)
                break
                ;;
        esac
    done
}

# invokeai安装路径设置
invokeai_custom_install_path_setting()
{
    local custom_install_path
    local invokeai_custom_install_path_setting_dialog

    while true
    do
        invokeai_custom_install_path_setting_dialog=$(dialog --erase-on-exit --notags \
            --title "Term-SD" \
            --backtitle "InvokeAI 安装路径设置界面" \
            --ok-label "确认" --cancel-label "取消" \
            --menu "请选择配置选项\n当前自定义安装路径: $([ -f term-sd/config/invokeai-path.conf ] && cat term-sd/config/invokeai-path.conf || echo 默认)" \
            $term_sd_dialog_height $term_sd_dialog_width $term_sd_dialog_menu_height \
            "0" "> 返回" \
            "1" "> 设置安装路径" \
            "2" "> 恢复默认安装路径设置" \
            3>&1 1>&2 2>&3)

        case $invokeai_custom_install_path_setting_dialog in
            1)
                custom_install_path=$(dialog --erase-on-exit \
                    --title "Term-SD" \
                    --backtitle "InvokeAI 安装路径设置界面" \
                    --ok-label "确认" --cancel-label "取消" \
                    --inputbox "请输入 InvokeAI 安装路径\n注: 请使用绝对路径" \
                    $term_sd_dialog_height $term_sd_dialog_width \
                    "$([ -f term-sd/config/invokeai-path.conf ] && cat term-sd/config/invokeai-path.conf)" \
                    3>&1 1>&2 2>&3)

                if [ $? = 0 ] && [ ! -z "$custom_install_path" ];then
                    if [ "$custom_install_path" = "/" ];then
                        dialog --erase-on-exit \
                            --title "Term-SD" \
                            --backtitle "InvokeAI 安装路径设置界面" \
                            --ok-label "确认" \
                            --msgbox "禁止将根目录设置为安装路径" \
                            $term_sd_dialog_height $term_sd_dialog_width

                    elif [ "$custom_install_path" = "$sd_webui_path" ] ||\
                    [ "$custom_install_path" = "$comfyui_path" ] ||\
                    [ "$custom_install_path" = "$fooocus_path" ] ||\
                    [ "$custom_install_path" = "$lora_scripts_path" ] ||\
                    [ "$custom_install_path" = "$kohya_ss_path" ];then

                        dialog --erase-on-exit \
                            --title "Term-SD" \
                            --backtitle "InvokeAI 安装路径设置界面" \
                            --ok-label "确认" \
                            --msgbox "安装路径和其他AI软件的安装目录相同, 请重新设置" \
                            $term_sd_dialog_height $term_sd_dialog_width

                    else
                        export invokeai_path=$custom_install_path
                        export invokeai_folder=$(basename "$invokeai_path")
                        export invokeai_parent_path=$(dirname "$invokeai_path")
                        echo "$custom_install_path" > term-sd/config/invokeai-path.conf

                        dialog --erase-on-exit \
                            --title "Term-SD" \
                            --backtitle "InvokeAI 安装路径设置界面" \
                            --ok-label "确认" \
                            --msgbox "InvokeAI 安装路径设置成功\n安装路径: $custom_install_path\n$([ ! $(echo $custom_install_path | awk '{print substr($0,1,1)}') = "/" ] && echo "检测到安装路径不是绝对路径,可能会导致一些问题")" \
                            $term_sd_dialog_height $term_sd_dialog_width
                    fi
                fi
                ;;
            2)
                if (dialog --erase-on-exit \
                    --title "Term-SD" \
                    --backtitle "InvokeAI 安装路径设置界面" \
                    --yes-label "是" --no-label "否" \
                    --yesno "是否重置 InvokeAI 安装路径?" \
                    $term_sd_dialog_height $term_sd_dialog_width) then

                    rm -f term-sd/config/invokeai-path.conf
                    export invokeai_path="$start_path/InvokeAI"
                    export invokeai_folder="InvokeAI"
                    export invokeai_parent_path=$start_path

                    dialog --erase-on-exit \
                        --title "Term-SD" \
                        --backtitle "InvokeAI 安装路径设置界面" \
                        --ok-label "确认" \
                        --msgbox "重置 InvokeAI 安装路径成功" \
                        $term_sd_dialog_height $term_sd_dialog_width
                fi
                ;;
            *)
                break
                ;;
        esac
    done
}

# fooocus安装路径设置
fooocus_custom_install_path_setting()
{
    local custom_install_path
    local fooocus_custom_install_path_setting_dialog

    while true
    do
        fooocus_custom_install_path_setting_dialog=$(dialog --erase-on-exit --notags \
            --title "Term-SD" \
            --backtitle "Fooocus 安装路径设置界面" \
            --ok-label "确认" --cancel-label "取消" \
            --menu "请选择配置选项\n当前自定义安装路径: $([ -f term-sd/config/fooocus-path.conf ] && cat term-sd/config/fooocus-path.conf || echo 默认)" \
            $term_sd_dialog_height $term_sd_dialog_width $term_sd_dialog_menu_height \
            "0" "> 返回" \
            "1" "> 设置安装路径" \
            "2" "> 恢复默认安装路径设置" \
            3>&1 1>&2 2>&3)

        case $fooocus_custom_install_path_setting_dialog in
            1)
                custom_install_path=$(dialog --erase-on-exit \
                    --title "Term-SD" \
                    --backtitle "Fooocus 安装路径设置界面" \
                    --ok-label "确认" --cancel-label "取消" \
                    --inputbox "请输入 Fooocus 安装路径\n注: 请使用绝对路径" \
                    $term_sd_dialog_height $term_sd_dialog_width \
                    "$([ -f term-sd/config/fooocus-path.conf ] && cat term-sd/config/fooocus-path.conf)" \
                    3>&1 1>&2 2>&3)

                if [ $? = 0 ] && [ ! -z "$custom_install_path" ];then
                    if [ "$custom_install_path" = "/" ];then
                        dialog --erase-on-exit \
                            --title "Term-SD" \
                            --backtitle "Fooocus 安装路径设置界面" \
                            --ok-label "确认" \
                            --msgbox "禁止将根目录设置为安装路径" \
                            $term_sd_dialog_height $term_sd_dialog_width

                    elif [ "$custom_install_path" = "$sd_webui_path" ] ||\
                    [ "$custom_install_path" = "$comfyui_path" ] ||\
                    [ "$custom_install_path" = "$invokeai_path" ] ||\
                    [ "$custom_install_path" = "$lora_scripts_path" ] ||\
                    [ "$custom_install_path" = "$kohya_ss_path" ];then

                        dialog --erase-on-exit \
                            --title "Term-SD" \
                            --backtitle "Fooocus 安装路径设置界面" \
                            --ok-label "确认" \
                            --msgbox "安装路径和其他 AI 软件的安装目录相同, 请重新设置" \
                            $term_sd_dialog_height $term_sd_dialog_width

                    else
                        export fooocus_path=$custom_install_path
                        export fooocus_folder=$(basename "$fooocus_path")
                        export fooocus_parent_path=$(dirname "$fooocus_path")
                        echo "$custom_install_path" > term-sd/config/fooocus-path.conf

                        dialog --erase-on-exit \
                            --title "Term-SD" \
                            --backtitle "Fooocus 安装路径设置界面" \
                            --ok-label "确认" \
                            --msgbox "Fooocus 安装路径设置成功\n安装路径: $custom_install_path\n$([ ! $(echo $custom_install_path | awk '{print substr($0,1,1)}') = "/" ] && echo "检测到安装路径不是绝对路径,可能会导致一些问题")" \
                            $term_sd_dialog_height $term_sd_dialog_width
                    fi
                fi
                ;;
            2)
                if (dialog --erase-on-exit \
                --title "Term-SD" \
                --backtitle "Fooocus 安装路径设置界面" \
                --yes-label "是" --no-label "否" \
                --yesno "是否重置 Fooocus 安装路径?" \
                $term_sd_dialog_height $term_sd_dialog_width) then

                    rm -f term-sd/config/fooocus-path.conf
                    export fooocus_path="$start_path/Fooocus"
                    export fooocus_folder="Fooocus"
                    export fooocus_parent_path=$start_path

                    dialog --erase-on-exit \
                        --title "Term-SD" \
                        --backtitle "Fooocus 安装路径设置界面" \
                        --ok-label "确认" --msgbox "重置 Fooocus 安装路径成功" \
                        $term_sd_dialog_height $term_sd_dialog_width
                fi
                ;;
            *)
                break
                ;;
        esac
    done
}

# lora-scripts安装路径设置
lora_scripts_custom_install_path_setting()
{
    local custom_install_path
    local lora_scripts_custom_install_path_setting_dialog

    while true
    do
        lora_scripts_custom_install_path_setting_dialog=$(dialog --erase-on-exit --notags \
            --title "Term-SD" \
            --backtitle "lora-scripts 安装路径设置界面" \
            --ok-label "确认" --cancel-label "取消" \
            --menu "请选择配置选项\n当前自定义安装路径: $([ -f term-sd/config/lora-scripts-path.conf ] && cat term-sd/config/lora-scripts-path.conf || echo 默认)" \
            $term_sd_dialog_height $term_sd_dialog_width $term_sd_dialog_menu_height \
            "0" "> 返回" \
            "1" "> 设置安装路径" \
            "2" "> 恢复默认安装路径设置" \
            3>&1 1>&2 2>&3)

        case $lora_scripts_custom_install_path_setting_dialog in
            1)
                custom_install_path=$(dialog --erase-on-exit \
                    --title "Term-SD" \
                    --backtitle "lora-scripts 安装路径设置界面" \
                    --ok-label "确认" --cancel-label "取消" \
                    --inputbox "请输入 lora-scripts 安装路径\n注: 请使用绝对路径" \
                    $term_sd_dialog_height $term_sd_dialog_width \
                    "$([ -f term-sd/config/lora-scripts-path.conf ] && cat term-sd/config/lora-scripts-path.conf)" \
                    3>&1 1>&2 2>&3)

                if [ $? = 0 ] && [ ! -z "$custom_install_path" ];then
                    if [ "$custom_install_path" = "/" ];then
                        dialog --erase-on-exit \
                            --title "Term-SD" \
                            --backtitle "lora-scripts 安装路径设置界面" \
                            --ok-label "确认" \
                            --msgbox "禁止将根目录设置为安装路径" \
                            $term_sd_dialog_height $term_sd_dialog_width

                    elif [ "$custom_install_path" = "$sd_webui_path" ] ||\
                    [ "$custom_install_path" = "$comfyui_path" ] ||\
                    [ "$custom_install_path" = "$invokeai_path" ] ||\
                    [ "$custom_install_path" = "$fooocus_path" ] ||\
                    [ "$custom_install_path" = "$kohya_ss_path" ];then

                        dialog --erase-on-exit \
                            --title "Term-SD" \
                            --backtitle "lora-scripts 安装路径设置界面" \
                            --ok-label "确认" \
                            --msgbox "安装路径和其他 AI 软件的安装目录相同, 请重新设置" \
                            $term_sd_dialog_height $term_sd_dialog_width

                    else
                        export lora_scripts_path=$custom_install_path
                        export lora_scripts_folder=$(basename "$lora_scripts_path")
                        export lora_scripts_parent_path=$(dirname "$lora_scripts_path")
                        echo "$custom_install_path" > term-sd/config/lora-scripts-path.conf

                        dialog --erase-on-exit \
                            --title "Term-SD" \
                            --backtitle "lora-scripts 安装路径设置界面" \
                            --ok-label "确认" \
                            --msgbox "lora-scripts 安装路径设置成功\n安装路径: $custom_install_path\n$([ ! $(echo $custom_install_path | awk '{print substr($0,1,1)}') = "/" ] && echo "检测到安装路径不是绝对路径,可能会导致一些问题")" \
                            $term_sd_dialog_height $term_sd_dialog_width
                    fi
                fi
                ;;
            2)
                if (dialog --erase-on-exit \
                    --title "Term-SD" \
                    --backtitle "lora-scripts 安装路径设置界面" \
                    --yes-label "是" --no-label "否" \
                    --yesno "是否重置 lora-scripts 安装路径?" \
                    $term_sd_dialog_height $term_sd_dialog_width) then

                    rm -f term-sd/config/lora-scripts-path.conf
                    export lora_scripts_path="$start_path/lora-scripts"
                    export lora_scripts_folder="lora-scripts"
                    export lora_scripts_parent_path=$start_path

                    dialog --erase-on-exit \
                        --title "Term-SD" \
                        --backtitle "lora-scripts 安装路径设置界面" \
                        --ok-label "确认" \
                        --msgbox "重置 lora-scripts 安装路径成功" \
                        $term_sd_dialog_height $term_sd_dialog_width
                fi
                ;;
            *)
                break
                ;;
        esac
    done
}

# kohya_ss安装路径设置
kohya_ss_custom_install_path_setting()
{
    local custom_install_path
    local kohya_ss_custom_install_path_setting_dialog

    while true
    do
        kohya_ss_custom_install_path_setting_dialog=$(dialog --erase-on-exit --notags \
            --title "Term-SD" \
            --backtitle "kohya_ss 安装路径设置界面" \
            --ok-label "确认" --cancel-label "取消" \
            --menu "请选择配置选项\n当前自定义安装路径: $([ -f term-sd/config/kohya_ss-path.conf ] && cat term-sd/config/kohya_ss-path.conf || echo 默认)" \
            $term_sd_dialog_height $term_sd_dialog_width $term_sd_dialog_menu_height \
            "0" "> 返回" \
            "1" "> 设置安装路径" \
            "2" "> 恢复默认安装路径设置" \
            3>&1 1>&2 2>&3)

        case $kohya_ss_custom_install_path_setting_dialog in
            1)
                custom_install_path=$(dialog --erase-on-exit \
                    --title "Term-SD" \
                    --backtitle "kohya_ss 安装路径设置界面" \
                    --ok-label "确认" --cancel-label "取消" \
                    --inputbox "请输入 kohya_ss 安装路径\n注: 请使用绝对路径" \
                    $term_sd_dialog_height $term_sd_dialog_width \
                    "$([ -f term-sd/config/kohya_ss-path.conf ] && cat term-sd/config/kohya_ss-path.conf)" \
                    3>&1 1>&2 2>&3)

                if [ $? = 0 ] && [ ! -z "$custom_install_path" ];then
                    if [ "$custom_install_path" = "/" ];then
                        dialog --erase-on-exit \
                            --title "Term-SD" \
                            --backtitle "kohya_ss 安装路径设置界面" \
                            --ok-label "确认" \
                            --msgbox "禁止将根目录设置为安装路径" \
                            $term_sd_dialog_height $term_sd_dialog_width

                    elif [ "$custom_install_path" = "$sd_webui_path" ] ||\
                    [ "$custom_install_path" = "$comfyui_path" ] ||\
                    [ "$custom_install_path" = "$invokeai_path" ] ||\
                    [ "$custom_install_path" = "$fooocus_path" ] ||\
                    [ "$custom_install_path" = "$lora_scripts_path" ];then

                        dialog --erase-on-exit \
                            --title "Term-SD" \
                            --backtitle "kohya_ss 安装路径设置界面" \
                            --ok-label "确认" \
                            --msgbox "安装路径和其他AI软件的安装目录相同, 请重新设置" \
                            $term_sd_dialog_height $term_sd_dialog_width

                    else
                        export kohya_ss_path=$custom_install_path
                        export kohya_ss_folder=$(basename "$kohya_ss_path")
                        export kohya_ss_parent_path=$(dirname "$kohya_ss_path")
                        echo "$custom_install_path" > term-sd/config/kohya_ss-path.conf

                        dialog --erase-on-exit \
                            --title "Term-SD" \
                            --backtitle "kohya_ss 安装路径设置界面" \
                            --ok-label "确认" \
                            --msgbox "kohya_ss 安装路径设置成功\n安装路径: $custom_install_path\n$([ ! $(echo $custom_install_path | awk '{print substr($0,1,1)}') = "/" ] && echo "检测到安装路径不是绝对路径,可能会导致一些问题")" \
                            $term_sd_dialog_height $term_sd_dialog_width
                    fi
                fi
                ;;
            2)
                if (dialog --erase-on-exit \
                    --title "Term-SD" \
                    --backtitle "kohya_ss 安装路径设置界面" \
                    --yes-label "是" --no-label "否" \
                    --yesno "是否重置 kohya_ss 安装路径?" \
                    $term_sd_dialog_height $term_sd_dialog_width) then

                    rm -f term-sd/config/kohya_ss-path.conf
                    export kohya_ss_path="$start_path/kohya_ss"
                    export kohya_ss_folder="kohya_ss"
                    export kohya_ss_parent_path=$start_path

                    dialog --erase-on-exit \
                        --title "Term-SD" \
                        --backtitle "kohya_ss 安装路径设置界面" \
                        --ok-label "确认" \
                        --msgbox "重置 kohya_ss 安装路径成功" \
                        $term_sd_dialog_height $term_sd_dialog_width
                fi
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
    local network_test
    local req
    local network_test_url
    local count
    local sum
    count=1
    network_test_url="google.com huggingface.co modelscope.cn github.com mirror.ghproxy.com gitclone.com gh-proxy.com ghps.cc gh.idayer.com ghproxy.net"
    sum=$(echo $network_test_url | wc -w)
    term_sd_echo "获取网络信息"
    [ -f "term-sd/task/ipinfo.sh" ] && rm -f term-sd/task/ipinfo.sh
    curl -s ipinfo.io >> term-sd/task/ipinfo.sh
    term_sd_echo "测试网络中"
    for i in $network_test_url; do
        term_sd_echo "[$count/$sum] 测试链接访问: $i"
        count=$(( $count + 1 ))
        curl --connect-timeout 10 $i > /dev/null 2>&1
        if [ $? = 0 ];then
            req="$req $i: 成功 ✓\n"
        else
            req="$req $i: 失败 ×\n"
        fi
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
$req\n
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
        --yesno "警告: 该操作将永久删除 Term-SD 目录中的所有文件, 包括 AI 软件下载的部分模型文件 (存在于 Term-SD 目录中的 \"cache\" 文件夹, 如有必要, 请备份该文件夹)\n是否卸载 Term-SD ?" \
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
