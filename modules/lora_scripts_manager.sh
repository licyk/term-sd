#!/bin/bash

#lora-scripts选项
function lora_scripts_option()
{
    export term_sd_manager_info="lora-scripts"
    cd "$start_path" #回到最初路径
    exit_venv #确保进行下一步操作前已退出其他虚拟环境
    if [ -d "./lora-scripts" ];then
        cd lora-scripts
        lora_scripts_option_dialog=$(
            dialog --clear --title "lora-scripts管理" --backtitle "lora-scripts管理选项" --ok-label "确认" --cancel-label "取消" --menu "请选择lora-scripts管理选项的功能\n当前更新源:$(git remote -v | awk 'NR==1 {print $2}')" 25 80 10 \
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
            case $lora_scripts_option_dialog in
                1)
                    term_sd_notice "更新lora-scripts中"
                    test_num=1
                    git pull
                    if [ $? = 0 ];then
                        test_num=0
                    fi
                    git pull ./sd-scripts
                    git pull ./frontend
                    git submodule init
                    git submodule update #版本不对应,有时会出现各种奇怪的报错
                    git submodule
                    if [ $test_num = "0" ];then
                        dialog --clear --title "lora-scripts管理" --backtitle "lora-scripts更新结果" --ok-label "确认" --msgbox "lora-scripts更新成功" 25 80
                    else
                        dialog --clear --title "lora-scripts管理" --backtitle "lora-scripts更新结果" --ok-label "确认" --msgbox "lora-scripts更新失败" 25 80
                    fi
                    lora_scripts_option
                    ;;
                2)
                    if (dialog --clear --title "lora-scripts管理" --backtitle "lora-scripts删除选项" --yes-label "是" --no-label "否" --yesno "是否删除lora-scripts?" 25 80) then
                        term_sd_notice "请再次确认是否删除lora-scripts(yes/no)?"
                        term_sd_notice "警告:该操作将永久删除lora-scripts"
                        term_sd_notice "提示:输入yes或no后回车"
                        term_sd_remove_repositore_option=""
                        read -p "===============================> " term_sd_remove_repositore_option
                        case $term_sd_remove_repositore_option in
                            yes|y|YES|Y)
                                term_sd_notice "删除lora-scripts中"
                                exit_venv
                                cd ..
                                rm -rf ./lora-scripts
                                ;;
                            *)
                                lora_scripts_option
                                ;;
                        esac
                    else
                        lora_scripts_option
                    fi
                    ;;
                3)
                    term_sd_fix_pointer_offset #修复lora-scripts
                    cd ./sd-scripts
                    term_sd_fix_pointer_offset #修复kohya-ss训练模块
                    cd ./../frontend
                    term_sd_fix_pointer_offset #修复lora-gui-dist
                    cd ..
                    git submodule init
                    git submodule update
                    git submodule
                    lora_scripts_option
                    ;;
                4)
                    git_checkout_manager
                    cd "$start_path/lora-scripts"
                    git submodule init
                    git submodule update
                    git submodule
                    lora_scripts_option
                    ;;
                5)
                    lora_scripts_change_repo
                    lora_scripts_option
                    ;;
                6)
                    print_line_to_shell "$term_sd_manager_info 启动"
                    enter_venv
                    export HF_HOME=huggingface
                    export PYTHONUTF8=1
                    python_cmd ./gui.py
                    print_line_to_shell
                    lora_scripts_option
                    ;;
                7)
                    lora_scripts_update_depend
                    lora_scripts_option
                    ;;
                8)
                    if (dialog --clear --title "lora-scripts管理" --backtitle "lora-scripts重新安装选项" --yes-label "是" --no-label "否" --yesno "是否重新安装lora-scripts?" 25 80) then
                        cd "$start_path"
                        exit_venv
                        process_install_lora_scripts
                    else
                        lora_scripts_option
                    fi
                    ;;
                9)
                    pytorch_reinstall
                    lora_scripts_option
                    ;;
                10)
                    manage_python_packages
                    lora_scripts_option
                    ;;
                11)
                    python_package_ver_backup_or_restore
                    lora_scripts_option
                    ;;
                18)
                    if (dialog --clear --title "lora-scripts管理" --backtitle "lora-scripts虚拟环境修复选项" --yes-label "是" --no-label "否" --yesno "是否修复lora-scripts的虚拟环境" 25 80);then
                        create_venv --fix
                    fi
                    lora_scripts_option
                    ;;
                19)
                    if (dialog --clear --title "lora-scripts管理" --backtitle "lora-scripts虚拟环境重建选项" --yes-label "是" --no-label "否" --yesno "是否重建lora-scripts的虚拟环境" 25 80);then
                        lora_scripts_venv_rebuild
                    fi
                    lora_scripts_option
                    ;;
            esac
        fi
    else
        if (dialog --clear --title "lora-scripts管理" --backtitle "lora-scripts安装选项" --yes-label "是" --no-label "否" --yesno "检测到当前未安装lora_scripts,是否进行安装?" 25 80) then
            process_install_lora_scripts
        fi
    fi
}

#lora-scripts依赖更新功能
function lora_scripts_update_depend()
{
    if (dialog --clear --title "lora-scripts管理" --backtitle "lora-scripts依赖更新选项" --yes-label "是" --no-label "否" --yesno "是否更新lora-scripts的依赖?" 25 80);then
        #更新前的准备
        proxy_option #代理选择
        pip_install_methon #安装方式选择
        final_install_check #安装前确认

        if [ $final_install_check_exec = 0 ];then
            print_line_to_shell "lora-scripts依赖更新"
            term_sd_notice "更新lora-scripts依赖中"
            tmp_disable_proxy
            create_venv
            enter_venv
            cd ./sd-scripts
            requirements_python_package_update "./requirements.txt" #sd-scripts目录下还有个_typos.toml，在安装requirements.txt里的依赖时会指向这个文件
            cd ..
            cmd_daemon pip_cmd install $pip_index_mirror $pip_extra_index_mirror $pip_find_mirror $force_pip $pip_install_methon_select --prefer-binary --upgrade lion-pytorch dadaptation prodigyopt lycoris-lora fastapi uvicorn wandb scipy --default-timeout=100 --retries 5
            requirements_python_package_update "./requirements.txt" #lora-scripts安装依赖
            exit_venv
            tmp_enable_proxy
            term_sd_notice "更新lora-scripts依赖结束"
            print_line_to_shell
        fi
    fi
}
