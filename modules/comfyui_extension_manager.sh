#!/bin/bash

# comfyui的扩展分为两种,一种是前端节点,另一种是后端扩展(少见).详见:https://github.com/comfyanonymous/ComfyUI/discussions/631
# 插件管理器
comfyui_extension_manager()
{
    local comfyui_extension_manager_dialog

    while true
    do
        cd "$comfyui_path"/web/extensions # 回到最初路径

        comfyui_extension_manager_dialog=$(dialog --erase-on-exit --notags \
            --title "ComfyUI 管理" \
            --backtitle "ComfyUI 插件管理选项" \
            --ok-label "确认" --cancel-label "取消" \
            --menu "请选择 ComfyUI 插件管理选项的功能" \
            $term_sd_dialog_height $term_sd_dialog_width $term_sd_dialog_menu_height \
            "0" "> 返回" \
            "1" "> 安装插件" \
            "2" "> 管理插件" \
            "3" "> 更新全部插件" \
            "4" "> 安装全部插件依赖" \
            3>&1 1>&2 2>&3 )

        case $comfyui_extension_manager_dialog in
            1) # 选择安装
                comfyui_extension_install
                ;;
            2) # 选择管理
                comfyui_extension_list
                ;;
            3) # 选择更新全部插件
                update_all_extension
                ;;
            4) # 选择安装全部插件依赖
                comfyui_extension_depend_install "插件"
                ;;
            *)
                break
                ;;
        esac
    done
}

# 插件列表浏览器
comfyui_extension_list()
{
    while true
    do
        cd "$comfyui_path"/web/extensions # 回到最初路径

        comfyui_extension_name=$(dialog --erase-on-exit \
            --ok-label "确认" --cancel-label "取消" \
            --title "ComfyUI 管理" \
            --backtitle "ComfyUI 插件列表" \
            --menu "使用上下键选择要操作的插件并回车确认" \
            $term_sd_dialog_height $term_sd_dialog_width $term_sd_dialog_menu_height \
            "-->返回<--" "<---------" \
            $(ls -l --time-style=+"%Y-%m-%d" | awk -F ' ' ' { print $7 " " $6 } ') \
            3>&1 1>&2 2>&3)

        if [ $? = 0 ];then
            if [ "$comfyui_extension_name" = "-->返回<--" ];then
                break
            elif [ -d "$comfyui_extension_name" ];then  # 选择文件夹
                if [ ! "$comfyui_extension_name" = "core" ];then # 排除掉core文件夹
                    cd "$comfyui_extension_name"
                    comfyui_extension_interface
                fi
            fi
        else
            break
        fi
    done
}

# 插件安装
comfyui_extension_install()
{
    local comfyui_extension_url
    local comfyui_extension_dep_notice
    local git_req

    comfyui_extension_url=$(dialog --erase-on-exit \
        --title "ComfyUI 管理" \
        --backtitle "ComfyUI 插件安装选项" \
        --ok-label "确认" --cancel-label "取消" \
        --inputbox "输入插件的 Github 地址或其他下载地址" \
        $term_sd_dialog_height $term_sd_dialog_width \
        3>&1 1>&2 2>&3)

    if [ ! -z "$comfyui_extension_url" ]; then
        term_sd_echo "安装 $(basename "$comfyui_extension_url" | awk -F '.git' '{print$1}') 插件中"
        if [ $(term_sd_is_git_repository_exist "$comfyui_extension_url") = 0 ];then
            term_sd_try git clone --recurse-submodules $comfyui_extension_url
            if [ $? = 0 ];then
                comfyui_custom_node_dep_notice="$(basename "$comfyui_extension_url" | awk -F '.git' '{print$1}') 插件安装成功"
                comfyui_extension_depend_install_auto "插件" "$(basename "$comfyui_extension_url" | awk -F '.git' '{print$1}')"
            else
                comfyui_custom_node_dep_notice="$(basename "$comfyui_extension_url" | awk -F '.git' '{print$1}') 插件安装失败"
            fi
        else
            comfyui_custom_node_dep_notice="$(basename "$comfyui_extension_url" | awk -F '.git' '{print$1}') 插件已存在"
        fi

        dialog --erase-on-exit \
            --title "ComfyUI 管理" \
            --backtitle "ComfyUI 插件安装结果" \
            --ok-label "确认" \
            --msgbox "$comfyui_custom_node_dep_notice" \
            $term_sd_dialog_height $term_sd_dialog_width

        comfyui_custom_node_dep_notice=
    else
        term_sd_echo "输入的 ComfyUI 插件安装地址为空,不执行操作"
    fi
}

