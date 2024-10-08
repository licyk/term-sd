#!/bin/bash

# Term-SD 启动参数处理
# 设置 TERM_SD_SCRIPT_NAME 全局变量读取要启动的 Term-SD 扩展脚本
term_sd_launch_arg_parse() {
    local argument_input
    local argument
    local i

    # 用别的方法实现了 getopt 命令的功能
    # 加一个 --null 是为了增加一次循环, 保证那些需要参数的选项能成功执行
    for i in "$@" "--null"; do
        argument=$i # 用作判断是参数还是选项

        # 参数检测部分
        if [[ ! -z "${argument_input}" ]]; then
            if term_sd_is_launch_arg "${argument}"; then # 测试输入值是参数还是选项
                unset argument # 检测到选项的下一项是选项, 直接清除
            fi

            # 检测输入的选项
            case "${argument_input}" in
                --set-python-path)
                    set_python_path "${argument}"
                    ;;
                --extra)
                    TERM_SD_SCRIPT_NAME=$argument
                    ;;
                --bar)
                    term_sd_loading_bar_setting "${argument}"
                    ;;
            esac
            unset argument_input # 清除选项, 留给下一次判断
        fi

        ####################

        # 选项检测部分(如果选项要跟参数值,则将启动选项赋值给 argument_input)
        case "${i}" in
            --help)
                term_sd_print_line
                term_sd_args_help
                term_sd_print_line
                exit 0
                ;;
            --reinstall-term-sd)
                # 防止重启后再执行重装
                case "${TERM_SD_IS_REINSTALL}" in
                    1)
                        ;;
                    *)
                        TERM_SD_IS_REINSTALL=1
                        term_sd_reinstall
                        ;;
                esac
                ;;
            --set-python-path)
                argument_input="--set-python-path"
                ;;
            --unset-python-path)
                rm -f "${START_PATH}/term-sd/config/python-path.conf"
                term_sd_echo "已删除自定义 Python 解释器路径配置"
                ;;
            --bar)
                argument_input="--bar"
                ;;
            --update-pip)
                ENABLE_PIP_VER_CHECK=1
                PIP_DISABLE_PIP_VERSION_CHECK=0
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
                argument_input="--extra"
                ;;
            --debug)
                term_sd_echo "显示 Term-SD 调试信息"
                TERM_SD_ENABLE_DEBUG=1
                ;;
            --unset-tcmalloc)
                USE_TCMALLOC=0
                term_sd_echo "禁用加载 TCMalloc 内存优化"
                ;;
            *)
                term_sd_unknown_args_echo ${i}
                ;;
        esac
    done
}

# Term-SD 命令行帮助信息
term_sd_args_help() {
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
            手动指定 Python 解释器路径, 当选项后面输入了路径, 则直接使用输入的路径来设置 Python 解释器路径 (建议用" "把路径括起来, 防止路径输入错误), 否则启动设置界面
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

# Term-SD 扩展脚本启动功能
term_sd_extra_scripts_launch() {
    if [[ -z "$@" ]]; then
        term_sd_extra_scripts
    else
        if [[ -f "term-sd/extra/${@%.sh}.sh" ]]; then
            term_sd_print_line "${@%.sh} 脚本启动"
            term_sd_echo "启动 ${@%.sh} 脚本中"
            . ./term-sd/extra/${@%.sh}.sh
            term_sd_print_line
            term_sd_echo "退出 ${@%.sh} 脚本"
            exit 0
        else
            term_sd_print_line
            term_sd_echo "未找到 ${@%.sh} 脚本"
            term_sd_echo "退出 Term-SD"
            exit 1
        fi
    fi
}

# 扩展脚本选择
term_sd_extra_scripts() {
    local extra_script

    extra_script=$(dialog --erase-on-exit \
        --title "Term-SD" \
        --backtitle "扩展脚本选项" \
        --ok-label "确认" --cancel-label "取消" \
        --menu "请选择要启动的脚本" \
        $(get_dialog_size_menu) \
        "Term-SD" "<---------" \
        $(ls -l "term-sd/extra" --time-style=+"%Y-%m-%d" | awk '{ print $7 " " $6 }') \
        "退出" "<---------" \
        3>&1 1>&2 2>&3)

    case "$?" in
        0)
            case "${extra_script}" in
                Term-SD)
                    . ./term-sd/modules/init.sh
                    term_sd_version
                    main
                    ;;
                退出)
                    term_sd_print_line
                    term_sd_echo "退出Term-SD"
                    exit 0
                    ;;
                *)
                    term_sd_print_line "${extra_script%.sh} 脚本启动"
                    . ./term-sd/extra/"${extra_script}"
                    term_sd_print_line
                    term_sd_echo "退出 ${extra_script%.sh} 脚本"
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
# 使用:
# term_sd_echo <输出信息>
term_sd_echo() {
    echo -e "[\033[33m$(date "+%Y-%m-%d %H:%M:%S")\033[0m][\033[36mTerm-SD\033[0m]\033[36m::\033[0m $@"
}

# 键盘输入读取
# 回车接收读取到的输入并输出
term_sd_read() {
    local input_text
    read -p "===============================> " input_text
    echo "${input_text}"
}

# 暂停运行(用于显示运行结果)
term_sd_pause() {
    term_sd_print_line
    term_sd_echo "执行结束, 请按回车键继续"
    read
}

# 测试输入值是参数还是选项, 是选项返回 0, 是参返回 1 (用于实现 getopt 命令的功能)
term_sd_is_launch_arg() {
    if [[ "$(echo $@ | awk '{for (i = 1; i <= NF; i++) {if (substr($i, 1, 2) == "--") {print "0"} else {print "1"}}}')" == 0 ]]; then
        return 0
    else
        return 1
    fi
}

# 提示未知启动参数
term_sd_unknown_args_echo() {
    if term_sd_is_launch_arg "$@" && [[ ! "$@" == "--null" ]]; then # 测试输入值是参数还是选项
        term_sd_echo "未知参数: $@"
    fi
}

# 创建目录
# 如果目录不存在则自动创建一个
# 使用:
# term_sd_mkdir <需创建的文件夹名>
term_sd_mkdir() {
    if [[ ! -d "$@" ]]; then
        mkdir -p "$@"
    else
        true
    fi
}

# 暂停执行
# 使用:
# term_sd_sleep <暂停的时间>
term_sd_sleep() {
    local pause_time=$1
    local i
    for (( i = pause_time; i >= 0; i-- )); do
        printf "[\033[33m$(date "+%Y-%m-%d %H:%M:%S")\033[0m][\033[36mTerm-SD\033[0m]\033[36m::\033[0m 等待中: ${i}  \r"
        sleep 1
    done
    printf "                                            \r"
}

# 路径格式转换(将 Windows 风格的文件路径转换成 Linux / Unix 风格的路径)
term_sd_win2unix_path() {
    if is_windows_platform; then
        echo "$(cd "$(dirname "$@" 2> /dev/null)" ; pwd)/$(basename "$@" 2> /dev/null)"
    else
        echo "$@"
    fi
}

# 检测目录是否为空, 为空是返回 0, 不为空返回 1
term_sd_is_dir_empty() {
    if [[ $(ls "$@" -al --format=horizontal | wc --words) -le 2 ]]; then
        return 0
    else
        return 1
    fi
}

# 系统判断
# 当 Term-SD 未初始化完成时(term_sd_python 命令未能使用), 使用 OS 环境变量判断系统的类型
is_windows_platform() {
    local sys_platform

    if term_sd_python --version &> /dev/null; then
        sys_platform=$(term_sd_python -c "$(py_is_windows_platform)")
    else
        case "${OS}" in
            "Windows_NT")
                sys_platform="win32"
                ;;
            *)
                sys_platform="other"
                ;;
        esac
    fi

    if [[ "${sys_platform}" = "win32" ]]; then
        return 0
    else
        return 1
    fi
}

