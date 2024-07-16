#!/bin/bash

# kohya_ss 启动参数设置
# 启动参数将保存在 <Start Path>/term-sd/config/kohya_ss-launch.conf
kohya_ss_launch_args_setting() {
    local arg
    local dialog_arg
    local launch_args
    local i

    dialog_arg=$(dialog --erase-on-exit --notags \
        --title "kohya_ss 管理" \
        --backtitle "kohya_ss 启动参数选项" \
        --ok-label "确认" --cancel-label "取消" \
        --checklist "请选择 kohya_ss 启动参数, 确认之后将覆盖原有启动参数配置" \
        $(get_dialog_size_menu) \
        "1" "(listen) 开放远程连接" OFF \
        "2" "(inbrowser) 启动 WebUI 完成后自动启动浏览器" ON \
        "3" "(share) 启用 Gradio 共享" OFF \
        "4" "(language zh-CN) 启用中文界面" ON \
        "5" "(headless) 禁用文件浏览按钮" OFF \
        3>&1 1>&2 2>&3)

    if [[ "$?" == 0 ]]; then
        for i in ${dialog_arg}; do
            case "${i}" in
                1)
                    arg="--listen 0.0.0.0"
                    ;;
                2)    
                    arg="--inbrowser"
                    ;;
                3)
                    arg="--share"
                    ;;
                4)
                    arg="--language zh-CN"
                    ;;
                5)
                    arg="--headless"
                    ;;
            esac
            launch_args="${arg} ${launch_args}"
        done

        # 生成启动脚本
        term_sd_echo "设置 kohya_ss 启动参数: ${launch_args}"
        echo "kohya_gui.py ${launch_args}" > "${START_PATH}"/term-sd/config/kohya_ss-launch.conf
    else
        term_sd_echo "取消设置 kohya_ss 启动参数"
    fi
}

# kohya_ss启动界面
kohya_ss_launch() {
    local dialog_arg
    local launch_args

    add_kohya_ss_normal_launch_args

    while true; do
        launch_args=$(cat "${START_PATH}"/term-sd/config/kohya_ss-launch.conf)
        if is_use_venv; then
            launch_args="python ${launch_args}"
        else
            launch_args="${TERM_SD_PYTHON_PATH} ${launch_args}"
        fi

        dialog_arg=$(dialog --erase-on-exit --notags \
            --title "kohya_ss 管理" \
            --backtitle "kohya_ss 启动选项" \
            --ok-label "确认" --cancel-label "取消" \
            --menu "请选择启动 kohya_ss / 修改 kohya_ss 启动参数\n当前启动参数: ${launch_args}" \
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
                kohya_ss_launch_args_setting
                ;;
            3)
                kohya_ss_launch_args_revise
                ;;
            4)
                restore_kohya_ss_launch_args
                ;;
            *)
                break
                ;;
        esac
    done
}

# kohya_ss 启动参数修改
# 输入前将从 <Start Path>/term-sd/config/kohya_ss-launch.conf 读取启动参数
# 可在原来的基础上修改
kohya_ss_launch_args_revise() {
    local dialog_arg
    local launch_args

    launch_args=$(cat "${START_PATH}"/term-sd/config/kohya_ss-launch.conf | awk '{sub("kohya_gui.py ","")}1')

    dialog_arg=$(dialog --erase-on-exit \
        --title "kohya_ss 管理" \
        --backtitle "kohya_ss 自定义启动参数选项" \
        --ok-label "确认" --cancel-label "取消" \
        --inputbox "请输入 kohya_ss 启动参数" \
        $(get_dialog_size) \
        "${launch_args}" \
        3>&1 1>&2 2>&3)

    if [[ "$?" == 0 ]]; then
        term_sd_echo "设置 kohya_ss 启动参数: ${dialog_arg}"
        echo "kohya_gui.py ${dialog_arg}" > "${START_PATH}"/term-sd/config/kohya_ss-launch.conf
    else
        term_sd_echo "取消修改 kohya_ss 启动参数"
    fi
}

# 添加默认启动参数配置
add_kohya_ss_normal_launch_args() {
    if [ ! -f ""${START_PATH}"/term-sd/config/kohya_ss-launch.conf" ]; then # 找不到启动配置时默认生成一个
        echo "kohya_gui.py --inbrowser --language zh-CN" > "${START_PATH}"/term-sd/config/kohya_ss-launch.conf
    fi
}

# 重置启动参数
restore_kohya_ss_launch_args() {
    if (dialog --erase-on-exit \
        --title "kohya_ss 管理" \
        --backtitle "kohya_ss 重置启动参数选项选项" \
        --yes-label "是" --no-label "否" \
        --yesno "是否重置 kohya_ss 启动参数 ?" \
        $(get_dialog_size)); then

        term_sd_echo "重置 kohya_ss 启动参数"
        rm -f "${START_PATH}"/term-sd/config/kohya_ss-launch.conf
        add_kohya_ss_normal_launch_args
    else
        term_sd_echo "取消重置 kohya_ss 启动参数操作"
    fi
}