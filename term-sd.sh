#!/bin/bash

###################
# 脚本已在Windows,Linux上做过测试,MacOS未做过测试,可能会有问题
# https://stackoverflow.com/questions/24332942/why-awk-script-does-not-work-on-mac-os-but-works-on-linux
# 未知MacOS上自带的awk是否会对脚本的运行产生影响
# 安装过程使用huggingface下载模型,需要科学上网,虽然国内有modelscope,但是需要使用api或者git来下载模型,所以没考虑

# licyk
###################

#测试输入值是参数还是选项,选项输出0,参数输出1(用于实现getopt命令的功能)
function option_or_value_test()
{
    echo $@ | awk -F ' ' '{for (i=1; i<=NF; i++) {if (substr($i, 1, 2) == "--") {print "0"} else {print "1"}}}'
}

#term-sd未知启动参数提醒
function term_sd_launch_unknown_option_notice()
{
    if [ $(option_or_value_test "$i") = 0 ];then #测试输入值是参数还是选项
        case $i in
		--null|--help|--reinstall-term-sd|--enable-auto-update|--disable-auto-update|--set-python-path|--set-pip-path|--unset-python-path|--unset-pip-path|--enable-new-bar|--disable-new-bar|--enable-bar|--disable-bar|--remove-term-sd|--quick-cmd|--multi-threaded-download|--update-pip|--test-network|--extra) #排除已有参数
                ;;
            *)
                term_sd_notice "未知参数 \"$i\""
                ;;
        esac
    fi
}

#term-sd处理用户输入功能(早期进行配置时使用)
function term_sd_process_user_input_early()
{
    #用别的方法实现了getopt命令的功能
    #加一个--null是为了增加一次循环,保证那些需要参数的选项能成功执行
    for i in "$@" "--null" ;do
        term_sd_launch_option_args="$i" #用作判断是参数还是选项

        #参数检测部分
        if [ ! -z $term_sd_launch_option ];then
            if [ $(option_or_value_test "$term_sd_launch_option_args") = 0 ];then #测试输入值是参数还是选项
                term_sd_launch_option_args="" #检测到选项的下一项是选项,直接清除
            fi

            #检测输入的选项
            case $term_sd_launch_option in
                --set-python-path)
                    set_python_path $term_sd_launch_option_args
                    ;;
                --set-pip-path)
                    set_pip_path $term_sd_launch_option_args
                    ;;
            esac
            term_sd_launch_option="" #清除选项,留给下一次判断
        fi

        ####################

        #选项检测部分(如果选项要跟参数值,则将启动选项赋值给term_sd_launch_option)
        case $i in
            --help)
                print_line_to_shell
                term_sd_notice "启动参数使用方法:"
                echo "  term-sd.sh [--help] [--extra script_name] [--multi-threaded-download] [--enable-auto-update] [--disable-auto-update] [--reinstall-term-sd] [--remove-term-sd] [--test-network] [--quick-cmd] [--set-python-path python_path] [--set-pip-path pip_path] [--unset-python-path] [--unset-pip-path] [--enable-new-bar] [--disable-new-bar] [--enable-bar] [--disable-bar]"
                echo "选项:"
                echo "  --help"
                echo "        显示启动参数帮助"
                echo "  --extra script_name"
                echo "        启动扩展脚本选择列表,当选项后面输入了脚本名,则直接启动指定的脚本,否则启动扩展脚本选择界面"
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
                echo "  --test-network"
                echo "        测试网络环境,用于测试代理是否可用,需安装curl"
                echo "  --quick-cmd"
                echo "        添加Term-SD快捷启动命令到shell"
                echo "  --set-python-path python_path"
                echo "        手动指定python解释器路径,当选项后面输入了路径,则直接使用输入的路径来设置python解释器路径(建议用\"\"把路径括起来),否则启动设置界面"
                echo "  --set-pip-path pip_path"
                echo "        手动指定pip路径,当选项后面输入了路径,则直接使用输入的路径来设置pip路径(建议用\"\"把路径括起来),否则启动设置界面"
                echo "  --unset-python-path"
                echo "        删除自定义python解释器路径配置"
                echo "  --unset-pip-path"
                echo "        删除自定义pip解释器路径配置"
                echo "  --update-pip"
                echo "        进入虚拟环境时更新pip软件包管理器"
                echo "  --enable-new-bar"
                echo "        启用新的Term-SD初始化进度条"
                echo "  --disable-new-bar"
                echo "        禁用新的Term-SD初始化进度条"
                echo "  --enable-bar"
                echo "        启用Term-SD初始化进度显示(默认)"
                echo "  --disable-bar"
                echo "        禁用Term-SD初始化进度显示(加了进度显示只会降低Term-SD初始化速度)"
                print_line_to_shell
                exit 1
                ;;
            --reinstall-term-sd)
                term_sd_reinstall
                ;;
            --enable-auto-update)
                term_sd_notice "启用Term-SD自动检查更新功能"
                touch ./term-sd/term-sd-auto-update.lock
                ;;
            --disable-auto-update)
                term_sd_notice "禁用Term-SD自动检查更新功能"
                rm -rf ./term-sd/term-sd-auto-update.lock
                rm -rf ./term-sd/term-sd-auto-update-time.conf
                ;;
            --set-python-path)
                term_sd_launch_option="--set-python-path"
                ;;
            --set-pip-path)
                term_sd_launch_option="--set-pip-path"
                ;;
            --unset-python-path)
                rm -f ./term-sd/python-path.conf
                term_sd_notice "已删除自定义python解释器路径配置"
                ;;
            --unset-pip-path)
                rm -f ./term-sd/pip-path.conf
                term_sd_notice "已删除自定义pip解释器路径配置"
                ;;
            --enable-new-bar)
                term_sd_notice "启用新的Term-SD初始化进度条"
                touch ./term-sd/term-sd-new-bar.lock
                ;;
            --disable-new-bar)
                term_sd_notice "禁用新的Term-SD初始化进度条"
                rm -rf ./term-sd/term-sd-new-bar.lock
                ;;
            --enable-bar)
                rm -f ./term-sd/term-sd-no-bar.lock
                term_sd_notice "启用Term-SD初始化进度显示"
                ;;
            --disable-bar)
                touch ./term-sd/term-sd-no-bar.lock
                term_sd_notice "禁用Term-SD初始化进度显示"
                ;;
            *)
                term_sd_launch_unknown_option_notice
                ;;
        esac

    done
}

