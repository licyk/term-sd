#!/bin/bash

# InvokeAI 管理
# 设置 INVOKEAI_ROOT 环境变量指定 InvokeAI 存放数据文件路径
invokeai_manager() {
    local dialog_arg
    export INVOKEAI_ROOT="${INVOKEAI_ROOT_PATH}/invokeai"

    cd "${START_PATH}" # 回到最初路径
    exit_venv # 确保进行下一步操作前已退出其他虚拟环境
    if [[ -d "${INVOKEAI_ROOT_PATH}" ]]; then # 找到 InvokeAI 文件夹
        cd "${INVOKEAI_ROOT_PATH}"
        enter_venv
        if is_invokeai_installed; then # 检测 InvokeAI 是否安装
            while true; do
                cd "${INVOKEAI_ROOT_PATH}"

                dialog_arg=$(dialog --erase-on-exit --notags \
                    --title "InvokeAI 管理" \
                    --backtitle "InvokeAI 管理选项" \
                    --ok-label "确认" --cancel-label "取消" \
                    --menu "请选择 InvokeAI 管理选项的功能\n当前 InvokeAI 版本: $(get_invokeai_version)" \
                    $(get_dialog_size_menu) \
                    "0" "> 返回" \
                    "1" "> 启动" \
                    "2" "> 更新" \
                    "3" "> 自定义节点管理" \
                    "4" "> 切换版本" \
                    "5" "> 更新依赖" \
                    "6" "> Python 软件包安装 / 重装 / 卸载" \
                    "7" "> 依赖库版本管理" \
                    "8" "> 重新安装 PyTorch" \
                    "9" "> 修复虚拟环境" \
                    "10" "> 重新构建虚拟环境" \
                    "11" "> 重新安装" \
                    "12" "> 卸载" \
                    3>&1 1>&2 2>&3)

                case "${dialog_arg}" in
                    1)
                        invokeai_launch
                        ;;
                    2)
                        # 更新前的准备
                        download_mirror_select # 下载镜像源选择
                        pip_install_mode_select upgrade # 安装方式选择
                        if term_sd_install_confirm "是否更新 InvokeAI ?"; then
                            term_sd_echo "更新 InvokeAI 中"
                            term_sd_tmp_disable_proxy # 临时取消代理,避免一些不必要的网络减速
                            install_python_package invokeai
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
                        clean_install_config # 清理安装参数
                        ;;
                    3)
                        invokeai_custom_node_manager
                        ;;
                    4)
                        if (dialog --erase-on-exit \
                            --title "InvokeAI 管理" \
                            --backtitle "InvokeAI 版本切换选项" \
                            --yes-label "是" --no-label "否" \
                            --yesno "是否切换 InvokeAI 版本 ?" \
                            $(get_dialog_size)); then

                            switch_invokeai_version
                        fi
                        ;;
                    5)
                            if (dialog --erase-on-exit \
                                --title "InvokeAI 管理" \
                                --backtitle "InvokeAI 依赖更新选项" \
                                --yes-label "是" --no-label "否" \
                                --yesno "是否更新 InvokeAI 的依赖 ?" \
                                $(get_dialog_size)); then

                                invokeai_update_depend
                            fi
                        ;;
                    6)
                        if (dialog --erase-on-exit \
                            --title "InvokeAI 管理" \
                            --backtitle "InvokeAI 的 Python 软件包安装 / 重装 / 卸载选项" \
                            --yes-label "是" --no-label "否" \
                            --yesno "是否进入 Python 软件包安装 / 重装 / 卸载选项 ?" \
                            $(get_dialog_size)); then

                            python_package_manager
                        fi
                        ;;
                    7)
                        python_package_ver_backup_manager
                        enter_venv
                        ;;
                    8)
                        pytorch_reinstall
                        enter_venv
                        ;;
                    9)
                        if is_use_venv; then
                            if (dialog --erase-on-exit \
                                --title "InvokeAI 管理" \
                                --backtitle "InvokeAI 虚拟环境修复选项" \
                                --yes-label "是" --no-label "否" \
                                --yesno "是否修复 InvokeAI 的虚拟环境 ?" \
                                $(get_dialog_size)); then

                                fix_venv
                                enter_venv
                                dialog --erase-on-exit \
                                    --title "InvokeAI 管理" \
                                    --backtitle "InvokeAI 虚拟环境修复选项" \
                                    --ok-label "确认" \
                                    --msgbox "InvokeAI 虚拟环境修复完成" \
                                    $(get_dialog_size)
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
                    10)
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
                    11)
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
                    12)
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
                                    rm -rf "${INVOKEAI_ROOT_PATH}"

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
            done
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
            fi
        fi
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

