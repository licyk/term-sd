#/bin/bash

#a1111_sd_webui_option选项
function a1111_sd_webui_option()
{
    cd "$start_path" #回到最初路径
    exit_venv #确保进行下一步操作前已退出其他虚拟环境
    if [ -d "stable-diffusion-webui" ];then #找到stable-diffusion-webui目录
        cd stable-diffusion-webui
        final_a1111_sd_webui_option=$(
            dialog --clear --title "A1111-SD-Webui管理" --backtitle "A1111-SD-Webui管理选项" --ok-label "确认" --cancel-label "取消" --menu "请选择A1111-SD-Webui管理选项的功能\n当前目录可用空间:$(df ./ -h |awk 'NR==2'|awk -F ' ' ' {print $4} ')" 20 60 10 \
            "1" "更新" \
            "2" "卸载" \
            "3" "修复更新" \
            "4" "管理插件" \
            "5" "切换版本" \
            "6" "启动" \
            "7" "重新安装" \
            "8" "重新安装pytorch" \
            "9" "重新生成venv虚拟环境" \
            "10" "返回" \
            3>&1 1>&2 2>&3)

        if [ $? = 0 ];then
            if [ "${final_a1111_sd_webui_option}" == '1' ]; then
                echo "更新A1111-Stable-Diffusion-Webui中"
                test_num=1
                git pull
                if [ $? = 0 ];then
                    test_num=0
                fi
                if [ $test_num = "0" ];then
                    dialog --clear --title "A1111-SD-Webui管理" --backtitle "A1111-SD-Webui更新结果" --msgbox "A1111-SD-Webui更新成功" 20 60
                else
                    dialog --clear --title "A1111-SD-Webui管理" --backtitle "A1111-SD-Webui更新结果" --msgbox "A1111-SD-Webui更新失败" 20 60
                fi
                a1111_sd_webui_option
            elif [ "${final_a1111_sd_webui_option}" == '2' ]; then
                if (dialog --clear --title "A1111-SD-Webui管理" --backtitle "A1111-SD-Webui删除选项" --yesno "是否删除A1111-Stable-Diffusion-Webui?" 20 60) then
                    echo "删除A1111-Stable-Diffusion-Webui中"
                    exit_venv
                    cd ..
                    rm -rf ./stable-diffusion-webui
                else
                    a1111_sd_webui_option
                fi
            elif [ "${final_a1111_sd_webui_option}" == '3' ]; then
                echo "修复更新中"
                term_sd_fix_pointer_offset
                a1111_sd_webui_option
            elif [ "${final_a1111_sd_webui_option}" == '4' ]; then
                cd extensions
                a1111_sd_webui_extension_methon
                a1111_sd_webui_option
            elif [ "${final_a1111_sd_webui_option}" == '5' ]; then
                git_checkout_manager
                a1111_sd_webui_option
            elif [ "${final_a1111_sd_webui_option}" == '6' ]; then
                if [ -f "./term-sd-launch.conf" ]; then #找到启动脚本
                    if (dialog --clear --title "A1111-SD-Webui管理" --backtitle "A1111-SD-Webui启动选项" --yes-label "启动" --no-label "修改参数" --yesno "请选择启动A1111-SD-Webui/修改A1111-SD-Webui启动参数\n当前启动参数:\npython $(cat ./term-sd-launch.conf)" 20 60) then
                        term_sd_launch
                        a1111_sd_webui_option
                    else #修改启动脚本
                        generate_a1111_sd_webui_launch
                        term_sd_launch
                        a1111_sd_webui_option
                    fi
                else #找不到启动脚本,并启动脚本生成界面
                generate_a1111_sd_webui_launch
                term_sd_launch
                a1111_sd_webui_option
                fi
            elif [ "${final_a1111_sd_webui_option}" == '7' ]; then
                if (dialog --clear --title "A1111-SD-Webui管理" --backtitle "A1111-SD-Webui重新安装选项" --yesno "是否重新安装A1111-Stable-Diffusion-Webui?" 20 60) then
                cd "$start_path"
                exit_venv
                process_install_a1111_sd_webui
                a1111_sd_webui_option
                fi
            elif [ "${final_a1111_sd_webui_option}" == '8' ]; then
                pytorch_reinstall
                a1111_sd_webui_option
            elif [ "${final_a1111_sd_webui_option}" == '9' ]; then
                create_venv
                a1111_sd_webui_option
            elif [ "${final_a1111_sd_webui_option}" == '10' ]; then
                mainmenu #回到主界面
            fi
        fi
    else #找不到stable-diffusion-webui目录
        if (dialog --clear --title "A1111-SD-Webui管理" --backtitle "A1111-SD-Webui安装选项" --yesno "检测到当前未安装A1111-Stable-Diffusion-Webui,是否进行安装?" 20 60) then
            process_install_a1111_sd_webui
            a1111_sd_webui_option
        fi
    fi
    mainmenu #处理完后返回主界面
}