#!/bin/bash

# kohya_ss 管理界面
kohya_ss_manager() {
    local dialog_arg

    cd "${START_PATH}" # 回到最初路径
    exit_venv # 确保进行下一步操作前已退出其他虚拟环境
    if [[ -d "${KOHYA_SS_ROOT_PATH}" ]] && ! term_sd_is_dir_empty "${KOHYA_SS_ROOT_PATH}"; then
        while true; do
            cd "${KOHYA_SS_ROOT_PATH}"
            dialog_arg=$(dialog --erase-on-exit --notags \
                --title "kohya_ss 管理" \
                --backtitle "kohya_ss 管理选项" \
                --ok-label "确认" \
                --cancel-label "取消" \
                --menu "请选择 kohya_ss 管理选项的功能\n当前更新源: $(git_remote_display)\n当前分支: $(git_branch_display)" \
                $(get_dialog_size_menu) \
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

            case "${dialog_arg}" in
                1)
                    kohya_ss_launch
                    ;;
                2)
                    if is_git_repo; then
                        term_sd_echo "更新 kohya_ss 中"
                        git_pull_repository
                        if [[ "$?" == 0 ]]; then
                            dialog --erase-on-exit \
                                --title "kohya_ss 管理" \
                                --backtitle "kohya_ss 更新结果" \
                                --ok-label "确认" \
                                --msgbox "kohya_ss 更新成功" \
                                $(get_dialog_size)
                        else
                            dialog --erase-on-exit \
                                --title "kohya_ss 管理" \
                                --backtitle "kohya_ss 更新结果" \
                                --ok-label "确认" \
                                --msgbox "kohya_ss 更新失败" \
                                $(get_dialog_size)
                        fi
                    else
                        dialog --erase-on-exit \
                            --title "kohya_ss 管理" \
                            --backtitle "kohya_ss 更新结果" \
                            --ok-label "确认" \
                            --msgbox "kohya_ss 非 Git 安装, 无法更新" \
                            $(get_dialog_size)
                    fi
                    ;;
                
                3)
                    if is_git_repo; then
                        if (dialog --erase-on-exit \
                            --title "kohya_ss 管理" \
                            --backtitle "kohya_ss 更新修复选项" \
                            --yes-label "是" --no-label "否" \
                            --yesno "是否修复 kohya_ss 更新 ?" \
                            $(get_dialog_size)); then

                            git_fix_pointer_offset
                            dialog --erase-on-exit \
                                --title "kohya_ss 管理" \
                                --backtitle "kohya_ss 更新修复选项" \
                                --ok-label "确认" \
                                --msgbox "kohya_ss 修复更新完成" \
                                $(get_dialog_size)
                        fi
                    else
                        dialog --erase-on-exit \
                            --title "kohya_ss 管理" \
                            --backtitle "kohya_ss 更新修复选项" \
                            --ok-label "确认" \
                            --msgbox "kohya_ss 非 Git 安装, 无法修复更新" \
                            $(get_dialog_size)
                    fi
                    ;;
                4)
                    if is_git_repo; then
                        if (dialog --erase-on-exit \
                            --title "kohya_ss 管理" \
                            --backtitle "kohya_ss 版本切换选项" \
                            --yes-label "是" --no-label "否" \
                            --yesno "是否切换 kohya_ss 版本 ?" \
                            $(get_dialog_size)); then

                            git_ver_switch && \
                            dialog --erase-on-exit \
                                --title "kohya_ss 管理" \
                                --backtitle "kohya_ss 版本切换选项" \
                                --ok-label "确认" \
                                --msgbox "kohya_ss 切换版本完成, 当前版本为: $(git_branch_display)" \
                                $(get_dialog_size)
                        fi
                    else
                        dialog --erase-on-exit \
                            --title "kohya_ss 管理" \
                            --backtitle "kohya_ss 版本切换选项" \
                            --ok-label "确认" \
                            --msgbox "kohya_ss 非 Git 安装, 无法切换版本" \
                            $(get_dialog_size)
                    fi
                    ;;
                5)
                    if is_git_repo; then
                        if (dialog --erase-on-exit \
                            --title "kohya_ss 管理" \
                            --backtitle "kohya_ss 更新源切换选项" \
                            --yes-label "是" --no-label "否" \
                            --yesno "是否切换 kohya_ss 更新源 ?" \
                            $(get_dialog_size)); then

                            kohya_ss_remote_revise
                        fi
                    else
                        dialog --erase-on-exit \
                            --title "kohya_ss 管理" \
                            --backtitle "kohya_ss 更新源切换选项" \
                            --ok-label "确认" \
                            --msgbox "kohya_ss 非 Git 安装, 无法切换更新源" \
                            $(get_dialog_size)
                    fi
                    ;;
                
                6)
                    if (dialog --erase-on-exit \
                        --title "kohya_ss 管理" \
                        --backtitle "kohya_ss 依赖更新选项" \
                        --yes-label "是" --no-label "否" \
                        --yesno "是否更新 kohya_ss 的依赖 ?" \
                        $(get_dialog_size)); then

                        kohya_ss_update_depend
                    fi
                    ;;
                7)
                    if (dialog --erase-on-exit \
                        --title "kohya_ss 管理" \
                        --backtitle "kohya_ss 的 Python 软件包安装 / 重装 / 卸载选项" \
                        --yes-label "是" --no-label "否" \
                        --yesno "是否进入 Python 软件包安装 / 重装 / 卸载选项 ?" \
                        $(get_dialog_size)); then

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
                    if is_use_venv; then
                        if (dialog --erase-on-exit \
                            --title "kohya_ss 管理" \
                            --backtitle "kohya_ss 虚拟环境修复选项" \
                            --yes-label "是" --no-label "否" \
                            --yesno "是否修复 kohya_ss 的虚拟环境 ?" \
                            $(get_dialog_size)); then

                            fix_venv
                            dialog --erase-on-exit \
                                --title "kohya_ss 管理" \
                                --backtitle "kohya_ss 虚拟环境修复选项" \
                                --ok-label "确认" \
                                --msgbox "kohya_ss 虚拟环境修复完成" \
                                $(get_dialog_size)
                        fi
                    else
                        dialog --erase-on-exit \
                            --title "kohya_ss 管理" \
                            --backtitle "kohya_ss 虚拟环境修复选项" \
                            --ok-label "确认" \
                            --msgbox "虚拟环境功能已禁用, 无法使用该功能" \
                            $(get_dialog_size)
                    fi
                    ;;
                11)
                    if is_use_venv; then
                        if (dialog --erase-on-exit \
                            --title "kohya_ss 管理" \
                            --backtitle "kohya_ss 虚拟环境重建选项" \
                            --yes-label "是" --no-label "否" \
                            --yesno "是否重建 kohya_ss 的虚拟环境 ?" \
                            $(get_dialog_size)); then

                            kohya_ss_venv_rebuild
                            dialog --erase-on-exit \
                                --title "kohya_ss 管理" \
                                --backtitle "kohya_ss 虚拟环境重建选项" \
                                --ok-label "确认" \
                                --msgbox "kohya_ss 虚拟环境重建完成" \
                                $(get_dialog_size)
                        fi
                    else
                        dialog --erase-on-exit \
                            --title "kohya_ss 管理" \
                            --backtitle "kohya_ss 虚拟环境重建选项" \
                            --ok-label "确认" \
                            --msgbox "虚拟环境功能已禁用, 无法使用该功能" \
                            $(get_dialog_size)
                    fi
                    ;;
                12)
                    if (dialog --erase-on-exit \
                        --title "kohya_ss 管理" \
                        --backtitle "kohya_ss 后端组件重装选项" \
                        --yes-label "是" --no-label "否" \
                        --yesno "是否重新安装 kohya_ss 后端组件 ?" \
                        $(get_dialog_size)); then

                        kohya_ss_backend_repo_reinstall
                    fi
                    ;;
                13)
                    if (dialog --erase-on-exit \
                        --title "kohya_ss 管理" \
                        --backtitle "kohya_ss 重新安装选项" \
                        --yes-label "是" --no-label "否" \
                        --yesno "是否重新安装 kohya_ss ?" \
                        $(get_dialog_size)); then

                        cd "${START_PATH}"
                        rm -f "${START_PATH}/term-sd/task/kohya_ss_install.sh"
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
                        $(get_dialog_size)); then

                        term_sd_echo "请再次确认是否删除 kohya_ss (yes/no) ?"
                        term_sd_echo "警告: 该操作将永久删除 kohya_ss"
                        term_sd_echo "提示: 输入 yes 或 no 后回车"
                        case "$(term_sd_read)" in
                            yes|y|YES|Y)
                                term_sd_echo "删除 kohya_ss 中"
                                exit_venv
                                cd ..
                                rm -rf "${KOHYA_SS_ROOT_PATH}"

                                dialog --erase-on-exit \
                                    --title "kohya_ss 管理" \
                                    --backtitle "kohya_ss 删除选项" \
                                    --ok-label "确认" \
                                    --msgbox "删除 kohya_ss 完成" \
                                    $(get_dialog_size)

                                break
                                ;;
                            *)
                                term_sd_echo "取消删除 kohya_ss 操作"
                                ;;
                        esac
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
            --yesno "检测到当前未安装 kohya_ss , 是否进行安装 ?" \
            $(get_dialog_size)); then

            rm -f "${START_PATH}/term-sd/task/kohya_ss_install.sh"
            install_kohya_ss
        fi
    fi
}

