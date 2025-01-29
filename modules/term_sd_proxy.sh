#!/bin/bash

# 在安装过程中, 只有 HuggingFace / Github 的访问有问题
#若全程保持代理, 可能会导致安装速度下降, 因为 Python 软件包的下载没必要走代理, 走代理后代理的速度可能比镜像源的速度慢
# 临时取消代理配置
term_sd_tmp_disable_proxy() {
    if [[ ! -z "${HTTP_PROXY}" ]] && is_use_only_proxy; then
        term_sd_echo "HuggingFace / Github 下载源独占代理已启用, 临时取消代理配置"
        unset HTTP_PROXY # 将代理配置删除
        unset HTTPS_PROXY
    fi
}

# 恢复原有代理配置
# 使用 TERM_SD_PROXY 全局变量读取代理地址
# 并重新设置 HTTP_PROXY, HTTPS_PROXY 环境变量
term_sd_tmp_enable_proxy() {
    if [[ ! -z $TERM_SD_PROXY ]] && is_use_only_proxy; then
        term_sd_echo "恢复代理配置"
        export HTTP_PROXY=$TERM_SD_PROXY # 从临时变量恢复代理配置
        export HTTPS_PROXY=$TERM_SD_PROXY
    fi
}

# 获取系统代理地址并返回
get_proxy_config() {
    local gsettings_proxy_status
    local gsettings_http_host
    local gsettings_http_port
    local gsettings_http_proxy_config
    local gsettings_socks_host
    local gsettings_socks_port
    local gsettings_socks_proxy_config
    local kde_proxy_status
    local kde_http_proxy_config
    local kde_socks_proxy_config
    local windows_proxy_config
    local macos_proxy_config

    if [[ "$(get_system_platform)" == "win32" ]]; then
        windows_proxy_config=$(powershell -ExecutionPolicy Bypass \
            -File "${START_PATH}/term-sd/modules/get_windows_proxy_config.ps1" \
        )
        echo "${windows_proxy_config}"
    elif [[ "$(get_system_platform)" == "linux" ]]; then
        # 获取代理设置状态
        gsettings_proxy_status=$(gsettings get org.gnome.system.proxy mode | sed "s/'//g") # Gnome
        kde_proxy_status=$(cat ~/.config/kioslaverc 2> /dev/null | grep "ProxyType" | awk -F 'ProxyType=' '{print $NF}') # KDE

        # 判断代理设置
        if [[ "${gsettings_proxy_status}" == "manual" ]]; then
            gsettings_http_host=$(gsettings get org.gnome.system.proxy.http host 2> /dev/null | sed "s/'//g")
            gsettings_http_port=$(gsettings get org.gnome.system.proxy.http port 2> /dev/null)
            gsettings_socks_host=$(gsettings get org.gnome.system.proxy.socks host 2> /dev/null | sed "s/'//g")
            gsettings_socks_port=$(gsettings get org.gnome.system.proxy.socks port 2> /dev/null)
            gsettings_http_proxy_config="http://${gsettings_http_host}:${gsettings_http_port}"
            gsettings_socks_proxy_config="socks://${gsettings_socks_host}:${gsettings_socks_port}"

            if [[ ! -z "${gsettings_http_host}" ]] && [[ ! -z "${gsettings_http_port}" ]]; then
                echo "${gsettings_http_proxy_config}"
            elif [[ ! -z "${gsettings_socks_host}" ]] && [[ ! -z "${gsettings_socks_port}" ]]; then
                echo "${gsettings_socks_proxy_config}"
            fi
        elif [[ "${kde_proxy_status}" == 1 ]]; then
            kde_http_proxy_config=$(cat ~/.config/kioslaverc 2> /dev/null |\
                grep "httpProxy=" |\
                awk -F 'httpProxy=' '{gsub(/ /, ":"); print $NF}' \
            )
            kde_socks_proxy_config=$(cat ~/.config/kioslaverc 2> /dev/null |\
                grep "socksProxy=" |\
                awk -F 'socksProxy=' '{gsub(/ /, ":"); print $NF}' \
            )

            if [[ ! -z "${kde_http_proxy_config}" ]]; then
                echo "${kde_http_proxy_config}"
            elif [[ ! -z "${kde_socks_proxy_config}" ]]; then
                echo "${kde_socks_proxy_config}"
            fi
        fi
    elif [[ "$(get_system_platform)" == "darwin" ]]; then
        macos_proxy_config=$(scutil --proxy 2> /dev/null | awk ' \
            /HTTPEnable/ { http_enabled = $3; } \
            /HTTPProxy/ { http_server = $3; } \
            /HTTPPort/ { http_port = $3; } \
            /SOCKSEnable/ { socks_enabled = $3; } \
            /SOCKSProxy/ { socks_server = $3; } \
            /SOCKSPort/ { socks_port = $3; } \
            END { \
                if (http_enabled == "1") { \
                    print "http://" http_server ":" http_port; \
                } else if (socks_enabled == "1") { \
                    print "socks://" socks_server ":" socks_port; \
                } \
            }' \
        )
        echo "${macos_proxy_config}"
    fi
}

