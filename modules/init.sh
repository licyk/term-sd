#/bin/bash

echo "######## ######## ########  ##     ##     ######  ########  "
echo "   ##    ##       ##     ## ###   ###    ##    ## ##     ## "
echo "   ##    ##       ##     ## #### ####    ##       ##     ## "
echo "   ##    ######   ########  ## ### ##     ######  ##     ## "
echo "   ##    ##       ##   ##   ##     ##          ## ##     ## "
echo "   ##    ##       ##    ##  ##     ##    ##    ## ##     ## "
echo "   ##    ######## ##     ## ##     ##     ######  ########  "
echo "Term-SD初始化中......"

#term-sd初始化部分
function term_sd_init()
{
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
        echo "将term-sd切换到dev分支"
        cd ./term-sd
        git checkout dev
        cd ..
        ;;
        "--main")
        echo "将term-sd切换到main分支"
        cd ./term-sd
        git checkout main
        cd ..
        ;;
        "--multi-threaded-download")
        echo "安装过程中启用多线程下载模型"
        aria2_multi_threaded="-x 8"
        ;;
        esac
    done

    term_sd_modules_number=$(( $(ls ./term-sd/modules/*.sh |wc -w) - 1 ))
    term_sd_modules_number_=1
    for term_sd_modules in ./term-sd/modules/*.sh ;do
        [ $term_sd_modules = "./term-sd/modules/init.sh" ] && continue
        term_sd_init_bar_1="$term_sd_modules_number_/$term_sd_modules_number"
        term_sd_init_bar_2=$(echo $term_sd_modules | awk -F'/' '{print $NF}')
        printf "[$term_sd_init_bar_1] 加载 ${term_sd_init_bar_2}                               \r"
        term_sd_modules_number_=$(( "$term_sd_modules_number_" + 1 ))
        source $term_sd_modules
    done
    printf "初始化Term-SD完成                               \n"
    echo "启动Term-SD中"
    term_sd_version
}

#term-sd分支设置
term_sd_branch=main
#设置启动时脚本路径
start_path=$(pwd)
#设置虚拟环境
if [ -f ./term-sd/term-sd-venv-disable.lock ];then #找到term-sd-venv-disable.lock文件,禁用虚拟环境
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

#启动terrm-sd
if [ $test_num -ge 5 ];then
    term_sd_init $(echo "$1 $2 $3 $4 $5 $6 $7 $8 $9")
else
    echo "缺少以下依赖"
    echo "--------------------"
    echo $missing_dep
    echo "--------------------"
    echo "请安装后重试"
    exit
fi