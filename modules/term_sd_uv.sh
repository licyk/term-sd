#!/bin/bash

# 处理 uv 命令
term_sd_uv() {
    if [[ ! -z "${VIRTUAL_ENV}" ]]; then
        uv "$@"
    else
        UV_PYTHON=$TERM_SD_PYTHON_PATH uv "$@"
    fi
}

# 处理 uv 安装命令
term_sd_uv_install() {
    check_uv_upgrade
    term_sd_uv install "$@"
}

# 安装 uv
term_sd_init_uv() {
    term_sd_pip install uv --upgrade
}

# 检查 uv 更新
# 使用 TERM_SD_UV_MININUM_VER 全局变量确定最低的 uv 版本
check_uv_upgrade() {
    local status

    status=$(term_sd_python "${START_PATH}/term-sd/python_modules/check_uv_version.py" --uv-mininum-ver "${TERM_SD_UV_MININUM_VER}")

    if [[ "${status}" == "True" ]]; then
        term_sd_echo "更新 uv 中"

        if term_sd_init_uv; then
            term_sd_echo "uv 更新成功"
            return 0
        else
            term_sd_echo "uv 更新失败, 可能会导致 Python 软件包的安装问题"
            return 1
        fi
    fi
}

# 检测是否使用 uv 作为包管理器
term_sd_is_use_uv() {
    [[ "${USE_UV_TO_MANAGE_PACKAGE}" == 1 ]] && return 0 || return 1
}

# 设置安装 Python 软件包时使用的包管理器
# 通过 USE_UV_TO_MANAGE_PACKAGE 全局变量设置使用的 Python 包管理器类型
python_package_install_manager_setting() {
    local dialog_arg

    while true; do
        dialog_arg=$(dialog --erase-on-exit --notags \
            --title "Term-SD" \
            --backtitle "Python 包管理器设置界面" \
            --ok-label "确认" --cancel-label "取消" \
            --menu "该功能用于设置 Term-SD 安装 Python 软件包时使用的 Python 包管理器, Pip 为传统的 Python 包管理器, uv 为速度更快的包管理器\n当前使用的 Python 包管理器: $(term_sd_is_use_uv && echo "uv" || echo "Pip")\n请选择使用的 Python 包管理器 (推荐使用 uv)" \
            $(get_dialog_size_menu) \
            "0" "> 返回" \
            "1" "> 使用 Pip 包管理器" \
            "2" "> 使用 uv 包管理器" \
            3>&1 1>&2 2>&3)

        case "${dialog_arg}" in
            1)
                USE_UV_TO_MANAGE_PACKAGE=0
                touch "${START_PATH}/term-sd/config/disable-uv.lock"

                dialog --erase-on-exit \
                    --title "Term-SD" \
                    --backtitle "Python 包管理器设置界面" \
                    --ok-label "确认" \
                    --msgbox "设置 Python 包管理器为 Pip 完成" \
                    $(get_dialog_size)
                ;;
            2)
                USE_UV_TO_MANAGE_PACKAGE=1
                rm -f "${START_PATH}/term-sd/config/disable-uv.lock"

                dialog --erase-on-exit \
                    --title "Term-SD" \
                    --backtitle "Python 包管理器设置界面" \
                    --ok-label "确认" \
                    --msgbox "设置 Python 包管理器为 uv 完成" \
                    $(get_dialog_size)
                ;;
            *)
                break
                ;;
        esac
    done
}

# 检测 uv 是否出现安装失败, 并显示警告信息
check_uv_install_failed_and_warning() {
    if [[ ! "$?" == 0 ]]; then
        term_sd_echo "检测到 uv 安装 Python 软件包失败, 尝试回滚到 Pip 重试 Python 软件包安装"
        return 0
    fi
    return 1
}
