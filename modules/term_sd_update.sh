#/bin/bash

#term-sd更新功能
function term_sd_update_option()
{
    term_sd_update_option_=$(dialog --clear --title "Term-SD" --backtitle "Term-SD更新选项" --ok-label "确认" --cancel-label "取消" --menu "请选择Term-SD的更新源\n当前Term-SD更新源:$(git --git-dir="./term-sd/.git" remote get-url origin)\n当前Term-SD分支:$(git --git-dir="./term-sd/.git" branch | grep \* | awk -F "* " '{print $NF}')" 20 60 10 \
        "1" "更新" \
        "2" "切换更新源" \
        "3" "切换分支" \
        "4" "返回" \
        3>&1 1>&2 2>&3)

    if [ $? = 0 ];then
        if [ $term_sd_update_option_ = 1 ];then
            git pull ./term-sd
            if [ $? = 0];then
                cp -fv ./term-sd/term-sd.sh .
                dialog --clear --title "Term-SD" --backtitle "Term-SD更新结果" --ok-label "确定" --msgbox "Term-SD更新成功,选择确定后重启"
                source ./term-sd/modules/init.sh
            else
                dialog --clear --title "Term-SD" --backtitle "Term-SD更新结果" --ok-label "确定" --msgbox "Term-SD更新失败"
                term_sd_update_option
            fi
        elif [ $term_sd_update_option_ = 2 ];then
            term_sd_remote
            term_sd_update_option
        elif [ $term_sd_update_option_ = 3 ];then
            term_sd_branch
        elif [ $term_sd_update_option_ = 4 ];then
            mainmenu
        fi
    else
        mainmenu
    fi
}

#term-sd更新源切换功能
function term_sd_remote()
{
    term_sd_remote_=$(dialog --clear --title "Term-SD" --backtitle "Term-SD分支切换界面" --ok-label "确认" --cancel-label "取消" --menu "请选择Term-SD的分支\n当前Term-SD更新源:$(git --git-dir="./term-sd/.git" remote get-url origin)" 20 60 10 \
        "1" "github源" \
        "2" "gitee源" \
        "3" "代理源(ghproxy.com)" \
        3>&1 1>&2 2>&3)
    
    if [ $? = 0 ];then
        if [ $term_sd_remote_ = 1 ];then
            git --git-dir="./term-sd/.git" remote set-url origin "https://github.com/licyk/term-sd.git"
        elif [ $term_sd_remote_ = 2 ];then
            git --git-dir="./term-sd/.git" remote set-url origin "https://gitee.com/four-dishes/term-sd.git"
        elif [ $term_sd_remote_ = 3 ];then
            git --git-dir="./term-sd/.git" remote set-url origin "https://ghproxy.com/https://github.com/licyk/term-sd.git"
        fi
    fi
    term_sd_update_option
}

#term-sd分支切换
function term_sd_branch()
{
    term_sd_branch_=$(dialog --clear --title "Term-SD" --backtitle "Term-SD分支切换界面" --ok-label "确认" --cancel-label "取消" --menu "请选择Term-SD的分支\n当前Term-SD分支:$(git --git-dir="./term-sd/.git" branch | grep \* | awk -F "* " '{print $NF}')" 20 60 10 \
        "1" "主分支" \
        "2" "测试分支" \
        "3" "返回" \
        3>&1 1>&2 2>&3)
    
    if [ $? = 0 ];then
        if [ $term_sd_branch_ = 1 ];then
            git --git-dir="./term-sd/.git" checkout main
            cp -fv ./term-sd/term-sd.sh .
            echo "切换到主分支"
            echo "即将重启Term-SD"
            sleep 1
            source ./term-sd/modules/init.sh
        elif [ $term_sd_branch_ = 2 ];then
            git --git-dir="./term-sd/.git" checkout dev
            cp -fv ./term-sd/term-sd.sh .
            echo "切换到测试分支"
            echo "即将重启Term-SD"
            sleep 1
            source ./term-sd/modules/init.sh
        elif [ $term_sd_branch_ = 3 ];then
            term_sd_update_option
        fi
    else
        term_sd_update_option
    fi
}