#处理用户输入的参数(较晚启动)
function term_sd_process_user_input()
{
    #重置变量
    export pip_manager_update=1
    export aria2_multi_threaded=""

    #加一个--null是为了增加一次循环,保证那些需要参数的选项能成功执行
    for i in "$@" "--null" ;do
        term_sd_launch_option_args="$i" #用作判断是参数还是选项

        #参数检测部分
        if [ ! -z $term_sd_launch_option ];then
            if [ $(option_or_value_test "$term_sd_launch_option_args") = 0 ];then #测试输入值是参数还是选项
                term_sd_launch_option_args="" #检测到选项的下一项是选项,直接清除
            fi

            #检测输入的选项
            case $term_sd_launch_option in
                --extra)
                    term_sd_extra_scripts_launch $term_sd_launch_option_args
                    ;;
            esac
            term_sd_launch_option="" #清除选项,留给下一次判断
        fi

        ####################

        #选项检测部分(如果选项要跟参数值,则设置触发获取参数的变量,命名为"term_sd_input_value_"+"选项名",赋值0,触发获取参数的功能后,赋值1)
        case $i in
            --remove-term-sd)
                remove_term_sd
                ;;
            --quick-cmd)
                install_cmd_to_shell
                exit 1
                ;;
            --multi-threaded-download)
                term_sd_notice "安装过程中启用多线程下载模型"
                export aria2_multi_threaded="-x 8"
                ;;
            --update-pip)
                export pip_manager_update=0
                term_sd_notice "进入虚拟环境时将更新pip软件包管理器"
                ;;
            --test-network)
                term_sd_test_network
                ;;
            --extra)
                term_sd_launch_option="--extra"
                ;;
            *)
                term_sd_launch_unknown_option_notice
                ;;
        esac

    done
}

#扩展脚本启动功能
function term_sd_extra_scripts_launch()
{
    if [ -z "$@" ];then
        term_sd_extra_scripts
    else
        if [ -f "./term-sd/extra/$(echo $@ | awk '{sub(".sh","")}1').sh" ];then
            term_sd_notice "启动$(echo $@ | awk '{sub(".sh","")}1')脚本中"
            source ./term-sd/extra/$(echo $@ | awk '{sub(".sh","")}1').sh
            print_line_to_shell
            term_sd_notice "退出$(echo $@ | awk '{sub(".sh","")}1')脚本"
            exit 1
        else
            print_line_to_shell
            term_sd_notice "未找到$(echo $@ | awk '{sub(".sh","")}1')脚本"
            term_sd_notice "退出Term-SD"
            exit 1
        fi
    fi
}