# 动态设置代理
# 自动检测系统代理配置并设置, 当配置不可用时则自动清除
# 当 <Start Path>/term-sd/config/enable-dynamic-proxy.lock 不存在时则不执行
# 检测到可用的系统代理后将设置 HTTP_PROXY, HTTPS_PROXY 环境变量, 使用 TERM_SD_PROXY 全局变量临时存储代理地址
# 代理地址保存在 <Start Path>/term-sd/config/proxy.conf
dynamic_configure_proxy() {
    local proxy_config

    if [[ ! -f "${START_PATH}/term-sd/config/enable-dynamic-proxy.lock" ]]; then
        return
    fi

    proxy_config=$(get_proxy_config)

    if term_sd_is_debug; then
        echo "proxy_config: ${proxy_config}"
    fi

    if [[ ! -z "${proxy_config}" ]]; then
        term_sd_echo "检测到本地系统代理配置, 设置代理中"
        export HTTP_PROXY=$proxy_config
        export HTTPS_PROXY=$proxy_config
        TERM_SD_PROXY=$HTTPS_PROXY
        echo "${proxy_config}" > "${START_PATH}/term-sd/config/proxy.conf"
        term_sd_echo "测试代理连通性中"
        curl -s --connect-timeout 1 "${HTTP_PROXY}"
        if [[ "$?" == 0 ]]; then
            term_sd_echo "代理配置可用"
        else
            term_sd_echo "代理连接异常, 清除代理配置中"
            unset HTTP_PROXY
            unset HTTPS_PROXY
            unset TERM_SD_PROXY
            rm -f "${START_PATH}/term-sd/config/proxy.conf"
            term_sd_echo "清除代理配置完成"
        fi
    else
        term_sd_echo "检测到系统代理已禁用, 清除代理中"
        unset HTTP_PROXY
        unset HTTPS_PROXY
        unset TERM_SD_PROXY
        rm -f "${START_PATH}/term-sd/config/proxy.conf"
        term_sd_echo "清除代理配置完成"
    fi
}

