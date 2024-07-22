#!/bin/bash

# 安装 ComfyUI 的功能
# 使用 COMFYUI_EXTENSION_INSTALL_LIST 全局变量读取要安装的 ComfyUI 插件
# 使用 COMFYUI_CUSTOM_NODE_INSTALL_LIST 全局变量读取要安装的 ComfyUI 自定义节点
# 使用 COMFYUI_DOWNLOAD_MODEL_LIST 全局变量读取要下载的模型
install_comfyui() {
    local cmd_sum
    local cmd_point
    local i

    if [[ -f "${START_PATH}/term-sd/task/comfyui_install.sh" ]]; then # 检测到有未完成的安装任务时直接执行安装任务
        cmd_sum=$(( $(cat "${START_PATH}/term-sd/task/comfyui_install.sh" | wc -l) + 1 )) # 统计命令行数
        term_sd_print_line "ComfyUI 安装"
        for (( cmd_point=1; cmd_point <= cmd_sum; cmd_point++ )); do
            term_sd_echo "ComfyUI 安装进度: [${cmd_point}/${cmd_sum}]"

            term_sd_exec_cmd "${START_PATH}/term-sd/task/comfyui_install.sh" "${cmd_point}" # 执行安装命令

            if [[ ! "$?" == 0 ]]; then
                if term_sd_is_use_strict_install_mode; then
                    term_sd_echo "安装命令执行失败, 终止安装程序, 请检查控制台输出的报错信息"
                    term_sd_tmp_enable_proxy # 恢复代理
                    clean_install_config # 清理安装参数
                    term_sd_pause

                    dialog --erase-on-exit \
                        --title "ComfyUI 管理" \
                        --backtitle "ComfyUI 安装结果" \
                        --ok-label "确认" \
                        --msgbox "ComfyUI 安装进程执行失败, 请重试" \
                        $(get_dialog_size)

                    return 1
                else
                    term_sd_echo "忽略执行失败的命令"
                    term_sd_echo "提示: 忽略执行失败的命令可能会导致安装不完整或者缺失文件"
                fi
            fi
        done

        term_sd_tmp_enable_proxy # 恢复代理
        clean_install_config # 清理安装参数
        term_sd_echo "ComfyUI 安装结束"
        rm -f "${START_PATH}/term-sd/task/comfyui_install.sh" # 删除任务文件
        term_sd_print_line

        dialog --erase-on-exit \
            --title "ComfyUI 管理" \
            --backtitle "ComfyUI 安装结果" \
            --ok-label "确认" \
            --msgbox "ComfyUI 安装结束, 选择确定进入管理界面\n注:\n建议在进入 ComfyUI 管理界面后, 进入 \"管理自定义节点\" , 选择 \"安装全部自定义节点依赖\" 为自定义节点安装依赖, 保证自定义节点的正常运行" \
            $(get_dialog_size)

        comfyui_manager # 进入管理界面
    else
        # 安装前的准备
        download_mirror_select # 下载镜像源选择
        pytorch_version_select # PyTorch 版本选择
        comfyui_extension_install_select # 插件选择
        comfyui_custom_node_install_select # 自定义节点选择
        comfyui_download_model_select # 模型选择
        pip_install_mode_select # 安装方式选择

        if term_sd_install_confirm "是否安装 ComfUI ?"; then
            term_sd_print_line "ComfyUI 安装"
            term_sd_echo "生成安装任务中"
            term_sd_set_install_env_value >> "${START_PATH}/term-sd/task/comfyui_install.sh" # 环境变量
            cat "${START_PATH}/term-sd/install/comfyui/comfyui_core.sh" >> "${START_PATH}/term-sd/task/comfyui_install.sh" # 核心组件

            # 启用代理
            echo "__term_sd_task_sys term_sd_tmp_enable_proxy" >> "${START_PATH}/term-sd/task/comfyui_install.sh"

            # 读取安装插件命令
            if [[ ! -z "${COMFYUI_EXTENSION_INSTALL_LIST}" ]]; then
                echo "__term_sd_task_sys term_sd_echo \"安装插件中\"" >> "${START_PATH}/term-sd/task/comfyui_install.sh"
                # 读取安装插件命令列表
                for i in ${COMFYUI_EXTENSION_INSTALL_LIST}; do
                    cat "${START_PATH}/term-sd/install/comfyui/comfyui_extension.sh" | grep -w ${i} | awk '{sub(" ON "," ") ; sub(" OFF "," ")}1' >> "${START_PATH}/term-sd/task/comfyui_install.sh" # 插件
                done
            fi

            # 读取安装自定义节点命令
            if [[ ! -z "${COMFYUI_CUSTOM_NODE_INSTALL_LIST}" ]]; then
                echo "__term_sd_task_sys term_sd_echo \"安装自定义节点中\"" >> "${START_PATH}/term-sd/task/comfyui_install.sh"
                # 读取安装自定义节点列表
                for i in ${COMFYUI_CUSTOM_NODE_INSTALL_LIST}; do
                    cat "${START_PATH}/term-sd/install/comfyui/comfyui_custom_node.sh" | grep -w ${i} | awk '{sub(" ON "," ") ; sub(" OFF "," ")}1' >> "${START_PATH}/term-sd/task/comfyui_install.sh" # 插件
                done
            fi

            # 取消代理
            echo "__term_sd_task_sys term_sd_tmp_disable_proxy" >> "${START_PATH}/term-sd/task/comfyui_install.sh"

            # 读取模型下载命令
            if [[ ! -z "${COMFYUI_DOWNLOAD_MODEL_LIST}" ]]; then
                echo "__term_sd_task_sys term_sd_echo \"下载模型中\"" >> "${START_PATH}/term-sd/task/comfyui_install.sh"
                if is_use_modelscope_src; then
                    # 读取模型
                    for i in ${COMFYUI_DOWNLOAD_MODEL_LIST}; do
                        cat "${START_PATH}/term-sd/install/comfyui/comfyui_ms_model.sh" | grep -w ${i} >> "${START_PATH}/term-sd/task/comfyui_install.sh" # 插件所需的模型
                    done
                    # 读取扩展的模型
                    for i in ${COMFYUI_DOWNLOAD_MODEL_LIST}; do
                        cat "${START_PATH}/term-sd/install/comfyui/comfyui_custom_node_ms_model.sh" | grep -w ${i} >> "${START_PATH}/term-sd/task/comfyui_install.sh" # 自定义节点所需的模型
                    done
                else
                    # 恢复代理
                    echo "__term_sd_task_sys term_sd_tmp_enable_proxy" >> "${START_PATH}/term-sd/task/comfyui_install.sh"
                    # 读取模型
                    for i in ${COMFYUI_DOWNLOAD_MODEL_LIST}; do
                        cat "${START_PATH}/term-sd/install/comfyui/comfyui_hf_model.sh" | grep -w ${i} >> "${START_PATH}/term-sd/task/comfyui_install.sh" # 插件所需的模型
                    done
                    # 读取扩展的模型
                    for i in ${COMFYUI_DOWNLOAD_MODEL_LIST}; do
                        cat "${START_PATH}/term-sd/install/comfyui/comfyui_custom_node_hf_model.sh" | grep -w ${i} >> "${START_PATH}/term-sd/task/comfyui_install.sh" # 自定义节点所需的模型
                    done
                fi
            fi

            unset COMFYUI_EXTENSION_INSTALL_LIST
            unset COMFYUI_CUSTOM_NODE_INSTALL_LIST
            unset COMFYUI_DOWNLOAD_MODEL_LIST

            term_sd_echo "任务队列生成完成"
            term_sd_echo "开始安装 ComfyUI"

            # 执行安装命令
            cmd_sum=$(( $(cat "${START_PATH}/term-sd/task/comfyui_install.sh" | wc -l) + 1 )) # 统计命令行数
            for (( cmd_point=1; cmd_point <= cmd_sum; cmd_point++ )); do
                term_sd_echo "ComfyUI 安装进度: [${cmd_point}/${cmd_sum}]"

                term_sd_exec_cmd "${START_PATH}/term-sd/task/comfyui_install.sh" "${cmd_point}" # 执行安装命令

                if [[ ! "$?" == 0 ]]; then
                    if term_sd_is_use_strict_install_mode; then
                        term_sd_echo "安装命令执行失败, 终止安装程序, 请检查控制台输出的报错信息"
                        term_sd_tmp_enable_proxy # 恢复代理
                        clean_install_config # 清理安装参数
                        term_sd_pause

                        dialog --erase-on-exit \
                            --title "ComfyUI 管理" \
                            --backtitle "ComfyUI 安装结果" \
                            --ok-label "确认" \
                            --msgbox "ComfyUI 安装进程执行失败, 请重试" \
                            $(get_dialog_size)

                        return 1
                    else
                        term_sd_echo "忽略执行失败的命令"
                        term_sd_echo "提示: 忽略执行失败的命令可能会导致安装不完整或者缺失文件"
                    fi
                fi
            done

            term_sd_tmp_enable_proxy # 恢复代理
            clean_install_config # 清理安装参数
            term_sd_echo "ComfyUI 安装结束"
            rm -f "${START_PATH}/term-sd/task/comfyui_install.sh" # 删除任务文件
            term_sd_print_line

            dialog --erase-on-exit \
                --title "ComfyUI 管理" \
                --backtitle "ComfyUI 安装结果" \
                --ok-label "确认" \
                --msgbox "ComfyUI 安装结束, 选择确定进入管理界面\n注:\n建议在进入 ComfyUI 管理界面后, 进入 \"管理自定义节点\" , 选择 \"安装全部自定义节点依赖\" 为自定义节点安装依赖, 保证自定义节点的正常运行" \
                $(get_dialog_size)

            comfyui_manager # 进入管理界面
        else
            unset COMFYUI_EXTENSION_INSTALL_LIST
            unset COMFYUI_CUSTOM_NODE_INSTALL_LIST
            unset COMFYUI_DOWNLOAD_MODEL_LIST
            clean_install_config # 清理安装参数
        fi
    fi
}

