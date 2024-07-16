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
