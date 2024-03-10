#!/bin/bash

# 插件管理器
sd_webui_extension_manager()
{
    local sd_webui_extension_manager_dialog
    while true
    do
        cd "$sd_webui_path"/extensions #回到最初路径

        # 功能选择界面
        sd_webui_extension_manager_dialog=$(
            dialog --erase-on-exit --notags --title "Stable-Diffusion-WebUI管理" --backtitle "Stable-Diffusion-WebUI插件管理选项" --ok-label "确认" --cancel-label "取消" --menu "请选择Stable-Diffusion-WebUI插件管理选项的功能" $term_sd_dialog_height $term_sd_dialog_width $term_sd_dialog_menu_height \
            "0" "> 返回" \
            "1" "> 安装插件" \
            "2" "> 管理插件" \
            "3" "> 更新全部插件" \
            3>&1 1>&2 2>&3 )

        case $sd_webui_extension_manager_dialog in
            1) # 选择安装
                sd_webui_extension_install
                ;;
            2) # 选择管理
                sd_webui_extension_list
                ;;
            3) # 选择更新全部插件
                update_all_extension
                ;;
            *)
                break
                ;;
        esac
    done
}

# 插件安装
sd_webui_extension_install()
{
    local sd_webui_extension_url

    sd_webui_extension_url=$(dialog --erase-on-exit --title "Stable-Diffusion-WebUI管理" --backtitle "Stable-Diffusion-WebUI插件安装选项" --ok-label "确认" --cancel-label "取消" --inputbox "请输入插件的github地址或其他下载地址" $term_sd_dialog_height $term_sd_dialog_width 3>&1 1>&2 2>&3)

    if [ ! -z "$sd_webui_extension_url" ]; then
        term_sd_echo "安装$(basename "$sd_webui_extension_url" | awk -F '.git' '{print$1}')插件中"
        if [ $(term_sd_is_git_repository_exist "$sd_webui_extension_url") = 0 ];then
            term_sd_try git clone --recurse-submodules $sd_webui_extension_url
            if [ $? = 0 ];then
                dialog --erase-on-exit --title "Stable-Diffusion-WebUI管理" --backtitle "Stable-Diffusion-WebUI插件安装结果" --ok-label "确认" --msgbox "$(basename "$sd_webui_extension_url" | awk -F '.git' '{print$1}')插件安装成功" $term_sd_dialog_height $term_sd_dialog_width
            else
                dialog --erase-on-exit --title "Stable-Diffusion-WebUI管理" --backtitle "Stable-Diffusion-WebUI插件安装结果" --ok-label "确认" --msgbox "$(basename "$sd_webui_extension_url" | awk -F '.git' '{print$1}')插件安装失败" $term_sd_dialog_height $term_sd_dialog_width
            fi
        else
            dialog --erase-on-exit --title "Stable-Diffusion-WebUI管理" --backtitle "Stable-Diffusion-WebUI插件安装结果" --ok-label "确认" --msgbox "$(basename "$sd_webui_extension_url" | awk -F '.git' '{print$1}')插件已存在" $term_sd_dialog_height $term_sd_dialog_width
        fi
    else
        term_sd_echo "输入的Stable-Diffusion-WebUI插件安装地址为空,不执行操作"
    fi
}

# 插件列表浏览器
sd_webui_extension_list()
{
    while true
    do
        cd "$sd_webui_path"/extensions #回到最初路径
        sd_webui_extension_name=$(
            dialog --erase-on-exit --ok-label "确认" --cancel-label "取消" --title "Stable-Diffusion-WebUI管理" --backtitle "Stable-Diffusion-WebUI插件列表" --menu "请选择Stable-Diffusion-WebUI插件" $term_sd_dialog_height $term_sd_dialog_width $term_sd_dialog_menu_height \
            "-->返回<--" "<---------" \
            $(ls -l --time-style=+"%Y-%m-%d"  | awk -F ' ' ' { print $7 " " $6 } ') \
            3>&1 1>&2 2>&3)

        if [ $? = 0 ];then
            if [ $sd_webui_extension_name = "-->返回<--" ];then
                break
            elif [ -d "$sd_webui_extension_name" ]; then  # 选择文件夹
                cd "$sd_webui_extension_name"
                sd_webui_extension_interface # 调用sd_webui_extension_interface函数处理插件
            fi
        else
            break
        fi
    done
}

