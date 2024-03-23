#!/bin/bash

# sd_webui_manager选项
sd_webui_manager()
{
    local sd_webui_manager_dialog
    local sd_webui_branch_info
    export term_sd_manager_info="stable-diffusion-webui"
    cd "$start_path" # 回到最初路径
    exit_venv # 确保进行下一步操作前已退出其他虚拟环境

    if [ -d "$sd_webui_path" ] && [ $(term_sd_test_empty_dir "$sd_webui_path") = 1 ];then # 找到stable-diffusion-webui目录
        while true
        do
            cd "$sd_webui_path"

            case $(git remote -v | awk 'NR==1 {print $2}' | awk -F'/' '{print $NF}') in # 分支判断
                stable-diffusion-webui|stable-diffusion-webui.git)
                    sd_webui_branch_info="AUTOMATIC1111 webui $(git_branch_display)"
                    ;;
                automatic|automatic.git)
                    sd_webui_branch_info="vladmandic webui $(git_branch_display)"
                    ;;
                stable-diffusion-webui-directml|stable-diffusion-webui-directml.git)
                    sd_webui_branch_info="lshqqytiger webui $(git_branch_display)"
                    ;;
                stable-diffusion-webui-forge|stable-diffusion-webui-forge.git)
                    sd_webui_branch_info="lllyasviel webui $(git_branch_display)"
                    ;;
                *)
                    sd_webui_branch_info="null (Git文件损坏)"
            esac

            sd_webui_manager_dialog=$(dialog --erase-on-exit --notags \
                --title "Stable-Diffusion-WebUI 管理" \
                --backtitle "Stable-Diffusion-WebUI 管理选项" \
                --ok-label "确认" --cancel-label "取消" \
                --menu "请选择 Stable-Diffusion-WebUI 管理选项的功能\n当前更新源: $(git_remote_display)\n当前分支: $sd_webui_branch_info" \
                $term_sd_dialog_height $term_sd_dialog_width $term_sd_dialog_menu_height \
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

            case $sd_webui_manager_dialog in
                1)
                    sd_webui_launch
                    ;;
                2)
                    term_sd_echo "更新 Stable-Diffusion-WebUI 中"
                    git_pull_repository
                    case $? in
                        0)
                            dialog --erase-on-exit \
                                --title "Stable-Diffusion-WebUI 管理" \
                                --backtitle "Stable-Diffusion-WebUI 更新结果" \
                                --ok-label "确认" \
                                --msgbox "Stable-Diffusion-WebUI 更新成功" \
                                $term_sd_dialog_height $term_sd_dialog_width
                            ;;
                        10)
                            dialog --erase-on-exit \
                                --title "Stable-Diffusion-WebUI 管理" \
                                --backtitle "Stable-Diffusion-WebUI 更新结果" \
                                --ok-label "确认" \
                                --msgbox "Stable-Diffusion-WebUI 非 Git 安装, 无法更新" \
                                $term_sd_dialog_height $term_sd_dialog_width
                            ;;
                        *)
                            dialog --erase-on-exit \
                                --title "Stable-Diffusion-WebUI 管理" \
                                --backtitle "Stable-Diffusion-WebUI 更新结果" \
                                --ok-label "确认" \
                                --msgbox "Stable-Diffusion-WebUI 更新失败" \
                                $term_sd_dialog_height $term_sd_dialog_width
                            ;;
                    esac
                    ;;
                3)
                    if (dialog --erase-on-exit \
                        --title "Stable-Diffusion-WebUI 管理" \
                        --backtitle "Stable-Diffusion-WebUI 更新修复选项" \
                        --yes-label "是" --no-label "否" \
                        --yesno "是否修复 Stable-Diffusion-Webui 更新?" \
                        $term_sd_dialog_height $term_sd_dialog_width) then

                        git_fix_pointer_offset
                    fi
                    ;;
                4)
                    sd_webui_extension_manager
                    ;;
                5)
                    git_ver_switch
                    ;;
                6)
                    if (dialog --erase-on-exit \
                        --title "Stable-Diffusion-WebUI 管理" \
                        --backtitle "Stable-Diffusion-WebUI 更新源切换选项" \
                        --yes-label "是" --no-label "否" \
                        --yesno "是否切换 Stable-Diffusion-WebUI 更新源?" \
                        $term_sd_dialog_height $term_sd_dialog_width) then

                        sd_webui_remote_revise
                    fi
                    ;;
                7)
                    if (dialog --erase-on-exit \
                        --title "Stable-Diffusion-WebUI 管理" \
                        --backtitle "Stable-Diffusion-WebUI 分支切换选项" \
                        --yes-label "是" --no-label "否" \
                        --yesno "是否切换 Stable-Diffusion-WebUI分支?" \
                        $term_sd_dialog_height $term_sd_dialog_width) then

                        sd_webui_branch_switch
                    fi
                    ;;
                8)
                    sd_webui_update_depend
                    ;;
                9)
                    if (dialog --erase-on-exit \
                        --title "Stable-Diffusion-WebUI 管理" \
                        --backtitle "Stable-Diffusion-WebUI 的 Python 软件包安装 / 重装 / 卸载选项" \
                        --yes-label "是" --no-label "否" \
                        --yesno "是否进入 Python 软件包安装 / 重装 / 卸载选项?" \
                        $term_sd_dialog_height $term_sd_dialog_width) then

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
                    if [ $venv_setup_status = 0 ];then
                        if (dialog --erase-on-exit \
                            --title "Stable-Diffusion-WebUI 管理" \
                            --backtitle "Stable-Diffusion-WebUI 虚拟环境修复选项" \
                            --yes-label "是" --no-label "否" \
                            --yesno "是否修复 Stable-Diffusion-WebUI 的虚拟环境" \
                            $term_sd_dialog_height $term_sd_dialog_width) then

                            fix_venv
                        fi
                    else
                        dialog --erase-on-exit \
                            --title "Stable-Diffusion-WebUI 管理" \
                            --backtitle "Stable-Diffusion-WebUI 虚拟环境修复选项" \
                            --ok-label "确认" \
                            --msgbox "虚拟环境功能已禁用, 无法使用该功能" \
                            $term_sd_dialog_height $term_sd_dialog_width
                    fi
                    ;;
                13)
                    if [ $venv_setup_status = 0 ];then
                        if (dialog --erase-on-exit \
                            --title "Stable-Diffusion-WebUI 管理" \
                            --backtitle "Stable-Diffusion-WebUI 虚拟环境重建选项" \
                            --yes-label "是" --no-label "否" \
                            --yesno "是否重建 Stable-Diffusion-WebUI 的虚拟环境?" \
                            $term_sd_dialog_height $term_sd_dialog_width);then

                            sd_webui_venv_rebuild
                        fi
                    else
                        dialog --erase-on-exit \
                            --title "Stable-Diffusion-WebUI 管理" \
                            --backtitle "Stable-Diffusion-WebUI 虚拟环境重建选项" \
                            --ok-label "确认" \
                            --msgbox "虚拟环境功能已禁用, 无法使用该功能" \
                            $term_sd_dialog_height $term_sd_dialog_width
                    fi
                    ;;
                14)
                    sd_webui_backend_repo_reinstall
                    ;;
                15)
                    if (dialog --erase-on-exit \
                        --title "Stable-Diffusion-WebUI 管理" \
                        --backtitle "Stable-Diffusion-WebUI 重新安装选项" \
                        --yes-label "是" --no-label "否" \
                        --yesno "是否重新安装 Stable-Diffusion-WebUI ?" \
                        $term_sd_dialog_height $term_sd_dialog_width) then

                        cd "$start_path"
                        rm -f "$start_path/term-sd/task/sd_webui_install.sh"
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
                        $term_sd_dialog_height $term_sd_dialog_width) then

                        term_sd_echo "请再次确认是否删除 Stable-Diffusion-WebUI (yes/no)?"
                        term_sd_echo "警告: 该操作将永久删除 Stable-Diffusion-WebUI"
                        term_sd_echo "提示: 输入 yes 或 no 后回车"
                        case $(term_sd_read) in
                            yes|y|YES|Y)
                                term_sd_echo "删除 Stable-Diffusion-WebUI 中"
                                exit_venv
                                cd ..
                                rm -rf "$sd_webui_folder"

                                dialog --erase-on-exit \
                                    --title "Stable-Diffusion-WebUI 管理" \
                                    --backtitle "Stable-Diffusion-WebUI 删除选项" \
                                    --ok-label "确认" \
                                    --msgbox "删除Stable-Diffusion-WebUI完成" \
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
    else #找不到stable-diffusion-webui目录
        if (dialog --erase-on-exit \
            --title "Stable-Diffusion-WebUI 管理" \
            --backtitle "Stable-Diffusion-WebUI 安装选项" \
            --yes-label "是" --no-label "否" \
            --yesno "检测到当前未安装 Stable-Diffusion-WebUI , 是否进行安装?" \
            $term_sd_dialog_height $term_sd_dialog_width) then

            install_sd_webui
        fi
    fi
}

