#!/bin/bash

#a1111_sd_webui_option选项
function a1111_sd_webui_option()
{
    export term_sd_manager_info="stable-diffusion-webui"
    cd "$start_path" #回到最初路径
    exit_venv #确保进行下一步操作前已退出其他虚拟环境
    if [ -d "stable-diffusion-webui" ];then #找到stable-diffusion-webui目录
        cd stable-diffusion-webui
        final_a1111_sd_webui_option=$(
            dialog --clear --title "A1111-SD-Webui管理" --backtitle "A1111-SD-Webui管理选项" --ok-label "确认" --cancel-label "取消" --menu "请选择A1111-SD-Webui管理选项的功能\n当前更新源:$(git remote -v | awk 'NR==1' | awk '{print $2}')" 22 70 12 \
            "1" "更新" \
            "2" "卸载" \
            "3" "修复更新" \
            "4" "管理插件" \
            "5" "切换版本" \
            "6" "更新源替换" \
            "7" "启动" \
            "8" "更新依赖" \
            "9" "重新安装" \
            "10" "重新安装pytorch" \
            $dialog_recreate_venv_button \
            $dialog_rebuild_venv_button \
            "20" "返回" \
            3>&1 1>&2 2>&3)

        if [ $? = 0 ];then
            if [ $final_a1111_sd_webui_option = 1 ]; then
                echo "更新A1111-Stable-Diffusion-Webui中"
                git pull
                if [ $? = 0 ];then
                    dialog --clear --title "A1111-SD-Webui管理" --backtitle "A1111-SD-Webui更新结果" --ok-label "确认" --msgbox "A1111-SD-Webui更新成功" 22 70
                else
                    dialog --clear --title "A1111-SD-Webui管理" --backtitle "A1111-SD-Webui更新结果" --ok-label "确认" --msgbox "A1111-SD-Webui更新失败" 22 70
                fi
                a1111_sd_webui_option
            elif [ $final_a1111_sd_webui_option = 2 ]; then
                if (dialog --clear --title "A1111-SD-Webui管理" --backtitle "A1111-SD-Webui删除选项" --yes-label "是" --no-label "否" --yesno "是否删除A1111-Stable-Diffusion-Webui?" 22 70) then
                    echo "删除A1111-Stable-Diffusion-Webui中"
                    exit_venv
                    cd ..
                    rm -rf ./stable-diffusion-webui
                else
                    a1111_sd_webui_option
                fi
            elif [ $final_a1111_sd_webui_option = 3 ]; then
                echo "修复更新中"
                term_sd_fix_pointer_offset
                a1111_sd_webui_option
            elif [ $final_a1111_sd_webui_option = 4 ]; then
                a1111_sd_webui_extension_methon
                a1111_sd_webui_option
            elif [ $final_a1111_sd_webui_option = 5 ]; then
                git_checkout_manager
                a1111_sd_webui_option
            elif [ $final_a1111_sd_webui_option = 6 ]; then
                a1111_sd_webui_change_repo
                a1111_sd_webui_option
            elif [ $final_a1111_sd_webui_option = 7 ]; then
                if [ -f "./term-sd-launch.conf" ]; then #找到启动脚本
                    a1111_sd_webui_launch
                else #找不到启动脚本,并启动脚本生成界面
                    generate_a1111_sd_webui_launch
                    term_sd_launch
                fi
                a1111_sd_webui_option
            elif [ $final_a1111_sd_webui_option = 8 ]; then
                a1111_sd_webui_update_depend
                a1111_sd_webui_option
            elif [ $final_a1111_sd_webui_option = 9 ]; then
                if (dialog --clear --title "A1111-SD-Webui管理" --backtitle "A1111-SD-Webui重新安装选项" --yes-label "是" --no-label "否" --yesno "是否重新安装A1111-Stable-Diffusion-Webui?" 22 70) then
                    cd "$start_path"
                    exit_venv
                    process_install_a1111_sd_webui
                else
                    a1111_sd_webui_option
                fi
            elif [ $final_a1111_sd_webui_option = 10 ]; then
                pytorch_reinstall
                a1111_sd_webui_option
            elif [ $final_a1111_sd_webui_option = 18 ]; then
                create_venv
                a1111_sd_webui_option
            elif [ $final_a1111_sd_webui_option = 19 ]; then
                if (dialog --clear --title "A1111-SD-Webui管理" --backtitle "A1111-SD-Webui虚拟环境重建选项" --yes-label "是" --no-label "否" --yesno "是否重建A1111-SD-Webui的虚拟环境" 22 70);then
                    a1111_sd_webui_venv_rebuild
                fi
                a1111_sd_webui_option
            elif [ $final_a1111_sd_webui_option = 20 ]; then
                echo #回到主界面
            fi
        fi
    else #找不到stable-diffusion-webui目录
        if (dialog --clear --title "A1111-SD-Webui管理" --backtitle "A1111-SD-Webui安装选项" --yes-label "是" --no-label "否" --yesno "检测到当前未安装A1111-Stable-Diffusion-Webui,是否进行安装?" 22 70) then
            process_install_a1111_sd_webui
        fi
    fi
    mainmenu #处理完后返回主界面
}

#a1111-sd-webui依赖更新功能
function a1111_sd_webui_update_depend()
{
    if (dialog --clear --title "A1111-SD-Webui管理" --backtitle "A1111-SD-Webui依赖更新选项" --yes-label "是" --no-label "否" --yesno "是否更新A1111-Stable-Diffusion-Webui的依赖?" 22 70);then
        #更新前的准备
        proxy_option #代理选择
        pip_install_methon #安装方式选择
        final_install_check #安装前确认

        if [ $final_install_check_exec = 0 ];then
            print_word_to_shell="A1111-SD-Webui依赖更新"
            print_line_to_shell
            echo "更新A1111-SD-Webui依赖中"
            tmp_disable_proxy
            create_venv
            enter_venv
            pip install -r ./repositories/CodeFormer/requirements.txt --prefer-binary --upgrade $pip_index_mirror $pip_extra_index_mirror $pip_find_mirror $force_pip $pip_install_methon_select --default-timeout=100 --retries 5
            pip install -r ./requirements.txt --prefer-binary --upgrade $pip_index_mirror $pip_extra_index_mirror $pip_find_mirror $force_pip $pip_install_methon_select --default-timeout=100 --retries 5
            pip install git+"$github_proxy"https://github.com/openai/CLIP --prefer-binary $pip_index_mirror $pip_extra_index_mirror $pip_find_mirror $force_pip $pip_install_methon_select --default-timeout=100 --retries 5
            exit_venv
            tmp_enable_proxy
            print_line_to_shell
        fi
    fi
}