# ComfyUI 插件选择
# 将选择的 ComfyUI 插件保存在 COMFYUI_EXTENSION_INSTALL_LIST 全局变量
comfyui_extension_install_select() {
    COMFYUI_EXTENSION_INSTALL_LIST=$(dialog --erase-on-exit --notags \
        --title "ComfyUI 安装" \
        --backtitle "ComfyUI 插件安装选项" \
        --ok-label "确认" --no-cancel \
        --checklist "请选择需要安装的 ComfyUI 插件" \
        $(get_dialog_size_menu) \
        $(cat "${START_PATH}/term-sd/install/comfyui/dialog_comfyui_extension.sh") \
        3>&1 1>&2 2>&3)
}

# ComfyUI 自定义节点选择
# 将选择的 ComfyUI 自定义节点保存在 COMFYUI_CUSTOM_NODE_INSTALL_LIST 全局变量中
comfyui_custom_node_install_select() {
    COMFYUI_CUSTOM_NODE_INSTALL_LIST=$(dialog --erase-on-exit --notags \
        --title "ComfyUI 安装" \
        --backtitle "ComfyUI 自定义节点安装选项" \
        --ok-label "确认" --no-cancel \
        --checklist "请选择需要安装的 ComfyUI 自定义节点" \
        $(get_dialog_size_menu) \
        $(cat "${START_PATH}/term-sd/install/comfyui/dialog_comfyui_custom_node.sh") \
        3>&1 1>&2 2>&3)
}

