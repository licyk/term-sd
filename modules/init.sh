#!/bin/bash

#term-sd初始化部分
function term_sd_init()
{
    term_sd_modules_number=$(( $(ls ./term-sd/modules/*.sh | wc -w) - 1 ))
    term_sd_modules_number_=1
    term_sd_init_bar_3="[$(date "+%Y-%m-%d %H:%M:%S")][Term-SD]:: "
    for term_sd_modules in ./term-sd/modules/*.sh ;do
        [ $term_sd_modules = "./term-sd/modules/init.sh" ] && continue
        term_sd_init_bar_1="$term_sd_modules_number_/$term_sd_modules_number"
        term_sd_init_bar_2=$(echo $term_sd_modules | awk -F'/' '{print $NF}')
        printf "$term_sd_init_bar_3[$term_sd_init_bar_1] 加载> ${term_sd_init_bar_2}                              \r"
        term_sd_modules_number_=$(( $term_sd_modules_number_ + 1 ))
        source $term_sd_modules
    done
    printf "[$(date "+%Y-%m-%d %H:%M:%S")][Term-SD]:: 初始化Term-SD完成                               \n"
    print_line_to_shell
    echo "[$(date "+%Y-%m-%d %H:%M:%S")][Term-SD]:: 启动Term-SD中"
    term_sd_version
    mainmenu
}

#初始化功能
term_sd_init
