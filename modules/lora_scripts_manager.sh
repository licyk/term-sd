#!/bin/bash

# lora-scripts选项
lora_scripts_manager()
{
    export term_sd_manager_info="lora-scripts"
    cd "$start_path" # 回到最初路径
    exit_venv # 确保进行下一步操作前已退出其他虚拟环境
    if [ -d "$lora_scripts_path" ] && [ $(term_sd_test_empty_dir "$lora_scripts_path") = 1 ];then
        while true
        do
            cd "$lora_scripts_path"
            lora_scripts_manager_dialog=$(dialog --erase-on-exit --notags \
                --title "lora-scripts 管理" \
                --backtitle "lora-scripts 管理选项" \
                --ok-label "确认" --cancel-label "取消" \
                --menu "请选择 lora-scripts 管理选项的功能\n当前更新源: $(git_remote_display)\n当前分支: $(git_branch_display)" \
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

            case $lora_scripts_manager_dialog in
                1)
                    lora_scripts_launch
                    ;;
                2)
                    term_sd_echo "更新 lora-scripts 中"
                    git_pull_repository
                    case $? in
                        0)
                            dialog --erase-on-exit \
                                --title "lora-scripts 管理" \
                                --backtitle "lora-scripts 更新结果" \
                                --ok-label "确认" \
                                --msgbox "lora-scripts 更新成功" \
                                $term_sd_dialog_height $term_sd_dialog_width
                            ;;
                        10)
                            dialog --erase-on-exit \
                            --title "lora-scripts 管理" \
                            --backtitle "lora-scripts 更新结果" \
                            --ok-label "确认" \
                            --msgbox "lora-scripts 非 Git 安装, 无法更新" \
                            $term_sd_dialog_height $term_sd_dialog_width
                            ;;
                        *)
                            dialog --erase-on-exit \
                                --title "lora-scripts 管理" \
                                --backtitle "lora-scripts 更新结果" \
                                --ok-label "确认" \
                                --msgbox "lora-scripts 更新失败" \
                                $term_sd_dialog_height $term_sd_dialog_width
                            ;;
                    esac
                    ;;
                
                3)
                    if (dialog --erase-on-exit \
                        --title "lora-scripts 管理" \
                        --backtitle "lora-scripts 更新修复选项" \
                        --yes-label "是" --no-label "否" \
                        --yesno "是否修复 lora-scripts 更新?" \
                        $term_sd_dialog_height $term_sd_dialog_width) then

                        git_fix_pointer_offset
                    fi
                    ;;
                4)
                    if (dialog --erase-on-exit \
                        --title "lora-scripts 管理" \
                        --backtitle "lora-scripts 版本切换选项" \
                        --yes-label "是" --no-label "否" \
                        --yesno "是否切换 lora-scripts 版本?" \
                        $term_sd_dialog_height $term_sd_dialog_width) then

                        git_ver_switch
                    fi
                    ;;
                5)
                    if (dialog --erase-on-exit \
                        --title "lora-scripts 管理" \
                        --backtitle "lora-scripts 更新源切换选项" \
                        --yes-label "是" --no-label "否" \
                        --yesno "是否切换 lora-scripts 更新源?" \
                        $term_sd_dialog_height $term_sd_dialog_width) then

                        lora_scripts_remote_revise
                    fi
                    ;;
                
                6)
                    lora_scripts_update_depend
                    ;;
                7)
                    if (dialog --erase-on-exit \
                        --title "lora-scripts 管理" \
                        --backtitle "lora-scripts 的 Python 软件包安装 / 重装/ 卸载选项" \
                        --yes-label "是" --no-label "否" \
                        --yesno "是否进入 Python 软件包安装/ 重装 / 卸载选项?" \
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
                            --title "lora-scripts 管理" \
                            --backtitle "lora-scripts 虚拟环境修复选项" \
                            --yes-label "是" --no-label "否" \
                            --yesno "是否修复 lora-scripts 的虚拟环境" \
                            $term_sd_dialog_height $term_sd_dialog_width) then

                            fix_venv
                        fi
                    else
                        dialog --erase-on-exit \
                            --title "lora-scripts 管理" \
                            --backtitle "lora-scripts 虚拟环境修复选项" \
                            --ok-label "确认" \
                            --msgbox "虚拟环境功能已禁用, 无法使用该功能" \
                            $term_sd_dialog_height $term_sd_dialog_width
                    fi
                    ;;
                11)
                    if [ $venv_setup_status = 0 ];then
                        if (dialog --erase-on-exit \
                            --title "lora-scripts 管理" \
                            --backtitle "lora-scripts 虚拟环境重建选项" \
                            --yes-label "是" --no-label "否" \
                            --yesno "是否重建 lora-scripts 的虚拟环境?" \
                            $term_sd_dialog_height $term_sd_dialog_width) then

                            lora_scripts_venv_rebuild
                        fi
                    else
                        dialog --erase-on-exit \
                            --title "lora-scripts 管理" \
                            --backtitle "lora-scripts 虚拟环境重建选项" \
                            --ok-label "确认" \
                            --msgbox "虚拟环境功能已禁用, 无法使用该功能" \
                            $term_sd_dialog_height $term_sd_dialog_width
                    fi
                    ;;
                12)
                    lora_scripts_backend_repo_reinstall
                    ;;
                13)
                    if (dialog --erase-on-exit \
                        --title "lora-scripts 管理" \
                        --backtitle "lora-scripts 重新安装选项" \
                        --yes-label "是" --no-label "否" \
                        --yesno "是否重新安装 lora-scripts ?" \
                        $term_sd_dialog_height $term_sd_dialog_width) then

                        cd "$start_path"
                        rm -f "$start_path/term-sd/task/lora_scripts_install.sh"
                        exit_venv
                        install_lora_scripts
                        break
                    fi
                    ;;
                14)
                    if (dialog --erase-on-exit \
                        --title "lora-scripts 管理" \
                        --backtitle "lora-scripts 删除选项" \
                        --yes-label "是" --no-label "否" \
                        --yesno "是否删除 lora-scripts ?" \
                        $term_sd_dialog_height $term_sd_dialog_width) then

                        term_sd_echo "请再次确认是否删除 lora-scripts (yes/no)?"
                        term_sd_echo "警告: 该操作将永久删除 lora-scripts"
                        term_sd_echo "提示: 输入 yes 或 no 后回车"
                        case $(term_sd_read) in
                            yes|y|YES|Y)
                                term_sd_echo "删除 lora-scripts 中"
                                exit_venv
                                cd ..
                                rm -rf "$lora_scripts_folder"

                                dialog --erase-on-exit \
                                    --title "lora-scripts 管理" \
                                    --backtitle "lora-scripts 删除选项" \
                                    --ok-label "确认" \
                                    --msgbox "删除 lora-scripts 完成" \
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
            --title "lora-scripts 管理" \
            --backtitle "lora-scripts 安装选项" \
            --yes-label "是" --no-label "否" \
            --yesno "检测到当前未安装 lora_scripts , 是否进行安装?" \
            $term_sd_dialog_height $term_sd_dialog_width) then

            rm -f "$start_path/term-sd/task/lora_scripts_install.sh"
            install_lora_scripts
        fi
    fi
}

