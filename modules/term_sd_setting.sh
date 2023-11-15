#!/bin/bash

# 设置
term_sd_setting()
{
    local term_sd_setting_dialog

    term_sd_setting_dialog=$(
        dialog --erase-on-exit --notags --title "Term-SD" --backtitle "Term-SD设置选项" --ok-label "确认" --cancel-label "取消" --menu "请选择Term-SD设置" $term_sd_dialog_height $term_sd_dialog_width $term_sd_dialog_menu_height \
        "0" "> 返回" \
        "1" "> 虚拟环境设置($([ $venv_setup_status = 0 ] && echo "启用" || echo "禁用"))" \
        "2" "> pip镜像源设置(配置文件)" \
        "3" "> pip镜像源设置(环境变量)($([ ! -z $(echo $PIP_INDEX_URL | grep "pypi.python.org") ] && echo "官方源" || echo "国内镜像源"))" \
        "4" "> pip缓存清理" \
        "5" "> 代理设置($([ -z $http_proxy ] && echo "无" || echo "代理地址:$(echo $http_proxy | awk '{print substr($1,1,40)}')"))" \
        "6" "> 命令执行监测设置($([ -f "./term-sd/term-sd-watch-retry.conf" ] && echo "启用(重试次数:$(cat ./term-sd/term-sd-watch-retry.conf))" || echo "禁用"))" \
        "7" "> Term-SD安装模式($([ ! -f "./term-sd/term-sd-disable-strict-install-mode.lock" ] && echo "严格模式" || echo "宽容模式"))" \
        "8" "> aria2线程设置($([ -f "./term-sd/aria2-thread.conf" ] && echo "启用(线程数:$(cat ./term-sd/aria2-thread.conf | awk '{sub("-x ","")}1'))" || echo "禁用"))" \
        "9" "> 缓存重定向设置($([ ! -f "./term-sd/disable-cache-path-redirect.lock" ] && echo "启用" || echo "禁用"))" \
        "10" "> CUDA内存分配设置($([ -f "./term-sd/cuda-memory-alloc.conf" ] && echo $([ ! -z $(cat ./term-sd/cuda-memory-alloc.conf | grep cudaMallocAsync) ] && echo "CUDA内置异步分配器" || echo "PyTorch原生分配器") || echo "未设置"))" \
        "11" "> 空间占用分析" \
        "12" "> 网络连接测试" \
        "13" "> 卸载Term-SD" \
        3>&1 1>&2 2>&3)

    case $term_sd_setting_dialog in
        1)
            python_venv_setting
            term_sd_setting
            ;;
        2)
            pip_mirrors_setting
            term_sd_setting
            ;;
        3)
            pip_mirrors_env_setting
            term_sd_setting
            ;;
        4)
            pip_cache_clean
            term_sd_setting
            ;;
        5)
            term_sd_proxy_setting
            term_sd_setting
            ;;
        6)
            term_sd_watch_setting
            term_sd_setting
            ;;
        7)
            term_sd_install_mode_setting
            term_sd_setting
            ;;
        8)
            aria2_multi_threaded_setting
            term_sd_setting
            ;;
        9)
            term_sd_cache_redirect_setting
            term_sd_setting
            ;;
        10)
            cuda_memory_alloc_setting
            term_sd_setting
            ;;
        11)
            term_sd_disk_space_stat
            term_sd_setting
            ;;
        12)
            term_sd_network_test
            term_sd_setting
            ;;
        13)
            term_sd_uninstall_interface
            term_sd_setting
            ;;
    esac
}

