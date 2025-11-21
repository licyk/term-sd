#!/bin/bash

# 设置 Term-SD 补丁系统
# 设置 TERM_SD_IS_INIT_PATCHER 全局变量保存启用状态
# 使用 TERM_SD_ORIGIN_PYTHONPATH 获取初始 PYTHONPATH 环境变量
term_sd_python_patcher_setting() {
    local dialog_arg
    local term_sd_patcher_info

    if [[ ! -f "${START_PATH}/term-sd/config/disable-term-sd-patcher.lock" ]]; then
        term_sd_patcher_info="启用"
    else
        term_sd_patcher_info="禁用"
    fi

    while true; do
        dialog_arg=$(dialog --erase-on-exit --notags \
            --title "Term-SD" \
            --backtitle "Term-SD 补丁系统设置界面" \
            --ok-label "确认" --cancel-label "取消" \
            --menu "该功能用于启用 Term-SD 的补丁系统, 对 Python 模块进行补丁以增强体验\n当前 Term-SD 补丁系统启用状态: ${term_sd_patcher_info}\n请选择是否启用 Term-SD 补丁系统" \
            $(get_dialog_size_menu) \
            "0" "> 返回" \
            "1" "> 启用 Term-SD 补丁系统" \
            "2" "> 禁用 Term-SD 补丁系统" \
            3>&1 1>&2 2>&3)

        case "${dialog_arg}" in
            1)
                rm -f  "${START_PATH}/term-sd/config/disable-term-sd-patcher.lock"
                if [[ ! "${TERM_SD_IS_INIT_PATCHER}" == 1 ]]; then
                    TERM_SD_IS_INIT_PATCHER=1
                    if is_windows_platform; then
                        export PYTHONPATH="$(get_term_sd_patcher_path);${TERM_SD_ORIGIN_PYTHONPATH}"
                    else
                        export PYTHONPATH="$(get_term_sd_patcher_path):${TERM_SD_ORIGIN_PYTHONPATH}"
                    fi
                fi

                dialog --erase-on-exit \
                    --title "Term-SD" \
                    --backtitle "Term-SD 补丁系统设置界面" \
                    --ok-label "确认" \
                    --msgbox "启用 Term-SD 的补丁系统完成" \
                    $(get_dialog_size)
                ;;
            2)
                touch "${START_PATH}/term-sd/config/disable-term-sd-patcher.lock"
                unset PYTHONPATH
                TERM_SD_IS_INIT_PATCHER=0

                dialog --erase-on-exit \
                    --title "Term-SD" \
                    --backtitle "Term-SD 补丁系统设置界面" \
                    --ok-label "确认" \
                    --msgbox "禁用 Term-SD 的补丁系统完成" \
                    $(get_dialog_size)
                ;;
            *)
                break
                ;;
        esac
    done
}
