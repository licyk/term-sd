#!/bin/bash

#comfyui
#comfyui的扩展分为两种,一种是前端节点,另一种是后端扩展.详见:https://github.com/comfyanonymous/ComfyUI/discussions/631

#comfyui前端节点管理
#自定义节点的安装或管理选项(该部分最先被调用)
function comfyui_custom_node_methon()
{
    cd "$start_path/ComfyUI/custom_nodes" #回到最初路径
    #功能选择界面
    final_comfyui_custom_node_methon=$(
        dialog --clear --title "ComfyUI管理" --backtitle "ComfyUI自定义节点管理选项" --ok-label "确认" --cancel-label "取消" --menu "请选择ComfyUI自定义节点管理选项的功能" 23 70 12 \
        "1" "安装" \
        "2" "管理" \
        "3" "更新全部自定义节点" \
        "4" "安装全部自定义节点依赖" \
        "5" "返回" \
        3>&1 1>&2 2>&3 )

    if [ $? = 0 ];then
        if [ $final_comfyui_custom_node_methon = 1 ]; then #选择安装
            comfyui_custom_node_install
            comfyui_custom_node_methon
        elif [ $final_comfyui_custom_node_methon = 2 ]; then #选择管理
            comfyui_custom_node_manager
            comfyui_custom_node_methon
        elif [ $final_comfyui_custom_node_methon = 3 ]; then #选择更新全部自定义节点
            extension_all_update
            comfyui_custom_node_methon
        elif [ $final_comfyui_custom_node_methon = 4 ]; then #选择安装全部插件依赖
            comfyui_extension_dep_install
            comfyui_custom_node_methon
        elif [ $final_comfyui_custom_node_methon = 5 ]; then #选择返回
            echo
        fi
    fi
}

#自定义节点管理界面
function comfyui_custom_node_manager()
{
    cd "$start_path/ComfyUI/custom_nodes" #回到最初路径
    dir_list=$(ls -l --time-style=+"%Y-%m-%d" | awk -F ' ' ' { print $7 " " $6 } ') #当前目录文件和文件夹信息

    comfyui_custom_node_selection=$(
        dialog --clear --yes-label "确认" --no-label "取消" --title "ComfyUI管理" --backtitle "ComfyUI自定义节点列表" \
        --menu "使用上下键选择要操作的插件并回车确认" 23 70 12 \
        $dir_list \
        3>&1 1>&2 2>&3)
    if [ $? = 0 ];then
        if [ -d "$comfyui_custom_node_selection" ]; then  # 选择文件夹
            cd "$comfyui_custom_node_selection"
            operate_comfyui_custom_node #调用operate_extension函数处理插件
            comfyui_custom_node_manager
        elif [ -f "$extension_selection" ]; then
            comfyui_custom_node_manager #留在当前目录
        else
            comfyui_custom_node_manager #留在当前目录
        fi
    fi
}

#自定义节点安装模块
function comfyui_custom_node_install()
{
    comfyui_custom_node_address=$(dialog --clear --title "ComfyUI管理" --backtitle "ComfyUI自定义节点安装选项" --ok-label "确认" --cancel-label "取消" --inputbox "输入自定义节点的github地址或其他下载地址" 23 70 3>&1 1>&2 2>&3)

    if [ ! -z $comfyui_custom_node_address ]; then
        echo "安装$(echo $comfyui_custom_node_address | awk -F'/' '{print $NF}')中"
        git clone $comfyui_custom_node_address
        git_req=$?
        comfyui_custom_node_dep_notice=""
        if [ -f "./$(awk -F "/" '{print $NF}' <<< "$comfyui_custom_node_address")/requirements.txt" ];then
            comfyui_custom_node_dep_notice="检测到该自定义节点需要安装依赖,请进入自定义节点管理功能,选中该自定义节点,运行一次\"安装依赖\"功能"
        elif [ -f "./$(awk -F "/" '{print $NF}' <<< "$comfyui_custom_node_address")/install.py" ];then
            comfyui_custom_node_dep_notice="检测到该自定义节点需要安装依赖,请进入自定义节点管理功能,选中该自定义节点,运行一次\"安装依赖\"功能"
        fi

        if [ $git_req = 0 ];then
            dialog --clear --title "ComfyUI管理" --backtitle "ComfyUI自定义节点安装结果" --ok-label "确认" --msgbox "$(echo $comfyui_custom_node_address | awk -F'/' '{print $NF}')自定义节点安装成功\n$comfyui_custom_node_dep_notice" 23 70
        else
            dialog --clear --title "ComfyUI管理" --backtitle "ComfyUI自定义节点安装结果" --ok-label "确认" --msgbox "$(echo $comfyui_custom_node_address | awk -F'/' '{print $NF}')自定义节点安装失败" 23 70
        fi
    fi
}

