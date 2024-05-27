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
                --bar)
                    term_sd_loading_bar_setting $term_sd_launch_args
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
                exit 0
                ;;
            --reinstall-term-sd)
                # 防止重启后再执行重装
                case $term_sd_reinstall_info in
                    0)
                        ;;
                    *)
                        term_sd_reinstall_info=0
                        term_sd_reinstall
                        ;;
                esac
                ;;
            --set-python-path)
                term_sd_launch_args_input="--set-python-path"
                ;;
            --unset-python-path)
                rm -f term-sd/config/python-path.conf
                term_sd_echo "已删除自定义 Python 解释器路径配置"
                ;;
            --bar)
                term_sd_launch_args_input="--bar"
                ;;
            --update-pip)
                export pip_manager_update=0
                export PIP_DISABLE_PIP_VERSION_CHECK=0
                term_sd_echo "进入虚拟环境时将更新 Pip 软件包管理器"
                ;;
            --remove-term-sd)
                term_sd_remove
                ;;
            --quick-cmd)
                install_cmd_to_shell
                exit 0
                ;;
            --extra)
                term_sd_launch_args_input="--extra"
                ;;
            --debug)
                term_sd_echo "显示 Term-SD 调试信息"
                export term_sd_debug_mode=0
                ;;
            --unset-tcmalloc)
                use_tcmalloc=1
                term_sd_echo "禁用加载 TCMalloc 内存优化"
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
        term-sd.sh [--help] [--extra script_name] [--reinstall-term-sd] [--remove-term-sd] [--quick-cmd] [--set-python-path python_path] [--unset-python-path] [--update-pip] [--bar display_mode] [--debug]

    选项:
        --help
            显示启动参数帮助
        --extra script_name
            启动扩展脚本选择列表, 当选项后面输入了脚本名, 则直接启动指定的脚本, 否则启动扩展脚本选择界面
        --reinstall-term-sd
            重新安装 Term-SD
        --remove-term-sd
            卸载 Term-SD
        --quick-cmd
            添加 Term-SD 快捷启动命令到 Shell
        --set-python-path python_path
            手动指定 Python 解释器路径, 当选项后面输入了路径, 则直接使用输入的路径来设置Python 解释器路径 (建议用" "把路径括起来, 防止路径输入错误), 否则启动设置界面
        --unset-python-path
            删除自定义 Python 解释器路径配置
        --update-pip
            进入虚拟环境时更新 Pip 软件包管理器
        --bar display_mode
            设置 Term-SD 初始化进度条的显示样式, 有以下显示模式:
                none: 禁用进度条显示
                normal: 使用默认的显示模式
                new: 使用新的进度条显示
        --debug
            显示 Term-SD 安装 AI 软件时使用的命令
        --unset-tcmalloc
            禁用加载内存优化
EOF
}

# 扩展脚本启动功能
term_sd_extra_scripts_launch()
{
    if [ -z "$*" ];then
        term_sd_extra_scripts
    else
        if [ -f "term-sd/extra/$(echo $@ | awk '{sub(".sh","")}1').sh" ];then
            term_sd_print_line "$(echo $@ | awk '{sub(".sh","")}1') 脚本启动"
            term_sd_echo "启动 $(echo $@ | awk '{sub(".sh","")}1') 脚本中"
            . ./term-sd/extra/$(echo $@ | awk '{sub(".sh","")}1').sh
            term_sd_print_line
            term_sd_echo "退出 $(echo $@ | awk '{sub(".sh","")}1') 脚本"
            exit 0
        else
            term_sd_print_line
            term_sd_echo "未找到 $(echo $@ | awk '{sub(".sh","")}1') 脚本"
            term_sd_echo "退出 Term-SD"
            exit 1
        fi
    fi
}

# 扩展脚本选择
term_sd_extra_scripts()
{
    local extra_script_dir_list
    local extra_script_dir_list_select

    extra_script_dir_list=$(ls -l "term-sd/extra" --time-style=+"%Y-%m-%d" | awk -F ' ' ' { print $7 " " $6 } ')
    extra_script_dir_list_select=$(dialog --erase-on-exit \
        --title "Term-SD" \
        --backtitle "扩展脚本选项" \
        --ok-label "确认" --cancel-label "取消" \
        --menu "请选择要启动的脚本" \
        $term_sd_dialog_height $term_sd_dialog_width $term_sd_dialog_menu_height \
        "Term-SD" "<---------" \
        $extra_script_dir_list \
        "退出" "<---------" \
        3>&1 1>&2 2>&3)

    case $? in
        0)
            case $extra_script_dir_list_select in
                Term-SD)
                    . ./term-sd/modules/init.sh
                    term_sd_version
                    main
                    ;;
                "退出")
                    term_sd_print_line
                    term_sd_echo "退出Term-SD"
                    exit 0
                    ;;
                *)
                    term_sd_print_line "$(echo $extra_script_dir_list_select | awk '{sub(".sh","")}1') 脚本启动"
                    . ./term-sd/extra/$extra_script_dir_list_select
                    term_sd_print_line
                    term_sd_echo "退出 $(echo $extra_script_dir_list_select | awk '{sub(".sh","")}1') 脚本"
                    exit 0
            esac
            ;;
        *)
            term_sd_echo "退出 Term-SD"
            exit 0
            ;;
    esac
}

