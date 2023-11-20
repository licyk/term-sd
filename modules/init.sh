#!/bin/bash

# term-sd初始化部分
term_sd_init()
{
    local modules_count_sum="$(( $(ls ./term-sd/modules/*.sh | wc -w) - 1 ))" # 需要加载的模块数量
    local count=1
    local info="[\033[33m$(date "+%Y-%m-%d %H:%M:%S")\033[0m][\033[36mTerm-SD\033[0m]:: "
    for i in ./term-sd/modules/*.sh ;do
        [ $i = "./term-sd/modules/init.sh" ] && continue
        printf "$info[$count/$modules_count_sum] 加载: $(basename $i .sh)                              \r"
        count=$(( $count + 1 ))
        source $i
    done
    printf "[\033[33m$(date "+%Y-%m-%d %H:%M:%S")\033[0m][\033[36mTerm-SD\033[0m]:: 初始化Term-SD完成                               \n"
    term_sd_print_line
}

# term-sd初始化部分(带进度条)
term_sd_init_new()
{
    local modules_count_sum="$(( $(ls ./term-sd/modules/*.sh | wc -w) - 1 ))" # 需要加载的模块数量
    local count=1
    local bar_length=$(( $term_sd_shell_width - 50)) # 初始进度条的总长度
    local i
    for i in ./term-sd/modules/*.sh ;do
        [ $i = "./term-sd/modules/init.sh" ] && continue # 避免重新初始化init.sh脚本
        term_sd_process_bar $bar_length $count $modules_count_sum # 输出进度条
        count=$(( $count + 1 ))
        source $i # 加载模块
    done
    term_sd_echo "初始化Term-SD完成"
    term_sd_print_line
}

# 进度条生成功能(开了只会降低加载速度)
term_sd_process_bar()
{
    local modules_count=$2
    local modules_count_sum=$3
    local mark
    local bar_length
    local bar_display='█' # 已完成的进度显示效果
    local bar
    local bar_length_sum=$1
    local i
    mark=$(echo $(awk 'BEGIN {print '$modules_count' / '$modules_count_sum' * 100 }') | awk -F'.' '{print $1}') #加载进度百分比
    bar_length=$(echo $(awk 'BEGIN {print '$modules_count' / '$modules_count_sum' * '$bar_length_sum' }') | awk -F'.' '{print $1}') #进度条已完成的实时长度

    for i in $(seq 1 $bar_length_sum); do # 这个循环将空的进度条填上一堆空格
        if [ $i -gt $bar_length ] ; then # 更换进度条的内容
            bar_display=' '
        fi
        bar="${bar}${bar_display}" # 一开始是空的，通过循环填上一堆空格,然后逐渐减少空格数量,增加方块符号的数量
    done
    printf "[\033[33m$(date "+%Y-%m-%d %H:%M:%S")\033[0m][\033[36mTerm-SD\033[0m]:: 加载模块中|${bar}| ${mark}%%\r"
    [ $modules_count = $modules_count_sum ] && echo
}

# 无进度显示的初始化功能(增加进度显示只会降低加载速度)
term_sd_init_no_bar()
{
    for i in ./term-sd/modules/*.sh ;do
        [ $i = "./term-sd/modules/init.sh" ] && continue
        source $i
    done
    term_sd_echo "初始化Term-SD完成"
    term_sd_print_line
}

# 初始化功能
if [ -f "./term-sd/term-sd-no-bar.lock" ];then
    term_sd_init_no_bar
elif [ -f "./term-sd/term-sd-new-bar.lock" ];then
    term_sd_init_new
else
    term_sd_init
fi
