#!/bin/bash

# lora-scripts 启动参数配置
# 设置的启动参数将保存在 <Start Path>/term-sd/config/lora-scripts-launch.conf
lora_scripts_launch_args_setting() {
    local arg
    local dialog_arg
    local launch_args
    local i

    dialog_arg=$(dialog --erase-on-exit --notags \
        --title "lora-scripts 管理" \
        --backtitle "lora-scripts 启动参数选项" \
        --ok-label "确认" --cancel-label "取消" \
        --checklist "请选择 lora-scripts 启动参数, 确认之后将覆盖原有启动参数配置" \
        $(get_dialog_size_menu) \
        "1" "(listen) 开放远程连接" OFF \
        "2" "(skip-prepare-environment) 跳过环境检查" OFF \
        "3" "(disable-tensorboard)禁用 TernsorBoard" OFF \
        "4" "(disable-tageditor) 禁用标签管理器" OFF \
        "5" "(dev) 启用开发版功能" OFF \
        3>&1 1>&2 2>&3)

    if [[ "$?" == 0 ]]; then
        for i in ${dialog_arg}; do
            case "${i}" in
                1)
                    arg="--listen"
                    ;;
                2)    
                    arg="--skip-prepare-environment"
                    ;;
                3)
                    arg="--disable-tensorboard"
                    ;;
                4)
                    arg="--disable-tageditor"
                    ;;
                5)
                    arg="--dev"
                    ;;
            esac
            launch_args="${arg} ${launch_args}"
        done

        # 生成启动脚本
        term_sd_echo "设置 lora-scripts 启动参数: ${launch_args}"
        echo "gui.py ${launch_args}" > "${START_PATH}"/term-sd/config/lora-scripts-launch.conf
    else
        term_sd_echo "取消设置 lora-scripts 启动参数"
    fi
}

# lora-scripts 启动界面
lora_scripts_launch() {
    local dialog_arg
    local launch_args

    add_lora_scripts_normal_launch_args

    while true; do

        launch_args=$(cat "${START_PATH}"/term-sd/config/lora-scripts-launch.conf)

        if is_use_venv; then
            launch_args="python ${launch_args}"
        else
            launch_args="${TERM_SD_PYTHON_PATH} ${launch_args}"
        fi

        dialog_arg=$(dialog --erase-on-exit --notags \
            --title "lora-scripts 管理" \
            --backtitle "lora-scripts 启动选项" \
            --ok-label "确认" --cancel-label "取消" \
            --menu "请选择启动 lora-scripts / 修改 lora-scripts 启动参数\n当前启动参数: ${launch_args}" \
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
                lora_scripts_launch_args_setting
                ;;
            3)
                lora_scripts_launch_args_revise
                ;;
            4)
                restore_lora_scripts_launch_args
                ;;
            *)
                break
                ;;
        esac
    done
}

# lora-scripts 启动参数修改
# 修改启动参数前从 term-sd/config/lora-scripts-launch.conf 读取启动参数
# 可在原来的基础上修改
lora_scripts_launch_args_revise() {
    local dialog_arg
    local launch_args

    launch_args=$(cat "${START_PATH}"/term-sd/config/lora-scripts-launch.conf | awk '{sub("gui.py ","")}1')

    dialog_arg=$(dialog --erase-on-exit \
        --title "lora-scripts 管理" \
        --backtitle "lora-scripts 自定义启动参数选项" \
        --ok-label "确认" --cancel-label "取消" \
        --inputbox "请输入 lora-scripts 启动参数" \
        $(get_dialog_size) \
        "${launch_args}" \
        3>&1 1>&2 2>&3)

    if [[ "$?" == 0 ]]; then
        term_sd_echo "设置 lora-scripts 启动参数: ${dialog_arg}"
        echo "gui.py ${dialog_arg}" > "${START_PATH}"/term-sd/config/lora-scripts-launch.conf
    else
        term_sd_echo "取消修改 lora-scripts 启动参数"
    fi
}

# 添加默认启动参数配置
add_lora_scripts_normal_launch_args() {
    if [ ! -f ""${START_PATH}"/term-sd/config/lora-scripts-launch.conf" ]; then # 找不到启动配置时默认生成一个
        echo "gui.py" > "${START_PATH}"/term-sd/config/lora-scripts-launch.conf
    fi
}

# 重置启动参数
restore_lora_scripts_launch_args() {
    if (dialog --erase-on-exit \
        --title "lora-scripts 管理" \
        --backtitle "lora-scripts 重置启动参数选项选项" \
        --yes-label "是" --no-label "否" \
        --yesno "是否重置 lora-scripts 启动参数 ?" \
        $(get_dialog_size)); then

        term_sd_echo "重置 lora-scripts 启动参数"
        rm -f "${START_PATH}"/term-sd/config/lora-scripts-launch.conf
        add_lora_scripts_normal_launch_args
    else
        term_sd_echo "取消重置 lora-scripts 启动参数操作"
    fi
}