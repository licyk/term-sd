#!/bin/bash

# 启动参数处理
term_sd_launch_args_manager()
{
    local term_sd_launch_args_input
    local term_sd_launch_args

    # 用别的方法实现了getopt命令的功能
    # 加一个--null是为了增加一次循环,保证那些需要参数的选项能成功执行
    for i in "$@" "--null" ;do
        term_sd_launch_args=$i # 用作判断是参数还是选项

        # 参数检测部分
        if [ ! -z $term_sd_launch_args_input ];then
            if [ "$(term_sd_test_args "$term_sd_launch_args")" = 0 ];then # 测试输入值是参数还是选项
                term_sd_launch_args= # 检测到选项的下一项是选项,直接清除
            fi

            # 检测输入的选项
            case $term_sd_launch_args_input in
                --set-python-path)
                    set_python_path $term_sd_launch_args
                    ;;
                --extra)
                    term_sd_extra_scripts_name=$term_sd_launch_args
                    ;;
            esac
            term_sd_launch_args_input= # 清除选项,留给下一次判断
        fi

        ####################

        # 选项检测部分(如果选项要跟参数值,则将启动选项赋值给term_sd_launch_args_input)
        case $i in
            --help)
                term_sd_print_line
                term_sd_args_help
                term_sd_print_line
                exit 1
                ;;
            --reinstall-term-sd)
                term_sd_reinstall
                ;;
            --set-python-path)
                term_sd_launch_args_input="--set-python-path"
                ;;
            --unset-python-path)
                rm -f ./term-sd/config/python-path.conf
                term_sd_echo "已删除自定义python解释器路径配置"
                ;;
            --enable-new-bar)
                term_sd_echo "启用新的Term-SD初始化进度条"
                touch ./term-sd/config/term-sd-new-bar.lock
                ;;
            --disable-new-bar)
                term_sd_echo "禁用新的Term-SD初始化进度条"
                rm -f ./term-sd/config/term-sd-new-bar.lock
                ;;
            --enable-bar)
                rm -f ./term-sd/config/term-sd-no-bar.lock
                term_sd_echo "启用Term-SD初始化进度显示"
                ;;
            --disable-bar)
                touch ./term-sd/config/term-sd-no-bar.lock
                term_sd_echo "禁用Term-SD初始化进度显示"
                ;;
            --update-pip)
                export pip_manager_update=0
                export PIP_DISABLE_PIP_VERSION_CHECK=0
                term_sd_echo "进入虚拟环境时将更新pip软件包管理器"
                ;;
            --remove-term-sd)
                term_sd_remove
                ;;
            --quick-cmd)
                install_cmd_to_shell
                exit 1
                ;;
            --extra)
                term_sd_launch_args_input="--extra"
                ;;
            --debug)
                term_sd_echo "显示Term-SD调试信息"
                export term_sd_debug_mode=0
                ;;
            *)
                term_sd_unknown_args_echo $i
                ;;
        esac

    done
}

# 帮助信息
term_sd_args_help()
{
    cat<<EOF
    Term-SD启动参数使用方法:
    term-sd.sh [--help] [--extra script_name] [--reinstall-term-sd] [--remove-term-sd] [--quick-cmd] [--set-python-path python_path] [--unset-python-path] [--update-pip] [--enable-new-bar] [--disable-new-bar] [--enable-bar] [--disable-bar] [--debug]

    选项:
    --help
        显示启动参数帮助
    --extra script_name
        启动扩展脚本选择列表,当选项后面输入了脚本名,则直接启动指定的脚本,否则启动扩展脚本选择界面
    --reinstall-term-sd
        重新安装Term-SD
    --remove-term-sd
        卸载Term-SD
    --quick-cmd
        添加Term-SD快捷启动命令到shell
    --set-python-path python_path
        手动指定python解释器路径,当选项后面输入了路径,则直接使用输入的路径来设置python解释器路径(建议用\\把路径括起来),否则启动设置界面
    --unset-python-path
        删除自定义python解释器路径配置
    --update-pip
        进入虚拟环境时更新pip软件包管理器
    --enable-new-bar
        启用新的Term-SD初始化进度条
    --disable-new-bar
        禁用新的Term-SD初始化进度条
    --enable-bar
        启用Term-SD初始化进度显示(默认)
    --disable-bar
        禁用Term-SD初始化进度显示(加了进度显示只会降低Term-SD初始化速度)
    --debug
        显示Term-SD安装ai软件时使用的命令
EOF
}

