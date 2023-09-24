#!/bin/bash

#处理用户输入的参数
function term_sd_process_user_input()
{
    for term_sd_launch_input in $(echo "$1 $2 $3 $4 $5 $6 $7 $8 $9") ;do
        case $term_sd_launch_input in
        "--help")
        echo
        echo "启动参数使用方法:"
        echo "  term-sd.sh [--help] [--extra] [--multi-threaded-download] [--enable-auto-update] [--disable-auto-update] [--reinstall-term-sd] [--remove-term-sd]"
        echo "选项:"
        echo "  --help"
        echo "        显示启动参数帮助"
        echo "  --extra"
        echo "        启动扩展脚本"
        echo "  --multi-threaded-download"
        echo "        安装过程中启用多线程下载模型"
        echo "  --enable-auto-update"
        echo "        启用Term-SD自动检查更新功能"
        echo "  --disable-auto-update"
        echo "        禁用Term-SD自动检查更新功能"
        echo "  --reinstall-term-sd"
        echo "        重新安装Term-SD"
        echo "  --remove-term-sd"
        echo "        卸载Term-SD"
        echo "  --test-proxy"
        echo "        测试网络环境,用于测试代理是否可用"
        exit 1
        ;;
        "--remove-term-sd")
        remove_term_sd
        ;;
        "--multi-threaded-download")
        echo "安装过程中启用多线程下载模型"
        export aria2_multi_threaded="-x 8"
        ;;
        "--enable-auto-update")
        echo "启用Term-SD自动检查更新功能"
        touch ./term-sd/term-sd-auto-update.lock
        ;;
        "--disable-auto-update")
        echo "禁用Term-SD自动检查更新功能"
        rm -rf ./term-sd/term-sd-auto-update.lock
        rm -rf ./term-sd/term-sd-auto-update-time.conf
        ;;
        "--test-proxy")
        if which curl > /dev/null;then
            echo "------------------------------"
            echo "测试网络环境"
            curl ipinfo.io ; echo
            echo "------------------------------"
        else
            echo "未安装curl,无法测试代理"
        fi
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

#自动更新触发功能
function term_sd_auto_update_trigger()
{
    if [ -f "./term-sd/term-sd-auto-update.lock" ];then #找到自动更新配置
        if [ -d "./term-sd/.git" ];then #检测到有.git文件夹
            if [ -f "./term-sd/term-sd-auto-update-time.conf" ];then #有上次运行记录
                term_sd_start_time=`date +'%Y-%m-%d %H:%M:%S'` #查看当前时间
                term_sd_end_time=$(cat ./term-sd/term-sd-auto-update-time.conf) #获取上次更新时间
                term_sd_start_time_seconds=$(date --date="$term_sd_start_time" +%s) #转换时间单位
                term_sd_end_time_seconds=$(date --date="$term_sd_end_time" +%s)
                term_sd_auto_update_time_span=$(( $term_sd_start_time_seconds - $term_sd_end_time_seconds )) #计算相隔时间
                term_sd_auto_update_time_set=3600 #检查更新时间间隔
                if [ $term_sd_auto_update_time_span -ge $term_sd_auto_update_time_set ];then #判断时间间隔
                    term_sd_auto_update
                    date +'%Y-%m-%d %H:%M:%S' > term-sd-auto-update-time.conf #记录自动更新功能的启动时间
                    mv -f ./term-sd-auto-update-time.conf ./term-sd
                fi
            else #没有时直接执行
                term_sd_auto_update
                date +'%Y-%m-%d %H:%M:%S' > term-sd-auto-update-time.conf #记录自动更新功能的启动时间
                mv -f ./term-sd-auto-update-time.conf ./term-sd
            fi
        fi    
    fi
}

