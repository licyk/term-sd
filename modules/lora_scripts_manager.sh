#!/bin/bash

# lora-scripts选项
lora_scripts_manager()
{
    export term_sd_manager_info="lora-scripts"
    cd "$start_path" # 回到最初路径
    exit_venv # 确保进行下一步操作前已退出其他虚拟环境
    if [ -d "./lora-scripts" ];then
        cd lora-scripts
        lora_scripts_manager_dialog=$(
            dialog --erase-on-exit --notags --title "lora-scripts管理" --backtitle "lora-scripts管理选项" --ok-label "确认" --cancel-label "取消" --menu "请选择lora-scripts管理选项的功能\n当前更新源:$(git remote -v | awk 'NR==1 {print $2}')" $term_sd_dialog_width $term_sd_dialog_height $term_sd_dialog_menu_height \
            "0" "> 返回" \
            "1" "> 启动" \
            "2" "> 更新" \
            "3" "> 修复更新" \
            "4" "> 切换版本" \
            "5" "> 更新源替换" \
            "6" "> 更新依赖" \
            "7" "> python软件包安装/重装/卸载" \
            "8" "> 依赖库版本管理" \
            "9" "> 重新安装pytorch" \
            "10" "> 修复虚拟环境" \
            "11" "> 重新构建虚拟环境" \
            "12" "> 重新安装" \
            "13" "> 卸载" \
            3>&1 1>&2 2>&3)

        case $lora_scripts_manager_dialog in
            1)
                term_sd_print_line "$term_sd_manager_info 启动"
                enter_venv
                term_sd_python ./gui.py
                term_sd_print_line
                lora_scripts_manager
                ;;
            2)
                term_sd_echo "更新lora-scripts中"
                git_pull_repository --submod # 版本不对应,有时会出现各种奇怪的报错
                case $? in
                    0)
                        dialog --erase-on-exit --title "lora-scripts管理" --backtitle "lora-scripts更新结果" --ok-label "确认" --msgbox "lora-scripts更新成功" $term_sd_dialog_width $term_sd_dialog_height
                        ;;
                    10)
                        dialog --erase-on-exit --title "lora-scripts管理" --backtitle "lora-scripts更新结果" --ok-label "确认" --msgbox "lora-scripts非git安装,无法更新" $term_sd_dialog_width $term_sd_dialog_height
                        ;;
                    *)
                        dialog --erase-on-exit --title "lora-scripts管理" --backtitle "lora-scripts更新结果" --ok-label "确认" --msgbox "lora-scripts更新失败" $term_sd_dialog_width $term_sd_dialog_height
                        ;;
                esac
                lora_scripts_manager
                ;;
            
            3)
                git_fix_pointer_offset
                lora_scripts_manager
                ;;
            4)
                git_ver_switch --submod
                lora_scripts_manager
                ;;
            5)
                if (dialog --erase-on-exit --title "lora-scripts管理" --backtitle "lora-scripts更新源切换选项" --yes-label "是" --no-label "否" --yesno "是否切换lora-scripts更新源?" $term_sd_dialog_width $term_sd_dialog_height) then
                    lora_scripts_remote_revise
                fi
                lora_scripts_manager
                ;;
            
            6)
                lora_scripts_update_depend
                lora_scripts_manager
                ;;
            7)
                if (dialog --erase-on-exit --title "lora-scripts管理" --backtitle "lora-scripts的python软件包安装/重装/卸载选项" --yes-label "是" --no-label "否" --yesno "是否进入python软件包安装/重装/卸载选项?" $term_sd_dialog_width $term_sd_dialog_height) then
                    python_package_manager
                fi
                lora_scripts_manager
                ;;
            8)
                python_package_ver_backup_manager
                lora_scripts_manager
                ;;
            9)
                pytorch_reinstall
                lora_scripts_manager
                ;;
            10)
                if [ $venv_setup_status = 0 ];then
                    if (dialog --erase-on-exit --title "lora-scripts管理" --backtitle "lora-scripts虚拟环境修复选项" --yes-label "是" --no-label "否" --yesno "是否修复lora-scripts的虚拟环境" $term_sd_dialog_width $term_sd_dialog_height);then
                        create_venv --fix
                    fi
                else
                    dialog --erase-on-exit --title "lora-scripts管理" --backtitle "lora-scripts虚拟环境修复选项" --ok-label "确认" --msgbox "虚拟环境功能已禁用,无法使用该功能" $term_sd_dialog_width $term_sd_dialog_height
                fi
                lora_scripts_manager
                ;;
            11)
                if [ $venv_setup_status = 0 ];then
                    if (dialog --erase-on-exit --title "lora-scripts管理" --backtitle "lora-scripts虚拟环境重建选项" --yes-label "是" --no-label "否" --yesno "是否重建lora-scripts的虚拟环境" $term_sd_dialog_width $term_sd_dialog_height);then
                        lora_scripts_venv_rebuild
                    fi
                else
                    dialog --erase-on-exit --title "lora-scripts管理" --backtitle "lora-scripts虚拟环境重建选项" --ok-label "确认" --msgbox "虚拟环境功能已禁用,无法使用该功能" $term_sd_dialog_width $term_sd_dialog_height
                fi
                lora_scripts_manager
                ;;
            12)
                if (dialog --erase-on-exit --title "lora-scripts管理" --backtitle "lora-scripts重新安装选项" --yes-label "是" --no-label "否" --yesno "是否重新安装lora-scripts?" $term_sd_dialog_width $term_sd_dialog_height) then
                    cd "$start_path"
                    rm -f "$start_path/term-sd/task/lora_scripts_install.sh"
                    exit_venv
                    install_lora_scripts
                else
                    lora_scripts_manager
                fi
                ;;
            13)
                if (dialog --erase-on-exit --title "lora-scripts管理" --backtitle "lora-scripts删除选项" --yes-label "是" --no-label "否" --yesno "是否删除lora-scripts?" $term_sd_dialog_width $term_sd_dialog_height) then
                    term_sd_echo "请再次确认是否删除lora-scripts(yes/no)?"
                    term_sd_echo "警告:该操作将永久删除lora-scripts"
                    term_sd_echo "提示:输入yes或no后回车"
                    case $(term_sd_read) in
                        yes|y|YES|Y)
                            term_sd_echo "删除lora-scripts中"
                            exit_venv
                            cd ..
                            rm -rf ./lora-scripts
                            term_sd_echo "删除lora-scripts完成"
                            ;;
                        *)
                            term_sd_echo "取消删除操作"
                            lora_scripts_manager
                            ;;
                    esac
                else
                    term_sd_echo "取消删除操作"
                    lora_scripts_manager
                fi
                ;;
        esac
    else
        if (dialog --erase-on-exit --title "lora-scripts管理" --backtitle "lora-scripts安装选项" --yes-label "是" --no-label "否" --yesno "检测到当前未安装lora_scripts,是否进行安装?" $term_sd_dialog_width $term_sd_dialog_height) then
            rm -f "$start_path/term-sd/task/lora_scripts_install.sh"
            install_lora_scripts
        fi
    fi
}

