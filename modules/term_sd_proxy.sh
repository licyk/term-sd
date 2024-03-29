#!/bin/bash

# 在安装过程中,只有huggingface/github的访问有问题,若全程保持代理,可能会导致安装速度下降,因为python软件包的下载没必要走代理,走代理后代理的速度可能比镜像源的速度慢
# 临时取消代理配置
term_sd_tmp_disable_proxy()
{
    if [ ! -z $http_proxy ];then
        case $term_sd_only_proxy in
            0)
                term_sd_echo "HuggingFace / Github 下载源独占代理已启用, 临时取消代理配置"
                term_sd_proxy=$https_proxy # 将代理配置储存到临时变量
                http_proxy= # 将代理配置删除
                https_proxy=
                ;;
        esac
    fi
}

#恢复原有代理配置
term_sd_tmp_enable_proxy()
{
    if [ ! -z $term_sd_proxy ];then
        case $term_sd_only_proxy in
            0)
                term_sd_echo "恢复代理配置"
                http_proxy=$term_sd_proxy #从临时变量恢复代理配置
                https_proxy=$term_sd_proxy
                ;;
        esac
    fi
}
