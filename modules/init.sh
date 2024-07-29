#!/bin/bash

# Term-SD 初始化模块
term_sd_init() {
    local sum=$(( $(ls "${START_PATH}"/term-sd/modules/*.sh | wc -w) - 1 )) # 需要加载的模块数量
    local count=1
    local module_name
    local i
    for i in "${START_PATH}"/term-sd/modules/*.sh; do
        [[ "${i}" == "${START_PATH}/term-sd/modules/init.sh" ]] && continue
        module_name=${i#${START_PATH}/term-sd/modules/}
        module_name=${module_name%.sh}
        printf "[\033[33m$(date "+%Y-%m-%d %H:%M:%S")\033[0m][\033[36mTerm-SD\033[0m]\033[36m::\033[0m [${count}/${sum}] 加载: ${module_name}                   \r"
        count=$(( $count + 1 ))
        . "${i}"
    done
    printf "[\033[33m$(date "+%Y-%m-%d %H:%M:%S")\033[0m][\033[36mTerm-SD\033[0m]\033[36m::\033[0m 初始化 Term-SD 完成                    \n"
    term_sd_print_line
}

# Term-SD 初始化模块(带进度条)
term_sd_init_new() {
    local sum=$(( $(ls "${START_PATH}"/term-sd/modules/*.sh | wc -w) - 1 )) # 需要加载的模块数量
    local count=1
    local bar_length=$(( SHELL_WIDTH - 50 )) # 初始进度条的总长度
    local i
    for i in "${START_PATH}"/term-sd/modules/*.sh; do
        [[ "${i}" == "${START_PATH}/term-sd/modules/init.sh" ]] && continue # 避免重新初始化 init.sh 脚本
        term_sd_process_bar "${bar_length}" "${count}" "${sum}" # 输出进度条
        count=$(( count + 1 ))
        . "${i}" # 加载模块
    done
    term_sd_echo "初始化 Term-SD 完成"
    term_sd_print_line
}

# 进度条生成功能(开了只会降低加载速度)
# 使用:
# term_sd_process_bar <进度条总长度> <已完成进度> <总进度>
term_sd_process_bar() {
    local count=$2
    local sum=$3
    local mark
    local bar_length
    local bar_display='█' # 已完成的进度显示效果
    local bar
    local bar_length_sum=$1
    local i
    mark=$(echo $(awk 'BEGIN {print '$count' / '$sum' * 100 }') | awk -F'.' '{print $1}') # 加载进度百分比
    bar_length=$(echo $(awk 'BEGIN {print '$count' / '$sum' * '$bar_length_sum' }') | awk -F '.' '{print $1}') # 进度条已完成的实时长度

    for i in $(seq 1 ${bar_length_sum}); do # 这个循环将空的进度条填上一堆空格
        if [[ "${i}" -gt "${bar_length}" ]]; then # 更换进度条的内容
            bar_display=' '
        fi
        bar="${bar}${bar_display}" # 一开始是空的, 通过循环填上一堆空格, 然后逐渐减少空格数量, 增加方块符号的数量
    done
    printf "[\033[33m$(date "+%Y-%m-%d %H:%M:%S")\033[0m][\033[36mTerm-SD\033[0m]\033[36m::\033[0m 加载模块中|${bar}| ${mark}%%\r"
    [[ "${count}" == "${sum}" ]] && echo
}

# 无进度显示的初始化功能(增加进度显示只会降低加载速度)
term_sd_init_no_bar() {
    local i
    for i in "${START_PATH}"/term-sd/modules/*.sh; do
        [[ "${i}" == "${START_PATH}/term-sd/modules/init.sh" ]] && continue
        . "${i}"
    done
    term_sd_echo "初始化 Term-SD 完成"
    term_sd_print_line
}

# 初始化功能
if [[ -f "${START_PATH}/term-sd/config/term-sd-bar.conf" ]]; then
    case "$(cat "${START_PATH}/term-sd/config/term-sd-bar.conf")" in
        none)
            term_sd_init_no_bar
            ;;
        new)
            term_sd_init_new
            ;;
        *)
            term_sd_init
            ;;
    esac
else
    term_sd_init
fi
