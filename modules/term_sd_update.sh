#!/bin/bash

# term-sd更新功能
term_sd_update_manager()
{
    local term_sd_update_manager_dialog

    if [ -d "./term-sd/.git" ];then # 检测目录中是否有.git文件夹
        term_sd_update_manager_dialog=$(
            dialog --erase-on-exit --notags --title "Term-SD" --backtitle "Term-SD更新选项" --ok-label "确认" --cancel-label "取消" --menu "请选择Term-SD的更新源\n当前Term-SD更新源:$(git --git-dir="./term-sd/.git" remote get-url origin)\n当前Term-SD分支:$(git --git-dir="./term-sd/.git" branch | grep \* | awk -F "*" '{print $NF}')\nTerm-SD自动更新:$([ -f "./term-sd/config/term-sd-auto-update.lock" ] && echo "启用" || echo "禁用")" $term_sd_dialog_height $term_sd_dialog_width $term_sd_dialog_menu_height \
            "0" "> 返回" \
            "1" "> 更新" \
            "2" "> 修复更新" \
            "3" "> 自动更新设置" \
            "4" "> 切换更新源" \
            "5" "> 切换分支" \
            3>&1 1>&2 2>&3)

        case $term_sd_update_manager_dialog in
            1)
                term_sd_echo "更新Term-SD中"
                cd ./term-sd
                git_pull_repository
                if [ $? = 0 ];then
                    cd ..
                    cp -f ./term-sd/term-sd.sh .
                    chmod +x ./term-sd.sh
                    dialog --erase-on-exit --title "Term-SD" --backtitle "Term-SD更新结果" --ok-label "确定" --msgbox "Term-SD更新成功,选择确定后重启" $term_sd_dialog_height $term_sd_dialog_width
                    source ./term-sd.sh
                else
                    cd ..
                    dialog --erase-on-exit --title "Term-SD" --backtitle "Term-SD更新结果" --ok-label "确定" --msgbox "Term-SD更新失败" $term_sd_dialog_height $term_sd_dialog_width
                    term_sd_update_manager
                fi
                ;;
            2)
                cd ./term-sd
                git_fix_pointer_offset
                cd ..
                term_sd_update_manager
                ;;
            3)
                term_sd_auto_update_setting
                term_sd_update_manager
                ;;
            4)
                term_sd_remote_revise
                term_sd_update_manager
                ;;
            5)
                term_sd_branch_switch
                term_sd_update_manager
                ;;
            
        esac
    else # 检测到没有该文件夹,无法进行更新,提示用户修复
        dialog --erase-on-exit --title "Term-SD" --backtitle "Term-SD更新选项" --ok-label "确定" --msgbox "Term-SD文件损坏,无法进行更新,请重启Term-SD并按提示修复问题" $term_sd_dialog_height $term_sd_dialog_width
    fi
}

# term-sd更新源切换功能
term_sd_remote_revise()
{
    term_sd_remote_revise_dialog=$(
        dialog --erase-on-exit --notags --title "Term-SD" --backtitle "Term-SD更新源切换选项" --ok-label "确认" --cancel-label "取消" --menu "请选择Term-SD的分支\n当前Term-SD更新源:$(git --git-dir="./term-sd/.git" remote get-url origin)" $term_sd_dialog_height $term_sd_dialog_width $term_sd_dialog_menu_height \
        "0" "> 返回" \
        "1" "> github源" \
        "2" "> gitlab源" \
        "3" "> gitee源" \
        "4" "> 代理源1(ghproxy.com)" \
        "5" "> 代理源2(gitclone.com)" \
        3>&1 1>&2 2>&3)
    
    case $term_sd_remote_revise_dialog in
        1)
            git --git-dir="./term-sd/.git" remote set-url origin "https://github.com/licyk/term-sd"
            dialog --erase-on-exit --title "Term-SD" --backtitle "Term-SD更新源切换选项" --ok-label "确认" --msgbox "Term-SD更新源切换完成" $term_sd_dialog_height $term_sd_dialog_width
            term_sd_remote_revise
            ;;
        2)
            git --git-dir="./term-sd/.git" remote set-url origin "https://gitlab.com/licyk/term-sd"
            dialog --erase-on-exit --title "Term-SD" --backtitle "Term-SD更新源切换选项" --ok-label "确认" --msgbox "Term-SD更新源切换完成" $term_sd_dialog_height $term_sd_dialog_width
            term_sd_remote_revise
            ;;
        3)
            git --git-dir="./term-sd/.git" remote set-url origin "https://gitee.com/four-dishes/term-sd"
            dialog --erase-on-exit --title "Term-SD" --backtitle "Term-SD更新源切换选项" --ok-label "确认" --msgbox "Term-SD更新源切换完成" $term_sd_dialog_height $term_sd_dialog_width
            term_sd_remote_revise
            ;;
        4)
            git --git-dir="./term-sd/.git" remote set-url origin "https://ghproxy.com/github.com/licyk/term-sd"
            dialog --erase-on-exit --title "Term-SD" --backtitle "Term-SD更新源切换选项" --ok-label "确认" --msgbox "Term-SD更新源切换完成" $term_sd_dialog_height $term_sd_dialog_width
            term_sd_remote_revise
            ;;
        5)
            git --git-dir="./term-sd/.git" remote set-url origin "https://gitclone.com/github.com/licyk/term-sd"
            dialog --erase-on-exit --title "Term-SD" --backtitle "Term-SD更新源切换选项" --ok-label "确认" --msgbox "Term-SD更新源切换完成" $term_sd_dialog_height $term_sd_dialog_width
            term_sd_remote_revise
            ;;
    esac
}

