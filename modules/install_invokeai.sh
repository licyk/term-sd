#!/bin/bash

# InvokeAI 安装功能
# 使用 INVOKEAI_INSTALL_CUSTOM_NODE_LIST 读取要安装的自定义节点
# 使用 INVOKEAI_DOWNLOAD_MODEL_LIST 读取要下载的模型
install_invokeai() {
    local cmd_sum
    local cmd_point
    local i

    if [ -f "${START_PATH}/term-sd/task/invokeai_install.sh" ]; then # 检测到有未完成的安装任务时直接执行安装任务
        cmd_sum=$(( $(cat "${START_PATH}/term-sd/task/invokeai_install.sh" | wc -l) + 1 )) # 统计命令行数
        term_sd_print_line "InvokeAI 安装"
        for (( cmd_point=1; cmd_point <= cmd_sum; cmd_point++ )); do
            term_sd_echo "InvokeAI 安装进度: [${cmd_point}/${cmd_sum}]"

            term_sd_exec_cmd "${START_PATH}/term-sd/task/invokeai_install.sh" "${cmd_point}"

            if [ ! $? = 0 ]; then
                if term_sd_is_use_strict_install_mode; then
                    term_sd_echo "安装命令执行失败, 终止安装程序, 请检查控制台输出的报错信息"
                    term_sd_tmp_enable_proxy # 恢复代理
                    clean_install_config # 清理安装参数
                    term_sd_pause

                    dialog --erase-on-exit \
                        --title "InvokeAI 管理" \
                        --backtitle "InvokeAI 安装结果" \
                        --ok-label "确认" \
                        --msgbox "InvokeAI 安装进程执行失败, 请重试" \
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
        term_sd_echo "InvokeAI 安装结束"
        rm -f "${START_PATH}/term-sd/task/invokeai_install.sh" # 删除任务文件
        term_sd_print_line

        dialog --erase-on-exit \
            --title "InvokeAI 管理" \
            --backtitle "InvokeAI 安装结果" \
            --ok-label "确认" \
            --msgbox "InvokeAI 安装结束, 选择确定进入管理界面" \
            $(get_dialog_size)

        invokeai_manager # 进入管理界面
    else # 生成安装任务并执行安装任务
        # 安装前的准备
        download_mirror_select # 下载镜像源选择
        pytorch_type_select # PyTorch 版本选择
        invokeai_custom_node_install_select # 自定义节点选择
        invokeai_download_model_select # 模型选择
        pip_install_mode_select # 安装方式选择

        if term_sd_install_confirm "是否安装 InvokeAI ?"; then
            term_sd_print_line "InvokeAI 安装"
            term_sd_echo "生成安装任务中"
            term_sd_set_install_env_value >> "${START_PATH}/term-sd/task/invokeai_install.sh" # 环境变量
            cat "${START_PATH}/term-sd/install/invokeai/invokeai_core.sh" >> "${START_PATH}/term-sd/task/invokeai_install.sh" # 核心组件

            # 启用代理
            echo "__term_sd_task_sys term_sd_tmp_enable_proxy" >> "${START_PATH}/term-sd/task/invokeai_install.sh"

            # 读取安装自定义节点命令
            if [[ ! -z "${INVOKEAI_INSTALL_CUSTOM_NODE_LIST}" ]]; then
                echo "__term_sd_task_sys term_sd_echo \"安装自定义节点中\"" >> "${START_PATH}/term-sd/task/invokeai_install.sh"
                # 读取安装自定义节点命令列表
                for i in ${INVOKEAI_INSTALL_CUSTOM_NODE_LIST}; do
                    cat "${START_PATH}/term-sd/install/invokeai/invokeai_custom_node.sh" | grep -w ${i} | awk '{sub(" ON "," ") ; sub(" OFF "," ")}1' >> "${START_PATH}/term-sd/task/invokeai_install.sh" # 自定义节点
                done
            fi

            # 取消代理
            echo "__term_sd_task_sys term_sd_tmp_disable_proxy" >> "${START_PATH}/term-sd/task/invokeai_install.sh"

            # 模型下载
            if [[ ! -z "${INVOKEAI_DOWNLOAD_MODEL_LIST}" ]]; then
                echo "__term_sd_task_sys term_sd_echo \"下载模型中\"" >> "${START_PATH}/term-sd/task/invokeai_install.sh"
                if is_use_modelscope_src; then
                    # 读取模型
                    for i in ${INVOKEAI_DOWNLOAD_MODEL_LIST}; do
                        cat "${START_PATH}/term-sd/install/invokeai/invokeai_ms_model.sh" | grep -w ${i} >> "${START_PATH}/term-sd/task/invokeai_install.sh" # 自定义节点所需的模型
                    done
                    # 读取自定义节点的模型
                    for i in ${INVOKEAI_DOWNLOAD_MODEL_LIST}; do
                        cat "${START_PATH}/term-sd/install/invokeai/invokeai_custom_node_ms_model.sh" | grep -w ${i} >> "${START_PATH}/term-sd/task/invokeai_install.sh" # 自定义节点所需的模型
                    done
                else
                    # 恢复代理
                    echo "__term_sd_task_sys term_sd_tmp_enable_proxy" >> "${START_PATH}/term-sd/task/invokeai_install.sh"
                    # 读取模型
                    for i in ${INVOKEAI_DOWNLOAD_MODEL_LIST}; do
                        cat "${START_PATH}/term-sd/install/invokeai/invokeai_hf_model.sh" | grep -w ${i} >> "${START_PATH}/term-sd/task/invokeai_install.sh" # 自定义节点所需的模型
                    done
                    # 读取自定义节点的模型
                    for i in ${INVOKEAI_DOWNLOAD_MODEL_LIST}; do
                        cat "${START_PATH}/term-sd/install/invokeai/invokeai_custom_node_hf_model.sh" | grep -w ${i} >> "${START_PATH}/term-sd/task/invokeai_install.sh" # 自定义节点所需的模型
                    done
                fi
            fi

            unset INVOKEAI_DOWNLOAD_MODEL_LIST
            unset INVOKEAI_INSTALL_CUSTOM_NODE_LIST

            term_sd_echo "任务队列生成完成"
            term_sd_echo "开始安装 InvokeAI"

            # 执行命令
            cmd_sum=$(( $(cat "${START_PATH}/term-sd/task/invokeai_install.sh" | wc -l) + 1 )) # 统计命令行数
            for ((cmd_point=1; cmd_point <= cmd_sum; cmd_point++)); do
                term_sd_echo "InvokeAI 安装进度: [${cmd_point}/${cmd_sum}]"

                term_sd_exec_cmd "${START_PATH}/term-sd/task/invokeai_install.sh" "${cmd_point}"

                if [[ ! "$?" == 0 ]]; then
                    if term_sd_is_use_strict_install_mode; then
                        term_sd_echo "安装命令执行失败, 终止安装程序, 请检查控制台输出的报错信息"
                        term_sd_tmp_enable_proxy # 恢复代理
                        clean_install_config # 清理安装参数
                        term_sd_pause

                        dialog --erase-on-exit \
                            --title "InvokeAI 管理" \
                            --backtitle "InvokeAI 安装结果" \
                            --ok-label "确认" \
                            --msgbox "InvokeAI 安装进程执行失败, 请重试" \
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
            term_sd_echo "InvokeAI 安装结束"
            rm -f "${START_PATH}/term-sd/task/invokeai_install.sh" # 删除任务文件
            term_sd_print_line

            dialog --erase-on-exit \
                --title "InvokeAI 管理" \
                --backtitle "InvokeAI 安装结果" \
                --ok-label "确认" \
                --msgbox "InvokeAI 安装结束, 选择确定进入管理界面" \
                $(get_dialog_size)

            invokeai_manager # 进入管理界面
        else
            unset INVOKEAI_DOWNLOAD_MODEL_LIST
            unset INVOKEAI_INSTALL_CUSTOM_NODE_LIST
            clean_install_config # 清理安装参数
        fi
    fi
}

