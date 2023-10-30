#!/bin/bash

#fooocus管理界面
function fooocus_option()
{
    export term_sd_manager_info="Fooocus"
    cd "$start_path" #回到最初路径
    exit_venv #确保进行下一步操作前已退出其他虚拟环境
    if [ -d "./Fooocus" ];then
        cd Fooocus
        fooocus_option_dialog=$(
            dialog --clear --title "Fooocus管理" --backtitle "Fooocus管理选项" --ok-label "确认" --cancel-label "取消" --menu "请选择Fooocus管理选项的功能\n当前更新源:$(git remote -v | awk 'NR==1 {print $2}')" 25 80 10 \
            "1" "更新" \
            "2" "卸载" \
            "3" "修复更新" \
            "4" "版本切换" \
            "5" "更新源切换" \
            "6" "启动" \
            "7" "更新依赖" \
            "8" "重新安装" \
            "9" "重新安装pytorch" \
            "10" "python软件包安装/重装/卸载" \
            "11" "依赖库版本管理" \
            $dialog_recreate_venv_button \
            $dialog_rebuild_venv_button \
            "20" "返回" \
            3>&1 1>&2 2>&3)

        if [ $? = 0 ];then
            case $fooocus_option_dialog in
                1)
                    term_sd_notice "更新Fooocus中"
                    test_num=1
                    git pull
                    if [ $? = 0 ];then
                        test_num=0
                    fi
                    cd ./repositories/ComfyUI-from-StabilityAI-Official
                    git pull --rebase
                    if [ $test_num = "0" ];then
                        dialog --clear --title "Fooocus管理" --backtitle "Fooocus更新结果" --ok-label "确认" --msgbox "Fooocus更新成功" 25 80
                    else
                        dialog --clear --title "Fooocus管理" --backtitle "Fooocus更新结果" --ok-label "确认" --msgbox "Fooocus更新失败" 25 80
                    fi
                    fooocus_option
                    ;;
                2)
                    if (dialog --clear --title "Fooocus管理" --backtitle "Fooocus删除选项" --yes-label "是" --no-label "否" --yesno "是否删除Fooocus?" 25 80) then
                        term_sd_notice "请再次确认是否删除Fooocus(yes/no)?"
                        term_sd_notice "警告:该操作将永久删除Fooocus"
                        term_sd_notice "提示:输入yes或no后回车"
                        term_sd_remove_repositore_option=""
                        read -p "===============================> " term_sd_remove_repositore_option
                        case $term_sd_remove_repositore_option in
                            yes|y|YES|Y)
                                term_sd_notice "删除Fooocus中"
                                exit_venv
                                cd ..
                                rm -rf ./Fooocus
                                ;;
                            *)
                                fooocus_option
                                ;;
                        esac
                    else
                        fooocus_option
                    fi
                    ;;
                3)
                    term_sd_fix_pointer_offset #修复Fooocus
                    cd ./repositories/ComfyUI-from-StabilityAI-Official
                    term_sd_fix_pointer_offset #修复Fooocus的核心ComfyUI
                    cd ../..
                    fooocus_option
                    ;;
                4)
                    git_checkout_manager
                    fooocus_option
                    ;;
                5)
                    fooocus_change_repo
                    fooocus_option
                    ;;
                6)
                    if [ ! -f "./term-sd-launch.conf" ]; then #找不到启动配置时默认生成一个
                        term_sd_notice "未找到启动配置文件,创建中"
                        echo "launch.py " > term-sd-launch.conf
                    fi
                    fooocus_launch
                    fooocus_option
                    ;;
                7)
                    fooocus_update_depend
                    fooocus_option
                    ;;
                8)
                    if (dialog --clear --title "Fooocus管理" --backtitle "Fooocus重新安装选项" --yes-label "是" --no-label "否" --yesno "是否重新安装Fooocus?" 25 80) then
                        cd "$start_path"
                        exit_venv
                        process_install_fooocus
                    else
                        fooocus_option
                    fi
                    ;;
                9)
                    pytorch_reinstall
                    fooocus_option
                    ;;
                10)
                    manage_python_packages
                    fooocus_option
                    ;;
                11)
                    python_package_ver_backup_or_restore
                    fooocus_option
                    ;;
                18)
                    if (dialog --clear --title "Fooocus管理" --backtitle "Fooocus虚拟环境修复选项" --yes-label "是" --no-label "否" --yesno "是否修复Fooocus的虚拟环境" 25 80);then
                        create_venv --fix
                    fi
                    fooocus_option
                    ;;
                19)
                    if (dialog --clear --title "Fooocus管理" --backtitle "Fooocus虚拟环境重建选项" --yes-label "是" --no-label "否" --yesno "是否重建Fooocus的虚拟环境" 25 80);then
                        fooocus_venv_rebuild
                    fi
                    fooocus_option
            esac
        fi
    else
        if (dialog --clear --title "Fooocus管理" --backtitle "Fooocus安装选项" --yes-label "是" --no-label "否" --yesno "检测到当前未安装Fooocus,是否进行安装?" 25 80) then
            process_install_fooocus
        fi
    fi
}

#fooocus依赖更新
function fooocus_update_depend()
{
    if (dialog --clear --title "Fooocus管理" --backtitle "Fooocus依赖更新选项" --yes-label "是" --no-label "否" --yesno "是否更新Fooocus的依赖?" 25 80);then
        #更新前的准备
        proxy_option #代理选择
        pip_install_methon #安装方式选择
        final_install_check #安装前确认

        if [ $final_install_check_exec = 0 ];then
            print_line_to_shell "Fooocus依赖更新"
            term_sd_notice "更新Fooocus依赖中"
            tmp_disable_proxy
            create_venv
            enter_venv
            requirements_python_package_update "./requirements_versions.txt"
            exit_venv
            tmp_enable_proxy
            term_sd_notice "更新Fooocus依赖结束"
            print_line_to_shell
        fi
    fi
}
