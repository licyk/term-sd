#!/bin/bash

# Git 全局镜像源设置
# Git 镜像源配置保存在 <Start Path>/term-sd/config/set-global-github-mirror.conf
# Git 配置保存在 <Start Path>/term-sd/config/.gitconfig
# 动态 Git 镜像源配置保存在 <Start Path>/term-sd/config/set-dynamic-global-github-mirror.lock
# 设置 GIT_CONFIG_GLOBAL 环境变量指定 Git 使用的配置文件
# 使用 TERM_SD_GITHUB_MIRROR 全局变量获取镜像源地址
term_sd_git_global_mirror_setting() {
    local dialog_arg
    local github_mirror_status

    while true; do
        if [[ -f "${START_PATH}/term-sd/config/set-global-github-mirror.conf" ]]; then
            github_mirror_status=$(cat "${START_PATH}/term-sd/config/set-global-github-mirror.conf" | awk '{sub("/https://github.com","") ; sub("/github.com","")}1')
        else
            github_mirror_status="未设置"
        fi

        dialog_arg=$(dialog --erase-on-exit --notags \
            --title "Term-SD" \
            --backtitle "Github 镜像源选项" \
            --ok-label "确认" --cancel-label "取消" \
            --menu "该功能用于设置 Github 镜像源, 加速国内下载 Github 文件的速度\n当前 Github 镜像源配置: ${github_mirror_status}\n请选择对 Github 镜像源的操作" \
            $(get_dialog_size_menu) \
            "0" "> 返回" \
            "1" "> 设置 Github 镜像源" \
            "2" "> 删除 Github 镜像源配置" \
            3>&1 1>&2 2>&3)

        case "${dialog_arg}" in
            1)
                term_sd_set_github_mirror
                if [[ "$?" == 0 ]]; then
                    dialog --erase-on-exit \
                        --title "Term-SD" \
                        --backtitle "Github 镜像源选项" \
                        --ok-label "确认" \
                        --msgbox "设置 Github 镜像源代理完成\n当前使用的 Github 镜像源: $(echo ${TERM_SD_GITHUB_MIRROR} | awk '{sub("/https://github.com","") sub("/github.com","")}1')" \
                        $(get_dialog_size)
                else
                    term_sd_echo "取消设置 Github 镜像源"
                fi
                ;;
            2)
                if (dialog --erase-on-exit \
                    --title "Term-SD" \
                    --backtitle "Github 镜像源选项" \
                    --yes-label "是" --no-label "否" \
                    --yesno "是否删除 Github 镜像源配置?" \
                    $(get_dialog_size)); then

                    term_sd_echo "删除 Github 镜像源"
                    rm -f "${START_PATH}"/term-sd/config/.gitconfig
                    rm -f "${START_PATH}"/term-sd/config/set-global-github-mirror.conf
                    rm -f "${START_PATH}"/term-sd/config/set-dynamic-global-github-mirror.lock
                    unset GIT_CONFIG_GLOBAL

                    dialog --erase-on-exit \
                        --title "Term-SD" \
                        --backtitle "Github 镜像源选项" \
                        --ok-label "确认" \
                        --msgbox "删除 Github 镜像源配置完成" \
                        $(get_dialog_size)
                fi
                ;;
            *)
                break
                ;;
        esac
    done

    unset TERM_SD_GITHUB_MIRROR
}