# 格式化信息输出
term_sd_echo()
{
    echo -e "[\033[33m$(date "+%Y-%m-%d %H:%M:%S")\033[0m][\033[36mTerm-SD\033[0m]\033[36m::\033[0m "$@""
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
    term_sd_echo "执行结束, 请按回车键继续"
    read
}

# 测试输入值是参数还是选项,选项输出0,参数输出1(用于实现getopt命令的功能)
term_sd_test_args()
{
    echo $@ | awk '{for (i=1; i<=NF; i++) {if (substr($i, 1, 2) == "--") {print "0"} else {print "1"}}}'
}

# 提示未知启动参数
term_sd_unknown_args_echo()
{
    if [ "$(term_sd_test_args "$@")" = 0 ] && [ ! "$@" = "--null" ];then # 测试输入值是参数还是选项
        term_sd_echo "未知参数: $@"
    fi
}

# 创建目录
term_sd_mkdir()
{
    if [ ! -d "$@" ];then
        mkdir -p "$@"
    else
        true
    fi
}

# 暂停执行
term_sd_sleep()
{
    local pause_time=$1
    local i
    for ((i = pause_time; i >= 0; i--))
    do
        printf "[\033[33m$(date "+%Y-%m-%d %H:%M:%S")\033[0m][\033[36mTerm-SD\033[0m]\033[36m::\033[0m 等待中: $i  \r"
        sleep 1
    done
    printf "                                            \r"
}

# 路径格式转换(将windows格式的文件路径转换成linux/unix格式的路径)
term_sd_win2unix_path()
{
    if is_windows_platform ;then
        echo "$(cd "$(dirname "$@" 2> /dev/null)" ; pwd)/$(basename "$@" 2> /dev/null)"
    else
        echo "$@"
    fi
}

# 检测目录是否为空,为空是返回0,不为空返回1
term_sd_test_empty_dir()
{
    if [ $(ls "$@" -al --format=horizontal | wc --words) -le 2 ];then
        echo 0
    else
        echo 1
    fi
}

# 系统判断
is_windows_platform()
{
    local sys_platform

    if term_sd_python --version &> /dev/null ;then
        sys_platform=$(term_sd_python -c "$(py_is_windows_platform)")
    else
        case $OS in
            Windows_NT)
                sys_platform="win32"
                ;;
            *)
                sys_platform="other"
                ;;
        esac
    fi

    if [ $sys_platform = "win32" ];then
        return 0
    else
        return 1
    fi
}

# 系统判断.py
py_is_windows_platform()
{
    cat<<EOF
import sys

if sys.platform == "win32":
    print("win32")
else:
    print("other")
EOF
}

# 加载进度条设置
term_sd_loading_bar_setting()
{
    if [ -z "$*" ];then
        term_sd_echo "未指定 Term-SD 初始化进度条的显示模式"
    else
        case $@ in
            none)
                echo "none" > term-sd/config/term-sd-bar.conf
                term_sd_echo "禁用 Term-SD 初始化进度显示"
                ;;
            normal)
                rm -f term-sd/config/term-sd-bar.conf
                term_sd_echo "使用默认 Term-SD 初始化进度显示模式"
                ;;
            new)
                echo "new" > term-sd/config/term-sd-bar.conf
                term_sd_echo "使用新的 Term-SD 初始化进度显示模式"
                ;;
            *)
                term_sd_echo "未知的 Term-SD 初始化进度条显示模式"
                ;;
        esac
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
        shell_word_width_zh_cn=$(( $(echo "$print_word_to_shell" | awk '{gsub(/[a-zA-Z]/,"") ; gsub(/[0-9]/, "") ; gsub(/[=+()（）、。,./\-_\\]/, "")}1' | wc -c) - 1 )) # 计算中文字符的长度
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

    if [ -f "term-sd/config/term-sd-auto-update.lock" ] && [ -d "term-sd/.git" ];then # 找到自动更新配置
        if [ -f "term-sd/config/term-sd-auto-update-time.conf" ];then # 有上次运行记录
            term_sd_start_time=`date +'%Y-%m-%d %H:%M:%S'` # 查看当前时间
            term_sd_end_time=$(cat term-sd/config/term-sd-auto-update-time.conf) # 获取上次更新时间
            term_sd_start_time_seconds=$(date --date="$term_sd_start_time" +%s) # 转换时间单位
            term_sd_end_time_seconds=$(date --date="$term_sd_end_time" +%s)
            term_sd_auto_update_time_span=$(( $term_sd_start_time_seconds - $term_sd_end_time_seconds )) # 计算相隔时间
            if [ $term_sd_auto_update_time_span -ge $term_sd_auto_update_time_set ];then # 判断时间间隔
                term_sd_auto_update
                date +'%Y-%m-%d %H:%M:%S' > term-sd/config/term-sd-auto-update-time.conf # 记录自动更新功能的启动时间
            fi
        else # 没有时直接执行
            term_sd_auto_update
            date +'%Y-%m-%d %H:%M:%S' > term-sd/config/term-sd-auto-update-time.conf # 记录自动更新功能的启动时间
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
    term_sd_local_branch=$(git --git-dir="term-sd/.git" branch | grep \* | awk -F "*" '{gsub(/[" "]/,"") ; print $NF}') # term-sd分支
    term_sd_local_hash=$(git --git-dir="term-sd/.git" rev-parse HEAD) # term-sd本地hash
    term_sd_remote_hash=$(git --git-dir="term-sd/.git" ls-remote origin refs/remotes/origin/$term_sd_local_branch $term_sd_local_branch 2> /dev/null) # term-sd远程hash
    if [ $? = 0 ];then # 网络连接正常时再进行更新
        term_sd_remote_hash=$(echo $term_sd_remote_hash | awk '{print $1}')
        if [ ! $term_sd_local_hash = $term_sd_remote_hash ];then
            term_sd_echo "检测到 Term-SD 有新版本"
            term_sd_echo "是否选择更新(yes/no)?"
            term_sd_echo "提示: 输入 yes 或 no 后回车"
            case $(term_sd_read) in
                yes|y|YES|Y)
                    term_sd_echo "更新 Term-SD 中"
                    cd term-sd
                    git pull
                    if [ $? = 0 ];then
                        cd ..
                        cp -f term-sd/term-sd.sh .
                        chmod +x term-sd.sh
                        term_sd_restart_info=0
                        term_sd_echo "Term-SD 更新成功"
                    else
                        cd ..
                        term_sd_echo "Term-SD 更新失败"
                    fi
                    ;;
                *)
                    term_sd_echo "跳过 Term-SD 的更新"
                    ;;
            esac
        else
            term_sd_echo "Term-SD 已经是最新版本"
        fi
    else
        term_sd_echo "Term-SD 连接更新源失败, 跳过更新"
        term_sd_echo "提示: 请检查网络连接是否正常, 若网络正常, 可尝试更换更新源或使用科学上网解决"
    fi
}

