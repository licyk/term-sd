#!/bin/bash

# term-sd更新功能
term_sd_update_manager()
{
    local term_sd_update_manager_dialog
    local req
    local commit_hash
    local local_commit_hash
    local origin_branch
    local ref
    
    if [ -d "term-sd/.git" ];then # 检测目录中是否有.git文件夹
        while true
        do
            term_sd_update_manager_dialog=$(dialog --erase-on-exit --notags \
                --title "Term-SD" \
                --backtitle "Term-SD 更新选项" \
                --ok-label "确认" --cancel-label "取消" \
                --menu "请选择 Term-SD 的更新源\n当前 Term-SD 更新源: $(cd term-sd ; git_remote_display)\n当前 Term-SD 分支: $(cd term-sd ; git_branch_display)\nTerm-SD 自动更新: $([ -f "term-sd/config/term-sd-auto-update.lock" ] && echo "启用" || echo "禁用")\n当前 Term-SD 版本: ${term_sd_version_info}" \
                $term_sd_dialog_height $term_sd_dialog_width $term_sd_dialog_menu_height \
                "0" "> 返回" \
                "1" "> 更新" \
                "2" "> 修复更新" \
                "3" "> 自动更新设置" \
                "4" "> 切换更新源" \
                "5" "> 切换分支" \
                3>&1 1>&2 2>&3)

            case $term_sd_update_manager_dialog in
                1)
                    term_sd_echo "更新 Term-SD 中"
                    [ -f "term-sd/config/term-sd-auto-update.lock" ] && date +'%Y-%m-%d %H:%M:%S' > term-sd/config/term-sd-auto-update-time.conf # 记录更新时间
                    term_sd_echo "拉取 Term-SD 远端更新内容"
                    term_sd_try git -C term-sd fetch
                    if [ $? = 0 ];then
                        ref=$(git -C term-sd symbolic-ref --quiet HEAD 2> /dev/null)
                        if [ $? = 0 ];then # 未出现分支游离
                            origin_branch="origin/${ref#refs/heads/}"
                        else # 出现分支游离时查询HEAD所指的分支
                            origin_branch="origin/$(git -C term-sd branch -a | grep /HEAD | awk -F'/' '{print $NF}')"
                        fi
                        commit_hash=$(git -C term-sd log $origin_branch --max-count 1 --format="%h")
                        local_commit_hash=$(git -C term-sd show -s --format="%h")
                        term_sd_echo "应用 Term-SD 远端更新内容"
                        git -C term-sd reset --hard $commit_hash
                        cp -f term-sd/term-sd.sh .
                        chmod +x term-sd.sh
                        if [ $commit_hash = $local_commit_hash ];then
                            dialog --erase-on-exit \
                                --title "Term-SD" \
                                --backtitle "Term-SD 更新结果" \
                                --ok-label "确定" \
                                --msgbox "Term-SD 已是最新版本" \
                                $term_sd_dialog_height $term_sd_dialog_width
                        else
                            dialog --erase-on-exit \
                                --title "Term-SD" \
                                --backtitle "Term-SD 更新结果" \
                                --ok-label "确定" \
                                --msgbox "Term-SD 更新成功, 选择确定后重启" \
                                $term_sd_dialog_height $term_sd_dialog_width

                            . ./term-sd/term-sd.sh
                        fi
                    else
                        dialog --erase-on-exit \
                            --title "Term-SD" \
                            --backtitle "Term-SD 更新结果" \
                            --ok-label "确定" \
                            --msgbox "Term-SD 更新失败" \
                            $term_sd_dialog_height $term_sd_dialog_width
                    fi
                    ;;
                2)
                    cd term-sd
                    git_fix_pointer_offset
                    cd ..
                    cp -f term-sd/term-sd.sh .
                    chmod +x term-sd.sh
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
                *)
                    break
                    ;;
            esac
        done
    else # 检测到没有该文件夹,无法进行更新,提示用户修复
        dialog --erase-on-exit \
            --title "Term-SD" \
            --backtitle "Term-SD 更新选项" \
            --ok-label "确定" \
            --msgbox "Term-SD 文件损坏, 无法进行更新, 请重启 Term-SD 并按提示修复问题" \
            $term_sd_dialog_height $term_sd_dialog_width
    fi
}