#term-sd自动更新功能
function term_sd_auto_update()
{
    echo "检查更新中"
    term_sd_local_branch=$(git --git-dir="./term-sd/.git" branch | grep \* | awk -F "* " '{print $NF}') #term-sd分支
    term_sd_local_hash=$(git --git-dir="./term-sd/.git" rev-parse HEAD) #term-sd本地hash
    term_sd_remote_hash=$(git --git-dir="./term-sd/.git" ls-remote origin refs/remotes/origin/$term_sd_local_branch $term_sd_local_branch | awk '{print $1}') #term-sd远程hash
    if git --git-dir="./term-sd/.git" ls-remote origin refs/remotes/origin/$term_sd_local_branch $term_sd_local_branch 2> /dev/null 1> /dev/null ;then #网络连接正常时再进行更新
        if [ ! $term_sd_local_hash = $term_sd_remote_hash ];then
            term_sd_auto_update_option=""
            echo "检测到term-sd有新版本"
            echo "是否选择更新(yes/no)?"
            echo "提示:输入yes或no后回车"
            read -p "==>" term_sd_auto_update_option
            if [ ! -z $term_sd_auto_update_option ];then
                if [ $term_sd_auto_update_option = yes ] || [ $term_sd_auto_update_option = y ] || [ $term_sd_auto_update_option = YES ] || [ $term_sd_auto_update_option = Y ];then
                    cd ./term-sd
                    git_pull_info=""
                    git pull
                    git_pull_info=$?
                    cd ..
                    if [ $git_pull_info = 0 ];then
                        cp -f ./term-sd/term-sd.sh .
                        chmod +x ./term-sd.sh
                        echo "更新成功"
                    else
                        term_sd_update_fix
                    fi
                fi
            fi
        else
            echo "已经是最新版本"
        fi
    else
        echo "连接更新源失败,跳过更新"
        echo "提示:请检查网络连接是否正常,若网络正常,可尝试更换更新源或使用科学上网解决"
    fi
}

#修复更新功能
#修复后term-sd会切换到主分支
function term_sd_update_fix()
{
    term_sd_auto_update_option=""
    echo "是否修复更新(yes/no)?"
    echo "提示:输入yes或no后回车"
    read -p "==>" term_sd_auto_update_option
    if [ ! -z $term_sd_auto_update_option ];then
        if [ $term_sd_auto_update_option = yes ] || [ $term_sd_auto_update_option = y ] || [ $term_sd_auto_update_option = YES ] || [ $term_sd_auto_update_option = Y ];then
            cd ./term-sd
            term_sd_local_main_branch=$(git branch -a | grep HEAD | awk -F'/' '{print $NF}') #term-sd主分支
            git checkout $term_sd_local_main_branch
            git reset --hard HEAD
            git_pull_info=""
            git pull
            git_pull_info=$?
            cd ..
            if [ $git_pull_info = 0 ];then
                cp -f ./term-sd/term-sd.sh .
                chmod +x ./term-sd.sh
                echo "更新成功"
            else
                echo "如果出错的可能是网络原因导致无法连接到更新源,可通过更换更新源或使用科学上网解决"
            fi
        fi
    fi
}

#term-sd安装功能
function term_sd_install()
{
    term_sd_install_option=""
    if [ ! -d "./term-sd" ];then
        echo "检测到term-sd未安装,是否进行安装(yes/no)?"
        echo "提示:输入yes或no后回车"
        read -p "==>" term_sd_install_option
        if [ ! -z $term_sd_install_option ];then
            if [ $term_sd_install_option = yes ] || [ $term_sd_install_option = y ] || [ $term_sd_install_option = YES ] || [ $term_sd_install_option = Y ];then
                term_sd_install_mirror_select
                git clone $term_sd_install_mirror
                if [ $? = 0 ];then
                    cp -f ./term-sd/term-sd.sh .
                    chmod +x ./term-sd.sh
                    echo "安装成功"
                else
                    echo "安装失败"
                    exit 1
                fi
            else
                exit 1
            fi
        else
            exit 1
        fi
    elif [ ! -d "./term-sd/.git" ];then
        echo "检测到term-sd的.git目录不存在,将会影响term-sd组件的更新,是否重新安装(yes/no)?"
        echo "提示:输入yes或no后回车"
        read -p "==>" term_sd_install_option
        if [ ! -z $term_sd_install_option ];then
            if [ $term_sd_install_option = yes ] || [ $term_sd_install_option = y ] || [ $term_sd_install_option = YES ] || [ $term_sd_install_option = Y ];then
                term_sd_install_mirror_select
                echo "清除term-sd文件"
                rm -rf ./term-sd
                echo "清除完成,开始安装"
                git clone $term_sd_install_mirror
                if [ $? = 0 ];then
                    cp -f ./term-sd/term-sd.sh .
                    chmod +x ./term-sd.sh
                    echo "安装成功"
                else
                    echo "安装失败"
                    exit 1
                fi
            fi
        fi
    fi
}