# 模型选择
# 使用 COMFYUI_CUSTOM_NODE_INSTALL_LIST 全局变量读取 ComfyUI 自定义节点对应需要下载的模型
# 将选择的模型保存在 COMFYUI_DOWNLOAD_MODEL_LIST 全局变量中
comfyui_download_model_select() {
    local model_list_file
    local dialog_list_file
    local model_list
    local i

    # 插件模型列表选择
    if is_use_modelscope_src; then
        model_list_file="comfyui_custom_node_ms_model.sh"
        dialog_list_file="dialog_comfyui_ms_model.sh"
    else
        model_list_file="comfyui_custom_node_hf_model.sh"
        dialog_list_file="dialog_comfyui_hf_model.sh"
    fi

    term_sd_echo "生成模型选择列表中"
    # 查找插件对应模型的编号
    for i in ${COMFYUI_CUSTOM_NODE_INSTALL_LIST}; do
        model_list="${model_list} $(cat "${START_PATH}"/term-sd/install/comfyui/${model_list_file} | grep -w ${i} | awk 'NR==1{if ($NF!="") {print $1 " " $(NF-1) " " $NF} }')"
    done

    # 模型选择(包含基础模型和插件的模型)
    COMFYUI_DOWNLOAD_MODEL_LIST=$(dialog --erase-on-exit --notags \
        --title "ComfyUI 安装" \
        --backtitle "ComfyUI 模型下载选项" \
        --ok-label "确认" --no-cancel \
        --checklist "请选择需要下载的 ComfyUI 模型\n注:\n1、模型后面括号内数字为模型的大小\n2、需要根据自己的需求勾选需要下载的模型" \
        $(get_dialog_size_menu) \
        "_null_" "=====基础模型选择=====" ON \
        $(cat "${START_PATH}/term-sd/install/comfyui/${dialog_list_file}") \
        "_null_" "=====插件模型选择=====" ON \
        $model_list \
        3>&1 1>&2 2>&3)
}
