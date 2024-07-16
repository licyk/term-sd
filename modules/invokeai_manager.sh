#!/bin/bash

# InvokeAI 管理
# 设置 INVOKEAI_ROOT 环境变量指定 InvokeAI 存放数据文件路径
invokeai_manager() {
    local dialog_arg
    export INVOKEAI_ROOT="${INVOKEAI_PATH}/invokeai"

    cd "${START_PATH}" # 回到最初路径
    exit_venv # 确保进行下一步操作前已退出其他虚拟环境
    if [[ -d "${INVOKEAI_PATH}" ]]; then # 找到invokeai文件夹
        while true; do
            cd "${INVOKEAI_PATH}"
            enter_venv # 进入环境
            if ! which invokeai-web 2> /dev/null ;then
                exit_venv # 退出原来的环境
                create_venv # 尝试重新生成虚拟环境,解决因为路径移动导致虚拟环境无法进入,然后检测不到invokeai
                enter_venv # 进入环境
            fi
            if which invokeai-web &> /dev/null ;then #查找环境中有没有invokeai
                dialog_arg=$(dialog --erase-on-exit --notags \
                    --title "InvokeAI 管理" \
                    --backtitle "InvokeAI 管理选项" \
                    --ok-label "确认" --cancel-label "取消" \
                    --menu "请选择 InvokeAI 管理选项的功能" \
                    $(get_dialog_size_menu) \
                    "0" "> 返回" \
                    "1" "> 启动" \
                    "2" "> 更新" \
                    "3" "> 更新依赖" \
                    "4" "> Python 软件包安装 / 重装 / 卸载" \
                    "5" "> 依赖库版本管理" \
                    "6" "> 重新安装 PyTorch" \
                    "7" "> 修复虚拟环境" \
                    "8" "> 重新构建虚拟环境" \
                    "9" "> 重新安装" \
                    "10" "> 卸载" \
                    3>&1 1>&2 2>&3)

                case "${dialog_arg}" in
                    1)
                        invokeai_launch
                        ;;
                    2)
                        # 更新前的准备
                        download_mirror_select # 下载镜像源选择
                        pip_install_mode_select # 安装方式选择
                        if term_sd_install_confirm "是否更新 InvokeAI ?"; then
                            term_sd_echo "更新 InvokeAI 中"
                            term_sd_tmp_disable_proxy # 临时取消代理,避免一些不必要的网络减速
                            install_python_package --upgrade invokeai
                            if [[ "$?" == 0 ]]; then
                                dialog --erase-on-exit \
                                    --title "InvokeAI 管理" \
                                    --backtitle "InvokeAI 更新结果" \
                                    --ok-label "确认" \
                                    --msgbox "InvokeAI 更新成功" \
                                    $(get_dialog_size)
                            else
                                dialog --erase-on-exit \
                                    --title "InvokeAI 管理" \
                                    --backtitle "InvokeAI 更新结果" \
                                    --ok-label "确认" \
                                    --msgbox "InvokeAI 更新失败" \
                                    $(get_dialog_size)
                            fi
                            term_sd_tmp_enable_proxy # 恢复原有的代理
                        fi
                        ;;
                    3)
                            if (dialog --erase-on-exit \
                                --title "InvokeAI 管理" \
                                --backtitle "InvokeAI 依赖更新选项" \
                                --yes-label "是" --no-label "否" \
                                --yesno "是否更新 InvokeAI 的依赖 ?" \
                                $(get_dialog_size)); then

                                invokeai_update_depend
                            fi
                        ;;
                    4)
                        if (dialog --erase-on-exit \
                            --title "InvokeAI 管理" \
                            --backtitle "InvokeAI 的 Python 软件包安装 / 重装 / 卸载选项" \
                            --yes-label "是" --no-label "否" \
                            --yesno "是否进入 Python 软件包安装 / 重装 / 卸载选项 ?" \
                            $(get_dialog_size)); then

                            python_package_manager
                        fi
                        ;;
                    5)
                        python_package_ver_backup_manager
                        ;;
                    6)
                        pytorch_reinstall
                        ;;
                    7)
                        if is_use_venv; then
                            if (dialog --erase-on-exit \
                                --title "InvokeAI 管理" \
                                --backtitle "InvokeAI 虚拟环境修复选项" \
                                --yes-label "是" --no-label "否" \
                                --yesno "是否修复 InvokeAI 的虚拟环境 ?" \
                                $(get_dialog_size)); then

                                fix_venv
                                enter_venv
                                install_python_package $(term_sd_pip freeze | grep -i invokeai) --no-deps --force-reinstall # 重新安装invokeai
                            fi
                        else
                            dialog --erase-on-exit \
                                --title "InvokeAI 管理" \
                                --backtitle "InvokeAI 虚拟环境修复选项" \
                                --ok-label "确认" \
                                --msgbox "虚拟环境功能已禁用, 无法使用该功能" \
                                $(get_dialog_size)
                        fi
                        ;;
                    8)
                        if is_use_venv; then
                            if (dialog --erase-on-exit \
                                --title "InvokeAI 管理" \
                                --backtitle "InvokeAI 虚拟环境重建选项" \
                                --yes-label "是" --no-label "否" \
                                --yesno "是否重建 InvokeAI 的虚拟环境 ?" \
                                $(get_dialog_size)); then

                                invokeai_venv_rebuild
                                dialog --erase-on-exit \
                                    --title "InvokeAI 管理" \
                                    --backtitle "InvokeAI 虚拟环境重建选项" \
                                    --ok-label "确认" \
                                    --msgbox "InvokeAI 虚拟环境重建完成" \
                                    $(get_dialog_size)
                            fi
                        else
                            dialog --erase-on-exit \
                                --title "InvokeAI 管理" \
                                --backtitle "InvokeAI 虚拟环境重建选项" \
                                --ok-label "确认" \
                                --msgbox "虚拟环境功能已禁用, 无法使用该功能" \
                                $(get_dialog_size)
                        fi
                        ;;
                    9)
                        if (dialog --erase-on-exit \
                            --title "InvokeAI 管理" \
                            --backtitle "InvokeAI 重新安装选项" \
                            --yes-label "是" --no-label "否" \
                            --yesno "是否重新安装 InvokeAI ?" \
                            $(get_dialog_size)); then

                            cd "${START_PATH}"
                            rm -f "${START_PATH}/term-sd/task/invokeai_install.sh"
                            exit_venv
                            install_invokeai
                            break
                        fi
                        ;;
                    10)
                        if (dialog --erase-on-exit \
                            --title "InvokeAI 管理" \
                            --backtitle "InvokeAI 删除选项" \
                            --yes-label "是" --no-label "否" \
                            --yesno "是否删除 InvokeAI ?" \
                            $(get_dialog_size)); then

                            term_sd_echo "请再次确认是否删除 InvokeAI (yes/no) ?"
                            term_sd_echo "警告: 该操作将永久删除 InvokeAI"
                            term_sd_echo "提示: 输入 yes 或 no 后回车"
                            case "$(term_sd_read)" in
                                yes|y|YES|Y)
                                    exit_venv
                                    term_sd_echo "删除 InvokeAI 中"
                                    cd ..
                                    rm -rf "${INVOKEAI_FOLDER}"

                                    dialog --erase-on-exit \
                                        --title "InvokeAI 管理" \
                                        --backtitle "InvokeAI 删除选项" \
                                        --ok-label "确认" \
                                        --msgbox "删除 InvokeAI 完成" \
                                        $(get_dialog_size)

                                    break
                                    ;;
                                *)
                                    term_sd_echo "取消删除 InvokeAI 操作"
                                    ;;
                            esac
                        fi
                        ;;
                    *)
                        break
                        ;;
                esac
            else 
                if (dialog --erase-on-exit \
                    --title "InvokeAI 管理" \
                    --backtitle "InvokeAI 安装选项" \
                    --yes-label "是" --no-label "否" \
                    --yesno "检测到当前未安装 InvokeAI, 是否进行安装 ?" \
                    $(get_dialog_size)); then

                    cd "${INVOKEAI_PARENT_PATH}"
                    rm -f "${START_PATH}/term-sd/task/invokeai_install.sh"
                    install_invokeai
                    break
                else
                    break
                fi
            fi
        done
    else
        if (dialog --erase-on-exit \
            --title "InvokeAI 管理" \
            --backtitle "InvokeAI 安装选项" \
            --yes-label "是" --no-label "否" \
            --yesno "检测到当前未安装 InvokeAI, 是否进行安装 ?" \
            $(get_dialog_size)); then

            rm -f "${START_PATH}/term-sd/task/invokeai_install.sh"
            install_invokeai
        fi
    fi

    unset INVOKEAI_ROOT
}

# invokeai更新依赖
invokeai_update_depend() {
    # 更新前的准备
    download_mirror_select # 下载镜像源选择
    pip_install_mode_select # 安装方式选择

    if term_sd_install_confirm "是否更新 InvokeAI 依赖 ?"; then
        term_sd_print_line "InvokeAI 依赖更新"
        term_sd_echo "更新 InvokeAI 依赖中"
        term_sd_tmp_disable_proxy
        create_venv
        enter_venv
        term_sd_pip freeze | awk -F '==' '{print $1}' > requirements.txt #生成一个更新列表
        python_package_update "requirements.txt"
        rm -f requirements.txt
        exit_venv
        term_sd_tmp_enable_proxy
        term_sd_echo "更新 InvokeAI 依赖结束"
        term_sd_pause
    fi
    clean_install_config # 清理安装参数
}