# term-sd安装功能
term_sd_install()
{
    if [ ! -d "term-sd" ];then
        term_sd_echo "检测到 Term-SD 未安装, 是否进行安装(yes/no)?"
        term_sd_echo "提示: 输入 yes 或 no 后回车"
        case $(term_sd_read) in
            yes|y|YES|Y)
                term_sd_clone_modules
                if [ $? = 0 ];then
                    term_sd_set_up_normal_setting
                    term_sd_restart_info=0
                    cp -f term-sd/term-sd.sh .
                    chmod +x term-sd.sh
                    term_sd_echo "Term-SD 安装成功"
                else
                    term_sd_echo "Term-SD 安装失败"
                    exit 1
                fi
                ;;
            *)
                term_sd_echo "退出 Term-SD"
                exit 0
                ;;
        esac
    elif [ ! -d "term-sd/.git" ];then
        term_sd_echo "检测到 Term-SD 的 .git 目录不存在, 将会导致 Term-SD 无法更新, 是否重新安装(yes/no)?"
        term_sd_echo "警告: 该操作将永久删除 Term-SD 目录中的所有文件 (除了 Term-SD 缓存文件夹和配置文件将备份到临时文件夹并在安装完成还原)"
        term_sd_echo "提示: 输入 yes 或 no 后回车"
        case $(term_sd_read) in
            yes|y|YES|Y)
                term_sd_backup_config
                term_sd_echo "清除 Term-SD 文件中"
                rm -rf term-sd
                term_sd_echo "Term-SD 文件清除完成"
                term_sd_clone_modules
                if [ $? = 0 ];then
                    term_sd_restore_config
                    term_sd_set_up_normal_setting
                    term_sd_restart_info=0
                    cp -f term-sd/term-sd.sh .
                    chmod +x term-sd.sh
                    term_sd_echo "Term-SD 重新安装成功"

                else
                    term_sd_echo "Term-SD 重新安装失败"
                    exit 1
                fi
                ;;
            *)
                term_sd_echo "取消操作"
                ;;
        esac
    fi
}

# term-sd重新安装功能
term_sd_reinstall()
{
    if which git &> /dev/null ;then
        term_sd_echo "是否重新安装 Term-SD (yes/no)?"
        term_sd_echo "警告: 该操作将永久删除 Term-SD 目录中的所有文件 (除了 Term-SD 缓存文件夹和配置文件将备份到临时文件夹并在安装完成还原)"
        term_sd_echo "提示: 输入 yes 或 no 后回车"
        case $(term_sd_read) in
            yes|y|YES|Y)
                term_sd_backup_config
                term_sd_echo "清除 Term-SD 文件中"
                rm -rf term-sd
                term_sd_echo "Term-SD 文件清除完成"
                term_sd_clone_modules
                if [ $? = 0 ];then
                    term_sd_restore_config
                    term_sd_set_up_normal_setting
                    term_sd_restart_info=0
                    cp -f term-sd/term-sd.sh .
                    chmod +x term-sd.sh
                    term_sd_echo "Term-SD 重新安装成功"
                else
                    term_sd_echo "Term-SD 重新安装失败"
                    exit 1
                fi
                ;;
            *)
                term_sd_echo "退出 Term-SD"
                exit 0
                ;;
        esac
    else
        term_sd_echo "缺少 Git, 无法重新安装 Term-SD"
    fi
}