# 虚拟环境设置
python_venv_setting()
{
    local python_venv_setting_dialog
    export venv_setup_status

    python_venv_setting_dialog=$(
        dialog --erase-on-exit --notags --title "Term-SD" --backtitle "虚拟环境设置界面" --ok-label "确认" --cancel-label "取消" --menu "该功能用于给AI软件启用虚拟环境,隔离不同AI软件的python库,防止python库中软件包版本和AI软件的版本要求不对应\n当前虚拟环境状态:$([ $venv_setup_status = 0 ] && echo "启用" || echo "禁用")\n是否启用虚拟环境?(推荐启用)" $term_sd_dialog_height $term_sd_dialog_width $term_sd_dialog_menu_height \
        "0" "> 返回" \
        "1" "> 启用" \
        "2" "> 禁用" \
        3>&1 1>&2 2>&3)

    case $python_venv_setting_dialog in
        1)
            venv_setup_status=0
            rm -rf ./term-sd/term-sd-venv-disable.lock
            dialog --erase-on-exit --title "Term-SD" --backtitle "虚拟环境设置界面" --ok-label "确认" --msgbox "启用成功" $term_sd_dialog_height $term_sd_dialog_width
            python_venv_setting
            ;;
        2)
            venv_setup_status=1
            touch ./term-sd/term-sd-venv-disable.lock
            dialog --erase-on-exit --title "Term-SD" --backtitle "虚拟环境设置界面" --ok-label "确认" --msgbox "禁用成功" $term_sd_dialog_height $term_sd_dialog_width
            python_venv_setting
            ;;
    esac
}

# pip镜像源选项(配置文件)
pip_mirrors_setting()
{
    local pip_mirrors_setting_dialog

    term_sd_echo "获取pip全局配置"
    pip_mirrors_setting_dialog=$(
        dialog --erase-on-exit --notags --title "Term-SD" --backtitle "pip镜像源(配置文件)选项" --ok-label "确认" --cancel-label "取消" --menu "该功能用于设置pip镜像源(环境变量)(优先级小于环境变量配置),加速国内下载python软件包的速度\n当前pip全局配置:\n$(term_sd_pip config list | awk '{print$0}')\n请选择设置的pip镜像源(配置文件)" $term_sd_dialog_height $term_sd_dialog_width $term_sd_dialog_menu_height \
        "0" "> 返回" \
        "1" "> 设置官方源" \
        "2" "> 设置国内镜像源" \
        "3" "> 删除镜像源配置" \
        3>&1 1>&2 2>&3)

    case $pip_mirrors_setting_dialog in
        1)
            term_sd_echo "设置pip镜像源为官方源"
            term_sd_pip config set global.index-url "https://pypi.python.org/simple"
            term_sd_pip config unset global.extra-index-url
            term_sd_pip config set global.find-links "https://download.pytorch.org/whl/torch_stable.html"
            dialog --erase-on-exit --title "Term-SD" --backtitle "pip镜像源(配置文件)选项" --ok-label "确认" --msgbox "设置pip镜像源为官方源成功" $term_sd_dialog_height $term_sd_dialog_width
            pip_mirrors_setting
            ;;
        2)
            term_sd_echo "设置pip镜像源为国内镜像源"
            term_sd_pip config set global.index-url "https://mirrors.bfsu.edu.cn/pypi/web/simple"
            term_sd_pip config set global.extra-index-url "https://mirrors.hit.edu.cn/pypi/web/simple https://pypi.tuna.tsinghua.edu.cn/simple https://mirror.nju.edu.cn/pypi/web/simple"
            term_sd_pip config set global.find-links "https://mirrors.aliyun.com/pytorch-wheels/torch_stable.html https://mirror.sjtu.edu.cn/pytorch-wheels/torch_stable.html"
            dialog --erase-on-exit --title "Term-SD" --backtitle "pip镜像源(配置文件)选项" --ok-label "确认" --msgbox "设置pip镜像源为国内镜像源成功" $term_sd_dialog_height $term_sd_dialog_width
            pip_mirrors_setting
            ;;
        3)
            term_sd_echo "删除镜像源配置"
            term_sd_pip config unset global.extra-index-url
            term_sd_pip config unset global.index-url
            term_sd_pip config unset global.find-links
            dialog --erase-on-exit --title "Term-SD" --backtitle "pip镜像源(配置文件)选项" --ok-label "确认" --msgbox "删除镜像源配置成功" $term_sd_dialog_height $term_sd_dialog_width
            pip_mirrors_setting
            ;;
    esac
}

