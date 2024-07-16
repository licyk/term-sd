#!/bin/bash

# SD WebUI 管理
sd_webui_manager() {
    local dialog_arg
    local sd_webui_branch

    cd "${START_PATH}" # 回到最初路径
    exit_venv # 确保进行下一步操作前已退出其他虚拟环境

    if [[ -d "${SD_WEBUI_PATH}" ]] && ! term_sd_is_dir_empty "${SD_WEBUI_PATH}" ;then # 找到stable-diffusion-webui目录
        while true; do
            cd "${SD_WEBUI_PATH}"

            case $(git remote get-url origin | awk -F '/' '{print $NF}') in # 分支判断
                stable-diffusion-webui|stable-diffusion-webui.git)
                    sd_webui_branch="AUTOMATIC1111 webui $(git_branch_display)"
                    ;;
                automatic|automatic.git)
                    sd_webui_branch="vladmandic webui $(git_branch_display)"
                    ;;
                stable-diffusion-webui-directml|stable-diffusion-webui-directml.git)
                    sd_webui_branch="lshqqytiger webui $(git_branch_display)"
                    ;;
                stable-diffusion-webui-forge|stable-diffusion-webui-forge.git)
                    sd_webui_branch="lllyasviel webui $(git_branch_display)"
                    ;;
                *)
                    sd_webui_branch="null (Git文件损坏)"
            esac

            dialog_arg=$(dialog --erase-on-exit --notags \
                --title "Stable-Diffusion-WebUI 管理" \
                --backtitle "Stable-Diffusion-WebUI 管理选项" \
                --ok-label "确认" --cancel-label "取消" \
                --menu "请选择 Stable-Diffusion-WebUI 管理选项的功能\n当前更新源: $(git_remote_display)\n当前分支: ${sd_webui_branch}" \
                $(get_dialog_size_menu) \
                "0" "> 返回" \
                "1" "> 启动" \
                "2" "> 更新" \
                "3" "> 修复更新" \
                "4" "> 管理插件" \
                "5" "> 切换版本" \
                "6" "> 更新源替换" \
                "7" "> 分支切换" \
                "8" "> 更新依赖" \
                "9" "> Python 软件包安装 / 重装 / 卸载" \
                "10" "> 依赖库版本管理" \
                "11" "> 重新安装 PyTorch" \
                "12" "> 修复虚拟环境" \
                "13" "> 重新构建虚拟环境" \
                "14" "> 重新安装后端组件" \
                "15" "> 重新安装" \
                "16" "> 卸载" \
                3>&1 1>&2 2>&3)

            case "${dialog_arg}" in
                1)
                    sd_webui_launch
                    ;;
                2)
                    if is_git_repo; then
                        term_sd_echo "更新 Stable-Diffusion-WebUI 中"
                        git_pull_repository
                        if [[ "$?" == 0 ]]; then
                            dialog --erase-on-exit \
                                --title "Stable-Diffusion-WebUI 管理" \
                                --backtitle "Stable-Diffusion-WebUI 更新结果" \
                                --ok-label "确认" \
                                --msgbox "Stable-Diffusion-WebUI 更新成功" \
                                $(get_dialog_size)
                        else
                            dialog --erase-on-exit \
                                --title "Stable-Diffusion-WebUI 管理" \
                                --backtitle "Stable-Diffusion-WebUI 更新结果" \
                                --ok-label "确认" \
                                --msgbox "Stable-Diffusion-WebUI 更新失败" \
                                $(get_dialog_size)
                        fi
                    else
                        dialog --erase-on-exit \
                            --title "Stable-Diffusion-WebUI 管理" \
                            --backtitle "Stable-Diffusion-WebUI 更新结果" \
                            --ok-label "确认" \
                            --msgbox "Stable-Diffusion-WebUI 非 Git 安装, 无法更新" \
                            $(get_dialog_size)
                    fi
                    ;;
                3)
                    if is_git_repo; then
                        if (dialog --erase-on-exit \
                            --title "Stable-Diffusion-WebUI 管理" \
                            --backtitle "Stable-Diffusion-WebUI 更新修复选项" \
                            --yes-label "是" --no-label "否" \
                            --yesno "是否修复 Stable-Diffusion-Webui 更新 ?" \
                            $(get_dialog_size)); then

                            git_fix_pointer_offset
                            dialog --erase-on-exit \
                                --title "Stable-Diffusion-WebUI 管理" \
                                --backtitle "Stable-Diffusion-WebUI 更新修复选项" \
                                --ok-label "确认" \
                                --msgbox "Stable-Diffusion-WebUI 修复更新完成" \
                                $(get_dialog_size)
                        fi
                    else
                        dialog --erase-on-exit \
                            --title "Stable-Diffusion-WebUI 管理" \
                            --backtitle "Stable-Diffusion-WebUI 更新修复选项" \
                            --ok-label "确认" \
                            --msgbox "Stable-Diffusion-WebUI 非 Git 安装, 无法修复更新" \
                            $(get_dialog_size)
                    fi
                    ;;
                4)
                    sd_webui_extension_manager
                    ;;
                5)
                    if is_git_repo; then
                        if (dialog --erase-on-exit \
                            --title "Stable-Diffusion-WebUI 管理" \
                            --backtitle "Stable-Diffusion-WebUI 版本切换选项" \
                            --yes-label "是" --no-label "否" \
                            --yesno "是否切换 Stable-Diffusion-Webui 版本 ?" \
                            $(get_dialog_size)); then

                            git_ver_switch
                            dialog --erase-on-exit \
                                --title "Stable-Diffusion-WebUI 管理" \
                                --backtitle "Stable-Diffusion-WebUI 版本切换选项" \
                                --ok-label "确认" \
                                --msgbox "Stable-Diffusion-WebUI 版本切换完成, 当前版本为: $(git_branch_display)" \
                                $(get_dialog_size)
                        fi
                    else
                        dialog --erase-on-exit \
                            --title "Stable-Diffusion-WebUI 管理" \
                            --backtitle "Stable-Diffusion-WebUI 版本切换选项" \
                            --ok-label "确认" \
                            --msgbox "Stable-Diffusion-WebUI 非 Git 安装, 无法切换版本" \
                            $(get_dialog_size)
                    fi
                    ;;
                6)
                    if is_git_repo; then
                        if (dialog --erase-on-exit \
                            --title "Stable-Diffusion-WebUI 管理" \
                            --backtitle "Stable-Diffusion-WebUI 更新源切换选项" \
                            --yes-label "是" --no-label "否" \
                            --yesno "是否切换 Stable-Diffusion-WebUI 更新源 ?" \
                            $(get_dialog_size)); then

                            sd_webui_remote_revise
                        fi
                    else
                        dialog --erase-on-exit \
                            --title "Stable-Diffusion-WebUI 管理" \
                            --backtitle "Stable-Diffusion-WebUI 更新源切换选项" \
                            --ok-label "确认" \
                            --msgbox "Stable-Diffusion-WebUI 非 Git 安装, 无法切换更新源" \
                            $(get_dialog_size)
                    fi
                    ;;
                7)
                    if is_git_repo; then
                        if (dialog --erase-on-exit \
                            --title "Stable-Diffusion-WebUI 管理" \
                            --backtitle "Stable-Diffusion-WebUI 分支切换选项" \
                            --yes-label "是" --no-label "否" \
                            --yesno "是否切换 Stable-Diffusion-WebUI 分支 ?" \
                            $(get_dialog_size)); then

                            sd_webui_branch_switch
                        fi
                    else
                        dialog --erase-on-exit \
                            --title "Stable-Diffusion-WebUI 管理" \
                            --backtitle "Stable-Diffusion-WebUI 分支切换选项" \
                            --ok-label "确认" \
                            --msgbox "Stable-Diffusion-WebUI 非 Git 安装, 无法切换分支" \
                            $(get_dialog_size)
                    fi
                    ;;
                8)
                    if (dialog --erase-on-exit \
                        --title "Stable-Diffusion-WebUI 管理" \
                        --backtitle "Stable-Diffusion-WebUI 依赖更新选项" \
                        --yes-label "是" --no-label "否" \
                        --yesno "是否更新 Stable-Diffusion-WebUI 的依赖 ?" \
                        $(get_dialog_size)); then

                        sd_webui_update_depend
                    fi
                    ;;
                9)
                    if (dialog --erase-on-exit \
                        --title "Stable-Diffusion-WebUI 管理" \
                        --backtitle "Stable-Diffusion-WebUI 的 Python 软件包安装 / 重装 / 卸载选项" \
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
                            --title "Stable-Diffusion-WebUI 管理" \
                            --backtitle "Stable-Diffusion-WebUI 虚拟环境修复选项" \
                            --yes-label "是" --no-label "否" \
                            --yesno "是否修复 Stable-Diffusion-WebUI 的虚拟环境" \
                            $(get_dialog_size)); then

                            fix_venv
                        fi
                    else
                        dialog --erase-on-exit \
                            --title "Stable-Diffusion-WebUI 管理" \
                            --backtitle "Stable-Diffusion-WebUI 虚拟环境修复选项" \
                            --ok-label "确认" \
                            --msgbox "虚拟环境功能已禁用, 无法使用该功能" \
                            $(get_dialog_size)
                    fi
                    ;;
                13)
                    if is_use_venv; then
                        if (dialog --erase-on-exit \
                            --title "Stable-Diffusion-WebUI 管理" \
                            --backtitle "Stable-Diffusion-WebUI 虚拟环境重建选项" \
                            --yes-label "是" --no-label "否" \
                            --yesno "是否重建 Stable-Diffusion-WebUI 的虚拟环境 ?" \
                            $(get_dialog_size));then

                            sd_webui_venv_rebuild
                        fi
                    else
                        dialog --erase-on-exit \
                            --title "Stable-Diffusion-WebUI 管理" \
                            --backtitle "Stable-Diffusion-WebUI 虚拟环境重建选项" \
                            --ok-label "确认" \
                            --msgbox "虚拟环境功能已禁用, 无法使用该功能" \
                            $(get_dialog_size)
                    fi
                    ;;
                14) 
                    if (dialog --erase-on-exit \
                        --title "Stable-Diffusion-WebUI 管理" \
                        --backtitle "Stable-Diffusion-WebUI 后端组件重装选项" \
                        --yes-label "是" --no-label "否" \
                        --yesno "是否重新安装 Stable-Diffusion-WebUI 后端组件 ?" \
                        $(get_dialog_size)); then

                        sd_webui_backend_repo_reinstall
                    fi
                    ;;
                15)
                    if (dialog --erase-on-exit \
                        --title "Stable-Diffusion-WebUI 管理" \
                        --backtitle "Stable-Diffusion-WebUI 重新安装选项" \
                        --yes-label "是" --no-label "否" \
                        --yesno "是否重新安装 Stable-Diffusion-WebUI ?" \
                        $(get_dialog_size)); then

                        cd "${START_PATH}"
                        rm -f "${START_PATH}/term-sd/task/sd_webui_install.sh"
                        exit_venv
                        install_sd_webui
                        break
                    fi
                    ;;
                16)
                    if (dialog --erase-on-exit \
                        --title "Stable-Diffusion-WebUI 管理" \
                        --backtitle "Stable-Diffusion-WebUI 删除选项" \
                        --yes-label "是" --no-label "否" \
                        --yesno "是否删除 Stable-Diffusion-WebUI ?" \
                        $(get_dialog_size)); then

                        term_sd_echo "请再次确认是否删除 Stable-Diffusion-WebUI (yes/no) ?"
                        term_sd_echo "警告: 该操作将永久删除 Stable-Diffusion-WebUI"
                        term_sd_echo "提示: 输入 yes 或 no 后回车"
                        case "$(term_sd_read)" in
                            yes|y|YES|Y)
                                term_sd_echo "删除 Stable-Diffusion-WebUI 中"
                                exit_venv
                                cd ..
                                rm -rf "$SD_WEBUI_FOLDER"

                                dialog --erase-on-exit \
                                    --title "Stable-Diffusion-WebUI 管理" \
                                    --backtitle "Stable-Diffusion-WebUI 删除选项" \
                                    --ok-label "确认" \
                                    --msgbox "删除Stable-Diffusion-WebUI完成" \
                                    $(get_dialog_size)

                                break
                                ;;
                            *)
                                term_sd_echo "取消删除操作"
                                ;;
                        esac
                    fi
                    ;;
                *)
                    break
                    ;;
            esac
        done
    else #找不到stable-diffusion-webui目录
        if (dialog --erase-on-exit \
            --title "Stable-Diffusion-WebUI 管理" \
            --backtitle "Stable-Diffusion-WebUI 安装选项" \
            --yes-label "是" --no-label "否" \
            --yesno "检测到当前未安装 Stable-Diffusion-WebUI , 是否进行安装 ?" \
            $(get_dialog_size)); then

            install_sd_webui
        fi
    fi
}

