#!/bin/bash

#comfyui
#comfyui的扩展分为两种,一种是前端节点,另一种是后端扩展.详见:https://github.com/comfyanonymous/ComfyUI/discussions/631

#comfyui后端插件管理
#插件的安装或管理选项(该部分最先被调用)
function comfyui_extension_methon()
{
    cd "$start_path/ComfyUI/web/extensions" #回到最初路径
    #功能选择界面
    comfyui_extension_methon_dialog=$(
        dialog --erase-on-exit --title "ComfyUI管理" --backtitle "ComfyUI插件管理选项" --ok-label "确认" --cancel-label "取消" --menu "请选择ComfyUI插件管理选项的功能" 25 80 10 \
        "1" "安装" \
        "2" "管理" \
        "3" "更新全部插件" \
        "4" "安装全部插件依赖" \
        "5" "返回" \
        3>&1 1>&2 2>&3 )

    if [ $? = 0 ];then
        case $comfyui_extension_methon_dialog in
            1) #选择安装
                comfyui_extension_install
                comfyui_extension_methon
                ;;
            2) #选择管理
                comfyui_extension_manager
                comfyui_extension_methon
                ;;
            3) #选择更新全部插件
                extension_all_update
                comfyui_extension_methon
                ;;
            4) #选择安装全部插件依赖
                comfyui_extension_depend_install
                comfyui_extension_methon
                ;;
        esac
    fi
}

#插件管理界面
function comfyui_extension_manager()
{
    cd "$start_path/ComfyUI/web/extensions" #回到最初路径
    dir_list=$(ls -l --time-style=+"%Y-%m-%d" | awk -F ' ' ' { print $7 " " $6 } ') #当前目录文件和文件夹信息

    comfyui_extension_selection=$(
        dialog --erase-on-exit --ok-label "确认" --cancel-label "取消" --title "ComfyUI管理" --backtitle "ComfyUI插件列表" --menu "使用上下键选择要操作的插件并回车确认" 25 80 10 \
        "-->返回<--" "<---------" \
        $dir_list \
        3>&1 1>&2 2>&3)

    if [ $? = 0 ];then
        if [ $comfyui_extension_selection = "-->返回<--" ];then
            echo
        elif [ -d "$comfyui_extension_selection" ];then  # 选择文件夹
            if [ ! "$comfyui_extension_selection" = "core" ];then #排除掉core文件夹
                cd "$comfyui_extension_selection"
                operate_comfyui_extension #调用operate_comfyui_extension函数处理插件
            fi
            comfyui_extension_manager
        elif [ -f "$extension_selection" ];then
            comfyui_extension_manager #留在当前目录
        else
            comfyui_extension_manager #留在当前目录
        fi
    fi
}

#插件安装模块
function comfyui_extension_install()
{
    comfyui_extension_address=$(dialog --erase-on-exit --title "ComfyUI管理" --backtitle "ComfyUI插件安装选项" --ok-label "确认" --cancel-label "取消" --inputbox "输入插件的github地址或其他下载地址" 25 80 3>&1 1>&2 2>&3)

    if [ ! -z $comfyui_extension_address ]; then
        term_sd_notice "安装$(echo $comfyui_extension_address | awk -F'/' '{print $NF}')中"
        git clone --recurse-submodules $comfyui_extension_address
        git_req=$?
        comfyui_extension_dep_notice=""
        if [ -f "./$(awk -F "/" '{print $NF}' <<< "$comfyui_extension_address")/requirements.txt" ] || [ -f "./$(awk -F "/" '{print $NF}' <<< "$comfyui_extension_address")/install.py" ];then
            comfyui_extension_dep_notice="检测到该插件需要安装依赖,请进入插件管理功能,选中该插件,运行一次\"安装依赖\"功能"
        fi

        if [ $git_req = 0 ];then
            dialog --erase-on-exit --title "ComfyUI管理" --backtitle "ComfyUI插件安装结果" --ok-label "确认" --msgbox "$(echo $comfyui_extension_address | awk -F'/' '{print $NF}')插件安装成功\n$comfyui_extension_dep_notice" 25 80
        else
            dialog --erase-on-exit --title "ComfyUI管理" --backtitle "ComfyUI插件安装结果" --ok-label "确认" --msgbox "$(echo $comfyui_extension_address | awk -F'/' '{print $NF}')插件安装失败" 25 80
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

    operate_comfyui_extension_dialog=$(
        dialog --erase-on-exit --title "ComfyUI管理" --backtitle "ComfyUI插件管理选项" --ok-label "确认" --cancel-label "取消" --menu "请选择对"$comfyui_extension_selection"插件的管理功能\n当前更新源:$([ -d "./.git" ] && git remote -v | awk 'NR==1 {print $2}' || echo "无")" 25 80 10 \
        $dialog_update_button \
        "2" "安装依赖" \
        "3" "卸载" \
        $dialog_fix_update_button \
        $dialog_git_checkout_button \
        $dialog_update_remote_checkout_button \
        "6" "返回" \
        3>&1 1>&2 2>&3)

    if [ $? = 0 ];then
        case $operate_comfyui_extension_dialog in
            1)
                term_sd_notice "更新"$comfyui_extension_selection"中"
                git pull --recurse-submodules
                if [ $? = 0 ];then
                    dialog --erase-on-exit --title "ComfyUI管理" --backtitle "ComfyUI插件更新结果" --ok-label "确认" --msgbox ""$comfyui_extension_selection"插件更新成功" 25 80
                else
                    dialog --erase-on-exit --title "ComfyUI管理" --backtitle "ComfyUI插件更新结果" --ok-label "确认" --msgbox ""$comfyui_extension_selection"插件更新失败" 25 80
                fi
                operate_comfyui_extension
                ;;
            2) #comfyui并不像a1111-sd-webui自动为插件安装依赖,所以只能手动装
                comfyui_extension_depend_install_single
                operate_comfyui_extension
                ;;
            3)
                if (dialog --erase-on-exit --title "ComfyUI管理" --backtitle "ComfyUI插件删除选项" --yes-label "是" --no-label "否" --yesno "是否删除"$comfyui_extension_selection"插件?" 25 80) then
                    term_sd_notice "请再次确认是否删除$(echo $comfyui_extension_selection | awk -F "/" '{print $NF}')(yes/no)?"
                    term_sd_notice "警告:该操作将永久删除$(echo $comfyui_extension_selection | awk -F "/" '{print $NF}')"
                    term_sd_notice "提示:输入yes或no后回车"
                    term_sd_remove_repository_option=""
                    read -p "===============================> " term_sd_remove_repository_option
                    case $term_sd_remove_repository_option in
                        yes|y|YES|Y)
                            term_sd_notice "删除$(echo $comfyui_extension_selection | awk -F "/" '{print $NF}')插件中"
                            cd ..
                            rm -rf ./$comfyui_extension_selection
                            term_sd_notice "删除$(echo $comfyui_extension_selection | awk -F "/" '{print $NF}')插件完成"
                            ;;
                        *)
                            term_sd_notice "取消删除操作"
                            operate_comfyui_extension
                            ;;
                    esac
                else
                    term_sd_notice "取消删除操作"
                    operate_comfyui_extension
                fi
                ;;
            4)
                term_sd_notice "修复更新中"
                term_sd_fix_pointer_offset
                operate_comfyui_extension
                ;;
            5)
                git_checkout_manager
                operate_comfyui_extension
                ;;
            6)
                select_repo_single
                operate_comfyui_extension
                ;;
        esac
    fi
}