# 扩展脚本启动功能
term_sd_extra_scripts_launch()
{
    if [ -z "$@" ];then
        term_sd_extra_scripts
    else
        if [ -f "./term-sd/extra/$(echo $@ | awk '{sub(".sh","")}1').sh" ];then
            term_sd_echo "启动$(echo $@ | awk '{sub(".sh","")}1')脚本中"
            source ./term-sd/extra/$(echo $@ | awk '{sub(".sh","")}1').sh
            term_sd_print_line
            term_sd_echo "退出$(echo $@ | awk '{sub(".sh","")}1')脚本"
            exit 1
        else
            term_sd_print_line
            term_sd_echo "未找到$(echo $@ | awk '{sub(".sh","")}1')脚本"
            term_sd_echo "退出Term-SD"
            exit 1
        fi
    fi
}

# 扩展脚本选择
term_sd_extra_scripts()
{
    local extra_script_dir_list
    local extra_script_dir_list_select

    extra_script_dir_list=$(ls -l "./term-sd/extra" --time-style=+"%Y-%m-%d" | awk -F ' ' ' { print $7 " " $6 } ')
    extra_script_dir_list_select=$(dialog --erase-on-exit --title "Term-SD" --backtitle "扩展脚本选项" --ok-label "确认" --cancel-label "取消" --menu "请选择要启动的脚本" $term_sd_dialog_height $term_sd_dialog_width $term_sd_dialog_menu_height \
        "Term-SD" "<---------" \
        $extra_script_dir_list \
        "退出" "<---------" \
        3>&1 1>&2 2>&3)

    case $? in
        0)
            case $extra_script_dir_list_select in
                Term-SD)
                    source ./term-sd/modules/init.sh
                    term_sd_version
                    main
                    ;;
                "退出")
                    term_sd_print_line
                    term_sd_echo "退出Term-SD"
                    exit 1
                    ;;
                *)
                    source ./term-sd/extra/$extra_script_dir_list_select
                    term_sd_print_line
                    term_sd_echo "退出$(echo $extra_script_dir_list_select | awk '{sub(".sh","")}1')脚本"
                    exit 1
            esac
            ;;
        *)
            term_sd_echo "退出Term-SD"
            exit 1
            ;;
    esac
}

# 格式化信息输出
term_sd_echo()
{
    echo -e "[\033[33m$(date "+%Y-%m-%d %H:%M:%S")\033[0m][\033[36mTerm-SD\033[0m]:: "$@""
}

# 键盘输入读取
term_sd_read()
{
    local term_sd_read_req
    read -p "===============================> " term_sd_read_req
    echo $term_sd_read_req
}

# 暂停运行(用于显示运行结果)
term_sd_pause()
{
    term_sd_print_line
    term_sd_echo "执行结束,请按回车键继续"
    read
}

# 测试输入值是参数还是选项,选项输出0,参数输出1(用于实现getopt命令的功能)
term_sd_test_args()
{
    echo $@ | awk -F ' ' '{for (i=1; i<=NF; i++) {if (substr($i, 1, 2) == "--") {print "0"} else {print "1"}}}'
}

# 提示未知启动参数
term_sd_unknown_args_echo()
{
    if [ "$(term_sd_test_args "$@")" = 0 ] && [ ! "$@" = "--null" ];then # 测试输入值是参数还是选项
        term_sd_echo "未知参数 \"$@\""
    fi
}