#扩展脚本列表
function term_sd_extra_scripts()
{
    extra_script_dir_list=$(ls -l "./term-sd/extra" --time-style=+"%Y-%m-%d" | awk -F ' ' ' { print $7 " " $6 } ')
    extra_script_dir_list_=$(dialog --clear --title "Term-SD" --backtitle "扩展脚本选项" --ok-label "确认" --cancel-label "取消" --menu "请选择要启动的脚本" 25 70 10 \
        "Term-SD" "<---------" \
        $extra_script_dir_list \
        "退出" "<---------" \
        3>&1 1>&2 2>&3)

    if [ $? = 0 ];then
        if [ $extra_script_dir_list_ = "Term-SD" ];then
            source ./term-sd/modules/init.sh
            term_sd_version
            _main_
        elif [ $extra_script_dir_list_ = "退出" ];then
            print_line_to_shell
            term_sd_notice "退出Term-SD"
            exit 1
        else
            source ./term-sd/extra/$extra_script_dir_list_
        fi
    fi
    print_line_to_shell
    term_sd_notice "退出Term-SD"
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
                    date +'%Y-%m-%d %H:%M:%S' > ./term-sd/term-sd-auto-update-time.conf #记录自动更新功能的启动时间
                fi
            else #没有时直接执行
                term_sd_auto_update
                date +'%Y-%m-%d %H:%M:%S' > ./term-sd/term-sd-auto-update-time.conf #记录自动更新功能的启动时间
            fi
        fi    
    fi
}

#term-sd自动更新功能
function term_sd_auto_update()
{
    term_sd_notice "检查更新中"
    term_sd_local_branch=$(git --git-dir="./term-sd/.git" branch | grep \* | awk -F "* " '{print $NF}') #term-sd分支
    term_sd_local_hash=$(git --git-dir="./term-sd/.git" rev-parse HEAD) #term-sd本地hash
    term_sd_remote_hash=$(git --git-dir="./term-sd/.git" ls-remote origin refs/remotes/origin/$term_sd_local_branch $term_sd_local_branch | awk '{print $1}') #term-sd远程hash
    if git --git-dir="./term-sd/.git" ls-remote origin refs/remotes/origin/$term_sd_local_branch $term_sd_local_branch 2> /dev/null 1> /dev/null ;then #网络连接正常时再进行更新
        if [ ! $term_sd_local_hash = $term_sd_remote_hash ];then
            term_sd_auto_update_option=""
            term_sd_notice "检测到Term-SD有新版本"
            term_sd_notice "是否选择更新(yes/no)?"
            term_sd_notice "提示:输入yes或no后回车"
            read -p "===============================> " term_sd_auto_update_option
            case $term_sd_auto_update_option in
                yes|y|YES|Y)
                    term_sd_notice "更新Term-SD中"
                    cd ./term-sd
                    git_pull_info=""
                    git pull
                    git_pull_info=$?
                    cd ..
                    if [ $git_pull_info = 0 ];then
                        cp -f ./term-sd/term-sd.sh .
                        chmod +x ./term-sd.sh
                        term_sd_notice "Term-SD更新成功"
                    else
                        term_sd_update_fix
                    fi
                    ;;
            esac
        else
            term_sd_notice "Term-SD已经是最新版本"
        fi
    else
        term_sd_notice "Term-SD连接更新源失败,跳过更新"
        term_sd_notice "提示:请检查网络连接是否正常,若网络正常,可尝试更换更新源或使用科学上网解决"
    fi
}

#修复更新功能
#修复后term-sd会切换到主分支
function term_sd_update_fix()
{
    term_sd_auto_update_option=""
    term_sd_notice "是否修复Term-SD的更新(yes/no)?"
    term_sd_notice "提示:输入yes或no后回车"
    read -p "===============================> " term_sd_auto_update_option

    case $term_sd_auto_update_option in
        yes|y|YES|Y)
            term_sd_notice "修复Term-SD更新中"
            cd ./term-sd
            term_sd_local_main_branch=$(git branch -a | grep HEAD | awk -F'/' '{print $NF}') #term-sd主分支
            git checkout $term_sd_local_main_branch
            git reset --hard HEAD
            git restore --source=HEAD :/
            term_sd_notice "修复Term-SD更新完成"
            term_sd_notice "更新Term-SD中"
            git_pull_info=""
            git pull
            git_pull_info=$?
            cd ..
            if [ $git_pull_info = 0 ];then
                cp -f ./term-sd/term-sd.sh .
                chmod +x ./term-sd.sh
                term_sd_notice "Term-SD更新成功"
            else
                term_sd_notice "如果出错的可能是网络原因导致无法连接到更新源,可通过更换更新源或使用科学上网解决"
            fi
            ;;
    esac
}