# 插件管理
comfyui_extension_interface() 
{
    local comfyui_extension_interface_dialog

    while true
    do
        comfyui_extension_interface_dialog=$(dialog --erase-on-exit --notags \
            --title "ComfyUI 管理" \
            --backtitle "ComfyUI 插件管理选项" \
            --ok-label "确认" --cancel-label "取消" \
            --menu "请选择对 ${comfyui_extension_name} 插件的管理功能\n当前更新源:$(git_remote_display)\n当前分支:$(git_branch_display)" \
            $term_sd_dialog_height $term_sd_dialog_width $term_sd_dialog_menu_height \
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
                term_sd_echo "更新 ${comfyui_extension_name} 插件中"
                git_pull_repository
                case $? in
                    0)
                        dialog --erase-on-exit \
                            --title "ComfyUI 管理" \
                            --backtitle "ComfyUI 插件更新结果" \
                            --ok-label "确认" \
                            --msgbox "${comfyui_extension_name} 插件更新成功" \
                            $term_sd_dialog_height $term_sd_dialog_width
                        ;;
                    10)
                        dialog --erase-on-exit \
                            --title "ComfyUI 管理" \
                            --backtitle "ComfyUI 插件更新结果" \
                            --ok-label "确认" \
                            --msgbox "${comfyui_extension_name} 插件非 Git 安装, 无法更新" \
                            $term_sd_dialog_height $term_sd_dialog_width
                        ;;
                    *)
                        dialog --erase-on-exit \
                            --title "ComfyUI 管理" \
                            --backtitle "ComfyUI 插件更新结果" \
                            --ok-label "确认" \
                            --msgbox "${comfyui_extension_name} 插件更新失败" \
                            $term_sd_dialog_height $term_sd_dialog_width
                        ;;
                esac
                ;;
            2)
                if (dialog --erase-on-exit \
                    --title "ComfyUI 管理" \
                    --backtitle "ComfyUI 插件修复更新" \
                    --yes-label "是" --no-label "否" \
                    --yesno "是否修复 ${comfyui_extension_name} 插件更新?" \
                    $term_sd_dialog_height $term_sd_dialog_width) then

                    git_fix_pointer_offset
                fi

                [ $? = 10 ] && \
                dialog --erase-on-exit \
                    --title "ComfyUI 管理" \
                    --backtitle "ComfyUI 插件修复更新" \
                    --ok-label "确认" \
                    --msgbox "${comfyui_extension_name} 插件非 Git 安装, 无法修复更新" \
                    $term_sd_dialog_height $term_sd_dialog_width
                ;;
            3) #comfyui并不像a1111-sd-webui自动为插件安装依赖,所以只能手动装
                comfyui_extension_depend_install_single "插件"
                ;;
            4)
                if (dialog --erase-on-exit \
                    --title "ComfyUI 管理" \
                    --backtitle "ComfyUI 插件版本切换" \
                    --yes-label "是" --no-label "否" \
                    --yesno "是否切换 ${comfyui_extension_name} 插件版本?" \
                    $term_sd_dialog_height $term_sd_dialog_width) then

                    git_ver_switch
                fi
                [ $? = 10 ] && \
                dialog --erase-on-exit \
                    --title "ComfyUI 管理" \
                    --backtitle "ComfyUI 插件版本切换" \
                    --ok-label "确认" \
                    --msgbox "${comfyui_extension_name}插件非 Git 安装, 无法进行版本切换" \
                    $term_sd_dialog_height $term_sd_dialog_width
                ;;
            5)
                git_remote_url_select_single
                [ $? = 10 ] && \
                dialog --erase-on-exit \
                    --title "ComfyUI 管理" \
                    --backtitle "ComfyUI 插件更新源切换" \
                    --ok-label "确认" \
                    --msgbox "${comfyui_extension_name} 插件非 Git 安装, 无法进行更新源切换" \
                    $term_sd_dialog_height $term_sd_dialog_width
                ;;
            6)
                if (dialog --erase-on-exit \
                    --title "ComfyUI 管理" \
                    --backtitle "ComfyUI 插件删除选项" \
                    --yes-label "是" --no-label "否" \
                    --yesno "是否删除 ${comfyui_extension_name} 插件?" \
                    $term_sd_dialog_height $term_sd_dialog_width) then

                    term_sd_echo "请再次确认是否删除 $(basename "$comfyui_extension_name") (yes/no)?"
                    term_sd_echo "警告: 该操作将永久删除 $(basename "$comfyui_extension_name")"
                    term_sd_echo "提示: 输入 yes 或 no 后回车"
                    case $(term_sd_read) in
                        yes|y|YES|Y)
                            term_sd_echo "删除 $(basename "$comfyui_extension_name") 插件中"
                            cd ..
                            rm -rf "$comfyui_extension_name"

                            dialog --erase-on-exit \
                                --title "ComfyUI 管理" \
                                --backtitle "ComfyUI 插件删除选项" \
                                --ok-label "确认" \
                                --msgbox "删除 $(basename "$comfyui_custom_node_name") 插件完成" \
                                $term_sd_dialog_height $term_sd_dialog_width
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
