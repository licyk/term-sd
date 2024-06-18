#!/bin/bash

# git全局镜像源设置
term_sd_git_global_mirror_setting()
{
    local term_sd_git_global_mirror_setting_dialog

    while true
    do
        term_sd_git_global_mirror_setting_dialog=$(dialog --erase-on-exit --notags \
            --title "Term-SD" \
            --backtitle "Github 镜像源选项" \
            --ok-label "确认" --cancel-label "取消" \
            --menu "该功能用于设置 Github 镜像源, 加速国内下载 Github 文件的速度\n当前 Github 镜像源配置: $([ -f "term-sd/config/set-global-github-mirror.conf" ] && echo "$(cat term-sd/config/set-global-github-mirror.conf | awk '{sub("/https://github.com","") sub("/github.com","")}1')" || echo "未设置")\n请选择对 Github 镜像源的操作" \
            $term_sd_dialog_height $term_sd_dialog_width $term_sd_dialog_menu_height \
            "0" "> 返回" \
            "1" "> 设置 Github 镜像源" \
            "2" "> 删除 Github 镜像源配置" \
            3>&1 1>&2 2>&3)

        case $term_sd_git_global_mirror_setting_dialog in
            1)
                term_sd_set_github_mirror
                if [ $? = 0 ];then
                    dialog --erase-on-exit \
                        --title "Term-SD" \
                        --backtitle "Github 镜像源选项" \
                        --ok-label "确认" \
                        --msgbox "设置 Github 镜像源代理完成\n当前使用的 Github 镜像源: $(echo $term_sd_github_mirror | awk '{sub("/https://github.com","") sub("/github.com","")}1')" \
                        $term_sd_dialog_height $term_sd_dialog_width
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
                    $term_sd_dialog_height $term_sd_dialog_width) then

                    term_sd_echo "删除 Github 镜像源"
                    rm -f "$start_path"/term-sd/config/.gitconfig
                    rm -f "$start_path"/term-sd/config/set-global-github-mirror.conf
                    rm -f "$start_path"/term-sd/config/set-dynamic-global-github-mirror.lock
                    unset GIT_CONFIG_GLOBAL

                    dialog --erase-on-exit \
                        --title "Term-SD" \
                        --backtitle "Github 镜像源选项" \
                        --ok-label "确认" \
                        --msgbox "删除 Github 镜像源配置完成" \
                        $term_sd_dialog_height $term_sd_dialog_width
                fi
                ;;
            *)
                break
                ;;
        esac
    done
}

