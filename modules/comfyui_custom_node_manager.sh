#!/bin/bash

#comfyui前端节点管理
#自定义节点的安装或管理选项(该部分最先被调用)
function comfyui_custom_node_methon()
{
    cd "$start_path/ComfyUI/custom_nodes" #回到最初路径
    #功能选择界面
    comfyui_custom_node_methon_dialog=$(
        dialog --erase-on-exit --title "ComfyUI管理" --backtitle "ComfyUI自定义节点管理选项" --ok-label "确认" --cancel-label "取消" --menu "请选择ComfyUI自定义节点管理选项的功能" 25 80 10 \
        "1" "安装" \
        "2" "管理" \
        "3" "更新全部自定义节点" \
        "4" "安装全部自定义节点依赖" \
        "5" "返回" \
        3>&1 1>&2 2>&3 )

    if [ $? = 0 ];then
        case $comfyui_custom_node_methon_dialog in
            1) #选择安装
                comfyui_custom_node_install
                comfyui_custom_node_methon
                ;;
            2) #选择管理
                comfyui_custom_node_manager
                comfyui_custom_node_methon
                ;;
            3) #选择更新全部自定义节点
                extension_all_update
                comfyui_custom_node_methon
                ;;
            4) #选择安装全部插件依赖
                comfyui_extension_depend_install
                comfyui_custom_node_methon
                ;;
        esac
    fi
}

#自定义节点管理界面
function comfyui_custom_node_manager()
{
    cd "$start_path/ComfyUI/custom_nodes" #回到最初路径
    dir_list=$(ls -l --time-style=+"%Y-%m-%d" | awk -F ' ' ' { print $7 " " $6 } ') #当前目录文件和文件夹信息

    comfyui_custom_node_selection=$(
        dialog --erase-on-exit --yes-label "确认" --no-label "取消" --title "ComfyUI管理" --backtitle "ComfyUI自定义节点列表" --menu "使用上下键选择要操作的插件并回车确认" 25 80 10 \
        "-->返回<--" "<---------" \
        $dir_list \
        3>&1 1>&2 2>&3)

    if [ $? = 0 ];then
        if [ $comfyui_custom_node_selection = "-->返回<--" ];then
            echo
        elif [ -d "$comfyui_custom_node_selection" ]; then  # 选择文件夹
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
    comfyui_custom_node_address=$(dialog --erase-on-exit --title "ComfyUI管理" --backtitle "ComfyUI自定义节点安装选项" --ok-label "确认" --cancel-label "取消" --inputbox "输入自定义节点的github地址或其他下载地址" 25 80 3>&1 1>&2 2>&3)

    if [ ! -z $comfyui_custom_node_address ]; then
        term_sd_notice "安装$(echo $comfyui_custom_node_address | awk -F'/' '{print $NF}')中"
        git clone --recurse-submodules $comfyui_custom_node_address
        git_req=$?
        comfyui_custom_node_dep_notice=""
        if [ -f "./$(awk -F "/" '{print $NF}' <<< "$comfyui_custom_node_address")/requirements.txt" ] || [ -f "./$(awk -F "/" '{print $NF}' <<< "$comfyui_custom_node_address")/install.py" ];then
            comfyui_custom_node_dep_notice="检测到该自定义节点需要安装依赖,请进入自定义节点管理功能,选中该自定义节点,运行一次\"安装依赖\"功能"
        fi

        if [ $git_req = 0 ];then
            dialog --erase-on-exit --title "ComfyUI管理" --backtitle "ComfyUI自定义节点安装结果" --ok-label "确认" --msgbox "$(echo $comfyui_custom_node_address | awk -F'/' '{print $NF}')自定义节点安装成功\n$comfyui_custom_node_dep_notice" 25 80
        else
            dialog --erase-on-exit --title "ComfyUI管理" --backtitle "ComfyUI自定义节点安装结果" --ok-label "确认" --msgbox "$(echo $comfyui_custom_node_address | awk -F'/' '{print $NF}')自定义节点安装失败" 25 80
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

    operate_comfyui_custom_node_dialog=$(
        dialog --erase-on-exit --title "ComfyUI选项" --backtitle "ComfyUI自定义节点管理选项" --ok-label "确认" --cancel-label "取消" --menu "请选择对"$comfyui_custom_node_selection"自定义节点的管理功能\n当前更新源:$([ -d "./.git" ] && git remote -v | awk 'NR==1 {print $2}' || echo "无")" 25 80 10 \
        $dialog_update_button \
        "2" "安装依赖" \
        "3" "卸载" \
        $dialog_fix_update_button \
        $dialog_git_checkout_button \
        $dialog_update_remote_checkout_button \
        "7" "返回" \
        3>&1 1>&2 2>&3)

    if [ $? = 0 ];then
        case $operate_comfyui_custom_node_dialog in
            1)
                term_sd_notice "更新$(echo $comfyui_custom_node_selection | awk -F "/" '{print $NF}')自定义节点中"
                cmd_daemon git pull --recurse-submodules
                if [ $? = "0" ];then
                    dialog --erase-on-exit --title "ComfyUI选项" --backtitle "ComfyUI自定义节点更新结果" --ok-label "确认" --msgbox ""$comfyui_custom_node_selection"自定义节点更新成功" 25 80
                else
                    dialog --erase-on-exit --title "ComfyUI选项" --backtitle "ComfyUI自定义节点更新结果" --ok-label "确认" --msgbox ""$comfyui_custom_node_selection"自定义节点更新失败" 25 80
                fi
                operate_comfyui_custom_node
                ;;
            2) #comfyui并不像a1111-sd-webui自动为插件安装依赖,所以只能手动装
                comfyui_extension_depend_install_single
                operate_comfyui_custom_node
                ;;
            3)
                if (dialog --erase-on-exit --title "ComfyUI选项" --backtitle "ComfyUI自定义节点删除选项" --yes-label "是" --no-label "否" --yesno "是否删除"$comfyui_custom_node_selection"自定义节点?" 25 80) then
                    term_sd_notice "请再次确认是否删除$(echo $comfyui_custom_node_selection | awk -F "/" '{print $NF}')(yes/no)?"
                    term_sd_notice "警告:该操作将永久删除$(echo $comfyui_custom_node_selection | awk -F "/" '{print $NF}')"
                    term_sd_notice "提示:输入yes或no后回车"
                    term_sd_remove_repository_option=""
                    read -p "===============================> " term_sd_remove_repository_option
                    case $term_sd_remove_repository_option in
                        yes|y|YES|Y)
                            term_sd_notice "删除$(echo $comfyui_custom_node_selection | awk -F "/" '{print $NF}')自定义节点中"
                            cd ..
                            rm -rf ./$comfyui_custom_node_selection
                            term_sd_notice "删除$(echo $comfyui_custom_node_selection | awk -F "/" '{print $NF}')自定义节点完成"
                            ;;
                        *)
                            term_sd_notice "取消删除操作"
                            operate_comfyui_custom_node
                            ;;
                    esac
                else
                    term_sd_notice "取消删除操作"
                    operate_comfyui_custom_node
                fi
                ;;
            4)
                term_sd_fix_pointer_offset
                operate_comfyui_custom_node
                ;;
            5)
                git_checkout_manager
                operate_comfyui_custom_node
                ;;
            6)
                select_repo_single
                operate_comfyui_custom_node
                ;;
        esac
    fi
}