# pip镜像源设置(环境变量)
pip_mirrors_env_setting()
{
    local pip_mirrors_env_setting_dialog
    export PIP_INDEX_URL
    export PIP_EXTRA_INDEX_URL
    export PIP_FIND_LINKS

    pip_mirrors_env_setting_dialog=$(
        dialog --erase-on-exit --notags --title "Term-SD" --backtitle "pip镜像源(环境变量)选项" --ok-label "确认" --cancel-label "取消" --menu "该功能用于设置pip镜像源(环境变量)(优先级大于全局配置),加速国内下载python软件包的速度\n当前pip环境变量配置:$([ ! -z $(echo $PIP_INDEX_URL | grep "pypi.python.org") ] && echo "官方源" || echo "国内镜像源")\n请选择设置的pip镜像源(环境变量)" $term_sd_dialog_height $term_sd_dialog_width $term_sd_dialog_menu_height \
        "0" "> 返回" \
        "1" "> 设置官方源" \
        "2" "> 设置国内镜像源(默认)" \
        3>&1 1>&2 2>&3)

    case $pip_mirrors_env_setting_dialog in
        1)
            PIP_INDEX_URL="https://pypi.python.org/simple"
            PIP_EXTRA_INDEX_URL=""
            PIP_FIND_LINKS="https://download.pytorch.org/whl/torch_stable.html"
            touch ./term-sd/disable-pip-mirror.lock
            dialog --erase-on-exit --title "Term-SD" --backtitle "pip镜像源(环境变量)选项" --ok-label "确认" --msgbox "设置pip镜像源为官方源成功" $term_sd_dialog_height $term_sd_dialog_width
            pip_mirrors_env_setting
            ;;
        2)
            PIP_INDEX_URL="https://mirrors.bfsu.edu.cn/pypi/web/simple"
            PIP_EXTRA_INDEX_URL="https://mirrors.hit.edu.cn/pypi/web/simple https://pypi.tuna.tsinghua.edu.cn/simple https://mirror.nju.edu.cn/pypi/web/simple"
            PIP_FIND_LINKS="https://mirrors.aliyun.com/pytorch-wheels/torch_stable.html https://mirror.sjtu.edu.cn/pytorch-wheels/torch_stable.html"
            rm -f ./term-sd/disable-pip-mirror.lock
            dialog --erase-on-exit --title "Term-SD" --backtitle "pip镜像源(环境变量)选项" --ok-label "确认" --msgbox "设置pip镜像源为国内镜像源成功" $term_sd_dialog_height $term_sd_dialog_width
            pip_mirrors_env_setting
            ;;
    esac
}

# pip缓存清理功能
pip_cache_clean()
{
    term_sd_echo "统计pip缓存信息"
    if (dialog --erase-on-exit --title "Term-SD" --backtitle "pip缓存清理选项" --yes-label "是" --no-label "否" --yesno "pip缓存信息:\npip缓存路径:$(term_sd_pip cache dir)\n包索引页面缓存大小:$(term_sd_pip cache info | grep "Package index page cache size" | awk -F ':'  '{print $2 $3 $4}')\n本地构建的wheel包大小:$(term_sd_pip cache info | grep "Locally built wheels size" | awk -F ':'  '{print $2 $3 $4}')\n是否删除pip缓存?" $term_sd_dialog_height $term_sd_dialog_width);then
        term_sd_pip cache purge
        dialog --erase-on-exit --title "Term-SD" --backtitle "pip缓存清理选项" --ok-label "确认" --msgbox "清理pip缓存完成" $term_sd_dialog_height $term_sd_dialog_width
    fi
}