# 终端横线显示功能
term_sd_print_line()
{
    local shellwidth
    local print_word_to_shell
    local shell_word_width
    local shell_word_width_zh_cn
    local print_line_info
    local print_word_info
    local print_mode

    if [ -z "$@" ];then # 输出方法选择
        print_mode=1
    else
        shellwidth=$term_sd_shell_width # 获取终端宽度
        print_word_to_shell=$(echo "$@" | awk '{gsub(/ /,"-")}1') # 将空格转换为"-"
        shell_word_width=$(( $(echo "$print_word_to_shell" | wc -c) - 1 )) # 总共的字符长度
        shell_word_width_zh_cn=$(( $(echo "$print_word_to_shell" | awk '{gsub(/[a-zA-Z]/,"") ; gsub(/[0-9]/, "") ; gsub(/-/,"")}1' | wc -c) - 1 )) # 计算中文字符的长度
        shell_word_width=$(( $shell_word_width - $shell_word_width_zh_cn )) # 除去中文之后的长度
        # 中文的字符长度为3,但终端中只占2个字符位
        shell_word_width_zh_cn=$(( $shell_word_width_zh_cn / 3 * 2 )) # 转换中文在终端占用的实际字符长度
        shell_word_width=$(( $shell_word_width + $shell_word_width_zh_cn )) # 最终显示文字的长度

        # 横线输出长度的计算
        shellwidth=$(( ($shellwidth - $shell_word_width) / 2 )) # 除去输出字符后的横线宽度

        # 判断终端宽度大小是否是单双数
        print_line_info=$(( $shellwidth % 2 ))
        # 判断字符宽度大小是否是单双数
        print_word_info=$(( $shell_word_width % 2 ))
        
        case $print_line_info in
            0) # 如果终端宽度大小是双数
                case $print_word_info in
                    0) # 如果字符宽度大小是双数
                        print_mode=2
                        ;;
                    1) # 如果字符宽度大小是单数
                        print_mode=3
                        ;;
                esac
                ;;
            1) # 如果终端宽度大小是单数数
                case $print_word_info in
                    0) # 如果字符宽度大小是双数
                        print_mode=2
                        ;;
                    1) # 如果字符宽度大小是单数
                        print_mode=3
                        ;;
                esac
                ;;
        esac
    fi

    # 输出
    case $print_mode in
        1)
            shellwidth=$term_sd_shell_width # 获取终端宽度
            yes "-" | sed $shellwidth'q' | tr -d '\n' # 输出横杠
            ;;
        2) # 解决显示字符为单数时少显示一个字符导致不对成的问题
            echo "$(yes "-" | sed $shellwidth'q' | tr -d '\n')"$@"$(yes "-" | sed $shellwidth'q' | tr -d '\n')"
            ;;
        3)
            echo "$(yes "-" | sed $shellwidth'q' | tr -d '\n')"$@"$(yes "-" | sed $(( $shellwidth + 1 ))'q' | tr -d '\n')"
            ;;
    esac
}

# 自动更新触发功能
term_sd_auto_update_trigger()
{
    local term_sd_start_time
    local term_sd_end_time
    local term_sd_start_time_seconds
    local term_sd_end_time_seconds
    local term_sd_auto_update_time_span
    local term_sd_auto_update_time_set=3600 # 检查更新时间间隔

    if [ -f "./term-sd/config/term-sd-auto-update.lock" ] && [ -d "./term-sd/.git" ];then # 找到自动更新配置
        if [ -f "./term-sd/config/term-sd-auto-update-time.conf" ];then # 有上次运行记录
            term_sd_start_time=`date +'%Y-%m-%d %H:%M:%S'` # 查看当前时间
            term_sd_end_time=$(cat ./term-sd/config/term-sd-auto-update-time.conf) # 获取上次更新时间
            term_sd_start_time_seconds=$(date --date="$term_sd_start_time" +%s) # 转换时间单位
            term_sd_end_time_seconds=$(date --date="$term_sd_end_time" +%s)
            term_sd_auto_update_time_span=$(( $term_sd_start_time_seconds - $term_sd_end_time_seconds )) # 计算相隔时间
            if [ $term_sd_auto_update_time_span -ge $term_sd_auto_update_time_set ];then # 判断时间间隔
                term_sd_auto_update
                date +'%Y-%m-%d %H:%M:%S' > ./term-sd/config/term-sd-auto-update-time.conf # 记录自动更新功能的启动时间
            fi
        else # 没有时直接执行
            term_sd_auto_update
            date +'%Y-%m-%d %H:%M:%S' > ./term-sd/config/term-sd-auto-update-time.conf # 记录自动更新功能的启动时间
        fi
    fi
}

