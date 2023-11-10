#!/bin/bash

# term-sd初始化部分
term_sd_init()
{
    term_sd_modules_number=$(( $(ls ./term-sd/modules/*.sh | wc -w) - 1 ))
    term_sd_modules_number_=1
    term_sd_init_bar_notice="[$(date "+%Y-%m-%d %H:%M:%S")][Term-SD]:: "
    for i in ./term-sd/modules/*.sh ;do
        [ $i = "./term-sd/modules/init.sh" ] && continue
        printf "$term_sd_init_bar_notice[$term_sd_modules_number_/$term_sd_modules_number] 加载> $(basename $i .sh)                              \r"
        term_sd_modules_number_=$(( $term_sd_modules_number_ + 1 ))
        source $i
    done
    printf "[$(date "+%Y-%m-%d %H:%M:%S")][Term-SD][info]:: 初始化Term-SD完成                               \n"
    term_sd_print_line
}

# term-sd初始化部分(带进度条)
term_sd_init_new()
{
    term_sd_modules_number_sum="$(( $(ls ./term-sd/modules/*.sh | wc -w) - 1 ))" #需要加载的模块数量
    term_sd_modules_number=1
    term_sd_modules_number_mark=$(echo $(awk 'BEGIN {print '$term_sd_modules_number' / '$term_sd_modules_number_sum' * 100}') | awk -F'.' '{print $1}') #加载进度百分比
    term_sd_process_bar_length=1 #设置初始进度条(已完成的效果)的长度
    shellwidth=$(stty size | awk '{print $2}') #获取终端宽度
    term_sd_process_bar_initial_length=$(( $shellwidth - 50 )) #初始进度条的总长度

    for i in ./term-sd/modules/*.sh ;do
        [ $i = "./term-sd/modules/init.sh" ] && continue #避免重新初始化init.sh脚本
        term_sd_process_bar #输出进度条
        term_sd_modules_number=$(( $term_sd_modules_number + 1 ))
        source $i #加载模块
    done
    echo
    term_sd_echo "初始化Term-SD完成"
    term_sd_print_line
}

# 进度条生成功能(开了只会降低加载速度)
term_sd_process_bar()
{
    term_sd_modules_number_mark=$(echo $(awk 'BEGIN {print '$term_sd_modules_number' / '$term_sd_modules_number_sum' * 100 }') | awk -F'.' '{print $1}') #加载进度百分比
    term_sd_process_bar_length=$(echo $(awk 'BEGIN {print '$term_sd_modules_number' / '$term_sd_modules_number_sum' * '$term_sd_process_bar_initial_length' }') | awk -F'.' '{print $1}') #进度条已完成的实时长度
    term_sd_init_bar_display='█' #已完成的进度显示效果
    term_sd_init_bar="" #清空进度条

    #这个for嵌套在另一个for里,共用一个i会影响"source $i"的运行
    for n in $(seq 1 "${term_sd_process_bar_initial_length}"); do #这个循环将空的进度条填上一堆空格
        if [ $n -gt $term_sd_process_bar_length ] ; then #更换进度条的内容(term_sd_init_bar_display)
            term_sd_init_bar_display=' '
        fi
        term_sd_init_bar="${term_sd_init_bar}${term_sd_init_bar_display}" #一开始是空的，通过循环填上一堆空格,然后逐渐减少空格数量,增加方块符号的数量
    done
    printf "[$(date "+%Y-%m-%d %H:%M:%S")][Term-SD][info]:: 加载模块中|${term_sd_init_bar}| ${term_sd_modules_number_mark}%%\r"
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