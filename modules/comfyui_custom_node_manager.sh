#!/bin/bash

# 自定义节点管理器
comfyui_custom_node_manager()
{
    local comfyui_custom_node_manager_dialog
    cd "$comfyui_path"/custom_nodes # 回到最初路径

    comfyui_custom_node_manager_dialog=$(
        dialog --erase-on-exit --notags --title "ComfyUI管理" --backtitle "ComfyUI自定义节点管理选项" --ok-label "确认" --cancel-label "取消" --menu "请选择ComfyUI自定义节点管理选项的功能" $term_sd_dialog_height $term_sd_dialog_width $term_sd_dialog_menu_height \
        "0" "> 返回" \
        "1" "> 安装自定义节点" \
        "2" "> 管理自定义节点" \
        "3" "> 更新全部自定义节点" \
        "4" "> 安装全部自定义节点依赖" \
        3>&1 1>&2 2>&3 )

    case $comfyui_custom_node_manager_dialog in
        1) # 选择安装
            comfyui_custom_node_install
            comfyui_custom_node_manager
            ;;
        2) # 选择管理
            comfyui_custom_node_list
            comfyui_custom_node_manager
            ;;
        3) # 选择更新全部自定义节点
            update_all_extension
            comfyui_custom_node_manager
            ;;
        4) # 选择安装全部自定义节点依赖
            comfyui_extension_depend_install
            comfyui_custom_node_manager
            ;;
    esac
}

# 自定义节点安装
comfyui_custom_node_install()
{
    local comfyui_custom_node_url
    local comfyui_custom_node_dep_notice
    local git_req

    comfyui_custom_node_url=$(dialog --erase-on-exit --title "ComfyUI管理" --backtitle "ComfyUI自定义节点安装选项" --ok-label "确认" --cancel-label "取消" --inputbox "输入自定义节点的github地址或其他下载地址" $term_sd_dialog_height $term_sd_dialog_width 3>&1 1>&2 2>&3)

    if [ ! -z "$comfyui_custom_node_url" ]; then
        term_sd_echo "安装$(basename "$comfyui_custom_node_url")自定义节点中"
        term_sd_watch git clone --recurse-submodules $comfyui_custom_node_url
        git_req=$?
        
        if [[[ -f "$(awk -F "/" '{print $NF}' <<< "$comfyui_custom_node_url")/requirements.txt" ] || [ -f "$(awk -F "/" '{print $NF}' <<< "$comfyui_custom_node_url")/install.py" ]]];then
            comfyui_custom_node_dep_notice="检测到该自定义节点需要安装依赖,请进入自定义节点管理功能,选中该自定义节点,运行一次"安装依赖"功能"
        fi

        if [ $git_req = 0 ];then
            dialog --erase-on-exit --title "ComfyUI管理" --backtitle "ComfyUI自定义节点安装结果" --ok-label "确认" --msgbox "$(basename "$comfyui_custom_node_url")自定义节点安装成功\n$comfyui_custom_node_dep_notice" $term_sd_dialog_height $term_sd_dialog_width
        else
            dialog --erase-on-exit --title "ComfyUI管理" --backtitle "ComfyUI自定义节点安装结果" --ok-label "确认" --msgbox "$(basename "$comfyui_custom_node_url")自定义节点安装失败" $term_sd_dialog_height $term_sd_dialog_width
        fi
    fi
}

# 自定义节点浏览器
comfyui_custom_node_list()
{
    cd "$comfyui_path"/custom_nodes # 回到最初路径

    comfyui_custom_node_name=$(
        dialog --erase-on-exit --yes-label "确认" --no-label "取消" --title "ComfyUI管理" --backtitle "ComfyUI自定义节点列表" --menu "使用上下键选择要操作的自定义节点并回车确认" $term_sd_dialog_height $term_sd_dialog_width $term_sd_dialog_menu_height \
        "-->返回<--" "<---------" \
        $(ls -l --time-style=+"%Y-%m-%d" | awk -F ' ' ' { print $7 " " $6 } ') \
        3>&1 1>&2 2>&3)

    if [ $? = 0 ];then
        if [ $comfyui_custom_node_name = "-->返回<--" ];then
            echo
        elif [ -d "$comfyui_custom_node_name" ]; then  # 选择文件夹
            cd "$comfyui_custom_node_name"
            comfyui_custom_node_interface
            comfyui_custom_node_list
        elif [ -f "$extension_selection" ]; then
            comfyui_custom_node_list # 留在当前目录
        else
            comfyui_custom_node_list # 留在当前目录
        fi
    fi
}


