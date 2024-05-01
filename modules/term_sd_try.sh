#!/bin/bash

# 进程监测
term_sd_try()
{
    local count=0
    if [ $term_sd_cmd_retry = 0 ];then
        "$@" # 执行输入的命令
    else
        while (( $count <= $term_sd_cmd_retry ));do  
            count=$(( $count + 1 ))
            "$@" # 执行输入的命令
            if [ $? = 0 ];then
                break # 运行成功并中断循环
            else
                if [ $count -gt $term_sd_cmd_retry ];then
                    term_sd_echo "超出重试次数, 终止重试"
                    [ $term_sd_debug_mode = 0 ] && term_sd_echo "执行失败的命令: \"$@\""
                    return 1
                    break # 超出重试次数后终端循环
                fi
                term_sd_echo "[$count/$term_sd_cmd_retry] 命令执行失败, 重试中"
            fi
        done
    fi
}

# 命令执行监测设置
term_sd_try_setting()
{
    local term_sd_try_setting_dialog
    local term_sd_try_value
    export term_sd_cmd_retry

    while true
    do
        term_sd_try_setting_dialog=$(
            dialog --erase-on-exit --notags \
            --title "Term-SD" \
            --backtitle "命令执行监测设置界面" \
            --ok-label "确认" --cancel-label "取消" \
            --menu "该功能用于监测命令的运行情况, 若设置了重试次数, Term-SD 将重试执行失败的命令 (有些命令需要联网, 在网络不稳定的时候容易导致命令执行失败), 保证命令执行成功\n当前状态: $([ -f "term-sd/config/term-sd-watch-retry.conf" ] && echo "启用 (重试次数: $(cat term-sd/config/term-sd-watch-retry.conf))" || echo "禁用")\n是否启用命令执行监测? (推荐启用)" \
            $term_sd_dialog_height $term_sd_dialog_width $term_sd_dialog_menu_height \
            "0" "> 返回" \
            "1" "> 启用" \
            "2" "> 禁用" \
            3>&1 1>&2 2>&3)

        case $term_sd_try_setting_dialog in
            1)
                term_sd_try_value=$(dialog --erase-on-exit \
                    --title "Term-SD" \
                    --backtitle "命令执行监测设置界面" \
                    --ok-label "确认" --cancel-label "取消" \
                    --inputbox "请输入重试次数 (仅输入数字, 不允许输入负数和其他非数字的字符)" \
                    $term_sd_dialog_height $term_sd_dialog_width \
                    "$(cat term-sd/config/term-sd-watch-retry.conf)" \
                    3>&1 1>&2 2>&3)

                if [ ! -z "$(echo $term_sd_try_value | awk '{gsub(/[0-9]/, "")}1')" ];then
                    dialog --erase-on-exit \
                        --title "Term-SD" \
                        --backtitle "命令执行监测设置界面" \
                        --ok-label "确认" \
                        --msgbox "输入格式错误,重试次数只能为数字且不能为负数" \
                        $term_sd_dialog_height $term_sd_dialog_width
                else
                    if [ ! -z "$term_sd_try_value" ];then
                        echo "$term_sd_try_value" > term-sd/config/term-sd-watch-retry.conf
                        term_sd_cmd_retry=$term_sd_try_value
                        dialog --erase-on-exit \
                            --title "Term-SD" \
                            --backtitle "命令执行监测设置界面" \
                            --ok-label "确认" \
                            --msgbox "启用成功, 重试次数: $term_sd_cmd_retry" \
                            $term_sd_dialog_height $term_sd_dialog_width
                    else
                        dialog --erase-on-exit \
                            --title "Term-SD" \
                            --backtitle "命令执行监测设置界面" \
                            --ok-label "确认" \
                            --msgbox "未输入,请重试" \
                            $term_sd_dialog_height $term_sd_dialog_width
                    fi
                fi
                ;;
            2)
                rm -rf term-sd/config/term-sd-watch-retry.conf
                term_sd_cmd_retry=0

                dialog --erase-on-exit \
                    --title "Term-SD" \
                    --backtitle "命令执行监测设置界面" \
                    --ok-label "确认" \
                    --msgbox "禁用成功" \
                    $term_sd_dialog_height $term_sd_dialog_width
                ;;
            *)
                break
                ;;
        esac
    done
}