# github镜像源选择
term_sd_set_github_mirror()
{
    local term_sd_set_github_mirror_dialog

    term_sd_set_github_mirror_dialog=$(dialog --erase-on-exit --notags \
        --title "Term-SD" \
        --backtitle "Github 镜像源选项" \
        --ok-label "确认" \
        --cancel-label "取消" \
        --menu "选择要使用的 Github 镜像源, 推荐设置动态 Github 镜像源" \
        $term_sd_dialog_height $term_sd_dialog_width $term_sd_dialog_menu_height \
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

    case $term_sd_set_github_mirror_dialog in
        1)
            term_sd_echo "启用 Github 动态镜像源中"
            touch "$start_path"/term-sd/config/set-dynamic-global-github-mirror.lock
            term_sd_auto_setup_github_mirror
            if [ -f "$start_path/term-sd/config/set-global-github-mirror.conf" ];then
                term_sd_github_mirror=$(cat "$start_path/term-sd/config/set-global-github-mirror.conf")
            else
                term_sd_github_mirror="无"
            fi
            term_sd_echo "启用 Github 动态镜像源完成"
            return 0
            ;;
        2)
            rm -f "$start_path"/term-sd/config/set-dynamic-global-github-mirror.lock
            term_sd_echo "测试可用 Github 镜像源"
            term_sd_test_avaliable_github_mirror
            term_sd_echo "设置 Github 镜像源"
            export GIT_CONFIG_GLOBAL="$start_path/term-sd/config/.gitconfig"
            rm -f "$start_path"/term-sd/config/.gitconfig
            git config --global url."$term_sd_github_mirror".insteadOf "https://github.com"
            echo "$term_sd_github_mirror" > "$start_path"/term-sd/config/set-global-github-mirror.conf
            return 0
            ;;
        3)
            rm -f "$start_path"/term-sd/config/set-dynamic-global-github-mirror.lock
            term_sd_github_mirror="https://mirror.ghproxy.com/https://github.com"
            term_sd_echo "设置 Github 镜像源"
            export GIT_CONFIG_GLOBAL="$start_path/term-sd/config/.gitconfig"
            rm -f "$start_path"/term-sd/config/.gitconfig
            git config --global url."$term_sd_github_mirror".insteadOf "https://github.com"
            echo "$term_sd_github_mirror" > "$start_path"/term-sd/config/set-global-github-mirror.conf
            return 0
            ;;
        4)
            rm -f "$start_path"/term-sd/config/set-dynamic-global-github-mirror.lock
            term_sd_github_mirror="https://gitclone.com/github.com"
            term_sd_echo "设置 Github 镜像源"
            export GIT_CONFIG_GLOBAL="$start_path/term-sd/config/.gitconfig"
            rm -f "$start_path"/term-sd/config/.gitconfig
            git config --global url."$term_sd_github_mirror".insteadOf "https://github.com"
            echo "$term_sd_github_mirror" > "$start_path"/term-sd/config/set-global-github-mirror.conf
            return 0
            ;;
        5)
            rm -f "$start_path"/term-sd/config/set-dynamic-global-github-mirror.lock
            term_sd_github_mirror="https://gh-proxy.com/https://github.com"
            term_sd_echo "设置 Github 镜像源"
            export GIT_CONFIG_GLOBAL="$start_path/term-sd/config/.gitconfig"
            rm -f "$start_path"/term-sd/config/.gitconfig
            git config --global url."$term_sd_github_mirror".insteadOf "https://github.com"
            echo "$term_sd_github_mirror" > "$start_path"/term-sd/config/set-global-github-mirror.conf
            return 0
            ;;
        6)
            rm -f "$start_path"/term-sd/config/set-dynamic-global-github-mirror.lock
            term_sd_github_mirror="https://ghps.cc/https://github.com"
            term_sd_echo "设置 Github 镜像源"
            export GIT_CONFIG_GLOBAL="$start_path/term-sd/config/.gitconfig"
            rm -f "$start_path"/term-sd/config/.gitconfig
            git config --global url."$term_sd_github_mirror".insteadOf "https://github.com"
            echo "$term_sd_github_mirror" > "$start_path"/term-sd/config/set-global-github-mirror.conf
            return 0
            ;;
        7)
            rm -f "$start_path"/term-sd/config/set-dynamic-global-github-mirror.lock
            term_sd_github_mirror="https://gh.idayer.com/https://github.com"
            term_sd_echo "设置 Github 镜像源"
            export GIT_CONFIG_GLOBAL="$start_path/term-sd/config/.gitconfig"
            rm -f "$start_path"/term-sd/config/.gitconfig
            git config --global url."$term_sd_github_mirror".insteadOf "https://github.com"
            echo "$term_sd_github_mirror" > "$start_path"/term-sd/config/set-global-github-mirror.conf
            return 0
            ;;
        8)
            rm -f "$start_path"/term-sd/config/set-dynamic-global-github-mirror.lock
            term_sd_github_mirror="https://ghproxy.net/https://github.com"
            term_sd_echo "设置 Github 镜像源"
            export GIT_CONFIG_GLOBAL="$start_path/term-sd/config/.gitconfig"
            rm -f "$start_path"/term-sd/config/.gitconfig
            git config --global url."$term_sd_github_mirror".insteadOf "https://github.com"
            echo "$term_sd_github_mirror" > "$start_path"/term-sd/config/set-global-github-mirror.conf
            return 0
            ;;
        *)
            return 1
            ;;
    esac
}

# 测试可用的github镜像源
# 返回term_sd_github_mirror变量
term_sd_test_avaliable_github_mirror()
{
    # 镜像源列表
    local mirror_list=$github_mirror_list
    local git_req
    local http_proxy
    local https_proxy
    http_proxy= # 临时清除配置好的代理,防止干扰测试
    https_proxy=
    [ -d "$start_path/term-sd/github_mirror_test" ] && rm -rf "$start_path/term-sd/github_mirror_test" &> /dev/null
    for i in $mirror_list ;do
        git clone $(git_format_repository_url $i https://github.com/licyk/empty) "$start_path/term-sd/github_mirror_test" --depth=1 &> /dev/null # 测试镜像源是否正常连接
        git_req=$?
        rm -rf "$start_path/term-sd/github_mirror_test" &> /dev/null
        if [ $git_req = 0 ];then
            term_sd_github_mirror=$(echo $i | awk '{sub("/term_sd_git_user/term_sd_git_repo","")}1')
            return
        fi
    done
    term_sd_github_mirror="https://mirror.ghproxy.com/https://github.com"
}