# InvokeAI 更新依赖
invokeai_update_depend() {
    # 更新前的准备
    download_mirror_select # 下载镜像源选择
    pip_install_mode_select upgrade # 安装方式选择

    if term_sd_install_confirm "是否更新 InvokeAI 依赖 ?"; then
        term_sd_print_line "InvokeAI 依赖更新"
        term_sd_echo "更新 InvokeAI 依赖中"
        term_sd_tmp_disable_proxy
        enter_venv
        get_python_env_pkg | awk -F '==' '{print $1}' > requirements.txt #生成一个更新列表
        python_package_update "requirements.txt"
        rm -f requirements.txt
        exit_venv
        term_sd_tmp_enable_proxy
        term_sd_echo "更新 InvokeAI 依赖结束"
        term_sd_pause
    fi
    clean_install_config # 清理安装参数
}

# 检测 InvokeAI 是否安装
is_invokeai_installed() {
    local status

    status=$(term_sd_python "${START_PATH}/term-sd/python_modules/check_invokeai_installed.py")

    if [[ "${status}" == "True" ]]; then
        return 0
    else
        return 1
    fi
}

# 切换 InvokeAI 版本
switch_invokeai_version() {
    local dialog_arg
    local invokeai_ver

    download_mirror_select # 下载镜像源选择
    pip_install_mode_select # 安装方式选择
    term_sd_echo "获取 InvokeAI 版本列表中"

    dialog_arg=$(dialog --erase-on-exit \
        --title "InvokeAI 管理" \
        --backtitle "InvokeAI 版本切换选项" \
        --ok-label "确认" --cancel-label "取消" \
        --menu "请选择要切换的 InvokeAI 版本\n当前 InvokeAI 版本: $(get_invokeai_version)" \
        $(get_dialog_size_menu) \
        "-->返回<--" "<-------------------" \
        $(term_sd_pip index versions invokeai --pre |\
            grep -oP "Available versions: \K.*" |\
            awk -F ',' '{ for (i = 1; i <= NF; i++) {print $i " <-------------------"} }' \
        ) \
        3>&1 1>&2 2>&3)

    if [[ "$?" == 0 ]]; then
        if [ ! "${dialog_arg}" == "-->返回<--" ]; then
            invokeai_ver=$dialog_arg
            term_sd_echo "当前选择的 InvokeAI 版本: ${invokeai_ver}"
            term_sd_echo "切换 InvokeAI 版本中"
            install_python_package "invokeai==${invokeai_ver}"
            if [[ "$?" == 0 ]]; then
                dialog --erase-on-exit \
                    --title "InvokeAI 管理" \
                    --backtitle "InvokeAI 版本切换选项" \
                    --ok-label "确认" \
                    --msgbox "切换 InvokeAI 版本成功, 当前版本为: ${invokeai_ver}" \
                    $(get_dialog_size)
            else
                dialog --erase-on-exit \
                    --title "InvokeAI 管理" \
                    --backtitle "InvokeAI 版本切换选项" \
                    --ok-label "确认" \
                    --msgbox "切换 InvokeAI 版本失败" \
                    $(get_dialog_size)
            fi
        else
            term_sd_echo "取消切换版本"
        fi
    else
        term_sd_echo "取消切换版本"
    fi
}

# 获取 InvokeAI 版本
get_invokeai_version() {
    local status

    status=$(term_sd_python "${START_PATH}/term-sd/python_modules/get_invokeai_version.py")

    if [[ "${status}" == "None" ]]; then
        echo "无"
    else
        echo "${status}"
    fi
}
