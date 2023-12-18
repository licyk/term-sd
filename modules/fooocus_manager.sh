#!/bin/bash

# fooocus管理界面
fooocus_manager()
{
    local git_req
    local fooocus_manager_dialog
    export term_sd_manager_info="Fooocus"
    cd "$start_path" # 回到最初路径
    exit_venv # 确保进行下一步操作前已退出其他虚拟环境
    if [ -d "$fooocus_path" ] && [ $(term_sd_test_empty_dir "$fooocus_path") = 1 ];then
        cd "$fooocus_path"
        fooocus_manager_dialog=$(
            dialog --erase-on-exit --notags --title "Fooocus管理" --backtitle "Fooocus管理选项" --ok-label "确认" --cancel-label "取消" --menu "请选择Fooocus管理选项的功能\n当前更新源:$(git_remote_display)\n当前分支:$(git_branch_display)" $term_sd_dialog_height $term_sd_dialog_width $term_sd_dialog_menu_height \
            "0" "> 返回" \
            "1" "> 启动" \
            "2" "> 更新" \
            "3" "> 修复更新" \
            "4" "> 切换版本" \
            "5" "> 更新源替换" \
            "6" "> 更新依赖" \
            "7" "> Python软件包安装/重装/卸载" \
            "8" "> 依赖库版本管理" \
            "9" "> 重新安装PyTorch" \
            "10" "> 修复虚拟环境" \
            "11" "> 重新构建虚拟环境" \
            "12" "> 重新安装后端组件" \
            "13" "> 重新安装" \
            "14" "> 卸载" \
            3>&1 1>&2 2>&3)

        case $fooocus_manager_dialog in
            1)
                fooocus_launch
                fooocus_manager
                ;;
            2)
                term_sd_echo "更新Fooocus中"
                git_pull_repository
                git_req=$?
                cd repositories/ComfyUI-from-StabilityAI-Official
                git_pull_repository
                case $git_req in
                    0)
                        dialog --erase-on-exit --title "Fooocus管理" --backtitle "Fooocus更新结果" --ok-label "确认" --msgbox "Fooocus更新成功" $term_sd_dialog_height $term_sd_dialog_width
                        ;;
                    10)
                        dialog --erase-on-exit --title "Fooocus管理" --backtitle "Fooocus更新结果" --ok-label "确认" --msgbox "Fooocus非git安装,无法更新" $term_sd_dialog_height $term_sd_dialog_width
                        ;;
                    *)
                        dialog --erase-on-exit --title "Fooocus管理" --backtitle "Fooocus更新结果" --ok-label "确认" --msgbox "Fooocus更新失败" $term_sd_dialog_height $term_sd_dialog_width
                        ;;
                esac
                fooocus_manager
                ;;
            3)
                git_fix_pointer_offset # 修复Fooocus
                cd repositories/Fooocus-from-StabilityAI-Official
                git_fix_pointer_offset # 修复Fooocus的核心ComfyUI
                fooocus_manager
                ;;
            4)
                git_ver_switch
                fooocus_manager
                ;;
            5)
                if (dialog --erase-on-exit --title "Fooocus管理" --backtitle "Fooocus更新源切换选项" --yes-label "是" --no-label "否" --yesno "是否切换Fooocus更新源?" $term_sd_dialog_height $term_sd_dialog_width) then
                    fooocus_remote_revise
                fi
                fooocus_manager
                ;;
            6)
                fooocus_update_depend
                fooocus_manager
                ;;
            7)
                if (dialog --erase-on-exit --title "Fooocus管理" --backtitle "Fooocus的Python软件包安装/重装/卸载选项" --yes-label "是" --no-label "否" --yesno "是否进入Python软件包安装/重装/卸载选项?" $term_sd_dialog_height $term_sd_dialog_width) then
                    python_package_manager
                fi
                fooocus_manager
                ;;
            8)
                python_package_ver_backup_manager
                fooocus_manager
                ;;
            9)
                pytorch_reinstall
                fooocus_manager
                ;;
            10)
                if [ $venv_setup_status = 0 ];then
                    if (dialog --erase-on-exit --title "Fooocus管理" --backtitle "Fooocus虚拟环境修复选项" --yes-label "是" --no-label "否" --yesno "是否修复Fooocus的虚拟环境" $term_sd_dialog_height $term_sd_dialog_width);then
                        create_venv --fix
                    fi
                else
                    dialog --erase-on-exit --title "Fooocus管理" --backtitle "Fooocus虚拟环境修复选项" --ok-label "确认" --msgbox "虚拟环境功能已禁用,无法使用该功能" $term_sd_dialog_height $term_sd_dialog_width
                fi
                fooocus_manager
                ;;
            11)
                if [ $venv_setup_status = 0 ];then
                    if (dialog --erase-on-exit --title "Fooocus管理" --backtitle "Fooocus虚拟环境重建选项" --yes-label "是" --no-label "否" --yesno "是否重建Fooocus的虚拟环境" $term_sd_dialog_height $term_sd_dialog_width);then
                        fooocus_venv_rebuild
                    fi
                else
                    dialog --erase-on-exit --title "Fooocus管理" --backtitle "Fooocus虚拟环境重建选项" --ok-label "确认" --msgbox "虚拟环境功能已禁用,无法使用该功能" $term_sd_dialog_height $term_sd_dialog_width
                fi
                fooocus_manager
                ;;
            12)
                foooucs_backend_repo_reinstall
                fooocus_manager
                ;;
            13)
                if (dialog --erase-on-exit --title "Fooocus管理" --backtitle "Fooocus重新安装选项" --yes-label "是" --no-label "否" --yesno "是否重新安装Fooocus?" $term_sd_dialog_height $term_sd_dialog_width) then
                    cd "$start_path"
                    rm -f "$start_path/term-sd/task/fooocus_install.sh"
                    exit_venv
                    install_fooocus
                else
                    fooocus_manager
                fi
                ;;
            14)
                if (dialog --erase-on-exit --title "Fooocus管理" --backtitle "Fooocus删除选项" --yes-label "是" --no-label "否" --yesno "是否删除Fooocus?" $term_sd_dialog_height $term_sd_dialog_width) then
                    term_sd_echo "请再次确认是否删除Fooocus(yes/no)?"
                    term_sd_echo "警告:该操作将永久删除Fooocus"
                    term_sd_echo "提示:输入yes或no后回车"
                    case $(term_sd_read) in
                        yes|y|YES|Y)
                            term_sd_echo "删除Fooocus中"
                            exit_venv
                            cd ..
                            rm -rf "$fooocus_folder"
                            term_sd_echo "删除Fooocus完成"
                            ;;
                        *)
                            term_sd_echo "取消删除操作"
                            fooocus_manager
                            ;;
                    esac
                else
                    term_sd_echo "取消删除操作"
                    fooocus_manager
                fi
                ;;
        esac
    else
        if (dialog --erase-on-exit --title "Fooocus管理" --backtitle "Fooocus安装选项" --yes-label "是" --no-label "否" --yesno "检测到当前未安装Fooocus,是否进行安装?" $term_sd_dialog_height $term_sd_dialog_width) then
            rm -f "$start_path/term-sd/task/fooocus_install.sh"
            install_fooocus
        fi
    fi
}

