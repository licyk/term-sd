#!/bin/bash

#a1111-sd-webui
#插件的安装或管理选项(该部分最先被调用)
function a1111_sd_webui_extension_methon()
{
    cd "$start_path/stable-diffusion-webui/extensions" #回到最初路径
    #功能选择界面
    final_a1111_sd_webui_extension_methon=$(
        dialog --clear --title "A1111-SD-Webui管理" --backtitle "A1111-SD-Webui插件管理选项" --ok-label "确认" --cancel-label "取消" --menu "请选择A1111-SD-Webui插件管理选项的功能" 22 70 12 \
        "1" "安装" \
        "2" "管理" \
        "3" "更新全部插件" \
        "4" "返回" \
        3>&1 1>&2 2>&3 )

    if [ $? = 0 ];then
        if [ "${final_a1111_sd_webui_extension_methon}" == '1' ]; then #选择安装
            a1111_sd_webui_extension_install
            a1111_sd_webui_extension_methon
        elif [ "${final_a1111_sd_webui_extension_methon}" == '2' ]; then #选择管理
            a1111_sd_webui_extension_manager
            a1111_sd_webui_extension_methon
        elif [ "${final_a1111_sd_webui_extension_methon}" == '3' ]; then #选择更新全部插件
            extension_all_update
            a1111_sd_webui_extension_methon
        elif [ "${final_a1111_sd_webui_extension_methon}" == '4' ]; then #选择返回
            echo
        fi
    fi
}

#插件管理界面
function a1111_sd_webui_extension_manager()
{
    cd "$start_path/stable-diffusion-webui/extensions" #回到最初路径
    export term_sd_manager_info="a1111_sd_webui_extension_option"
    dir_list=$(ls -l --time-style=+"%Y-%m-%d"  | awk -F ' ' ' { print $7 " " $6 } ') #当前目录文件和文件夹信息

    extension_selection=$(
        dialog --clear --ok-label "确认" --cancel-label "取消" --title "A1111-SD-Webui管理" --backtitle "A1111-SD-Webui插件列表" \
        --menu "请选择A1111-SD-Webui插件" 22 70 12 \
        $dir_list \
        3>&1 1>&2 2>&3)
    if [ $? = 0 ];then
        if [[ -d "$extension_selection" ]]; then  # 选择文件夹
            cd "$extension_selection"
            a1111_sd_webui_operate_extension #调用a1111_sd_webui_operate_extension函数处理插件
            a1111_sd_webui_extension_manager
        elif [[ -f "$extension_selection" ]]; then
            a1111_sd_webui_extension_manager #留在当前目录
        else
            a1111_sd_webui_extension_manager #留在当前目录
        fi
    fi
}

#插件安装模块
function a1111_sd_webui_extension_install()
{
    extension_address=$(dialog --clear --title "A1111-SD-Webui管理" --backtitle "A1111-SD-Webui插件安装选项" --yes-label "确认" --no-label "取消" --inputbox "请输入插件的github地址或其他下载地址" 22 70 3>&1 1>&2 2>&3)

    if [ $? = 0 ]; then
        git clone $extension_address
        if [ $? = "0" ];then
            dialog --clear --title "A1111-SD-Webui管理" --backtitle "A1111-SD-Webui插件安装结果" --msgbox "A1111-SD-Webui插件安装成功" 22 70
        else
            dialog --clear --title "A1111-SD-Webui管理" --backtitle "A1111-SD-Webui插件安装结果" --msgbox "A1111-SD-Webui插件安装失败" 22 70
        fi
    fi
}

#插件处理模块
function a1111_sd_webui_operate_extension() 
{
    #当git在子文件夹中找不到.git文件夹时,将会自动在父文件夹中寻找,以此类推,直到找到.git文件夹。用户的安装方式可能是直接下载源码压缩包,导致安装后的文件夹没有.git文件夹,直接执行git会导致不良的后果
    if [ -d "./.git" ];then #检测目录中是否有.git文件夹
        dialog_button_1=""1" "更新""
        dialog_button_2=""3" "修复更新""
        dialog_button_3=""4" "版本切换""
        dialog_button_4=""5" "更新源切换""
    else
        dialog_button_1=""
        dialog_button_2=""
        dialog_button_3=""
        dialog_button_4=""
    fi

    final_a1111_sd_webui_operate_extension=$(
        dialog --clear --title "A1111-SD-Webui管理" --backtitle "A1111-SD-Webui插件管理选项" --ok-label "确认" --cancel-label "取消" --menu "请选择对"$extension_selection"插件的管理功能" 22 70 12 \
        $dialog_button_1 \
        "2" "卸载" \
        $dialog_button_2 \
        $dialog_button_3 \
        $dialog_button_4 \
        "6" "返回" \
        3>&1 1>&2 2>&3)
    if [ $? = 0 ];then
        if [ "${final_a1111_sd_webui_operate_extension}" == '1' ]; then
            echo "更新$(echo $extension_selection | awk -F "/" '{print $NF}')插件中"
            git pull
            if [ $? = "0" ];then
                dialog --clear --title "A1111-SD-Webui管理" --backtitle "A1111-SD-Webui插件更新结果" --msgbox ""$extension_selection"插件更新成功" 22 70
            else
                dialog --clear --title "A1111-SD-Webui管理" --backtitle "A1111-SD-Webui插件更新结果" --msgbox ""$extension_selection"插件更新失败" 22 70
            fi
        elif [ "${final_a1111_sd_webui_operate_extension}" == '2' ]; then
            if (dialog --clear --title "A1111-SD-Webui管理" --backtitle "A1111-SD-Webui插件删除选项" --yes-label "是" --no-label "否" --yesno "是否删除"$extension_selection"插件?" 22 70) then
                echo "删除$(echo $extension_selection | awk -F "/" '{print $NF}')插件中"
                cd ..
                rm -rf ./$extension_selection
            fi
        elif [ "${final_a1111_sd_webui_operate_extension}" == '3' ]; then
            echo "修复更新中"
            term_sd_fix_pointer_offset
        elif [ "${final_a1111_sd_webui_operate_extension}" == '4' ]; then
            git_checkout_manager
        elif [ "${final_a1111_sd_webui_operate_extension}" == '5' ]; then
            select_repo_single
        elif [ "${final_a1111_sd_webui_operate_extension}" == '6' ]; then
            cd ..
        fi
    fi
}
