#!/bin/bash

#term-sd处理用户输入功能(早期进行配置时使用)
function term_sd_process_user_input_early()
{
    for term_sd_launch_input in "$@" ;do
        case $term_sd_launch_input in
        "--help")
        term_sd_notice "启动参数使用方法:"
        echo "  term-sd.sh [--help] [--extra] [--multi-threaded-download] [--enable-auto-update] [--disable-auto-update] [--reinstall-term-sd] [--remove-term-sd] [--test-network] [--quick-cmd] [--set-python-path] [--set-pip-path] [--unset-python-path] [--unset-pip-path]"
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
        echo "  --test-network"
        echo "        测试网络环境,用于测试代理是否可用,需安装curl"
        echo "  --quick-cmd"
        echo "        添加Term-SD快捷启动命令到shell"
        echo "  --set-python-path"
        echo "        手动指定python解释器路径"
        echo "  --set-pip-path"
        echo "        手动指定pip路径"
        echo "  --unset-python-path"
        echo "        删除自定义python解释器路径配置"
        echo "  --unset-pip-path"
        echo "        删除自定义pip解释器路径配置"
        echo "  --update-pip"
        echo "        进入虚拟环境时更新pip软件包管理器"
        print_line_to_shell
        exit 1
        ;;
        "--enable-auto-update")
        term_sd_notice "启用Term-SD自动检查更新功能"
        touch ./term-sd/term-sd-auto-update.lock
        ;;
        "--disable-auto-update")
        term_sd_notice "禁用Term-SD自动检查更新功能"
        rm -rf ./term-sd/term-sd-auto-update.lock
        rm -rf ./term-sd/term-sd-auto-update-time.conf
        ;;
        "--set-python-path")
        set_python_path
        ;;
        "--set-pip-path")
        set_pip_path
        ;;
        "--unset-python-path")
        rm -f ./term-sd/python-path.conf
        term_sd_notice "已删除自定义python解释器路径配置"
        ;;
        "--unset-pip-path")
        rm -f ./term-sd/pip-path.conf
        term_sd_notice "已删除自定义pip解释器路径配置"
        ;;
        esac
    done
}

#处理用户输入的参数(较晚启动)
function term_sd_process_user_input()
{
    export pip_manager_update=1
    export aria2_multi_threaded=""
    for term_sd_launch_input in "$@" ;do
        case $term_sd_launch_input in
        "--remove-term-sd")
        remove_term_sd
        ;;
        "--quick-cmd")
        install_cmd_to_shell
        exit 1
        ;;
        "--multi-threaded-download")
        term_sd_notice "安装过程中启用多线程下载模型"
        export aria2_multi_threaded="-x 8"
        ;;
        "--update-pip")
        export pip_manager_update=0
        term_sd_notice "进入虚拟环境时将更新pip软件包管理器"
        ;;
        "--test-network")
        term_sd_test_network
        ;;
        "--extra")
        term_sd_extra_scripts
        ;;
        esac
    done
}

#扩展脚本列表
function term_sd_extra_scripts()
{
    extra_script_dir_list=$(ls -l "./term-sd/extra" --time-style=+"%Y-%m-%d" | awk -F ' ' ' { print $7 " " $6 } ')
    extra_script_dir_list_=$(dialog --clear --title "Term-SD" --backtitle "扩展脚本选项" --ok-label "确认" --cancel-label "取消" --menu "请选择要启动的脚本" 25 70 10 \
        "term-sd" "<------------" \
        $extra_script_dir_list \
        "退出" "<------------" \
        3>&1 1>&2 2>&3)

    if [ $? = 0 ];then
        if [ $extra_script_dir_list_ = "term-sd" ];then
            source ./term-sd/modules/init.sh
        elif [ $extra_script_dir_list_ = "退出" ];then
            exit 1
        else
            source ./term-sd/extra/$extra_script_dir_list_
        fi
    fi
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
            if [ ! -z $term_sd_auto_update_option ];then
                if [ $term_sd_auto_update_option = yes ] || [ $term_sd_auto_update_option = y ] || [ $term_sd_auto_update_option = YES ] || [ $term_sd_auto_update_option = Y ];then
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
                fi
            fi
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
    if [ ! -z $term_sd_auto_update_option ];then
        if [ $term_sd_auto_update_option = yes ] || [ $term_sd_auto_update_option = y ] || [ $term_sd_auto_update_option = YES ] || [ $term_sd_auto_update_option = Y ];then
            term_sd_notice "修复Term-SD更新中"
            cd ./term-sd
            term_sd_local_main_branch=$(git branch -a | grep HEAD | awk -F'/' '{print $NF}') #term-sd主分支
            git checkout $term_sd_local_main_branch
            git reset --hard HEAD
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
        fi
    fi
}

