#!/bin/bash

# kohya_ss选项
kohya_ss_manager()
{
    export term_sd_manager_info="kohya_ss"
    cd "$start_path" # 回到最初路径
    exit_venv # 确保进行下一步操作前已退出其他虚拟环境
    if [ -d "$kohya_ss_path" ] && ! term_sd_test_empty_dir "$kohya_ss_path" ;then
        while true
        do
            cd "$kohya_ss_path"
            kohya_ss_manager_dialog=$(dialog --erase-on-exit --notags \
                --title "kohya_ss 管理" \
                --backtitle "kohya_ss 管理选项" \
                --ok-label "确认" \
                --cancel-label "取消" \
                --menu "请选择 kohya_ss 管理选项的功能\n当前更新源: $(git_remote_display)\n当前分支: $(git_branch_display)" \
                $term_sd_dialog_height $term_sd_dialog_width $term_sd_dialog_menu_height \
                "0" "> 返回" \
                "1" "> 启动" \
                "2" "> 更新" \
                "3" "> 修复更新" \
                "4" "> 切换版本" \
                "5" "> 更新源替换" \
                "6" "> 更新依赖" \
                "7" "> Python 软件包安装 / 重装 / 卸载" \
                "8" "> 依赖库版本管理" \
                "9" "> 重新安装 PyTorch" \
                "10" "> 修复虚拟环境" \
                "11" "> 重新构建虚拟环境" \
                "12" "> 重新安装后端组件" \
                "13" "> 重新安装" \
                "14" "> 卸载" \
                3>&1 1>&2 2>&3)

            case $kohya_ss_manager_dialog in
                1)
                    kohya_ss_launch
                    ;;
                2)
                    if is_git_repo ;then
                        term_sd_echo "更新 kohya_ss 中"
                        git_pull_repository
                        if [ $? = 0 ];then
                            dialog --erase-on-exit \
                                --title "kohya_ss 管理" \
                                --backtitle "kohya_ss 更新结果" \
                                --ok-label "确认" \
                                --msgbox "kohya_ss 更新成功" \
                                $term_sd_dialog_height $term_sd_dialog_width
                        else
                            dialog --erase-on-exit \
                                --title "kohya_ss 管理" \
                                --backtitle "kohya_ss 更新结果" \
                                --ok-label "确认" \
                                --msgbox "kohya_ss 更新失败" \
                                $term_sd_dialog_height $term_sd_dialog_width
                        fi
                    else
                        dialog --erase-on-exit \
                            --title "kohya_ss 管理" \
                            --backtitle "kohya_ss 更新结果" \
                            --ok-label "确认" \
                            --msgbox "kohya_ss 非 Git 安装, 无法更新" \
                            $term_sd_dialog_height $term_sd_dialog_width
                    fi
                    ;;
                
                3)
                    if is_git_repo ;then
                        if (dialog --erase-on-exit \
                            --title "kohya_ss 管理" \
                            --backtitle "kohya_ss 更新修复选项" \
                            --yes-label "是" --no-label "否" \
                            --yesno "是否修复 kohya_ss 更新?" \
                            $term_sd_dialog_height $term_sd_dialog_width) then

                            git_fix_pointer_offset
                        fi
                    else
                        dialog --erase-on-exit \
                            --title "kohya_ss 管理" \
                            --backtitle "kohya_ss 更新修复选项" \
                            --ok-label "确认" \
                            --msgbox "kohya_ss 非 Git 安装, 无法修复更新" \
                            $term_sd_dialog_height $term_sd_dialog_width
                    fi
                    ;;
                4)
                    if is_git_repo ;then
                        if (dialog --erase-on-exit \
                            --title "kohya_ss 管理" \
                            --backtitle "kohya_ss 版本切换选项" \
                            --yes-label "是" --no-label "否" \
                            --yesno "是否切换 kohya_ss 版本?" \
                            $term_sd_dialog_height $term_sd_dialog_width) then

                            git_ver_switch
                        fi
                    else
                        dialog --erase-on-exit \
                            --title "kohya_ss 管理" \
                            --backtitle "kohya_ss 版本切换选项" \
                            --ok-label "确认" \
                            --msgbox "kohya_ss 非 Git 安装, 无法切换版本" \
                            $term_sd_dialog_height $term_sd_dialog_width
                    fi
                    ;;
                5)
                    if is_git_repo ;then
                        if (dialog --erase-on-exit \
                            --title "kohya_ss 管理" \
                            --backtitle "kohya_ss 更新源切换选项" \
                            --yes-label "是" --no-label "否" \
                            --yesno "是否切换 kohya_ss 更新源?" \
                            $term_sd_dialog_height $term_sd_dialog_width) then

                            kohya_ss_remote_revise
                        fi
                    else
                        dialog --erase-on-exit \
                            --title "kohya_ss 管理" \
                            --backtitle "kohya_ss 更新源切换选项" \
                            --ok-label "确认" \
                            --msgbox "kohya_ss 非 Git 安装, 无法切换更新源" \
                            $term_sd_dialog_height $term_sd_dialog_width
                    fi
                    ;;
                
                6)
                    kohya_ss_update_depend
                     ;;
                7)
                    if (dialog --erase-on-exit \
                        --title "kohya_ss 管理" \
                        --backtitle "kohya_ss 的 Python 软件包安装 / 重装 / 卸载选项" \
                        --yes-label "是" --no-label "否" \
                        --yesno "是否进入 Python 软件包安装 / 重装 / 卸载选项?" \
                        $term_sd_dialog_height $term_sd_dialog_width) then

                        python_package_manager
                    fi
                     ;;
                8)
                    python_package_ver_backup_manager
                     ;;
                9)
                    pytorch_reinstall
                     ;;
                10)
                    if [ $venv_setup_status = 0 ];then
                        if (dialog --erase-on-exit \
                            --title "kohya_ss 管理" \
                            --backtitle "kohya_ss 虚拟环境修复选项" \
                            --yes-label "是" --no-label "否" \
                            --yesno "是否修复 kohya_ss 的虚拟环境" \
                            $term_sd_dialog_height $term_sd_dialog_width) then

                            fix_venv
                        fi
                    else
                        dialog --erase-on-exit \
                            --title "kohya_ss 管理" \
                            --backtitle "kohya_ss 虚拟环境修复选项" \
                            --ok-label "确认" \
                            --msgbox "虚拟环境功能已禁用, 无法使用该功能" \
                            $term_sd_dialog_height $term_sd_dialog_width
                    fi
                     ;;
                11)
                    if [ $venv_setup_status = 0 ];then
                        if (dialog --erase-on-exit \
                            --title "kohya_ss 管理" \
                            --backtitle "kohya_ss 虚拟环境重建选项" \
                            --yes-label "是" --no-label "否" \
                            --yesno "是否重建 kohya_ss 的虚拟环境?" \
                            $term_sd_dialog_height $term_sd_dialog_width) then

                            kohya_ss_venv_rebuild
                        fi
                    else
                        dialog --erase-on-exit \
                            --title "kohya_ss 管理" \
                            --backtitle "kohya_ss 虚拟环境重建选项" \
                            --ok-label "确认" \
                            --msgbox "虚拟环境功能已禁用, 无法使用该功能" \
                            $term_sd_dialog_height $term_sd_dialog_width
                    fi
                    ;;
                12)
                    kohya_ss_backend_repo_reinstall
                    ;;
                13)
                    if (dialog --erase-on-exit \
                        --title "kohya_ss 管理" \
                        --backtitle "kohya_ss 重新安装选项" \
                        --yes-label "是" --no-label "否" \
                        --yesno "是否重新安装 kohya_ss ?" \
                        $term_sd_dialog_height $term_sd_dialog_width) then

                        cd "$start_path"
                        rm -f "$start_path/term-sd/task/kohya_ss_install.sh"
                        exit_venv
                        install_kohya_ss
                        break
                    fi
                    ;;
                14)
                    if (dialog --erase-on-exit \
                        --title "kohya_ss 管理" \
                        --backtitle "kohya_ss 删除选项" \
                        --yes-label "是" --no-label "否" \
                        --yesno "是否删除 kohya_ss ?" \
                        $term_sd_dialog_height $term_sd_dialog_width) then

                        term_sd_echo "请再次确认是否删除 kohya_ss (yes/no)?"
                        term_sd_echo "警告: 该操作将永久删除 kohya_ss"
                        term_sd_echo "提示: 输入 yes 或 no 后回车"
                        case $(term_sd_read) in
                            yes|y|YES|Y)
                                term_sd_echo "删除 kohya_ss 中"
                                exit_venv
                                cd ..
                                rm -rf "$kohya_ss_folder"

                                dialog --erase-on-exit \
                                    --title "kohya_ss 管理" \
                                    --backtitle "kohya_ss 删除选项" \
                                    --ok-label "确认" \
                                    --msgbox "删除 kohya_ss 完成" \
                                    $term_sd_dialog_height $term_sd_dialog_width

                                break
                                ;;
                            *)
                                term_sd_echo "取消删除操作"
                                ;;
                        esac
                    else
                        term_sd_echo "取消删除操作"
                    fi
                    ;;
                *)
                    break
                    ;;
            esac
        done
    else
        if (dialog --erase-on-exit \
            --title "kohya_ss 管理" \
            --backtitle "kohya_ss 安装选项" \
            --yes-label "是" --no-label "否" \
            --yesno "检测到当前未安装 kohya_ss , 是否进行安装?" \
            $term_sd_dialog_height $term_sd_dialog_width) then

            rm -f "$start_path/term-sd/task/kohya_ss_install.sh"
            install_kohya_ss
        fi
    fi
}