#自定义节点处理模块
function operate_comfyui_custom_node() 
{
    #当git在子文件夹中找不到.git文件夹时,将会自动在父文件夹中寻找,以此类推,直到找到.git文件夹。用户的安装方式可能是直接下载源码压缩包,导致安装后的文件夹没有.git文件夹,直接执行git会导致不良的后果   
    
    if [ -d "./.git" ];then #检测目录中是否有.git文件夹
        dialog_update_button=""1" "更新""
        dialog_fix_update_button=""4" "修复更新""
        dialog_git_checkout_button=""5" "版本切换""
        dialog_update_remote_checkout_button=""6" "更新源切换"" 
    else
        dialog_update_button=""
        dialog_fix_update_button=""
        dialog_git_checkout_button=""
        dialog_update_remote_checkout_button=""
    fi

    final_operate_comfyui_custom_node=$(
        dialog --clear --title "ComfyUI选项" --backtitle "ComfyUI自定义节点管理选项" --ok-label "确认" --cancel-label "取消" --menu "请选择对"$comfyui_custom_node_selection"自定义节点的管理功能\n当前更新源:$([ -d "./.git" ] && git remote -v | awk 'NR==1' | awk '{print $2}' || echo "无")" 23 70 12 \
        $dialog_update_button \
        "2" "安装依赖" \
        "3" "卸载" \
        $dialog_fix_update_button \
        $dialog_git_checkout_button \
        $dialog_update_remote_checkout_button \
        "7" "返回" \
        3>&1 1>&2 2>&3)
    if [ $? = 0 ];then
        if [ $final_operate_comfyui_custom_node = 1 ]; then
            echo "更新$(echo $comfyui_custom_node_selection | awk -F "/" '{print $NF}')自定义节点中"
            git pull
            if [ $? = "0" ];then
                dialog --clear --title "ComfyUI选项" --backtitle "ComfyUI自定义节点更新结果" --ok-label "确认" --msgbox ""$comfyui_custom_node_selection"自定义节点更新成功" 23 70
            else
                dialog --clear --title "ComfyUI选项" --backtitle "ComfyUI自定义节点更新结果" --ok-label "确认" --msgbox ""$comfyui_custom_node_selection"自定义节点更新失败" 23 70
            fi
        elif [ $final_operate_comfyui_custom_node = 2 ]; then #comfyui并不像a1111-sd-webui自动为插件安装依赖,所以只能手动装
            cd "$start_path/ComfyUI"
            enter_venv
            cd -
            dep_info="" #清除上次运行结果

            if [ -f "./install.py" ] || [ -f "./requirements.txt" ];then
                echo "安装$(echo $comfyui_custom_node_selection | awk -F "/" '{print $NF}')自定义节点依赖"
                dep_info="$dep_info\n $(echo $comfyui_custom_node_selection | awk -F "/" '{print $NF}')自定义节点:\n" #作为显示安装结果信息
            fi

            if [ -f "./install.py" ];then #找到install.py文件
                $python_cmd install.py
                if [ $? = 0 ];then #记录退出状态
                    dep_info="$dep_info     run install.py:成功\n"
                else
                    dep_info="$dep_info     run install.py:失败\n"
                fi
            fi

            if [ -f "./requirements.txt" ];then #找到requirement.txt文件
                pip install -r requirements.txt
                if [ $? = 0 ];then #记录退出状态
                    dep_info="$dep_info     install requirements.txt:成功\n"
                else
                    dep_info="$dep_info     install requirements.txt:失败\n"
                fi
            fi

            exit_venv
            dialog --clear --title "ComfyUI选项" --backtitle "ComfyUI自定义节点依赖安装结果" --ok-label "确认" --msgbox "当前依赖的安装情况列表\n------------------------------------------------------------------\n$dep_info------------------------------------------------------------------" 23 70
        elif [ $final_operate_comfyui_custom_node = 3 ]; then
            if (dialog --clear --title "ComfyUI选项" --backtitle "ComfyUI自定义节点删除选项" --yes-label "是" --no-label "否" --yesno "是否删除"$comfyui_custom_node_selection"自定义节点?" 23 70) then
                echo "删除$(echo $comfyui_custom_node_selection | awk -F "/" '{print $NF}')自定义节点中"
                cd ..
                rm -rf ./$comfyui_custom_node_selection
            fi
        elif [ $final_operate_comfyui_custom_node = 4 ]; then
            echo "修复更新中"
            term_sd_fix_pointer_offset
        elif [ $final_operate_comfyui_custom_node = 5 ]; then
            git_checkout_manager
        elif [ $final_operate_comfyui_custom_node = 6 ]; then
            select_repo_single
        elif [ $final_operate_comfyui_custom_node = 7 ]; then
            cd ..
        fi
    fi
}

