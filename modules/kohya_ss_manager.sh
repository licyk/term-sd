#!/bin/bash

# kohya_ss选项
kohya_ss_manager()
{
    export term_sd_manager_info="kohya_ss"
    cd "$start_path" # 回到最初路径
    exit_venv # 确保进行下一步操作前已退出其他虚拟环境
    if [ -d "$kohya_ss_path" ] && [ $(ls "$kohya_ss_path" -al --format=horizontal | wc --words) -gt 2 ];then
        cd "$kohya_ss_path"
        kohya_ss_manager_dialog=$(
            dialog --erase-on-exit --notags --title "kohya_ss管理" --backtitle "kohya_ss管理选项" --ok-label "确认" --cancel-label "取消" --menu "请选择kohya_ss管理选项的功能\n当前更新源:$(git_remote_display)\n当前分支:$(git_branch_display)" $term_sd_dialog_height $term_sd_dialog_width $term_sd_dialog_menu_height \
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

        case $kohya_ss_manager_dialog in
            1)
                term_sd_print_line "$term_sd_manager_info 启动"
                enter_venv
                term_sd_python ./kohya_gui.py --language zh-CN
                term_sd_pause
                kohya_ss_manager
                ;;
            2)
                term_sd_echo "更新kohya_ss中"
                git_pull_repository --submod # 版本不对应,有时会出现各种奇怪的报错
                case $? in
                    0)
                        dialog --erase-on-exit --title "kohya_ss管理" --backtitle "kohya_ss更新结果" --ok-label "确认" --msgbox "kohya_ss更新成功" $term_sd_dialog_height $term_sd_dialog_width
                        ;;
                    10)
                        dialog --erase-on-exit --title "kohya_ss管理" --backtitle "kohya_ss更新结果" --ok-label "确认" --msgbox "kohya_ss非git安装,无法更新" $term_sd_dialog_height $term_sd_dialog_width
                        ;;
                    *)
                        dialog --erase-on-exit --title "kohya_ss管理" --backtitle "kohya_ss更新结果" --ok-label "确认" --msgbox "kohya_ss更新失败" $term_sd_dialog_height $term_sd_dialog_width
                        ;;
                esac
                kohya_ss_manager
                ;;
            
            3)
                git_fix_pointer_offset
                kohya_ss_manager
                ;;
            4)
                git_ver_switch --submod
                kohya_ss_manager
                ;;
            5)
                if (dialog --erase-on-exit --title "kohya_ss管理" --backtitle "kohya_ss更新源切换选项" --yes-label "是" --no-label "否" --yesno "是否切换kohya_ss更新源?" $term_sd_dialog_height $term_sd_dialog_width) then
                    kohya_ss_remote_revise
                fi
                kohya_ss_manager
                ;;
            
            6)
                kohya_ss_update_depend
                kohya_ss_manager
                ;;
            7)
                if (dialog --erase-on-exit --title "kohya_ss管理" --backtitle "kohya_ss的python软件包安装/重装/卸载选项" --yes-label "是" --no-label "否" --yesno "是否进入python软件包安装/重装/卸载选项?" $term_sd_dialog_height $term_sd_dialog_width) then
                    python_package_manager
                fi
                kohya_ss_manager
                ;;
            8)
                python_package_ver_backup_manager
                kohya_ss_manager
                ;;
            9)
                pytorch_reinstall
                kohya_ss_manager
                ;;
            10)
                if [ $venv_setup_status = 0 ];then
                    if (dialog --erase-on-exit --title "kohya_ss管理" --backtitle "kohya_ss虚拟环境修复选项" --yes-label "是" --no-label "否" --yesno "是否修复kohya_ss的虚拟环境" $term_sd_dialog_height $term_sd_dialog_width);then
                        create_venv --fix
                    fi
                else
                    dialog --erase-on-exit --title "kohya_ss管理" --backtitle "kohya_ss虚拟环境修复选项" --ok-label "确认" --msgbox "虚拟环境功能已禁用,无法使用该功能" $term_sd_dialog_height $term_sd_dialog_width
                fi
                kohya_ss_manager
                ;;
            11)
                if [ $venv_setup_status = 0 ];then
                    if (dialog --erase-on-exit --title "kohya_ss管理" --backtitle "kohya_ss虚拟环境重建选项" --yes-label "是" --no-label "否" --yesno "是否重建kohya_ss的虚拟环境" $term_sd_dialog_height $term_sd_dialog_width);then
                        kohya_ss_venv_rebuild
                    fi
                else
                    dialog --erase-on-exit --title "kohya_ss管理" --backtitle "kohya_ss虚拟环境重建选项" --ok-label "确认" --msgbox "虚拟环境功能已禁用,无法使用该功能" $term_sd_dialog_height $term_sd_dialog_width
                fi
                kohya_ss_manager
                ;;
            12)
                if (dialog --erase-on-exit --title "kohya_ss管理" --backtitle "kohya_ss重新安装选项" --yes-label "是" --no-label "否" --yesno "是否重新安装kohya_ss?" $term_sd_dialog_height $term_sd_dialog_width) then
                    cd "$start_path"
                    rm -f "$start_path/term-sd/task/kohya_ss_install.sh"
                    exit_venv
                    install_kohya_ss
                else
                    kohya_ss_manager
                fi
                ;;
            13)
                if (dialog --erase-on-exit --title "kohya_ss管理" --backtitle "kohya_ss删除选项" --yes-label "是" --no-label "否" --yesno "是否删除kohya_ss?" $term_sd_dialog_height $term_sd_dialog_width) then
                    term_sd_echo "请再次确认是否删除kohya_ss(yes/no)?"
                    term_sd_echo "警告:该操作将永久删除kohya_ss"
                    term_sd_echo "提示:输入yes或no后回车"
                    case $(term_sd_read) in
                        yes|y|YES|Y)
                            term_sd_echo "删除kohya_ss中"
                            exit_venv
                            cd ..
                            rm -rf ./"$kohya_ss_folder"
                            term_sd_echo "删除kohya_ss完成"
                            ;;
                        *)
                            term_sd_echo "取消删除操作"
                            kohya_ss_manager
                            ;;
                    esac
                else
                    term_sd_echo "取消删除操作"
                    kohya_ss_manager
                fi
                ;;
        esac
    else
        if (dialog --erase-on-exit --title "kohya_ss管理" --backtitle "kohya_ss安装选项" --yes-label "是" --no-label "否" --yesno "检测到当前未安装kohya_ss,是否进行安装?" $term_sd_dialog_height $term_sd_dialog_width) then
            rm -f "$start_path/term-sd/task/kohya_ss_install.sh"
            install_kohya_ss
        fi
    fi
}

# kohya_ss依赖更新功能
kohya_ss_update_depend()
{
    if (dialog --erase-on-exit --title "kohya_ss管理" --backtitle "kohya_ss依赖更新选项" --yes-label "是" --no-label "否" --yesno "是否更新kohya_ss的依赖?" $term_sd_dialog_height $term_sd_dialog_width);then
        # 更新前的准备
        download_mirror_select # 下载镜像源选择
        pip_install_mode_select # 安装方式选择
        term_sd_install_confirm # 安装前确认

        if [ $? = 0 ];then
            term_sd_print_line "kohya_ss依赖更新"
            term_sd_echo "更新kohya_ss依赖中"
            term_sd_tmp_disable_proxy
            create_venv
            enter_venv
            term_sd_watch term_sd_pip install $pip_index_mirror $pip_extra_index_mirror $pip_find_mirror $pip_break_system_package $pip_install_mode --prefer-binary --upgrade lion-pytorch dadaptation prodigyopt lycoris-lora fastapi uvicorn wandb scipy
            python_package_update "./requirements.txt" # kohya_ss安装依赖
            exit_venv
            term_sd_tmp_enable_proxy
            term_sd_echo "更新kohya_ss依赖结束"
            term_sd_pause
        fi
    fi
}
