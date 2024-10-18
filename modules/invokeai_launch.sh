#!/bin/bash

# InvokeAI 启动界面
# 参考: https://invoke-ai.github.io/InvokeAI/features/UTILITIES
invokeai_launch() {
    local dialog_arg
    local launch_args

    add_invokeai_normal_launch_args

    while true; do
        launch_args="invokeai-web $(cat "${START_PATH}"/term-sd/config/invokeai-launch.conf)"

        dialog_arg=$(dialog --erase-on-exit --notags \
            --title "InvokeAI 管理" \
            --backtitle "InvokeAI 启动参数选项" \
            --ok-label "确认" --cancel-label "取消" \
            --menu "请选择 InvokeAI 启动参数\n当前自定义启动参数: ${launch_args}" \
            $(get_dialog_size_menu) \
            "0" "> 返回" \
            "1" "> 启动" \
            "2" "> 配置预设启动参数" \
            "3" "> 修改自定义启动参数" \
            "4" "> 重置启动参数" \
            3>&1 1>&2 2>&3)

        case "${dialog_arg}" in
            1)
                term_sd_launch
                ;;
            2)
                invokeai_launch_args_setting
                ;;
            3)
                invokeai_manual_launch
                ;;
            4)
                restore_invokeai_launch_args
                ;;
            *)
                break
                ;;
        esac
    done
}

# 启动参数预设选择
# 启动参数保存在 <Start Path>/term-sd/config/invokeai-launch.conf
invokeai_launch_args_setting() {
    local dialog_arg
    local arg
    local launch_args
    local i

    dialog_arg=$(dialog --erase-on-exit --notags \
        --title "InvokeAI 管理" \
        --backtitle "InvokeAI 启动参数选项" \
        --ok-label "确认" --cancel-label "取消" \
        --checklist "请选择 InvokeAI 启动参数, 确认之后将覆盖原有启动参数配置\n注: InvokeAI 4.x 已移除该列表中的启动参数, 若使用将导致 InvokeAI 报错导致无法启动, 需使用修改自定义启动参数功能将所有启动参数清除" \
        $(get_dialog_size_menu) \
        "1" "(host) 开放远程连接" OFF \
        "2" "(no-esrgan) 禁用 ESRGAN 进行画面修复" OFF \
        "3" "(no-internet_available) 启用离线模式" OFF \
        "4" "(log_tokenization) 启用详细日志显示" OFF \
        "5" "(no-patchmatch) 禁用图片修复模块" OFF \
        "6" "(ignore_missing_core_models) 忽略下载核心模型" OFF \
        "7" "(log_format plain) 使用纯文本格式日志" OFF \
        "8" "(log_format color) 使用彩色格式日志" OFF \
        "9" "(log_format syslog) 使用系统格式日志" OFF \
        "10" "(log_format legacy) 使用传统格式日志" OFF \
        "11" "(log_sql) 显示数据库查新日志" OFF \
        "12" "(dev_reload) 启用开发者模式" OFF \
        "13" "(log_memory_usage) 显示详细内存使用日志" OFF \
        "14" "(always_use_cpu) 强制使用 CPU" OFF \
        "15" "(tiled_decode) 启用分块 VAE 解码, 降低显存占用" OFF \
        3>&1 1>&2 2>&3)

    if [[ "$?" == 0 ]]; then
        for i in ${dialog_arg}; do
            case "${i}" in
                1)
                    arg="--host 0.0.0.0"
                    ;;
                2)
                    arg="--no-esrgan"
                    ;;
                3)
                    arg="--no-internet_available"
                    ;;
                4)
                    arg="--log_tokenization"
                    ;;
                5)
                    arg="--no-patchmatch"
                    ;;
                6)
                    arg="--ignore_missing_core_models"
                    ;;
                7)
                    arg="--log_format plain"
                    ;;
                8)
                    arg="--log_format color"
                    ;;
                9)
                    arg="--log_format syslog"
                    ;;
                10)
                    arg="--log_format legacy"
                    ;;
                11)
                    arg="--log_sql"
                    ;;
                12)
                    arg="--dev_reload"
                    ;;
                13)
                    arg="--log_memory_usage"
                    ;;
                14)
                    arg="--always_use_cpu"
                    ;;
                15)
                    arg="--tiled_decode"
                    ;;
            esac
            launch_args="${arg} ${launch_args}"
        done

        term_sd_echo "设置 InvokeAI 启动参数: ${launch_args}"
        echo "${launch_args}" > "${START_PATH}"/term-sd/config/invokeai-launch.conf
    else
        term_sd_echo "取消设置 InvokeAI 启动参数"
    fi
}

# 启动参数修改
# 修改参数前将从 <Start Path>/term-sd/config/invokeai-launch.conf 中读取启动参数
# 可在原来的基础上修改
invokeai_manual_launch() {
    local dialog_arg
    local launch_args

    launch_args=$(cat "${START_PATH}"/term-sd/config/invokeai-launch.conf)

    dialog_arg=$(dialog --erase-on-exit \
        --title "InvokeAI 管理" \
        --backtitle "InvokeAI 自定义启动参数选项" \
        --ok-label "确认" --cancel-label "取消" \
        --inputbox "请输入 InvokeAI 启动参数" \
        $(get_dialog_size) \
        "${launch_args}" \
        3>&1 1>&2 2>&3)

    if [[ "$?" == 0 ]]; then
        term_sd_echo "设置 InvokeAI 启动参数: ${dialog_arg}"
        echo "${dialog_arg}" > "${START_PATH}"/term-sd/config/invokeai-launch.conf
    else
        term_sd_echo "取消 InvokeAI 启动参数修改"
    fi
}

# 添加默认启动参数配置
add_invokeai_normal_launch_args() {
    if [[ ! -f "${START_PATH}/term-sd/config/invokeai-launch.conf" ]]; then # 找不到启动配置时默认生成一个
        echo "" > "${START_PATH}"/term-sd/config/invokeai-launch.conf
    fi
}

# 重置启动参数
restore_invokeai_launch_args() {
    if (dialog --erase-on-exit \
        --title "InvokeAI 管理" \
        --backtitle "InvokeAI 重置启动参数选项选项" \
        --yes-label "是" --no-label "否" \
        --yesno "是否重置 InvokeAI 启动参数 ?" \
        $(get_dialog_size)); then

        term_sd_echo "重置启动参数"
        rm -f "${START_PATH}"/term-sd/config/invokeai-launch.conf
        add_invokeai_normal_launch_args
    else
        term_sd_echo "取消重置操作"
    fi
}

# 启动 InvokeAI
# 使用:
# launch_invokeai_web <启动参数>
launch_invokeai_web() {
    if which invokeai-web &> /dev/null; then
        invokeai-web "$@"
    else
        term_sd_python "${START_PATH}/term-sd/python_modules/launch_invokeai.py" "$@"
    fi
}