#term-sd安装功能
function term_sd_install()
{
    term_sd_install_option=""
    if [ ! -d "./term-sd" ];then
        term_sd_notice "检测到Term-SD未安装,是否进行安装(yes/no)?"
        term_sd_notice "提示:输入yes或no后回车"
        read -p "===============================> " term_sd_install_option
        if [ ! -z $term_sd_install_option ];then
            if [ $term_sd_install_option = yes ] || [ $term_sd_install_option = y ] || [ $term_sd_install_option = YES ] || [ $term_sd_install_option = Y ];then
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
            else
                exit 1
            fi
        else
            exit 1
        fi
    elif [ ! -d "./term-sd/.git" ];then
        term_sd_notice "检测到Term-SD的.git目录不存在,将会导致Term-SD无法更新,是否重新安装(yes/no)?"
        term_sd_notice "提示:输入yes或no后回车"
        read -p "===============================> " term_sd_install_option
        if [ ! -z $term_sd_install_option ];then
            if [ $term_sd_install_option = yes ] || [ $term_sd_install_option = y ] || [ $term_sd_install_option = YES ] || [ $term_sd_install_option = Y ];then
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
            fi
        fi
    fi
}

#term-sd重新安装功能
function term_sd_reinstall()
{
    term_sd_install_option=""
    for term_sd_launch_input in "$@" ;do
        case $term_sd_launch_input in
        "--reinstall-term-sd")
        term_sd_notice "是否重新安装Term-SD(yes/no)?"
        term_sd_notice "提示:输入yes或no后回车"
        read -p "===============================> " term_sd_install_option
        if [ ! -z $term_sd_install_option ];then
            if [ $term_sd_install_option = yes ] || [ $term_sd_install_option = y ] || [ $term_sd_install_option = YES ] || [ $term_sd_install_option = Y ];then
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
    term_sd_notice "请选择Term-SD下载源"
    term_sd_notice "1、github源"
    term_sd_notice "2、gitlab源"
    term_sd_notice "3、gitee源"
    term_sd_notice "4、代理源(ghproxy.com)"
    term_sd_notice "提示:输入数字后回车"
    read -p "===============================> " term_sd_install_option
    if [ ! -z $term_sd_install_option ];then
        if [ $term_sd_install_option = 1 ];then
            term_sd_notice "选择github源"
            term_sd_install_mirror="https://github.com/licyk/term-sd"
        elif [ $term_sd_install_option = 2 ];then
            term_sd_notice "选择gitlab源"
            term_sd_install_mirror="https://gitlab.com/licyk/term-sd"
        elif [ $term_sd_install_option = 3 ];then
            term_sd_notice "选择gitee源"
            term_sd_install_mirror="https://gitee.com/four-dishes/term-sd"
        elif [ $term_sd_install_option = 4 ];then
            term_sd_notice "选择代理源(ghproxy.com)"
            term_sd_install_mirror="https://ghproxy.com/https://github.com/licyk/term-sd"
        else
            term_sd_notice "输入有误,请重试"
            term_sd_install_mirror_select
        fi
    else
        term_sd_notice "未输入,请重试"
        term_sd_install_mirror_select
    fi
}