# term-sd自动更新功能
term_sd_auto_update()
{
    local term_sd_local_branch
    local term_sd_local_hash
    local term_sd_remote_hash

    term_sd_echo "检查更新中"
    term_sd_local_branch=$(git --git-dir="./term-sd/.git" branch | grep \* | awk -F "* " '{print $NF}') # term-sd分支
    term_sd_local_hash=$(git --git-dir="./term-sd/.git" rev-parse HEAD) # term-sd本地hash
    term_sd_remote_hash=$(git --git-dir="./term-sd/.git" ls-remote origin refs/remotes/origin/$term_sd_local_branch $term_sd_local_branch) # term-sd远程hash
    if [ $? = 0 ];then # 网络连接正常时再进行更新
        term_sd_remote_hash=$(echo $term_sd_remote_hash | awk '{print $1}')
        if [ ! $term_sd_local_hash = $term_sd_remote_hash ];then
            term_sd_echo "检测到Term-SD有新版本"
            term_sd_echo "是否选择更新(yes/no)?"
            term_sd_echo "提示:输入yes或no后回车"
            case $(term_sd_read) in
                yes|y|YES|Y)
                    term_sd_echo "更新Term-SD中"
                    cd ./term-sd
                    git pull
                    if [ $? = 0 ];then
                        cd ..
                        cp -f ./term-sd/term-sd.sh .
                        chmod +x ./term-sd.sh
                        term_sd_restart_info=0
                        term_sd_echo "Term-SD更新成功"
                    else
                        cd ..
                        term_sd_echo "Term-SD更新失败"
                    fi
                    ;;
            esac
        else
            term_sd_echo "Term-SD已经是最新版本"
        fi
    else
        term_sd_echo "Term-SD连接更新源失败,跳过更新"
        term_sd_echo "提示:请检查网络连接是否正常,若网络正常,可尝试更换更新源或使用科学上网解决"
    fi
}

# term-sd下载源选择
term_sd_install_mirror_select()
{
    term_sd_echo "请选择Term-SD下载源"
    term_sd_echo "1、github源"
    term_sd_echo "2、gitlab源"
    term_sd_echo "3、gitee源"
    term_sd_echo "4、代理源1(ghproxy.com)"
    term_sd_echo "5、代理源2(gitclone.com)"
    term_sd_echo "提示:输入数字后回车"
    case $(term_sd_read) in
        1)
            term_sd_echo "选择github源"
            term_sd_install_mirror="https://github.com/licyk/term-sd"
            ;;
        2)
            term_sd_echo "选择gitlab源"
            term_sd_install_mirror="https://gitlab.com/licyk/term-sd"
            ;;
        3)
            term_sd_echo "选择gitee源"
            term_sd_install_mirror="https://gitee.com/four-dishes/term-sd"
            ;;
        4)
            term_sd_echo "选择代理源1(ghproxy.com)"
            term_sd_install_mirror="https://ghproxy.com/github.com/licyk/term-sd"
            ;;
        5)
            term_sd_echo "选择代理源2(gitclone.com)"
            term_sd_install_mirror="https://gitclone.com/github.com/licyk/term-sd"
            ;;
        *)
            term_sd_echo "输入有误,请重试"
            term_sd_install_mirror_select
            ;;
    esac
}

# term-sd安装功能
term_sd_install()
{
    if [ ! -d "./term-sd" ];then
        term_sd_echo "检测到Term-SD未安装,是否进行安装(yes/no)?"
        term_sd_echo "提示:输入yes或no后回车"
        case $(term_sd_read) in
            yes|y|YES|Y)
                term_sd_install_mirror_select
                term_sd_echo "下载Term-SD中"
                git clone $term_sd_install_mirror
                if [ $? = 0 ];then
                    cp -f ./term-sd/term-sd.sh .
                    chmod +x ./term-sd.sh
                    term_sd_restart_info=0
                    term_sd_echo "Term-SD安装成功"
                    echo "3" > ./term-sd/config/term-sd-watch-retry.conf
                    export term_sd_cmd_retry=3
                    term_sd_echo "Term-SD命令执行监测设置已自动设置"
                    touch ./term-sd/config/term-sd-auto-update.lock
                    term_sd_echo "Term-SD自动更新已自动设置"
                else
                    term_sd_echo "Term-SD安装失败"
                    exit 1
                fi
                ;;
            *)
                exit 1
                ;;
        esac
    elif [ ! -d "./term-sd/.git" ];then
        term_sd_echo "检测到Term-SD的.git目录不存在,将会导致Term-SD无法更新,是否重新安装(yes/no)?"
        term_sd_echo "警告:该操作将永久删除Term-SD目录中的所有文件,包括ai软件下载的部分模型文件(存在于Term-SD目录中的\"cache\"文件夹,如有必要,请备份该文件夹)"
        term_sd_echo "提示:输入yes或no后回车"
        case $(term_sd_read) in
            yes|y|YES|Y)
                term_sd_install_mirror_select
                term_sd_echo "清除Term-SD文件中"
                rm -rf ./term-sd
                term_sd_echo "清除完成,开始安装Term-SD"
                git clone $term_sd_install_mirror
                if [ $? = 0 ];then
                    cp -f ./term-sd/term-sd.sh .
                    chmod +x ./term-sd.sh
                    term_sd_restart_info=0
                    term_sd_echo "Term-SD安装成功"
                    echo "3" > ./term-sd/config/term-sd-watch-retry.conf
                    export term_sd_cmd_retry=3
                    term_sd_echo "Term-SD命令执行监测设置已自动设置"
                    touch ./term-sd/config/term-sd-auto-update.lock
                    term_sd_echo "Term-SD自动更新已自动设置"
                else
                    term_sd_echo "Term-SD安装失败"
                    exit 1
                fi
                ;;
        esac
    fi
}

