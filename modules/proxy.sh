#!/bin/bash

#配置代理界面
function set_proxy_option()
{
    set_proxy_option_=$(dialog --clear --title "Term-SD" --backtitle "代理设置界面" --ok-label "确认" --cancel-label "取消" --menu "请选择设置代理协议\n当前代理设置:$([ -z $http_proxy ] && echo "无" || echo $http_proxy)" 22 70 12 \
        "1" "http" \
        "2" "socks" \
        "3" "socks5" \
        "4" "删除代理参数" \
        "5" "返回" \
        3>&1 1>&2 2>&3)

    if [ $? = 0 ];then
        if [ $set_proxy_option_ = 1 ];then
            proxy_config=$(dialog --clear --title "Term-SD" --backtitle "代理参数设置界面" --yes-label "确认" --no-label "取消" --inputbox "请输入代理地址\n格式:<ip>:<port>" 22 70 3>&1 1>&2 2>&3)
            if [ $? = 0 ];then
                export http_proxy="http://$proxy_config"
                export https_proxy="http://$proxy_config"
                echo "http://$proxy_config" > proxy.conf
                mv -f ./proxy.conf ./term-sd/
            fi
            set_proxy_option
        elif [ $set_proxy_option_ = 2 ];then
            proxy_config=$(dialog --clear --title "Term-SD" --backtitle "代理参数设置界面" --yes-label "确认" --no-label "取消" --inputbox "请输入代理地址\n格式:<ip>:<port>" 22 70 3>&1 1>&2 2>&3)
            if [ $? = 0 ];then
                export http_proxy="socks://$proxy_config"
                export https_proxy="socks://$proxy_config"
                echo "socks://$proxy_config" > proxy.conf
                mv -f ./proxy.conf ./term-sd/
            fi
            set_proxy_option
        elif [ $set_proxy_option_ = 3 ];then
            proxy_config=$(dialog --clear --title "Term-SD" --backtitle "代理参数设置界面" --yes-label "确认" --no-label "取消" --inputbox "请输入代理地址\n格式:<ip>:<port>" 22 70 3>&1 1>&2 2>&3)
            if [ $? = 0 ];then
                export http_proxy="socks5://$proxy_config"
                export https_proxy="socks5://$proxy_config"
                echo "socks5://$proxy_config" > proxy.conf
                mv -f ./proxy.conf ./term-sd/
            fi
            set_proxy_option
        elif [ $set_proxy_option_ = 4 ];then
            rm -rf ./term-sd/proxy.conf
            export http_proxy=""
            export https_proxy=""
            set_proxy_option
        elif [ $set_proxy_option_ = 5 ];then
            mainmenu
        fi
    else
        mainmenu
    fi
}

#在安装过程中,只有huggingface的访问有问题,若全程保持代理,可能会导致安装速度下降,因为python软件包的下载没必要走代理
#临时取消代理配置
function tmp_disable_proxy()
{
    if [ $only_hugggingface_proxy = 0 ];then
        echo "临时取消代理配置"
        proxy_address_1=$http_proxy #将代理配置储存到临时变量
        proxy_address_2=$https_proxy
        http_proxy="" #将代理配置删除
        https_proxy=""
    fi
}

#恢复原有代理配置
function tmp_enable_proxy()
{
    if [ $only_hugggingface_proxy = 0 ];then
        echo "恢复代理配置"
        http_proxy=$proxy_address_1 #从临时变量恢复代理配置
        https_proxy=$proxy_address_2
        proxy_address_1=""
        proxy_address_2=""
    fi
}