# Stable-Diffusion-WebUI依赖更新功能
sd_webui_update_depend()
{
    if (dialog --erase-on-exit \
        --title "Stable-Diffusion-WebUI 管理" \
        --backtitle "Stable-Diffusion-WebUI 依赖更新选项" \
        --yes-label "是" --no-label "否" \
        --yesno "是否更新 Stable-Diffusion-WebUI 的依赖?" \
        $term_sd_dialog_height $term_sd_dialog_width) then
        # 更新前的准备
        download_mirror_select # 下载镜像源选择
        pip_install_mode_select # 安装方式选择
        term_sd_install_confirm "是否更新 Stable-Diffusion-WebUI 依赖?" # 安装前确认

        if [ $? = 0 ];then
            term_sd_print_line "Stable-Diffusion-WebUI 依赖更新"
            term_sd_echo "更新 Stable-Diffusion-WebUI 依赖中"
            term_sd_tmp_disable_proxy
            create_venv
            enter_venv
            python_package_update "repositories/CodeFormer/requirements.txt"
            python_package_update "requirements.txt"
            term_sd_try term_sd_pip install git+$(git_format_repository_url $github_mirror https://github.com/openai/CLIP) --prefer-binary $pip_index_mirror $pip_extra_index_mirror $pip_find_mirror $pip_break_system_package $pip_install_mode
            exit_venv
            term_sd_tmp_enable_proxy
            term_sd_echo "更新 Stable-Diffusion-WebUI 依赖结束"
            term_sd_pause
        fi
    fi
}

# sd-webui后端组件重装
sd_webui_backend_repo_reinstall()
{
    if (dialog --erase-on-exit \
        --title "Stable-Diffusion-WebUI 管理" \
        --backtitle "Stable-Diffusion-WebUI 后端组件重装选项" \
        --yes-label "是" --no-label "否" \
        --yesno "是否重新安装 Stable-Diffusion-WebUI 后端组件?" \
        $term_sd_dialog_height $term_sd_dialog_width) then

        download_mirror_select # 下载镜像源选择
        term_sd_install_confirm "是否重新安装 Stable-Diffusion-WebUI 后端组件?" # 安装前确认

        if [ $? = 0 ];then
            term_sd_print_line "Stable-Diffusion-WebUI 后端组件重装"
            term_sd_echo "删除原有 Stable-Diffusion-WebUI 后端组件中"
            rm -rf repositories/*
            term_sd_echo "重新下载 Stable-Diffusion-WebUI 后端组件中"
            git_clone_repository ${github_mirror} https://github.com/sczhou/CodeFormer repositories CodeFormer
            git_clone_repository ${github_mirror} https://github.com/salesforce/BLIP repositories BLIP
            git_clone_repository ${github_mirror} https://github.com/Stability-AI/stablediffusion repositories stable-diffusion-stability-ai
            git_clone_repository ${github_mirror} https://github.com/Stability-AI/generative-models repositories generative-models
            git_clone_repository ${github_mirror} https://github.com/crowsonkb/k-diffusion repositories k-diffusion
            git_clone_repository ${github_mirror} https://github.com/AUTOMATIC1111/stable-diffusion-webui-assets repositories stable-diffusion-webui-assets
            term_sd_echo "重装 Stable-Diffusion-WebUI 后端组件结束"
            term_sd_pause
        fi
    fi
}