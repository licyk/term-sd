#!/bin/bash

# ComfyUI 插件 / 自定义节点依赖一键安装
# 使用:
# comfyui_extension_depend_install <提示信息>
# 使用时将检测 ComfyUI 插件 / 自定义节点文件夹中包含的 install.py 文件和 requirements.txt 文件
# 如果检测到上述文件, 将通过文件安装依赖
comfyui_extension_depend_install() {
    local install_msg
    local count=0
    local sum=0
    local depend_sum=0
    local success_count=0
    local fail_count=0
    local i
    local depend_type=$1

    # 安装前的准备
    download_mirror_select # 下载镜像源选择
    pip_install_mode_select # 安装方式选择

    if term_sd_install_confirm "是否安装 ComfyUI 插件 / 自定义节点依赖 ?"; then
        term_sd_print_line "${TERM_SD_MANAGE_OBJECT} ${depend_type}依赖一键安装"
        term_sd_tmp_disable_proxy
        enter_venv "${COMFYUI_PATH}"

        for i in ./*; do # 统计需要安装的依赖
            [[ -f "${i}" ]] && continue # 排除文件
            if [[ -f "${i}/install.py" ]] || [[ -f "${i}/requirements.txt" ]]; then
                count=$(( count + 1 ))
            fi
        done

        for i in ./*; do
            [[ -f "${i}" ]] && continue # 排除文件
            cd "${i}"
            if [[ -f "install.py" ]] || [[ -f "requirements.txt" ]]; then
                sum=$(( sum + 1 ))
                term_sd_echo "[${sum}/${count}] 安装 $(echo ${i} | awk -F "/" '{print $NF}') ${depend_type}依赖"
                install_msg="${install_msg} $(basename "${i}"):\n" # 作为显示安装结果信息
            fi

            if [[ -f "install.py" ]]; then # 找到 install.py 文件
                depend_sum=$(( depend_sum + 1 ))
                term_sd_try term_sd_python install.py
                if [[ "$?" = 0 ]]; then # 记录退出状态
                    install_msg="${install_msg}     run install.py: 成功 ✓\n"
                    success_count=$((success_count + 1))
                else
                    install_msg="${install_msg}     run install.py: 失败 ×\n"
                    fail_count=$((fail_count + 1))
                fi
            fi

            if [[ -f "requirements.txt" ]]; then # 找到requirement.txt文件
                depend_sum=$(( depend_sum + 1 ))
                install_python_package -r requirements.txt
                if [[ "$?" = 0 ]]; then # 记录退出状态
                    install_msg="${install_msg}     install requirements.txt: 成功 ✓\n"
                    success_count=$(( success_count + 1 ))
                else
                    install_msg="${install_msg}     install requirements.txt: 失败 ×\n"
                    fail_count=$(( fail_count + 1 ))
                fi
            fi
            cd ..
        done
        exit_venv
        term_sd_tmp_enable_proxy
        term_sd_print_line

        dialog --erase-on-exit \
            --title "ComfyUI管理" \
            --backtitle "ComfyUI ${depend_type}依赖安装结果" \
            --ok-label "确认" \
            --msgbox "当前依赖的安装情况列表\n[●: ${depend_sum} | ✓: ${success_count} | ×: ${fail_count}]\n${TERM_SD_DELIMITER}\n${install_msg}${TERM_SD_DELIMITER}" \
            $(get_dialog_size)
    else
        term_sd_echo "取消安装 ComfyUI 插件 / 自定义节点依赖"
    fi
    clean_install_config # 清理安装参数
}

# 单独为 ComfyUI 插件 / 自定义节点安装依赖的功能
# 使用: 
# comfyui_extension_depend_install_single <提示内容> <插件 / 自定义节点名称>
# 安装依赖结束后将弹窗提示安装结果
comfyui_extension_depend_install_single() {
    local install_msg
    local depend_type=$1
    local name=$2

    name=$(basename "$(pwd)")
    # 安装前的准备
    download_mirror_select # 下载镜像源选择
    pip_install_mode_select # 安装方式选择

    if term_sd_install_confirm "是否安装 ${name} ${depend_type}依赖 ?"; then
        enter_venv "${COMFYUI_PATH}"

        if [[ -f "install.py" ]] || [[ -f "requirements.txt" ]]; then
            term_sd_echo "安装 ${name} ${depend_type}依赖"
            install_msg="${install_msg}\n ${name}${depend_type}:\n" # 作为显示安装结果信息
        fi

        if [[ -f "install.py" ]]; then # 找到 install.py 文件
            term_sd_try term_sd_python install.py
            if [[ "$?" == 0 ]]; then # 记录退出状态
                install_msg="${install_msg}     run install.py: 成功 ✓\n"
            else
                install_msg="${install_msg}     run install.py: 失败 ×\n"
            fi
        fi

        if [[ -f "requirements.txt" ]]; then # 找到requirement.txt文件
            install_python_package -r requirements.txt
            if [[ "$?" == 0 ]]; then # 记录退出状态
                install_msg="${install_msg}     install requirements.txt: 成功 ✓\n"
            else
                install_msg="${install_msg}     install requirements.txt: 失败 ×\n"
            fi
        fi

        exit_venv

        dialog --erase-on-exit \
            --title "ComfyUI选项" \
            --backtitle "ComfyUI ${depend_type}依赖安装结果" \
            --ok-label "确认" \
            --msgbox "当前 ${name} ${depend_type}依赖的安装情况\n${TERM_SD_DELIMITER}${install_msg}${TERM_SD_DELIMITER}" \
            $(get_dialog_size)
    fi
    clean_install_config # 清理安装参数
}

# 插件/自定义节点依赖安装(自动)
# 使用:
# comfyui_extension_depend_install_auto <提示内容> <目录>
# COMFYUI_CUSTOM_NODE_INSTALL_DEP_MESSAGE 变量用于返回安装依赖的信息
comfyui_extension_depend_install_auto() {
    local depend_type=$1
    local extension_name=$2
    if [[ -f "$2/requirements.txt" ]] || [[ -f "$2/install.py" ]]; then
        term_sd_echo "开始安装 ${extension_name} ${depend_type}依赖"
        COMFYUI_CUSTOM_NODE_INSTALL_DEP_MESSAGE="${COMFYUI_CUSTOM_NODE_INSTALL_DEP_MESSAGE}\n\n${extension_name} ${depend_type}依赖安装:\n"

        enter_venv "${COMFYUI_PATH}"
        cd "${extension_name}"

        if [[ -f "install.py" ]]; then # 找到install.py文件
            term_sd_try term_sd_python install.py
            if [[ "$?" == 0 ]]; then # 记录退出状态
                COMFYUI_CUSTOM_NODE_INSTALL_DEP_MESSAGE="${COMFYUI_CUSTOM_NODE_INSTALL_DEP_MESSAGE}     run install.py: 成功 ✓\n"
            else
                COMFYUI_CUSTOM_NODE_INSTALL_DEP_MESSAGE="${COMFYUI_CUSTOM_NODE_INSTALL_DEP_MESSAGE}     run install.py: 失败 ×\n"
            fi
        fi

        if [[ -f "requirements.txt" ]]; then # 找到requirement.txt文件
            install_python_package -r requirements.txt
            if [[ "$?" == 0 ]]; then # 记录退出状态
                COMFYUI_CUSTOM_NODE_INSTALL_DEP_MESSAGE="${COMFYUI_CUSTOM_NODE_INSTALL_DEP_MESSAGE}     install requirements.txt: 成功 ✓\n"
            else
                COMFYUI_CUSTOM_NODE_INSTALL_DEP_MESSAGE="${COMFYUI_CUSTOM_NODE_INSTALL_DEP_MESSAGE}     install requirements.txt: 失败 ×\n"
            fi
        fi
        cd ..
        exit_venv
    fi
}