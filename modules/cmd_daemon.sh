#!/bin/bash

#安装重试模块
function cmd_daemon()
{
    if [ $cmd_daemon_retry = 0 ];then
        "$@" #执行输入的命令
    else
        count=0
        while (( $count <= $cmd_daemon_retry ));do  
            count=$(( $count + 1 ))
            "$@" #执行输入的命令
            if [ $? = 0 ];then
                break #运行成功并中断循环
            else
                if [ $count -gt $cmd_daemon_retry ];then
                    term_sd_notice "超出重试次数,终止重试"
                    break
                fi
                term_sd_notice "[$count/$cmd_daemon_retry]检测到命令执行失败,重试中"
            fi
        done
    fi
}