# 代理设置
term_sd_proxy_setting()
{
    local term_sd_proxy_config
    local term_sd_proxy_setting_dialog
    export http_proxy
    export https_proxy

    term_sd_proxy_setting_dialog=$(
        dialog --erase-on-exit --notags --title "Term-SD" --backtitle "代理设置界面" --ok-label "确认" --cancel-label "取消" --menu "该功能用于设置代理服务器,解决AI软件和Term-SD因网络环境导致无法连接上服务器,而出现报错的问题\n当前代理设置:$([ -z $http_proxy ] && echo "无" || echo $http_proxy)\n请选择设置代理协议" $term_sd_dialog_height $term_sd_dialog_width $term_sd_dialog_menu_height \
        "0" "> 返回" \
        "1" "> http协议" \
        "2" "> socks协议" \
        "3" "> socks5协议" \
        "4" "> 删除代理参数" \
        3>&1 1>&2 2>&3)

    case $term_sd_proxy_setting_dialog in
        1)
            term_sd_proxy_config=$(dialog --erase-on-exit --title "Term-SD" --backtitle "代理参数设置界面" --ok-label "确认" --cancel-label "取消" --inputbox "请输入代理地址\n格式:<ip>:<port>" $term_sd_dialog_height $term_sd_dialog_width "$(echo $http_proxy | awk -F'://' '{print $NF}')" 3>&1 1>&2 2>&3)
            term_sd_proxy_config=$(echo $term_sd_proxy_config | awk '{gsub(/[：]/, ":") ; gsub(/[。]/, ".")}1') # 防止用户输入中文冒号,句号后导致错误
            if [ $? = 0 ];then
                http_proxy="http://$term_sd_proxy_config"
                https_proxy="http://$term_sd_proxy_config"
                echo "http://$term_sd_proxy_config" > ./term-sd/proxy.conf
                dialog --erase-on-exit --title "Term-SD" --backtitle "代理参数设置界面" --ok-label "确认" --msgbox "代理地址:\"$http_proxy\"\n代理协议:\"$(echo $http_proxy | awk -F '://' '{print$NR}')\"\n设置代理完成" $term_sd_dialog_height $term_sd_dialog_width
            fi
            term_sd_proxy_setting
            ;;
        2)
            term_sd_proxy_config=$(dialog --erase-on-exit --title "Term-SD" --backtitle "代理参数设置界面" --ok-label "确认" --cancel-label "取消" --inputbox "请输入代理地址\n格式:<ip>:<port>" $term_sd_dialog_height $term_sd_dialog_width "$(echo $http_proxy | awk -F'://' '{print $NF}')" 3>&1 1>&2 2>&3)
            term_sd_proxy_config=$(echo $term_sd_proxy_config | awk '{gsub(/[：]/, ":") ; gsub(/[。]/, ".")}1') # 防止用户输入中文冒号,句号后导致错误
            if [ $? = 0 ];then
                http_proxy="socks://$term_sd_proxy_config"
                https_proxy="socks://$term_sd_proxy_config"
                echo "socks://$term_sd_proxy_config" > ./term-sd/proxy.conf
                dialog --erase-on-exit --title "Term-SD" --backtitle "代理参数设置界面" --ok-label "确认" --msgbox "代理地址:\"$http_proxy\"\n代理协议:\"$(echo $http_proxy | awk -F '://' '{print$NR}')\"\n设置代理完成" $term_sd_dialog_height $term_sd_dialog_width
            fi
            term_sd_proxy_setting
            ;;
        3)
            term_sd_proxy_config=$(dialog --erase-on-exit --title "Term-SD" --backtitle "代理参数设置界面" --ok-label "确认" --cancel-label "取消" --inputbox "请输入代理地址\n格式:<ip>:<port>" $term_sd_dialog_height $term_sd_dialog_width "$(echo $http_proxy | awk -F'://' '{print $NF}')" 3>&1 1>&2 2>&3)
            term_sd_proxy_config=$(echo $term_sd_proxy_config | awk '{gsub(/[：]/, ":") ; gsub(/[。]/, ".")}1') # 防止用户输入中文冒号,句号后导致错误
            if [ $? = 0 ];then
                http_proxy="socks5://$term_sd_proxy_config"
                https_proxy="socks5://$term_sd_proxy_config"
                echo "socks5://$term_sd_proxy_config" > ./term-sd/proxy.conf
                dialog --erase-on-exit --title "Term-SD" --backtitle "代理参数设置界面" --ok-label "确认" --msgbox "代理地址:\"$http_proxy\"\n代理协议:\"$(echo $http_proxy | awk -F '://' '{print$NR}')\"\n设置代理完成" $term_sd_dialog_height $term_sd_dialog_width
            fi
            term_sd_proxy_setting
            ;;
        4)
            if (dialog --erase-on-exit --title "Term-SD" --backtitle "代理参数删除界面" --yes-label "是" --no-label "否" --yesno "是否删除代理配置?" $term_sd_dialog_height $term_sd_dialog_width) then
                http_proxy=
                https_proxy=
                rm -f ./term-sd/proxy.conf
                dialog --erase-on-exit --title "Term-SD" --backtitle "代理参数设置界面" --ok-label "确认" --msgbox "清除设置代理完成" $term_sd_dialog_height $term_sd_dialog_width
            fi
            term_sd_proxy_setting
            ;;
    esac
}