# kohya_ss依赖更新功能
kohya_ss_update_depend()
{
    if (dialog --erase-on-exit \
        --title "kohya_ss 管理" \
        --backtitle "kohya_ss 依赖更新选项" \
        --yes-label "是" --no-label "否" \
        --yesno "是否更新 kohya_ss 的依赖?" \
        $term_sd_dialog_height $term_sd_dialog_width) then

        # 更新前的准备
        download_mirror_select # 下载镜像源选择
        pip_install_mode_select # 安装方式选择
        term_sd_install_confirm "是否更新 kohya_ss 依赖?" # 安装前确认

        if [ $? = 0 ];then
            term_sd_print_line "kohya_ss 依赖更新"
            term_sd_echo "更新 kohya_ss 依赖中"
            term_sd_tmp_disable_proxy
            create_venv
            enter_venv
            python_package_update "requirements.txt" # kohya_ss安装依赖
            exit_venv
            term_sd_tmp_enable_proxy
            term_sd_echo "更新 kohya_ss 依赖结束"
            term_sd_pause
        fi
    fi
}

# 后端组件重装
kohya_ss_backend_repo_reinstall()
{
    if (dialog --erase-on-exit \
        --title "kohya_ss 管理" \
        --backtitle "kohya_ss 后端组件重装选项" \
        --yes-label "是" --no-label "否" \
        --yesno "是否重新安装 kohya_ss 后端组件?" \
        $term_sd_dialog_height $term_sd_dialog_width) then

        download_mirror_select # 下载镜像源选择
        term_sd_install_confirm "是否重新安装 kohya_ss 后端组件?" # 安装前确认

        if [ $? = 0 ];then
            term_sd_print_line "kohya_ss 后端组件重装"
            term_sd_echo "删除原有 kohya_ss 后端组件中"
            rm -rf sd-scripts
            term_sd_mkdir sd-scripts
            term_sd_echo "重新下载 kohya_ss 后端组件中"
            git_clone_repository ${github_mirror} https://github.com/kohya-ss/sd-scripts "$kohya_ss_path" sd-scripts # kohya_ss后端
            git submodule init
            git submodule update
            term_sd_echo "重装 kohya_ss 后端组件结束"
            term_sd_pause
        fi
    fi
}