# 代理设置
# 使用 HTTP_PROXY, HTTP_PROXY 环境变量设置代理
# 将代理地址保存到 TERM_SD_PROXY 全局变量作为恢复代理时使用的参数
# <Start Path>/term-sd/config/proxy.conf 配置文件用于保存代理地址
term_sd_proxy_setting() {
    local term_sd_proxy_config
    local dialog_arg
    local is_proxy_available
    local proxy_info
    local dynamic_proxy_info

    while true; do
        if [[ ! -z "${HTTP_PROXY}" ]]; then
            term_sd_echo "测试代理地址连通性中"
            curl -s --connect-timeout 1 "${HTTP_PROXY}"
            if [[ "$?" == 0 ]]; then
                is_proxy_available="(可用 ✓)"
            else
                is_proxy_available="(连接异常 ×)"
            fi
        fi

        if [[ ! -z "${HTTP_PROXY}" ]]; then
            proxy_info="${HTTP_PROXY} ${is_proxy_available}"
        else
            proxy_info="未设置"
        fi

        if [[ -f "${START_PATH}/term-sd/config/enable-dynamic-proxy.lock" ]]; then
            dynamic_proxy_info="启用"
        else
            dynamic_proxy_info="禁用"
        fi

        dialog_arg=$(dialog --erase-on-exit --notags \
            --title "Term-SD" \
            --backtitle "代理设置界面" \
            --ok-label "确认" --cancel-label "取消" \
            --menu "该功能用于设置代理服务器, 解决 AI 软件和 Term-SD 因网络环境导致无法连接上服务器, 而出现报错的问题\n注意: 动态设置代理可自动检测系统代理并设置, 并且将覆盖手动设置的代理地址, 如需手动设置代理, 需将动态设置代理禁用\n当前代理设置: ${proxy_info}\n当前动态代理设置: ${dynamic_proxy_info}\n请选择要设置的代理协议" \
            $(get_dialog_size_menu) \
            "0" "> 返回" \
            "1" "> 动态设置代理" \
            "2" "> 设置 Http 协议代理" \
            "3" "> 设置 Socks 协议代理" \
            "4" "> 设置 Socks5 协议代理" \
            "5" "> 设置自定义协议代理" \
            "6" "> 删除代理参数" \
            3>&1 1>&2 2>&3)

        case "${dialog_arg}" in
            1)
                dynamic_configure_proxy_setting
                ;;
            2)
                term_sd_proxy_config=$(dialog --erase-on-exit \
                    --title "Term-SD" \
                    --backtitle "代理参数设置界面" \
                    --ok-label "确认" --cancel-label "取消" \
                    --inputbox "请输入代理地址\n格式: <IP>:<端口>" \
                    $(get_dialog_size) \
                    "$(echo ${HTTP_PROXY} | awk -F '://' '{print $NF}')" \
                    3>&1 1>&2 2>&3)

                if [[ "$?" == 0 ]] && [[ ! -z "${term_sd_proxy_config}" ]]; then
                    term_sd_proxy_config=$(echo ${term_sd_proxy_config} | awk '{gsub(/[：]/, ":") ; gsub(/[。]/, ".")}1') # 防止用户输入中文冒号,句号后导致错误
                    export HTTP_PROXY="http://${term_sd_proxy_config}"
                    export HTTPS_PROXY="http://${term_sd_proxy_config}"
                    TERM_SD_PROXY=$HTTPS_PROXY
                    echo "http://${term_sd_proxy_config}" > "${START_PATH}/term-sd/config/proxy.conf"

                    dialog --erase-on-exit \
                        --title "Term-SD" \
                        --backtitle "代理参数设置界面" \
                        --ok-label "确认" \
                        --msgbox "代理地址: ${HTTP_PROXY}\n代理协议: $(echo ${HTTP_PROXY} | awk -F '://' '{print$NR}')\n设置代理完成" \
                        $(get_dialog_size)
                fi
                ;;
            3)
                term_sd_proxy_config=$(dialog --erase-on-exit \
                    --title "Term-SD" \
                    --backtitle "代理参数设置界面" \
                    --ok-label "确认" --cancel-label "取消" \
                    --inputbox "请输入代理地址\n格式: <IP>:<端口>" \
                    $(get_dialog_size) "$(echo ${HTTP_PROXY} | awk -F'://' '{print $NF}')" \
                    3>&1 1>&2 2>&3)

                if [[ "$?" == 0 ]] && [[ ! -z "$term_sd_proxy_config" ]]; then
                    term_sd_proxy_config=$(echo ${term_sd_proxy_config} | awk '{gsub(/[：]/, ":") ; gsub(/[。]/, ".")}1') # 防止用户输入中文冒号,句号后导致错误
                    export HTTP_PROXY="socks://${term_sd_proxy_config}"
                    export HTTPS_PROXY="socks://${term_sd_proxy_config}"
                    TERM_SD_PROXY=$HTTPS_PROXY
                    echo "socks://${term_sd_proxy_config}" > "${START_PATH}/term-sd/config/proxy.conf"

                    dialog --erase-on-exit \
                        --title "Term-SD" \
                        --backtitle "代理参数设置界面" \
                        --ok-label "确认" \
                        --msgbox "代理地址: ${HTTP_PROXY}\n代理协议: $(echo ${HTTP_PROXY} | awk -F '://' '{print$NR}')\n设置代理完成" \
                        $(get_dialog_size)
                fi
                ;;
            4)
                term_sd_proxy_config=$(dialog --erase-on-exit \
                    --title "Term-SD" \
                    --backtitle "代理参数设置界面" \
                    --ok-label "确认" --cancel-label "取消" \
                    --inputbox "请输入代理地址\n格式: <IP>:<端口>" \
                    $(get_dialog_size) "$(echo ${HTTP_PROXY} | awk -F'://' '{print $NF}')" \
                    3>&1 1>&2 2>&3)

                if [[ "$?" == 0 ]] && [[ ! -z "${term_sd_proxy_config}" ]]; then
                    term_sd_proxy_config=$(echo ${term_sd_proxy_config} | awk '{gsub(/[：]/, ":") ; gsub(/[。]/, ".")}1') # 防止用户输入中文冒号, 句号后导致错误
                    export HTTP_PROXY="socks5://${term_sd_proxy_config}"
                    export HTTPS_PROXY="socks5://${term_sd_proxy_config}"
                    TERM_SD_PROXY=$HTTPS_PROXY
                    echo "socks5://${term_sd_proxy_config}" > "${START_PATH}/term-sd/config/proxy.conf"

                    dialog --erase-on-exit \
                        --title "Term-SD" \
                        --backtitle "代理参数设置界面" \
                        --ok-label "确认" \
                        --msgbox "代理地址: ${HTTP_PROXY}\n代理协议: $(echo ${HTTP_PROXY} | awk -F '://' '{print $NR}')\n设置代理完成" \
                        $(get_dialog_size)
                fi
                ;;
            5)
                term_sd_proxy_config=$(dialog --erase-on-exit \
                    --title "Term-SD" \
                    --backtitle "代理参数设置界面" \
                    --ok-label "确认" --cancel-label "取消" \
                    --inputbox "请输入代理地址\n格式: <代理协议>://<IP>:<端口>" \
                    $(get_dialog_size) \
                    "${HTTP_PROXY}" \
                    3>&1 1>&2 2>&3)

                if [[ "$?" == 0 ]] && [[ ! -z "${term_sd_proxy_config}" ]]; then
                    term_sd_proxy_config=$(echo ${term_sd_proxy_config} | awk '{gsub(/[：]/, ":") ; gsub(/[。]/, ".")}1') # 防止用户输入中文冒号, 句号后导致错误
                    export HTTP_PROXY="${term_sd_proxy_config}"
                    export HTTPS_PROXY="${term_sd_proxy_config}"
                    TERM_SD_PROXY=$HTTPS_PROXY
                    echo "${term_sd_proxy_config}" > "${START_PATH}/term-sd/config/proxy.conf"

                    dialog --erase-on-exit \
                        --title "Term-SD" \
                        --backtitle "代理参数设置界面" \
                        --ok-label "确认" \
                        --msgbox "代理地址: ${HTTP_PROXY}\n代理协议: $(echo ${HTTP_PROXY} | awk -F '://' '{print $NR}')\n设置代理完成" \
                        $(get_dialog_size)
                fi
                ;;
            6)
                if (dialog --erase-on-exit \
                    --title "Term-SD" \
                    --backtitle "代理参数删除界面" \
                    --yes-label "是" --no-label "否" \
                    --yesno "是否删除代理配置 ?" \
                    $(get_dialog_size)); then

                    unset HTTP_PROXY
                    unset HTTPS_PROXY
                    unset TERM_SD_PROXY
                    rm -f "${START_PATH}/term-sd/config/proxy.conf"

                    dialog --erase-on-exit \
                        --title "Term-SD" \
                        --backtitle "代理参数设置界面" \
                        --ok-label "确认" \
                        --msgbox "清除设置代理完成" \
                        $(get_dialog_size)
                fi
                ;;
            *)
                break
                ;;
        esac
    done
}

