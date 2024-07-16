#!/bin/bash

# ComfyUI 自定义节点管理器
# 管理 <ComfyUI Path>/custom_nodes 文件夹下的自定义节点
comfyui_custom_node_manager() {
    local dialog_arg

    if [[ ! -d "${COMFYUI_PATH}"/custom_nodes ]]; then
        dialog --erase-on-exit \
            --title "ComfyUI 管理" \
            --backtitle "ComfyUI 自定义节点管理选项" \
            --ok-label "确认" \
            --msgbox "找不到 ComfyUI 自定义节点目录, 请检查 ComfyUI 是否安装完整" \
            $(get_dialog_size)
        return 1
    fi

    while true; do
        cd "${COMFYUI_PATH}"/custom_nodes # 回到最初路径

        dialog_arg=$(dialog --erase-on-exit --notags \
            --title "ComfyUI 管理" \
            --backtitle "ComfyUI 自定义节点管理选项" \
            --ok-label "确认" --cancel-label "取消" \
            --menu "请选择 ComfyUI 自定义节点管理选项的功能" \
            $(get_dialog_size_menu) \
            "0" "> 返回" \
            "1" "> 安装自定义节点" \
            "2" "> 管理自定义节点" \
            "3" "> 更新全部自定义节点" \
            "4" "> 安装全部自定义节点依赖" \
            3>&1 1>&2 2>&3)

        case "${dialog_arg}" in
            1)
                # 选择安装
                comfyui_custom_node_install
                ;;
            2)
                # 选择管理
                comfyui_custom_node_list
                ;;
            3)
                # 选择更新全部自定义节点
                if (dialog --erase-on-exit \
                    --title "ComfyUI 管理" \
                    --backtitle "ComfyUI 自定义节点管理" \
                    --yes-label "是" --no-label "否" \
                    --yesno "是否更新所有 ComfyUI 自定义节点 ?" \
                    $(get_dialog_size)); then

                    update_all_extension
                fi
                ;;
            4)
                # 选择安装全部自定义节点依赖
                if (dialog --erase-on-exit \
                    --title "ComfyUI 管理" \
                    --backtitle "ComfyUI 自定义节点管理" \
                    --yes-label "是" --no-label "否" \
                    --yesno "是否安装所有 ComfyUI 自定义节点的依赖?" \
                    $(get_dialog_size)); then

                    comfyui_extension_depend_install "自定义节点"
                fi
                ;;
            *)
                break
                ;;
        esac
    done
}

# ComfyUI 自定义节点安装
# 使用 COMFYUI_CUSTOM_NODE_INSTALL_DEP_MESSAGE 全局变量临时储存安装信息
comfyui_custom_node_install() {
    local repo_url
    local custom_node_name

    repo_url=$(dialog --erase-on-exit \
        --title "ComfyUI 管理" \
        --backtitle "ComfyUI 自定义节点安装选项" \
        --ok-label "确认" --cancel-label "取消" \
        --inputbox "输入自定义节点的 Github 地址或其他下载地址" \
        $(get_dialog_size) \
        3>&1 1>&2 2>&3)

    if [[ ! -z "${repo_url}" ]]; then
        custom_node_name=$(basename "${repo_url}" | awk -F '.git' '{print $1}')
        term_sd_echo "安装 ${custom_node_name} 自定义节点中"
        if ! term_sd_is_git_repository_exist "${repo_url}"; then # 检查待安装的自定义节点是否存在于自定义节点文件夹中
            term_sd_try git clone --recurse-submodules "${repo_url}" "${COMFYUI_PATH}/custom_nodes/${custom_node_name}"
            if [[ "$?" == 0 ]]; then
                COMFYUI_CUSTOM_NODE_INSTALL_DEP_MESSAGE="${custom_node_name} 自定义节点安装成功"
                comfyui_extension_depend_install_auto "自定义节点" "${custom_node_name}" # 检查是否存在依赖文件并安装
            else
                COMFYUI_CUSTOM_NODE_INSTALL_DEP_MESSAGE="${custom_node_name} 自定义节点安装失败"
            fi
        else
            COMFYUI_CUSTOM_NODE_INSTALL_DEP_MESSAGE="${custom_node_name} 自定义节点已存在"
        fi

        dialog --erase-on-exit \
            --title "ComfyUI 管理" \
            --backtitle "ComfyUI 自定义节点安装结果" \
            --ok-label "确认" \
            --msgbox "${COMFYUI_CUSTOM_NODE_INSTALL_DEP_MESSAGE}" \
            $(get_dialog_size)

        unset COMFYUI_CUSTOM_NODE_INSTALL_DEP_MESSAGE
    else
        dialog --erase-on-exit \
            --title "ComfyUI 管理" \
            --backtitle "ComfyUI 自定义节点管理选项" \
            --ok-label "确认" \
            --msgbox "输入的 ComfyUI 自定义节点安装地址为空" \
            $(get_dialog_size)
    fi
}