#comfyui后端插件管理
#插件的安装或管理选项(该部分最先被调用)
function comfyui_extension_methon()
{
    cd "$start_path/ComfyUI/web/extensions" #回到最初路径
    #功能选择界面
    final_comfyui_extension_methon=$(
        dialog --clear --title "ComfyUI管理" --backtitle "ComfyUI插件管理选项" --ok-label "确认" --cancel-label "取消" --menu "请选择ComfyUI插件管理选项的功能" 23 70 12 \
        "1" "安装" \
        "2" "管理" \
        "3" "更新全部插件" \
        "4" "安装全部插件依赖" \
        "5" "返回" \
        3>&1 1>&2 2>&3 )

    if [ $? = 0 ];then
        if [ $final_comfyui_extension_methon = 1 ]; then #选择安装
            comfyui_extension_install
            comfyui_extension_methon
        elif [ $final_comfyui_extension_methon = 2 ]; then #选择管理
            comfyui_extension_manager
            comfyui_extension_methon
        elif [ $final_comfyui_extension_methon = 3 ]; then #选择更新全部插件
            extension_all_update
            comfyui_extension_methon
        elif [ $final_comfyui_extension_methon = 4 ]; then #选择安装全部插件依赖
            comfyui_extension_dep_install
            comfyui_extension_methon
        elif [ $final_comfyui_extension_methon = 5 ]; then #选择返回
            echo
        fi
    fi
}

#插件管理界面
function comfyui_extension_manager()
{
    cd "$start_path/ComfyUI/web/extensions" #回到最初路径
    dir_list=$(ls -l --time-style=+"%Y-%m-%d" | awk -F ' ' ' { print $7 " " $6 } ') #当前目录文件和文件夹信息

    comfyui_extension_selection=$(
        dialog --clear --ok-label "确认" --cancel-label "取消" --title "ComfyUI管理" --backtitle "ComfyUI插件列表" \
        --menu "使用上下键选择要操作的插件并回车确认" 23 70 12 \
        $dir_list \
        3>&1 1>&2 2>&3)
    if [ $? = 0 ];then
        if [ -d "$comfyui_extension_selection" ]; then  # 选择文件夹
            if [ ! "$comfyui_extension_selection" = "core" ];then #排除掉core文件夹
                cd "$comfyui_extension_selection"
                operate_comfyui_extension #调用operate_comfyui_extension函数处理插件
            fi
            comfyui_extension_manager
        elif [ -f "$extension_selection" ]; then
            comfyui_extension_manager #留在当前目录
        else
            comfyui_extension_manager #留在当前目录
        fi
    fi
}