# 系统判断(Python)
py_is_windows_platform() {
    cat<<EOF
import sys

if sys.platform == "win32":
    print("win32")
else:
    print("other")
EOF
}

# 加载进度条设置
# 配置保存在 <Start Path>/term-sd/config/term-sd-bar.conf
term_sd_loading_bar_setting() {
    if [[ -z "$@" ]]; then
        term_sd_echo "未指定 Term-SD 初始化进度条的显示模式"
    else
        case "$@" in
            "none")
                echo "none" > "${START_PATH}/term-sd/config/term-sd-bar.conf"
                term_sd_echo "禁用 Term-SD 初始化进度显示"
                ;;
            "normal")
                rm -f "${START_PATH}/term-sd/config/term-sd-bar.conf"
                term_sd_echo "使用默认 Term-SD 初始化进度显示模式"
                ;;
            "new")
                echo "new" > "${START_PATH}/term-sd/config/term-sd-bar.conf"
                term_sd_echo "使用新的 Term-SD 初始化进度显示模式"
                ;;
            *)
                term_sd_echo "未知的 Term-SD 初始化进度条显示模式"
                ;;
        esac
    fi
}

# 终端横线显示功能
# 使用:
# term_sd_print_line <输出的文本>
# 使用 SHELL_WIDTH 全局变量获取终端宽度
term_sd_print_line() {
    local shell_width
    local input_text
    local input_text_length
    local input_zh_text_length
    local shell_width_info
    local text_length_info
    local print_mode

    if [[ -z "$@" ]]; then # 输出方法选择
        print_mode=1
    else
        shell_width=$SHELL_WIDTH # 获取终端宽度
        input_text=$(echo "$@" | awk '{gsub(/ /,"-")}1') # 将空格转换为"-"
        input_text_length=$(( $(echo "${input_text}" | wc -c) - 1 )) # 总共的字符长度
        input_zh_text_length=$(( $(echo "${input_text}" | awk '{gsub(/[a-zA-Z]/,"") ; gsub(/[0-9]/, "") ; gsub(/[=+()（）、。,./\-_\\]/, "")}1' | wc -c) - 1 )) # 计算中文字符的长度
        input_text_length=$(( input_text_length - input_zh_text_length )) # 除去中文之后的长度
        # 中文的字符长度为3,但终端中只占2个字符位
        input_zh_text_length=$(( input_zh_text_length / 3 * 2 )) # 转换中文在终端占用的实际字符长度
        input_text_length=$(( input_text_length + input_zh_text_length )) # 最终显示文字的长度

        # 横线输出长度的计算
        shell_width=$(( (shell_width - input_text_length) / 2 )) # 除去输出字符后的横线宽度

        # 判断终端宽度大小是否是单双数
        shell_width_info=$(( shell_width % 2 ))
        # 判断字符宽度大小是否是单双数
        text_length_info=$(( input_text_length % 2 ))

        case "${shell_width_info}" in
            0)
                # 如果终端宽度大小是双数
                case "${text_length_info}" in
                    0) 
                        # 如果字符宽度大小是双数
                        print_mode=2
                        ;;
                    1)
                        # 如果字符宽度大小是单数
                        print_mode=3
                        ;;
                esac
                ;;
            1)
                # 如果终端宽度大小是单数数
                case "${text_length_info}" in
                    0)
                        # 如果字符宽度大小是双数
                        print_mode=2
                        ;;
                    1)
                        # 如果字符宽度大小是单数
                        print_mode=3
                        ;;
                esac
                ;;
        esac
    fi

    # 输出
    case "${print_mode}" in
        1)
            shell_width=$SHELL_WIDTH # 获取终端宽度
            yes "-" | sed $shell_width'q' | tr -d '\n' # 输出横杠
            ;;
        2)
            # 解决显示字符为单数时少显示一个字符导致不对成的问题
            echo "$(yes "-" | sed "${shell_width}"'q' | tr -d '\n')"$@"$(yes "-" | sed "${shell_width}"'q' | tr -d '\n')"
            ;;
        3)
            echo "$(yes "-" | sed "${shell_width}"'q' | tr -d '\n')"$@"$(yes "-" | sed $(( shell_width + 1 ))'q' | tr -d '\n')"
            ;;
    esac
}

# Term-SD 自动更新触发功能
# 使用 <Start Path>/term-sd/config/term-sd-auto-update.lock 检测是否启用的自动更新
# 使用 <Start Path>/term-sd/config/term-sd-auto-update-time.conf 获取上次更新的时间
term_sd_auto_update_trigger() {
    local start_time
    local end_time
    local start_time_sec
    local end_time_sec
    local time_span
    local normal_time_span=3600 # 检查更新时间间隔

    if [[ -f "${START_PATH}/term-sd/config/term-sd-auto-update.lock" ]] && [[ -d "${START_PATH}/term-sd/.git" ]]; then # 找到自动更新配置
        if [[ -f "${START_PATH}/term-sd/config/term-sd-auto-update-time.conf" ]]; then # 有上次运行记录
            start_time=`date +'%Y-%m-%d %H:%M:%S'` # 查看当前时间
            end_time=$(cat "${START_PATH}/term-sd/config/term-sd-auto-update-time.conf") # 获取上次更新时间
            start_time_sec=$(date --date="${start_time}" +%s) # 转换时间单位
            end_time_sec=$(date --date="${end_time}" +%s)
            time_span=$(( start_time_sec - end_time_sec )) # 计算相隔时间
            if (( time_span >= normal_time_span )); then # 判断时间间隔
                term_sd_auto_update
                date +'%Y-%m-%d %H:%M:%S' > "${START_PATH}/term-sd/config/term-sd-auto-update-time.conf" # 记录自动更新功能的启动时间
            fi
        else # 没有时直接执行
            term_sd_auto_update
            date +'%Y-%m-%d %H:%M:%S' > "${START_PATH}/term-sd/config/term-sd-auto-update-time.conf" # 记录自动更新功能的启动时间
        fi
    fi
}

# Term-SD 自动更新功能
term_sd_auto_update() {
    local ref
    local origin_branch
    local commit_hash
    local local_commit_hash

    term_sd_echo "检查更新中"
    git -C term-sd fetch
    if [[ "$?" = 0 ]]; then # 拉取远端内容成功后再更新
        ref=$(git -C "${START_PATH}/term-sd" symbolic-ref --quiet HEAD 2> /dev/null)
        if [[ "$?" = 0 ]]; then # 未出现分支游离
            origin_branch="origin/${ref#refs/heads/}"
        else # 出现分支游离时查询HEAD所指的分支
            origin_branch="origin/$(git -C "${START_PATH}/term-sd" branch -a | grep "/HEAD" | awk -F '/' '{print $NF}')"
        fi
        commit_hash=$(git -C "${START_PATH}/term-sd" log "${origin_branch}" --max-count 1 --format="%h")
        local_commit_hash=$(git -C "${START_PATH}/term-sd" show -s --format="%h")
        if [[ ! "${commit_hash}" == "${local_commit_hash}" ]]; then
            term_sd_echo "检测到 Term-SD 有新版本"
            term_sd_echo "是否选择更新(yes/no) ?"
            term_sd_echo "提示: 输入 yes 或 no 后回车"
            case "$(term_sd_read)" in
                yes|y|YES|Y)
                    term_sd_echo "更新 Term-SD 中"
                    git -C "${START_PATH}/term-sd" reset --hard "${commit_hash}"
                    cp -f "${START_PATH}/term-sd/term-sd.sh" "${START_PATH}/"
                    chmod +x "${START_PATH}/term-sd.sh"
                    TERM_SD_TO_RESTART=1
                    term_sd_echo "Term-SD 更新完成"
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