# 下载term-sd
term_sd_clone_modules()
{
    local i
    local count=0
    local repo_urls="https://github.com/licyk/term-sd https://gitlab.com/licyk/term-sd https://licyk@bitbucket.org/licyks/term-sd https://gitee.com/licyk/term-sd"

    term_sd_echo "下载 Term-SD 中"
    for i in $repo_urls
    do
        count=$((count + 1))
        git clone $i
        if [ $? = 0 ];then
            term_sd_echo "Term-SD 下载成功"
            return 0
        else
            term_sd_echo "Term-SD 下载失败"
            if [ $count -lt $(echo $repo_urls | wc --words) ];then
                term_sd_echo "更换 Term-SD 下载源进行下载中"
            else
                return 1
            fi
        fi
    done
}

# 备份cache文件夹
term_sd_backup_config()
{
    term_sd_echo "备份 Term-SD 缓存文件夹和配置文件中"
    term_sd_mkdir "term-sd-tmp"
    term_sd_mkdir "term-sd-tmp/config"
    rm -f term-sd/config/note.md
    [ -d "term-sd/config" ] && mv -f term-sd/config/* term-sd-tmp/config
    [ -d "term-sd/cache" ] && mv -f term-sd/cache term-sd-tmp
    [ -d "term-sd/requirements-backup" ] && mv -f term-sd/requirements-backup term-sd-tmp
    [ -d "term-sd/backup" ] && mv -f term-sd/backup term-sd-tmp
}

# 恢复cache文件夹
term_sd_restore_config()
{
    term_sd_echo "恢复 Term-SD 缓存文件夹和配置文件中"
    [ -d "term-sd-tmp/cache" ] && mv -f term-sd-tmp/cache term-sd
    [ -d "term-sd-tmp/config" ] && mv -f term-sd-tmp/config/* term-sd/config
    [ -d "term-sd-tmp/requirements-backup" ] && mv -f term-sd-tmp/requirements-backup term-sd
    [ -d "term-sd-tmp/backup" ] && mv -f term-sd-tmp/backup term-sd
    rm -rf term-sd-tmp
}

# 设置默认term-sd设置
term_sd_set_up_normal_setting()
{
    if [ ! -f "term-sd/config/term-sd-watch-retry.conf" ];then
        echo "3" > term-sd/config/term-sd-watch-retry.conf
        export term_sd_cmd_retry=3
        term_sd_echo "Term-SD 命令执行监测设置已自动设置"
    fi

    if [ ! -f "term-sd/config/term-sd-auto-update.lock" ];then
        touch term-sd/config/term-sd-auto-update.lock
        date +'%Y-%m-%d %H:%M:%S' > term-sd/config/term-sd-auto-update-time.conf
        term_sd_echo "Term-SD 自动更新已自动设置"
    fi

    if [ ! -f "term-sd/config/term-sd-pip-mirror.conf" ];then
        echo "2" > term-sd/config/term-sd-pip-mirror.conf
        term_sd_echo "Term-SD 设置 Pip 镜像源为国内镜像源"
    fi

    touch term-sd/.install_by_launch_script
}

# term-sd卸载功能
term_sd_remove()
{
    term_sd_echo "是否卸载 Term-SD?"
    term_sd_echo "警告: 该操作将永久删除 Term-SD 目录中的所有文件, 包括 AI 软件下载的部分模型文件 (存在于 Term-SD 目录中的 cache 文件夹, 如有必要, 请备份该文件夹)"
    term_sd_echo "提示: 输入 yes 或 no 后回车"
    case $(term_sd_read) in
        y|yes|YES|Y)
            term_sd_echo "开始卸载 Term-SD"
            rm -rf term-sd
            rm -rf term-sd.sh
            if [ $user_shell = bash ] || [ $user_shell = zsh ];then
                remove_config_from_shell
            fi
            term_sd_echo "Term-SD 卸载完成"
            ;;
        *)
            term_sd_echo "取消操作"
            ;;
    esac
    exit 0
}

# term-sd添加快捷命令功能
install_cmd_to_shell()
{
    while true
    do
        case $user_shell in
            bash|zsh)
                term_sd_echo "是否将 Term-SD 快捷启动指令添加到 Shell 环境中?"
                term_sd_echo "添加后可使用 term_sd, tsd 指令启动 Term-SD"
                term_sd_echo "1、添加"
                term_sd_echo "2、删除"
                term_sd_echo "3、退出"
                term_sd_echo "提示: 输入数字后回车"
                case $(term_sd_read) in
                    1)
                        install_config_to_shell
                        break
                        ;;
                    2)
                        remove_config_from_shell
                        break
                        ;;
                    3)
                        exit 1
                        ;;
                    *)
                        term_sd_echo "输入有误, 请重试"
                        ;;
                esac
                ;;
            *)
                term_sd_echo "不支持该 Shell"
                ;;
        esac
    done
}

# term-sd快捷命令安装功能
install_config_to_shell()
{
    if cat ~/.${user_shell}rc | grep term_sd > /dev/null ;then
        term_sd_echo "配置已存在, 添加前请删除原有配置"
    else
        echo "# Term-SD" >> ~/.${user_shell}rc
        echo "term_sd(){ local term_sd_start_path=\$(pwd) ; cd \"$(pwd)\" ; ./term-sd.sh \"\$@\" ; cd \"\$term_sd_start_path\" > /dev/null ; }" >> ~/.${user_shell}rc
        echo "alias tsd='term_sd'" >> ~/.${user_shell}rc
        term_sd_echo "配置添加完成, 重启 Shell 以生效"
    fi
}

# term-sd快捷命令卸载功能
remove_config_from_shell()
{
    sed -i '/# Term-SD/d' ~/.${user_shell}rc
    sed -i '/term_sd(){/d' ~/.${user_shell}rc
    sed -i '/alias tsd/d' ~/.${user_shell}rc
    term_sd_echo "配置已删除, 重启 Shell 以生效"
}

# 手动指定python路径功能
set_python_path()
{
    local set_python_path_option

    while true
    do
        if [ -z "$*" ];then
            term_sd_echo "请输入 Python 解释器的路径"
            term_sd_echo "提示: 输入完后请回车保存, 或者输入 exit 退出"
            read -p "===============================> " set_python_path_option
            if [ -z "$set_python_path_option" ];then
                term_sd_echo "未输入, 请重试"
            elif [ "$set_python_path_option" = "exit" ];then
                term_sd_echo "退出 Python 解释器路径指定功能"
                break
            elif [ -f "$set_python_path_option" ];then
                term_sd_python_path=$(term_sd_win2unix_path $set_python_path_option)
                echo $term_sd_python_path > term-sd/config/python-path.conf
                term_sd_echo "Python 解释器路径指定完成"
                term_sd_echo "提示:"
                term_sd_echo "使用 --set-python-path 重新设置 Python 解释器路径"
                term_sd_echo "使用 --unset-python-path 删除 Python 解释器路径设置"
                break
            else
                term_sd_echo "输入的路径有误, 请重试"
            fi
        else # 直接将选项后面的参数作为路径
            if [ -f "$@" ];then
                term_sd_echo "设置 Python 解释器路径: $@"
                term_sd_python_path=$(term_sd_win2unix_path $@)
                echo "$term_sd_python_path" > term-sd/config/python-path.conf
                term_sd_echo "Python 解释器路径指定完成"
                term_sd_echo "提示:"
                term_sd_echo "使用 --set-python-path 重新设置 Python 解释器路径"
                term_sd_echo "使用 --unset-python-path 删除 Python 解释器路径设置"
                break
            else
                term_sd_echo "输入的路径有误, 跳过指定 Python 解释器路径"
                break
            fi
        fi
    done
}

# 配置内存优化(仅限Linux)
prepare_tcmalloc()
{
    case $use_tcmalloc in
        1)
            term_sd_echo "取消加载内存优化"
            ;;
        *)
            if [[ "${OSTYPE}" == "linux"* ]] && [[ -z "${NO_TCMALLOC}" ]] && [[ -z "${LD_PRELOAD}" ]]; then
                term_sd_echo "检测到系统为 Linux, 尝试启用内存优化"
                # 检查glibc版本
                LIBC_VER=$(echo $(ldd --version | awk 'NR==1 {print $NF}') | grep -oP '\d+\.\d+')
                term_sd_echo "glibc 版本为 $LIBC_VER"
                libc_vernum=$(expr $LIBC_VER)
                # 从 2.34 开始，libpthread 已经集成到 libc.so 中
                libc_v234=2.34
                # 定义 Tcmalloc 库数组
                TCMALLOC_LIBS=("libtcmalloc(_minimal|)\.so\.\d" "libtcmalloc\.so\.\d")
                # 遍历数组
                for lib in "${TCMALLOC_LIBS[@]}"
                do
                    # 确定库支持的 Tcmalloc 类型
                    TCMALLOC="$(PATH=/usr/sbin:$PATH ldconfig -p | grep -P $lib | head -n 1)"
                    TC_INFO=(${TCMALLOC//=>/})
                    if [[ ! -z "${TC_INFO}" ]]; then
                        term_sd_echo "检查 TCMalloc: ${TC_INFO}"
                        # 确定库是否链接到 libpthread 和解析未定义符号: pthread_key_create
                        if [ $(echo "$libc_vernum < $libc_v234" | bc) -eq 1 ]; then
                            # glibc < 2.34，pthread_key_create 在 libpthread.so 中。检查链接到 libpthread.so
                            if ldd ${TC_INFO[2]} | grep -q 'libpthread'; then
                                term_sd_echo "$TC_INFO 链接到 libpthread, 执行 LD_PRELOAD=${TC_INFO[2]}"
                                # 设置完整路径 LD_PRELOAD
                                export LD_PRELOAD="${TC_INFO[2]}"
                                break
                            else
                                term_sd_echo "$TC_INFO 没有链接到 libpthread, 将触发未定义符号: pthread_Key_create 错误"
                            fi
                        else
                            # libc.so（glibc）的2.34版本已将pthread库集成到glibc内部。在Ubuntu 22.04系统以及现代Linux系统和WSL（Windows Subsystem for Linux）环境下
                            # libc.so（glibc）链接了一个几乎能在所有Linux用户态环境中运行的库，因此通常无需额外检查
                            term_sd_echo "$TC_INFO 链接到 libc.so, 执行 LD_PRELOAD=${TC_INFO[2]}"
                            # 设置完整路径 LD_PRELOAD
                            export LD_PRELOAD="${TC_INFO[2]}"
                            break
                        fi
                    fi
                done
                if [[ -z "${LD_PRELOAD}" ]]; then
                    term_sd_echo "无法定位 TCMalloc。未在系统上找到 tcmalloc 或 google-perftool"
                    term_sd_echo "取消加载内存优化"
                    term_sd_echo "提示: 可根据 Term-SD 帮助文档安装 google-perftool"
                    term_sd_sleep 3
                fi
            fi
            ;;
    esac
}

#############################

export term_sd_version_info="1.3.11" # term-sd版本
export user_shell=$(basename $SHELL) # 读取用户所使用的shell
export start_path=$(pwd) # 设置启动时脚本路径
export PYTHONUTF8=1 # 强制Python解释器使用UTF-8编码来处理字符串,避免乱码问题
export PYTHONIOENCODING=utf8
export PIP_TIMEOUT=30 # 设置pip的超时时间
export PIP_RETRIES=5 # 设置pip的重试次数
export PIP_DISABLE_PIP_VERSION_CHECK # 禁用pip版本版本检查
export pip_manager_update # Term-SD自动更新pip
export term_sd_debug_mode # # debug模式
export term_sd_delimiter
export SAFETENSORS_FAST_GPU=1 # 强制所有模型使用 GPU 加载
export term_sd_pip_index_url="https://mirrors.cloud.tencent.com/pypi/simple"
export term_sd_pip_extra_index_url="https://mirror.baidu.com/pypi/simple"
export term_sd_pip_find_links="https://mirrors.aliyun.com/pytorch-wheels/torch_stable.html https://mirror.sjtu.edu.cn/pytorch-wheels/torch_stable.html"
export term_sd_pip_index_url_args=""
export term_sd_pip_extra_index_url_args=""
export term_sd_pip_find_links_args=""
missing_depend_info=0 # 依赖缺失状态
missing_depend_macos_info=0
term_sd_restart_info=1 # term-sd重启状态
term_sd_shell_width=$(stty size | awk '{print $2}') # 获取终端宽度
term_sd_shell_height=$(stty size | awk '{print $1}') # 获取终端高度

# 在使用http_proxy变量后,会出现ValueError: When localhost is not accessible, a shareable link must be created. Please set share=True
# 导致启动异常
# 需要设置no_proxy让localhost,127.0.0.1,::1避开http_proxy
# 详见https://github.com/microsoft/TaskMatrix/issues/250
export no_proxy="localhost,127.0.0.1,::1" # 除了避免http_proxy变量的影响,也避免了代理软件的影响(在启动a1111-sd-webui前开启代理软件可能会导致webui无法生图(启动后再开启没有影响),并报错,设置该变量后完美解决该问题)

term_sd_print_line "Term-SD"

# 检测term-sd是直接启动还是重启
case $term_sd_env_prepare_info in
    0) # 检测到是重启
        term_sd_echo "重启 Term-SD 中"
        ;;
    *)
        term_sd_echo "Term-SD 初始化中"
        term_sd_extra_scripts_name="null"  # Term-SD扩展脚本
        term_sd_launch_args_manager "$@" # 处理用户输入的参数
        ;;
esac

# 目录结构检测,防止用户直接运行Term-SD目录内的term-sd.sh
if [ ! -d "term-sd" ] && [ -d ".git" ] && [ -d "modules" ] && [ -f "modules/init.sh" ] && [ -d "extra" ];then
    term_sd_echo "检测到目录错误"
    term_sd_echo "禁止用户直接在 Term-SD 目录里运行 Term-SD"
    term_sd_echo "请将 term-sd.sh 文件复制到 Term-SD 目录外面(和 Term-SD 目录放在一起)"
    term_sd_echo "再运行目录外面的 term-sd.sh"
    term_sd_echo "退出 Term-SD"
    exit 1
fi

if [ "$(dirname "$(echo $0)")" = "." ] || [ "$(dirname "$(echo $0)")" = "$(pwd)" ];then
    true
else
    term_sd_echo "检测到未在 term-sd.sh 文件所在目录运行 Term-SD"
    term_sd_echo "请进入 term-sd.sh 文件所在目录后再次运行 Term-SD"
    term_sd_echo "退出 Term-SD"
    exit 1
fi

# root权限检测
if [ $(id -u) -eq 0 ];then
    term_sd_echo "检测到使用 root 权限运行 Term-SD, 这可能会导致不良后果"
    term_sd_echo "是否继续运行 Term-SD (yes/no)?"
    term_sd_echo "提示: 输入 yes 或 no 后回车"
    case $(term_sd_read) in
        yes|y|YES|Y)
            term_sd_echo "继续初始化 Term-SD"
            ;;
        *)
            term_sd_echo "终止 Term-SD 初始化进程"
            term_sd_echo "退出 Term-SD"
            exit 1
            ;;
    esac
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
if [ -f "term-sd/config/python-path.conf" ];then
    export term_sd_python_path=$(cat term-sd/config/python-path.conf)
fi

if [ -f "term-sd/config/proxy.conf" ];then # 读取代理设置并设置代理
    export http_proxy=$(cat term-sd/config/proxy.conf)
    export https_proxy=$(cat term-sd/config/proxy.conf)
    # 代理变量的说明:https://blog.csdn.net/Dancen/article/details/128045261
fi
export term_sd_proxy=$https_proxy # 临时代理变量储存

# 设置安装重试次数
if [ -f "term-sd/config/term-sd-watch-retry.conf" ];then
    export term_sd_cmd_retry=$(cat term-sd/config/term-sd-watch-retry.conf)
else # 没有配置文件时使用默认值
    export term_sd_cmd_retry=0
fi

# 设置安装ai软件时下载模型的线程数
if [ -f "term-sd/config/aria2-thread.conf" ];then
    export aria2_multi_threaded=$(cat term-sd/config/aria2-thread.conf)
else
    export aria2_multi_threaded="-x 1"
fi

# 设置虚拟环境
if [ -f "term-sd/config/term-sd-venv-disable.lock" ];then # 找到term-sd-venv-disable.lock文件,禁用虚拟环境
    export venv_setup_status="1"
else
    export venv_setup_status="0"
fi

# 设置安装模式
if [ -f "term-sd/config/term-sd-disable-strict-install-mode.lock" ];then
    export term_sd_install_mode=1
else
    export term_sd_install_mode=0
fi

# cuda内存分配方案设置
if [ -f "term-sd/config/cuda-memory-alloc.conf" ];then
    export PYTORCH_CUDA_ALLOC_CONF=$(cat term-sd/config/cuda-memory-alloc.conf)
fi

# pip镜像源
for i in $term_sd_pip_index_url
do
    term_sd_pip_index_url_args="$term_sd_pip_index_url_args --index-url $i"
done
term_sd_pip_index_url_args=$(echo $term_sd_pip_index_url_args) # 去除多余空格

for i in $term_sd_pip_extra_index_url
do
    term_sd_pip_extra_index_url_args="$term_sd_pip_extra_index_url_args --extra-index-url $i"
done
term_sd_pip_extra_index_url_args=$(echo $term_sd_pip_extra_index_url_args) # 去除多余空格

for i in $term_sd_pip_find_links
do
    term_sd_pip_find_links_args="$term_sd_pip_find_links_args --find-links $i"
done
term_sd_pip_find_links_args=$(echo $term_sd_pip_find_links_args) # 去除多余空格

# 设置pip镜像源
if [ -f "term-sd/config/term-sd-pip-mirror.conf" ];then
    case $(cat term-sd/config/term-sd-pip-mirror.conf) in
        1)
            export PIP_INDEX_URL="https://pypi.python.org/simple"
            export PIP_EXTRA_INDEX_URL=""
            export PIP_FIND_LINKS="https://download.pytorch.org/whl/torch_stable.html"
            ;;
        2)
            export PIP_INDEX_URL=$term_sd_pip_index_url
            export PIP_EXTRA_INDEX_URL=$term_sd_pip_extra_index_url
            export PIP_FIND_LINKS=$term_sd_pip_find_links
            ;;
        *)
            export PIP_INDEX_URL=$term_sd_pip_index_url
            export PIP_EXTRA_INDEX_URL=$term_sd_pip_extra_index_url
            export PIP_FIND_LINKS=$term_sd_pip_find_links
            ;;
    esac
fi

# 设置ai软件路径
if [ -f "term-sd/config/sd-webui-path.conf" ];then
    export sd_webui_path=$(cat term-sd/config/sd-webui-path.conf)
    export sd_webui_folder=$(basename "$sd_webui_path")
    export sd_webui_parent_path=$(dirname "$sd_webui_path")
else
    export sd_webui_path="$start_path/stable-diffusion-webui"
    export sd_webui_folder="stable-diffusion-webui"
    export sd_webui_parent_path=$start_path
fi

if [ -f "term-sd/config/comfyui-path.conf" ];then
    export comfyui_path=$(cat term-sd/config/comfyui-path.conf)
    export comfyui_folder=$(basename "$comfyui_path")
    export comfyui_parent_path=$(dirname "$comfyui_path")
else
    export comfyui_path="$start_path/ComfyUI"
    export comfyui_folder="ComfyUI"
    export comfyui_parent_path=$start_path
fi

if [ -f "term-sd/config/invokeai-path.conf" ];then
    export invokeai_path=$(cat term-sd/config/invokeai-path.conf)
    export invokeai_folder=$(basename "$invokeai_path")
    export invokeai_parent_path=$(dirname "$invokeai_path")
else
    export invokeai_path="$start_path/InvokeAI"
    export invokeai_folder="InvokeAI"
    export invokeai_parent_path=$start_path
fi

if [ -f "term-sd/config/fooocus-path.conf" ];then
    export fooocus_path=$(cat term-sd/config/fooocus-path.conf)
    export fooocus_folder=$(basename "$fooocus_path")
    export fooocus_parent_path=$(dirname "$fooocus_path")
else
    export fooocus_path="$start_path/Fooocus"
    export fooocus_folder="Fooocus"
    export fooocus_parent_path=$start_path
fi

if [ -f "term-sd/config/lora-scripts-path.conf" ];then
    export lora_scripts_path=$(cat term-sd/config/lora-scripts-path.conf)
    export lora_scripts_folder=$(basename "$lora_scripts_path")
    export lora_scripts_parent_path=$(dirname "$lora_scripts_path")
else
    export lora_scripts_path="$start_path/lora-scripts"
    export lora_scripts_folder="lora-scripts"
    export lora_scripts_parent_path=$start_path
fi

if [ -f "term-sd/config/kohya_ss-path.conf" ];then
    export kohya_ss_path=$(cat term-sd/config/kohya_ss-path.conf)
    export kohya_ss_folder=$(basename "$kohya_ss_path")
    export kohya_ss_parent_path=$(dirname "$kohya_ss_path")
else
    export kohya_ss_path="$start_path/kohya_ss"
    export kohya_ss_folder="kohya_ss"
    export kohya_ss_parent_path=$start_path
fi

# github镜像源设置
if [ -f "term-sd/config/set-global-github-mirror.conf" ];then
    export GIT_CONFIG_GLOBAL="$start_path/term-sd/config/.gitconfig"
fi

# huggingface镜像源设置
if [ -f "term-sd/config/set-global-huggingface-mirror.conf" ];then
    export HF_ENDPOINT=$(cat term-sd/config/set-global-huggingface-mirror.conf)
fi

# 依赖检测
case $term_sd_env_prepare_info in # 判断启动状态(在shell中,新变量的值为空,且不需要定义就可以使用,不像c语言中要求那么严格)
    0)
        ;;
    *)
        term_sd_echo "检测依赖软件是否安装"
        term_sd_depend="git aria2c dialog curl" # term-sd依赖软件包
        term_sd_depend_macos="wget rustc cmake brew protoc" # term-sd依赖软件包(MacOS)

        # 检测可用的python命令,并检测是否手动指定python路径
        if [ -z "$term_sd_python_path" ];then
            if python3 --version &> /dev/null || python --version &> /dev/null ;then # 判断是否有可用的python
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
            if which "$term_sd_python_path" &> /dev/null ;then
                term_sd_echo "使用自定义 Python 解释器路径: $term_sd_python_path"
            else
                term_sd_echo "手动指定的 Python 路径错误"
                term_sd_echo "提示:"
                term_sd_echo "使用 --set-python-path 重新设置 Python 解释器路径"
                term_sd_echo "使用 --unset-python-path 删除 Python 解释器路径设置"
                missing_depend_info=1
                missing_depend="$missing_depend python,"
            fi
        fi

        # 检测可用的pip命令
        if ! "$term_sd_python_path" -m pip -V &> /dev/null ;then
            missing_depend_info=1
            missing_depend="$missing_depend pip,"
        fi

        # 检测python模块是否安装
        term_sd_depend_python="venv tkinter"
        for i in $term_sd_depend_python
        do
            if ! "$term_sd_python_path" -c "import $i" &> /dev/null ;then
                missing_depend_info=1
                missing_depend="$missing_depend python_module: $i,"
            fi
        done

        #判断系统是否安装必须使用的软件
        for i in $term_sd_depend ; do
            if ! which $i &> /dev/null ;then
                case $i in
                    aria2c)
                        i=aria2
                        ;;
                esac
                missing_depend="$missing_depend $i,"
                missing_depend_info=1
            fi
        done

        #依赖检测(MacOS)
        if [ $(uname) = "Darwin" ];then
            for i in $term_sd_depend_macos ; do
                if ! which $i &> /dev/null ;then
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
                    missing_depend_macos_info=1
                fi
            done

            if [ ! $missing_depend_macos_info = 0 ];then
                print_line_to_shell "缺少以下依赖"
                echo $missing_depend_macos
                print_line_to_shell
                term_sd_echo "缺少依赖将影响 AI 软件的安装, 请退出 Term-SD 并使用 Homebrew (如果没有 Homebrew, 则先安装 Homebrew, 再用 Homebrew 去安装其他缺少依赖) 安装缺少的依赖后重试"
                term_sd_sleep 5
            fi
        fi

        # 判断依赖检测结果
        if [ $missing_depend_info = 0 ];then
            term_sd_echo "依赖检测完成, 无缺失依赖"
            prepare_tcmalloc # 配置内存优化(Linux)
            term_sd_install
            if [ -d "term-sd/modules" ];then # 找到目录后才启动
                term_sd_auto_update_trigger
                export term_sd_env_prepare_info=0 # 用于检测term-sd的启动状态
            else
                term_sd_echo "Term-SD 模块丢失, 输入 ./term-sd.sh --reinstall-term-sd 重新安装 Term-SD"
                exit 1
            fi
        else
            term_sd_print_line "缺少以下依赖"
            echo $missing_depend
            term_sd_print_line
            term_sd_echo "请安装缺少的依赖后重试"
            exit 1
        fi

        if [ ! -f "term-sd/.install_by_launch_script" ];then # 检测是否通过启动脚本安装term-sd
            term_sd_set_up_normal_setting # 非启动脚本安装时设置默认term-sd设置
        fi
        ;;
esac

# 放在依赖检测之后,解决一些奇怪的问题
# term-sd设置路径环境变量
if [ ! -f "term-sd/config/disable-cache-path-redirect.lock" ];then
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
    term_sd_echo "重载 Term-SD 启动脚本中"
    . ./term-sd.sh
fi

term_sd_echo "Term-SD 版本: $term_sd_version_info"
[ -d "term-sd/.git" ] && term_sd_echo "Commit: $(git --git-dir="term-sd/.git" show -s --format="%h %cd" --date=format:"%Y-%m-%d %H:%M:%S")"

case $term_sd_extra_scripts_name in
    null)
        . ./term-sd/modules/init.sh # 加载term-sd模块
        ;;
    *)
        term_sd_extra_scripts_launch $term_sd_extra_scripts_name
        ;;
esac

# 启动term-sd
term_sd_echo "启动 Term-SD 中"
term_sd_version
main