#插件安装模块
function comfyui_extension_install()
{
    comfyui_extension_address=$(dialog --clear --title "ComfyUI管理" --backtitle "ComfyUI插件安装选项" --ok-label "确认" --cancel-label "取消" --inputbox "输入插件的github地址或其他下载地址" 23 70 3>&1 1>&2 2>&3)

    if [ ! -z $comfyui_extension_address ]; then
        echo "安装$(echo $comfyui_extension_address | awk -F'/' '{print $NF}')中"
        git clone $comfyui_extension_address
        git_req=$?
        comfyui_extension_dep_notice=""
        if [ -f "./$(awk -F "/" '{print $NF}' <<< "$comfyui_extension_address")/requirements.txt" ];then
            comfyui_extension_dep_notice="检测到该插件需要安装依赖,请进入插件管理功能,选中该插件,运行一次\"安装依赖\"功能"
        elif [ -f "./$(awk -F "/" '{print $NF}' <<< "$comfyui_extension_address")/install.py" ];then
            comfyui_extension_dep_notice="检测到该插件需要安装依赖,请进入插件管理功能,选中该插件,运行一次\"安装依赖\"功能"
        fi

        if [ $git_req = 0 ];then
            dialog --clear --title "ComfyUI管理" --backtitle "ComfyUI插件安装结果" --ok-label "确认" --msgbox "$(echo $comfyui_extension_address | awk -F'/' '{print $NF}')插件安装成功\n$comfyui_extension_dep_notice" 23 70
        else
            dialog --clear --title "ComfyUI管理" --backtitle "ComfyUI插件安装结果" --ok-label "确认" --msgbox "$(echo $comfyui_extension_address | awk -F'/' '{print $NF}')插件安装失败" 23 70
        fi
    fi
}

#插件处理模块
function operate_comfyui_extension() 
{
    #当git在子文件夹中找不到.git文件夹时,将会自动在父文件夹中寻找,以此类推,直到找到.git文件夹。用户的安装方式可能是直接下载源码压缩包,导致安装后的文件夹没有.git文件夹,直接执行git会导致不良的后果   
    if [ -d "./.git" ];then #检测目录中是否有.git文件夹
        dialog_update_button=""1" "更新""
        dialog_fix_update_button=""4" "修复更新""
        dialog_git_checkout_button=""5" "版本切换""
        dialog_update_remote_checkout_button=""6" "更新源切换"" 
    else
        dialog_update_button=""
        dialog_fix_update_button=""
        dialog_git_checkout_button=""
        dialog_update_remote_checkout_button=""
    fi

    final_operate_comfyui_extension=$(
        dialog --clear --title "ComfyUI管理" --backtitle "ComfyUI插件管理选项" --ok-label "确认" --cancel-label "取消" --menu "请选择对"$comfyui_extension_selection"自定义节点的管理功能\n当前更新源:$([ -d "./.git" ] && git remote -v | awk 'NR==1' | awk '{print $2}' || echo "无")" 23 70 12 \
        $dialog_update_button \
        "2" "安装依赖" \
        "3" "卸载" \
        $dialog_fix_update_button \
        $dialog_git_checkout_button \
        $dialog_update_remote_checkout_button \
        "6" "返回" \
        3>&1 1>&2 2>&3)

    if [ $? = 0 ];then
        if [ $final_operate_comfyui_extension = 1 ]; then
            echo "更新"$comfyui_extension_selection"中"
            git pull
            if [ $? = 0 ];then
                dialog --clear --title "ComfyUI管理" --backtitle "ComfyUI插件更新结果" --ok-label "确认" --msgbox ""$comfyui_extension_selection"插件更新成功" 23 70
            else
                dialog --clear --title "ComfyUI管理" --backtitle "ComfyUI插件更新结果" --ok-label "确认" --msgbox ""$comfyui_extension_selection"插件更新失败" 23 70
            fi
        elif [ $final_operate_comfyui_extension = 2 ]; then #comfyui并不像a1111-sd-webui自动为插件安装依赖,所以只能手动装
            cd "$start_path/ComfyUI"
            enter_venv
            cd -
            dep_info="" #清除上次运行结果

            if [ -f "./install.py" ] || [ -f "./requirements.txt" ];then
                echo "安装$(echo $comfyui_extension_selection | awk -F "/" '{print $NF}')插件依赖"
                dep_info="$dep_info\n $(echo $comfyui_extension_selection | awk -F "/" '{print $NF}')插件:\n" #作为显示安装结果信息
            fi

            if [ -f "./install.py" ];then #找到install.py文件
                $python_cmd install.py
                if [ $? = 0 ];then #记录退出状态
                    dep_info="$dep_info     run install.py:成功\n"
                else
                    dep_info="$dep_info     run install.py:失败\n"
                fi
            fi

            if [ -f "./requirements.txt" ];then #找到requirement.txt文件
                pip install -r requirements.txt
                if [ $? = 0 ];then #记录退出状态
                    dep_info="$dep_info     install requirements.txt:成功\n"
                else
                    dep_info="$dep_info     install requirements.txt:失败\n"
                fi
            fi

            exit_venv
            dialog --clear --title "ComfyUI管理" --backtitle "ComfyUI插件依赖安装结果" --ok-label "确认" --msgbox "当前依赖的安装情况列表\n------------------------------------------------------------------\n$dep_info------------------------------------------------------------------" 23 70
        elif [ $final_operate_comfyui_extension = 3 ]; then
            if (dialog --clear --title "ComfyUI管理" --backtitle "ComfyUI插件删除选项" --yes-label "是" --no-label "否" --yesno "是否删除"$comfyui_extension_selection"插件?" 23 70) then
                echo "删除$(echo $comfyui_extension_selection | awk -F "/" '{print $NF}')插件中"
                cd ..
                rm -rf ./$comfyui_extension_selection
            fi
        elif [ $final_operate_comfyui_extension = 4 ]; then
            echo "修复更新中"
            term_sd_fix_pointer_offset
        elif [ $final_operate_comfyui_extension = 5 ]; then
            git_checkout_manager
        elif [ $final_operate_comfyui_extension = 6 ]; then
            select_repo_single
        elif [ $final_operate_comfyui_extension = 7 ]; then
            cd ..
        fi
    fi
}