# 命令执行监测设置
term_sd_watch_setting()
{
    local term_sd_watch_setting_dialog
    local term_sd_watch_value
    export term_sd_cmd_retry

    term_sd_watch_setting_dialog=$(
        dialog --erase-on-exit --notags --title "Term-SD" --backtitle "命令执行监测设置界面" --ok-label "确认" --cancel-label "取消" --menu "该功能用于监测命令的运行情况,若设置了重试次数,Term-SD将重试执行失败的命令(有些命令需要联网,在网络不稳定的时候容易导致命令执行失败),保证命令执行成功\n当前状态:$([ -f "./term-sd/term-sd-watch-retry.conf" ] && echo "启用(重试次数:$(cat ./term-sd/term-sd-watch-retry.conf))" || echo "禁用")\n是否启用命令执行监测?(推荐启用)" $term_sd_dialog_height $term_sd_dialog_width $term_sd_dialog_menu_height \
        "0" "> 返回" \
        "1" "> 启用" \
        "2" "> 禁用" \
        3>&1 1>&2 2>&3)

    case $term_sd_watch_setting_dialog in
        1)
            term_sd_watch_value=$(dialog --erase-on-exit --title "Term-SD" --backtitle "命令执行监测设置界面" --ok-label "确认" --cancel-label "取消" --inputbox "请输入重试次数(仅输入数字,不允许输入负数和其他非数字的字符)" $term_sd_dialog_height $term_sd_dialog_width "$(cat ./term-sd/term-sd-watch-retry.conf)" 3>&1 1>&2 2>&3)
            if [ ! -z "$(echo $term_sd_watch_value | awk '{gsub(/[0-9]/, "")}1')" ];then
                dialog --erase-on-exit --title "Term-SD" --backtitle "命令执行监测设置界面" --ok-label "确认" --msgbox "输入格式错误,重试次数只能为数字且不能为负数" $term_sd_dialog_height $term_sd_dialog_width
            else
                echo "$term_sd_watch_value" > ./term-sd/term-sd-watch-retry.conf
                term_sd_cmd_retry=$term_sd_watch_value
                dialog --erase-on-exit --title "Term-SD" --backtitle "命令执行监测设置界面" --ok-label "确认" --msgbox "启用成功" $term_sd_dialog_height $term_sd_dialog_width
            fi
            term_sd_watch_setting
            ;;
        2)
            rm -rf ./term-sd/term-sd-watch-retry.conf
            term_sd_cmd_retry=0
            dialog --erase-on-exit --title "Term-SD" --backtitle "命令执行监测设置界面" --ok-label "确认" --msgbox "禁用成功" $term_sd_dialog_height $term_sd_dialog_width
            term_sd_watch_setting
            ;;
    esac
}

# 安装模式设置
term_sd_install_mode_setting()
{
    local term_sd_install_mode_setting_dialog
    export term_sd_install_mode

    term_sd_install_mode_setting_dialog=$(
        dialog --erase-on-exit --notags --title "Term-SD" --backtitle "安装模式设置界面" --ok-label "确认" --cancel-label "取消" --menu "该功能用于设置Term-SD安装AI软件的工作模式。当启用\"严格模式\"后,Term-SD在安转AI软件时出现执行失败的命令时将停止安装进程(Term-SD支持断点恢复,可恢复上次安装进程中断的位置),而\"宽容模式\"在安转AI软件时出现执行失败的命令时忽略执行失败的命令继续执行完成安装任务\n当前安装模式:$([ ! -f "./term-sd/term-sd-disable-strict-install-mode.lock" ] && echo "严格模式" || echo "宽容模式")\n请选择要设置的安装模式(默认启用严格模式)" $term_sd_dialog_height $term_sd_dialog_width $term_sd_dialog_menu_height \
        "0" "> 返回" \
        "1" "> 严格模式" \
        "2" "> 宽容模式" \
        3>&1 1>&2 2>&3)

    case $term_sd_install_mode_setting_dialog in
        1)
            term_sd_install_mode=0
            rm -f ./term-sd/term-sd-disable-strict-install-mode.lock
            dialog --erase-on-exit --title "Term-SD" --backtitle "安装模式设置界面" --ok-label "确认" --msgbox "启用严格模式成功" $term_sd_dialog_height $term_sd_dialog_width
            term_sd_install_mode_setting
            ;;
        2)
            term_sd_install_mode=1
            touch ./term-sd/term-sd-disable-strict-install-mode.lock
            dialog --erase-on-exit --title "Term-SD" --backtitle "安装模式设置界面" --ok-label "确认" --msgbox "启用宽容模式成功" $term_sd_dialog_height $term_sd_dialog_width
            term_sd_install_mode_setting
            ;;
    esac
}