# 自定义节点浏览器
# 将列出 <ComfyUI Path>/custom_nodes 中所有的自定义节点的文件夹
comfyui_custom_node_list() {
    local custom_node_name

    while true; do
        cd "$COMFYUI_PATH"/custom_nodes # 回到最初路径
        get_dir_folder_list # 获取当前目录下的所有文件夹

        if term_sd_is_bash_ver_lower; then # Bash 版本低于 4 时使用旧版列表显示方案
            custom_node_name=$(dialog --erase-on-exit \
                --yes-label "确认" --no-label "取消" \
                --title "ComfyUI 管理" \
                --backtitle "ComfyUI 自定义节点列表" \
                --menu "使用上下键选择要操作的自定义节点并回车确认" \
                $(get_dialog_size_menu) \
                "-->返回<--" "<---------" \
                "${LOCAL_DIR_LIST}" \
                3>&1 1>&2 2>&3)
        else
            custom_node_name=$(dialog --erase-on-exit \
                --yes-label "确认" --no-label "取消" \
                --title "ComfyUI 管理" \
                --backtitle "ComfyUI 自定义节点列表" \
                --menu "使用上下键选择要操作的自定义节点并回车确认" \
                $(get_dialog_size_menu) \
                "-->返回<--" "<---------" \
                "${LOCAL_DIR_LIST[@]}" \
                3>&1 1>&2 2>&3)
        fi

        if [[ "$?" == 0 ]]; then
            if [[ "${custom_node_name}" == "-->返回<--" ]]; then
                break
            elif [[ -d "${custom_node_name}" ]]; then # 选择文件夹
                cd "${custom_node_name}"
                comfyui_custom_node_interface "${custom_node_name}"
            else
                dialog --erase-on-exit \
                    --title "ComfyUI 管理" \
                    --backtitle "ComfyUI 自定义节点管理" \
                    --ok-label "确认" \
                    --msgbox "当前的选择非 ComfyUI 自定义节点, 请重新选择" \
                    $(get_dialog_size)
            fi
        else
            break
        fi
    done

    unset LOCAL_DIR_LIST
}