# 自定义节点选择
# 将选择的自定义节点保存在 INVOKEAI_INSTALL_CUSTOM_NODE_LIST 全局变量中
invokeai_custom_node_install_select() {
    INVOKEAI_INSTALL_CUSTOM_NODE_LIST=$(dialog --erase-on-exit --notags \
        --title "InvokeAI 安装" \
        --backtitle "InvokeAI 自定义节点安装选项" \
        --ok-label "确认" --no-cancel \
        --checklist "请选择需要安装的 InvokeAI 自定义节点" \
        $(get_dialog_size_menu) \
        $(cat "${START_PATH}/term-sd/install/invokeai/dialog_invokeai_custom_node.sh") \
        3>&1 1>&2 2>&3)
}

# 模型选择
# 将选择的模型保存在 INVOKEAI_DOWNLOAD_MODEL_LIST 全局变量中
invokeai_download_model_select() {
    local dialog_list_file
    local model_list
    local invokeai_model_list_file
    local i

    term_sd_echo "生成模型选择列表中"
    if is_use_modelscope_src; then
        dialog_list_file="dialog_invokeai_ms_model.sh"
        invokeai_model_list_file="invokeai_custom_node_ms_model.sh"
    else
        dialog_list_file="dialog_invokeai_hf_model.sh"
        invokeai_model_list_file="invokeai_custom_node_hf_model.sh"
    fi

    # 查找自定义节点对应模型的编号
    for i in ${INVOKEAI_INSTALL_CUSTOM_NODE_LIST}; do
        model_list="${model_list} $(cat "${START_PATH}"/term-sd/install/invokeai/${invokeai_model_list_file} | grep -w ${i} | awk 'NR==1{if ($NF!="") {print $1 " " $(NF-1) " " $NF} }')"
    done

    # 模型选择
    INVOKEAI_DOWNLOAD_MODEL_LIST=$(dialog --erase-on-exit --notags \
        --title "InvokeAI 安装" \
        --backtitle "InvokeAI 模型下载选项" \
        --ok-label "确认" --no-cancel \
        --checklist "请选择需要下载的 InvokeAI 模型\n注:\n1、模型后面括号内数字为模型的大小, 未有括号标注的模型大小均小于 0.1m\n2、不建议使用 Term-SD 下载 InvokeAI 的模型, 建议使用 InvokeAI 自带的模型管理器下载模型" \
        $(get_dialog_size_menu) \
        "_null_" "=====基础模型选择=====" ON \
        $(cat "${START_PATH}/term-sd/install/invokeai/${dialog_list_file}") \
        "_null_" "=====自定义节点模型选择=====" ON \
        ${model_list} \
        3>&1 1>&2 2>&3)
}

# 安装 PyPatchMatch (仅限 Windows 系统)
install_pypatchmatch_for_windows() {
    local pypatchmatch_path=$(term_sd_python "${START_PATH}/term-sd/python_modules/get_pypatchmatch_path.py")
    if is_windows_platform && [[ ! "${pypatchmatch_path}" == "None" ]]; then
        term_sd_echo "下载 PyPatchMatch 中"
        if is_use_modelscope_src; then
            get_modelscope_model licyks/invokeai-core-model/master/pypatchmatch/libpatchmatch_windows_amd64.dll "${pypatchmatch_path}" libpatchmatch_windows_amd64.dll
            get_modelscope_model licyks/invokeai-core-model/master/pypatchmatch/opencv_world460.dll "${pypatchmatch_path}" opencv_world460.dll
        else
            aria2_download https://huggingface.co/licyk/invokeai-core-model/resolve/main/pypatchmatch/libpatchmatch_windows_amd64.dll "${pypatchmatch_path}" libpatchmatch_windows_amd64.dll
            aria2_download https://huggingface.co/licyk/invokeai-core-model/resolve/main/pypatchmatch/opencv_world460.dll "${pypatchmatch_path}" opencv_world460.dll
        fi
    fi
}
