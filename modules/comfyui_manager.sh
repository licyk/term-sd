#!/bin/bash

# ComfyUI 管理
comfyui_manager() {
    local dialog_arg

    cd "${START_PATH}" # 回到最初路径
    exit_venv # 确保进行下一步操作前已退出其他虚拟环境
    if [[ -d "${COMFYUI_PATH}" ]] && ! term_sd_is_dir_empty "${COMFYUI_PATH}"; then
        while true; do
            cd "${COMFYUI_PATH}"
            dialog_arg=$(dialog --erase-on-exit --notags \
                --title "ComfyUI 管理" \
                --backtitle "ComfyUI 管理选项" \
                --ok-label "确认" --cancel-label "取消" \
                --menu "请选择 ComfyUI 管理选项的功能\n当前更新源: $(git_remote_display)\n当前分支: $(git_branch_display)" \
                $(get_dialog_size_menu) \
                "0" "> 返回" \
                "1" "> 启动" \
                "2" "> 更新" \
                "3" "> 修复更新" \
                "4" "> 管理自定义节点" \
                "5" "> 管理插件" \
                "6" "> 切换版本" \
                "7" "> 更新源替换" \
                "8" "> 更新依赖" \
                "9" "> Python 软件包安装 / 重装 / 卸载" \
                "10" "> 依赖库版本管理" \
                "11" "> 重新安装 PyTorch" \
                "12" "> 修复虚拟环境" \
                "13" "> 重新构建虚拟环境" \
                "14" "> 重新安装" \
                "15" "> 卸载" \
                3>&1 1>&2 2>&3)

            case "${dialog_arg}" in
                1)
                    comfyui_launch
                    ;;
                2)
                    if is_git_repo; then
                        term_sd_echo "更新 ComfyUI 中"
                        git_pull_repository
                        if [[ "$?" == 0 ]]; then
                            dialog --erase-on-exit \
                                --title "ComfyUI 管理" \
                                --backtitle "ComfyUI 更新结果" \
                                --ok-label "确认" \
                                --msgbox "ComfyUI 更新成功" \
                                $(get_dialog_size)
                        else
                            dialog --erase-on-exit \
                                --title "ComfyUI 管理" \
                                --backtitle "ComfyUI 更新结果" \
                                --ok-label "确认" \
                                --msgbox "ComfyUI 更新失败" \
                                $(get_dialog_size)
                        fi
                    else
                        dialog --erase-on-exit \
                            --title "ComfyUI 管理" \
                            --backtitle "ComfyUI 更新结果" \
                            --ok-label "确认" \
                            --msgbox "ComfyUI 非 Git 安装, 无法更新" \
                            $(get_dialog_size)
                    fi
                    ;;
                3)
                    if is_git_repo; then
                        if (dialog --erase-on-exit \
                            --title "ComfyUI 管理" \
                            --backtitle "ComfyUI 更新修复选项" \
                            --yes-label "是" --no-label "否" \
                            --yesno "是否修复 ComfyUI 更新 ?" \
                            $(get_dialog_size)); then

                            git_fix_pointer_offset
                            dialog --erase-on-exit \
                                --title "ComfyUI 管理" \
                                --backtitle "ComfyUI 修复更新" \
                                --ok-label "确认" \
                                --msgbox "ComfyUI 修复更新完成" \
                                $(get_dialog_size)
                        fi
                    else
                        dialog --erase-on-exit \
                            --title "ComfyUI 管理" \
                            --backtitle "ComfyUI 更新修复选项" \
                            --ok-label "确认" \
                            --msgbox "ComfyUI 非 Git 安装, 无法修复更新" \
                            $(get_dialog_size)
                    fi
                    ;;
                4)
                    comfyui_custom_node_manager
                    ;;
                5)
                    comfyui_extension_manager
                    ;;
                6)
                    if is_git_repo; then
                        if (dialog --erase-on-exit \
                            --title "ComfyUI 管理" \
                            --backtitle "ComfyUI 版本切换选项" \
                            --yes-label "是" --no-label "否" \
                            --yesno "是否切换 ComfyUI 版本 ?" \
                            $(get_dialog_size)); then

                            git_ver_switch && \
                            dialog --erase-on-exit \
                                --title "ComfyUI 管理" \
                                --backtitle "ComfyUI 版本切换" \
                                --ok-label "确认" \
                                --msgbox "ComfyUI 版本切换完成, 当前版本为: $(git_branch_display)" \
                                $(get_dialog_size)
                        fi
                    else
                        dialog --erase-on-exit \
                            --title "ComfyUI 管理" \
                            --backtitle "ComfyUI 版本切换选项" \
                            --ok-label "确认" \
                            --msgbox "ComfyUI 非 Git 安装, 无法切换版本" \
                            $(get_dialog_size)
                    fi
                    ;;
                7)
                    if is_git_repo; then
                        if (dialog --erase-on-exit \
                            --title "ComfyUI 管理" \
                            --backtitle "ComfyUI 更新源切换选项" \
                            --yes-label "是" --no-label "否" \
                            --yesno "是否切换 ComfyUI 更新源 ?" \
                            $(get_dialog_size)); then

                            comfyui_remote_revise
                        fi
                    else
                        dialog --erase-on-exit \
                            --title "ComfyUI 管理" \
                            --backtitle "ComfyUI 更新源切换选项" \
                            --ok-label "确认" \
                            --msgbox "ComfyUI 非 Git 安装, 无法切换更新源" \
                            $(get_dialog_size)
                    fi
                    ;;
                
                8)
                    if (dialog --erase-on-exit \
                        --title "ComfyUI 管理" \
                        --backtitle "ComfyUI 依赖更新选项" \
                        --yes-label "是" --no-label "否" \
                        --yesno "是否更新 ComfyUI 的依赖 ?" \
                        $(get_dialog_size)); then

                        comfyui_update_depend
                    fi
                    ;;
                9)
                    if (dialog --erase-on-exit \
                        --title "ComfyUI 管理" \
                        --backtitle "ComfyUI 的 Python 软件包安装 / 重装 / 卸载选项" \
                        --yes-label "是" --no-label "否" \
                        --yesno "是否进入 Python 软件包安装 / 重装 / 卸载选项 ?" \
                        $(get_dialog_size)); then

                        python_package_manager
                    fi
                    ;;
                10)
                    python_package_ver_backup_manager
                    ;;
                11)
                    pytorch_reinstall
                    ;;
                12)
                    if is_use_venv; then
                        if (dialog --erase-on-exit \
                            --title "ComfyUI 管理" \
                            --backtitle "ComfyUI 虚拟环境修复选项" \
                            --yes-label "是" --no-label "否" \
                            --yesno "是否修复 ComfyUI 的虚拟环境 ? " \
                            $(get_dialog_size)); then

                            fix_venv
                            dialog --erase-on-exit \
                                --title "ComfyUI 管理" \
                                --backtitle "ComfyUI 虚拟环境修复选项" \
                                --ok-label "确认" \
                                --msgbox "ComfyUI 虚拟环境修复完成" \
                                $(get_dialog_size)
                        fi
                    else
                        dialog --erase-on-exit \
                            --title "ComfyUI 管理" \
                            --backtitle "ComfyUI 虚拟环境修复选项" \
                            --ok-label "确认" \
                            --msgbox "虚拟环境功能已禁用, 无法使用该功能" \
                            $(get_dialog_size)
                    fi
                    ;;
                13)
                    if is_use_venv; then
                        if (dialog --erase-on-exit \
                            --title "ComfyUI 管理" \
                            --backtitle "ComfyUI 虚拟环境重建选项" \
                            --yes-label "是" --no-label "否" \
                            --yesno "是否重建 ComfyUI 的虚拟环境 ?" \
                            $(get_dialog_size)); then

                            comfyui_venv_rebuild
                            dialog --erase-on-exit \
                                --title "ComfyUI 管理" \
                                --backtitle "ComfyUI 虚拟环境重建选项" \
                                --ok-label "确认" \
                                --msgbox "ComfyUI 虚拟环境重建完成" \
                                $(get_dialog_size)
                        fi
                    else
                        dialog --erase-on-exit \
                            --title "ComfyUI 管理" \
                            --backtitle "ComfyUI 虚拟环境重建选项" \
                            --ok-label "确认" \
                            --msgbox "虚拟环境功能已禁用, 无法使用该功能" \
                            $(get_dialog_size)
                    fi
                    ;;
                14)
                    if (dialog --erase-on-exit \
                        --title "ComfyUI 管理" \
                        --backtitle "ComfyUI 重新安装选项" \
                        --yes-label "是" --no-label "否" \
                        --yesno "是否重新安装 ComfyUI ?" \
                        $(get_dialog_size)); then

                        cd "${START_PATH}"
                        rm -f "${START_PATH}/term-sd/task/comfyui_install.sh"
                        exit_venv
                        install_comfyui
                        break
                    fi
                    ;;
                15)
                    if (dialog --erase-on-exit \
                        --title "ComfyUI 管理" \
                        --backtitle "ComfyUI 删除选项" \
                        --yes-label "是" --no-label "否" \
                        --yesno "是否删除 ComfyUI ?" \
                        $(get_dialog_size)); then

                        term_sd_echo "请再次确认是否删除 ComfyUI (yes/no) ?"
                        term_sd_echo "警告: 该操作将永久删除 ComfyUI"
                        term_sd_echo "提示: 输入 yes 或 no 后回车"
                        case "$(term_sd_read)" in
                            yes|y|YES|Y)
                                term_sd_echo "删除 ComfyUI 中"
                                exit_venv
                                cd ..
                                rm -rf "${COMFYUI_FOLDER}"

                                dialog --erase-on-exit \
                                    --title "ComfyUI 管理" \
                                    --backtitle "ComfyUI 删除选项" \
                                    --ok-label "确认" \
                                    --msgbox "删除 ComfyUI 完成" \
                                    $(get_dialog_size)
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
            --title "ComfyUI 管理" \
            --backtitle "ComfyUI 安装选项" \
            --yes-label "是" --no-label "否" \
            --yesno "检测到当前未安装 ComfyUI , 是否进行安装 ?" \
            $(get_dialog_size)); then

            rm -f "${START_PATH}/term-sd/task/comfyui_install.sh"
            install_comfyui
        fi
    fi
}

# ComfyUI 依赖更新功能
# 解决 ComfyUI 部分依赖过旧导致报错的问题
comfyui_update_depend() {
    # 更新前的准备
    download_mirror_select # 下载镜像源选择
    pip_install_mode_select upgrade # 安装方式选择

    if term_sd_install_confirm "是否更新 ComfyUI 依赖 ?"; then
        term_sd_print_line "ComfyUI 依赖更新"
        term_sd_echo "更新 ComfyUI 依赖中"
        term_sd_tmp_disable_proxy
        enter_venv
        python_package_update "requirements.txt"
        exit_venv
        term_sd_tmp_enable_proxy
        term_sd_echo "更新 ComfyUI 依赖结束"
        term_sd_pause
    else
        term_sd_echo "取消更新 ComfyUI 依赖"
    fi
    clean_install_config # 清理安装参数
}
