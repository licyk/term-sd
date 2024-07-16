#!/bin/bash

# 命令自动重试功能
# 使用 TERM_SD_CMD_RETRY 全局变量获取重试次数
term_sd_try() {
    local count=0
    if (( TERM_SD_CMD_RETRY == 0 )); then
        "$@" # 执行输入的命令
    else
        while (( count <= TERM_SD_CMD_RETRY ));do  
            count=$(( count + 1 ))
            "$@" # 执行输入的命令
            if [[ "$?" == 0 ]]; then
                break # 运行成功并中断循环
            else
                if (( count > TERM_SD_CMD_RETRY )); then
                    term_sd_echo "超出重试次数, 终止重试"
                    term_sd_is_debug && term_sd_echo "执行失败的命令: \"$@\""
                    return 1
                fi
                term_sd_echo "[$count/$TERM_SD_CMD_RETRY] 命令执行失败, 重试中"
            fi
        done
    fi
}

# 命令自动重试功能设置
# 使用 TERM_SD_CMD_RETRY 全局变量设置自动重试次数
term_sd_try_setting() {
    local dialog_arg
    local term_sd_try_value
    local term_sd_try_info
    local config_value

    while true; do
        if [[ -f "${START_PATH}/term-sd/config/term-sd-watch-retry.conf" ]]; then
            term_sd_try_info="启用 (重试次数: $(cat "${START_PATH}/term-sd/config/term-sd-watch-retry.conf"))"
        else
            term_sd_try_info="禁用"
        fi

        dialog_arg=$(dialog --erase-on-exit --notags \
            --title "Term-SD" \
            --backtitle "命令执行监测设置界面" \
            --ok-label "确认" --cancel-label "取消" \
            --menu "该功能用于监测命令的运行情况, 若设置了重试次数, Term-SD 将重试执行失败的命令 (有些命令需要联网, 在网络不稳定的时候容易导致命令执行失败), 保证命令执行成功\n当前状态: ${term_sd_try_info}\n是否启用命令执行监测? (推荐启用)" \
            $(get_dialog_size_menu) \
            "0" "> 返回" \
            "1" "> 启用" \
            "2" "> 禁用" \
            3>&1 1>&2 2>&3)

        case "${dialog_arg}" in
            1)
                config_value=$(cat "${START_PATH}/term-sd/config/term-sd-watch-retry.conf")

                term_sd_try_value=$(dialog --erase-on-exit \
                    --title "Term-SD" \
                    --backtitle "命令执行监测设置界面" \
                    --ok-label "确认" --cancel-label "取消" \
                    --inputbox "请输入重试次数 (仅输入数字, 不允许输入负数和其他非数字的字符)" \
                    $(get_dialog_size) \
                    "${config_value}" \
                    3>&1 1>&2 2>&3)

                if [[ ! -z "$(echo ${term_sd_try_value} | awk '{gsub(/[0-9]/, "")}1')" ]]; then
                    dialog --erase-on-exit \
                        --title "Term-SD" \
                        --backtitle "命令执行监测设置界面" \
                        --ok-label "确认" \
                        --msgbox "输入格式错误, 重试次数只能为数字且不能为负数" \
                        $(get_dialog_size)
                else
                    if [[ ! -z "${term_sd_try_value}" ]]; then
                        echo "${term_sd_try_value}" > "${START_PATH}/term-sd/config/term-sd-watch-retry.conf"
                        TERM_SD_CMD_RETRY=$term_sd_try_value
                        dialog --erase-on-exit \
                            --title "Term-SD" \
                            --backtitle "命令执行监测设置界面" \
                            --ok-label "确认" \
                            --msgbox "Term-SD 命令执行监测启用成功, 重试次数: ${TERM_SD_CMD_RETRY}" \
                            $(get_dialog_size)
                    else
                        dialog --erase-on-exit \
                            --title "Term-SD" \
                            --backtitle "命令执行监测设置界面" \
                            --ok-label "确认" \
                            --msgbox "未输入, 请重试" \
                            $(get_dialog_size)
                    fi
                fi
                ;;
            2)
                rm -f "${START_PATH}/term-sd/config/term-sd-watch-retry.conf"
                TERM_SD_CMD_RETRY=0

                dialog --erase-on-exit \
                    --title "Term-SD" \
                    --backtitle "命令执行监测设置界面" \
                    --ok-label "确认" \
                    --msgbox "Term-SD 命令执行监测禁用成功" \
                    $(get_dialog_size)
                ;;
            *)
                break
                ;;
        esac
    done
}