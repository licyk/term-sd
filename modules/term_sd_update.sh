#!/bin/bash

#term-sd更新功能
function term_sd_update_option()
{
    if [ -d "./term-sd/.git" ];then #检测目录中是否有.git文件夹
        term_sd_update_option_dialog=$(
            dialog --clear --title "Term-SD" --backtitle "Term-SD更新选项" --ok-label "确认" --cancel-label "取消" --menu "请选择Term-SD的更新源\n当前Term-SD更新源:$(git --git-dir="./term-sd/.git" remote get-url origin)\n当前Term-SD分支:$(git --git-dir="./term-sd/.git" branch | grep \* | awk -F "* " '{print $NF}')" 25 80 10 \
            "1" "更新" \
            "2" "切换更新源" \
            "3" "切换分支" \
            "4" "修复更新" \
            "5" "返回" \
            3>&1 1>&2 2>&3)

        if [ $? = 0 ];then
            case $term_sd_update_option_dialog in
                1)
                    term_sd_notice "更新Term-SD中"
                    cd ./term-sd
                    git_pull_info=""
                    git fetch --all
                    git pull --all
                    git_pull_info=$?
                    cd ..
                    if [ $git_pull_info = 0 ];then
                        cp -f ./term-sd/term-sd.sh .
                        chmod +x ./term-sd.sh
                        dialog --clear --title "Term-SD" --backtitle "Term-SD更新结果" --ok-label "确定" --msgbox "Term-SD更新成功,选择确定后重启" 25 80
                        source ./term-sd.sh
                    else
                        dialog --clear --title "Term-SD" --backtitle "Term-SD更新结果" --ok-label "确定" --msgbox "Term-SD更新失败" 25 80
                        term_sd_update_option
                    fi
                    ;;
                2)
                    term_sd_remote
                    term_sd_update_option
                    ;;
                3)
                    term_sd_branch
                    term_sd_update_option
                    ;;
                4)
                    cd ./term-sd
                    term_sd_fix_pointer_offset
                    cd ..
                    term_sd_update_option
                    ;;
            esac
        fi
    else #检测到没有该文件夹,无法进行更新,提示用户修复
        dialog --clear --title "Term-SD" --backtitle "Term-SD更新选项" --ok-label "确定" --msgbox "Term-SD文件损坏,无法进行更新,请重启Term-SD并按提示修复问题" 25 80
    fi
}

#term-sd更新源切换功能
function term_sd_remote()
{
    term_sd_remote_dialog=$(
        dialog --clear --title "Term-SD" --backtitle "Term-SD分支切换界面" --ok-label "确认" --cancel-label "取消" --menu "请选择Term-SD的分支\n当前Term-SD更新源:$(git --git-dir="./term-sd/.git" remote get-url origin)" 25 80 10 \
        "1" "github源" \
        "2" "gitlab源" \
        "3" "gitee源" \
        "4" "代理源1(ghproxy.com)" \
        "5" "代理源2(gitclone.com)" \
        3>&1 1>&2 2>&3)
    
    if [ $? = 0 ];then
        case $term_sd_remote_dialog in
            1)
                git --git-dir="./term-sd/.git" remote set-url origin "https://github.com/licyk/term-sd"
                ;;
            2)
                git --git-dir="./term-sd/.git" remote set-url origin "https://gitlab.com/licyk/term-sd"
                ;;
            3)
                git --git-dir="./term-sd/.git" remote set-url origin "https://gitee.com/four-dishes/term-sd"
                ;;
            4)
                git --git-dir="./term-sd/.git" remote set-url origin "https://ghproxy.com/github.com/licyk/term-sd"
                ;;
            5)
                git --git-dir="./term-sd/.git" remote set-url origin "https://gitclone.com/github.com/licyk/term-sd"
                ;;
        esac
    fi
}

#term-sd分支切换
function term_sd_branch()
{
    term_sd_branch_dialog=$(dialog --clear --title "Term-SD" --backtitle "Term-SD分支切换界面" --ok-label "确认" --cancel-label "取消" --menu "请选择Term-SD的分支\n当前Term-SD分支:$(git --git-dir="./term-sd/.git" branch | grep \* | awk -F "* " '{print $NF}')" 25 80 10 \
        "1" "主分支" \
        "2" "测试分支" \
        "3" "返回" \
        3>&1 1>&2 2>&3)
    
    if [ $? = 0 ];then
        case $term_sd_branch_dialog in
            1)
                cd ./term-sd
                git checkout main
                cd ..
                cp -f ./term-sd/term-sd.sh .
                chmod +x ./term-sd.sh
                term_sd_notice "切换到主分支"
                term_sd_notice "即将重启Term-SD"
                sleep 1
                source ./term-sd.sh
                ;;
            2)
                cd ./term-sd
                git checkout dev
                cd ..
                cp -f ./term-sd/term-sd.sh .
                chmod +x ./term-sd.sh
                term_sd_notice "切换到测试分支"
                term_sd_notice "即将重启Term-SD"
                sleep 1
                source ./term-sd.sh
                ;;
        esac
    fi
}