# term-sd分支切换
term_sd_branch_switch()
{
    term_sd_branch_switch_dialog=$(
        dialog --erase-on-exit --notags --title "Term-SD" --backtitle "Term-SD分支切换界面" --ok-label "确认" --cancel-label "取消" --menu "请选择Term-SD的分支\n当前Term-SD分支:$(git --git-dir="./term-sd/.git" branch | grep \* | awk -F "* " '{print $NF}')" $term_sd_dialog_height $term_sd_dialog_width $term_sd_dialog_menu_height \
        "0" "> 返回" \
        "1" "> 主分支" \
        "2" "> 测试分支" \
        3>&1 1>&2 2>&3)
    
    if [ $? = 0 ];then
        case $term_sd_branch_switch_dialog in
            1)
                cd ./term-sd
                git checkout main
                cd ..
                cp -f ./term-sd/term-sd.sh .
                chmod +x ./term-sd.sh
                term_sd_echo "切换到主分支"
                term_sd_echo "即将重启Term-SD"
                sleep 1
                source ./term-sd.sh
                ;;
            2)
                cd ./term-sd
                git checkout dev
                cd ..
                cp -f ./term-sd/term-sd.sh .
                chmod +x ./term-sd.sh
                term_sd_echo "切换到测试分支"
                term_sd_echo "即将重启Term-SD"
                sleep 1
                source ./term-sd.sh
                ;;
        esac
    fi
}

# 自动更新设置
term_sd_auto_update_setting()
{
    local term_sd_auto_update_setting_dialog

    term_sd_auto_update_setting_dialog=$(
        dialog --erase-on-exit --notags --title "Term-SD" --backtitle "Term-SD自动更新选项" --ok-label "确认" --cancel-label "取消" --menu "是否启用Term-SD自动更新?\n当前状态:$([ -f "./term-sd/config/term-sd-auto-update.lock" ] && echo "启用" || echo "禁用")" $term_sd_dialog_height $term_sd_dialog_width $term_sd_dialog_menu_height \
        "0" "> 返回" \
        "1" "> 启用" \
        "2" "> 禁用" \
        3>&1 1>&2 2>&3)

    case $term_sd_auto_update_setting_dialog in
        1)
            touch ./term-sd/config/term-sd-auto-update.lock
            dialog --erase-on-exit --title "Term-SD" --backtitle "Term-SD自动更新选项" --ok-label "确认" --msgbox "启用成功" $term_sd_dialog_height $term_sd_dialog_width
            term_sd_auto_update_setting
            ;;
        2)
            rm -f ./term-sd/config/term-sd-auto-update.lock
            rm -f ./term-sd/config/term-sd-auto-update-time.conf
            dialog --erase-on-exit --title "Term-SD" --backtitle "Term-SD自动更新选项" --ok-label "确认" --msgbox "禁用成功" $term_sd_dialog_height $term_sd_dialog_width
            term_sd_auto_update_setting
            ;;
    esac
}
