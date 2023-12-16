#!/bin/bash

# InvokeAI选项
invokeai_manager()
{
    local invokeai_manager_dialog
    export term_sd_manager_info="InvokeAI"
    cd "$start_path" # 回到最初路径
    exit_venv # 确保进行下一步操作前已退出其他虚拟环境
    if [ -d "$invokeai_path" ];then # 找到invokeai文件夹
        cd "$invokeai_path"
        enter_venv # 进入环境
        if ! which invokeai-web 2> /dev/null ;then
            exit_venv # 退出原来的环境
            create_venv # 尝试重新生成虚拟环境,解决因为路径移动导致虚拟环境无法进入,然后检测不到invokeai
            enter_venv # 进入环境
        fi
        if which invokeai-web 2> /dev/null ;then #查找环境中有没有invokeai
            invokeai_manager_dialog=$(
                dialog --erase-on-exit --notags --title "InvokeAI管理" --backtitle "InvokeAI管理选项" --ok-label "确认" --cancel-label "取消" --menu "请选择InvokeAI管理选项的功能" $term_sd_dialog_height $term_sd_dialog_width $term_sd_dialog_menu_height \
                "0" "> 返回" \
                "1" "> 启动" \
                "2" "> 更新" \
                "3" "> 更新依赖" \
                "4" "> python软件包安装/重装/卸载" \
                "5" "> 依赖库版本管理" \
                "6" "> 重新安装pytorch" \
                "7" "> 修复虚拟环境" \
                "8" "> 重新构建虚拟环境" \
                "9" "> 重新安装" \
                "10" "> 卸载" \
                3>&1 1>&2 2>&3)

            case $invokeai_manager_dialog in
                1)
                    invokeai_launch
                    invokeai_manager
                    ;;
                2)
                    # 更新前的准备
                    download_mirror_select # 下载镜像源选择
                    pip_install_mode_select # 安装方式选择
                    term_sd_install_confirm # 安装前确认
                    if [ $? = 0 ];then
                        term_sd_echo "更新InvokeAI中"
                        term_sd_tmp_disable_proxy # 临时取消代理,避免一些不必要的网络减速
                        term_sd_watch term_sd_pip install $pip_mirror $extra_pip_mirror $pip_break_system_package $pip_install_mode --prefer-binary --upgrade invokeai
                        if [ $? = 0 ];then
                            dialog --erase-on-exit --title "InvokeAI管理" --backtitle "InvokeAI更新结果" --ok-label "确认" --msgbox "InvokeAI更新成功" $term_sd_dialog_height $term_sd_dialog_width
                        else
                            dialog --erase-on-exit --title "InvokeAI管理" --backtitle "InvokeAI更新结果" --ok-label "确认" --msgbox "InvokeAI更新失败" $term_sd_dialog_height $term_sd_dialog_width
                        fi
                        term_sd_tmp_enable_proxy # 恢复原有的代理
                    fi
                    invokeai_manager
                    ;;
                3)
                    invokeai_update_depend
                    invokeai_manager
                    ;;
                4)
                    if (dialog --erase-on-exit --title "InvokeAI管理" --backtitle "InvokeAI的python软件包安装/重装/卸载选项" --yes-label "是" --no-label "否" --yesno "是否进入python软件包安装/重装/卸载选项?" $term_sd_dialog_height $term_sd_dialog_width) then
                        python_package_manager
                    fi
                    invokeai_manager
                    ;;
                5)
                    python_package_ver_backup_manager
                    invokeai_manager
                    ;;
                6)
                    pytorch_reinstall
                    invokeai_manager
                    ;;
                7)
                    if [ $venv_setup_status = 0 ];then
                        if (dialog --erase-on-exit --title "InvokeAI管理" --backtitle "InvokeAI虚拟环境修复选项" --yes-label "是" --no-label "否" --yesno "是否修复InvokeAI的虚拟环境" $term_sd_dialog_height $term_sd_dialog_width);then
                            create_venv --fix
                            enter_venv
                            term_sd_watch term_sd_pip install $(term_sd_pip freeze | grep -i invokeai) --no-deps --force-reinstall # 重新安装invokeai
                        fi
                    else
                        dialog --erase-on-exit --title "InvokeAI管理" --backtitle "InvokeAI虚拟环境修复选项" --ok-label "确认" --msgbox "虚拟环境功能已禁用,无法使用该功能" $term_sd_dialog_height $term_sd_dialog_width
                    fi
                        invokeai_manager
                    ;;
                8)
                    if [ $venv_setup_status = 0 ];then
                        if (dialog --erase-on-exit --title "InvokeAI管理" --backtitle "InvokeAI虚拟环境重建选项" --yes-label "是" --no-label "否" --yesno "是否重建InvokeAI的虚拟环境" $term_sd_dialog_height $term_sd_dialog_width);then
                            invokeai_venv_rebuild
                        fi
                    else
                        dialog --erase-on-exit --title "InvokeAI管理" --backtitle "InvokeAI虚拟环境重建选项" --ok-label "确认" --msgbox "虚拟环境功能已禁用,无法使用该功能" $term_sd_dialog_height $term_sd_dialog_width
                    fi
                    invokeai_manager
                    ;;
                9)
                    if (dialog --erase-on-exit --title "InvokeAI管理" --backtitle "InvokeAI重新安装选项" --yes-label "是" --no-label "否" --yesno "是否重新安装InvokeAI?" $term_sd_dialog_height $term_sd_dialog_width) then
                        cd "$start_path"
                        rm -f "$start_path/term-sd/task/invokeai_install.sh"
                        exit_venv
                        install_invokeai
                    else
                        invokeai_manager
                    fi
                    ;;
                10)
                    if (dialog --erase-on-exit --title "InvokeAI管理" --backtitle "InvokeAI删除选项" --yes-label "是" --no-label "否" --yesno "是否删除InvokeAI?" $term_sd_dialog_height $term_sd_dialog_width) then
                        term_sd_echo "请再次确认是否删除InvokeAI(yes/no)?"
                        term_sd_echo "警告:该操作将永久删除InvokeAI"
                        term_sd_echo "提示:输入yes或no后回车"
                        case $(term_sd_read) in
                            yes|y|YES|Y)
                                exit_venv
                                term_sd_echo "删除InvokeAI中"
                                cd ..
                                rm -rf ./InvokeAI
                                term_sd_echo "删除InvokeAI完成"
                                ;;
                            *)
                                term_sd_echo "取消删除操作"
                                invokeai_manager
                                ;;
                        esac
                    else
                        term_sd_echo "取消删除操作"
                        invokeai_manager
                    fi
                    ;;
            esac
        else 
            if (dialog --erase-on-exit --title "InvokeAI管理" --backtitle "InvokeAI安装选项" --yes-label "是" --no-label "否" --yesno "检测到当前未安装InvokeAI,是否进行安装?" $term_sd_dialog_height $term_sd_dialog_width) then
                cd "$invokeai_parent_path"
                rm -f "$start_path/term-sd/task/invokeai_install.sh"
                install_invokeai
            fi
        fi
    else
        if (dialog --erase-on-exit --title "InvokeAI管理" --backtitle "InvokeAI安装选项" --yes-label "是" --no-label "否" --yesno "检测到当前未安装InvokeAI,是否进行安装?" $term_sd_dialog_height $term_sd_dialog_width) then
            rm -f "$start_path/term-sd/task/invokeai_install.sh"
            install_invokeai
        fi
    fi
}

# invokeai更新依赖
invokeai_update_depend()
{
    if (dialog --erase-on-exit --title "InvokeAI管理" --backtitle "InvokeAI依赖更新选项" --yes-label "是" --no-label "否" --yesno "是否更新InvokeAI的依赖?" $term_sd_dialog_height $term_sd_dialog_width);then
        # 更新前的准备
        download_mirror_select # 下载镜像源选择
        pip_install_mode_select # 安装方式选择
        term_sd_install_confirm # 安装前确认

        if [ $? = 0 ];then
            term_sd_print_line "InvokeAI依赖更新"
            term_sd_echo "更新InvokeAI依赖中"
            term_sd_tmp_disable_proxy
            create_venv
            enter_venv
            term_sd_pip freeze | awk -F'==' '{print $1}' > requirements.txt #生成一个更新列表
            python_package_update "./requirements.txt"
            rm -rf ./requirements.txt
            exit_venv
            term_sd_tmp_enable_proxy
            term_sd_echo "更新InvokeAI依赖结束"
            term_sd_pause
        fi
    fi
}