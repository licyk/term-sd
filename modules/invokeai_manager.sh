#!/bin/bash

#InvokeAI选项
function invokeai_option()
{
    export term_sd_manager_info="InvokeAI"
    cd "$start_path" #回到最初路径
    exit_venv #确保进行下一步操作前已退出其他虚拟环境
    if [ -d "InvokeAI" ];then #找到invokeai文件夹
        cd InvokeAI
        create_venv #尝试重新生成虚拟环境,解决因为路径移动导致虚拟环境无法进入,然后检测不到invokeai
        enter_venv #进入环境
        if which invokeai 2> /dev/null ;then #查找环境中有没有invokeai
            invokeai_option_dialog=$(
                dialog --erase-on-exit --title "InvokeAI管理" --backtitle "InvokeAI管理选项" --ok-label "确认" --cancel-label "取消" --menu "请选择InvokeAI管理选项的功能" 25 80 10 \
                "1" "更新" \
                "2" "卸载" \
                "3" "启动" \
                "4" "更新依赖" \
                "5" "重新安装" \
                "6" "重新安装pytorch" \
                "7" "python软件包安装/重装/卸载" \
                "8" "依赖库版本管理" \
                $dialog_recreate_venv_button \
                $dialog_rebuild_venv_button \
                "20" "返回" \
                3>&1 1>&2 2>&3)

            if [ $? = 0 ];then
                case $invokeai_option_dialog in
                    1)
                        proxy_option #代理选择
                        pip_install_methon #安装方式选择
                        final_install_check #安装前确认
                        if [ $final_install_check_exec = 0 ];then
                            term_sd_notice "更新InvokeAI中"
                            tmp_disable_proxy #临时取消代理,避免一些不必要的网络减速
                            pip_cmd install $pip_mirror $extra_pip_mirror $force_pip $pip_install_methon_select --prefer-binary --upgrade invokeai --default-timeout=100 --retries 5
                            if [ $? = 0 ];then
                                dialog --erase-on-exit --title "InvokeAI管理" --backtitle "InvokeAI更新结果" --ok-label "确认" --msgbox "InvokeAI更新成功" 25 80
                            else
                                dialog --erase-on-exit --title "InvokeAI管理" --backtitle "InvokeAI更新结果" --ok-label "确认" --msgbox "InvokeAI更新失败" 25 80
                            fi
                            tmp_enable_proxy #恢复原有的代理
                        fi
                        invokeai_option
                        ;;
                    2)
                        if (dialog --erase-on-exit --title "InvokeAI管理" --backtitle "InvokeAI删除选项" --yes-label "是" --no-label "否" --yesno "是否删除InvokeAI?" 25 80) then
                            term_sd_notice "请再次确认是否删除InvokeAI(yes/no)?"
                            term_sd_notice "警告:该操作将永久删除InvokeAI"
                            term_sd_notice "提示:输入yes或no后回车"
                            term_sd_remove_repository_option=""
                            read -p "===============================> " term_sd_remove_repository_option
                            case $term_sd_remove_repository_option in
                                yes|y|YES|Y)
                                    term_sd_notice "删除InvokeAI中"
                                    exit_venv
                                    cd ..
                                    rm -rf ./InvokeAI
                                    ;;
                                *)
                                    term_sd_notice "取消删除操作"
                                    invokeai_option
                                    ;;
                            esac
                        else
                            term_sd_notice "取消删除操作"
                            invokeai_option
                        fi
                        ;;
                    3)
                        if [ ! -f "./term-sd-launch.conf" ]; then #找不到启动配置时默认生成一个
                            term_sd_notice "未找到启动配置文件,创建中"
                            echo "--root ./invokeai --web" > term-sd-launch.conf
                        fi
                        generate_invokeai_launch
                        invokeai_option
                        ;;
                    4)
                        invokeai_update_depend
                        invokeai_option
                        ;;
                    5)
                        if (dialog --erase-on-exit --title "InvokeAI管理" --backtitle "InvokeAI重新安装选项" --yes-label "是" --no-label "否" --yesno "是否重新安装InvokeAI?" 25 80) then
                            cd "$start_path"
                            exit_venv
                            process_install_invokeai
                        else
                            invokeai_option
                        fi
                        ;;
                    6)
                        pytorch_reinstall
                        invokeai_option
                        ;;
                    7)
                        manage_python_packages
                        invokeai_option
                        ;;
                    8)
                        python_package_ver_backup_or_restore
                        invokeai_option
                        ;;
                    18)
                        if (dialog --erase-on-exit --title "InvokeAI管理" --backtitle "InvokeAI虚拟环境修复选项" --yes-label "是" --no-label "否" --yesno "是否修复InvokeAI的虚拟环境" 25 80);then
                            create_venv --fix
                            enter_venv
                            cmd_daemon pip_cmd install $(pip_cmd freeze | grep -i invokeai) --no-deps --force-reinstall #重新安装invokeai
                        fi
                        invokeai_option
                        ;;
                    19)
                        if (dialog --erase-on-exit --title "InvokeAI管理" --backtitle "InvokeAI虚拟环境重建选项" --yes-label "是" --no-label "否" --yesno "是否重建InvokeAI的虚拟环境" 25 80);then
                            invokeai_venv_rebuild
                        fi
                        invokeai_option
                        ;;
                esac
            fi
        else 
            if (dialog --erase-on-exit --title "InvokeAI管理" --backtitle "InvokeAI安装选项" --yes-label "是" --no-label "否" --yesno "检测到当前未安装InvokeAI,是否进行安装?" 25 80) then
                cd "$start_path"
                process_install_invokeai
            fi
        fi
    else
        if (dialog --erase-on-exit --title "InvokeAI管理" --backtitle "InvokeAI安装选项" --yes-label "是" --no-label "否" --yesno "检测到当前未安装InvokeAI,是否进行安装?" 25 80) then
          process_install_invokeai
        fi
    fi
}

#invokeai更新依赖功能
function invokeai_update_depend()
{
    if (dialog --erase-on-exit --title "InvokeAI管理" --backtitle "InvokeAI依赖更新选项" --yes-label "是" --no-label "否" --yesno "是否更新InvokeAI的依赖?" 25 80);then
        #更新前的准备
        proxy_option #代理选择
        pip_install_methon #安装方式选择
        final_install_check #安装前确认

        if [ $final_install_check_exec = 0 ];then
            print_line_to_shell "InvokeAI依赖更新"
            term_sd_notice "更新InvokeAI依赖中"
            tmp_disable_proxy
            create_venv
            enter_venv
            pip_cmd freeze | awk -F'==' '{print $1}' > requirements.txt #生成一个更新列表
            requirements_python_package_update "./requirements.txt"
            rm -rf ./requirements.txt
            exit_venv
            tmp_enable_proxy
            term_sd_notice "更新InvokeAI依赖结束"
            print_line_to_shell
        fi
    fi
}