# term-sd重新安装功能
term_sd_reinstall()
{
    if which git > /dev/null 2>&1 ;then
        term_sd_echo "是否重新安装Term-SD(yes/no)?"
        term_sd_echo "警告:该操作将永久删除Term-SD目录中的所有文件,包括ai软件下载的部分模型文件(存在于Term-SD目录中的\"cache\"文件夹,如有必要,请备份该文件夹)"
        term_sd_echo "提示:输入yes或no后回车"
        case $(term_sd_read) in
            yes|y|YES|Y)
                term_sd_install_mirror_select
                term_sd_echo "清除Term-SD文件中"
                rm -rf ./term-sd
                term_sd_echo "清除完成,开始安装Term-SD"
                git clone $term_sd_install_mirror
                if [ $? = 0 ];then
                    cp -f ./term-sd/term-sd.sh .
                    chmod +x ./term-sd.sh
                    term_sd_restart_info=0
                    term_sd_echo "Term-SD安装成功"
                    echo "3" > ./term-sd/config/term-sd-watch-retry.conf
                    export term_sd_cmd_retry=3
                    term_sd_echo "Term-SD命令执行监测设置已自动设置"
                    touch ./term-sd/config/term-sd-auto-update.lock
                    term_sd_echo "Term-SD自动更新已自动设置"
                else
                    term_sd_echo "Term-SD安装失败"
                    exit 1
                fi
                ;;
            *)
                exit 1
                ;;
        esac
    fi
}

# term-sd卸载功能
term_sd_remove()
{
    term_sd_echo "是否卸载Term-SD"
    term_sd_echo "警告:该操作将永久删除Term-SD目录中的所有文件,包括ai软件下载的部分模型文件(存在于Term-SD目录中的\"cache\"文件夹,如有必要,请备份该文件夹)"
    term_sd_echo "提示:输入yes或no后回车"
    case $(term_sd_read) in
        y|yes|YES|Y)
            term_sd_echo "开始卸载Term-SD"
            rm -rf ./term-sd
            rm -rf ./term-sd.sh
            if [ $user_shell = bash ] || [ $user_shell = zsh ];then
                remove_config_from_shell
            fi
            term_sd_echo "Term-SD卸载完成"
            ;;
    esac
    exit 1
}

# term-sd添加快捷命令功能
install_cmd_to_shell()
{
    case $user_shell in
        bash|zsh)
            term_sd_echo "是否将Term-SD快捷启动指令添加到shell环境中?"
            term_sd_echo "添加后可使用\"term_sd\",\"tsd\"指令启动Term-SD"
            term_sd_echo "1、添加"
            term_sd_echo "2、删除"
            term_sd_echo "3、退出"
            term_sd_echo "提示:输入数字后回车"
            case $(term_sd_read) in
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
                    term_sd_echo "输入有误,请重试"
                    install_cmd_to_shell
                    ;;
            esac
            ;;
        *)
            term_sd_echo "不支持该shell"
            ;;
    esac
}

# term-sd快捷命令安装功能
install_config_to_shell()
{
    if cat ~/.${user_shell}rc | grep term_sd > /dev/null ;then
        term_sd_echo "配置已存在,添加前请删除原有配置"
    else
        echo "# Term-SD" >> ~/.${user_shell}rc
        echo "term_sd(){ local term_sd_start_path=\$(pwd) ; cd \"$(pwd)\" ; ./term-sd.sh \"\$@\" ; cd \"\$term_sd_start_path\" > /dev/null ; }" >> ~/.${user_shell}rc
        echo "alias tsd='term_sd'" >> ~/.${user_shell}rc
        term_sd_echo "配置添加完成,重启shell以生效"
    fi
}