#term-sd安装功能
function term_sd_install()
{
    term_sd_install_option=""
    if [ ! -d "./term-sd" ];then
        term_sd_notice "检测到Term-SD未安装,是否进行安装(yes/no)?"
        term_sd_notice "提示:输入yes或no后回车"
        read -p "===============================> " term_sd_install_option
    
        case $term_sd_install_option in
            yes|y|YES|Y)
                term_sd_install_mirror_select
                term_sd_notice "下载Term-SD中"
                git clone $term_sd_install_mirror
                if [ $? = 0 ];then
                    cp -f ./term-sd/term-sd.sh .
                    chmod +x ./term-sd.sh
                    term_sd_notice "Term-SD安装成功"
                else
                    term_sd_notice "Term-SD安装失败"
                    exit 1
                fi
                ;;
            *)
                exit 1
                ;;
        esac
    elif [ ! -d "./term-sd/.git" ];then
        term_sd_notice "检测到Term-SD的.git目录不存在,将会导致Term-SD无法更新,是否重新安装(yes/no)?"
        term_sd_notice "提示:输入yes或no后回车"
        read -p "===============================> " term_sd_install_option

        case $term_sd_install_option in
            yes|y|YES|Y)
                term_sd_install_mirror_select
                term_sd_notice "清除Term-SD文件中"
                rm -rf ./term-sd
                term_sd_notice "清除完成,开始安装Term-SD"
                git clone $term_sd_install_mirror
                if [ $? = 0 ];then
                    cp -f ./term-sd/term-sd.sh .
                    chmod +x ./term-sd.sh
                    term_sd_notice "Term-SD安装成功"
                else
                    term_sd_notice "Term-SD安装失败"
                    exit 1
                fi
                ;;
        esac
    fi
}

#term-sd重新安装功能
function term_sd_reinstall()
{
    if which git > /dev/null 2> /dev/null ;then
        term_sd_install_option=""
        term_sd_notice "是否重新安装Term-SD(yes/no)?"
        term_sd_notice "提示:输入yes或no后回车"
        read -p "===============================> " term_sd_install_option

        case $term_sd_install_option in
            yes|y|YES|Y)
                term_sd_install_mirror_select
                term_sd_notice "清除Term-SD文件中"
                rm -rf ./term-sd
                term_sd_notice "清除完成,开始安装Term-SD"
                git clone $term_sd_install_mirror
                if [ $? = 0 ];then
                    cp -f ./term-sd/term-sd.sh .
                    chmod +x ./term-sd.sh
                    term_sd_notice "Term-SD安装成功"
                else
                    term_sd_notice "Term-SD安装失败"
                    exit 1
                fi
                ;;
            *)
                exit 1
                ;;
        esac
    fi
}

#term-sd下载源选择
function term_sd_install_mirror_select()
{
    term_sd_install_option=""
    term_sd_notice "请选择Term-SD下载源"
    term_sd_notice "1、github源"
    term_sd_notice "2、gitlab源"
    term_sd_notice "3、gitee源"
    term_sd_notice "4、代理源(ghproxy.com)"
    term_sd_notice "提示:输入数字后回车"
    read -p "===============================> " term_sd_install_option

    case $term_sd_install_option in
        1)
            term_sd_notice "选择github源"
            term_sd_install_mirror="https://github.com/licyk/term-sd"
            ;;
        2)
            term_sd_notice "选择gitlab源"
            term_sd_install_mirror="https://gitlab.com/licyk/term-sd"
            ;;
        3)
            term_sd_notice "选择gitee源"
            term_sd_install_mirror="https://gitee.com/four-dishes/term-sd"
            ;;
        4)
            term_sd_notice "选择代理源(ghproxy.com)"
            term_sd_install_mirror="https://ghproxy.com/https://github.com/licyk/term-sd"
            ;;
        *)
            term_sd_notice "输入有误,请重试"
            term_sd_install_mirror_select
            ;;
    esac
}

#term-sd卸载功能
function remove_term_sd()
{
    remove_term_sd_option=""
    term_sd_notice "是否卸载Term-SD"
    term_sd_notice "提示:输入yes或no后回车"
    read -p "===============================> " remove_term_sd_option

    case $remove_term_sd_option in
        y|yes|YES|Y)
            term_sd_notice "开始卸载Term-SD"
            rm -rf ./term-sd
            rm -rf ./term-sd.sh
            user_shell=$(echo $SHELL | awk -F "/" '{print $NF}') #读取用户所使用的shell
            if [ $user_shell = bash ] || [ $user_shell = zsh ];then
                sed -i '/# Term-SD/d' ~/."$user_shell"rc
                sed -i '/termsd(){/d' ~/."$user_shell"rc
                sed -i '/alias tsd/d' ~/."$user_shell"rc
            fi
            term_sd_notice "Term-SD卸载完成"
            ;;
    esac
    exit 1
}

