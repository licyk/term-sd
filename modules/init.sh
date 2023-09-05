#/bin/bash

echo "######## ######## ########  ##     ##     ######  ########  "
echo "   ##    ##       ##     ## ###   ###    ##    ## ##     ## "
echo "   ##    ##       ##     ## #### ####    ##       ##     ## "
echo "   ##    ######   ########  ## ### ##     ######  ##     ## "
echo "   ##    ##       ##   ##   ##     ##          ## ##     ## "
echo "   ##    ##       ##    ##  ##     ##    ##    ## ##     ## "
echo "   ##    ######## ##     ## ##     ##     ######  ########  "
echo "Term-SD初始化中......"
###############################################################################

#term-sd分支设置
term_sd_branch=main
#设置启动时脚本路径
start_path=$(pwd)
#设置虚拟环境
if [ -f ./term-sd-venv-disable.lock ];then #找到term-sd-venv-disable.lock文件,禁用虚拟环境
    venv_active="1"
    venv_info="禁用"
else
    venv_active="0"
    venv_info="启用"
fi

term_sd_version_="0.3.10"

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


if [ $test_num -ge 5 ];then
    for term_sd_launch_input in $(echo "$1 $2 $3 $4 $5 $6 $7 $8 $9") ;do
    case $term_sd_launch_input in
    "--help")
    echo
    echo "启动参数使用方法:"
    echo "  term-sd.sh [--help] [--dev] [--multi-threaded-download]"
    echo "选项:"
    echo "  --help\n        显示启动参数帮助"
    echo "  --dev\n        将term-sd更新源切换到dev分支"
    echo "  --multi-threaded-download\n        安装过程中启用多线程下载模型"
    exit 1
    ;;
    "--dev")
    echo "将term-sd更新源切换到dev分支"
    term_sd_branch=dev
    ;;
    "--multi-threaded-download")
    echo "安装过程中启用多线程下载模型"
    aria2_multi_threaded="-x 8"
    ;;
    esac
    done

    echo "初始化Term-SD完成"
    echo "启动Term-SD中"
    #term_sd_version
else
    echo "缺少以下依赖"
    echo "--------------------"
    echo $missing_dep
    echo "--------------------"
    echo "请安装后重试"
    exit
fi

for term_sd_modules in ./term-sd/modules/*.sh ;do
    [ $term_sd_modules = "./term-sd/modules/init.sh" ]
    echo "加载$(echo $term_sd_modules | awk -F'/' '{print $NF}')"
    source $term_sd_modules
done
