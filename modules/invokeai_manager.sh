#!/bin/bash

#InvokeAI选项
function invokeai_option()
{
    cd "$start_path" #回到最初路径
    exit_venv #确保进行下一步操作前已退出其他虚拟环境
    if [ -d "InvokeAI" ];then #找到invokeai文件夹
        cd InvokeAI
        create_venv #尝试重新生成虚拟环境,解决因为路径移动导致虚拟环境无法进入,然后检测不到invokeai
        enter_venv #进入环境
        if which invokeai 2> /dev/null ;then #查找环境中有没有invokeai
            final_invokeai_option=$(
                dialog --clear --title "InvokeAI管理" --backtitle "InvokeAI管理选项" --ok-label "确认" --cancel-label "取消" --menu "请选择InvokeAI管理选项的功能" 20 60 10 \
                "1" "更新" \
                "2" "卸载" \
                "3" "启动" \
                "4" "重新安装" \
                "5" "重新安装pytorch" \
                "6" "返回" \
                3>&1 1>&2 2>&3)

            if [ $? = 0 ];then
                if [ "${final_invokeai_option}" == '1' ]; then
                    proxy_option #代理选择
                    pip_install_methon #安装方式选择
                    final_install_check #安装前确认
                    echo "更新InvokeAI中"
                    pip install $pip_mirror $extra_pip_mirror $force_pip $pip_install_methon_select --upgrade invokeai --default-timeout=100 --retries 5
                    if [ $? = "0" ];then
                        dialog --clear --title "InvokeAI管理" --backtitle "InvokeAI更新结果" --msgbox "InvokeAI更新成功" 20 60
                    else
                        dialog --clear --title "InvokeAI管理" --backtitle "InvokeAI更新结果" --msgbox "InvokeAI更新失败" 20 60
                    fi
                    invokeai_option
                elif [ "${final_invokeai_option}" == '2' ]; then
                    if (dialog --clear --title "InvokeAI管理" --backtitle "InvokeAI删除选项" --yes-label "是" --no-label "否" --yesno "是否删除InvokeAI?" 20 60) then
                        echo "删除InvokeAI中"
                        exit_venv
                        cd ..
                        rm -rf ./InvokeAI
                    else
                        invokeai_option
                    fi
                elif [ "${final_invokeai_option}" == '3' ]; then
                    generate_invokeai_launch
                    invokeai_option
                elif [ "${final_invokeai_option}" == '4' ]; then
                    if (dialog --clear --title "InvokeAI管理" --backtitle "InvokeAI重新安装选项" --yesno "是否重新安装InvokeAI?" 20 60) then
                        cd "$start_path"
                        exit_venv
                        process_install_invokeai
                        invokeai_option
                    fi
                elif [ "${final_invokeai_option}" == '5' ]; then
                    pytorch_reinstall
                    invokeai_option
                elif [ "${final_invokeai_option}" == '6' ]; then
                    mainmenu #回到主界面
                fi
            fi
        else 
            if (dialog --clear --title "InvokeAI管理" --backtitle "InvokeAI安装选项" --yesno "检测到当前未安装InvokeAI,是否进行安装?" 20 60) then
                cd "$start_path"
                process_install_invokeai
                invokeai_option
            fi
        fi
    else
        if (dialog --clear --title "InvokeAI管理" --backtitle "InvokeAI安装选项" --yesno "检测到当前未安装InvokeAI,是否进行安装?" 20 60) then
          process_install_invokeai
          invokeai_option
        fi
    fi
    mainmenu #处理完后返回主界面界面
}