#term-sd卸载功能
function remove_term_sd()
{
    remove_term_sd_option=""
    term_sd_notice "是否卸载Term-SD"
    term_sd_notice "提示:输入yes或no后回车"
    read -p "===============================> " remove_term_sd_option
    if [ ! -z  $remove_term_sd_option ];then
        if [ $remove_term_sd_option = yes ] || [ $remove_term_sd_option = y ] || [ $remove_term_sd_option = YES ] || [ $remove_term_sd_option = Y ];then
            term_sd_notice "开始卸载Term-SD"
            rm -rf ./term-sd
            rm -rf ./term-sd.sh
            user_shell=$(echo $SHELL | awk -F "/" '{print $NF}') #读取用户所使用的shell
            if [ $user_shell = bash ] || [ $user_shell = zsh ];then
                cd ~
                sed -i '/termsd(){/d' ."$user_shell"rc
                sed -i '/alias tsd/d' ."$user_shell"rc
                cd - > /dev/null
            fi
            term_sd_notice "Term-SD卸载完成"
        fi
    fi
    exit 1
}

#term-sd添加快捷命令功能
function install_cmd_to_shell()
{
    if [ $user_shell = bash ] || [ $user_shell = zsh ];then
        term_sd_notice "是否将Term-SD快捷启动指令添加到shell环境中?"
        term_sd_notice "添加后可使用\"termsd\"指令启动Term-SD"
        term_sd_notice "1、添加"
        term_sd_notice "2、删除"
        term_sd_notice "3、退出"
        term_sd_notice "提示:输入数字后回车"
        read -p "===============================> " install_to_shell_option

        if [ ! -z $install_to_shell_option ];then
            if [ $install_to_shell_option = 1 ];then
                install_config_to_shell
            elif [ $install_to_shell_option = 2 ];then
                remove_config_from_shell
            elif [ $install_to_shell_option = 3 ];then
                exit 1
            else
                term_sd_notice "输入有误,请重试"
                install_cmd_to_shell
            fi
        else
            term_sd_notice "未输入,请重试"
            install_cmd_to_shell
        fi
    else
        term_sd_notice "不支持该shell"
    fi
}

#term-sd快捷命令安装功能
function install_config_to_shell()
{
    #将要向.bashrc写入的配置
    term_sd_shell_config="termsd(){ term_sd_start_path=\$(pwd) ; cd \"$term_sd_install_path\" ; ./term-sd.sh \"\$@\" ; cd \"\$term_sd_start_path\" > /dev/null ; }"
    cd ~
    if [ $user_shell = bash ] || [ $user_shell = zsh ];then
        if cat ./."$user_shell"rc | grep termsd > /dev/null ;then
            term_sd_notice "配置已存在,添加前请删除原有配置"
        else
            echo $term_sd_shell_config >> ."$user_shell"rc
            echo "alias tsd='termsd'" >> ."$user_shell"rc
            term_sd_notice "配置添加完成,重启shell以生效"
        fi
    fi
    cd - > /dev/null
}

#term-sd快捷命令卸载功能
function remove_config_from_shell()
{
    cd ~
    sed -i '/termsd(){/d' ."$user_shell"rc
    sed -i '/alias tsd/d' ."$user_shell"rc
    term_sd_notice "配置已删除,重启shell以生效"
    cd - > /dev/null
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
        
        if [ $print_line_info = 0 ];then #如果终端宽度大小是双数
            if [ $print_word_info = 0 ];then #如果字符宽度大小是双数
                print_line_methon=2
            elif [ $print_word_info = 1 ];then #如果字符宽度大小是单数
                print_line_methon=3
            fi
        elif [ $print_line_info = 1 ];then #如果终端宽度大小是单数数
            if [ $print_word_info = 0 ];then #如果字符宽度大小是双数
                print_line_methon=2
            elif [ $print_word_info = 1 ];then #如果字符宽度大小是单数
                print_line_methon=3
            fi
        fi

        print_line_to_shell_methon
    fi
}

