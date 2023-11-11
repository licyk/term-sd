#!/bin/bash

# 设置
term_sd_setting()
{
    local term_sd_setting_dialog

    term_sd_setting_dialog=$(dialog --erase-on-exit --title "Term-SD" --backtitle "Term-SD设置选项" --ok-label "确认" --cancel-label "取消" --menu "请选择Term-SD设置" 25 80 10 \
        "0" "返回" \
        "1" "虚拟环境设置($([ $venv_setup_status = 0 ] && echo "启用" || echo "禁用"))" \
        "2" "pip镜像源设置" \
        "3" "pip缓存清理" \
        "4" "代理设置($([ -z $http_proxy ] && echo "无" || echo "代理地址:$http_proxy"))" \
        "5" "命令执行监测设置($([ -f "./term-sd/term-sd-watch-retry.conf" ] && echo "启用(重试次数:$(cat ./term-sd/term-sd-watch-retry.conf))" || echo "禁用"))" \
        "6" "Term-SD安装模式($([ ! -f "./term-sd/term-sd-disable-strict-install-mode.lock" ] && echo "严格模式" || echo "宽容模式"))" \
        "7" "aria2线程设置($([ -f "./term-sd/aria2-thread.conf" ] && echo "启用(线程数:$(cat ./term-sd/aria2-thread.conf | awk '{sub("-x ","")}1'))" || echo "禁用"))" \
        "8" "缓存重定向设置($([ ! -f "./term-sd/disable-cache-path-redirect.lock" ] && echo "启用" || echo "禁用"))" \
        "9" "空间占用分析" \
        "10" "网络连接测试" \
        "11" "卸载Term-SD" \
        3>&1 1>&2 2>&3)

    case $term_sd_setting_dialog in
        1)
            venv_setting
            term_sd_setting
            ;;
        2)
            pip_mirrors_setting
            term_sd_setting
            ;;
        3)
            pip_cache_clean
            term_sd_setting
            ;;
        4)
            term_sd_proxy_setting
            term_sd_setting
            ;;
        5)
            term_sd_watch_setting
            term_sd_setting
            ;;
        6)
            term_sd_install_mode_setting
            term_sd_setting
            ;;
        7)
            aria2_multi_threaded_setting
            term_sd_setting
            ;;
        8)
            term_sd_cache_redirect_setting
            term_sd_setting
            ;;
        9)
            term_sd_disk_space_stat
            term_sd_setting
            ;;
        10)
            term_sd_network_test
            term_sd_setting
            ;;
        11)
            term_sd_uninstall_interface
            term_sd_setting
            ;;
    esac
}

# 命令执行监测设置
term_sd_watch_setting()
{
    local term_sd_watch_setting_dialog
    local term_sd_watch_value
    export term_sd_cmd_retry

    term_sd_watch_setting_dialog=$(dialog --erase-on-exit --title "Term-SD" --backtitle "命令执行监测设置界面" --ok-label "确认" --cancel-label "取消" --menu "该功能用于监测命令的运行情况,若设置了重试次数,Term-SD将重试执行失败的命令(有些命令需要联网,在网络不稳定的时候容易导致命令执行失败),保证命令执行成功\n当前状态:$([ -f "./term-sd/term-sd-watch-retry.conf" ] && echo "启用(重试次数:$(cat ./term-sd/term-sd-watch-retry.conf))" || echo "禁用")\n是否启用命令执行监测?(推荐启用)" 25 80 10 \
        "0" "返回" \
        "1" "启用" \
        "2" "禁用" \
        3>&1 1>&2 2>&3)

    case $term_sd_watch_setting_dialog in
        1)
            term_sd_watch_value=$(dialog --erase-on-exit --title "Term-SD" --backtitle "命令执行监测设置界面" --ok-label "确认" --cancel-label "取消" --inputbox "请输入重试次数(仅输入数字,不允许输入负数和其他非数字的字符)" 25 80 "$(cat ./term-sd/term-sd-watch-retry.conf)" 3>&1 1>&2 2>&3)
            if [ -z "$(echo $term_sd_watch_value | awk '{gsub(/[0-9]/, "")}1')" ];then
                dialog --erase-on-exit --title "Term-SD" --backtitle "命令执行监测设置界面" --ok-label "确认" --msgbox "输入格式错误,重试次数只能为数字且不能为负数" 25 80
            else
                echo "$term_sd_watch_value" > ./term-sd/term-sd-watch-retry.conf
                term_sd_cmd_retry=$term_sd_watch_value
                dialog --erase-on-exit --title "Term-SD" --backtitle "命令执行监测设置界面" --ok-label "确认" --msgbox "启用成功" 25 80
            fi
            term_sd_watch_setting
            ;;
        2)
            rm -rf ./term-sd/term-sd-watch-retry.conf
            term_sd_cmd_retry=0
            dialog --erase-on-exit --title "Term-SD" --backtitle "命令执行监测设置界面" --ok-label "确认" --msgbox "禁用成功" 25 80
            term_sd_watch_setting
            ;;
    esac
}