#term-sd添加快捷命令功能
function install_cmd_to_shell()
{
    case $user_shell in
        bash|zsh)
            term_sd_notice "是否将Term-SD快捷启动指令添加到shell环境中?"
            term_sd_notice "添加后可使用\"termsd\"指令启动Term-SD"
            term_sd_notice "1、添加"
            term_sd_notice "2、删除"
            term_sd_notice "3、退出"
            term_sd_notice "提示:输入数字后回车"
            read -p "===============================> " install_to_shell_option

            case $install_to_shell_option in
                1)
                    install_config_to_shell
                    ;;
                2)
                    remove_config_from_shell
                    ;;
                3)
                    exit 1
                    ;;
                *)
                    term_sd_notice "输入有误,请重试"
                    install_cmd_to_shell
                    ;;
            esac
            ;;
        *)
            term_sd_notice "不支持该shell"
            ;;
    esac
}

#term-sd快捷命令安装功能
function install_config_to_shell()
{
    #将要向.bashrc写入的配置
    term_sd_shell_config="termsd(){ term_sd_start_path=\$(pwd) ; cd \"$term_sd_install_path\" ; ./term-sd.sh \"\$@\" ; cd \"\$term_sd_start_path\" > /dev/null ; }"
    if cat ~/."$user_shell"rc | grep termsd > /dev/null ;then
        term_sd_notice "配置已存在,添加前请删除原有配置"
    else
        echo "# Term-SD" >> ~/."$user_shell"rc
        echo $term_sd_shell_config >> ~/."$user_shell"rc
        echo "alias tsd='termsd'" >> ~/."$user_shell"rc
        term_sd_notice "配置添加完成,重启shell以生效"
    fi
}

#term-sd快捷命令卸载功能
function remove_config_from_shell()
{
    sed -i '/# Term-SD/d' ~/."$user_shell"rc
    sed -i '/termsd(){/d' ~/."$user_shell"rc
    sed -i '/alias tsd/d' ~/."$user_shell"rc
    term_sd_notice "配置已删除,重启shell以生效"
}

#终端横线显示功能
function print_line_to_shell()
{
    if [ -z "$1" ];then
        print_line_methon=1
        print_line_to_shell_methon
    else
        print_word_to_shell="$1"
        shellwidth=$(stty size | awk '{print $2}') #获取终端宽度
        print_word_to_shell_=$(echo "$print_word_to_shell" | awk '{gsub(/ /,"-")}1') #将空格转换为"-"
        shell_word_width=$(( $(echo "$print_word_to_shell_" | wc -c) - 1 )) #总共的字符长度
        shell_word_width_zh_cn=$(( $(echo "$print_word_to_shell_" | awk '{gsub(/[a-zA-Z]/, "")}1' | awk '{gsub(/[0-9]/, "")}1' | awk '{gsub(/-/,"")}1' | wc -c) - 1 )) #计算中文字符的长度
        shell_word_width=$(( $shell_word_width - $shell_word_width_zh_cn )) #除去中文之后的长度
        #中文的字符长度为3,但终端中只占2个字符位
        shell_word_width_zh_cn=$(( $shell_word_width_zh_cn / 3 * 2 )) #转换中文在终端占用的实际字符长度
        shell_word_width=$(( $shell_word_width + $shell_word_width_zh_cn )) #最终显示文字的长度

        #横线输出长度的计算
        shellwidth=$(( $shellwidth - $shell_word_width )) #除去输出字符后的横线宽度
        shellwidth=$(( $shellwidth / 2 )) #半边的宽度

        #判断终端宽度大小是否是单双数
        print_line_info=$(( $shellwidth % 2 ))
        #判断字符宽度大小是否是单双数
        print_word_info=$(( $shell_word_width % 2 ))
        
        case $print_line_info in
            0) #如果终端宽度大小是双数
                case $print_word_info in
                    0) #如果字符宽度大小是双数
                        print_line_methon=2
                        ;;
                    1) #如果字符宽度大小是单数
                        print_line_methon=3
                        ;;
                esac
                ;;
            1) #如果终端宽度大小是单数数
                case $print_word_info in
                    0) #如果字符宽度大小是双数
                        print_line_methon=2
                        ;;
                    1) #如果字符宽度大小是单数
                        print_line_methon=3
                        ;;
                esac
                ;;
        esac

        print_line_to_shell_methon
    fi
}

