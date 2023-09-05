#/bin/bash

#lora-scripts选项
function lora_scripts_option()
{
    cd "$start_path" #回到最初路径
    exit_venv #确保进行下一步操作前已退出其他虚拟环境
    if [ -d "./lora-scripts" ];then
        cd lora-scripts
        final_lora_scripts_option=$(
            dialog --clear --title "lora-scripts管理" --backtitle "lora-scripts管理选项" --ok-label "确认" --cancel-label "取消" --menu "请选择lora-scripts管理选项的功能\n当前目录可用空间:$(df ./ -h |awk 'NR==2'|awk -F ' ' ' {print $4} ')" 20 60 10 \
            "1" "更新" \
            "2" "卸载" \
            "3" "修复更新" \
            "4" "版本切换" \
            "5" "启动" \
            "6" "重新安装" \
            "7" "重新安装pytorch" \
            "8" "重新生成venv虚拟环境" \
            "9" "返回" \
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
                    dialog --clear --title "lora-scripts管理" --backtitle "lora-scripts更新结果" --msgbox "lora-scripts更新成功" 20 60
                else
                    dialog --clear --title "lora-scripts管理" --backtitle "lora-scripts更新结果" --msgbox "lora-scripts更新失败" 20 60
                fi
                lora_scripts_option
            elif [ "${final_lora_scripts_option}" == '2' ]; then
                if (dialog --clear --title "lora-scripts管理" --backtitle "lora-scripts删除选项" --yes-label "是" --no-label "否" --yesno "是否删除lora-scripts?" 20 60) then
                    echo "删除lora-scripts中"
                    exit_venv
                    cd ..
                    rm -rfv ./lora-scripts
                else
                    lora_scripts_option
                fi
            elif [ "${final_lora_scripts_option}" == '3' ]; then
                echo "修复更新中"
                git checkout main
                git reset --hard HEAD #修复lora-scripts
                cd ./sd-scripts
                git checkout main
                git reset --hard HEAD #修复kohya-ss训练模块
                cd ./../frontend
                git checkout master
                git reset --hard HEAD #修复lora-gui-dist
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
                enter_venv
                export HF_HOME=huggingface
                export PYTHONUTF8=1
                if [ $(uname -o) = "Msys" ];then #为了兼容windows系统
                    python ./gui.py
                else
                    python3 ./gui.py
                fi
                lora_scripts_option
            elif [ "${final_lora_scripts_option}" == '6' ]; then
                if (dialog --clear --title "lora-scripts管理" --backtitle "lora-scripts重新安装选项" --yesno "是否重新安装lora_scripts?" 20 60) then
                    cd "$start_path"
                    exit_venv
                    process_install_lora_scripts
                    lora_scripts_option
                fi
            elif [ "${final_lora_scripts_option}" == '7' ]; then
                pytorch_reinstall
                lora_scripts_option
            elif [ "${final_lora_scripts_option}" == '8' ]; then
                create_venv
                lora_scripts_option
            elif [ "${final_lora_scripts_option}" == '9' ]; then
                mainmenu #回到主界面
            fi
        fi
    else
        if (dialog --clear --title "lora-scripts管理" --backtitle "lora-scripts安装选项" --yesno "检测到当前未安装lora_scripts,是否进行安装?" 20 60) then
            process_install_lora_scripts
            lora_scripts_option
        fi
    fi
    mainmenu #处理完后返回主界面界面
}