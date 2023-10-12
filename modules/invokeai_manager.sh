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
                dialog --clear --title "InvokeAI管理" --backtitle "InvokeAI管理选项" --ok-label "确认" --cancel-label "取消" --menu "请选择InvokeAI管理选项的功能" 25 70 10 \
                "1" "更新" \
                "2" "卸载" \
                "3" "启动" \
                "4" "重新安装" \
                "5" "重新安装pytorch" \
                "6" "python软件包重装" \
                $dialog_rebuild_venv_button \
                "20" "返回" \
                3>&1 1>&2 2>&3)

            if [ $? = 0 ];then
                if [ $invokeai_option_dialog = 1 ]; then
                    proxy_option #代理选择
                    pip_install_methon #安装方式选择
                    final_install_check #安装前确认
                    if [ $final_install_check_exec = 0 ];then
                        term_sd_notice "更新InvokeAI中"
                        "$pip_cmd" install $pip_mirror $extra_pip_mirror $force_pip $pip_install_methon_select --prefer-binary --upgrade invokeai --default-timeout=100 --retries 5
                        if [ $? = 0 ];then
                            dialog --clear --title "InvokeAI管理" --backtitle "InvokeAI更新结果" --ok-label "确认" --msgbox "InvokeAI更新成功" 25 70
                        else
                            dialog --clear --title "InvokeAI管理" --backtitle "InvokeAI更新结果" --ok-label "确认" --msgbox "InvokeAI更新失败" 25 70
                        fi
                    fi
                    invokeai_option
                elif [ $invokeai_option_dialog = 2 ]; then
                    if (dialog --clear --title "InvokeAI管理" --backtitle "InvokeAI删除选项" --yes-label "是" --no-label "否" --yesno "是否删除InvokeAI?" 25 70) then
                        term_sd_notice "删除InvokeAI中"
                        exit_venv
                        cd ..
                        rm -rf ./InvokeAI
                    else
                        invokeai_option
                    fi
                elif [ $invokeai_option_dialog = 3 ]; then
                    if [ ! -f "./term-sd-launch.conf" ]; then #找不到启动配置时默认生成一个
                        term_sd_notice "未找到启动配置文件,创建中"
                        echo "--root ./invokeai --web" > term-sd-launch.conf
                    fi
                    generate_invokeai_launch
                    invokeai_option
                elif [ $invokeai_option_dialog = 4 ]; then
                    if (dialog --clear --title "InvokeAI管理" --backtitle "InvokeAI重新安装选项" --yes-label "是" --no-label "否" --yesno "是否重新安装InvokeAI?" 25 70) then
                        cd "$start_path"
                        exit_venv
                        process_install_invokeai
                    else
                        invokeai_option
                    fi
                elif [ $invokeai_option_dialog = 5 ]; then
                    pytorch_reinstall
                    invokeai_option
                elif [ $invokeai_option_dialog = 6 ]; then
                    reinstall_python_packages
                    invokeai_option
                elif [ $invokeai_option_dialog = 19 ]; then
                    if (dialog --clear --title "InvokeAI管理" --backtitle "InvokeAI虚拟环境重建选项" --yes-label "是" --no-label "否" --yesno "是否重建InvokeAI的虚拟环境" 25 70);then
                        invokeai_venv_rebuild
                    fi
                    invokeai_option
                fi
            fi
        else 
            if (dialog --clear --title "InvokeAI管理" --backtitle "InvokeAI安装选项" --yes-label "是" --no-label "否" --yesno "检测到当前未安装InvokeAI,是否进行安装?" 25 70) then
                cd "$start_path"
                process_install_invokeai
            fi
        fi
    else
        if (dialog --clear --title "InvokeAI管理" --backtitle "InvokeAI安装选项" --yes-label "是" --no-label "否" --yesno "检测到当前未安装InvokeAI,是否进行安装?" 25 70) then
          process_install_invokeai
        fi
    fi
    mainmenu #处理完后返回主界面界面
}
