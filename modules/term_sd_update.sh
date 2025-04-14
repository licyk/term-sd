#!/bin/bash

# Term-SD 更新功能
term_sd_update_manager() {
    local dialog_arg
    local req
    local commit_hash
    local local_commit_hash
    local origin_branch
    local ref
    local auto_update_info
    
    if is_git_repo "${START_PATH}/term-sd"; then
        while true; do
            if [[ -f "${START_PATH}/term-sd/config/term-sd-auto-update.lock" ]]; then
                auto_update_info="启用"
            else
                auto_update_info="禁用"
            fi

            dialog_arg=$(dialog --erase-on-exit --notags \
                --title "Term-SD" \
                --backtitle "Term-SD 更新选项" \
                --ok-label "确认" --cancel-label "取消" \
                --menu "请选择 Term-SD 的操作\nTerm-SD 更新源: $(git_remote_display "${START_PATH}/term-sd")\nTerm-SD 分支: $(git_branch_display "${START_PATH}/term-sd")\nTerm-SD 自动更新: ${auto_update_info}\nTerm-SD 版本: ${TERM_SD_VER}" \
                $(get_dialog_size_menu) \
                "0" "> 返回" \
                "1" "> 更新" \
                "2" "> 修复更新" \
                "3" "> 自动更新设置" \
                "4" "> 切换更新源" \
                "5" "> 切换分支" \
                "6" "> 重启" \
                3>&1 1>&2 2>&3)

            case "${dialog_arg}" in
                1)
                    term_sd_echo "更新 Term-SD 中"
                    if [[ -f "${START_PATH}/term-sd/config/term-sd-auto-update.lock" ]]; then
                        date +'%Y-%m-%d %H:%M:%S' > "${START_PATH}/term-sd/config/term-sd-auto-update-time.conf" # 记录更新时间
                    fi
                    commit_hash=$(git -C "${START_PATH}/term-sd" show -s --format="%h")
                    git_pull_repository "${START_PATH}/term-sd"
                    if [[ "$?" == 0 ]]; then                        
                        local_commit_hash=$(git -C "${START_PATH}/term-sd" show -s --format="%h")
                        cp -f "${START_PATH}/term-sd/term-sd.sh" "${START_PATH}"
                        chmod +x "${START_PATH}/term-sd.sh"
                        if [[ "${commit_hash}" == "${local_commit_hash}" ]]; then
                            dialog --erase-on-exit \
                                --title "Term-SD" \
                                --backtitle "Term-SD 更新结果" \
                                --ok-label "确定" \
                                --msgbox "Term-SD 已是最新版本" \
                                $(get_dialog_size)
                        else
                            dialog --erase-on-exit \
                                --title "Term-SD" \
                                --backtitle "Term-SD 更新结果" \
                                --ok-label "确定" \
                                --msgbox "Term-SD 更新成功, 选择确定后重启" \
                                $(get_dialog_size)

                            . "${START_PATH}/term-sd/term-sd.sh"
                        fi
                    else
                        dialog --erase-on-exit \
                            --title "Term-SD" \
                            --backtitle "Term-SD 更新结果" \
                            --ok-label "确定" \
                            --msgbox "Term-SD 更新失败" \
                            $(get_dialog_size)
                    fi
                    ;;
                2)
                    git_fix_pointer_offset "${START_PATH}/term-sd"
                    cp -f "${START_PATH}/term-sd/term-sd.sh" "${START_PATH}"
                    chmod +x "${START_PATH}/term-sd.sh"
                    ;;
                3)
                    term_sd_auto_update_setting
                    ;;
                4)
                    term_sd_remote_revise
                    ;;
                5)
                    term_sd_branch_switch
                    ;;
                6)
                    term_sd_echo "重启 Term-SD 中"
                    . "${START_PATH}/term-sd/term-sd.sh"
                    ;;
                *)
                    break
                    ;;
            esac
        done
    else # 检测到没有该文件夹, 无法进行更新, 提示用户修复
        dialog --erase-on-exit \
            --title "Term-SD" \
            --backtitle "Term-SD 更新选项" \
            --ok-label "确定" \
            --msgbox "Term-SD 文件损坏, 无法进行更新, 请重启 Term-SD 并按提示修复问题" \
            $(get_dialog_size)
    fi
}

# Term-SD 更新源切换功能
term_sd_remote_revise() {
    local dialog_arg

    while true; do
        dialog_arg=$(dialog --erase-on-exit --notags \
            --title "Term-SD" \
            --backtitle "Term-SD 更新源切换选项" \
            --ok-label "确认" --cancel-label "取消" \
            --menu "请选择 Term-SD 的分支\n当前 Term-SD 更新源: $(cd term-sd ; git_remote_display)" \
            $(get_dialog_size_menu) \
            "0" "> 返回" \
            "1" "> Github 源" \
            "2" "> Gitee 源" \
            "3" "> Bitbucket 源" \
            "4" "> Gitlab 源" \
            3>&1 1>&2 2>&3)
        
        case "${dialog_arg}" in
            1)
                git -C "${START_PATH}/term-sd" remote set-url origin "https://github.com/licyk/term-sd"
                dialog --erase-on-exit \
                    --title "Term-SD" \
                    --backtitle "Term-SD 更新源切换选项" \
                    --ok-label "确认" \
                    --msgbox "Term-SD 更新源切换完成" \
                    $(get_dialog_size)
                ;;
            2)
                git -C "${START_PATH}/term-sd" remote set-url origin "https://gitee.com/licyk/term-sd"
                dialog --erase-on-exit \
                    --title "Term-SD" \
                    --backtitle "Term-SD 更新源切换选项" \
                    --ok-label "确认" \
                    --msgbox "Term-SD 更新源切换完成" \
                    $(get_dialog_size)
                ;;
            3)
                git -C "${START_PATH}/term-sd" remote set-url origin "https://licyk@bitbucket.org/licyks/term-sd"
                dialog --erase-on-exit \
                    --title "Term-SD" \
                    --backtitle "Term-SD 更新源切换选项" \
                    --ok-label "确认" \
                    --msgbox "Term-SD 更新源切换完成" \
                    $(get_dialog_size)
                ;;
            4)
                git -C "${START_PATH}/term-sd" remote set-url origin "https://gitlab.com/licyk/term-sd"
                dialog --erase-on-exit \
                    --title "Term-SD" \
                    --backtitle "Term-SD 更新源切换选项" \
                    --ok-label "确认" \
                    --msgbox "Term-SD 更新源切换完成" \
                    $(get_dialog_size)
                ;;
            *)
                break
                ;;
        esac
    done
}