#输出终端横线方法
function print_line_to_shell_methon()
{
    if [ $print_line_methon = 1 ];then
        shellwidth=$(stty size | awk '{print $2}') #获取终端宽度
        yes "-" | sed $shellwidth'q' | tr -d '\n' #输出横杠
    elif [ $print_line_methon = 2 ];then #解决显示字符为单数时少显示一个字符导致不对成的问题
        echo "$(yes "-" | sed $shellwidth'q' | tr -d '\n')"$print_word_to_shell"$(yes "-" | sed $shellwidth'q' | tr -d '\n')"
    elif [ $print_line_methon = 3 ];then
        echo "$(yes "-" | sed $shellwidth'q' | tr -d '\n')"$print_word_to_shell"$(yes "-" | sed $(( $shellwidth + 1 ))'q' | tr -d '\n')"
    fi
    print_word_to_shell="" #清除已输出的内容
}

#手动指定python路径功能
function set_python_path()
{
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
        echo $term_sd_python_path > python-path.conf
        mv -f ./python-path.conf ./term-sd/
        term_sd_notice "python解释器路径指定完成"
        term_sd_notice "提示:"
        term_sd_notice "使用--set-pip-path重新设置pip路径"
        term_sd_notice "使用--unset-pip-path删除pip路径设置"
    fi
}

#手动指定python路径功能
function set_pip_path()
{
    term_sd_notice "请输入python解释器的路径"
    term_sd_notice "提示:输入完后请回车保存,或者输入exit退出"
    read -p "===============================> " set_pip_path_option
    if [ -z "$set_pip_path_option" ];then
        term_sd_notice "未输入，请重试"
        set_pip_path
    elif [ "$set_pip_path_option" = "exit" ];then
        term_sd_notice "退出pip路径指定功能"
    else
        term_sd_pip_path="$set_pip_path_option"
        echo $term_sd_pip_path > pip-path.conf
        mv -f ./pip-path.conf ./term-sd/
        term_sd_notice "python解释器路径指定完成"
        term_sd_notice "提示:"
        term_sd_notice "使用--set-python-path重新设置python解释器路径"
        term_sd_notice "使用--unset-python-path删除python解释器路径设置"
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
    test_num=0
    temr_sd_depend="git aria2c dialog" #term-sd依赖软件包
    term_sd_install_path=$(pwd) #读取term-sd安装位置
    user_shell=$(echo $SHELL | awk -F "/" '{print $NF}') #读取用户所使用的shell

    #检测用户是否进行指定python运行路径
    for term_sd_launch_input in "$@" ;do
        case $term_sd_launch_input in
        "--set-python-path")
        set_python_path
        ;;
        "--set-pip-path")
        set_pip_path
        ;;
        "--unset-python-path")
        rm -f ./term-sd/python-path.conf
        term_sd_notice "已删除自定义python解释器路径配置"
        ;;
        "--unset-pip-path")
        rm -f ./term-sd/pip-path.conf
        term_sd_notice "已删除自定义pip解释器路径配置"
        ;;
        esac
    done

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
    for term_sd_depend_ in $temr_sd_depend ; do
        if which $term_sd_depend_ > /dev/null 2> /dev/null ;then
            test_num=$(( $test_num + 1 ))
        else
            missing_dep="$missing_dep $term_sd_depend_,"
        fi
    done

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
        term_sd_reinstall "$@"
        term_sd_install
        if [ -d "./term-sd/modules" ];then #找到目录后才启动
            term_sd_auto_update_trigger
            export term_sd_env_prepare_info=0 #用于检测term-sd的启动状态
            term_sd_process_user_input "$@"
            source ./term-sd/modules/init.sh
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
term_sd_version_="0.5.4"

#判断启动状态(在shell中,新变量的值为空,且不需要定义就可以使用,不像c语言中要求那么严格)
if [ ! -z $term_sd_env_prepare_info ] && [ $term_sd_env_prepare_info = 0 ];then #检测term-sd是直接启动还是重启
    #重启Term-SD
    print_line_to_shell "Term-SD"
    term_sd_notice "重启Term-SD中"
    source ./term-sd/modules/init.sh
else
    #正常启动
    term_sd_env_prepare "$@"
fi