# 自定义节点管理
comfyui_custom_node_interface() 
{
    local comfyui_custom_node_interface_dialog

    comfyui_custom_node_interface_dialog=$(
        dialog --erase-on-exit --notags --title "ComfyUI选项" --backtitle "ComfyUI自定义节点管理选项" --ok-label "确认" --cancel-label "取消" --menu "请选择对${comfyui_custom_node_name}自定义节点的管理功能\n当前更新源:$(git_remote_display)\n当前分支:$(git_branch_display)" $term_sd_dialog_height $term_sd_dialog_width $term_sd_dialog_menu_height \
        "0" "> 返回" \
        "1" "> 更新" \
        "2" "> 修复更新" \
        "3" "> 安装依赖" \
        "4" "> 版本切换" \
        "5" "> 更新源切换" \
        "6" "> 卸载" \
        3>&1 1>&2 2>&3)

    case $comfyui_custom_node_interface_dialog in
        1)
            term_sd_echo "更新$(echo $comfyui_custom_node_name | awk -F "/" '{print $NF}')自定义节点中"
            git_pull_repository
            case $? in
                0)
                    dialog --erase-on-exit --title "ComfyUI管理" --backtitle "ComfyUI自定义节点更新结果" --ok-label "确认" --msgbox "${comfyui_custom_node_name}自定义节点更新成功" $term_sd_dialog_height $term_sd_dialog_width
                    ;;
                10)
                    dialog --erase-on-exit --title "ComfyUI管理" --backtitle "ComfyUI自定义节点更新结果" --ok-label "确认" --msgbox "${comfyui_custom_node_name}自定义节点非git安装,无法更新" $term_sd_dialog_height $term_sd_dialog_width
                    ;;
                *)
                    dialog --erase-on-exit --title "ComfyUI管理" --backtitle "ComfyUI自定义节点更新结果" --ok-label "确认" --msgbox "${comfyui_custom_node_name}自定义节点更新失败" $term_sd_dialog_height $term_sd_dialog_width
                    ;;
            esac
            comfyui_custom_node_interface
            ;;
        2)
            git_fix_pointer_offset
            [ $? = 10 ] && dialog --erase-on-exit --title "ComfyUI管理" --backtitle "ComfyUI自定义节点修复更新" --ok-label "确认" --msgbox "${comfyui_custom_node_name}自定义节点非git安装,无法修复更新" $term_sd_dialog_height $term_sd_dialog_width
            comfyui_custom_node_interface
            ;;
        3) # comfyui并不像a1111-sd-webui自动为插件安装依赖,所以只能手动装
            comfyui_extension_depend_install_single "自定义节点"
            comfyui_custom_node_interface
            ;;
        4)
            git_ver_switch
            [ $? = 10 ] && dialog --erase-on-exit --title "ComfyUI管理" --backtitle "ComfyUI自定义节点版本切换" --ok-label "确认" --msgbox "${comfyui_custom_node_name}自定义节点非git安装,无法进行版本切换" $term_sd_dialog_height $term_sd_dialog_width
            comfyui_custom_node_interface
            ;;
        5)
            git_remote_url_select_single
            [ $? = 10 ] && dialog --erase-on-exit --title "ComfyUI管理" --backtitle "ComfyUI自定义节点更新源切换" --ok-label "确认" --msgbox "${comfyui_custom_node_name}自定义节点非git安装,无法进行更新源切换" $term_sd_dialog_height $term_sd_dialog_width
            comfyui_custom_node_interface
            ;;
        6)
            if (dialog --erase-on-exit --title "ComfyUI选项" --backtitle "ComfyUI自定义节点删除选项" --yes-label "是" --no-label "否" --yesno "是否删除${comfyui_custom_node_name}自定义节点?" $term_sd_dialog_height $term_sd_dialog_width) then
                term_sd_echo "请再次确认是否删除$(basename "$comfyui_custom_node_name")(yes/no)?"
                term_sd_echo "警告:该操作将永久删除$(basename "$comfyui_custom_node_name")"
                term_sd_echo "提示:输入yes或no后回车"
                case $(term_sd_read) in
                    yes|y|YES|Y)
                        term_sd_echo "删除$(basename "$comfyui_custom_node_name")自定义节点中"
                        cd ..
                        rm -rf "$comfyui_custom_node_name"
                        term_sd_echo "删除$(basename "$comfyui_custom_node_name")自定义节点完成"
                        ;;
                    *)
                        term_sd_echo "取消删除操作"
                        comfyui_custom_node_interface
                        ;;
                esac
            else
                term_sd_echo "取消删除操作"
                comfyui_custom_node_interface
            fi
            ;;
    esac
}