#!/bin/bash

#term-sd初始化部分
function term_sd_init()
{
    term_sd_modules_number=$(( $(ls ./term-sd/modules/*.sh | wc -w) - 1 ))
    term_sd_modules_number_=1
    term_sd_init_bar_notice="[$(date "+%Y-%m-%d %H:%M:%S")][Term-SD]:: "
    for term_sd_modules in ./term-sd/modules/*.sh ;do
        [ $term_sd_modules = "./term-sd/modules/init.sh" ] && continue
        printf "$term_sd_init_bar_notice[$term_sd_modules_number_/$term_sd_modules_number] 加载> $(echo $term_sd_modules | awk -F'/' '{print $NF}')                              \r"
        term_sd_modules_number_=$(( $term_sd_modules_number_ + 1 ))
        source $term_sd_modules
    done
    printf "[$(date "+%Y-%m-%d %H:%M:%S")][Term-SD]:: 初始化Term-SD完成                               \n"
    print_line_to_shell
}

#term-sd初始化部分(带进度条)
function term_sd_init_new()
{
    term_sd_modules_number_sum="$(( $(ls ./term-sd/modules/*.sh | wc -w) - 1 ))" #需要加载的模块数量
    term_sd_modules_number=1
    term_sd_modules_number_mark=$(echo $(awk 'BEGIN {print '$term_sd_modules_number' / '$term_sd_modules_number_sum' * 100}') | awk -F'.' '{print $1}') #加载进度百分比
    term_sd_process_bar_length=1 #设置初始进度条(已完成的效果)的长度
    term_sd_process_bar_initial_length=$(( $shellwidth - 50 )) #初始进度条的总长度

    for term_sd_modules in ./term-sd/modules/*.sh ;do
        [ $term_sd_modules = "./term-sd/modules/init.sh" ] && continue #避免重新初始化init.sh脚本
        term_sd_process_bar #输出进度条
        term_sd_modules_number=$(( $term_sd_modules_number + 1 ))
        source $term_sd_modules #加载模块
    done
    echo
    term_sd_notice "初始化Term-SD完成"
    print_line_to_shell
}

#进度条生成功能(开了只会降低加载速度)
function term_sd_process_bar()
{
    term_sd_modules_number_mark=$(echo $(awk 'BEGIN {print '$term_sd_modules_number' / '$term_sd_modules_number_sum' * 100 }') | awk -F'.' '{print $1}') #加载进度百分比
    term_sd_process_bar_length=$(echo $(awk 'BEGIN {print '$term_sd_modules_number' / '$term_sd_modules_number_sum' * '$term_sd_process_bar_initial_length' }') | awk -F'.' '{print $1}') #进度条已完成的实时长度
    term_sd_init_bar_display='▇' #已完成的进度显示效果
    term_sd_init_bar="" #清空进度条

    for i in $(seq 1 "${term_sd_process_bar_initial_length}"); do #这个循环将空的进度条填上一堆空格
        if [ "$i" -gt "${term_sd_process_bar_length}" ] ; then #更换进度条的内容(term_sd_init_bar_display)
            term_sd_init_bar_display=' '
        fi
        term_sd_init_bar="${term_sd_init_bar}${term_sd_init_bar_display}" #一开始是空的，通过循环填上一堆空格,然后逐渐减少空格数量,增加方块符号的数量
    done
    printf "[$(date "+%Y-%m-%d %H:%M:%S")][Term-SD]:: 加载模块中[${term_sd_init_bar}] ${term_sd_modules_number_mark}%%\r"
}

#初始化功能
if [ ! -f "./term-sd/term-sd-new-bar.lock" ];then
    term_sd_init
else
    term_sd_init_new
fi
