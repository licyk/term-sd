#!/bin/bash

# 虚拟环境设置
python_venv_setting()
{
    local python_venv_setting_dialog
    export venv_setup_status

    while true
    do
        python_venv_setting_dialog=$(dialog --erase-on-exit --notags \
            --title "Term-SD" \
            --backtitle "虚拟环境设置界面" \
            --ok-label "确认" --cancel-label "取消" \
            --menu "该功能用于给 AI 软件启用虚拟环境, 隔离不同 AI 软件的 Python 库, 防止 Python 库中软件包版本和 AI 软件的版本要求不对应\n当前虚拟环境状态: $([ $venv_setup_status = 0 ] && echo "启用" || echo "禁用")\n是否启用虚拟环境? (推荐启用)" \
            $term_sd_dialog_height $term_sd_dialog_width $term_sd_dialog_menu_height \
            "0" "> 返回" \
            "1" "> 启用" \
            "2" "> 禁用" \
            3>&1 1>&2 2>&3)

        case $python_venv_setting_dialog in
            1)
                venv_setup_status=0
                rm -rf term-sd/config/term-sd-venv-disable.lock

                dialog --erase-on-exit \
                    --title "Term-SD" \
                    --backtitle "虚拟环境设置界面" \
                    --ok-label "确认" \
                    --msgbox "启用成功" \
                    $term_sd_dialog_height $term_sd_dialog_width
                ;;
            2)
                venv_setup_status=1
                touch term-sd/config/term-sd-venv-disable.lock

                dialog --erase-on-exit \
                    --title "Term-SD" \
                    --backtitle "虚拟环境设置界面" \
                    --ok-label "确认" \
                    --msgbox "禁用成功" \
                    $term_sd_dialog_height $term_sd_dialog_width
                ;;
            *)
                break
                ;;
        esac
    done
}

# pip镜像源选项(配置文件)
pip_mirrors_setting()
{
    local pip_mirrors_setting_dialog

    while true
    do
        term_sd_echo "获取 Pip 全局配置"
        pip_mirrors_setting_dialog=$(dialog --erase-on-exit --notags \
            --title "Term-SD" \
            --backtitle "Pip 镜像源 (配置文件) 选项" \
            --ok-label "确认" --cancel-label "取消" \
            --menu "该功能用于设置 Pip 镜像源 (环境变量) (优先级小于环境变量配置), 加速国内下载 Python 软件包的速度\n当前 Pip 全局配置:\n$(term_sd_pip config list | awk '{print$0}')\n请选择设置的 Pip 镜像源 (配置文件)" \
            $term_sd_dialog_height $term_sd_dialog_width $term_sd_dialog_menu_height \
            "0" "> 返回" \
            "1" "> 设置官方源" \
            "2" "> 设置国内镜像源" \
            "3" "> 删除镜像源配置" \
            3>&1 1>&2 2>&3)

        case $pip_mirrors_setting_dialog in
            1)
                term_sd_echo "设置 Pip 镜像源为官方源"
                term_sd_pip config set global.index-url "https://pypi.python.org/simple"
                term_sd_pip config unset global.extra-index-url
                term_sd_pip config set global.find-links "https://download.pytorch.org/whl/torch_stable.html"

                dialog --erase-on-exit \
                    --title "Term-SD" \
                    --backtitle "Pip 镜像源 (配置文件) 选项" \
                    --ok-label "确认" \
                    --msgbox "设置 Pip 镜像源为官方源成功" \
                    $term_sd_dialog_height $term_sd_dialog_width
                ;;
            2)
                term_sd_echo "设置 Pip 镜像源为国内镜像源"
                term_sd_pip config set global.index-url "https://mirrors.cloud.tencent.com/pypi/simple"
                term_sd_pip config set global.extra-index-url "https://mirror.baidu.com/pypi/simple https://mirrors.bfsu.edu.cn/pypi/web/simple https://mirror.nju.edu.cn/pypi/web/simple"
                term_sd_pip config set global.find-links "https://mirrors.aliyun.com/pytorch-wheels/torch_stable.html https://mirror.sjtu.edu.cn/pytorch-wheels/torch_stable.html"

                dialog --erase-on-exit \
                    --title "Term-SD" \
                    --backtitle "Pip 镜像源 (配置文件) 选项" \
                    --ok-label "确认" \
                    --msgbox "设置 Pip 镜像源为国内镜像源成功" \
                    $term_sd_dialog_height $term_sd_dialog_width
                ;;
            3)
                term_sd_echo "删除镜像源配置"
                term_sd_pip config unset global.extra-index-url
                term_sd_pip config unset global.index-url
                term_sd_pip config unset global.find-links

                dialog --erase-on-exit \
                    --title "Term-SD" \
                    --backtitle "Pip 镜像源 (配置文件) 选项" \
                    --ok-label "确认" \
                    --msgbox "删除镜像源配置成功" \
                    $term_sd_dialog_height $term_sd_dialog_width
                ;;
            *)
                break
                ;;
        esac
    done
}