# aria2线程设置
aria2_multi_threaded_setting()
{
    local aria2_multi_threaded_setting_dialog
    local aria2_multi_threaded_value
    export aria2_multi_threaded

    aria2_multi_threaded_setting_dialog=$(
        dialog --erase-on-exit --notags --title "Term-SD" --backtitle "aria2线程设置界面" --ok-label "确认" --cancel-label "取消" --menu "该功能用于增加Term-SD在使用aria2下载模型时的线程数,在一定程度上提高下载速度\n当前状态:$([ -f "./term-sd/aria2-thread.conf" ] && echo "启用(线程数:$(cat ./term-sd/aria2-thread.conf | awk '{sub("-x ","")}1'))" || echo "禁用")\n是否启用aria2多线程下载?" $term_sd_dialog_height $term_sd_dialog_width $term_sd_dialog_menu_height \
        "0" "> 返回" \
        "1" "> 启用" \
        "2" "> 禁用" \
        3>&1 1>&2 2>&3)

    case $aria2_multi_threaded_setting_dialog in
        1)
            aria2_multi_threaded_value=$(dialog --erase-on-exit --title "Term-SD" --backtitle "aria2线程设置界面" --ok-label "确认" --cancel-label "取消" --inputbox "请输入线程数(仅输入数字(),不允许输入负数和其他非数字的字符)" $term_sd_dialog_height $term_sd_dialog_width "$(cat ./term-sd/aria2-thread.conf | awk '{sub("-x ","")}1')" 3>&1 1>&2 2>&3)
            if [ ! -z "$(echo $aria2_multi_threaded_value | awk '{gsub(/[0-9]/, "")}1')" ] || [ $aria2_multi_threaded_value = 0 ] ;then
                dialog --erase-on-exit --title "Term-SD" --backtitle "aria2线程设置界面" --ok-label "确认" --msgbox "输入格式错误,线程数只能为数字且不能为负数" $term_sd_dialog_height $term_sd_dialog_width
            else
                if [ $aria2_multi_threaded_value -le 16 ];then
                    echo "-x $aria2_multi_threaded_value" > ./term-sd/aria2-thread.conf
                    aria2_multi_threaded="-x $aria2_multi_threaded_value"
                    dialog --erase-on-exit --title "Term-SD" --backtitle "aria2线程设置界面" --ok-label "确认" --msgbox "启用成功" $term_sd_dialog_height $term_sd_dialog_width
                else
                    echo "-x 16" > ./term-sd/aria2-thread.conf
                    aria2_multi_threaded="-x 16"
                    dialog --erase-on-exit --title "Term-SD" --backtitle "aria2线程设置界面" --ok-label "确认" --msgbox "启用成功" $term_sd_dialog_height $term_sd_dialog_width
                fi
            fi
            aria2_multi_threaded_setting
            ;;
        2)
            rm -rf ./term-sd/aria2-thread.conf
            aria2_multi_threaded=
            dialog --erase-on-exit --title "Term-SD" --backtitle "aria2线程设置界面" --ok-label "确认" --msgbox "禁用成功" $term_sd_dialog_height $term_sd_dialog_width
            aria2_multi_threaded_setting
            ;;
    esac
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

    term_sd_cache_redirect_setting_dialog=$(
        dialog --erase-on-exit --notags --title "Term-SD" --backtitle "缓存重定向设置界面" --ok-label "确认" --cancel-label "取消" --menu "该功能将会把ai软件产生的缓存重定向至Term-SD中(便于清理)\n当前状态:$([ ! -f "./term-sd/disable-cache-path-redirect.lock" ] && echo "启用" || echo "禁用")\n是否启用缓存重定向?" $term_sd_dialog_height $term_sd_dialog_width $term_sd_dialog_menu_height \
        "0" "> 返回" \
        "1" "> 启用" \
        "2" "> 禁用" \
        3>&1 1>&2 2>&3)

    case $term_sd_cache_redirect_setting_dialog in
        1)
            rm -f ./term-sd/disable-cache-path-redirect.lock
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
            dialog --erase-on-exit --title "Term-SD" --backtitle "缓存重定向设置界面" --ok-label "确认" --msgbox "启用成功" $term_sd_dialog_height $term_sd_dialog_width
            term_sd_cache_redirect_setting
            ;;
        2)
            touch -f ./term-sd/disable-cache-path-redirect.lock
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
            dialog --erase-on-exit --title "Term-SD" --backtitle "缓存重定向设置界面" --ok-label "确认" --msgbox "禁用成功" $term_sd_dialog_height $term_sd_dialog_width
            term_sd_cache_redirect_setting
            ;;
    esac
}

