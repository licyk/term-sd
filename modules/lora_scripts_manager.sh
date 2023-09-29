#!/bin/bash

#lora-scripts选项
function lora_scripts_option()
{
    export term_sd_manager_info="lora-scripts"
    cd "$start_path" #回到最初路径
    exit_venv #确保进行下一步操作前已退出其他虚拟环境
    if [ -d "./lora-scripts" ];then
        cd lora-scripts
        final_lora_scripts_option=$(
            dialog --clear --title "lora-scripts管理" --backtitle "lora-scripts管理选项" --ok-label "确认" --cancel-label "取消" --menu "请选择lora-scripts管理选项的功能\n当前更新源:$(git remote -v | awk 'NR==1' | awk '{print $2}')" 22 70 12 \
            "1" "更新" \
            "2" "卸载" \
            "3" "修复更新" \
            "4" "版本切换" \
            "5" "更新源切换" \
            "6" "启动" \
            "7" "重新安装" \
            "8" "重新安装pytorch" \
            $dialog_button_5 \
            $dialog_button_6 \
            "20" "返回" \
            3>&1 1>&2 2>&3)

        if [ $? = 0 ];then
            if [ "${final_lora_scripts_option}" == '1' ]; then
                echo "更新lora-scripts中"
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
                    dialog --clear --title "lora-scripts管理" --backtitle "lora-scripts更新结果" --msgbox "lora-scripts更新成功" 22 70
                else
                    dialog --clear --title "lora-scripts管理" --backtitle "lora-scripts更新结果" --msgbox "lora-scripts更新失败" 22 70
                fi
                lora_scripts_option
            elif [ "${final_lora_scripts_option}" == '2' ]; then
                if (dialog --clear --title "lora-scripts管理" --backtitle "lora-scripts删除选项" --yes-label "是" --no-label "否" --yesno "是否删除lora-scripts?" 22 70) then
                    echo "删除lora-scripts中"
                    exit_venv
                    cd ..
                    rm -rf ./lora-scripts
                else
                    lora_scripts_option
                fi
            elif [ "${final_lora_scripts_option}" == '3' ]; then
                echo "修复更新中"
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
            elif [ "${final_lora_scripts_option}" == '4' ]; then
                git_checkout_manager
                cd "$start_path/lora-scripts"
                git submodule init
                git submodule update
                git submodule
                lora_scripts_option
            elif [ "${final_lora_scripts_option}" == '5' ]; then
                lora_scripts_change_repo
                lora_scripts_option
            elif [ "${final_lora_scripts_option}" == '6' ]; then
                enter_venv
                export HF_HOME=huggingface
                export PYTHONUTF8=1
                $python_cmd ./gui.py
                lora_scripts_option
            elif [ "${final_lora_scripts_option}" == '7' ]; then
                if (dialog --clear --title "lora-scripts管理" --backtitle "lora-scripts重新安装选项" --yesno "是否重新安装lora_scripts?" 22 70) then
                    cd "$start_path"
                    exit_venv
                    process_install_lora_scripts
                else
                    lora_scripts_option
                fi
            elif [ "${final_lora_scripts_option}" == '8' ]; then
                pytorch_reinstall
                lora_scripts_option
            elif [ "${final_lora_scripts_option}" == '18' ]; then
                create_venv
                lora_scripts_option
            elif [ "${final_lora_scripts_option}" == '19' ]; then
                if (dialog --clear --title "lora-scripts管理" --backtitle "lora-scripts虚拟环境重建选项" --yes-label "是" --no-label "否" --yesno "是否重建lora-scripts的虚拟环境" 22 70);then
                    lora_scripts_venv_rebuild
                fi
                lora_scripts_option
            elif [ "${final_lora_scripts_option}" == '20' ]; then
                mainmenu #回到主界面
            fi
        fi
    else
        if (dialog --clear --title "lora-scripts管理" --backtitle "lora-scripts安装选项" --yesno "检测到当前未安装lora_scripts,是否进行安装?" 22 70) then
            process_install_lora_scripts
        fi
    fi
    mainmenu #处理完后返回主界面界面
}