#输出终端横线方法
function print_line_to_shell_methon()
{
    case $print_line_methon in
        1)
            shellwidth=$(stty size | awk '{print $2}') #获取终端宽度
            yes "-" | sed $shellwidth'q' | tr -d '\n' #输出横杠
            ;;
        2) #解决显示字符为单数时少显示一个字符导致不对成的问题
            echo "$(yes "-" | sed $shellwidth'q' | tr -d '\n')"$print_word_to_shell"$(yes "-" | sed $shellwidth'q' | tr -d '\n')"
            ;;
        3)
            echo "$(yes "-" | sed $shellwidth'q' | tr -d '\n')"$print_word_to_shell"$(yes "-" | sed $(( $shellwidth + 1 ))'q' | tr -d '\n')"
            ;;
    esac
    print_word_to_shell="" #清除已输出的内容
}

#手动指定python路径功能
function set_python_path()
{
    if [ -z "$@" ];then
        term_sd_notice "请输入python解释器的路径"
        term_sd_notice "提示:输入完后请回车保存,或者输入exit退出"
        read -p "===============================> " set_python_path_option
        if [ -z "$set_python_path_option" ];then
            term_sd_notice "未输入，请重试"
            set_python_path
        elif [ "$set_python_path_option" = "exit" ];then
            term_sd_notice "退出python路径指定功能"
        else
            term_sd_python_path="$set_python_path_option"
            echo $term_sd_python_path > ./term-sd/python-path.conf
            term_sd_notice "python解释器路径指定完成"
            term_sd_notice "提示:"
            term_sd_notice "使用--set-python-path重新设置python解释器路径"
            term_sd_notice "使用--unset-python-path删除python解释器路径设置"
        fi
    else #直接将选项后面的参数作为路径
        term_sd_notice "设置python解释器路径: $@"
        echo $@ > ./term-sd/python-path.conf
        term_sd_notice "python解释器路径指定完成"
        term_sd_notice "提示:"
        term_sd_notice "使用--set-python-path重新设置python解释器路径"
        term_sd_notice "使用--unset-python-path删除python解释器路径设置"
    fi
}

#手动指定pip路径功能
function set_pip_path()
{
    if [ -z "$@" ];then
        term_sd_notice "请输入pip的路径"
        term_sd_notice "提示:输入完后请回车保存,或者输入exit退出"
        read -p "===============================> " set_pip_path_option
        if [ -z "$set_pip_path_option" ];then
            term_sd_notice "未输入，请重试"
            set_pip_path
        elif [ "$set_pip_path_option" = "exit" ];then
            term_sd_notice "退出pip路径指定功能"
        else
            term_sd_pip_path="$set_pip_path_option"
            echo $term_sd_pip_path > ./term-sd/pip-path.conf
            term_sd_notice "pip路径指定完成"
            term_sd_notice "提示:"
            term_sd_notice "使用--set-pip-path重新设置pip路径"
            term_sd_notice "使用--unset-pip-path删除pip路径设置"
        fi
    else #直接将选项后面的参数作为路径
        term_sd_notice "设置pip路径: $@"
        echo $@ > ./term-sd/pip-path.conf
        term_sd_notice "pip路径指定完成"
        term_sd_notice "提示:"
        term_sd_notice "使用--set-pip-path重新设置pip路径"
        term_sd_notice "使用--unset-pip-path删除pip路径设置"
    fi
}

#term-sd格式化输出信息
function term_sd_notice()
{
    echo "[$(date "+%Y-%m-%d %H:%M:%S")][Term-SD]:: "$@""
}

#终端大小检测
function terminal_size_test()
{
    shellwidth=$(stty size | awk '{print $2}') #获取终端宽度，推荐85
    shellheight=$(stty size | awk '{print $1}') #获取终端高度，推荐35
    term_sd_notice "当前终端大小: $shellheight x $shellwidth"
    if [ $shellheight -lt 30 ] || [ $shellwidth -lt 75 ];then
        term_sd_notice "检测到终端大小过小"
        term_sd_notice "为了防止界面显示不全,建议调大终端大小"
        sleep 3
    fi
}

