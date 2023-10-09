#!/bin/bash

#comfyui选项
function comfyui_option()
{
    export term_sd_manager_info="ComfyUI"
    cd "$start_path" #回到最初路径
    exit_venv #确保进行下一步操作前已退出其他虚拟环境
    if [ -d "ComfyUI" ];then
        cd ComfyUI
        comfyui_option_dialog=$(
            dialog --clear --title "ComfyUI管理" --backtitle "ComfyUI管理选项" --ok-label "确认" --cancel-label "取消" --menu "请选择ComfyUI管理选项的功能\n当前更新源:$(git remote -v | awk 'NR==1' | awk '{print $2}')" 23 70 12 \
            "1" "更新" \
            "2" "卸载" \
            "3" "修复更新" \
            "4" "自定义节点管理" \
            "5" "插件管理" \
            "6" "切换版本" \
            "7" "更新源切换" \
            "8" "启动" \
            "9" "更新依赖" \
            "10" "重新安装" \
            "11" "重新安装pytorch" \
            $dialog_recreate_venv_button \
            $dialog_rebuild_venv_button \
            "20" "返回" \
            3>&1 1>&2 2>&3)

        if [ $? = 0 ];then
            if [ $comfyui_option_dialog = 1 ]; then
                echo "更新ComfyUI中"
                git pull
                if [ $? = 0 ];then
                    dialog --clear --title "ComfyUI管理" --backtitle "ComfyUI更新结果" --ok-label "确认" --msgbox "ComfyUI更新成功" 23 70
                else
                    dialog --clear --title "ComfyUI管理" --backtitle "ComfyUI更新结果" --ok-label "确认" --msgbox "ComfyUI更新失败" 23 70
                fi
                comfyui_option
            elif [ $comfyui_option_dialog = 2 ]; then
                if (dialog --clear --title "ComfyUI管理" --backtitle "ComfyUI删除选项" --yes-label "是" --no-label "否" --yesno "是否删除ComfyUI?" 23 70) then
                    echo "删除ComfyUI中"
                    exit_venv
                    cd ..
                    rm -rf ./ComfyUI
                else
                    comfyui_option
                fi
            elif [ $comfyui_option_dialog = 3 ]; then
                echo "修复更新中"
                term_sd_fix_pointer_offset
                comfyui_option
            elif [ $comfyui_option_dialog = 4 ]; then
                export comfyui_extension_info_display=1 #1代表自定义节点，其他数字代表插件
                cd custom_nodes
                comfyui_custom_node_methon
                comfyui_option
            elif [ $comfyui_option_dialog = 5 ]; then
                export comfyui_extension_info_display=2
                cd web/extensions
                comfyui_extension_methon
                comfyui_option
            elif [ $comfyui_option_dialog = 6 ]; then
                git_checkout_manager
                comfyui_option
            elif [ $comfyui_option_dialog = 7 ]; then
                comfyui_change_repo
                comfyui_option
            elif [ $comfyui_option_dialog = 8 ]; then
                if [ -f "./term-sd-launch.conf" ]; then #找到启动脚本
                    comfyui_launch
                else #找不到启动脚本,并启动脚本生成界面
                    generate_comfyui_launch
                    term_sd_launch
                fi
                comfyui_option
            elif [ $comfyui_option_dialog = 9 ]; then
                comfyui_update_depend
                comfyui_option
            elif [ $comfyui_option_dialog = 10 ]; then
                if (dialog --clear --title "ComfyUI管理" --backtitle "ComfyUI重新安装选项" --yes-label "是" --no-label "否" --yesno "是否重新安装ComfyUI?" 23 70) then
                    cd "$start_path"
                    exit_venv
                    process_install_comfyui
                else
                    comfyui_option
                fi
            elif [ $comfyui_option_dialog = 11 ]; then
                pytorch_reinstall
                comfyui_option
            elif [ $comfyui_option_dialog = 18 ]; then
                create_venv
                comfyui_option
            elif [ $comfyui_option_dialog = 19 ]; then
                if (dialog --clear --title "ComfyUI管理" --backtitle "ComfyUI虚拟环境重建选项" --yes-label "是" --no-label "否" --yesno "是否重建ComfyUI的虚拟环境" 23 70);then
                    comfyui_venv_rebuild
                fi
                comfyui_option
            elif [ $comfyui_option_dialog = 20 ]; then
                echo #回到主界面
            fi
        fi
    else
        if (dialog --clear --title "ComfyUI管理" --backtitle "ComfyUI安装选项" --yes-label "是" --no-label "否" --yesno "检测到当前未安装ComfyUI,是否进行安装?" 23 70) then
            process_install_comfyui
        fi
    fi
    mainmenu #处理完后返回主界面界面
}

#comfyui依赖更新功能
function comfyui_update_depend()
{
    if (dialog --clear --title "ComfyUI管理" --backtitle "ComfyUI依赖更新选项" --yes-label "是" --no-label "否" --yesno "是否更新ComfyUI的依赖?" 23 70);then
        #更新前的准备
        proxy_option #代理选择
        pip_install_methon #安装方式选择
        final_install_check #安装前确认

        if [ $final_install_check_exec = 0 ];then
            print_line_to_shell "ComfyUI依赖更新"
            echo "更新ComfyUI依赖中"
            tmp_disable_proxy
            create_venv
            enter_venv
            "$pip_cmd" install -r ./requirements.txt --prefer-binary --upgrade $pip_index_mirror $pip_extra_index_mirror $pip_find_mirror $force_pip $pip_install_methon_select --default-timeout=100 --retries 5
            exit_venv
            tmp_enable_proxy
            print_line_to_shell
        fi
    fi
}