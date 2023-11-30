#!/bin/bash

# comfyui的扩展分为两种,一种是前端节点,另一种是后端扩展(少见).详见:https://github.com/comfyanonymous/ComfyUI/discussions/631
# 插件管理器
comfyui_extension_manager()
{
    local comfyui_extension_manager_dialog
    cd "$start_path/ComfyUI/web/extensions" # 回到最初路径

    comfyui_extension_manager_dialog=$(
        dialog --erase-on-exit --notags --title "ComfyUI管理" --backtitle "ComfyUI插件管理选项" --ok-label "确认" --cancel-label "取消" --menu "请选择ComfyUI插件管理选项的功能" $term_sd_dialog_height $term_sd_dialog_width $term_sd_dialog_menu_height \
        "0" "> 返回" \
        "1" "> 安装插件" \
        "2" "> 管理插件" \
        "3" "> 更新全部插件" \
        "4" "> 安装全部插件依赖" \
        3>&1 1>&2 2>&3 )

    if [ $? = 0 ];then
        case $comfyui_extension_manager_dialog in
            1) # 选择安装
                comfyui_extension_install
                comfyui_extension_manager
                ;;
            2) # 选择管理
                comfyui_extension_list
                comfyui_extension_manager
                ;;
            3) # 选择更新全部插件
                update_all_extension
                comfyui_extension_manager
                ;;
            4) # 选择安装全部插件依赖
                comfyui_extension_depend_install
                comfyui_extension_manager
                ;;
        esac
    fi
}

# 插件列表浏览器
comfyui_extension_list()
{
    cd "$start_path/ComfyUI/web/extensions" # 回到最初路径

    comfyui_extension_name=$(
        dialog --erase-on-exit --ok-label "确认" --cancel-label "取消" --title "ComfyUI管理" --backtitle "ComfyUI插件列表" --menu "使用上下键选择要操作的插件并回车确认" $term_sd_dialog_height $term_sd_dialog_width $term_sd_dialog_menu_height \
        "-->返回<--" "<---------" \
        $(ls -l --time-style=+"%Y-%m-%d" | awk -F ' ' ' { print $7 " " $6 } ') \
        3>&1 1>&2 2>&3)

    if [ $? = 0 ];then
        if [ $comfyui_extension_name = "-->返回<--" ];then
            echo
        elif [ -d "$comfyui_extension_name" ];then  # 选择文件夹
            if [ ! "$comfyui_extension_name" = "core" ];then # 排除掉core文件夹
                cd "$comfyui_extension_name"
                comfyui_extension_interface
            fi
            comfyui_extension_list
        elif [ -f "$extension_selection" ];then
            comfyui_extension_list # 留在当前目录
        else
            comfyui_extension_list # 留在当前目录
        fi
    fi
}

# 插件安装
comfyui_extension_install()
{
    local comfyui_extension_url
    local comfyui_extension_dep_notice
    local git_req

    comfyui_extension_url=$(dialog --erase-on-exit --title "ComfyUI管理" --backtitle "ComfyUI插件安装选项" --ok-label "确认" --cancel-label "取消" --inputbox "输入插件的github地址或其他下载地址" $term_sd_dialog_height $term_sd_dialog_width 3>&1 1>&2 2>&3)

    if [ ! -z $comfyui_extension_url ]; then
        term_sd_echo "安装$(echo $comfyui_extension_url | awk -F'/' '{print $NF}')插件中"
        term_sd_watch git clone --recurse-submodules $comfyui_extension_url
        git_req=$?
        
        if [ -f "./$(awk -F "/" '{print $NF}' <<< "$comfyui_extension_url")/requirements.txt" ] || [ -f "./$(awk -F "/" '{print $NF}' <<< "$comfyui_extension_url")/install.py" ];then
            comfyui_extension_dep_notice="检测到该插件需要安装依赖,请进入插件管理功能,选中该插件,运行一次\"安装依赖\"功能"
        fi

        if [ $git_req = 0 ];then
            dialog --erase-on-exit --title "ComfyUI管理" --backtitle "ComfyUI插件安装结果" --ok-label "确认" --msgbox "$(echo $comfyui_extension_url | awk -F'/' '{print $NF}')插件安装成功\n$comfyui_extension_dep_notice" $term_sd_dialog_height $term_sd_dialog_width
        else
            dialog --erase-on-exit --title "ComfyUI管理" --backtitle "ComfyUI插件安装结果" --ok-label "确认" --msgbox "$(echo $comfyui_extension_url | awk -F'/' '{print $NF}')插件安装失败" $term_sd_dialog_height $term_sd_dialog_width
        fi
    fi
}