# term-sd更新源切换功能
term_sd_remote_revise()
{
    local term_sd_remote_revise_dialog

    while true
    do
        term_sd_remote_revise_dialog=$(dialog --erase-on-exit --notags \
            --title "Term-SD" \
            --backtitle "Term-SD 更新源切换选项" \
            --ok-label "确认" --cancel-label "取消" \
            --menu "请选择 Term-SD 的分支\n当前 Term-SD 更新源: $(cd term-sd ; git_remote_display)" \
            $term_sd_dialog_height $term_sd_dialog_width $term_sd_dialog_menu_height \
            "0" "> 返回" \
            "1" "> Github 源" \
            "2" "> Gitlab 源" \
            "3" "> Gitee 源" \
            "4" "> Bitbucket 源" \
            3>&1 1>&2 2>&3)
        
        case $term_sd_remote_revise_dialog in
            1)
                git -C term-sd remote set-url origin "https://github.com/licyk/term-sd"
                dialog --erase-on-exit \
                    --title "Term-SD" \
                    --backtitle "Term-SD 更新源切换选项" \
                    --ok-label "确认" \
                    --msgbox "Term-SD 更新源切换完成" \
                    $term_sd_dialog_height $term_sd_dialog_width
                ;;
            2)
                git -C term-sd remote set-url origin "https://gitlab.com/licyk/term-sd"
                dialog --erase-on-exit \
                    --title "Term-SD" \
                    --backtitle "Term-SD 更新源切换选项" \
                    --ok-label "确认" \
                    --msgbox "Term-SD 更新源切换完成" \
                    $term_sd_dialog_height $term_sd_dialog_width
                ;;
            3)
                git -C term-sd remote set-url origin "https://gitee.com/licyk/term-sd"
                dialog --erase-on-exit \
                    --title "Term-SD" \
                    --backtitle "Term-SD 更新源切换选项" \
                    --ok-label "确认" \
                    --msgbox "Term-SD 更新源切换完成" \
                    $term_sd_dialog_height $term_sd_dialog_width
                ;;
            4)
                git -C term-sd remote set-url origin "https://licyk@bitbucket.org/licyks/term-sd"
                dialog --erase-on-exit \
                    --title "Term-SD" \
                    --backtitle "Term-SD 更新源切换选项" \
                    --ok-label "确认" \
                    --msgbox "Term-SD 更新源切换完成" \
                    $term_sd_dialog_height $term_sd_dialog_width
                ;;
            *)
                break
                ;;
        esac
    done
}

# term-sd分支切换
term_sd_branch_switch()
{
    local term_sd_branch_switch_dialog

    while true
    do
        term_sd_branch_switch_dialog=$(dialog --erase-on-exit --notags \
            --title "Term-SD" \
            --backtitle "Term-SD 分支切换界面" \
            --ok-label "确认" --cancel-label "取消" \
            --menu "请选择 Term-SD 的分支\n当前 Term-SD 分支: $(cd term-sd ; git_branch_display)" \
            $term_sd_dialog_height $term_sd_dialog_width $term_sd_dialog_menu_height \
            "0" "> 返回" \
            "1" "> 主分支" \
            "2" "> 测试分支" \
            3>&1 1>&2 2>&3)
    
        if [ $? = 0 ];then
            case $term_sd_branch_switch_dialog in
                1)
                    if (dialog --erase-on-exit \
                        --title "Term-SD" \
                        --backtitle "Term-SD 分支切换界面" \
                        --yes-label "是" --no-label "否" \
                        --yesno "是否切换 Term-SD 的主分支?" \
                        $term_sd_dialog_height $term_sd_dialog_width) then

                        git -C term-sd checkout main
                        git -C term-sd reset --hard origin/main
                        cp -f term-sd/term-sd.sh .
                        chmod +x term-sd.sh
                        term_sd_echo "切换到 Term-SD 主分支"
                        term_sd_echo "即将重启 Term-SD"
                        term_sd_sleep 3
                        . ./term-sd/term-sd.sh
                    else
                        term_sd_echo "取消切换 Term-SD 分支操作"
                    fi
                    ;;
                2)
                    if (dialog --erase-on-exit \
                        --title "Term-SD" \
                        --backtitle "Term-SD 分支切换界面" \
                        --yes-label "是" --no-label "否" \
                        --yesno "是否切换 Term-SD 的测试分支?" \
                        $term_sd_dialog_height $term_sd_dialog_width) then

                        git -C term-sd checkout dev
                        git -C term-sd reset --hard origin/dev
                        cp -f term-sd/term-sd.sh .
                        chmod +x term-sd.sh
                        term_sd_echo "切换到 Term-SD 测试分支"
                        term_sd_echo "即将重启 Term-SD"
                        term_sd_sleep 3
                        . ./term-sd/term-sd.sh
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

# 自动更新设置
term_sd_auto_update_setting()
{
    local term_sd_auto_update_setting_dialog

    while true
    do
        term_sd_auto_update_setting_dialog=$(dialog --erase-on-exit --notags \
            --title "Term-SD" \
            --backtitle "Term-SD 自动更新选项" \
            --ok-label "确认" --cancel-label "取消" \
            --menu "是否启用 Term-SD 自动更新?\nTerm-SD 自动更新: $([ -f "term-sd/config/term-sd-auto-update.lock" ] && echo "启用" || echo "禁用")" \
            $term_sd_dialog_height $term_sd_dialog_width $term_sd_dialog_menu_height \
            "0" "> 返回" \
            "1" "> 启用" \
            "2" "> 禁用" \
            3>&1 1>&2 2>&3)

        case $term_sd_auto_update_setting_dialog in
            1)
                touch term-sd/config/term-sd-auto-update.lock
                dialog --erase-on-exit \
                    --title "Term-SD" \
                    --backtitle "Term-SD 自动更新选项" \
                    --ok-label "确认" \
                    --msgbox "启用 Term-SD 自动更新成功" $term_sd_dialog_height $term_sd_dialog_width
                ;;
            2)
                rm -f term-sd/config/term-sd-auto-update.lock
                rm -f term-sd/config/term-sd-auto-update-time.conf
                dialog --erase-on-exit \
                    --title "Term-SD" \
                    --backtitle "Term-SD 自动更新选项" \
                    --ok-label "确认" \
                    --msgbox "禁用 Term-SD 自动更新成功" \
                    $term_sd_dialog_height $term_sd_dialog_width
                ;;
            *)
                break
                ;;
        esac
    done
}
