#!/bin/bash

# sd_webui_manager选项
sd_webui_manager()
{
    local sd_webui_manager_dialog
    export term_sd_manager_info="stable-diffusion-webui"
    cd "$start_path" # 回到最初路径
    exit_venv # 确保进行下一步操作前已退出其他虚拟环境

    if [ -d "stable-diffusion-webui" ];then # 找到stable-diffusion-webui目录
        cd stable-diffusion-webui

        case $(git remote -v | awk 'NR==1 {print $2}' | awk -F'/' '{print $NF}') in # 分支判断
            stable-diffusion-webui)
                sd_webui_branch_info="AUTOMATIC1111 webui"
                ;;
            automatic)
                sd_webui_branch_info="vladmandic webui"
                ;;
            stable-diffusion-webui-directml)
                sd_webui_branch_info="lshqqytiger webui"
                ;;
        esac

        sd_webui_manager_dialog=$(
            dialog --erase-on-exit --title "Stable-Diffusion-WebUI管理" --backtitle "Stable-Diffusion-WebUI管理选项" --ok-label "确认" --cancel-label "取消" --menu "请选择Stable-Diffusion-WebUI管理选项的功能\n当前更新源:$(git remote -v | awk 'NR==1 {print $2}')\n当前分支:$sd_webui_branch_info" 25 80 10 \
            "0" "返回" \
            "1" "启动" \
            "2" "更新" \
            "3" "修复更新" \
            "4" "管理插件" \
            "5" "切换版本" \
            "6" "更新源替换" \
            "7" "分支切换" \
            "8" "更新依赖" \
            "9" "python软件包安装/重装/卸载" \
            "10" "依赖库版本管理" \
            "11" "重新安装pytorch" \
            "12" "修复虚拟环境" \
            "13" "重新构建虚拟环境" \
            "14" "重新安装" \
            "15" "卸载" \
            3>&1 1>&2 2>&3)

        case $sd_webui_manager_dialog in
            1)
                sd_webui_launch
                sd_webui_manager
                ;;
            2)
                term_sd_echo "更新Stable-Diffusion-WebUI中"
                git_pull_repository
                case $? in
                    0)
                        dialog --erase-on-exit --title "Stable-Diffusion-WebUI管理" --backtitle "Stable-Diffusion-WebUI更新结果" --ok-label "确认" --msgbox "Stable-Diffusion-WebUI更新成功" 25 80
                        ;;
                    10)
                        dialog --erase-on-exit --title "Stable-Diffusion-WebUI管理" --backtitle "Stable-Diffusion-WebUI更新结果" --ok-label "确认" --msgbox "Stable-Diffusion-WebUI非git安装,无法更新" 25 80
                        ;;
                    *)
                        dialog --erase-on-exit --title "Stable-Diffusion-WebUI管理" --backtitle "Stable-Diffusion-WebUI更新结果" --ok-label "确认" --msgbox "Stable-Diffusion-WebUI更新失败" 25 80
                        ;;
                esac
                sd_webui_manager
                ;;
            3)
                git_fix_pointer_offset
                sd_webui_manager
                ;;
            4)
                sd_webui_extension_manager
                sd_webui_manager
                ;;
            5)
                git_ver_switch
                sd_webui_manager
                ;;
            6)
                sd_webui_remote_revise
                sd_webui_manager
                ;;
            7)
                if (dialog --erase-on-exit --title "Stable-Diffusion-WebUI管理" --backtitle "Stable-Diffusion-WebUI分支切换选项" --yes-label "是" --no-label "否" --yesno "是否切换Stable-Diffusion-Webui分支?" 25 80) then
                    sd_webui_branch_switch
                fi
                sd_webui_manager
                ;;
            8)
                sd_webui_update_depend
                sd_webui_manager
                ;;
            9)
                python_package_manager
                sd_webui_manager
                ;;
            10)
                python_package_ver_backup_manager
                sd_webui_manager
                ;;
            11)
                pytorch_reinstall
                sd_webui_manager
                ;;
            12)
                if [ $venv_setup_status = 0 ];then
                    if (dialog --erase-on-exit --title "Stable-Diffusion-WebUI管理" --backtitle "Stable-Diffusion-WebUI虚拟环境修复选项" --yes-label "是" --no-label "否" --yesno "是否修复Stable-Diffusion-WebUI的虚拟环境" 25 80);then
                        create_venv --fix
                    fi
                else
                    dialog --erase-on-exit --title "Stable-Diffusion-WebUI管理" --backtitle "Stable-Diffusion-WebUI虚拟环境修复选项" --ok-label "确认" --msgbox "虚拟环境功能已禁用,无法使用该功能" 25 80
                fi
                sd_webui_manager
                ;;
            13)
                if [ $venv_setup_status = 0 ];then
                    if (dialog --erase-on-exit --title "Stable-Diffusion-WebUI管理" --backtitle "Stable-Diffusion-WebUI虚拟环境重建选项" --yes-label "是" --no-label "否" --yesno "是否重建Stable-Diffusion-WebUI的虚拟环境" 25 80);then
                        sd_webui_venv_rebuild
                    fi
                else
                    dialog --erase-on-exit --title "Stable-Diffusion-WebUI管理" --backtitle "Stable-Diffusion-WebUI虚拟环境重建选项" --ok-label "确认" --msgbox "虚拟环境功能已禁用,无法使用该功能" 25 80
                fi
                sd_webui_manager
                ;;
            14)
                if (dialog --erase-on-exit --title "Stable-Diffusion-WebUI管理" --backtitle "Stable-Diffusion-WebUI重新安装选项" --yes-label "是" --no-label "否" --yesno "是否重新安装Stable-Diffusion-WebUI?" 25 80) then
                    cd "$start_path"
                    exit_venv
                    install_sd_webui
                else
                    sd_webui_manager
                fi
                ;;
            15)
                if (dialog --erase-on-exit --title "Stable-Diffusion-WebUI管理" --backtitle "Stable-Diffusion-WebUI删除选项" --yes-label "是" --no-label "否" --yesno "是否删除Stable-Diffusion-WebUI?" 25 80);then
                    term_sd_echo "请再次确认是否删除Stable-Diffusion-WebUI(yes/no)?"
                    term_sd_echo "警告:该操作将永久删除Stable-Diffusion-WebUI"
                    term_sd_echo "提示:输入yes或no后回车"
                    case $(term_sd_read) in
                        yes|y|YES|Y)
                            term_sd_echo "删除Stable-Diffusion-WebUI中"
                            exit_venv
                            cd ..
                            rm -rf ./stable-diffusion-webui
                            term_sd_echo "删除Stable-Diffusion-WebUI完成"
                            ;;
                        *)
                            term_sd_echo "取消删除操作"
                            sd_webui_manager
                            ;;
                    esac
                else
                    term_sd_echo "取消删除操作"
                    sd_webui_manager
                fi
                ;;
        esac
    else #找不到stable-diffusion-webui目录
        if (dialog --erase-on-exit --title "Stable-Diffusion-WebUI管理" --backtitle "Stable-Diffusion-WebUI安装选项" --yes-label "是" --no-label "否" --yesno "检测到当前未安装Stable-Diffusion-WebUI,是否进行安装?" 25 80) then
            install_sd_webui
        fi
    fi
}