# cuda内存分配设置
cuda_memory_alloc_setting()
{
    local cuda_memory_alloc_setting_dialog
    export PYTORCH_CUDA_ALLOC_CONF

    cuda_memory_alloc_setting_dialog=$(
        dialog --erase-on-exit --notags --title "Term-SD" --backtitle "CUDA内存分配设置界面" --ok-label "确认" --cancel-label "取消" --menu "该功能用于更换底层CUDA内存分配器(仅支持nvidia显卡,且CUDA版本需要大于11.4)\n当前内存分配器:$([ -f "./term-sd/cuda-memory-alloc.conf" ] && echo $([ ! -z $(cat ./term-sd/cuda-memory-alloc.conf | grep cudaMallocAsync) ] && echo "CUDA内置异步分配器" || echo "PyTorch原生分配器") || echo "未设置")\n请选择CUDA内存分配器" $term_sd_dialog_height $term_sd_dialog_width $term_sd_dialog_menu_height \
        "0" "> 返回" \
        "1" "> PyTorch原生分配器" \
        "2" "> CUDA(11.4+)内置异步分配器" \
        "3" "> 清除设置" \
        3>&1 1>&2 2>&3)

    case $cuda_memory_alloc_setting_dialog in
        1)
            PYTORCH_CUDA_ALLOC_CONF=garbage_collection_threshold:0.9,max_split_size_mb:512
            echo "garbage_collection_threshold:0.9,max_split_size_mb:512" > ./term-sd/cuda-memory-alloc.conf
            dialog --erase-on-exit --title "Term-SD" --backtitle "CUDA内存分配设置界面" --ok-label "确认" --msgbox "设置CUDA内存分配器为PyTorch原生分配器成功" $term_sd_dialog_height $term_sd_dialog_width
            cuda_memory_alloc_setting
            ;;
        2)
            PYTORCH_CUDA_ALLOC_CONF=backend:cudaMallocAsync
            echo "backend:cudaMallocAsync" > ./term-sd/cuda-memory-alloc.conf
            dialog --erase-on-exit --title "Term-SD" --backtitle "CUDA内存分配设置界面" --ok-label "确认" --msgbox "设置CUDA内存分配器为CUDA内置异步分配器成功" $term_sd_dialog_height $term_sd_dialog_width
            cuda_memory_alloc_setting
            ;;
        3)
            PYTORCH_CUDA_ALLOC_CONF=
            rm -f ./term-sd/cuda-memory-alloc.conf
            dialog --erase-on-exit --title "Term-SD" --backtitle "CUDA内存分配设置界面" --ok-label "确认" --msgbox "清除CUDA内存分配器设置成功" $term_sd_dialog_height $term_sd_dialog_width
            cuda_memory_alloc_setting
            ;;
    esac
}