# SD WebUI 依赖更新功能
sd_webui_update_depend() {
    # 更新前的准备
    download_mirror_select # 下载镜像源选择
    pip_install_mode_select # 安装方式选择

    if term_sd_install_confirm "是否更新 Stable-Diffusion-WebUI 依赖 ?"; then
        term_sd_print_line "Stable-Diffusion-WebUI 依赖更新"
        term_sd_echo "更新 Stable-Diffusion-WebUI 依赖中"
        term_sd_tmp_disable_proxy
        create_venv
        enter_venv
        python_package_update "requirements_versions.txt"
        install_python_package git+$(git_format_repository_url "${GITHUB_MIRROR}" https://github.com/openai/CLIP)
        exit_venv
        term_sd_tmp_enable_proxy
        term_sd_echo "更新 Stable-Diffusion-WebUI 依赖结束"
        term_sd_pause
    fi
    clean_install_config # 清理安装参数
}

# SD WebUI 后端组件重装
sd_webui_backend_repo_reinstall() {
    download_mirror_select # 下载镜像源选择

    if term_sd_install_confirm "是否重新安装 Stable-Diffusion-WebUI 后端组件 ?"; then
        term_sd_print_line "Stable-Diffusion-WebUI 后端组件重装"
        term_sd_echo "删除原有 Stable-Diffusion-WebUI 后端组件中"
        rm -rf repositories/*
        term_sd_echo "重新下载 Stable-Diffusion-WebUI 后端组件中"
        git_clone_repository https://github.com/sczhou/CodeFormer "${SD_WEBUI_PATH}"/repositories CodeFormer
        git_clone_repository https://github.com/salesforce/BLIP "${SD_WEBUI_PATH}"/repositories BLIP
        git_clone_repository https://github.com/Stability-AI/stablediffusion "${SD_WEBUI_PATH}"/repositories stable-diffusion-stability-ai
        git_clone_repository https://github.com/Stability-AI/generative-models "${SD_WEBUI_PATH}"/repositories generative-models
        git_clone_repository https://github.com/crowsonkb/k-diffusion "${SD_WEBUI_PATH}"/repositories k-diffusion
        git_clone_repository https://github.com/AUTOMATIC1111/stable-diffusion-webui-assets "${SD_WEBUI_PATH}"/repositories stable-diffusion-webui-assets
        term_sd_echo "重装 Stable-Diffusion-WebUI 后端组件结束"
        term_sd_pause
    fi
    clean_install_config # 清理安装参数
}