#comfyui插件/自定义节点依赖一键安装部分
function comfyui_extension_dep_install()
{
    proxy_option #代理选择
    pip_install_methon #安装方式选择
    final_install_check #安装前确认
    if [ $final_install_check_exec = 0 ];then
        print_word_to_shell="$term_sd_manager_info 插件/自定义节点依赖一键安装"
        print_line_to_shell
        tmp_disable_proxy
        cd "$start_path/ComfyUI"
        enter_venv
        cd -
        dep_info="" #清除上次运行结果
        extension_dep_to_install="0"
        extension_dep_to_install_="0"

        for extension_folder in ./* ;do #统计需要安装的依赖
            [ -f "$extension_folder" ] && continue #排除文件
            if [ -f "./$extension_folder/install.py" ] || [ -f "./$extension_folder/requirements.txt" ];then
                extension_dep_to_install=$(( $extension_dep_to_install + 1 ))
            fi
        done

        for extension_folder in ./*
        do
            [ -f "$extension_folder" ] && continue #排除文件
            cd $extension_folder
            if [ -f "./install.py" ] || [ -f "./requirements.txt" ];then
                extension_dep_to_install_=$(( $extension_dep_to_install_ + 1 ))
                echo "[$extension_dep_to_install_/$extension_dep_to_install] 安装$(echo $extension_folder | awk -F "/" '{print $NF}')依赖"
                dep_info="$dep_info $(echo $extension_folder | awk -F "/" '{print $NF}'):\n" #作为显示安装结果信息
            fi

            if [ -f "./install.py" ];then #找到install.py文件
                $python_cmd install.py
                if [ $? = 0 ];then #记录退出状态
                    dep_info="$dep_info     run install.py:成功\n"
                else
                    dep_info="$dep_info     run install.py:失败\n"
                fi
            fi

            if [ -f "./requirements.txt" ];then #找到requirement.txt文件
                pip install -r requirements.txt
                if [ $? = 0 ];then #记录退出状态
                    dep_info="$dep_info     install requirements.txt:成功\n"
                else
                    dep_info="$dep_info     install requirements.txt:失败\n"
                fi
            fi
            cd ..
        done
        exit_venv
        tmp_enable_proxy
        print_line_to_shell
        dialog --clear --title "ComfyUI管理" --backtitle "ComfyUI插件/自定义节点依赖安装结果" --ok-label "确认" --msgbox "当前依赖的安装情况列表\n------------------------------------------------------------------\n$dep_info------------------------------------------------------------------" 23 70
    fi
}