# 动态代理设置
dynamic_configure_proxy_setting() {
    local dialog_arg
    local dynamic_proxy_info
    local dynamic_proxy_msg

    while true; do
        if [[ -f "${START_PATH}/term-sd/config/enable-dynamic-proxy.lock" ]]; then
            dynamic_proxy_info="启用"
        else
            dynamic_proxy_info="禁用"
        fi

        dialog_arg=$(dialog --erase-on-exit --notags \
            --title "Term-SD" \
            --backtitle "动态代理设置界面" \
            --ok-label "确认" \
            --cancel-label "取消" \
            --menu "该功能将检测系统代理并自动应用, 当系统代理禁用后将自动取消代理\n注意: 启用后自动检测到的代理配置将覆盖原先的代理配置, 如需手动设置代理, 需禁用动态代理设置\n当前状态: ${dynamic_proxy_info}\n是否启用动态代理 ?" \
            $(get_dialog_size_menu) \
            "0" "> 返回" \
            "1" "> 启用" \
            "2" "> 禁用" \
            3>&1 1>&2 2>&3)

        case "${dialog_arg}" in
            1)
                touch -f "${START_PATH}/term-sd/config/enable-dynamic-proxy.lock"
                dynamic_configure_proxy # 检测系统代理并设置

                if [[ -z "${HTTP_PROXY}" ]]; then
                    dynamic_proxy_msg="当前未检测到系统代理, 已自动清除代理配置"
                else
                    dynamic_proxy_msg="检测到系统代理并可用, 已设置代理\n代理地址: ${HTTP_PROXY}"
                fi

                dialog --erase-on-exit \
                    --title "Term-SD" \
                    --backtitle "动态代理设置界面" \
                    --ok-label "确认" \
                    --msgbox "启用成功\n${dynamic_proxy_msg}" \
                    $(get_dialog_size)
                ;;
            2)
                rm -f "${START_PATH}/term-sd/config/enable-dynamic-proxy.lock"

                dialog --erase-on-exit \
                    --title "Term-SD" \
                    --backtitle "动态代理设置界面" \
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
