#!/bin/bash

# pip镜像源选项
pip_mirrors_setting()
{
    local pip_mirrors_setting_dialog

    term_sd_echo "获取pip全局配置"
    pip_mirrors_setting_dialog=$(
        dialog --erase-on-exit --notags --title "Term-SD" --backtitle "pip镜像源选项" --ok-label "确认" --cancel-label "取消" --menu "请选择设置的pip镜像源\n当前pip全局配置:\n$(term_sd_pip config list | awk '{print$0}')" 25 80 10 \
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
            term_sd_echo "镜像源配置完成"
            pip_mirrors_setting
            ;;
        2)
            term_sd_echo "设置pip镜像源为国内镜像源"
            term_sd_pip config set global.index-url " https://mirrors.bfsu.edu.cn/pypi/web/simple"
            term_sd_pip config set global.extra-index-url "https://mirrors.hit.edu.cn/pypi/web/simple https://pypi.tuna.tsinghua.edu.cn/simple https://mirror.nju.edu.cn/pypi/web/simple"
            term_sd_pip config set global.find-links "https://mirrors.aliyun.com/pytorch-wheels/torch_stable.html https://mirror.sjtu.edu.cn/pytorch-wheels/torch_stable.html"
            term_sd_echo "镜像源配置完成"
            pip_mirrors_setting
            ;;
        3)
            term_sd_echo "删除镜像源配置"
            term_sd_pip config unset global.extra-index-url
            term_sd_pip config unset global.index-url
            term_sd_pip config unset global.find-links
            term_sd_echo "删除镜像源配置完成"
            pip_mirrors_setting
            ;;
    esac
}

# pip缓存清理功能
pip_cache_clean()
{
    term_sd_echo "统计pip缓存信息"
    if (dialog --erase-on-exit --title "Term-SD" --backtitle "pip缓存清理选项" --yes-label "是" --no-label "否" --yesno "pip缓存信息:\npip缓存路径:$(term_sd_pip cache dir)\n包索引页面缓存大小:$(term_sd_pip cache info | grep "Package index page cache size" | awk -F ':'  '{print $2 $3 $4}')\n本地构建的wheel包大小:$(term_sd_pip cache info | grep "Locally built wheels size" | awk -F ':'  '{print $2 $3 $4}')\n是否删除pip缓存?" 25 80);then
        term_sd_pip cache purge
        term_sd_echo "清理pip缓存完成"
    fi
}