# 储存占用分析
term_sd_disk_space_stat()
{
    term_sd_echo "统计空间占用中"
    dialog --erase-on-exit --title "Term-SD" --backtitle "Term-SD空间占用分析" --ok-label "确认" --msgbox "当前目录剩余空间:$(df ./ -h |awk 'NR==2'|awk -F ' ' ' {print $4} ')\n
项目空间占用:\n
Term-SD(重定向)缓存目录:$([ -d "./term-sd/cache" ] && du -sh ./term-sd/cache | awk -F ' ' ' {print $1} ' || echo "无")\n
stable-diffusion-webui:$([ -d "./stable-diffusion-webui" ] && du -sh ./stable-diffusion-webui | awk -F ' ' ' {print $1} ' || echo "未安装")\n
ComfyUI:$([ -d "./ComfyUI" ] && du -sh ./ComfyUI | awk -F ' ' ' {print $1} ' || echo "未安装")\n
InvokeAI:$([ -d "./InvokeAI" ] && du -sh ./InvokeAI | awk -F ' ' ' {print $1} ' || echo "未安装")\n
lora-scripts:$([ -d "./lora-scripts" ] && du -sh ./lora-scripts | awk -F ' ' ' {print $1} ' || echo "未安装")\n
Fooocus:$([ -d "./Fooocus" ] && du -sh ./Fooocus | awk -F ' ' ' {print $1} ' || echo "未安装")\n
" $term_sd_dialog_height $term_sd_dialog_width
}

# 网络连接测试
term_sd_network_test()
{
    term_sd_echo "测试网络中"
    dialog --erase-on-exit --title "Term-SD" --backtitle "Term-SD网络测试" --ok-label "确认" --msgbox "网络测试结果:\n
------------------------------------------------------------------\n
网络信息:\n
$(curl -s ipinfo.io)\n
------------------------------------------------------------------\n
网站访问:\n
google.com: $(curl google.com > /dev/null 2>&1 && echo "成功" || echo "失败")\n
huggingface.co: $(curl huggingface.co > /dev/null 2>&1 && echo "成功" || echo "失败")\n
modelscope: $(curl modelscope.cn > /dev/null 2>&1 && echo "成功" || echo "失败")\n
github.com: $(curl github.com > /dev/null 2>&1 && echo "成功" || echo "失败")\n
ghproxy.com: $(curl ghproxy.com > /dev/null 2>&1 && echo "成功" || echo "失败")\n
gitclone.com: $(curl gitclone.com > /dev/null 2>&1 && echo "成功" || echo "失败")\n
gh-proxy.com: $(curl gh-proxy.com > /dev/null 2>&1 && echo "成功" || echo "失败")\n
ghps.cc: $(curl ghps.cc > /dev/null 2>&1 && echo "成功" || echo "失败")\n
gh.idayer.com: $(curl gh.idayer.com > /dev/null 2>&1 && echo "成功" || echo "失败")\n
------------------------------------------------------------------\n
" $term_sd_dialog_height $term_sd_dialog_width
}

# 卸载选项
term_sd_uninstall_interface()
{
    if (dialog --erase-on-exit --title "Term-SD" --backtitle "Term-SD卸载界面" --yes-label "是" --no-label "否" --yesno "警告:该操作将永久删除Term-SD目录中的所有文件,包括ai软件下载的部分模型文件(存在于Term-SD目录中的\"cache\"文件夹,如有必要,请备份该文件夹)\n是否卸载Term-SD?" $term_sd_dialog_height $term_sd_dialog_width) then
        term_sd_echo "请再次确认是否删除Term-SD(yes/no)?"
        term_sd_echo "警告:该操作将永久删除Term-SD"
        term_sd_echo "提示:输入yes或no后回车"
        case $(term_sd_read) in
            y|yes|YES|Y)
                term_sd_echo "开始卸载Term-SD"
                rm -f ./term-sd
                rm -rf ./term-sd.sh
                user_shell=$(echo $SHELL | awk -F "/" '{print $NF}') # 读取用户所使用的shell
                if [ $user_shell = bash ] || [ $user_shell = zsh ];then
                    sed -i '/# Term-SD/d' ~/."$user_shell"rc
                    sed -i '/term_sd(){/d' ~/."$user_shell"rc
                    sed -i '/alias tsd/d' ~/."$user_shell"rc
                fi
                term_sd_echo "Term-SD卸载完成"
                exit 1
                ;;
            *)
                term_sd_echo "取消卸载操作"
                ;;
        esac
    else
        term_sd_echo "取消卸载操作"
    fi
}