#term-sd网络检测功能(用来检测代理是否可用)
function term_sd_test_network()
{
    if which curl > /dev/null;then
        print_line_to_shell "测试网络环境"
        term_sd_notice "获取网络信息"
        curl ipinfo.io
        echo
        print_line_to_shell
        if [ $? = 0 ];then
            term_sd_notice "网络连接正常"

            #测试各个网站访问情况
            term_sd_notice "[1/4] 测试google访问情况"
            if curl google.com > /dev/null 2> /dev/null;then
                term_sd_test_network_1="成功"
            else
                term_sd_test_network_1="失败"
            fi
            term_sd_notice "[2/4] 测试huggingface访问情况"
            if curl huggingface.co > /dev/null 2> /dev/null;then
                term_sd_test_network_2="成功"
            else
                term_sd_test_network_2="失败"
            fi
            term_sd_notice "[3/4] 测试github访问情况"
            if curl github.com > /dev/null 2> /dev/null;then
                term_sd_test_network_3="成功"
            else
                term_sd_test_network_3="失败"
            fi
            term_sd_notice "[4/4] 测试ghproxy访问情况"
            if curl ghproxy.com > /dev/null 2> /dev/null;then
                term_sd_test_network_4="成功"
            else
                term_sd_test_network_4="失败"
            fi
            print_line_to_shell "网络测试结果"
            term_sd_notice "访问google: $term_sd_test_network_1"
            term_sd_notice "访问huggingface: $term_sd_test_network_2"
            term_sd_notice "访问github: $term_sd_test_network_3"
            term_sd_notice "访问ghproxy: $term_sd_test_network_4"
            print_line_to_shell
        else
            term_sd_notice "网络连接异常"
        fi
    else
        term_sd_notice "未安装curl,无法测试网络,请安装后重试"
    fi
    sleep 5
}