# Term-SD 分支切换
term_sd_branch_switch() {
    local dialog_arg

    while true; do
        dialog_arg=$(dialog --erase-on-exit --notags \
            --title "Term-SD" \
            --backtitle "Term-SD 分支切换界面" \
            --ok-label "确认" --cancel-label "取消" \
            --menu "请选择 Term-SD 的分支\n当前 Term-SD 分支: $(git_branch_display "${START_PATH}/term-sd")" \
            $(get_dialog_size_menu) \
            "0" "> 返回" \
            "1" "> 主分支" \
            "2" "> 测试分支" \
            3>&1 1>&2 2>&3)
    
        if [[ "$?" == 0 ]]; then
            case "${dialog_arg}" in
                1)
                    if (dialog --erase-on-exit \
                        --title "Term-SD" \
                        --backtitle "Term-SD 分支切换界面" \
                        --yes-label "是" --no-label "否" \
                        --yesno "是否切换 Term-SD 的主分支 ?" \
                        $(get_dialog_size)); then

                        git -C "${START_PATH}/term-sd" checkout main
                        git -C "${START_PATH}/term-sd" reset --hard origin/main
                        cp -f term-sd/term-sd.sh .
                        chmod +x term-sd.sh
                        term_sd_echo "切换到 Term-SD 主分支"
                        term_sd_echo "即将重启 Term-SD"
                        term_sd_sleep 3
                        . "${START_PATH}/term-sd/term-sd.sh"
                    else
                        term_sd_echo "取消切换 Term-SD 分支操作"
                    fi
                    ;;
                2)
                    if (dialog --erase-on-exit \
                        --title "Term-SD" \
                        --backtitle "Term-SD 分支切换界面" \
                        --yes-label "是" --no-label "否" \
                        --yesno "是否切换 Term-SD 的测试分支 ?" \
                        $(get_dialog_size)); then

                        git -C "${START_PATH}/term-sd" checkout dev
                        git -C "${START_PATH}/term-sd" reset --hard origin/dev
                        cp -f term-sd/term-sd.sh .
                        chmod +x term-sd.sh
                        term_sd_echo "切换到 Term-SD 测试分支"
                        term_sd_echo "即将重启 Term-SD"
                        term_sd_sleep 3
                        . "${START_PATH}/term-sd/term-sd.sh"
                    else
                        term_sd_echo "取消切换 Term-SD 分支操作"
                    fi
                    ;;
                *)
                    break
                    ;;
            esac
        else
            break
        fi
    done
}

# Term-SD 自动更新设置
# Term-SD 自动更新配置保存在 <Start Path>/term-sd/config/term-sd-auto-update.lock
# <Start Path>/term-sd/config/term-sd-auto-update-time.conf 保存上一次自动更新的时间
term_sd_auto_update_setting() {
    local dialog_arg
    local auto_update_info

    while true; do
        if [[ -f "${START_PATH}/term-sd/config/term-sd-auto-update.lock" ]]; then
            auto_update_info="启用"
        else
            auto_update_info="禁用"
        fi

        dialog_arg=$(dialog --erase-on-exit --notags \
            --title "Term-SD" \
            --backtitle "Term-SD 自动更新选项" \
            --ok-label "确认" --cancel-label "取消" \
            --menu "是否启用 Term-SD 自动更新 ?\nTerm-SD 自动更新: ${auto_update_info}" \
            $(get_dialog_size_menu) \
            "0" "> 返回" \
            "1" "> 启用" \
            "2" "> 禁用" \
            3>&1 1>&2 2>&3)

        case "${dialog_arg}" in
            1)
                touch "${START_PATH}/term-sd/config/term-sd-auto-update.lock"
                dialog --erase-on-exit \
                    --title "Term-SD" \
                    --backtitle "Term-SD 自动更新选项" \
                    --ok-label "确认" \
                    --msgbox "启用 Term-SD 自动更新成功" \
                    $(get_dialog_size)
                ;;
            2)
                rm -f "${START_PATH}/term-sd/config/term-sd-auto-update.lock"
                rm -f "${START_PATH}/term-sd/config/term-sd-auto-update-time.conf"
                dialog --erase-on-exit \
                    --title "Term-SD" \
                    --backtitle "Term-SD 自动更新选项" \
                    --ok-label "确认" \
                    --msgbox "禁用 Term-SD 自动更新成功" \
                    $(get_dialog_size)
                ;;
            *)
                break
                ;;
        esac
    done
}