# term-sd快捷命令卸载功能
remove_config_from_shell()
{
    sed -i '/# Term-SD/d' ~/.${user_shell}rc
    sed -i '/term_sd(){/d' ~/.${user_shell}rc
    sed -i '/alias tsd/d' ~/.${user_shell}rc
    term_sd_echo "配置已删除,重启shell以生效"
}

# 手动指定python路径功能
set_python_path()
{
    local set_python_path_option

    if [ -z "$*" ];then
        term_sd_echo "请输入python解释器的路径"
        term_sd_echo "提示:输入完后请回车保存,或者输入exit退出"
        read -p "===============================> " set_python_path_option
        if [ -z "$set_python_path_option" ];then
            term_sd_echo "未输入，请重试"
            set_python_path
        elif [ "$set_python_path_option" = "exit" ];then
            term_sd_echo "退出python路径指定功能"
        else
            term_sd_python_path="$set_python_path_option"
            echo $term_sd_python_path > ./term-sd/config/python-path.conf
            term_sd_echo "python解释器路径指定完成"
            term_sd_echo "提示:"
            term_sd_echo "使用--set-python-path重新设置python解释器路径"
            term_sd_echo "使用--unset-python-path删除python解释器路径设置"
        fi
    else # 直接将选项后面的参数作为路径
        term_sd_echo "设置python解释器路径: $@"
        echo $@ > ./term-sd/config/python-path.conf
        term_sd_echo "python解释器路径指定完成"
        term_sd_echo "提示:"
        term_sd_echo "使用--set-python-path重新设置python解释器路径"
        term_sd_echo "使用--unset-python-path删除python解释器路径设置"
    fi
}

#############################

term_sd_print_line "Term-SD"
term_sd_echo "Term-SD初始化中"

export term_sd_version_info="1.0.12" # term-sd版本
export user_shell=$(echo $SHELL | awk -F "/" '{print $NF}') # 读取用户所使用的shell
export start_path=$(pwd) # 设置启动时脚本路径
export PYTHONUTF8=1 # 强制Python解释器使用UTF-8编码来处理字符串,避免乱码问题
export PIP_TIMEOUT=120 # 设置pip的超时时间
export PIP_RETRIES=5 # 设置pip的重试次数
export PIP_DISABLE_PIP_VERSION_CHECK # 禁用pip版本版本检查
export pip_manager_update # Term-SD自动更新pip
export term_sd_debug_mode # # debug模式
export term_sd_delimiter
missing_depend_info=0 # 依赖缺失状态
missing_depend_macos_info=0
term_sd_extra_scripts_name="null" # Term-SD扩展脚本
term_sd_restart_info=1 # term-sd重启
term_sd_shell_width=$(stty size | awk '{print $2}') # 获取终端宽度
term_sd_shell_height=$(stty size | awk '{print $1}') # 获取终端高度

# 在使用http_proxy变量后,会出现ValueError: When localhost is not accessible, a shareable link must be created. Please set share=True
# 导致启动异常
# 需要设置no_proxy让localhost,127.0.0.1,::1避开http_proxy
# 详见https://github.com/microsoft/TaskMatrix/issues/250
export no_proxy="localhost,127.0.0.1,::1" # 除了避免http_proxy变量的影响,也避免了代理软件的影响(在启动a1111-sd-webui前开启代理软件可能会导致webui无法生图(启动后再开启没有影响),并报错,设置该变量后完美解决该问题)

# 检测term-sd是直接启动还是重启
case $term_sd_env_prepare_info in
    0) # 检测到是重启
        term_sd_echo "重启Term-SD中"
        ;;
    *)
        term_sd_launch_args_manager "$@" # 处理用户输入的参数
        ;;
esac

# 目录结构检测,防止用户直接运行Term-SD目录内的term-sd.sh
if [ ! -d "./term-sd" ] && [ -d "./.git" ] && [ -d "./modules" ] && [ -f "./modules/init.sh" ] && [ -d "./extra" ] && [ -d "./other" ];then
    term_sd_echo "检测到目录错误"
    term_sd_echo "禁止用户直接在Term-SD目录里运行Term-SD"
    term_sd_echo "请将term-sd.sh文件复制到Term-SD目录外面(和Term-SD目录放在一起)"
    term_sd_echo "再运行目录外面的term-sd.sh"
    term_sd_echo "退出Term-SD"
    exit 1
fi

# dialog使用文档https://manpages.debian.org/bookworm/dialog/dialog.1.en.html
# 设置dialog界面的大小
export term_sd_dialog_menu_height=10 #dialog高度条目

