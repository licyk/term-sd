#!/bin/bash

#a1111_sd_webui_option选项
function a1111_sd_webui_option()
{
    export term_sd_manager_info="stable-diffusion-webui"
    cd "$start_path" #回到最初路径
    exit_venv #确保进行下一步操作前已退出其他虚拟环境
    if [ -d "stable-diffusion-webui" ];then #找到stable-diffusion-webui目录
        cd stable-diffusion-webui

        case $(git remote -v | awk 'NR==1 {print $2}' | awk -F'/' '{print $NF}') in #分支判断
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

        a1111_sd_webui_option_dialog=$(
            dialog --clear --title "A1111-SD-Webui管理" --backtitle "A1111-SD-Webui管理选项" --ok-label "确认" --cancel-label "取消" --menu "请选择A1111-SD-Webui管理选项的功能\n当前更新源:$(git remote -v | awk 'NR==1 {print $2}')\n当前分支:$sd_webui_branch_info" 25 80 10 \
            "1" "更新" \
            "2" "卸载" \
            "3" "修复更新" \
            "4" "管理插件" \
            "5" "切换版本" \
            "6" "更新源替换" \
            "7" "分支切换" \
            "8" "启动" \
            "9" "更新依赖" \
            "10" "重新安装" \
            "11" "重新安装pytorch" \
            "12" "python软件包安装/重装/卸载" \
            "13" "依赖库版本管理" \
            $dialog_recreate_venv_button \
            $dialog_rebuild_venv_button \
            "20" "返回" \
            3>&1 1>&2 2>&3)

        if [ $? = 0 ];then
            case $a1111_sd_webui_option_dialog in
                1)
                    term_sd_notice "更新A1111-Stable-Diffusion-Webui中"
                    git pull
                    if [ $? = 0 ];then
                        dialog --clear --title "A1111-SD-Webui管理" --backtitle "A1111-SD-Webui更新结果" --ok-label "确认" --msgbox "A1111-SD-Webui更新成功" 25 80
                    else
                        dialog --clear --title "A1111-SD-Webui管理" --backtitle "A1111-SD-Webui更新结果" --ok-label "确认" --msgbox "A1111-SD-Webui更新失败" 25 80
                    fi
                    a1111_sd_webui_option
                    ;;
                2)
                    if (dialog --clear --title "A1111-SD-Webui管理" --backtitle "A1111-SD-Webui删除选项" --yes-label "是" --no-label "否" --yesno "是否删除A1111-Stable-Diffusion-Webui?" 25 80) then
                        term_sd_notice "删除A1111-Stable-Diffusion-Webui中"
                        exit_venv
                        cd ..
                        rm -rf ./stable-diffusion-webui
                    else
                        a1111_sd_webui_option
                    fi
                    ;;
                3)
                    term_sd_fix_pointer_offset
                    a1111_sd_webui_option
                    ;;
                4)
                    a1111_sd_webui_extension_methon
                    a1111_sd_webui_option
                    ;;
                5)
                    git_checkout_manager
                    a1111_sd_webui_option
                    ;;
                6)
                    a1111_sd_webui_change_repo
                    a1111_sd_webui_option
                    ;;
                7)
                    if (dialog --clear --title "A1111-SD-Webui管理" --backtitle "A1111-SD-Webui分支切换选项" --yes-label "是" --no-label "否" --yesno "是否切换Stable-Diffusion-Webui分支?" 25 80) then
                        sd_webui_branch_switch
                    fi
                    a1111_sd_webui_option
                    ;;
                8)
                    if [ ! -f "./term-sd-launch.conf" ]; then #找不到启动配置时默认生成一个
                        term_sd_notice "未找到启动配置文件,创建中"
                        echo "launch.py --theme dark --autolaunch --xformers" > term-sd-launch.conf
                    fi
                    sd_webui_launch
                    a1111_sd_webui_option
                    ;;
                9)
                    a1111_sd_webui_update_depend
                    a1111_sd_webui_option
                    ;;
                10)
                    if (dialog --clear --title "A1111-SD-Webui管理" --backtitle "A1111-SD-Webui重新安装选项" --yes-label "是" --no-label "否" --yesno "是否重新安装A1111-Stable-Diffusion-Webui?" 25 80) then
                        cd "$start_path"
                        exit_venv
                        process_install_a1111_sd_webui
                    else
                        a1111_sd_webui_option
                    fi
                    ;;
                11)
                    pytorch_reinstall
                    a1111_sd_webui_option
                    ;;
                12)
                    manage_python_packages
                    a1111_sd_webui_option
                    ;;
                13)
                    python_package_ver_backup_or_restore
                    a1111_sd_webui_option
                    ;;
                18)
                    if (dialog --clear --title "A1111-SD-Webui管理" --backtitle "A1111-SD-Webui虚拟环境修复选项" --yes-label "是" --no-label "否" --yesno "是否修复A1111-SD-Webui的虚拟环境" 25 80);then
                        create_venv --fix
                    fi
                    a1111_sd_webui_option
                    ;;
                19)
                    if (dialog --clear --title "A1111-SD-Webui管理" --backtitle "A1111-SD-Webui虚拟环境重建选项" --yes-label "是" --no-label "否" --yesno "是否重建A1111-SD-Webui的虚拟环境" 25 80);then
                        a1111_sd_webui_venv_rebuild
                    fi
                    a1111_sd_webui_option
                    ;;
            esac
        fi
    else #找不到stable-diffusion-webui目录
        if (dialog --clear --title "A1111-SD-Webui管理" --backtitle "A1111-SD-Webui安装选项" --yes-label "是" --no-label "否" --yesno "检测到当前未安装A1111-Stable-Diffusion-Webui,是否进行安装?" 25 80) then
            process_install_a1111_sd_webui
        fi
    fi
}

#a1111-sd-webui依赖更新功能
function a1111_sd_webui_update_depend()
{
    if (dialog --clear --title "A1111-SD-Webui管理" --backtitle "A1111-SD-Webui依赖更新选项" --yes-label "是" --no-label "否" --yesno "是否更新A1111-Stable-Diffusion-Webui的依赖?" 25 80);then
        #更新前的准备
        proxy_option #代理选择
        pip_install_methon #安装方式选择
        final_install_check #安装前确认

        if [ $final_install_check_exec = 0 ];then
            print_line_to_shell "A1111-SD-Webui依赖更新"
            term_sd_notice "更新A1111-SD-Webui依赖中"
            tmp_disable_proxy
            create_venv
            enter_venv
            requirements_python_package_update "./repositories/CodeFormer/requirements.txt"
            requirements_python_package_update "./requirements.txt"
            pip_cmd install git+"$github_proxy"https://github.com/openai/CLIP --prefer-binary $pip_index_mirror $pip_extra_index_mirror $pip_find_mirror $force_pip $pip_install_methon_select --default-timeout=100 --retries 5
            exit_venv
            tmp_enable_proxy
            term_sd_notice "更新A1111-SD-Webui依赖结束"
            print_line_to_shell
        fi
    fi
}
