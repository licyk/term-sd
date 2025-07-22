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
                    "9" "> 切换 PyTorch 类型" \
                    "10" "> 修复虚拟环境" \
                    "11" "> 重新构建虚拟环境" \
                    "12" "> 重新安装" \
                    "13" "> 卸载" \
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
                            update_invokeai_version
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
                        switch_pytorch_type_for_invokeai
                        ;;
                    10)
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
                    11)
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
                    12)
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
                    13)
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
        get_python_env_pkg | awk -F '==' '{print $1}' > requirements.txt # 生成一个更新列表
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
    local device_type

    download_mirror_select # 下载镜像源选择
    pip_install_mode_select # 安装方式选择
    term_sd_echo "获取原 PyTorch 类型"
    device_type=$(term_sd_python "${START_PATH}/term-sd/python_modules/get_pytorch_type.py")
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
        if [[ ! "${dialog_arg}" == "-->返回<--" ]]; then
            invokeai_ver=$dialog_arg
            term_sd_echo "当前选择的 InvokeAI 版本: ${invokeai_ver}"
            term_sd_echo "切换 InvokeAI 版本中"
            update_or_switch_invokeai_version_process "${device_type}" "${invokeai_ver}"
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
    clean_install_config # 清理安装参数
}

# 更新 InvokeAI
update_invokeai_version() {
    local device_type
    term_sd_echo "获取原 PyTorch 类型"
    device_type=$(term_sd_python "${START_PATH}/term-sd/python_modules/get_pytorch_type.py")
    term_sd_echo "更新 InvokeAI 中"
    update_or_switch_invokeai_version_process "${device_type}" "latest"
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

# 获取 InvokeAI 当前版本对应的 PyTorch 所需的PyTorch镜像源类型
# 使用:
# get_pytorch_mirror_type_for_invokeai <显卡类型>
# 可用的显卡类型: cuda, rocm, ipex, cpu
# 返回: PyTorch 镜像源类型
get_pytorch_mirror_type_for_invokeai() {
    local status
    local device_type=$@
    status=$(term_sd_python "${START_PATH}/term-sd/python_modules/get_pytorch_mirror_type.py" --device-type "${device_type}")
    echo "${status}"
}

# 配置安装 InvokeAI 所需的 PyTorch 安装信息
# 使用:
# set_pytorch_install_config_for_invokeai <显卡类型>
# 设置 PYTORCH_TYPE, INSTALL_PYTORCH_VERSION, INSTALL_XFORMERS_VERSION 全局变量进行 PyTorch 安装信息配置
# 使用时需确保 InvokeAI 核心包已被安装
set_pytorch_install_config_for_invokeai() {
    local device_type=$@
    local pytorch_ver
    local xformers_ver
    term_sd_echo "配置 InvokeAI 所需 PyTorch 的安装信息"
    PYTORCH_TYPE=$(get_pytorch_mirror_type_for_invokeai "${device_type}")
    pytorch_ver=$(term_sd_python "${START_PATH}/term-sd/python_modules/get_invokeai_require_pytorch.py")
    xformers_ver=$(term_sd_python "${START_PATH}/term-sd/python_modules/get_invokeai_require_xformers.py")
    if [[ "${PYTORCH_TYPE}" == "cpu" ]]; then
        INSTALL_PYTORCH_VERSION=$pytorch_ver
    else
        INSTALL_PYTORCH_VERSION="${pytorch_ver} ${xformers_ver}" # 合并依赖需求
    fi

    if term_sd_is_debug; then
        term_sd_echo "PYTORCH_TYPE: ${PYTORCH_TYPE}"
        term_sd_echo "pytorch_ver: ${pytorch_ver}"
        term_sd_echo "xformers_ver: ${xformers_ver}"
        term_sd_echo "INSTALL_PYTORCH_VERSION: ${INSTALL_PYTORCH_VERSION}"
    fi

    term_sd_echo "InvokeAI 所需 PyTorch 的安装信息配置完成"
}

# 同步 InvokeAI 组件
# 使用:
# sync_invokeai_component <显卡类型> <可选参数: force_reinstall (用于强制切换 PyTorch 版本)>
sync_invokeai_component() {
    local invokeai_package_ver
    local device_type=$1
    local force_reinstall_pytorch=$2
    invokeai_package_ver=$(get_invokeai_version)
    [[ "${invokeai_package_ver}" == "无" ]] && invokeai_package_ver="invokeai"
    term_sd_echo "同步 InvokeAI 组件中"
    set_pytorch_install_config_for_invokeai "${device_type}" # 配置 PyTorch 安装信息
    term_sd_echo "同步 PyTorch 组件中"
    if [[ "${force_reinstall_pytorch}" == "force_reinstall" ]]; then
        PIP_FORCE_REINSTALL_ARG="--force-reinstall" process_pytorch || return 1 # 安装 PyTorch
    else
        process_pytorch || return 1 # 安装 PyTorch
    fi
    term_sd_echo "同步 InvokeAI 其余组件中"
    install_python_package "invokeai==${invokeai_package_ver}" || return 1 # 安装 InvokeAI 依赖
    term_sd_echo "同步 InvokeAI 组件完成"
}

# 安装 InvokeAI 处理
# 使用:
# install_invokeai_process <显卡类型>
install_invokeai_process() {
    local device_type=$@
    install_python_package invokeai --no-deps || return 1
    sync_invokeai_component "${device_type}" || return 1
}

# 更新 / 切换 InvokeAI 版本处理
# 使用:
# switch_invokeai_version_process <显卡类型> <InvokeAI 版本> <可选参数: force_reinstall (用于强制切换 PyTorch 版本)>
# 当 <InvokeAI 版本> 指定为 latest 时, 则更新 InvokeAI 到最新版本
# 否则切换到指定的 InvokeAI 版本
update_or_switch_invokeai_version_process() {
    local device_type=$1
    local invokeai_version=$2
    local force_reinstall_pytorch=$3
    local current_version

    current_version=$(get_invokeai_version)
    [[ "${current_version}" == "无" ]] && current_version="5.0.2"

    if [[ "${invokeai_version}" == "latest" ]]; then
        term_sd_echo "更新 InvokeAI 内核中"
        install_python_package invokeai --no-deps
    else
        term_sd_echo "切换 InvokeAI 内核版本到 ${invokeai_version} 中"
        install_python_package "invokeai==${invokeai_version}" --no-deps
    fi

    if [[ "$?" == 0 ]]; then
        # 内核更新成功时再同步组件版本
        term_sd_echo "切换 InvokeAI 内核版本完成, 开始同步组件版本中"
        if sync_invokeai_component "${device_type}" "${force_reinstall_pytorch}"; then
            term_sd_echo "InvokeAI 版本切换成功"
            return 0
        else
            term_sd_echo "InvokeAI 组件同步失败, 回退 InvokeAI 版本中"
            install_python_package "invokeai==${current_version}" --no-deps
            term_sd_echo "回退 InvokeAI 版本结束"
            return 1
        fi
    else
        term_sd_echo "InvokeAI 内核版本切换失败"
        return 1
    fi
}

# 切换 InvokeAI 环境的 PyTorch 类型
switch_pytorch_type_for_invokeai() {
    local current_version
    if (dialog --erase-on-exit \
        --title "InvokeAI 管理" \
        --backtitle "InvokeAI 环境 PyTorch 类型切换选项" \
        --yes-label "是" --no-label "否" \
        --yesno "是否切换 PyTorch 类型 ?" \
        $(get_dialog_size)); then

        pytorch_type_select # 选择 PyTorch 类型
        download_mirror_select # 下载镜像源选择
        pip_install_mode_select # 安装方式选择

        if term_sd_install_confirm "是否切换 PyTorch 类型 ?"; then
            term_sd_echo "开始切换 PyTorch 类型"
            current_version=$(get_invokeai_version)
            [[ "${current_version}" == "无" ]] && current_version="5.0.2"

            update_or_switch_invokeai_version_process "${PYTORCH_TYPE}" "${current_version}" "force_reinstall"
            if [[ "$?" == 0 ]]; then
                dialog --erase-on-exit \
                    --title "InvokeAI 管理" \
                    --backtitle "InvokeAI 环境 PyTorch 类型切换选项" \
                    --ok-label "确认" \
                    --msgbox "切换 PyTorch 类型成功" \
                    $(get_dialog_size)
            else
                dialog --erase-on-exit \
                    --title "InvokeAI 管理" \
                    --backtitle "InvokeAI 环境 PyTorch 类型切换选项" \
                    --ok-label "确认" \
                    --msgbox "切换 PyTorch 类型失败" \
                    $(get_dialog_size)
            fi
        else
            term_sd_echo "取消切换 PyTorch 类型"
        fi
        clean_install_config # 清理安装参数
    else
        term_sd_echo "取消切换 PyTorch 类型"
    fi
}
