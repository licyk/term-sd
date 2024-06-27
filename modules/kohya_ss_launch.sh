#!/bin/bash

# kohya_ss启动脚本生成部分
kohya_ss_launch_args_setting()
{
    local kohya_ss_launch_args
    local kohya_ss_launch_args_setting_dialog
    local launch_args

    kohya_ss_launch_args_setting_dialog=$(dialog --erase-on-exit --notags \
        --title "kohya_ss 管理" \
        --backtitle "kohya_ss 启动参数选项" \
        --ok-label "确认" --cancel-label "取消" \
        --checklist "请选择 kohya_ss 启动参数, 确认之后将覆盖原有启动参数配置" \
        $term_sd_dialog_height $term_sd_dialog_width $term_sd_dialog_menu_height \
        "1" "(listen) 开放远程连接" OFF \
        "2" "(inbrowser) 启动 WebUI 完成后自动启动浏览器" ON \
        "3" "(share) 启用 Gradio 共享" OFF \
        "4" "(language zh-CN) 启用中文界面" ON \
        "5" "(headless) 禁用文件浏览按钮" OFF \
        3>&1 1>&2 2>&3)

    if [ $? = 0 ];then
        for i in $kohya_ss_launch_args_setting_dialog; do
            case $i in
                1)
                    kohya_ss_launch_args="--listen 0.0.0.0"
                    ;;
                2)    
                    kohya_ss_launch_args="--inbrowser"
                    ;;
                3)
                    kohya_ss_launch_args="--share"
                    ;;
                4)
                    kohya_ss_launch_args="--language zh-CN"
                    ;;
                5)
                    kohya_ss_launch_args="--headless"
                    ;;
            esac
            launch_args="$kohya_ss_launch_args $launch_args"
        done

        # 生成启动脚本
        term_sd_echo "设置启动参数: $launch_args"
        echo "kohya_gui.py $launch_args" > "$start_path"/term-sd/config/kohya_ss-launch.conf
    else
        term_sd_echo "取消设置启动参数"
    fi
}

# kohya_ss启动界面
kohya_ss_launch()
{
    local kohya_ss_launch_dialog

    add_kohya_ss_normal_launch_args

    while true
    do
        kohya_ss_launch_dialog=$(dialog --erase-on-exit --notags \
            --title "kohya_ss 管理" \
            --backtitle "kohya_ss 启动选项" \
            --ok-label "确认" --cancel-label "取消" \
            --menu "请选择启动 kohya_ss / 修改 kohya_ss 启动参数\n当前启动参数: \n$([ $venv_setup_status = 0 ] && echo python || echo "$term_sd_python_path") $(cat "$start_path"/term-sd/config/kohya_ss-launch.conf)"\
             $term_sd_dialog_height $term_sd_dialog_width $term_sd_dialog_menu_height \
            "0" "> 返回" \
            "1" "> 启动" \
            "2" "> 配置预设启动参数" \
            "3" "> 修改自定义启动参数" \
            "4" "> 重置启动参数" \
            3>&1 1>&2 2>&3)

        case $kohya_ss_launch_dialog in
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

# kohya_ss手动输入启动参数界面
kohya_ss_launch_args_revise()
{
    local kohya_ss_launch_args

    kohya_ss_launch_args=$(dialog --erase-on-exit \
        --title "kohya_ss 管理" \
        --backtitle "kohya_ss 自定义启动参数选项" \
        --ok-label "确认" --cancel-label "取消" \
        --inputbox "请输入 kohya_ss 启动参数" \
        $term_sd_dialog_height $term_sd_dialog_width \
        "$(cat "$start_path"/term-sd/config/kohya_ss-launch.conf | awk '{sub("kohya_gui.py ","")}1')" \
        3>&1 1>&2 2>&3)

    if [ $? = 0 ];then
        term_sd_echo "设置启动参数: $kohya_ss_launch_args"
        echo "kohya_gui.py $kohya_ss_launch_args" > "$start_path"/term-sd/config/kohya_ss-launch.conf
    else
        term_sd_echo "取消启动参数修改"
    fi
}

# 添加默认启动参数配置
add_kohya_ss_normal_launch_args()
{
    if [ ! -f ""$start_path"/term-sd/config/kohya_ss-launch.conf" ]; then # 找不到启动配置时默认生成一个
        echo "kohya_gui.py --inbrowser --language zh-CN" > "$start_path"/term-sd/config/kohya_ss-launch.conf
    fi
}

# 重置启动参数
restore_kohya_ss_launch_args()
{
    if (dialog --erase-on-exit \
        --title "kohya_ss 管理" \
        --backtitle "kohya_ss 重置启动参数选项选项" \
        --yes-label "是" --no-label "否" \
        --yesno "是否重置 kohya_ss 启动参数" \
        $term_sd_dialog_height $term_sd_dialog_width) then

        term_sd_echo "重置启动参数"
        rm -f "$start_path"/term-sd/config/kohya_ss-launch.conf
        add_kohya_ss_normal_launch_args
    else
        term_sd_echo "取消重置操作"
    fi
}