# ComfyUI 自定义节点管理
# 使用:
# comfyui_custom_node_interface <自定义节点的文件夹名>
comfyui_custom_node_interface() {
    local dialog_arg
    local custom_node_name=$@

    while true; do
        dialog_arg=$(dialog --erase-on-exit --notags \
            --title "ComfyUI 选项" \
            --backtitle "ComfyUI 自定义节点管理选项" \
            --ok-label "确认" --cancel-label "取消" \
            --menu "请选择对 ${custom_node_name} 自定义节点的管理功能\n当前更新源: $(git_remote_display)\n当前分支: $(git_branch_display)" \
            $(get_dialog_size_menu) \
            "0" "> 返回" \
            "1" "> 更新" \
            "2" "> 修复更新" \
            "3" "> 安装依赖" \
            "4" "> 版本切换" \
            "5" "> 更新源切换" \
            "6" "> 卸载" \
            3>&1 1>&2 2>&3)

        case "${dialog_arg}" in
            1)
                if is_git_repo; then
                    term_sd_echo "更新 ${custom_node_name} 自定义节点中"
                    git_pull_repository
                    if [[ "$?" == 0 ]]; then
                        dialog --erase-on-exit \
                            --title "ComfyUI 管理" \
                            --backtitle "ComfyUI 自定义节点更新结果" \
                            --ok-label "确认" \
                            --msgbox "${custom_node_name} 自定义节点更新成功" \
                            $(get_dialog_size)
                    else
                        dialog --erase-on-exit \
                            --title "ComfyUI 管理" \
                            --backtitle "ComfyUI 自定义节点更新结果" \
                            --ok-label "确认" \
                            --msgbox "${custom_node_name} 自定义节点更新失败" \
                            $(get_dialog_size)
                    fi
                else
                    dialog --erase-on-exit \
                        --title "ComfyUI 管理" \
                        --backtitle "ComfyUI 自定义节点更新结果" \
                        --ok-label "确认" \
                        --msgbox "${custom_node_name} 自定义节点非 Git 安装, 无法更新" \
                        $(get_dialog_size)
                fi
                ;;
            2)
                if is_git_repo; then
                    if (dialog --erase-on-exit \
                        --title "ComfyUI 管理" \
                        --backtitle "ComfyUI 自定义节点修复更新" \
                        --yes-label "是" --no-label "否" \
                        --yesno "是否修复 ${custom_node_name} 自定义节点更新 ?" \
                        $(get_dialog_size)); then

                        git_fix_pointer_offset
                        dialog --erase-on-exit \
                            --title "ComfyUI 管理" \
                            --backtitle "ComfyUI 自定义节点修复更新" \
                            --ok-label "确认" \
                            --msgbox "${custom_node_name} 自定义节点修复更新完成" \
                            $(get_dialog_size)
                    else
                        term_sd_echo "取消修复 ${custom_node_name} 自定义节点的更新"
                    fi
                else
                    dialog --erase-on-exit \
                        --title "ComfyUI 管理" \
                        --backtitle "ComfyUI 自定义节点修复更新" \
                        --ok-label "确认" \
                        --msgbox "${custom_node_name} 自定义节点非 Git 安装, 无法修复更新" \
                        $(get_dialog_size)
                fi
                ;;
            3)
                # ComfyUI 并不像 SD WebUI 自动为插件安装依赖, 所以只能手动装
                if (dialog --erase-on-exit \
                    --title "ComfyUI 选项" \
                    --backtitle "ComfyUI 自定义节点依赖安装选项" \
                    --yes-label "是" --no-label "否" \
                    --yesno "是否安装 ${custom_node_name} 自定义节点依赖 ?" \
                    $(get_dialog_size)); then

                    comfyui_extension_depend_install_single "自定义节点" "${custom_node_name}"
                else
                    term_sd_echo "取消安装 ${custom_node_name} 自定义节点依赖"
                fi
                ;;
            4)
                if is_git_repo; then
                    if (dialog --erase-on-exit \
                        --title "ComfyUI 管理" \
                        --backtitle "ComfyUI 自定义节点版本切换" \
                        --yes-label "是" --no-label "否" \
                        --yesno "是否切换 ${custom_node_name} 自定义节点版本?" \
                        $(get_dialog_size)); then

                        git_ver_switch
                        dialog --erase-on-exit \
                            --title "ComfyUI 管理" \
                            --backtitle "ComfyUI 自定义节点版本切换" \
                            --ok-label "确认" \
                            --msgbox "${custom_node_name} 自定义节点版本切换完成, 当前版本为: $(git_branch_display)" \
                            $(get_dialog_size)
                    fi
                else
                    dialog --erase-on-exit \
                        --title "ComfyUI 管理" \
                        --backtitle "ComfyUI自定义节点版本切换" \
                        --ok-label "确认" \
                        --msgbox "${custom_node_name} 自定义节点非 Git 安装, 无法进行版本切换" \
                        $(get_dialog_size)
                fi
                ;;
            5)
                if is_git_repo; then
                    if (dialog --erase-on-exit \
                        --title "ComfyUI 管理" \
                        --backtitle "ComfyUI 自定义节点更新源切换" \
                        --yes-label "是" --no-label "否" \
                        --yesno "是否切换 ${custom_node_name} 自定义节点更新源 ?" \
                        $(get_dialog_size)); then

                        git_remote_url_select_single
                    fi
                else
                    dialog --erase-on-exit \
                        --title "ComfyUI 管理" \
                        --backtitle "ComfyUI 自定义节点更新源切换" \
                        --ok-label "确认" \
                        --msgbox "${custom_node_name} 自定义节点非 Git 安装, 无法进行更新源切换" \
                        $(get_dialog_size)
                fi
                ;;
            6)
                if (dialog --erase-on-exit \
                    --title "ComfyUI 选项" \
                    --backtitle "ComfyUI 自定义节点删除选项" \
                    --yes-label "是" --no-label "否" \
                    --yesno "是否删除 ${custom_node_name} 自定义节点?" \
                    $(get_dialog_size)); then

                    term_sd_echo "请再次确认是否删除 ${custom_node_name} 自定义节点 (yes/no) ?"
                    term_sd_echo "警告: 该操作将永久删除 ${custom_node_name} 自定义节点"
                    term_sd_echo "提示: 输入 yes 或 no 后回车"
                    case "$(term_sd_read)" in
                        yes|y|YES|Y)
                            term_sd_echo "删除 ${custom_node_name} 自定义节点中"
                            cd ..
                            rm -rf "${custom_node_name}"

                            dialog --erase-on-exit \
                            --title "ComfyUI 管理" \
                            --backtitle "ComfyUI 自定义节点删除选项" \
                            --ok-label "确认" \
                            --msgbox "删除 ${custom_node_name} 自定义节点完成" \
                            $(get_dialog_size)

                            break
                            ;;
                        *)
                            term_sd_echo "取消删除 ${custom_node_name} 自定义节点操作"
                            ;;
                    esac
                fi
                ;;
            *)
                break
                ;;
        esac
    done
}