# 插件管理功能
sd_webui_extension_interface() 
{
    local sd_webui_extension_interface_dialog

    while true
    do
        sd_webui_extension_interface_dialog=$(
            dialog --erase-on-exit --notags --title "Stable-Diffusion-WebUI管理" --backtitle "Stable-Diffusion-WebUI插件管理选项" --ok-label "确认" --cancel-label "取消" --menu "请选择对${sd_webui_extension_name}插件的管理功能\n当前更新源:$(git_remote_display)\n当前分支:$(git_branch_display)" $term_sd_dialog_height $term_sd_dialog_width $term_sd_dialog_menu_height \
            "0" "> 返回" \
            "1" "> 更新" \
            "2" "> 修复更新" \
            "3" "> 版本切换" \
            "4" "> 更新源切换" \
            "5" "> 卸载" \
            3>&1 1>&2 2>&3)

        case $sd_webui_extension_interface_dialog in
            1)
                term_sd_echo "更新$(echo $sd_webui_extension_name | awk -F "/" '{print $NF}')插件中"
                git_pull_repository
                case $? in
                    0)
                        dialog --erase-on-exit --title "Stable-Diffusion-WebUI管理" --backtitle "Stable-Diffusion-WebUI插件更新结果" --ok-label "确认" --msgbox "${sd_webui_extension_name}插件更新成功" $term_sd_dialog_height $term_sd_dialog_width
                        ;;
                    10)
                        dialog --erase-on-exit --title "Stable-Diffusion-WebUI管理" --backtitle "Stable-Diffusion-WebUI插件更新结果" --ok-label "确认" --msgbox "${sd_webui_extension_name}插件非git安装,无法更新" $term_sd_dialog_height $term_sd_dialog_width
                        ;;
                    *)
                        dialog --erase-on-exit --title "Stable-Diffusion-WebUI管理" --backtitle "Stable-Diffusion-WebUI插件更新结果" --ok-label "确认" --msgbox "${sd_webui_extension_name}插件更新失败" $term_sd_dialog_height $term_sd_dialog_width
                        ;;
                esac
                ;;
            
            2)
                if (dialog --erase-on-exit --title "Stable-Diffusion-WebUI管理" --backtitle "Stable-Diffusion-WebUI插件修复更新" --yes-label "是" --no-label "否" --yesno "是否修复${sd_webui_extension_name}插件更新?" $term_sd_dialog_height $term_sd_dialog_width) then
                    git_fix_pointer_offset
                fi
                [ $? = 10 ] && dialog --erase-on-exit --title "Stable-Diffusion-WebUI管理" --backtitle "Stable-Diffusion-WebUI插件修复更新" --ok-label "确认" --msgbox "${sd_webui_extension_name}插件非git安装,无法修复更新" $term_sd_dialog_height $term_sd_dialog_width
                ;;
            3)
                git_ver_switch
                [ $? = 10 ] && dialog --erase-on-exit --title "Stable-Diffusion-WebUI管理" --backtitle "Stable-Diffusion-WebUI插件版本切换" --ok-label "确认" --msgbox "${sd_webui_extension_name}插件非git安装,无法进行版本切换" $term_sd_dialog_height $term_sd_dialog_width
                ;;
            4)
                git_remote_url_select_single
                [ $? = 10 ] && dialog --erase-on-exit --title "Stable-Diffusion-WebUI管理" --backtitle "Stable-Diffusion-WebUI插件更新源切换" --ok-label "确认" --msgbox "${sd_webui_extension_name}插件非git安装,无法进行更新源切换" $term_sd_dialog_height $term_sd_dialog_width
                ;;
            5)
                if (dialog --erase-on-exit --title "Stable-Diffusion-WebUI管理" --backtitle "Stable-Diffusion-WebUI插件删除选项" --yes-label "是" --no-label "否" --yesno "是否删除${sd_webui_extension_name}插件?" $term_sd_dialog_height $term_sd_dialog_width) then
                    term_sd_echo "请再次确认是否删除$(basename "$sd_webui_extension_name")(yes/no)?"
                    term_sd_echo "警告:该操作将永久删除$(basename "$sd_webui_extension_name")"
                    term_sd_echo "提示:输入yes或no后回车"
                    case $(term_sd_read) in
                        yes|y|YES|Y)
                            term_sd_echo "删除$(basename "$sd_webui_extension_name")插件中"
                            cd ..
                            rm -rf "$sd_webui_extension_name"
                            dialog --erase-on-exit --title "Stable-Diffusion-WebUI管理" --backtitle "Stable-Diffusion-WebUI插件删除选项" --ok-label "确认" --msgbox "删除$(basename "$sd_webui_extension_name")插件完成" $term_sd_dialog_height $term_sd_dialog_width
                            break                            
                            ;;
                        *)
                            term_sd_echo "取消删除操作"
                            ;;
                    esac
                else
                    term_sd_echo "取消删除操作"
                fi
                ;;
            *)
                break
                ;;
        esac
    done
}