# pip镜像源设置(环境变量)
# term-sd-pip-mirror.conf存储的值为1时,使用官方源;为2时使用镜像源
pip_mirrors_env_setting()
{
    local pip_mirrors_env_setting_dialog
    local pip_mirror_setup_info
    export PIP_INDEX_URL
    export PIP_EXTRA_INDEX_URL
    export PIP_FIND_LINKS

    while true
    do
        if [ -z "$PIP_INDEX_URL" ];then
            pip_mirror_setup_info="未设置"
        elif [ ! -z $(echo $PIP_INDEX_URL | grep "pypi.python.org") ];then
            pip_mirror_setup_info="官方源"
        else
            pip_mirror_setup_info="国内镜像源"
        fi

        pip_mirrors_env_setting_dialog=$(dialog --erase-on-exit --notags \
            --title "Term-SD" \
            --backtitle "Pip 镜像源 (环境变量) 选项" \
            --ok-label "确认" --cancel-label "取消" \
            --menu "该功能用于设置 Pip 镜像源 (环境变量) (优先级大于全局配置), 加速国内下载 Python 软件包的速度\n当前 Pip 环境变量配置: $pip_mirror_setup_info\n请选择设置的 Pip 镜像源 (环境变量)" \
            $term_sd_dialog_height $term_sd_dialog_width $term_sd_dialog_menu_height \
            "0" "> 返回" \
            "1" "> 设置官方源" \
            "2" "> 设置国内镜像源 (默认)" \
            "3" "> 删除镜像源配置" \
            3>&1 1>&2 2>&3)

        case $pip_mirrors_env_setting_dialog in
            1)
                PIP_INDEX_URL="https://pypi.python.org/simple"
                PIP_EXTRA_INDEX_URL=""
                PIP_FIND_LINKS="https://download.pytorch.org/whl/torch_stable.html"
                echo "1" > term-sd/config/term-sd-pip-mirror.conf

                dialog --erase-on-exit \
                    --title "Term-SD" \
                    --backtitle "Pip 镜像源 (环境变量) 选项" \
                    --ok-label "确认" \
                    --msgbox "设置 Pip 镜像源为官方源成功" \
                    $term_sd_dialog_height $term_sd_dialog_width
                ;;
            2)
                PIP_INDEX_URL="https://mirrors.cloud.tencent.com/pypi/simple"
                PIP_EXTRA_INDEX_URL="https://mirror.baidu.com/pypi/simple https://mirrors.bfsu.edu.cn/pypi/web/simple https://mirror.nju.edu.cn/pypi/web/simple"
                PIP_FIND_LINKS="https://mirrors.aliyun.com/pytorch-wheels/torch_stable.html https://mirror.sjtu.edu.cn/pytorch-wheels/torch_stable.html"
                echo "2" > term-sd/config/term-sd-pip-mirror.conf

                dialog --erase-on-exit \
                    --title "Term-SD" \
                    --backtitle "Pip 镜像源 (环境变量) 选项" \
                    --ok-label "确认" \
                    --msgbox "设置 Pip 镜像源为国内镜像源成功" \
                    $term_sd_dialog_height $term_sd_dialog_width
                ;;
            3)
                unset PIP_INDEX_URL
                unset PIP_EXTRA_INDEX_URL
                unset PIP_FIND_LINKS
                rm -f term-sd/config/term-sd-pip-mirror.conf

                dialog --erase-on-exit \
                    --title "Term-SD" \
                    --backtitle "Pip 镜像源 (环境变量) 选项" \
                    --ok-label "确认" \
                    --msgbox "删除镜像源配置成功" \
                    $term_sd_dialog_height $term_sd_dialog_width
                ;;
            *)
                break
                ;;
        esac
    done
}

# pip缓存清理功能
pip_cache_clean()
{
    term_sd_echo "统计pip缓存信息"
    if (dialog --erase-on-exit \
        --title "Term-SD" \
        --backtitle "Pip缓存清理选项" \
        --yes-label "是" --no-label "否" \
        --yesno "Pip 缓存信息:\nPip缓存路径: $(term_sd_pip cache dir)\n包索引页面缓存大小: $(term_sd_pip cache info | grep "Package index page cache size" | awk -F ':'  '{print $2 $3 $4}')\n本地构建的 WHELL 包大小: $(term_sd_pip cache info | grep "Locally built wheels size" | awk -F ':'  '{print $2 $3 $4}')\n是否删除 Pip 缓存?" \
        $term_sd_dialog_height $term_sd_dialog_width) then
        term_sd_pip cache purge

        dialog --erase-on-exit \
            --title "Term-SD" \
            --backtitle "Pip 缓存清理选项" \
            --ok-label "确认" \
            --msgbox "清理 Pip 缓存完成" \
            $term_sd_dialog_height $term_sd_dialog_width
    fi
}