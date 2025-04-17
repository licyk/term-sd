#!/bin/bash

. "${START_PATH}"/term-sd/modules/install_prepare.sh
. "${START_PATH}"/term-sd/modules/get_modelscope_model.sh
. "${START_PATH}"/term-sd/modules/term_sd_git.sh
. "${START_PATH}"/term-sd/modules/term_sd_task_manager.sh
. "${START_PATH}"/term-sd/modules/term_sd_manager.sh
. "${START_PATH}"/term-sd/modules/term_sd_proxy.sh
. "${START_PATH}"/term-sd/modules/term_sd_try.sh


if [[ ! -d "${INVOKEAI_ROOT_PATH}" ]]; then
    term_sd_echo "未安装 InvokeAI"
else
    # 删除 InvokeAI 自定义节点安装任务文件
    rm -f "${START_PATH}/term-sd/task/invokeai_install_custom_node.sh"
    download_mirror_select # 下载镜像源选择

    # 自定义节点选择
    INVOKEAI_INSTALL_CUSTOM_NODE_LIST=$(dialog --erase-on-exit --notags \
        --title "InvokeAI 安装" \
        --backtitle "InvokeAI 自定义节点安装选项" \
        --ok-label "确认" --no-cancel \
        --checklist "请选择需要安装的 InvokeAI 自定义节点" \
        $(get_dialog_size_menu) \
        $(cat "${START_PATH}/term-sd/install/invokeai/dialog_invokeai_custom_node.sh" | awk '{print $1 " " $2 " OFF"}') \
        3>&1 1>&2 2>&3)

    # 自定义节点模型列表选择
    if is_use_modelscope_src; then
        invokeai_custom_node_model_list_file="invokeai_custom_node_ms_model.sh"
    else
        invokeai_custom_node_model_list_file="invokeai_custom_node_hf_model.sh"
    fi

    term_sd_echo "生成模型选择列表中"

    # 查找自定义节点对应模型的编号
    for i in ${INVOKEAI_INSTALL_CUSTOM_NODE_LIST}; do
        model_list="${model_list} $(cat "${START_PATH}"/term-sd/install/invokeai/${invokeai_custom_node_model_list_file} | grep -w ${i} | awk 'NR==1{if ($NF!="") {print $1 " " $(NF-1) " " $NF} }' | awk '{sub($NF,"OFF")}1')"
    done

    # 模型选择
    INVOKEAI_DOWNLOAD_MODEL_LIST=$(dialog --erase-on-exit --notags \
        --title "InvokeAI 安装" \
        --backtitle "InvokeAI 自定义节点模型下载选项" \
        --ok-label "确认" --no-cancel \
        --checklist "请选择需要下载的 InvokeAI 自定义节点模型" \
        $(get_dialog_size_menu) \
        "_null_" "=====自定义节点模型选择=====" OFF \
        ${model_list} \
        3>&1 1>&2 2>&3)

    # 安装确认
    if term_sd_install_confirm "是否安装 InvokeAI 自定义节点 ?"; then
        term_sd_echo "生成任务队列"
        touch "${START_PATH}/term-sd/task/invokeai_install_custom_node.sh"

        # 自定义节点
        if [[ ! -z "${INVOKEAI_INSTALL_CUSTOM_NODE_LIST}" ]]; then
            echo "__term_sd_task_sys term_sd_echo \"下载自定义节点中\"" >> "${START_PATH}/term-sd/task/invokeai_install_custom_node.sh"
            for i in ${INVOKEAI_INSTALL_CUSTOM_NODE_LIST}; do
                cat "${START_PATH}/term-sd/install/invokeai/invokeai_custom_node.sh" | grep -w ${i} | awk '{sub(" ON "," ") ; sub(" OFF "," ")}1' >> "${START_PATH}/term-sd/task/invokeai_install_custom_node.sh" # 自定义节点
            done
        fi

        # 自定义节点模型
        if [[ ! -z "${INVOKEAI_DOWNLOAD_MODEL_LIST}" ]]; then
            echo "__term_sd_task_sys term_sd_echo \"下载模型中\"" >> "${START_PATH}/term-sd/task/invokeai_install_custom_node.sh"
            if is_use_modelscope_src; then
                echo "__term_sd_task_sys term_sd_tmp_disable_proxy" >> "${START_PATH}/term-sd/task/invokeai_install_custom_node.sh"
                for i in ${INVOKEAI_DOWNLOAD_MODEL_LIST}; do
                    cat "${START_PATH}/term-sd/install/invokeai/invokeai_custom_node_ms_model.sh" | grep -w ${i} >> "${START_PATH}/term-sd/task/invokeai_install_custom_node.sh" # 自定义节点所需的模型
                done
            else
                for i in ${INVOKEAI_DOWNLOAD_MODEL_LIST}; do
                    cat "${START_PATH}/term-sd/install/invokeai/invokeai_custom_node_hf_model.sh" | grep -w ${i} >> "${START_PATH}/term-sd/task/invokeai_install_custom_node.sh" # 自定义节点所需的模型
                done
            fi
        fi

        term_sd_echo "任务队列生成完成"
        term_sd_echo "开始下载 InvokeAI 自定义节点"

        cmd_sum=$(( $(cat "${START_PATH}/term-sd/task/invokeai_install_custom_node.sh" | wc -l) + 1 )) # 统计命令行数
        for (( cmd_point=1; cmd_point<=cmd_sum; cmd_point++ )); do
            term_sd_echo "InvokeAI 安装进度: [${cmd_point}/${cmd_sum}]"
            term_sd_exec_cmd "${START_PATH}/term-sd/task/invokeai_install_custom_node.sh" "${cmd_point}"
        done

        term_sd_tmp_enable_proxy # 恢复代理
        term_sd_echo "InvokeAI 自定义节点下载结束"
        rm -f "${START_PATH}/term-sd/task/invokeai_install_custom_node.sh" # 删除任务文件
    else
        term_sd_echo "取消下载 InvokeAI 自定义节点"
    fi
fi