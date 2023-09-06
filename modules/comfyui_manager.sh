#/bin/bash

#comfyui选项
function comfyui_option()
{
    cd "$start_path" #回到最初路径
    exit_venv #确保进行下一步操作前已退出其他虚拟环境
    if [ -d "ComfyUI" ];then
        cd ComfyUI
        final_comfyui_option=$(
            dialog --clear --title "ComfyUI管理" --backtitle "ComfyUI管理选项" --ok-label "确认" --cancel-label "取消" --menu "请选择ComfyUI管理选项的功能\n当前目录可用空间:$(df ./ -h |awk 'NR==2'|awk -F ' ' ' {print $4} ')" 20 60 10 \
            "1" "更新" \
            "2" "卸载" \
            "3" "修复更新" \
            "4" "自定义节点管理" \
            "5" "插件管理" \
            "6" "切换版本" \
            "7" "启动" \
            "8" "重新安装" \
            "9" "重新安装pytorch" \
            "10" "重新生成venv虚拟环境" \
            "11" "返回" \
            3>&1 1>&2 2>&3)

        if [ $? = 0 ];then
            if [ "${final_comfyui_option}" == '1' ]; then
                echo "更新ComfyUI中"
                git pull
                if [ $? = "0" ];then
                    dialog --clear --title "ComfyUI管理" --backtitle "ComfyUI更新结果" --msgbox "ComfyUI更新成功" 20 60
                else
                    dialog --clear --title "ComfyUI管理" --backtitle "ComfyUI更新结果" --msgbox "ComfyUI更新失败" 20 60
                fi
                comfyui_option
            elif [ "${final_comfyui_option}" == '2' ]; then
                if (dialog --clear --title "ComfyUI管理" --backtitle "ComfyUI删除选项" --yes-label "是" --no-label "否" --yesno "是否删除ComfyUI?" 20 60) then
                    echo "删除ComfyUI中"
                    exit_venv
                    cd ..
                    rm -rfv ./ComfyUI
                else
                    comfyui_option
                fi
            elif [ "${final_comfyui_option}" == '3' ]; then
                echo "修复更新中"
                term_sd_fix_pointer_offset
                comfyui_option
            elif [ "${final_comfyui_option}" == '4' ]; then
                cd custom_nodes
                comfyui_custom_node_methon
                comfyui_option
            elif [ "${final_comfyui_option}" == '5' ]; then
                cd web/extensions
                comfyui_extension_methon
                comfyui_option
            elif [ "${final_comfyui_option}" == '6' ]; then
                git_checkout_manager
                comfyui_option
            elif [ "${final_comfyui_option}" == '7' ]; then
                if [ -f "./term-sd-launch.conf" ]; then #找到启动脚本
                    if (dialog --clear --title "ComfyUI管理" --backtitle "ComfyUI启动选项" --yes-label "启动" --no-label "修改参数" --yesno "请选择启动ComfyUI/修改ComfyUI启动参数\n当前启动参数:\npython $(cat ./term-sd-launch.conf)" 20 60) then
                        term_sd_launch
                        comfyui_option
                    else
                        generate_comfyui_launch
                        term_sd_launch
                        comfyui_option
                    fi
                else #找不到启动脚本,并启动脚本生成界面
                    generate_comfyui_launch
                    term_sd_launch
                    comfyui_option
                fi    
            elif [ "${final_comfyui_option}" == '8' ]; then
                if (dialog --clear --title "ComfyUI管理" --backtitle "ComfyUI重新安装选项" --yesno "是否重新安装ComfyUI?" 20 60) then
                    cd "$start_path"
                    exit_venv
                    process_install_comfyui
                    comfyui_option
                fi
            elif [ "${final_comfyui_option}" == '9' ]; then
                pytorch_reinstall
                comfyui_option
            elif [ "${final_comfyui_option}" == '10' ]; then
                create_venv
                comfyui_option
            elif [ "${final_comfyui_option}" == '11' ]; then
                mainmenu #回到主界面
            fi
        fi
    else
        if (dialog --clear --title "ComfyUI管理" --backtitle "ComfyUI安装选项" --yesno "检测到当前未安装ComfyUI,是否进行安装?" 20 60) then
            process_install_comfyui
            comfyui_option
        fi
    fi
    mainmenu #处理完后返回主界面界面
}