if [ $(( $term_sd_shell_width -20 )) -le 12 ];then # dialog宽度
    export term_sd_dialog_width=-1
else
    export term_sd_dialog_width=$(( $term_sd_shell_width -20 ))
fi

if [ $(( $term_sd_shell_height - 6 )) -le 6 ];then # dialog高度
    export term_sd_dialog_height=-1
else
    export term_sd_dialog_height=$(( $term_sd_shell_height - 6 ))
fi

# 分隔符变量
term_sd_delimiter=$(yes "-" | sed $(( $term_sd_dialog_width - 4 ))'q' | tr -d '\n') # 分隔符号

# 设置debug模式的环境变量设置
if [ -z $term_sd_debug_mode ];then
    term_sd_debug_mode=1
fi

# 设置pip自动更新的环境变量设置
if [ -z $pip_manager_update ];then
    pip_manager_update=1
    PIP_DISABLE_PIP_VERSION_CHECK=1
fi

# 存在python自定义路径配置文件时自动读取到变量中
if [ -f "./term-sd/config/python-path.conf" ];then
    export term_sd_python_path=$(cat ./term-sd/config/python-path.conf)
fi

if [ -f "./term-sd/config/proxy.conf" ];then # 读取代理设置并设置代理
    export http_proxy=$(cat ./term-sd/config/proxy.conf)
    export https_proxy=$(cat ./term-sd/config/proxy.conf)
    # 代理变量的说明:https://blog.csdn.net/Dancen/article/details/128045261
fi

# 设置安装重试次数
if [ -f "./term-sd/config/term-sd-watch-retry.conf" ];then
    export term_sd_cmd_retry=$(cat ./term-sd/config/term-sd-watch-retry.conf)
else # 没有配置文件时使用默认值
    export term_sd_cmd_retry=0
fi

# 设置安装ai软件时下载模型的线程数
if [ -f "./term-sd/config/aria2-thread.conf" ];then
    export aria2_multi_threaded=$(cat ./term-sd/config/aria2-thread.conf)
else
    export aria2_multi_threaded="-x 1"
fi

# 设置虚拟环境
if [ -f "./term-sd/config/term-sd-venv-disable.lock" ];then # 找到term-sd-venv-disable.lock文件,禁用虚拟环境
    export venv_setup_status="1"
else
    export venv_setup_status="0"
fi

# 设置安装模式
if [ -f "./term-sd/config/term-sd-disable-strict-install-mode.lock" ];then
    export term_sd_install_mode=1
else
    export term_sd_install_mode=0
fi

# cuda内存分配方案设置
if [ -f "./term-sd/config/cuda-memory-alloc.conf" ];then
    export PYTORCH_CUDA_ALLOC_CONF=$(cat ./term-sd/config/cuda-memory-alloc.conf)
fi

# 设置pip镜像源
if [ -f "./term-sd/config/disable-pip-mirror.lock" ];then
    export PIP_INDEX_URL="https://pypi.python.org/simple"
    export PIP_EXTRA_INDEX_URL=""
    export PIP_FIND_LINKS="https://download.pytorch.org/whl/torch_stable.html"
else
    export PIP_INDEX_URL="https://mirrors.bfsu.edu.cn/pypi/web/simple"
    export PIP_EXTRA_INDEX_URL="https://mirrors.hit.edu.cn/pypi/web/simple https://pypi.tuna.tsinghua.edu.cn/simple https://mirror.nju.edu.cn/pypi/web/simple"
    export PIP_FIND_LINKS="https://mirrors.aliyun.com/pytorch-wheels/torch_stable.html https://mirror.sjtu.edu.cn/pytorch-wheels/torch_stable.html"
fi

