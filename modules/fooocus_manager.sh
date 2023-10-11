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
            dialog --clear --title "Fooocus管理" --backtitle "Fooocus管理选项" --ok-label "确认" --cancel-label "取消" --menu "请选择Fooocus管理选项的功能\n当前更新源:$(git remote -v | awk 'NR==1' | awk '{print $2}')" 25 70 10 \
            "1" "更新" \
            "2" "卸载" \
            "3" "修复更新" \
            "4" "版本切换" \
            "5" "更新源切换" \
            "6" "启动" \
            "7" "更新依赖" \
            "8" "重新安装" \
            "9" "重新安装pytorch" \
            "10" "python软件包重装" \
            $dialog_recreate_venv_button \
            $dialog_rebuild_venv_button \
            "20" "返回" \
            3>&1 1>&2 2>&3)

        if [ $? = 0 ];then
            if [ $fooocus_option_dialog = 1 ]; then
                term_sd_notice "更新Fooocus中"
                test_num=1
                git pull
                if [ $? = 0 ];then
                    test_num=0
                fi
                git pull --rebase ./repositories/ComfyUI-from-StabilityAI-Official
                if [ $test_num = "0" ];then
                    dialog --clear --title "Fooocus管理" --backtitle "Fooocus更新结果" --ok-label "确认" --msgbox "Fooocus更新成功" 25 70
                else
                    dialog --clear --title "Fooocus管理" --backtitle "Fooocus更新结果" --ok-label "确认" --msgbox "Fooocus更新失败" 25 70
                fi
                fooocus_option
            elif [ $fooocus_option_dialog = 2 ]; then
                if (dialog --clear --title "Fooocus管理" --backtitle "Fooocus删除选项" --yes-label "是" --no-label "否" --yesno "是否删除Fooocus?" 25 70) then
                    term_sd_notice "删除Fooocus中"
                    exit_venv
                    cd ..
                    rm -rf ./Fooocus
                else
                    fooocus_option
                fi
            elif [ $fooocus_option_dialog = 3 ]; then
                term_sd_notice "修复更新中"
                term_sd_fix_pointer_offset #修复Fooocus
                cd ./repositories/ComfyUI-from-StabilityAI-Official
                term_sd_fix_pointer_offset #修复ComfyUI核心
                cd ../..
                fooocus_option
            elif [ $fooocus_option_dialog = 4 ]; then
                git_checkout_manager
                fooocus_option
            elif [ $fooocus_option_dialog = 5 ]; then
                fooocus_change_repo
                fooocus_option
            elif [ $fooocus_option_dialog = 6 ]; then
                if [ ! -f "./term-sd-launch.conf" ]; then #找不到启动配置时默认生成一个
                    term_sd_notice "未找到启动配置文件,创建中"
                    echo "launch.py " > term-sd-launch.conf
                fi
                fooocus_launch
                fooocus_option
            elif [ $fooocus_option_dialog = 7 ]; then
                fooocus_update_depend
                fooocus_option
            elif [ $fooocus_option_dialog = 8 ]; then
                if (dialog --clear --title "Fooocus管理" --backtitle "Fooocus重新安装选项" --yes-label "是" --no-label "否" --yesno "是否重新安装Fooocus?" 25 70) then
                    cd "$start_path"
                    exit_venv
                    process_install_fooocus
                else
                    fooocus_option
                fi
            elif [ $fooocus_option_dialog = 9 ]; then
                pytorch_reinstall
                fooocus_option
            elif [ $fooocus_option_dialog = 10 ]; then
                reinstall_python_packages
                fooocus_option
            elif [ $fooocus_option_dialog = 18 ]; then
                create_venv
                fooocus_option
            elif [ $fooocus_option_dialog = 19 ]; then
                if (dialog --clear --title "Fooocus管理" --backtitle "Fooocus虚拟环境重建选项" --yes-label "是" --no-label "否" --yesno "是否重建Fooocus的虚拟环境" 25 70);then
                    fooocus_venv_rebuild
                fi
                fooocus_option
            fi
        fi
    else
        if (dialog --clear --title "Fooocus管理" --backtitle "Fooocus安装选项" --yes-label "是" --no-label "否" --yesno "检测到当前未安装Fooocus,是否进行安装?" 25 70) then
            process_install_fooocus
        fi
    fi
    mainmenu #处理完后返回主界面界面
}

#fooocus依赖更新
function fooocus_update_depend()
{
    if (dialog --clear --title "fooocus_option管理" --backtitle "fooocus_option依赖更新选项" --yes-label "是" --no-label "否" --yesno "是否更新fooocus_option的依赖?" 25 70);then
        #更新前的准备
        proxy_option #代理选择
        pip_install_methon #安装方式选择
        final_install_check #安装前确认

        if [ $final_install_check_exec = 0 ];then
            print_line_to_shell "fooocus_option依赖更新"
            term_sd_notice "更新fooocus_option依赖中"
            tmp_disable_proxy
            create_venv
            enter_venv
            "$pip_cmd" install $pip_index_mirror $pip_extra_index_mirror $pip_find_mirror $force_pip $pip_install_methon_select --prefer-binary --upgrade -r ./requirements_versions.txt --default-timeout=100 --retries 5
            exit_venv
            tmp_enable_proxy
            print_line_to_shell
        fi
    fi
}