# lora-scripts依赖更新功能
lora_scripts_update_depend()
{
    if (dialog --erase-on-exit \
        --title "lora-scripts 管理" \
        --backtitle "lora-scripts 依赖更新选项" \
        --yes-label "是" --no-label "否" \
        --yesno "是否更新 lora-scripts 的依赖?" \
        $term_sd_dialog_height $term_sd_dialog_width) then

        # 更新前的准备
        download_mirror_select # 下载镜像源选择
        pip_install_mode_select # 安装方式选择
        term_sd_install_confirm "是否更新 lora-scripts 依赖?" # 安装前确认

        if [ $? = 0 ];then
            term_sd_print_line "lora-scripts 依赖更新"
            term_sd_echo "更新 lora-scripts 依赖中"
            term_sd_tmp_disable_proxy
            create_venv
            enter_venv
            cd sd-scripts
            python_package_update requirements.txt # sd-scripts目录下还有个_typos.toml，在安装requirements.txt里的依赖时会指向这个文件
            cd ..
            python_package_update requirements.txt # lora-scripts安装依赖
            exit_venv
            term_sd_tmp_enable_proxy
            term_sd_echo "更新 lora-scripts 依赖结束"
            term_sd_pause
        fi
    fi
}

# 后端组件重装
lora_scripts_backend_repo_reinstall()
{
    if (dialog --erase-on-exit \
        --title "lora-scripts 管理" \
        --backtitle "lora-scripts 后端组件重装选项" \
        --yes-label "是" --no-label "否" \
        --yesno "是否重新安装 lora-scripts 后端组件?" \
        $term_sd_dialog_height $term_sd_dialog_width) then

        download_mirror_select # 下载镜像源选择
        term_sd_install_confirm "是否重新安装 lora-scripts 后端组件?" # 安装前确认

        if [ $? = 0 ];then
            term_sd_print_line "lora-scripts 后端组件重装"
            term_sd_echo "删除原有 lora-scripts 后端组件中"
            rm -rf sd-scripts
            rm -rf frontend
            rm -rf mikazuki/dataset-tag-editor
            term_sd_mkdir sd-scripts
            term_sd_mkdir frontend
            term_sd_mkdir mikazuki/dataset-tag-editor
            term_sd_echo "重新下载 lora-scripts 后端组件中"
            git_clone_repository ${github_mirror} https://github.com/kohya-ss/sd-scripts "$lora_scripts_path" sd-scripts # lora-scripts后端
            git_clone_repository ${github_mirror} https://github.com/hanamizuki-ai/lora-gui-dist "$lora_scripts_path" frontend # lora-scripts前端
            git_clone_repository ${github_mirror} https://github.com/Akegarasu/dataset-tag-editor "$lora_scripts_path"/mikazuki dataset-tag-editor # 标签编辑器
            git submodule init
            git submodule update
            term_sd_echo "重装 lora-scripts 后端组件结束"
            term_sd_pause
        fi
    fi
}
