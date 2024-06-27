#!/bin/bash

# lora-scripts启动脚本生成部分
lora_scripts_launch_args_setting()
{
    local lora_scripts_launch_args
    local lora_scripts_launch_args_setting_dialog
    local launch_args

    lora_scripts_launch_args_setting_dialog=$(dialog --erase-on-exit --notags \
        --title "lora-scripts 管理" \
        --backtitle "lora-scripts 启动参数选项" \
        --ok-label "确认" --cancel-label "取消" \
        --checklist "请选择 lora-scripts 启动参数, 确认之后将覆盖原有启动参数配置" \
        $term_sd_dialog_height $term_sd_dialog_width $term_sd_dialog_menu_height \
        "1" "(listen) 开放远程连接" OFF \
        "2" "(skip-prepare-environment) 跳过环境检查" OFF \
        "3" "(disable-tensorboard)禁用 TernsorBoard" OFF \
        "4" "(disable-tageditor) 禁用标签管理器" OFF \
        "5" "(dev) 启用开发版功能" OFF \
        3>&1 1>&2 2>&3)

    if [ $? = 0 ];then
        for i in $lora_scripts_launch_args_setting_dialog; do
            case $i in
                1)
                    lora_scripts_launch_args="--listen"
                    ;;
                2)    
                    lora_scripts_launch_args="--skip-prepare-environment"
                    ;;
                3)
                    lora_scripts_launch_args="--disable-tensorboard"
                    ;;
                4)
                    lora_scripts_launch_args="--disable-tageditor"
                    ;;
                5)
                    lora_scripts_launch_args="--dev"
                    ;;
            esac
            launch_args="$lora_scripts_launch_args $launch_args"
        done

        # 生成启动脚本
        term_sd_echo "设置启动参数: $launch_args"
        echo "gui.py $launch_args" > "$start_path"/term-sd/config/lora-scripts-launch.conf
    else
        term_sd_echo "取消设置启动参数"
    fi
}

# lora-scripts启动界面
lora_scripts_launch()
{
    local lora_scripts_launch_dialog

    add_lora_scripts_normal_launch_args

    while true
    do
        lora_scripts_launch_dialog=$(dialog --erase-on-exit --notags \
            --title "lora-scripts 管理" \
            --backtitle "lora-scripts 启动选项" \
            --ok-label "确认" --cancel-label "取消" \
            --menu "请选择启动 lora-scripts / 修改 lora-scripts 启动参数\n当前启动参数:\n$([ $venv_setup_status = 0 ] && echo python || echo "$term_sd_python_path") $(cat "$start_path"/term-sd/config/lora-scripts-launch.conf)"\
             $term_sd_dialog_height $term_sd_dialog_width $term_sd_dialog_menu_height \
            "0" "> 返回" \
            "1" "> 启动" \
            "2" "> 配置预设启动参数" \
            "3" "> 修改自定义启动参数" \
            "4" "> 重置启动参数" \
            3>&1 1>&2 2>&3)

        case $lora_scripts_launch_dialog in
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

# lora-scripts手动输入启动参数界面
lora_scripts_launch_args_revise()
{
    local lora_scripts_launch_args

    lora_scripts_launch_args=$(dialog --erase-on-exit \
        --title "lora-scripts 管理" \
        --backtitle "lora-scripts 自定义启动参数选项" \
        --ok-label "确认" --cancel-label "取消" \
        --inputbox "请输入 lora-scripts 启动参数" \
        $term_sd_dialog_height $term_sd_dialog_width \
        "$(cat "$start_path"/term-sd/config/lora-scripts-launch.conf | awk '{sub("gui.py ","")}1')" \
        3>&1 1>&2 2>&3)

    if [ $? = 0 ];then
        term_sd_echo "设置启动参数: $lora_scripts_launch_args"
        echo "gui.py $lora_scripts_launch_args" > "$start_path"/term-sd/config/lora-scripts-launch.conf
    else
        term_sd_echo "取消启动参数修改"
    fi
}

# 添加默认启动参数配置
add_lora_scripts_normal_launch_args()
{
    if [ ! -f ""$start_path"/term-sd/config/lora-scripts-launch.conf" ]; then # 找不到启动配置时默认生成一个
        echo "gui.py" > "$start_path"/term-sd/config/lora-scripts-launch.conf
    fi
}

# 重置启动参数
restore_lora_scripts_launch_args()
{
    if (dialog --erase-on-exit \
        --title "lora-scripts 管理" \
        --backtitle "lora-scripts 重置启动参数选项选项" \
        --yes-label "是" --no-label "否" \
        --yesno "是否重置 lora-scripts 启动参数" \
        $term_sd_dialog_height $term_sd_dialog_width) then

        term_sd_echo "重置启动参数"
        rm -f "$start_path"/term-sd/config/lora-scripts-launch.conf
        add_lora_scripts_normal_launch_args
    else
        term_sd_echo "取消重置操作"
    fi
}