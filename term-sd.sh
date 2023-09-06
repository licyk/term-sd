#!/bin/bash

#处理用户输入的参数
function term_sd_process_user_input()
{
    for term_sd_launch_input in $(echo "$1 $2 $3 $4 $5 $6 $7 $8 $9") ;do
        case $term_sd_launch_input in
        "--help")
        echo
        echo "启动参数使用方法:"
        echo "  term-sd.sh [--help] [--extra] [--multi-threaded-download]"
        echo "选项:"
        echo "  --help\n        显示启动参数帮助"
        echo "  --extra\n        启动扩展脚本"
        echo "  --multi-threaded-download\n        安装过程中启用多线程下载模型"
        exit 1
        ;;
        "--multi-threaded-download")
        aria2_multi_threaded="-x 8"
        ;;
        "--enable-auto-update")
        touch ./term-sd/term-sd-auto-update.lock
        ;;
        "--disable-auto-update")
        rm -rfv ./term-sd/term-sd-auto-update.lock
        ;;
        "--extra")
        term_sd_extra_scripts
        ;;
        esac
    done
    source ./term-sd/modules/init.sh
}

#扩展脚本列表
function term_sd_extra_scripts()
{
    extra_script_dir_list=$(ls -l "./term-sd/extra" --time-style=+"%Y-%m-%d" | awk -F ' ' ' { print $7 " " $6 } ')
    extra_script_dir_list_=$(dialog --clear --title "Term-SD" --backtitle "扩展脚本选项" --ok-label "确认" --cancel-label "取消" --menu "请选择要启动的脚本" 20 60 10 \
        "term-sd" "<------------" \
        $extra_script_dir_list \
        "退出" "<------------" \
        3>&1 1>&2 2>&3)

    if [ $? = 0 ];then
        if [ $extra_script_dir_list_ = "term-sd" ];then
            source ./term-sd/modules/init.sh
            exit 1
        elif [ $extra_script_dir_list_ = "退出" ];then
            exit 1
        fi
    else
        exit 1
    fi

    source ./term-sd/extra/$extra_script_dir_list_
    exit 1
}

#term-sd自动更新功能
function term_sd_auto_update()
{
    term_sd_local_branch=$(git --git-dir="./term-sd/.git" branch -a | grep HEAD | awk -F'/' '{print $NF}') #term-sd主分支
    term_sd_local_hash=$(git --git-dir="./term-sd/.git" rev-parse HEAD) #term-sd本地hash
    term_Sd_remote_hash=$(git ls-remote origin refs/remotes/origin/$term_sd_local_branch $term_sd_local_branch | awk '{print $1}') #term-sd远程hash
    if [ ! $term_sd_local_hash = $term_Sd_remote_hash ];then
        echo "检测到term-sd有新版本"
        echo "是否选择更新(yes/no)"
        echo "提示:输入yes或no后回车"
        read -p "==>" term_sd_auto_update_option
        if [ $term_sd_auto_update_option = yes ] || [ $term_sd_auto_update_option = y ] || [ $term_sd_auto_update_option = YES ] || [ $term_sd_auto_update_option = Y ];then
            git --git-dir="./term-sd/.git" pull
            if [ ! $? = 0 ];then
                term_sd_update_fix
            fi
        fi
    fi  
}

function term_sd_update_fix()
{
    echo "是否修复更新(yes/no)"
    echo "提示:输入yes或no后回车"
    read -p "==>" term_sd_auto_update_option_1
    if [ $term_sd_auto_update_option = yes ] || [ $term_sd_auto_update_option = y ] || [ $term_sd_auto_update_option = YES ] || [ $term_sd_auto_update_option = Y ];then
        git --git-dir="./term-sd/.git" checkout $term_sd_local_branch
        git --git-dir="./term-sd/.git" reset --hard HEAD
        git --git-dir="./term-sd/.git" pull
        if [ ! $? = 0 ];then
            echo "如果出错的可能是网络原因导致无法连接到更新源,可通过更换更新源解决"
        fi
    fi
}

echo "Term-SD初始化中......"

if [ $(uname -o) = "Msys" ];then #为了兼容windows系统
    test_python="python"
else
    test_python="python3"
fi

#判断系统是否安装必须使用的软件
echo "检测依赖软件是否安装"
missing_dep=""
test_num=0
if which dialog > /dev/null ;then
    test_num=$(( $test_num + 1 ))
else
    missing_dep="$missing_dep dialog,"
fi

if which aria2c > /dev/null ;then
    test_num=$(( $test_num + 1 ))
else
    missing_dep="$missing_dep aria2,"
fi

if which $test_python > /dev/null;then
    test_num=$(( $test_num + 1 ))
else
    missing_dep="$missing_dep python,"
fi

if which pip >/dev/null;then
    test_num=$(( $test_num + 1 ))
else
    missing_dep="$missing_dep pip,"
fi

if which git > /dev/null;then
    test_num=$(( $test_num + 1 ))
else
    missing_dep="$missing_dep git,"
fi

#启动terrm-sd
if [ $test_num -ge 5 ];then
    echo "完成"
    if [  -f "./term-sd/term-sd-auto-update.lock" ];then
        term_sd_auto_update
    fi
    term_sd_process_user_input $(echo "$1 $2 $3 $4 $5 $6 $7 $8 $9")
else
    echo "缺少以下依赖"
    echo "--------------------"
    echo $missing_dep
    echo "--------------------"
    echo "请安装后重试"
    exit
fi