# Stable-Diffusion-WebUI依赖更新功能
sd_webui_update_depend()
{
    if (dialog --erase-on-exit --title "Stable-Diffusion-WebUI管理" --backtitle "Stable-Diffusion-WebUI依赖更新选项" --yes-label "是" --no-label "否" --yesno "是否更新Stable-Diffusion-WebUI的依赖?" 25 80);then
        # 更新前的准备
        download_mirror_select # 下载镜像源选择
        pip_install_mode_select # 安装方式选择
        term_sd_install_confirm # 安装前确认

        if [ $? = 0 ];then
            term_sd_print_line "Stable-Diffusion-WebUI依赖更新"
            term_sd_echo "更新Stable-Diffusion-WebUI依赖中"
            term_sd_tmp_disable_proxy
            create_venv
            enter_venv
            python_package_update "./repositories/CodeFormer/requirements.txt"
            python_package_update "./requirements.txt"
            term_sd_watch term_sd_pip install git+"$github_proxy"https://github.com/openai/CLIP --prefer-binary $pip_index_mirror $pip_extra_index_mirror $pip_find_mirror $force_pip $pip_install_methon_select --default-timeout=100 --retries 5
            exit_venv
            term_sd_tmp_enable_proxy
            term_sd_echo "更新Stable-Diffusion-WebUI依赖结束"
            term_sd_print_line
        fi
    fi
}