# 安装模式设置
term_sd_install_mode_setting()
{
    local term_sd_install_mode_setting_dialog
    export term_sd_install_mode

    term_sd_install_mode_setting_dialog=$(dialog --erase-on-exit --title "Term-SD" --backtitle "安装模式设置界面" --ok-label "确认" --cancel-label "取消" --menu "该功能用于设置Term-SD安装AI软件的工作模式。当启用\"严格模式\"后,Term-SD在安转AI软件时出现执行失败的命令时将停止安装进程(Term-SD支持断点恢复,可恢复上次安装进程中断的位置),而\"宽容模式\"在安转AI软件时出现执行失败的命令时忽略执行失败的命令继续执行完成安装任务\n当前安装模式:$([ ! -f "./term-sd/term-sd-disable-strict-install-mode.lock" ] && echo "严格模式" || echo "宽容模式")\n请选择要设置的安装模式(默认启用严格模式)" 25 80 10 \
        "0" "返回" \
        "1" "严格模式" \
        "2" "宽容模式" \
        3>&1 1>&2 2>&3)

    case $term_sd_install_mode_setting_dialog in
        1)
            term_sd_install_mode=0
            rm -f ./term-sd/term-sd-disable-strict-install-mode.lock
            term_sd_install_mode_setting
            ;;
        2)
            term_sd_install_mode=1
            touch ./term-sd/term-sd-disable-strict-install-mode.lock
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

    aria2_multi_threaded_setting_dialog=$(dialog --erase-on-exit --title "Term-SD" --backtitle "aria2线程设置界面" --ok-label "确认" --cancel-label "取消" --menu "该功能用于增加Term-SD在使用aria2下载模型时的线程数,在一定程度上提高下载速度\n当前状态:$([ -f "./term-sd/aria2-thread.conf" ] && echo "启用(线程数:$(cat ./term-sd/aria2-thread.conf | awk '{sub("-x ","")}1'))" || echo "禁用")\n是否启用aria2多线程下载?" 25 80 10 \
        "0" "返回" \
        "1" "启用" \
        "2" "禁用" \
        3>&1 1>&2 2>&3)

    case $aria2_multi_threaded_setting_dialog in
        1)
            aria2_multi_threaded_value=$(dialog --erase-on-exit --title "Term-SD" --backtitle "aria2线程设置界面" --ok-label "确认" --cancel-label "取消" --inputbox "请输入线程数(仅输入数字(),不允许输入负数和其他非数字的字符)" 25 80 "$(cat ./term-sd/aria2-thread.conf | awk '{sub("-x ","")}1')" 3>&1 1>&2 2>&3)
            if [ -z "$(echo $aria2_multi_threaded_value | awk '{gsub(/[0-9]/, "")}1')" ] || [ $aria2_multi_threaded_value = 0 ] ;then
                dialog --erase-on-exit --title "Term-SD" --backtitle "aria2线程设置界面" --ok-label "确认" --msgbox "输入格式错误,线程数只能为数字且不能为负数" 25 80
            else
                if [ $@ -le 16 ];then
                    echo "-x $aria2_multi_threaded_value" > ./term-sd/aria2-thread.conf
                    aria2_multi_threaded="-x $aria2_multi_threaded_value"
                    dialog --erase-on-exit --title "Term-SD" --backtitle "aria2线程设置界面" --ok-label "确认" --msgbox "启用成功" 25 80
                else
                    echo "-x 16" > ./term-sd/aria2-thread.conf
                    aria2_multi_threaded="-x 16"
                    dialog --erase-on-exit --title "Term-SD" --backtitle "aria2线程设置界面" --ok-label "确认" --msgbox "启用成功" 25 80
                fi
            fi
            aria2_multi_threaded_setting
            ;;
        2)
            rm -rf ./term-sd/aria2-thread.conf
            aria2_multi_threaded=
            dialog --erase-on-exit --title "Term-SD" --backtitle "aria2线程设置界面" --ok-label "确认" --msgbox "禁用成功" 25 80
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

    term_sd_cache_redirect_setting_dialog=$(dialog --erase-on-exit --title "Term-SD" --backtitle "缓存重定向设置界面" --ok-label "确认" --cancel-label "取消" --menu "该功能将会把ai软件产生的缓存重定向至Term-SD中(便于清理)\n当前状态:$([ ! -f "./term-sd/disable-cache-path-redirect.lock" ] && echo "启用" || echo "禁用")\n是否启用缓存重定向?" 25 80 10 \
        "0" "返回" \
        "1" "启用" \
        "2" "禁用" \
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
            dialog --erase-on-exit --title "Term-SD" --backtitle "缓存重定向设置界面" --ok-label "确认" --msgbox "启用成功" 25 80
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
            dialog --erase-on-exit --title "Term-SD" --backtitle "缓存重定向设置界面" --ok-label "确认" --msgbox "禁用成功" 25 80
            term_sd_cache_redirect_setting
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
" 25 80
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
google: $(curl google.com > /dev/null 2> /dev/null && echo "成功" || echo "失败")\n
huggingface: $(curl huggingface.co > /dev/null 2> /dev/null && echo "成功" || echo "失败")\n
github: $(curl github.com > /dev/null 2> /dev/null && echo "成功" || echo "失败")\n
ghproxy: $(curl ghproxy.com > /dev/null 2> /dev/null && echo "成功" || echo "失败")\n
gitclone: $(curl gitclone.com > /dev/null 2> /dev/null && echo "成功" || echo "失败")\n
------------------------------------------------------------------\n
" 25 80
}

