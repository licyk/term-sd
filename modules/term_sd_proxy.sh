#!/bin/bash

# 代理设置
term_sd_proxy_setting()
{
    local term_sd_proxy_config
    local term_sd_proxy_setting_dialog
    export http_proxy
    export https_proxy

    term_sd_proxy_setting_dialog=$(
        dialog --erase-on-exit --notags --title "Term-SD" --backtitle "代理设置界面" --ok-label "确认" --cancel-label "取消" --menu "请选择设置代理协议\n当前代理设置:$([ -z $http_proxy ] && echo "无" || echo $http_proxy)" 25 80 10 \
        "0" "> 返回" \
        "1" "> http协议" \
        "2" "> socks协议" \
        "3" "> socks5协议" \
        "4" "> 删除代理参数" \
        3>&1 1>&2 2>&3)

    case $term_sd_proxy_setting_dialog in
        1)
            term_sd_proxy_config=$(dialog --erase-on-exit --title "Term-SD" --backtitle "代理参数设置界面" --ok-label "确认" --cancel-label "取消" --inputbox "请输入代理地址\n格式:<ip>:<port>" 25 80 "$(echo $http_proxy | awk -F'://' '{print $NF}')" 3>&1 1>&2 2>&3)
            term_sd_proxy_config=$(echo $term_sd_proxy_config | awk '{gsub(/[：]/, ":")}1' | awk '{gsub(/[。]/, ".")}1') # 防止用户输入中文冒号,句号后导致错误
            if [ $? = 0 ];then
                export http_proxy="http://$term_sd_proxy_config"
                export https_proxy="http://$term_sd_proxy_config"
                echo "http://$term_sd_proxy_config" > ./term-sd/proxy.conf
            fi
            term_sd_proxy_setting
            ;;
        2)
            term_sd_proxy_config=$(dialog --erase-on-exit --title "Term-SD" --backtitle "代理参数设置界面" --ok-label "确认" --cancel-label "取消" --inputbox "请输入代理地址\n格式:<ip>:<port>" 25 80 "$(echo $http_proxy | awk -F'://' '{print $NF}')" 3>&1 1>&2 2>&3)
            term_sd_proxy_config=$(echo $term_sd_proxy_config | awk '{gsub(/[：]/, ":")}1' | awk '{gsub(/[。]/, ".")}1') # 防止用户输入中文冒号,句号后导致错误
            if [ $? = 0 ];then
                export http_proxy="socks://$term_sd_proxy_config"
                export https_proxy="socks://$term_sd_proxy_config"
                echo "socks://$term_sd_proxy_config" > ./term-sd/proxy.conf
            fi
            term_sd_proxy_setting
            ;;
        3)
            term_sd_proxy_config=$(dialog --erase-on-exit --title "Term-SD" --backtitle "代理参数设置界面" --ok-label "确认" --cancel-label "取消" --inputbox "请输入代理地址\n格式:<ip>:<port>" 25 80 "$(echo $http_proxy | awk -F'://' '{print $NF}')" 3>&1 1>&2 2>&3)
            term_sd_proxy_config=$(echo $term_sd_proxy_config | awk '{gsub(/[：]/, ":")}1' | awk '{gsub(/[。]/, ".")}1') # 防止用户输入中文冒号,句号后导致错误
            if [ $? = 0 ];then
                export http_proxy="socks5://$term_sd_proxy_config"
                export https_proxy="socks5://$term_sd_proxy_config"
                echo "socks5://$term_sd_proxy_config" > ./term-sd/proxy.conf
            fi
            term_sd_proxy_setting
            ;;
        4)
            if (dialog --erase-on-exit --title "Term-SD" --backtitle "代理参数删除界面" --yes-label "是" --no-label "否" --yesno "是否删除代理配置?" 25 80) then
                rm -rf ./term-sd/proxy.conf
                export http_proxy=
                export https_proxy=
            fi
            term_sd_proxy_setting
            ;;
    esac
}

# 在安装过程中,只有huggingface的访问有问题,若全程保持代理,可能会导致安装速度下降,因为python软件包的下载没必要走代理,走代理后代理的速度可能比镜像源的速度慢
# 临时取消代理配置
term_sd_tmp_disable_proxy()
{
    if [ ! -z $http_proxy ] && [ $only_hugggingface_proxy = 0 ];then
        term_sd_echo "huggingface下载源独占代理已启用,临时取消代理配置"
        proxy_address_1=$http_proxy # 将代理配置储存到临时变量
        proxy_address_2=$https_proxy
        http_proxy= # 将代理配置删除
        https_proxy=
    fi
}

#恢复原有代理配置
term_sd_tmp_enable_proxy()
{
    if [ ! -z $proxy_address_1 ] && [ $only_hugggingface_proxy = 0 ];then
        term_sd_echo "恢复代理配置"
        http_proxy=$proxy_address_1 #从临时变量恢复代理配置
        https_proxy=$proxy_address_2
    fi
}