#term-sd重新安装功能
function term_sd_reinstall()
{
    term_sd_install_option=""
    for term_sd_launch_input in $(echo "$1 $2 $3 $4 $5 $6 $7 $8 $9") ;do
        case $term_sd_launch_input in
        "--reinstall-term-sd")
        echo "是否重新安装Term-SD(yes/no)?"
        echo "提示:输入yes或no后回车"
        read -p "==>" term_sd_install_option
        if [ ! -z $term_sd_install_option ];then
            if [ $term_sd_install_option = yes ] || [ $term_sd_install_option = y ] || [ $term_sd_install_option = YES ] || [ $term_sd_install_option = Y ];then
                term_sd_install_mirror_select
                echo "清除term-sd文件"
                rm -rf ./term-sd
                echo "清除完成,开始安装"
                git clone $term_sd_install_mirror
                if [ $? = 0 ];then
                    cp -f ./term-sd/term-sd.sh .
                    chmod +x ./term-sd.sh
                    echo "安装成功"
                else
                    echo "安装失败"
                    exit 1
                fi
            else
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
    term_sd_install_option=""
    echo "请选择下载源"
    echo "1、github源"
    echo "2、gitlab源"
    echo "3、gitee源"
    echo "4、代理源(ghproxy.com)"
    echo "输入数字后回车"
    read -p "==>" term_sd_install_option
    if [ ! -z $term_sd_install_option ];then
        if [ $term_sd_install_option = 1 ];then
            echo "选择github源"
            term_sd_install_mirror="https://github.com/licyk/term-sd.git"
        elif [ $term_sd_install_option = 2 ];then
            echo "选择gitlab源"
            term_sd_install_mirror="https://gitlab.com/licyk/term-sd.git"
        elif [ $term_sd_install_option = 3 ];then
            echo "选择gitee源"
            term_sd_install_mirror="https://gitee.com/four-dishes/term-sd.git"
        elif [ $term_sd_install_option = 4 ];then
            echo "选择代理源(ghproxy.com)"
            term_sd_install_mirror="https://ghproxy.com/https://github.com/licyk/term-sd.git"
        else
            echo "输入有误,请重试"
            term_sd_install_mirror_select
        fi
    else
        echo "未输入,请重试"
        term_sd_install_mirror_select
    fi
}

#term-sd卸载功能
function remove_term_sd()
{
    remove_term_sd_option=""
    echo "是否卸载Term-SD"
    echo "提示:输入yes或no后回车"
    read -p "==>" remove_term_sd_option
    if [ ! -z  $remove_term_sd_option ];then
        if [ $remove_term_sd_option = yes ] || [ $remove_term_sd_option = y ] || [ $remove_term_sd_option = YES ] || [ $remove_term_sd_option = Y ];then
            echo "开始卸载Term-SD"
            rm -rf ./term-sd
            rm -rf ./term-sd.sh
            echo "Term-SD卸载完成"
        fi
    fi
    exit 1
}

#################################################

echo "Term-SD初始化中......"

if [ $(uname -o) = "Msys" ];then #为了兼容windows系统
    test_python="python"
else
    test_python="python3"
fi

if [ -f "./term-sd/proxy.conf" ];then #读取代理设置并设置代理
    export http_proxy=$(cat ./term-sd/proxy.conf)
    export https_proxy=$(cat ./term-sd/proxy.conf)
    #export all_proxy=$(cat ./term-sd/proxy.conf)
    #代理变量的说明:https://blog.csdn.net/Dancen/article/details/128045261
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
        term_sd_auto_update_trigger
        term_sd_process_user_input $(echo "$1 $2 $3 $4 $5 $6 $7 $8 $9")
    else
        echo "term-sd模块丢失,\"输入./term-sd.sh --reinstall-term-sd\"重新安装Term-SD"
    fi
else
    echo "缺少以下依赖"
    echo "------------------------------"
    echo $missing_dep
    echo "------------------------------"
    echo "请安装后重试"
    exit 1
fi