# 插件管理
comfyui_extension_interface() 
{
    local comfyui_extension_interface_dialog

    comfyui_extension_interface_dialog=$(
        dialog --erase-on-exit --notags --title "ComfyUI管理" --backtitle "ComfyUI插件管理选项" --ok-label "确认" --cancel-label "取消" --menu "请选择对${comfyui_extension_name}插件的管理功能\n当前更新源:$(git_remote_display)\n当前分支:$(git_branch_display)" $term_sd_dialog_height $term_sd_dialog_width $term_sd_dialog_menu_height \
        "0" "> 返回" \
        "1" "> 更新" \
        "2" "> 修复更新" \
        "3" "> 安装依赖" \
        "4" "> 版本切换" \
        "5" "> 更新源切换" \
        "6" "> 卸载" \
        3>&1 1>&2 2>&3)

    case $comfyui_extension_interface_dialog in
        1)
            term_sd_echo "更新${comfyui_extension_name}插件中"
            git_pull_repository
            case $? in
                0)
                    dialog --erase-on-exit --title "ComfyUI管理" --backtitle "ComfyUI自定义节点更新结果" --ok-label "确认" --msgbox "${comfyui_extension_name}插件更新成功" $term_sd_dialog_height $term_sd_dialog_width
                    ;;
                10)
                    dialog --erase-on-exit --title "ComfyUI管理" --backtitle "ComfyUI自定义节点更新结果" --ok-label "确认" --msgbox "${comfyui_extension_name}插件非git安装,无法更新" $term_sd_dialog_height $term_sd_dialog_width
                    ;;
                *)
                    dialog --erase-on-exit --title "ComfyUI管理" --backtitle "ComfyUI自定义节点更新结果" --ok-label "确认" --msgbox "${comfyui_extension_name}插件更新失败" $term_sd_dialog_height $term_sd_dialog_width
                    ;;
            esac
            comfyui_extension_interface
            ;;
        2)
            git_fix_pointer_offset
            [ $? = 10 ] && dialog --erase-on-exit --title "ComfyUI管理" --backtitle "ComfyUI自定义节点修复更新" --ok-label "确认" --msgbox "${comfyui_extension_name}插件非git安装,无法修复更新" $term_sd_dialog_height $term_sd_dialog_width
            comfyui_extension_interface
            ;;
        3) #comfyui并不像a1111-sd-webui自动为插件安装依赖,所以只能手动装
            comfyui_extension_depend_install_single "插件"
            comfyui_extension_interface
            ;;
        5)
            git_ver_switch
            [ $? = 10 ] && dialog --erase-on-exit --title "ComfyUI管理" --backtitle "ComfyUI自定义节点版本切换" --ok-label "确认" --msgbox "${comfyui_extension_name}插件非git安装,无法进行版本切换" $term_sd_dialog_height $term_sd_dialog_width
            comfyui_extension_interface
            ;;
        6)
            git_remote_url_select_single
            [ $? = 10 ] && dialog --erase-on-exit --title "ComfyUI管理" --backtitle "ComfyUI自定义节点更新源切换" --ok-label "确认" --msgbox "${comfyui_extension_name}插件非git安装,无法进行更新源切换" $term_sd_dialog_height $term_sd_dialog_width
            comfyui_extension_interface
            ;;
        6)
            if (dialog --erase-on-exit --title "ComfyUI管理" --backtitle "ComfyUI插件删除选项" --yes-label "是" --no-label "否" --yesno "是否删除${comfyui_extension_name}插件?" $term_sd_dialog_height $term_sd_dialog_width) then
                term_sd_echo "请再次确认是否删除$(echo $comfyui_extension_name | awk -F "/" '{print $NF}')(yes/no)?"
                term_sd_echo "警告:该操作将永久删除$(echo $comfyui_extension_name | awk -F "/" '{print $NF}')"
                term_sd_echo "提示:输入yes或no后回车"
                case $(term_sd_read) in
                    yes|y|YES|Y)
                        term_sd_echo "删除$(echo $comfyui_extension_name | awk -F "/" '{print $NF}')插件中"
                        cd ..
                        rm -rf ./$comfyui_extension_name
                        term_sd_echo "删除$(echo $comfyui_extension_name | awk -F "/" '{print $NF}')插件完成"
                        ;;
                    *)
                        term_sd_echo "取消删除操作"
                        comfyui_extension_interface
                        ;;
                esac
            else
                term_sd_echo "取消删除操作"
                comfyui_extension_interface
            fi
            ;;
    esac
}