#term-sd准备环境功能
function term_sd_env_prepare()
{
    print_line_to_shell "Term-SD"

    #目录结构检测,防止用户直接运行Term-SD目录内的term-sd.sh
    term_sd_notice "Term-SD初始化中"
    if [ ! -d "./term-sd" ] && [ -d "./.git" ] && [ -d "./modules" ] && [ -f "./modules/init.sh" ] && [ -d "./extra" ] && [ -d "./other" ];then
        term_sd_notice "检测到目录错误"
        term_sd_notice "禁止用户直接在Term-SD目录里运行Term-SD"
        term_sd_notice "请将term-sd.sh文件复制到Term-SD目录外面(和Term-SD目录放在一起)"
        term_sd_notice "再运行目录外面的term-sd.sh"
        term_sd_notice "退出Term-SD"
        exit 1
    fi

    term_sd_process_user_input_early "$@" #处理用户输入

    term_sd_notice "检测依赖软件是否安装"
    missing_dep=""
    missing_dep_macos=""
    test_num=0
    test_num_macos=0
    term_sd_depend="git aria2c dialog" #term-sd依赖软件包
    term_sd_depend_macos="wget rustc cmake brew protoc"
    term_sd_install_path=$(pwd) #读取term-sd安装位置
    user_shell=$(echo $SHELL | awk -F "/" '{print $NF}') #读取用户所使用的shell

    #存在python自定义路径配置文件时自动读取到变量中
    if [ -f "./term-sd/python-path.conf" ];then
        term_sd_python_path=$(cat ./term-sd/python-path.conf)
    fi

    #存在pip自定义路径配置文件时自动读取到变量中
    if [ -f "./term-sd/pip-path.conf" ];then
        term_sd_pip_path=$(cat ./term-sd/pip-path.conf)
    fi

    #检测可用的python命令,并检测是否手动指定python路径
    if [ -z "$term_sd_python_path" ];then
        if python3 --version > /dev/null 2> /dev/null || python --version > /dev/null 2> /dev/null ;then #判断是否有可用的python
            test_num=$(( $test_num + 1 ))

            if [ ! -z "$(python3 --version 2> /dev/null)" ];then
                export term_sd_python_path=$(which python3)
            elif [ ! -z "$(python --version 2> /dev/null)" ];then
                export term_sd_python_path=$(which python)
            fi
        else
            missing_dep="$missing_dep python,"
        fi  
    else
        if which "$term_sd_python_path" > /dev/null 2> /dev/null ;then
            test_num=$(( $test_num + 1 ))
            term_sd_notice "使用自定义python解释器路径:$term_sd_python_path"
        else
            term_sd_notice "手动指定的python路径错误"
            term_sd_notice "提示:"
            term_sd_notice "使用--set-python-path重新设置python解释器路径"
            term_sd_notice "使用--unset-python-path删除python解释器路径设置"
            missing_dep="$missing_dep python,"
        fi
    fi

    #检测可用的pip命令,并检测是否手动指定pip路径
    if [ -z "$term_sd_pip_path" ];then
        if which pip > /dev/null 2> /dev/null ;then
            test_num=$(( $test_num + 1 ))
            export term_sd_pip_path=$(which pip)
        else
            missing_dep="$missing_dep pip,"
        fi
    else
        if which "$term_sd_pip_path" > /dev/null 2> /dev/null ;then
            test_num=$(( $test_num + 1 ))
            term_sd_notice "使用自定义pip路径:$term_sd_pip_path"
        else
            term_sd_notice "手动指定的pip路径错误"
            term_sd_notice "提示:"
            term_sd_notice "使用--set-pip-path重新设置pip路径"
            term_sd_notice "使用--unset-pip-path删除pip路径设置"
            missing_dep="$missing_dep pip,"
        fi
    fi

    #判断系统是否安装必须使用的软件
    for i in $term_sd_depend ; do
        if which $i > /dev/null 2> /dev/null ;then
            test_num=$(( $test_num + 1 ))
        else
            missing_dep="$missing_dep $i,"
        fi
    done


    #依赖检测(MacOS)
    if [ $(uname) = "Darwin" ];then
        for i in $term_sd_depend_macos ; do
            if which $i > /dev/null 2> /dev/null ;then
                test_num_macos=$(( $test_num_macos + 1 ))
            else
                #转换名称
                case $i in
                    rustc)
                        i=rust
                        ;;
                    brew)
                        i=homebrew
                        ;;
                    protoc)
                        i=protobuf
                        ;;
                esac
                missing_dep_macos="$missing_dep_macos $i,"
            fi
        done

        if [ $test_num_macos -ge 5 ];then
            print_line_to_shell "缺少以下依赖"
            echo $missing_dep_macos
            print_line_to_shell
            term_sd_notice "缺少依赖将影响ai软件的安装,请退出Term-SD并使用homebrew(如果没有homebrew,则先安装homebrew,再用homebrew去安装其他缺少依赖)安装缺少的依赖后重试"
            sleep 5
        fi
    fi

    #在使用http_proxy变量后,会出现ValueError: When localhost is not accessible, a shareable link must be created. Please set share=True
    #导致启动异常
    #需要设置no_proxy让localhost,127.0.0.1,::1避开http_proxy
    #详见https://github.com/microsoft/TaskMatrix/issues/250
    export no_proxy="localhost,127.0.0.1,::1" #除了避免http_proxy变量的影响,也避免了代理软件的影响(在启动a1111-sd-webui前开启代理软件可能会导致webui无法生图(启动后再开启没有影响),并报错,设置该变量后完美解决该问题)

    if [ -f "./term-sd/proxy.conf" ];then #读取代理设置并设置代理
        export http_proxy=$(cat ./term-sd/proxy.conf)
        export https_proxy=$(cat ./term-sd/proxy.conf)
        #export all_proxy=$(cat ./term-sd/proxy.conf)
        #代理变量的说明:https://blog.csdn.net/Dancen/article/details/128045261
    fi

    #设置启动时脚本路径
    export start_path=$(pwd)

    #设置虚拟环境
    if [ -f ./term-sd/term-sd-venv-disable.lock ];then #找到term-sd-venv-disable.lock文件,禁用虚拟环境
        export venv_active="1"
        export dialog_recreate_venv_button=""
        export dialog_rebuild_venv_button=""
    else
        export venv_active="0"
        export dialog_recreate_venv_button=""18" "修复venv虚拟环境"" #在启用venv后显示这些dialog按钮
        export dialog_rebuild_venv_button=""19" "重新构建venv虚拟环境""
    fi

    #启动terrm-sd
    if [ $test_num -ge 5 ];then
        term_sd_notice "检测完成"
        terminal_size_test #检测终端大小
        term_sd_install
        if [ -d "./term-sd/modules" ];then #找到目录后才启动
            term_sd_auto_update_trigger
            export term_sd_env_prepare_info=0 #用于检测term-sd的启动状态
            term_sd_process_user_input "$@" #处理用户输入
            source ./term-sd/modules/init.sh #加载term-sd模块
        else
            term_sd_notice "Term-SD模块丢失,\"输入./term-sd.sh --reinstall-term-sd\"重新安装Term-SD"
        fi
    else
        print_line_to_shell "缺少以下依赖"
        echo $missing_dep
        print_line_to_shell
        term_sd_notice "请安装缺少的依赖后重试"
        exit 1
    fi
}

#################################################

#term-sd版本
term_sd_version_="0.6.2"

#判断启动状态(在shell中,新变量的值为空,且不需要定义就可以使用,不像c语言中要求那么严格)
if [ ! -z $term_sd_env_prepare_info ] && [ $term_sd_env_prepare_info = 0 ];then #检测term-sd是直接启动还是重启
    #重启Term-SD
    print_line_to_shell "Term-SD"
    term_sd_notice "重启Term-SD中"
    source ./term-sd/modules/init.sh
    term_sd_notice "启动Term-SD中"
    term_sd_version
    _main_
else
    #正常启动
    term_sd_env_prepare "$@"
    term_sd_notice "启动Term-SD中"
    term_sd_version
    _main_
fi