# fooocus依赖更新
fooocus_update_depend()
{
    if (dialog --erase-on-exit --title "Fooocus管理" --backtitle "Fooocus依赖更新选项" --yes-label "是" --no-label "否" --yesno "是否更新Fooocus的依赖?" $term_sd_dialog_height $term_sd_dialog_width);then
        # 更新前的准备
        download_mirror_select # 下载镜像源选择
        pip_install_mode_select # 安装方式选择
        term_sd_install_confirm # 安装前确认

        if [ $? = 0 ];then
            term_sd_print_line "Fooocus依赖更新"
            term_sd_echo "更新Fooocus依赖中"
            term_sd_tmp_disable_proxy
            create_venv
            enter_venv
            python_package_update "requirements_versions.txt"
            exit_venv
            term_sd_tmp_enable_proxy
            term_sd_echo "更新Fooocus依赖结束"
            term_sd_pause
        fi
    fi
}

# fooocus后端重装
foooucs_backend_repo_reinstall()
{
    if (dialog --erase-on-exit --title "Fooocus管理" --backtitle "Fooocus后端组件重装选项" --yes-label "是" --no-label "否" --yesno "是否重新安装Fooocus后端组件?" $term_sd_dialog_height $term_sd_dialog_width);then
        download_mirror_select # 下载镜像源选择
        term_sd_install_confirm # 安装前确认

        if [ $? = 0 ];then
            term_sd_print_line "Fooocus后端组件重装"
            term_sd_echo "删除原有Fooocus后端组件中"
            rm -rf repositories/*
            term_sd_echo "重新下载Fooocus后端组件中"
            git_clone_repository ${github_mirror} https://github.com/comfyanonymous/ComfyUI repositories ComfyUI-from-StabilityAI-Official
            term_sd_echo "重装Fooocus后端组件结束"
            term_sd_pause
        fi
    fi
}