# lora-scripts依赖更新功能
lora_scripts_update_depend()
{
    if (dialog --erase-on-exit --title "lora-scripts管理" --backtitle "lora-scripts依赖更新选项" --yes-label "是" --no-label "否" --yesno "是否更新lora-scripts的依赖?" $term_sd_dialog_width $term_sd_dialog_height);then
        # 更新前的准备
        download_mirror_select # 下载镜像源选择
        pip_install_mode_select # 安装方式选择
        term_sd_install_confirm # 安装前确认

        if [ $? = 0 ];then
            term_sd_print_line "lora-scripts依赖更新"
            term_sd_echo "更新lora-scripts依赖中"
            tmp_disable_proxy
            create_venv
            enter_venv
            cd ./sd-scripts
            requirements_python_package_update "./requirements.txt" # sd-scripts目录下还有个_typos.toml，在安装requirements.txt里的依赖时会指向这个文件
            cd ..
            term_sd_watch term_sd_pip install $pip_index_mirror $pip_extra_index_mirror $pip_find_mirror $pip_break_system_package $pip_install_mode --prefer-binary --upgrade lion-pytorch dadaptation prodigyopt lycoris-lora fastapi uvicorn wandb scipy
            requirements_python_package_update "./requirements.txt" # lora-scripts安装依赖
            exit_venv
            tmp_enable_proxy
            term_sd_echo "更新lora-scripts依赖结束"
            term_sd_print_line
        fi
    fi
}