# 卸载选项
term_sd_uninstall_interface()
{
    local term_sd_uninstall_interface_dlalog

    term_sd_uninstall_interface_dlalog=$(dialog --erase-on-exit --title "Term-SD" --backtitle "Term-SD卸载界面" --ok-label "确认" --cancel-label "取消" --menu "警告:该操作将永久删除Term-SD目录中的所有文件,包括ai软件下载的部分模型文件(存在于Term-SD目录中的\"cache\"文件夹,如有必要,请备份该文件夹)\n是否卸载Term-SD?" 25 80 10 \
        "0" "取消" \
        "1" "确认" \
        3>&1 1>&2 2>&3)

    case $term_sd_uninstall_interface_dlalog in
        1)
            case $(term_sd_read) in
                y|yes|YES|Y)
                    term_sd_echo "开始卸载Term-SD"
                    rm -f ./term-sd
                    rm -rf ./term-sd.sh
                    user_shell=$(echo $SHELL | awk -F "/" '{print $NF}') # 读取用户所使用的shell
                    if [ $user_shell = bash ] || [ $user_shell = zsh ];then
                        sed -i '/# Term-SD/d' ~/."$user_shell"rc
                        sed -i '/termsd(){/d' ~/."$user_shell"rc
                        sed -i '/alias tsd/d' ~/."$user_shell"rc
                    fi
                    term_sd_echo "Term-SD卸载完成"
                    exit 1
                    ;;
                *)
                    term_sd_uninstall_interface
                    ;;
            esac
            ;;
    esac
}