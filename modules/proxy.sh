#!/bin/bash

#配置代理界面
function set_proxy_option()
{
    set_proxy_option_dialog=$(dialog --clear --title "Term-SD" --backtitle "代理设置界面" --ok-label "确认" --cancel-label "取消" --menu "请选择设置代理协议\n当前代理设置:$([ -z $http_proxy ] && echo "无" || echo $http_proxy)" 25 70 10 \
        "1" "http" \
        "2" "socks" \
        "3" "socks5" \
        "4" "删除代理参数" \
        "5" "网络测试" \
        "6" "返回" \
        3>&1 1>&2 2>&3)

    if [ $? = 0 ];then
        case $set_proxy_option_dialog in
            1)
                proxy_config=$(dialog --clear --title "Term-SD" --backtitle "代理参数设置界面" --ok-label "确认" --cancel-label "取消" --inputbox "请输入代理地址\n格式:<ip>:<port>" 25 70 "$(echo $http_proxy | awk -F'://' '{print $NF}')" 3>&1 1>&2 2>&3)
                #proxy_config=$(echo $proxy_config | awk '{sub("：",":")}1')
                proxy_config=$(echo $proxy_config | awk '{gsub(/[：]/, ":")}1' | awk '{gsub(/[。]/, ".")}1') #防止用户输入中文冒号,句号后导致错误
                if [ ! -z $proxy_config ];then
                    export http_proxy="http://$proxy_config"
                    export https_proxy="http://$proxy_config"
                    echo "http://$proxy_config" > ./term-sd/proxy.conf
                fi
                set_proxy_option
                ;;
            2)
                proxy_config=$(dialog --clear --title "Term-SD" --backtitle "代理参数设置界面" --ok-label "确认" --cancel-label "取消" --inputbox "请输入代理地址\n格式:<ip>:<port>" 25 70 "$(echo $http_proxy | awk -F'://' '{print $NF}')" 3>&1 1>&2 2>&3)
                proxy_config=$(echo $proxy_config | awk '{gsub(/[：]/, ":")}1' | awk '{gsub(/[。]/, ".")}1') #防止用户输入中文冒号,句号后导致错误
                if [ ! -z $proxy_config ];then
                    export http_proxy="socks://$proxy_config"
                    export https_proxy="socks://$proxy_config"
                    echo "socks://$proxy_config" > ./term-sd/proxy.conf
                fi
                set_proxy_option
                ;;
            3)
                proxy_config=$(dialog --clear --title "Term-SD" --backtitle "代理参数设置界面" --ok-label "确认" --cancel-label "取消" --inputbox "请输入代理地址\n格式:<ip>:<port>" 25 70 "$(echo $http_proxy | awk -F'://' '{print $NF}')" 3>&1 1>&2 2>&3)
                proxy_config=$(echo $proxy_config | awk '{gsub(/[：]/, ":")}1' | awk '{gsub(/[。]/, ".")}1') #防止用户输入中文冒号,句号后导致错误
                if [ ! -z $proxy_config ];then
                    export http_proxy="socks5://$proxy_config"
                    export https_proxy="socks5://$proxy_config"
                    echo "socks5://$proxy_config" > ./term-sd/proxy.conf
                fi
                set_proxy_option
                ;;
            4)
                if (dialog --clear --title "Term-SD" --backtitle "代理参数删除界面" --yes-label "是" --no-label "否" --yesno "是否删除代理配置?" 25 70) then
                    rm -rf ./term-sd/proxy.conf
                    export http_proxy=""
                    export https_proxy=""
                fi
                set_proxy_option
                ;;
            5)
                term_sd_network_test
                set_proxy_option
                ;;
        esac
    fi
}

function term_sd_network_test()
{
    term_sd_notice "测试网络中"
    dialog --clear --title "Term-SD" --backtitle "Term-SD网络测试" --ok-label "确认" --msgbox "网络测试结果:\n
------------------------------------------------------------------\n
网络信息:\n
$(curl -s ipinfo.io)\n
------------------------------------------------------------------\n
网站访问:\n
google: $(curl google.com > /dev/null 2> /dev/null && echo "成功" || echo "失败")\n
huggingface: $(curl huggingface.co > /dev/null 2> /dev/null && echo "成功" || echo "失败")\n
github: $(curl github.com > /dev/null 2> /dev/null && echo "成功" || echo "失败")\n
ghproxy: $(curl ghproxy.com > /dev/null 2> /dev/null && echo "成功" || echo "失败")\n
------------------------------------------------------------------\n
" 25 70
}

#在安装过程中,只有huggingface的访问有问题,若全程保持代理,可能会导致安装速度下降,因为python软件包的下载没必要走代理,走代理后代理的速度可能比镜像源的速度慢
#临时取消代理配置
function tmp_disable_proxy()
{
    if [ ! -z $http_proxy ] && [ $only_hugggingface_proxy = 0 ];then
        term_sd_notice "huggingface独占代理已启用,临时取消代理配置"
        proxy_address_1=$http_proxy #将代理配置储存到临时变量
        proxy_address_2=$https_proxy
        http_proxy="" #将代理配置删除
        https_proxy=""
    fi
}

#恢复原有代理配置
function tmp_enable_proxy()
{
    if [ ! -z $proxy_address_1 ] && [ $only_hugggingface_proxy = 0 ];then
        term_sd_notice "恢复代理配置"
        http_proxy=$proxy_address_1 #从临时变量恢复代理配置
        https_proxy=$proxy_address_2
        proxy_address_1=""
        proxy_address_2=""
    fi
}
