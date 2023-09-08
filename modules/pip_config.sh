#!/bin/bash

#pip镜像源选项
function set_proxy_option()
{
    echo "获取pip全局配置"
    if (dialog --clear --title "Term-SD" --backtitle "pip镜像源选项" --yes-label "是" --no-label "否" --yesno "pip全局配置:\n$(pip config list)\n是否启用pip镜像源?" 20 60) then
        #pip config set global.index-url "https://mirror.sjtu.edu.cn/pypi/web/simple"
        pip config set global.index-url "https://mirrors.bfsu.edu.cn/pypi/web/simple"
        #pip config set global.extra-index-url "https://mirror.sjtu.edu.cn/pytorch-wheels"
        #pip config set global.extra-index-url "https://mirrors.aliyun.com/pytorch-wheels"
        pip config set global.find-links "https://mirrors.aliyun.com/pytorch-wheels/torch_stable.html"
    else
        pip config unset global.index-url
        pip config unset global.find-links
    fi
    mainmenu
}

#pip缓存清理功能
function pip_cache_clean()
{
    echo "统计pip缓存信息中"
    if (dialog --clear --title "Term-SD" --backtitle "pip缓存清理选项" --yes-label "是" --no-label "否" --yesno "pip缓存信息:\npip缓存路径:$(pip cache dir)\n包索引页面缓存大小:$(pip cache info |awk NR==2 | awk -F ':'  '{print $2 $3 $4}')\n本地构建的wheel包大小:$(pip cache info |awk NR==5 | awk -F ':'  '{print $2 $3 $4}')\n是否删除pip缓存?" 20 60);then
        pip cache purge
    fi
    mainmenu
}