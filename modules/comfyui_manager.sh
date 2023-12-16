#!/bin/bash

# comfyui选项
comfyui_manager()
{
    local comfyui_manager_dialog
    export term_sd_manager_info="ComfyUI"

    cd "$start_path" # 回到最初路径
    exit_venv # 确保进行下一步操作前已退出其他虚拟环境

    if [ -d "$comfyui_folder" ] && [ $(ls "$comfyui_folder" -al --format=horizontal | wc --words) -gt 2 ];then
        cd $comfyui_folder
        comfyui_manager_dialog=$(
            dialog --erase-on-exit --notags --title "ComfyUI管理" --backtitle "ComfyUI管理选项" --ok-label "确认" --cancel-label "取消" --menu "请选择ComfyUI管理选项的功能\n当前更新源:$(git_remote_display)\n当前分支:$(git_branch_display)" $term_sd_dialog_height $term_sd_dialog_width $term_sd_dialog_menu_height \
            "0" "> 返回" \
            "1" "> 启动" \
            "2" "> 更新" \
            "3" "> 修复更新" \
            "4" "> 管理自定义节点" \
            "5" "> 管理插件" \
            "6" "> 切换版本" \
            "7" "> 更新源替换" \
            "8" "> 更新依赖" \
            "9" "> python软件包安装/重装/卸载" \
            "10" "> 依赖库版本管理" \
            "11" "> 重新安装pytorch" \
            "12" "> 修复虚拟环境" \
            "13" "> 重新构建虚拟环境" \
            "14" "> 重新安装" \
            "15" "> 卸载" \
            3>&1 1>&2 2>&3)

        case $comfyui_manager_dialog in
            1)
                comfyui_launch
                comfyui_manager
                ;;
            2)
                term_sd_echo "更新ComfyUI中"
                git_pull_repository
                case $? in
                    0)
                        dialog --erase-on-exit --title "ComfyUI管理" --backtitle "ComfyUI更新结果" --ok-label "确认" --msgbox "ComfyUI更新成功" $term_sd_dialog_height $term_sd_dialog_width
                        ;;
                    10)
                        dialog --erase-on-exit --title "ComfyUI管理" --backtitle "ComfyUI更新结果" --ok-label "确认" --msgbox "ComfyUI非git安装,无法更新" $term_sd_dialog_height $term_sd_dialog_width
                        ;;
                    *)
                        dialog --erase-on-exit --title "ComfyUI管理" --backtitle "ComfyUI更新结果" --ok-label "确认" --msgbox "ComfyUI更新失败" $term_sd_dialog_height $term_sd_dialog_width
                        ;;
                esac
                comfyui_manager
                ;;
            
            3)
                git_fix_pointer_offset
                comfyui_manager
                ;;
            4)
                export comfyui_extension_info=1 # 1代表自定义节点，其他数字代表插件
                cd custom_nodes
                comfyui_custom_node_manager
                comfyui_manager
                ;;
            5)
                export comfyui_extension_info=2
                cd web/extensions
                comfyui_extension_manager
                comfyui_manager
                ;;
            6)
                git_ver_switch
                comfyui_manager
                ;;
            7)
                if (dialog --erase-on-exit --title "ComfyUI管理" --backtitle "ComfyUI更新源切换选项" --yes-label "是" --no-label "否" --yesno "是否切换ComfyUI更新源?" $term_sd_dialog_height $term_sd_dialog_width) then
                    comfyui_remote_revise
                fi
                comfyui_manager
                ;;
            
            8)
                comfyui_update_depend
                comfyui_manager
                ;;
            9)
                if (dialog --erase-on-exit --title "ComfyUI管理" --backtitle "ComfyUI的python软件包安装/重装/卸载选项" --yes-label "是" --no-label "否" --yesno "是否进入python软件包安装/重装/卸载选项?" $term_sd_dialog_height $term_sd_dialog_width) then
                    python_package_manager
                fi
                comfyui_manager
                ;;
            10)
                python_package_ver_backup_manager
                comfyui_manager
                ;;
            11)
                pytorch_reinstall
                comfyui_manager
                ;;
            12)
                if [ $venv_setup_status = 0 ];then
                    if (dialog --erase-on-exit --title "ComfyUI管理" --backtitle "ComfyUI虚拟环境修复选项" --yes-label "是" --no-label "否" --yesno "是否修复ComfyUI的虚拟环境" $term_sd_dialog_height $term_sd_dialog_width);then
                        create_venv --fix
                    fi
                else
                    dialog --erase-on-exit --title "ComfyUI管理" --backtitle "ComfyUI虚拟环境修复选项" --ok-label "确认" --msgbox "虚拟环境功能已禁用,无法使用该功能" $term_sd_dialog_height $term_sd_dialog_width
                fi
                comfyui_manager
                ;;
            13)
                if [ $venv_setup_status = 0 ];then
                    if (dialog --erase-on-exit --title "ComfyUI管理" --backtitle "ComfyUI虚拟环境重建选项" --yes-label "是" --no-label "否" --yesno "是否重建ComfyUI的虚拟环境" $term_sd_dialog_height $term_sd_dialog_width);then
                        comfyui_venv_rebuild
                    fi
                else
                    dialog --erase-on-exit --title "ComfyUI管理" --backtitle "ComfyUI虚拟环境重建选项" --ok-label "确认" --msgbox "虚拟环境功能已禁用,无法使用该功能" $term_sd_dialog_height $term_sd_dialog_width
                fi
                comfyui_manager
                ;;
            14)
                if (dialog --erase-on-exit --title "ComfyUI管理" --backtitle "ComfyUI重新安装选项" --yes-label "是" --no-label "否" --yesno "是否重新安装ComfyUI?" $term_sd_dialog_height $term_sd_dialog_width) then
                    cd "$start_path"
                    rm -f "$start_path/term-sd/task/comfyui_install.sh"
                    exit_venv
                    install_comfyui
                else
                    comfyui_manager
                fi
                ;;
            15)
                if (dialog --erase-on-exit --title "ComfyUI管理" --backtitle "ComfyUI删除选项" --yes-label "是" --no-label "否" --yesno "是否删除ComfyUI?" $term_sd_dialog_height $term_sd_dialog_width) then
                    term_sd_echo "请再次确认是否删除ComfyUI(yes/no)?"
                    term_sd_echo "警告:该操作将永久删除ComfyUI"
                    term_sd_echo "提示:输入yes或no后回车"
                    case $(term_sd_read) in
                        yes|y|YES|Y)
                            term_sd_echo "删除ComfyUI中"
                            exit_venv
                            cd ..
                            rm -rf ./"$comfyui_folder"
                            term_sd_echo "删除ComfyUI完成"
                            ;;
                        *)
                            term_sd_echo "取消删除操作"
                            comfyui_manager
                            ;;
                    esac
                else
                    term_sd_echo "取消删除操作"
                    comfyui_manager
                fi
                ;;
        esac
    else
        if (dialog --erase-on-exit --title "ComfyUI管理" --backtitle "ComfyUI安装选项" --yes-label "是" --no-label "否" --yesno "检测到当前未安装ComfyUI,是否进行安装?" $term_sd_dialog_height $term_sd_dialog_width) then
            rm -f "$start_path/term-sd/task/comfyui_install.sh"
            install_comfyui
        fi
    fi
}

# comfyui依赖更新功能
comfyui_update_depend()
{
    if (dialog --erase-on-exit --title "ComfyUI管理" --backtitle "ComfyUI依赖更新选项" --yes-label "是" --no-label "否" --yesno "是否更新ComfyUI的依赖?" $term_sd_dialog_height $term_sd_dialog_width);then
        # 更新前的准备
        download_mirror_select # 下载镜像源选择
        pip_install_mode_select # 安装方式选择
        term_sd_install_confirm # 安装前确认

        if [ $? = 0 ];then
            term_sd_print_line "ComfyUI依赖更新"
            term_sd_echo "更新ComfyUI依赖中"
            term_sd_tmp_disable_proxy
            create_venv
            enter_venv
            python_package_update "./requirements.txt"
            exit_venv
            term_sd_tmp_enable_proxy
            term_sd_echo "更新ComfyUI依赖结束"
            term_sd_pause
        fi
    fi
}
