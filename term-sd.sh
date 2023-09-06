#!/bin/bash

#处理用户输入的参数
function term_sd_process_user_input()
{
    for term_sd_launch_input in $(echo "$1 $2 $3 $4 $5 $6 $7 $8 $9") ;do
        case $term_sd_launch_input in
        "--help")
        echo
        echo "启动参数使用方法:"
        echo "  term-sd.sh [--help] [--extra] [--multi-threaded-download] [--enable-auto-update] [--disable-auto-update] [--reinstall-term-sd]"
        echo "选项:"
        echo "  --help\n        显示启动参数帮助"
        echo "  --extra\n        启动扩展脚本"
        echo "  --multi-threaded-download\n        安装过程中启用多线程下载模型"
        echo "  --enable-auto-update\n        启动Term-SD自动检查更新功能"
        echo "  --disable-auto-update\n        禁用Term-SD自动检查更新功能"
        echo "  --reinstall-term-sd\n        重新安装Term-SD"
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
    term_Sd_remote_hash=$(git --git-dir="./term-sd/.git" ls-remote origin refs/remotes/origin/$term_sd_local_branch $term_sd_local_branch | awk '{print $1}') #term-sd远程hash
    if git --git-dir="./term-sd/.git" ls-remote origin refs/remotes/origin/$term_sd_local_branch $term_sd_local_branch 2> /dev/null 1> /dev/null ;then #网络连接正常时再进行更新
        if [ ! $term_sd_local_hash = $term_Sd_remote_hash ];then
            echo "检测到term-sd有新版本"
            echo "是否选择更新(yes/no)?"
            echo "提示:输入yes或no后回车"
            read -p "==>" term_sd_auto_update_option
            if [ $term_sd_auto_update_option = yes ] || [ $term_sd_auto_update_option = y ] || [ $term_sd_auto_update_option = YES ] || [ $term_sd_auto_update_option = Y ];then
                git --git-dir="./term-sd/.git" pull
                if [ ! $? = 0 ];then
                    term_sd_update_fix
                fi
            fi
        fi
    fi
}

#修复更新功能
function term_sd_update_fix()
{
    echo "是否修复更新(yes/no)?"
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

#term-sd安装功能
function term_sd_install()
{
    if [ ! -d "./term-sd" ];then
        echo "检测到term-sd未安装,是否进行安装(yes/no)?"
        echo "提示:输入yes或no后回车"
        read -p "==>" term_sd_install_option_1
        if [ $term_sd_install_option_1 = yes ] || if [ $term_sd_install_option_1 = y ] || if [ $term_sd_install_option_1 = YES ] || if [ $term_sd_install_option_1 = Y ];then
            term_sd_install_mirror_select
            git clone $term_sd_install_mirror
            if [ $? = 0 ];then
                cp -fv ./term-sd/term-sd.sh .
                echo "安装成功"
            else
                echo "安装失败"
                exit 1
            fi
        else
            exit 1
        fi
    elif [ ! -d "./term-sd/.git" ];then
        if [ -d "./term-sd" ];then
        echo "检测到term-sd的.git目录不存在,将会影响term-sd组件的更新,是否重新安装(yes/no)?"
        echo "提示:输入yes或no后回车"
        read -p "==>" term_sd_install_option_1
        if [ $term_sd_install_option_1 = yes ] || if [ $term_sd_install_option_1 = y ] || if [ $term_sd_install_option_1 = YES ] || if [ $term_sd_install_option_1 = Y ];then
            term_sd_install_mirror_select
            echo "清除term-sd文件"
            rm -rfv ./term-sd
            echo "清除完成,开始安装"
            git clone $term_sd_install_mirror
            if [ $? = 0 ];then
                cp -fv ./term-sd/term-sd.sh .
                echo "安装成功"
            else
                echo "安装失败"
                exit 1
            fi
        fi
    fi
}

#term-sd重新安装功能
function term_sd_reinstall()
{
    for term_sd_launch_input in $(echo "$1 $2 $3 $4 $5 $6 $7 $8 $9") ;do
        case $term_sd_launch_input in
        "--reinstall-term-sd")
        echo "是否重新安装Term-SD(yes/no)?"
        echo "提示:输入yes或no后回车"
        read -p "==>" term_sd_install_option_3
        if [ $term_sd_install_option_3 = yes ] || if [ $term_sd_install_option_3 = y ] || if [ $term_sd_install_option_3 = YES ] || if [ $term_sd_install_option_3 = Y ];then
            term_sd_install_mirror_select
            git clone $term_sd_install_mirror
            if [ $? = 0 ];then
                cp -fv ./term-sd/term-sd.sh .
                echo "安装成功"
            else
                echo "安装失败"
                exit 1
            fi
        else
            exit 1
        fi
        ;;
        esac
    done
}

#term-sd下载源选择
function term_sd_install_mirror_select()
{
    echo "请选择下载源"
    echo "1、github源"
    echo "2、gitee源"
    echo "3、代理源(ghproxy.com)"
    echo "输入数字后回车"
    read -p "==>" term_sd_install_option_2
    if [ $term_sd_install_option_2 = 1 ];then
        echo "选择github源"
        term_sd_install_mirror=""
    elif [ $term_sd_install_option_2 = 2 ];then
        echo "选择gitee源"
        term_sd_install_mirror=""
    if [ $term_sd_install_option_2 = 3 ];then
        echo "选择代理源(ghproxy.com)"
        term_sd_install_mirror=""
    else
        echo "输入有误,请重试"
        term_sd_install_mirror_select
    fi
}

#################################################

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
    echo "检测完成"
    term_sd_reinstall $(echo "$1 $2 $3 $4 $5 $6 $7 $8 $9")
    term_sd_install
    if [ -d "./term-sd/modules" ];then #找到目录后才启动
        if [ -f "./term-sd/term-sd-auto-update.lock" ];then
            term_sd_auto_update
        fi
        term_sd_process_user_input $(echo "$1 $2 $3 $4 $5 $6 $7 $8 $9")
    else
        echo "term-sd模块丢失,退出"
    fi
else
    echo "缺少以下依赖"
    echo "--------------------"
    echo $missing_dep
    echo "--------------------"
    echo "请安装后重试"
    exit 1
fi