# Term-SD 安装功能
term_sd_install() {
    if [[ ! -d "${START_PATH}/term-sd" ]]; then
        term_sd_echo "检测到 Term-SD 组件未安装, 开始下载组件中"
        term_sd_clone_modules
        if [[ "$?" == 0 ]]; then
            term_sd_set_up_normal_setting
            TERM_SD_TO_RESTART=1
            cp -f "${START_PATH}/term-sd/term-sd.sh" "${START_PATH}/"
            chmod +x "${START_PATH}/term-sd.sh"
            term_sd_echo "Term-SD 安装成功"
        else
            term_sd_echo "Term-SD 安装失败, 可尝试重新运行"
            exit 1
        fi
    elif [[ ! -d "${START_PATH}/term-sd/.git" ]]; then
        term_sd_echo "检测到 Term-SD 的 .git 目录不存在, 将会导致 Term-SD 无法更新, 是否重新安装 (yes/no) ?"
        term_sd_echo "警告: 该操作将永久删除 Term-SD 目录中的所有文件 (除了 Term-SD 缓存文件夹和配置文件将备份到临时文件夹并在安装完成还原)"
        term_sd_echo "提示: 输入 yes 或 no 后回车"
        case "$(term_sd_read)" in
            yes|y|YES|Y)
                term_sd_backup_config
                term_sd_echo "清除 Term-SD 文件中"
                rm -rf "${START_PATH}/term-sd"
                term_sd_echo "Term-SD 文件清除完成"
                term_sd_clone_modules
                if [[ "$?" == 0 ]]; then
                    term_sd_restore_config
                    TERM_SD_TO_RESTART=1
                    cp -f "${START_PATH}/term-sd/term-sd.sh" "${START_PATH}/"
                    chmod +x "${START_PATH}/term-sd.sh"
                    term_sd_echo "Term-SD 重新安装成功"
                else
                    term_sd_echo "Term-SD 重新安装失败"
                    exit 1
                fi
                ;;
            *)
                term_sd_echo "取消重新安装 Term-SD 操作"
                ;;
        esac
    fi
}

# Term-SD 重新安装功能
# 使用 TERM_SD_TO_RESTART 全局变量标记 Term-SD 需要进行重载
term_sd_reinstall() {
    if which git &> /dev/null; then
        term_sd_echo "是否重新安装 Term-SD (yes/no) ?"
        term_sd_echo "警告: 该操作将永久删除 Term-SD 目录中的所有文件 (除了 Term-SD 缓存文件夹和配置文件将备份到临时文件夹并在安装完成还原)"
        term_sd_echo "提示: 输入 yes 或 no 后回车"
        case "$(term_sd_read)" in
            yes|y|YES|Y)
                term_sd_backup_config
                term_sd_echo "清除 Term-SD 文件中"
                rm -rf "${START_PATH}/term-sd"
                term_sd_echo "Term-SD 文件清除完成"
                term_sd_clone_modules
                if [[ "$?" == 0 ]]; then
                    term_sd_restore_config
                    TERM_SD_TO_RESTART=1
                    cp -f "${START_PATH}/term-sd/term-sd.sh" "${START_PATH}/"
                    chmod +x "${START_PATH}/term-sd.sh"
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

# 下载 Term-SD
term_sd_clone_modules() {
    local i
    local count=0
    local repo_urls="https://github.com/licyk/term-sd https://gitlab.com/licyk/term-sd https://licyk@bitbucket.org/licyks/term-sd https://gitee.com/licyk/term-sd"

    term_sd_echo "下载 Term-SD 中"
    for i in ${repo_urls}; do
        count=$((count + 1))
        git clone "${i}" "${START_PATH}/term-sd"
        if [[ "$?" == 0 ]]; then
            term_sd_echo "Term-SD 下载成功"
            return 0
        else
            term_sd_echo "Term-SD 下载失败"
            if [[ "${count}" -lt "$(echo "${repo_urls}" | wc --words)" ]]; then
                term_sd_echo "更换 Term-SD 下载源进行下载中"
            else
                return 1
            fi
        fi
    done
}