# 依赖检测
case $term_sd_env_prepare_info in # 判断启动状态(在shell中,新变量的值为空,且不需要定义就可以使用,不像c语言中要求那么严格)
    0)
        ;;
    *)
        term_sd_echo "检测依赖软件是否安装"
        term_sd_depend="git aria2c dialog curl" # term-sd依赖软件包
        term_sd_depend_macos="wget rustc cmake brew protoc gawk" # term-sd依赖软件包(MacOS)

        # 检测可用的python命令,并检测是否手动指定python路径
        if [ -z "$term_sd_python_path" ];then
            if python3 --version > /dev/null 2>&1 || python --version > /dev/null 2>&1 ;then # 判断是否有可用的python
                if [ ! -z "$(python3 --version 2> /dev/null)" ];then
                    export term_sd_python_path=$(which python3)
                elif [ ! -z "$(python --version 2> /dev/null)" ];then
                    export term_sd_python_path=$(which python)
                fi
            else
                missing_depend_info=1
                missing_depend="$missing_depend python,"
            fi  
        else
            if which "$term_sd_python_path" > /dev/null 2>&1 ;then
                term_sd_echo "使用自定义python解释器路径:$term_sd_python_path"
            else
                term_sd_echo "手动指定的python路径错误"
                term_sd_echo "提示:"
                term_sd_echo "使用--set-python-path重新设置python解释器路径"
                term_sd_echo "使用--unset-python-path删除python解释器路径设置"
                missing_depend_info=1
                missing_depend="$missing_depend python,"
            fi
        fi

        # 检测可用的pip命令
        if ! "$term_sd_python_path" -m pip -V > /dev/null 2>&1 ;then
            missing_depend_info=1
            missing_depend="$missing_depend pip,"
        fi

        #判断系统是否安装必须使用的软件
        for i in $term_sd_depend ; do
            if ! which $i > /dev/null 2>&1 ;then
                missing_depend="$missing_depend $i,"
                missing_depend_info=1
            fi
        done

        #依赖检测(MacOS)
        if [ $(uname) = "Darwin" ];then
            for i in $term_sd_depend_macos ; do
                if which $i > /dev/null 2>&1 ;then
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
                    missing_depend_macos="$missing_depend_macos $i,"
                fi
            done

            if [ $missing_depend_macos_info = 0 ];then
                alias awk='gawk' #将gawk链接到awk命令中
            else
                print_line_to_shell "缺少以下依赖"
                echo $missing_depend_macos
                print_line_to_shell
                term_sd_notice "缺少依赖将影响ai软件的安装,请退出Term-SD并使用homebrew(如果没有homebrew,则先安装homebrew,再用homebrew去安装其他缺少依赖)安装缺少的依赖后重试"
                sleep 5
            fi
        fi

        # 判断依赖检测结果
        if [ $missing_depend_info = 0 ];then
            term_sd_echo "依赖检测完成,无缺失依赖"
            term_sd_install
            if [ -d "./term-sd/modules" ];then # 找到目录后才启动
                term_sd_auto_update_trigger
                export term_sd_env_prepare_info=0 # 用于检测term-sd的启动状态
            else
                term_sd_echo "Term-SD模块丢失,\"输入./term-sd.sh --reinstall-term-sd\"重新安装Term-SD"
                exit 1
            fi
        else
            term_sd_print_line "缺少以下依赖"
            echo $missing_depend
            term_sd_print_line
            term_sd_echo "请安装缺少的依赖后重试"
            exit 1
        fi
        ;;
esac

# 放在依赖检测之后,解决一些奇怪的问题
# term-sd设置路径环境变量
if [ ! -f "./term-sd/config/disable-cache-path-redirect.lock" ];then
    export CACHE_HOME="$start_path/term-sd/cache"
    export HF_HOME="$start_path/term-sd/cache/huggingface"
    export MATPLOTLIBRC="$start_path/term-sd/cache"
    export MODELSCOPE_CACHE="$start_path/term-sd/cache/modelscope/hub"
    export MS_CACHE_HOME="$start_path/term-sd/cache/modelscope/hub"
    export SYCL_CACHE_DIR="$start_path/term-sd/cache/libsycl_cache"
    export TORCH_HOME="$start_path/term-sd/cache/torch"
    export U2NET_HOME="$start_path/term-sd/cache/u2net"
    export XDG_CACHE_HOME="$start_path/term-sd/cache"
    export PIP_CACHE_DIR="$start_path/term-sd/cache/pip"
    export PYTHONPYCACHEPREFIX="$start_path/term-sd/cache/pycache"
    # export TRANSFORMERS_CACHE="$start_path/term-sd/cache/huggingface/transformers"
fi

#############################

# 自动更新成功时重载环境
if [ $term_sd_restart_info = 0 ];then
    source ./term-sd.sh
fi

case $term_sd_extra_scripts_name in
    null)
        source ./term-sd/modules/init.sh # 加载term-sd模块
        ;;
    *)
        term_sd_extra_scripts_launch $term_sd_extra_scripts_name
        ;;
esac

# 启动terrm-sd
term_sd_echo "启动Term-SD中"
term_sd_version
main