# kohya_ss 依赖更新功能
kohya_ss_update_depend() {
    # 更新前的准备
    download_mirror_select # 下载镜像源选择
    pip_install_mode_select upgrade # 安装方式选择

    if term_sd_install_confirm "是否更新 kohya_ss 依赖 ?"; then
        term_sd_print_line "kohya_ss 依赖更新"
        term_sd_echo "更新 kohya_ss 依赖中"
        term_sd_tmp_disable_proxy
        enter_venv
        python_package_update "requirements.txt" # kohya_ss 依赖
        exit_venv
        term_sd_tmp_enable_proxy
        term_sd_echo "更新 kohya_ss 依赖结束"
        term_sd_pause
    fi
    clean_install_config # 清理安装参数
}

# 后端组件重装
kohya_ss_backend_repo_reinstall() {
    download_mirror_select # 下载镜像源选择

    if term_sd_install_confirm "是否重新安装 kohya_ss 后端组件 ?"; then
        term_sd_print_line "kohya_ss 后端组件重装"
        term_sd_echo "删除原有 kohya_ss 后端组件中"
        rm -rf "${KOHYA_SS_ROOT_PATH}"/sd-scripts
        term_sd_mkdir "${KOHYA_SS_ROOT_PATH}"/sd-scripts
        term_sd_echo "重新下载 kohya_ss 后端组件中"
        git_clone_repository https://github.com/kohya-ss/sd-scripts "${KOHYA_SS_ROOT_PATH}" sd-scripts # kohya_ss 后端
        git_init_submodule "${KOHYA_SS_ROOT_PATH}"
        term_sd_echo "重装 kohya_ss 后端组件结束"
        term_sd_pause
    fi
    clean_install_config # 清理安装参数
}