# 备份 cache 文件夹
# 备份的 cache 文件夹保存在 <Start Path>/term-sd-tmp
term_sd_backup_config() {
    term_sd_echo "备份 Term-SD 缓存文件夹和配置文件中"
    term_sd_mkdir "${START_PATH}/term-sd-tmp"
    term_sd_mkdir "${START_PATH}/term-sd-tmp/config"
    rm -f "${START_PATH}/term-sd/config/note.md"
    [[ -d "${START_PATH}/term-sd/config" ]] && mv -f "${START_PATH}"/term-sd/config/* "${START_PATH}"/term-sd-tmp/config
    [[ -d "${START_PATH}/term-sd/cache" ]] && mv -f "${START_PATH}"/term-sd/cache "${START_PATH}"/term-sd-tmp
    [[ -d "${START_PATH}/term-sd/requirements-backup" ]] && mv -f "${START_PATH}"/term-sd/requirements-backup "${START_PATH}"/term-sd-tmp
    [[ -d "${START_PATH}/term-sd/backup" ]] && mv -f "${START_PATH}"/term-sd/backup "${START_PATH}"/term-sd-tmp
}

# 恢复 cache 文件夹
# 从 <Start Path>/term-sd-tmp 恢复文件到 <Start Path>/term-sd 中
term_sd_restore_config() {
    term_sd_echo "恢复 Term-SD 缓存文件夹和配置文件中"
    [[ -d "${START_PATH}/term-sd-tmp/cache" ]] && mv -f "${START_PATH}/term-sd-tmp/cache" "${START_PATH}/term-sd"
    [[ -d "${START_PATH}/term-sd-tmp/config" ]] && mv -f "${START_PATH}"/term-sd-tmp/config/* "${START_PATH}/term-sd/config"
    [[ -d "${START_PATH}/term-sd-tmp/requirements-backup" ]] && mv -f "${START_PATH}/term-sd-tmp/requirements-backup" "${START_PATH}/term-sd"
    [[ -d "${START_PATH}/term-sd-tmp/backup" ]] && mv -f "${START_PATH}/term-sd-tmp/backup" "${START_PATH}/term-sd"
    rm -rf "${START_PATH}/term-sd-tmp"
}

# 设置默认 Term-SD 设置
# 设置完成后使用 <Start Path>/term-sd/config/install-by-launch-script.lock 标记已执行设置
term_sd_set_up_normal_setting() {
    if [[ ! -f "${START_PATH}/term-sd/config/term-sd-watch-retry.conf" ]]; then
        echo "3" > "${START_PATH}/term-sd/config/term-sd-watch-retry.conf"
        TERM_SD_CMD_RETRY=3
        term_sd_echo "Term-SD 命令执行监测设置已自动设置"
    fi

    if [[ ! -f "${START_PATH}/term-sd/config/term-sd-auto-update.lock" ]]; then
        touch "${START_PATH}/term-sd/config/term-sd-auto-update.lock"
        date +'%Y-%m-%d %H:%M:%S' > "${START_PATH}/term-sd/config/term-sd-auto-update-time.conf"
        term_sd_echo "Term-SD 自动更新已自动设置"
    fi

    if [[ ! -f "${START_PATH}/term-sd/config/set-aria2-thread.conf" ]]; then
        echo "16" > "${START_PATH}/term-sd/config/set-aria2-thread.conf"
        term_sd_echo "Term-SD 设置 Aria2 下载线程为 16"
    fi

    if [[ ! -f "${START_PATH}/term-sd/config/term-sd-pip-mirror.conf" ]]; then
        echo "2" > "${START_PATH}/term-sd/config/term-sd-pip-mirror.conf"
        term_sd_echo "Term-SD 设置 Pip 镜像源为国内镜像源"
    fi

    if [[ ! -f "${START_PATH}/term-sd/config/set-dynamic-global-github-mirror.lock" ]]; then
        touch "${START_PATH}"/term-sd/config/set-dynamic-global-github-mirror.lock
        term_sd_echo "Term-SD 启用 Github 镜像源"
    fi

    if [[ ! -f "${START_PATH}/term-sd/config/set-dynamic-global-huggingface-mirror.lock" ]]; then
        touch "${START_PATH}"/term-sd/config/set-dynamic-global-huggingface-mirror.lock
        term_sd_echo "Term-SD 启用 HuggingFace 镜像源"
    fi

    if [[ ! -f "${START_PATH}/term-sd/config/set-cuda-memory-alloc.lock" ]];then
        touch "${START_PATH}/term-sd/config/set-cuda-memory-alloc.lock"
        term_sd_echo "Term-SD 启用 CUDA 内存分配器设置"
    fi

    touch "${START_PATH}/term-sd/config/install-by-launch-script.lock"
}

# Term-SD 卸载功能
term_sd_remove() {
    term_sd_echo "是否卸载 Term-SD ?"
    term_sd_echo "警告: 该操作将永久删除 Term-SD 目录中的所有文件, 包括 AI 软件下载的部分模型文件 (存在于 Term-SD 目录中的 cache 文件夹, 如有必要, 请备份该文件夹)"
    term_sd_echo "提示: 输入 yes 或 no 后回车"
    case "$(term_sd_read)" in
        y|yes|YES|Y)
            term_sd_echo "开始卸载 Term-SD"
            rm -rf "${START_PATH}/term-sd"
            rm -rf "${START_PATH}/term-sd.sh"
            if [[ "${USER_SHELL}" == "bash" ]] || [[ "${USER_SHELL}" == "zsh" ]]; then
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

# Term-SD 添加快捷命令功能
# 仅支持在 Bash, Zsh 中添加快捷启动 Term-SD 命令
# 快捷启动命令保存在 .bashrc / .zshrc 文件中
install_cmd_to_shell() {
    while true; do
        case "${USER_SHELL}" in
            bash|zsh)
                term_sd_echo "是否将 Term-SD 快捷启动命令添加到 Shell 环境中 ?"
                term_sd_echo "添加后可使用 term_sd, tsd 命令启动 Term-SD"
                term_sd_echo "1、添加"
                term_sd_echo "2、删除"
                term_sd_echo "3、退出"
                term_sd_echo "提示: 输入数字后回车"
                case "$(term_sd_read)" in
                    1)
                        if cat ~/."${USER_SHELL}"rc | grep term_sd > /dev/null; then
                            term_sd_echo "Term-SD 快捷启动命令已存在, 是否刷新 (yes/no) ? "
                            term_sd_echo "提示: 输入 yes 或 no 后回车"
                            case "$(term_sd_read)" in
                                y|yes|YES|Y)
                                    remove_config_from_shell
                                    install_config_to_shell
                                    term_sd_echo "Term-SD 快捷启动命令刷新完成, 可使用 term_sd, tsd 命令启动 Term-SD, 退出 Term-SD 并重启 Shell"
                                    exec "${SHELL}"
                                    ;;
                                *)
                                    term_sd_echo "取消更新 Term-SD 快捷启动命令操作"
                                    ;;
                            esac
                        else
                            install_config_to_shell
                            term_sd_echo "Term-SD 快捷启动命令添加完成, 可使用 term_sd, tsd 命令启动 Term-SD, 退出 Term-SD 并重启 Shell"
                            exec "${SHELL}"
                        fi
                        break
                        ;;
                    2)
                        remove_config_from_shell
                        term_sd_echo "Term-SD 快捷启动命令已删除, 退出 Term-SD 并重启 Shell"
                        exec "${SHELL}"
                        break
                        ;;
                    3)
                        exit 0
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

# 将快捷命令写入 Shell 配置文件中
install_config_to_shell() {
    cat<<EOF >> ~/."${USER_SHELL}"rc
# Term-SD
term_sd(){ "$(pwd)/term-sd.sh" "\$@" || echo -e "[\033[33m\$(date "+%Y-%m-%d %H:%M:%S")\033[0m][\033[36mTerm-SD\033[0m]\033[36m::\033[0m Term-SD 异常退出" ; }
alias tsd="term_sd"
EOF
}

# 将快捷命令从 Shell 配置文件中删除
remove_config_from_shell() {
    sed -i '/# Term-SD/d' ~/."${USER_SHELL}"rc
    sed -i '/term_sd(){/d' ~/."${USER_SHELL}"rc
    sed -i '/alias tsd/d' ~/."${USER_SHELL}"rc
}

# 手动指定 Python 路径功能
# 如果 Python 可用, 则使用 TERM_SD_PYTHON_PATH 全局变量保存 Python 路径
# 将 Python 路径保存在 <Start Path>/term-sd/config/python-path.conf 文件中
set_python_path() {
    local input_python_path

    while true; do
        if [[ -z "$@" ]]; then
            term_sd_echo "请输入 Python 解释器的路径"
            term_sd_echo "提示: 输入完后请回车保存, 或者输入 exit 退出"
            read -p "===============================> " input_python_path
            if [[ -z "${input_python_path}" ]]; then
                term_sd_echo "未输入, 请重试"
            elif [[ "${input_python_path}" = "exit" ]]; then
                term_sd_echo "退出 Python 解释器路径指定功能"
                break
            elif [[ -f "${input_python_path}" ]]; then
                TERM_SD_PYTHON_PATH=$(term_sd_win2unix_path "${input_python_path}")
                echo "${TERM_SD_PYTHON_PATH}" > "${START_PATH}/term-sd/config/python-path.conf"
                term_sd_echo "Python 解释器路径指定完成"
                term_sd_echo "提示:"
                term_sd_echo "使用 --set-python-path 重新设置 Python 解释器路径"
                term_sd_echo "使用 --unset-python-path 删除 Python 解释器路径设置"
                break
            else
                term_sd_echo "输入的路径有误, 请重试"
            fi
        else # 直接将选项后面的参数作为路径
            if [[ -f "$@" ]]; then
                term_sd_echo "设置 Python 解释器路径: $@"
                TERM_SD_PYTHON_PATH=$(term_sd_win2unix_path "$@")
                echo "$TERM_SD_PYTHON_PATH" > "${START_PATH}/term-sd/config/python-path.conf"
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
prepare_tcmalloc() {
    local LIBC_VER
    local libc_vernum
    local libc_v234
    local TCMALLOC_LIBS
    local lib
    local TCMALLOC
    local TC_INFO

    case "${USE_TCMALLOC}" in
        0)
            term_sd_echo "取消加载内存优化"
            ;;
        *)
            if [[ "${OSTYPE}" == "linux"* ]] && [[ -z "${LD_PRELOAD}" ]]; then
                term_sd_echo "检测到系统为 Linux, 尝试启用内存优化"
                # 检查glibc版本
                LIBC_VER=$(echo $(ldd --version | awk 'NR==1 {print $NF}') | grep -oP '\d+\.\d+')
                term_sd_echo "glibc 版本为 ${LIBC_VER}"
                libc_vernum=$(expr ${LIBC_VER})
                # 从 2.34 开始，libpthread 已经集成到 libc.so 中
                libc_v234=2.34
                # 定义 Tcmalloc 库数组
                TCMALLOC_LIBS=("libtcmalloc(_minimal|)\.so\.\d" "libtcmalloc\.so\.\d")
                # 遍历数组
                for lib in "${TCMALLOC_LIBS[@]}"
                do
                    # 确定库支持的 Tcmalloc 类型
                    TCMALLOC="$(PATH=/usr/sbin:${PATH} ldconfig -p | grep -P "${lib}" | head -n 1)"
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
                                term_sd_echo "${TC_INFO} 没有链接到 libpthread, 将触发未定义符号: pthread_Key_create 错误"
                            fi
                        else
                            # libc.so（glibc）的2.34版本已将pthread库集成到glibc内部。在Ubuntu 22.04系统以及现代Linux系统和WSL（Windows Subsystem for Linux）环境下
                            # libc.so（glibc）链接了一个几乎能在所有Linux用户态环境中运行的库，因此通常无需额外检查
                            term_sd_echo "${TC_INFO} 链接到 libc.so, 执行 LD_PRELOAD=${TC_INFO[2]}"
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

# 自动选择 Github 镜像源
# 如果有可用的镜像源, 则使用 GIT_CONFIG_GLOBAL 环境变量指定 Git 配置文件路径
# 使用 <Start Path>/term-sd/config/set-global-github-mirror.conf 保存镜像源地址
term_sd_auto_setup_github_mirror() {
    if [[ -f "${START_PATH}/term-sd/config/set-dynamic-global-github-mirror.lock" ]]; then
        export GIT_CONFIG_GLOBAL="${START_PATH}/term-sd/config/.gitconfig"
        local mirror_status=0
        local i
        local url
        local github_mirror
        local HTTP_PROXY
        local HTTPS_PROXY
        HTTP_PROXY=
        HTTPS_PROXY=

        rm -f "${START_PATH}"/term-sd/config/.gitconfig
        rm -f "${START_PATH}"/term-sd/config/set-global-github-mirror.conf
        for i in ${GITHUB_MIRROR_LIST}; do
            rm -rf "${START_PATH}/term-sd/task/github_mirror_test" &> /dev/null
            github_mirror=$(echo ${i} | awk '{sub("/term_sd_git_user/term_sd_git_repo","")}1')
            term_sd_echo "测试 Github 镜像源: ${github_mirror}"
            url=$(echo ${i} | awk '{sub("term_sd_git_user","licyk")}1' | awk '{sub("term_sd_git_repo","empty")}1') # 生成格式化之后的链接
            git clone "${url}" "${START_PATH}/term-sd/task/github_mirror_test" --depth=1 &> /dev/null # 测试镜像源是否正常连接
            git_req=$?
            rm -rf "${START_PATH}/term-sd/task/github_mirror_test" &> /dev/null
            if [[ "${git_req}" == 0 ]]; then
                term_sd_echo "该 Github 镜像源可用"
                mirror_status=1
                break
            fi
        done

        if [[ "${mirror_status}" == 1 ]]; then
            term_sd_echo "设置 Github 镜像源"
            git config --global url."${github_mirror}".insteadOf "https://github.com"
            echo "${github_mirror}" > "${START_PATH}"/term-sd/config/set-global-github-mirror.conf
        else
            term_sd_echo "无可用 Github 镜像源, 取消使用 Github 镜像源"
            unset GIT_CONFIG_GLOBAL
        fi
    fi
}

# 自动选择 HuggingFace 镜像源
# 如果有可用的 HuggingFace 镜像, 则使用 HF_ENDPOINT 环境变量指定 HuggingFace 镜像源
# 使用 <Start Path>/term-sd/config/set-global-huggingface-mirror.conf 保存镜像源地址
term_sd_auto_setup_huggingface_mirror() {
    if [[ -f "${START_PATH}/term-sd/config/set-dynamic-global-huggingface-mirror.lock" ]]; then
        local mirror_status=0
        local i
        local huggingface_mirror
        local HTTP_PROXY
        local HTTPS_PROXY
        HTTP_PROXY=
        HTTPS_PROXY=
        rm -f "${START_PATH}"/term-sd/config/set-global-huggingface-mirror.conf

        for i in ${HUGGINGFACE_MIRROR_LIST}; do
            term_sd_echo "测试 HuggingFace 镜像源: ${i}"
            curl ${i}/licyk/sd-model/resolve/main/README.md -o /dev/null --connect-timeout 10 --silent
            if [[ "$?" == 0 ]]; then
                term_sd_echo "该 HuggingFace 镜像源可用"
                huggingface_mirror=$i
                mirror_status=1
                break
            fi
        done

        if [[ "${mirror_status}" == 1 ]]; then
            term_sd_echo "设置 HuggingFace 镜像源"
            export HF_ENDPOINT=$huggingface_mirror
            echo "${huggingface_mirror}" > "${START_PATH}"/term-sd/config/set-global-huggingface-mirror.conf
        else
            term_sd_echo "无可用 HuggingFace 镜像源, 取消设置 HuggingFace 镜像源"
        fi
    fi
}

# 用户协议
# 同意用户协议后使用 <Start Path>/term-sd/config/agree-user-agreement.lock 标记
term_sd_user_agreement() {
    if [[ ! -f "${START_PATH}/term-sd/config/agree-user-agreement.lock" ]]; then
        term_sd_print_line "用户协议"
        cat term-sd/help/user_agreement.md
        echo
        term_sd_print_line
        term_sd_echo "是否同意该用户协议 (yes/no) ?"
        case "$(term_sd_read)" in
            yes|y|YES|Y)
                touch "${START_PATH}/term-sd/config/agree-user-agreement.lock"
                term_sd_echo "确认同意该用户协议"
                ;;
            *)
                term_sd_echo "取消同意该用户协议"
                term_sd_echo "退出 Term-SD"
                exit 0
                ;;
        esac
    fi
}

# 获取 Dialog 的宽高度
get_dialog_size() {
    echo "${DIALOG_HEIGHT}" "${DIALOG_WIDTH}"
}

# 获取 Dialog 的宽高度(附带 Dialog 菜单高度)
get_dialog_size_menu() {
    echo "${DIALOG_HEIGHT}" "${DIALOG_WIDTH}" "${DIALOG_MENU_HEIGHT}"
}

main() {
    # 切换到 term-sd.sh 文件所在位置
    cd "$(cd "$(dirname "$0")" ; pwd)"

    # 目录结构检测, 发现错误时修正路径
    if [[ ! -d "term-sd" ]] \
        && [[ -d ".git" ]] \
        && [[ -d "modules" ]] \
        && [[ -f "modules/init.sh" ]] \
        && [[ -d "extra" ]] \
        && [[ -d "install" ]] \
        && [[ -d "task" ]] \
        && [[ -d "help" ]] \
        && [[ -d "config" ]]; then
        cd ..
    fi

    # root 权限检测
    if [[ $(id -u) -eq 0 ]]; then
        term_sd_echo "检测到使用 root 权限运行 Term-SD, 这可能会导致不良后果"
        term_sd_echo "是否继续运行 Term-SD (yes/no) ?"
        term_sd_echo "提示: 输入 yes 或 no 后回车"
        case "$(term_sd_read)" in
            yes|y|YES|Y)
                term_sd_echo "继续初始化 Term-SD"
                ;;
            *)
                term_sd_echo "终止 Term-SD 初始化进程"
                term_sd_echo "退出 Term-SD"
                exit 0
                ;;
        esac
    fi

    # 变量初始化
    TERM_SD_VER="1.4.6" #  Term-SD 版本
    USER_SHELL=$(basename "${SHELL}") # 读取用户所使用的 Shell
    START_PATH=$(pwd) # 设置启动时脚本路径
    export PYTHONUTF8=1 # 强制 Python 解释器使用 UTF-8 编码来处理字符串, 避免乱码问题
    export PYTHONIOENCODING=utf8
    export PIP_TIMEOUT=30 # 设置 Pip 的超时时间
    export PIP_RETRIES=5 # 设置 Pip 的重试次数
    export PIP_DISABLE_PIP_VERSION_CHECK # Pip 版本版本检查
    export SAFETENSORS_FAST_GPU=1 # 强制所有模型使用 GPU 加载
    TERM_SD_PIP_INDEX_URL="https://mirrors.cloud.tencent.com/pypi/simple" # 保存 Pip 镜像源地址
    # TERM_SD_PIP_EXTRA_INDEX_URL="https://mirror.baidu.com/pypi/simple"
    TERM_SD_PIP_EXTRA_INDEX_URL="https://mirrors.cernet.edu.cn/pypi/web/simple"
    TERM_SD_PIP_FIND_LINKS="https://mirrors.aliyun.com/pytorch-wheels/torch_stable.html https://mirror.sjtu.edu.cn/pytorch-wheels/torch_stable.html"
    TERM_SD_PYPI_MIRROR="https://licyk.github.io/t/pypi/index_ms_mirror.html"
    TERM_SD_PIP_INDEX_URL_ARG="" # 用于设置 Pip 镜像源的命令参数
    TERM_SD_PIP_EXTRA_INDEX_URL_ARG=""
    TERM_SD_PIP_FIND_LINKS_ARG=""
    # Github 镜像源列表
    GITHUB_MIRROR_LIST="https://ghp.ci/https://github.com/term_sd_git_user/term_sd_git_repo https://mirror.ghproxy.com/https://github.com/term_sd_git_user/term_sd_git_repo https://ghproxy.net/https://github.com/term_sd_git_user/term_sd_git_repo https://gh-proxy.com/https://github.com/term_sd_git_user/term_sd_git_repo https://ghps.cc/https://github.com/term_sd_git_user/term_sd_git_repo https://gh.idayer.com/https://github.com/term_sd_git_user/term_sd_git_repo ttps://gitclone.com/github.com/term_sd_git_user/term_sd_git_repo"
    HUGGINGFACE_MIRROR_LIST="https://hf-mirror.com https://huggingface.sukaka.top" # HuggingFace 镜像源列表
    local term_sd_is_missing_dep=0 # 依赖缺失标记
    local term_sd_is_missing_macos_dep=0
    TERM_SD_TO_RESTART=0 # Term-SD 是否需要重启的标志
    SHELL_WIDTH=$(stty size | awk '{print $2}') # 获取终端宽度
    SHELL_HEIGHT=$(stty size | awk '{print $1}') # 获取终端高度
    local term_sd_depend="git aria2c dialog curl" # Term-SD 依赖的软件包
    local term_sd_depend_macos="wget rustc cmake protoc" # (MacOS)
    local term_sd_depend_python="venv tkinter pip" # (Python 模块)
    local missing_depend_name
    local i
    local vc_runtime_dll_path

    # 在使用 HTTP_PROXY 变量后, 会出现 ValueError: When localhost is not accessible, a shareable link must be created. Please set share=True
    # 导致启动异常
    # 需要设置 NO_PROXY 让 localhost,127.0.0.1,::1 不走 HTTP_PROXY
    # 参考: https://github.com/microsoft/TaskMatrix/issues/250
    # 除了避免 HTTP_PROXY 变量的影响, 也避免了代理软件的影响(在启动 SD WebUI 前开启代理软件可能会导致无法生图(启动后再开启没有影响), 并报错, 设置该变量后完美解决该问题)
    export NO_PROXY="localhost,127.0.0.1,::1" 

    term_sd_print_line "Term-SD"

    # 判断直接启动 Term-SD 还是重启 Term-SD
    if [[ "${TERM_SD_IS_PREPARE_ENV}" == 1 ]]; then
        # 检测到是重启
        term_sd_echo "重启 Term-SD 中"
    else
        term_sd_echo "Term-SD 初始化中"
        TERM_SD_SCRIPT_NAME="null"  # Term-SD 扩展脚本
        term_sd_launch_arg_parse "$@" # 处理用户输入的参数
    fi

    # Dialog 使用文档: https://manpages.debian.org/bookworm/dialog/dialog.1.en.html
    # 设置 Dialog 界面的大小
    DIALOG_MENU_HEIGHT=10 # Dialog 列表高度

    if [[ $(( SHELL_WIDTH -20 )) -le 12 ]]; then # Dialog 宽度
        DIALOG_WIDTH=-1
    else
        DIALOG_WIDTH=$(( SHELL_WIDTH -20 ))
    fi

    if [[ $(( SHELL_HEIGHT - 6 )) -le 6 ]]; then # Dialog 高度
        DIALOG_HEIGHT=-1
    else
        DIALOG_HEIGHT=$(( SHELL_HEIGHT - 6 ))
    fi

    # 分隔符变量
    TERM_SD_DELIMITER=$(yes "-" | sed $(( DIALOG_WIDTH - 4 ))'q' | tr -d '\n') # 分隔符号

    # 设置 Term-SD 的 Debug 模式的环境变量设置
    if [[ -z "${TERM_SD_ENABLE_DEBUG}" ]]; then
        TERM_SD_ENABLE_DEBUG=0
    fi

    # 设置 Pip 自动更新的环境变量设置
    if [[ -z "${ENABLE_PIP_VER_CHECK}" ]]; then
        ENABLE_PIP_VER_CHECK=0
        PIP_DISABLE_PIP_VERSION_CHECK=1
    fi

    # 存在 Python 自定义路径配置文件时自动读取到变量中
    if [[ -f "${START_PATH}/term-sd/config/python-path.conf" ]]; then
        TERM_SD_PYTHON_PATH=$(cat "${START_PATH}/term-sd/config/python-path.conf")
    fi

    if [[ -f "${START_PATH}/term-sd/config/proxy.conf" ]]; then # 读取代理设置并设置代理
        export HTTP_PROXY=$(cat "${START_PATH}/term-sd/config/proxy.conf")
        export HTTPS_PROXY=$(cat "${START_PATH}/term-sd/config/proxy.conf")
        # 代理变量的说明: https://blog.csdn.net/Dancen/article/details/128045261
    fi
    TERM_SD_PROXY=$HTTPS_PROXY # 代理地址储存到特殊变量中, 用于恢复代理时作为参数使用

    # 设置 Term-SD 安装重试次数
    if [[ -f "${START_PATH}/term-sd/config/term-sd-watch-retry.conf" ]]; then
        TERM_SD_CMD_RETRY=$(cat "${START_PATH}/term-sd/config/term-sd-watch-retry.conf")
    else # 没有配置文件时使用默认值
        TERM_SD_CMD_RETRY=0
    fi

    # 设置虚拟环境的启用状态
    if [[ -f "${START_PATH}/term-sd/config/term-sd-venv-disable.lock" ]]; then
        ENABLE_VENV=0
    else
        ENABLE_VENV=1
    fi

    # 设置 Term-SD 执行安装时使用的安装模式
    if [[ -f "${START_PATH}/term-sd/config/term-sd-disable-strict-install-mode.lock" ]]; then
        TERM_SD_ENABLE_STRICT_INSTALL_MODE=0
    else
        TERM_SD_ENABLE_STRICT_INSTALL_MODE=1
    fi

    # 生成设置 Pip 镜像源的参数
    for i in ${TERM_SD_PIP_INDEX_URL}; do
        TERM_SD_PIP_INDEX_URL_ARG="$TERM_SD_PIP_INDEX_URL_ARG --index-url ${i}"
    done
    TERM_SD_PIP_INDEX_URL_ARG=$(echo "${TERM_SD_PIP_INDEX_URL_ARG}")


    for i in ${TERM_SD_PIP_EXTRA_INDEX_URL}; do
        TERM_SD_PIP_EXTRA_INDEX_URL_ARG="$TERM_SD_PIP_EXTRA_INDEX_URL_ARG --extra-index-url ${i}"
    done
    TERM_SD_PIP_EXTRA_INDEX_URL_ARG=$(echo "${TERM_SD_PIP_EXTRA_INDEX_URL_ARG}")


    for i in ${TERM_SD_PIP_FIND_LINKS}; do
        TERM_SD_PIP_FIND_LINKS_ARG="$TERM_SD_PIP_FIND_LINKS_ARG --find-links ${i}"
    done
    TERM_SD_PIP_FIND_LINKS_ARG=$(echo "${TERM_SD_PIP_FIND_LINKS_ARG}")


    # 设置 AI 软件路径
    if [[ -f "${START_PATH}/term-sd/config/sd-webui-path.conf" ]]; then
        SD_WEBUI_PATH=$(cat "${START_PATH}/term-sd/config/sd-webui-path.conf")
        SD_WEBUI_FOLDER=$(basename "${SD_WEBUI_PATH}")
        SD_WEBUI_PARENT_PATH=$(dirname "${SD_WEBUI_PATH}")
    else
        SD_WEBUI_PATH="${START_PATH}/stable-diffusion-webui"
        SD_WEBUI_FOLDER="stable-diffusion-webui"
        SD_WEBUI_PARENT_PATH=${START_PATH}
    fi

    if [[ -f "${START_PATH}/term-sd/config/comfyui-path.conf" ]]; then
        COMFYUI_PATH=$(cat "${START_PATH}/term-sd/config/comfyui-path.conf")
        COMFYUI_FOLDER=$(basename "${COMFYUI_PATH}")
        COMFYUI_PARENT_PATH=$(dirname "${COMFYUI_PATH}")
    else
        COMFYUI_PATH="${START_PATH}/ComfyUI"
        COMFYUI_FOLDER="ComfyUI"
        COMFYUI_PARENT_PATH=${START_PATH}
    fi

    if [[ -f "${START_PATH}/term-sd/config/invokeai-path.conf" ]]; then
        INVOKEAI_PATH=$(cat "${START_PATH}/term-sd/config/invokeai-path.conf")
        INVOKEAI_FOLDER=$(basename "${INVOKEAI_PATH}")
        INVOKEAI_PARENT_PATH=$(dirname "${INVOKEAI_PATH}")
    else
        INVOKEAI_PATH="${START_PATH}/InvokeAI"
        INVOKEAI_FOLDER="InvokeAI"
        INVOKEAI_PARENT_PATH=${START_PATH}
    fi

    if [[ -f "${START_PATH}/term-sd/config/fooocus-path.conf" ]]; then
        FOOOCUS_PATH=$(cat "${START_PATH}/term-sd/config/fooocus-path.conf")
        FOOOCUS_FOLDER=$(basename "${FOOOCUS_PATH}")
        FOOOCUS_PARENT_PATH=$(dirname "${FOOOCUS_PATH}")
    else
        FOOOCUS_PATH="${START_PATH}/Fooocus"
        FOOOCUS_FOLDER="Fooocus"
        FOOOCUS_PARENT_PATH=${START_PATH}
    fi

    if [[ -f "${START_PATH}/term-sd/config/lora-scripts-path.conf" ]]; then
        LORA_SCRIPTS_PATH=$(cat "${START_PATH}/term-sd/config/lora-scripts-path.conf")
        LORA_SCRIPTS_FOLDER=$(basename "${LORA_SCRIPTS_PATH}")
        LORA_SCRIPTS_PARENT_PATH=$(dirname "${LORA_SCRIPTS_PATH}")
    else
        LORA_SCRIPTS_PATH="${START_PATH}/lora-scripts"
        LORA_SCRIPTS_FOLDER="lora-scripts"
        LORA_SCRIPTS_PARENT_PATH=${START_PATH}
    fi

    if [[ -f "${START_PATH}/term-sd/config/kohya_ss-path.conf" ]]; then
        KOHYA_SS_PATH=$(cat "${START_PATH}/term-sd/config/kohya_ss-path.conf")
        KOHYA_SS_FOLDER=$(basename "${KOHYA_SS_PATH}")
        KOHYA_SS_PARENT_PATH=$(dirname "${KOHYA_SS_PATH}")
    else
        KOHYA_SS_PATH="${START_PATH}/kohya_ss"
        KOHYA_SS_FOLDER="kohya_ss"
        KOHYA_SS_PARENT_PATH=${START_PATH}
    fi

    # 获取 Bash 主版本
    BASH_MAJOR_VERSION=$(awk -F '.' '{print $1}' <<< ${BASH_VERSION})

    # 依赖检测
    if [[ ! "${TERM_SD_IS_PREPARE_ENV}" == 1 ]]; then # 判断启动状态
        term_sd_echo "检测依赖软件是否安装"

        # 检测可用的 Python命令, 并检测是否手动指定 Python 路径
        if [[ -z "${TERM_SD_PYTHON_PATH}" ]]; then
            if python3 --version &> /dev/null || python --version &> /dev/null; then # 判断是否有可用的 Python
                if [[ ! -z "$(python3 --version 2> /dev/null)" ]]; then
                    TERM_SD_PYTHON_PATH=$(which python3)
                elif [[ ! -z "$(python --version 2> /dev/null)" ]]; then
                    TERM_SD_PYTHON_PATH=$(which python)
                fi
            else
                term_sd_is_missing_dep=1
                missing_depend_name="${missing_depend_name} python,"
            fi
        else
            if "${TERM_SD_PYTHON_PATH}" --version &> /dev/null; then
                term_sd_echo "使用自定义 Python 解释器路径: ${TERM_SD_PYTHON_PATH}"
            else
                term_sd_echo "手动指定的 Python 路径错误"
                term_sd_echo "提示:"
                term_sd_echo "使用 --set-python-path 重新设置 Python 解释器路径"
                term_sd_echo "使用 --unset-python-path 删除 Python 解释器路径设置"
                term_sd_is_missing_dep=1
                missing_depend_name="${missing_depend_name} python,"
            fi
        fi

        # 检测 Python 模块是否安装
        for i in ${term_sd_depend_python}; do
            if ! "$TERM_SD_PYTHON_PATH" -c "import ${i}" &> /dev/null; then
                term_sd_is_missing_dep=1
                missing_depend_name="${missing_depend_name} python_module:${i},"
            fi
        done

        #判断系统是否安装必须使用的软件
        for i in ${term_sd_depend}; do
            if ! which "${i}" &> /dev/null; then
                case "${i}" in
                    aria2c)
                        i=aria2
                        ;;
                esac
                missing_depend_name="${missing_depend_name} ${i},"
                term_sd_is_missing_dep=1
            fi
        done

        # 依赖检测(MacOS)
        if [[ "${OSTYPE}" == "darwin"* ]]; then
            export PYTORCH_ENABLE_MPS_FALLBACK=1 # 启用自动回滚运算
            for i in ${term_sd_depend_macos}; do
                if ! which "${i}" &> /dev/null; then
                    # 转换名称
                    case "${i}" in
                        rustc)
                            i=rust
                            ;;
                        protoc)
                            i=protobuf
                            ;;
                    esac
                    MISSING_DEPEND_MACOS_NAME="${MISSING_DEPEND_MACOS_NAME} ${i},"
                    term_sd_is_missing_macos_dep=1
                fi
            done

            if [[ "${term_sd_is_missing_macos_dep}" == 1 ]]; then
                print_line_to_shell "缺少以下依赖"
                for i in ${MISSING_DEPEND_MACOS_NAME}; do
                    echo "${i}"
                done
                unset MISSING_DEPEND_MACOS_NAME
                print_line_to_shell
                term_sd_echo "缺少依赖将影响 AI 软件的安装, 请退出 Term-SD 并使用 Homebrew (如果没有 Homebrew, 则先安装 Homebrew, 再用 Homebrew 去安装其他缺少依赖) 安装缺少的依赖后重试"
                term_sd_sleep 5
            fi
        fi

        # 依赖检测(Windows)
        if is_windows_platform; then
            if [[ ! -z "${SYSTEMROOT}" ]]; then
                vc_runtime_dll_path="$(term_sd_win2unix_path "${SYSTEMROOT}")/System32/vcruntime140_1.dll"
            else
                vc_runtime_dll_path="/c/Windows/System32/vcruntime140_1.dll"
            fi

            if [[ ! -f "${vc_runtime_dll_path}" ]]; then
                term_sd_echo "检测到 Microsoft Visual C++ Redistributable 未安装, 这可能会导致部分功能异常或无法正常启动, 请安装 Microsoft Visual C++ Redistributable 后再试"
                term_sd_sleep 5
            fi
        fi

        # 判断依赖检测结果
        if [[ "${term_sd_is_missing_dep}" == 0 ]]; then
            term_sd_echo "依赖检测完成, 无缺失依赖"
            prepare_tcmalloc # 配置内存优化(Linux)
            term_sd_install
            if [[ -d "term-sd/modules" ]]; then # 找到目录后才启动
                term_sd_auto_update_trigger
                TERM_SD_IS_PREPARE_ENV=1 # 用于检测 Term-SD 的启动状态, 设置后不再重新执行依赖检测
            else
                term_sd_echo "Term-SD 模块丢失, 输入 ./term-sd.sh --reinstall-term-sd 重新安装 Term-SD"
                exit 1
            fi
        else
            term_sd_print_line "缺少以下依赖"
            for i in ${missing_depend_name}; do
                echo "${i}"
            done
            term_sd_print_line
            term_sd_echo "请安装缺少的依赖后重试"
            exit 1
        fi

        if [[ ! -f "${START_PATH}/term-sd/config/install-by-launch-script.lock" ]]; then # 检测是否通过启动脚本安装 Term-SD
            term_sd_set_up_normal_setting # 非启动脚本安装时设置默认 Term-SD 设置
        fi

        term_sd_auto_setup_github_mirror # 配置 Github 镜像源
        term_sd_auto_setup_huggingface_mirror # 配置 HuggingFace 镜像源
        term_sd_user_agreement # 用户协议
    fi

    # 放在依赖检测之后, 解决一些奇怪的问题
    # 设置缓存路径的环境变量
    if [[ ! -f "${START_PATH}/term-sd/config/disable-cache-path-redirect.lock" ]]; then
        export CACHE_HOME="${START_PATH}/term-sd/cache"
        export HF_HOME="${START_PATH}/term-sd/cache/huggingface"
        export MATPLOTLIBRC="${START_PATH}/term-sd/cache"
        export MODELSCOPE_CACHE="${START_PATH}/term-sd/cache/modelscope/hub"
        export MS_CACHE_HOME="${START_PATH}/term-sd/cache/modelscope/hub"
        export SYCL_CACHE_DIR="${START_PATH}/term-sd/cache/libsycl_cache"
        export TORCH_HOME="${START_PATH}/term-sd/cache/torch"
        export U2NET_HOME="${START_PATH}/term-sd/cache/u2net"
        export XDG_CACHE_HOME="${START_PATH}/term-sd/cache"
        export PIP_CACHE_DIR="${START_PATH}/term-sd/cache/pip"
        export PYTHONPYCACHEPREFIX="${START_PATH}/term-sd/cache/pycache"
        # export TRANSFORMERS_CACHE="${START_PATH}/term-sd/cache/huggingface/transformers"
    fi

    # 设置 Pip 镜像源的环境变量
    if [[ -f "${START_PATH}/term-sd/config/term-sd-pip-mirror.conf" ]]; then
        case "$(cat "${START_PATH}/term-sd/config/term-sd-pip-mirror.conf")" in
            1)
                export PIP_INDEX_URL="https://pypi.python.org/simple"
                export PIP_EXTRA_INDEX_URL=""
                export PIP_FIND_LINKS="https://download.pytorch.org/whl/torch_stable.html ${TERM_SD_PYPI_MIRROR}"
                ;;
            2)
                export PIP_INDEX_URL=$TERM_SD_PIP_INDEX_URL
                export PIP_EXTRA_INDEX_URL=$TERM_SD_PIP_EXTRA_INDEX_URL
                export PIP_FIND_LINKS="$TERM_SD_PIP_FIND_LINKS ${TERM_SD_PYPI_MIRROR}"
                ;;
            *)
                export PIP_INDEX_URL=$TERM_SD_PIP_INDEX_URL
                export PIP_EXTRA_INDEX_URL=$TERM_SD_PIP_EXTRA_INDEX_URL
                export PIP_FIND_LINKS="$TERM_SD_PIP_FIND_LINKS ${TERM_SD_PYPI_MIRROR}"
                ;;
        esac
    fi

    # Github 镜像源设置
    if [[ ! -f "${START_PATH}/term-sd/config/set-dynamic-global-github-mirror.lock" ]] && [[ -f "${START_PATH}/term-sd/config/set-global-github-mirror.conf" ]]; then
        export GIT_CONFIG_GLOBAL="${START_PATH}/term-sd/config/.gitconfig"
    fi

    # HuggingFace 镜像源设置
    if [[ ! -f "${START_PATH}/term-sd/config/set-dynamic-global-huggingface-mirror.lock" ]] && [[ -f "${START_PATH}/term-sd/config/set-global-huggingface-mirror.conf" ]]; then
        export HF_ENDPOINT=$(cat "${START_PATH}/term-sd/config/set-global-huggingface-mirror.conf")
    fi

    # 设置安装 AI 软件时调用 Aria2 下载模型的线程数
    if [[ -f "${START_PATH}/term-sd/config/set-aria2-thread.conf" ]]; then
        ARIA2_MULTI_THREAD=$(cat "${START_PATH}/term-sd/config/set-aria2-thread.conf")
    else
        ARIA2_MULTI_THREAD=1
    fi

    #############################

    # 自动更新成功时重载环境
    if [[ "${TERM_SD_TO_RESTART}" == 1 ]]; then
        term_sd_echo "重载 Term-SD 启动脚本中"
        . ./term-sd/term-sd.sh
    fi

    term_sd_echo "Term-SD 版本: ${TERM_SD_VER}"
    if [[ -d "${START_PATH}/term-sd/.git" ]]; then
        term_sd_echo "Commit: $(git --git-dir="${START_PATH}/term-sd/.git" show -s --format="%h %cd" --date=format:"%Y-%m-%d %H:%M:%S")"
    fi

    # TERM_SD_SCRIPT_NAME 全局变量不为空时执行启动 Term-SD 扩展脚本的功能
    case "${TERM_SD_SCRIPT_NAME}" in
        null)
            . "${START_PATH}"/term-sd/modules/init.sh # 加载 Term-SD 模块
            ;;
        *)
            term_sd_extra_scripts_launch "${TERM_SD_SCRIPT_NAME}"
            ;;
    esac

    # 启动 Term-SD
    term_sd_echo "启动 Term-SD 中"
    term_sd_version
    term_sd_manager
}

main "$@"