# Github 镜像源选择
# 使用 TERM_SD_GITHUB_MIRROR 全局变量保存选择的镜像源
term_sd_set_github_mirror() {
    local dialog_arg

    dialog_arg=$(dialog --erase-on-exit --notags \
        --title "Term-SD" \
        --backtitle "Github 镜像源选项" \
        --ok-label "确认" \
        --cancel-label "取消" \
        --menu "选择要使用的 Github 镜像源, 推荐设置动态 Github 镜像源" \
        $(get_dialog_size_menu) \
        "0" "> 返回" \
        "1" "> 设置动态 Github 镜像源" \
        "2" "> 自动选择 Github 镜像源" \
        "3" "> 镜像源1 (mirror.ghproxy.com)" \
        "4" "> 镜像源2 (gitclone.com)" \
        "5" "> 镜像源3 (gh-proxy.com)" \
        "6" "> 镜像源4 (ghps.cc)" \
        "7" "> 镜像源5 (gh.idayer.com)" \
        "8" "> 镜像源6 (ghproxy.net)" \
        3>&1 1>&2 2>&3)

    case "${dialog_arg}" in
        1)
            term_sd_echo "启用 Github 动态镜像源中"
            touch "${START_PATH}"/term-sd/config/set-dynamic-global-github-mirror.lock
            term_sd_auto_setup_github_mirror
            if [ -f "${START_PATH}/term-sd/config/set-global-github-mirror.conf" ]; then
                TERM_SD_GITHUB_MIRROR=$(cat "${START_PATH}/term-sd/config/set-global-github-mirror.conf")
            else
                TERM_SD_GITHUB_MIRROR="无"
            fi
            term_sd_echo "启用 Github 动态镜像源完成"
            return 0
            ;;
        2)
            rm -f "${START_PATH}"/term-sd/config/set-dynamic-global-github-mirror.lock
            term_sd_echo "测试可用 Github 镜像源"
            term_sd_test_avaliable_github_mirror
            term_sd_echo "设置 Github 镜像源"
            export GIT_CONFIG_GLOBAL="${START_PATH}/term-sd/config/.gitconfig"
            rm -f "${START_PATH}"/term-sd/config/.gitconfig
            git config --global url."${TERM_SD_GITHUB_MIRROR}".insteadOf "https://github.com"
            echo "${TERM_SD_GITHUB_MIRROR}" > "${START_PATH}"/term-sd/config/set-global-github-mirror.conf
            return 0
            ;;
        3)
            rm -f "${START_PATH}"/term-sd/config/set-dynamic-global-github-mirror.lock
            TERM_SD_GITHUB_MIRROR="https://mirror.ghproxy.com/https://github.com"
            term_sd_echo "设置 Github 镜像源"
            export GIT_CONFIG_GLOBAL="${START_PATH}/term-sd/config/.gitconfig"
            rm -f "${START_PATH}"/term-sd/config/.gitconfig
            git config --global url."${TERM_SD_GITHUB_MIRROR}".insteadOf "https://github.com"
            echo "${TERM_SD_GITHUB_MIRROR}" > "${START_PATH}"/term-sd/config/set-global-github-mirror.conf
            return 0
            ;;
        4)
            rm -f "${START_PATH}"/term-sd/config/set-dynamic-global-github-mirror.lock
            TERM_SD_GITHUB_MIRROR="https://gitclone.com/github.com"
            term_sd_echo "设置 Github 镜像源"
            export GIT_CONFIG_GLOBAL="${START_PATH}/term-sd/config/.gitconfig"
            rm -f "${START_PATH}"/term-sd/config/.gitconfig
            git config --global url."${TERM_SD_GITHUB_MIRROR}".insteadOf "https://github.com"
            echo "${TERM_SD_GITHUB_MIRROR}" > "${START_PATH}"/term-sd/config/set-global-github-mirror.conf
            return 0
            ;;
        5)
            rm -f "${START_PATH}"/term-sd/config/set-dynamic-global-github-mirror.lock
            TERM_SD_GITHUB_MIRROR="https://gh-proxy.com/https://github.com"
            term_sd_echo "设置 Github 镜像源"
            export GIT_CONFIG_GLOBAL="${START_PATH}/term-sd/config/.gitconfig"
            rm -f "${START_PATH}"/term-sd/config/.gitconfig
            git config --global url."${TERM_SD_GITHUB_MIRROR}".insteadOf "https://github.com"
            echo "${TERM_SD_GITHUB_MIRROR}" > "${START_PATH}"/term-sd/config/set-global-github-mirror.conf
            return 0
            ;;
        6)
            rm -f "${START_PATH}"/term-sd/config/set-dynamic-global-github-mirror.lock
            TERM_SD_GITHUB_MIRROR="https://ghps.cc/https://github.com"
            term_sd_echo "设置 Github 镜像源"
            export GIT_CONFIG_GLOBAL="${START_PATH}/term-sd/config/.gitconfig"
            rm -f "${START_PATH}"/term-sd/config/.gitconfig
            git config --global url."${TERM_SD_GITHUB_MIRROR}".insteadOf "https://github.com"
            echo "${TERM_SD_GITHUB_MIRROR}" > "${START_PATH}"/term-sd/config/set-global-github-mirror.conf
            return 0
            ;;
        7)
            rm -f "${START_PATH}"/term-sd/config/set-dynamic-global-github-mirror.lock
            TERM_SD_GITHUB_MIRROR="https://gh.idayer.com/https://github.com"
            term_sd_echo "设置 Github 镜像源"
            export GIT_CONFIG_GLOBAL="${START_PATH}/term-sd/config/.gitconfig"
            rm -f "${START_PATH}"/term-sd/config/.gitconfig
            git config --global url."${TERM_SD_GITHUB_MIRROR}".insteadOf "https://github.com"
            echo "${TERM_SD_GITHUB_MIRROR}" > "${START_PATH}"/term-sd/config/set-global-github-mirror.conf
            return 0
            ;;
        8)
            rm -f "${START_PATH}"/term-sd/config/set-dynamic-global-github-mirror.lock
            TERM_SD_GITHUB_MIRROR="https://ghproxy.net/https://github.com"
            term_sd_echo "设置 Github 镜像源"
            export GIT_CONFIG_GLOBAL="${START_PATH}/term-sd/config/.gitconfig"
            rm -f "${START_PATH}"/term-sd/config/.gitconfig
            git config --global url."${TERM_SD_GITHUB_MIRROR}".insteadOf "https://github.com"
            echo "${TERM_SD_GITHUB_MIRROR}" > "${START_PATH}"/term-sd/config/set-global-github-mirror.conf
            return 0
            ;;
        *)
            return 1
            ;;
    esac
}

# 测试可用的 Github 镜像源
# 将选择的镜像 Github 镜像源保存在 TERM_SD_GITHUB_MIRROR 全局变量
term_sd_test_avaliable_github_mirror() {
    # 镜像源列表
    local mirror_list=$GITHUB_MIRROR_LIST
    local git_req
    local HTTP_PROXY
    local HTTPS_PROXY
    local i
    HTTP_PROXY= # 临时清除配置好的代理, 防止干扰测试
    HTTPS_PROXY=
    rm -rf "${START_PATH}/term-sd/task/github_mirror_test" &> /dev/null
    for i in ${mirror_list}; do
        git clone $(git_format_repository_url ${i} https://github.com/licyk/empty) "${START_PATH}/term-sd/task/github_mirror_test" --depth=1 &> /dev/null # 测试镜像源是否正常连接
        git_req=$?
        rm -rf "${START_PATH}/term-sd/task/github_mirror_test" &> /dev/null
        if [[ "${git_req}" == 0 ]]; then
            TERM_SD_GITHUB_MIRROR=$(awk '{sub("/term_sd_git_user/term_sd_git_repo","")}1' <<< ${i})
            return
        fi
    done
    TERM_SD_GITHUB_MIRROR="https://mirror.ghproxy.com/https://github.com"
}