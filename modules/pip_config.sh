#!/bin/bash

#pip镜像源选项
function set_pip_mirrors_option()
{
    term_sd_notice "获取pip全局配置"
    set_pip_mirrors_option_dialog=$(dialog --clear --title "Term-SD" --backtitle "pip镜像源选项" --ok-label "确认" --cancel-label "取消" --menu "请选择设置的pip镜像源\n当前pip全局配置:\n$(pip_cmd config list | sed 's/.\{70\}/&\n/')" 25 70 10 \
        "1" "官方源" \
        "2" "国内镜像源" \
        "3" "删除镜像源配置" \
        "4" "返回" \
        3>&1 1>&2 2>&3)

    if [ $? = 0 ];then
        if [ $set_pip_mirrors_option_dialog = 1 ];then
            #pip config unset global.index-url
            #pip config unset global.find-links
            pip_cmd config set global.index-url "https://pypi.python.org/simple"
            pip_cmd config unset global.extra-index-url
            pip_cmd config set global.find-links "https://download.pytorch.org/whl/torch_stable.html"
            set_pip_mirrors_option
        elif [ $set_pip_mirrors_option_dialog = 2 ];then
            #pip config set global.index-url "https://mirror.sjtu.edu.cn/pypi/web/simple"
            pip_cmd config set global.index-url " https://mirrors.bfsu.edu.cn/pypi/web/simple"
            #pip config set global.extra-index-url "https://mirror.sjtu.edu.cn/pytorch-wheels"
            #pip config set global.extra-index-url "https://mirrors.aliyun.com/pytorch-wheels"
            pip_cmd config set global.extra-index-url "https://mirrors.hit.edu.cn/pypi/web/simple https://pypi.tuna.tsinghua.edu.cn/simple https://mirrors.pku.edu.cn/pypi/web/simple"
            pip_cmd config set global.find-links "https://mirrors.aliyun.com/pytorch-wheels/torch_stable.html https://mirror.sjtu.edu.cn/pytorch-wheels/torch_stable.html"
            set_pip_mirrors_option
        elif [ $set_pip_mirrors_option_dialog = 3 ];then
            pip_cmd config unset global.extra-index-url
            pip_cmd config unset global.index-url
            pip_cmd config unset global.find-links
            set_pip_mirrors_option
        fi
    fi
}

#pip缓存清理功能
function pip_cache_clean()
{
    term_sd_notice "统计pip缓存信息中"
    if (dialog --clear --title "Term-SD" --backtitle "pip缓存清理选项" --yes-label "是" --no-label "否" --yesno "pip缓存信息:\npip缓存路径:$(pip_cmd cache dir)\n包索引页面缓存大小:$(pip_cmd cache info |awk NR==2 | awk -F ':'  '{print $2 $3 $4}')\n本地构建的wheel包大小:$(pip_cmd cache info |awk NR==5 | awk -F ':'  '{print $2 $3 $4}')\n是否删除pip缓存?" 25 70);then
        pip_cmd cache purge
    fi
}