#!/bin/bash

. "${START_PATH}"/term-sd/modules/install_prepare.sh
. "${START_PATH}"/term-sd/modules/get_modelscope_model.sh
. "${START_PATH}"/term-sd/modules/term_sd_git.sh
. "${START_PATH}"/term-sd/modules/term_sd_task_manager.sh
. "${START_PATH}"/term-sd/modules/term_sd_manager.sh
. "${START_PATH}"/term-sd/modules/term_sd_proxy.sh
. "${START_PATH}"/term-sd/modules/term_sd_try.sh


if [[ ! -d "${COMFYUI_PATH}" ]]; then
    term_sd_echo "未安装 ComfyUI"
else
    rm -f "${START_PATH}/term-sd/task/comfyui_install_extension.sh"
    download_mirror_select # 下载镜像源选择

    # 插件选择
    COMFYUI_EXTENSION_INSTALL_LIST=$(dialog --erase-on-exit --notags \
        --title "ComfyUI 安装" \
        --backtitle "ComfyUI 插件安装选项" \
        --ok-label "确认" --no-cancel \
        --checklist "请选择需要安装的 ComfyUI 插件" \
        $(get_dialog_size_menu) \
        $(cat "${START_PATH}/term-sd/install/comfyui/dialog_comfyui_extension.sh" | awk '{sub($3,"OFF")}1') \
        3>&1 1>&2 2>&3)

    # 自定义节点选择
    COMFYUI_CUSTOM_NODE_INSTALL_LIST=$(dialog --erase-on-exit --notags \
        --title "ComfyUI 安装" \
        --backtitle "ComfyUI 自定义节点安装选项" \
        --ok-label "确认" --no-cancel \
        --checklist "请选择需要安装的 ComfyUI 自定义节点" \
        $(get_dialog_size_menu) \
        $(cat "${START_PATH}/term-sd/install/comfyui/dialog_comfyui_custom_node.sh" | awk '{sub($3,"OFF")}1') \
        3>&1 1>&2 2>&3)

    if is_use_modelscope_src; then
        comfyui_custom_node_model_list_file="comfyui_custom_node_ms_model.sh"
    else
        comfyui_custom_node_model_list_file="comfyui_custom_node_hf_model.sh"
    fi

    term_sd_echo "生成模型选择列表中"
    # 查找插件对应模型的编号
    for i in ${COMFYUI_CUSTOM_NODE_INSTALL_LIST}; do
        comfyui_custom_node_model_list="${comfyui_custom_node_model_list} $(cat "${START_PATH}"/term-sd/install/comfyui/${comfyui_custom_node_model_list_file} | grep -w ${i} | awk 'NR==1{if ($NF!="") {print $1 " " $(NF-1) " " $NF} }' | awk '{sub($NF,"OFF")}1')"
    done

    # 模型选择
    COMFYUI_DOWNLOAD_MODEL_LIST=$(dialog --erase-on-exit --notags \
        --title "ComfyUI 安装" \
        --backtitle "ComfyUI 模型下载选项" \
        --ok-label "确认" --no-cancel \
        --checklist "请选择需要下载的 ComfyUI 扩展模型" \
        $(get_dialog_size_menu) \
        "_null_" "=====扩展模型选择=====" OFF \
        ${comfyui_custom_node_model_list} \
        3>&1 1>&2 2>&3)

    # 安装确认
    if term_sd_install_confirm "是否安装 ComfyUI 插件 / 自定义节点 ?"; then
        term_sd_echo "生成任务队列"
        touch "${START_PATH}/term-sd/task/comfyui_install_extension.sh"

        # 插件
        if [[ ! -z "${COMFYUI_EXTENSION_INSTALL_LIST}" ]]; then
            echo "__term_sd_task_sys term_sd_echo \"安装插件中\"" >> "${START_PATH}/term-sd/task/comfyui_install_extension.sh"
            for i in ${COMFYUI_EXTENSION_INSTALL_LIST} ;do
                cat "${START_PATH}/term-sd/install/comfyui/comfyui_extension.sh" | grep -w ${i} | awk '{sub(" ON "," ") ; sub(" OFF "," ")}1' >> "${START_PATH}/term-sd/task/comfyui_install_extension.sh" # 插件
            done
        fi

        term_sd_add_blank_line "${START_PATH}"/term-sd/task/comfyui_install_extension.sh

        # 自定义节点
        if [[ ! -z "${COMFYUI_CUSTOM_NODE_INSTALL_LIST}" ]]; then
            echo "__term_sd_task_sys term_sd_echo \"安装自定义节点中\"" >> "${START_PATH}/term-sd/task/comfyui_install_extension.sh"
            for i in $COMFYUI_CUSTOM_NODE_INSTALL_LIST ;do
                cat "${START_PATH}/term-sd/install/comfyui/comfyui_custom_node.sh" | grep -w ${i} | awk '{sub(" ON "," ") ; sub(" OFF "," ")}1' >> "${START_PATH}/term-sd/task/comfyui_install_extension.sh" # 插件
            done
        fi

        # 扩展的模型
        if [[ ! -z "${COMFYUI_DOWNLOAD_MODEL_LIST}" ]]; then
            echo "__term_sd_task_sys term_sd_echo \"安装自定义节点中\"" >> "${START_PATH}/term-sd/task/comfyui_install_extension.sh"
            if is_use_modelscope_src; then
                for i in ${COMFYUI_DOWNLOAD_MODEL_LIST} ;do
                    echo "__term_sd_task_sys term_sd_tmp_disable_proxy" >> "${START_PATH}/term-sd/task/comfyui_install_extension.sh"
                    cat "${START_PATH}/term-sd/install/comfyui/comfyui_custom_node_ms_model.sh" | grep -w ${i} >> "${START_PATH}/term-sd/task/comfyui_install_extension.sh" # 自定义节点所需的模型
                done
            else
                for i in $COMFYUI_DOWNLOAD_MODEL_LIST ;do
                    cat "${START_PATH}/term-sd/install/comfyui/comfyui_custom_node_hf_model.sh" | grep -w ${i} >> "${START_PATH}/term-sd/task/comfyui_install_extension.sh" # 自定义节点所需的模型
                done
            fi
        fi

        term_sd_echo "任务队列生成完成"
        term_sd_echo "开始下载 ComfyUI 插件 / 自定义节点"

        cmd_sum=$(( $(cat "${START_PATH}/term-sd/task/comfyui_install_extension.sh" | wc -l) + 1 )) # 统计命令行数
        for ((cmd_point=1;cmd_point<=cmd_sum;cmd_point++))
        do
            term_sd_echo "ComfyUI 安装进度: [$cmd_point/$cmd_sum]"
            term_sd_exec_cmd "${START_PATH}/term-sd/task/comfyui_install_extension.sh" ${cmd_point}
        done

        term_sd_tmp_enable_proxy # 恢复代理
        term_sd_echo "ComfyUI 插件 / 自定义节点下载结束"
        rm -f "${START_PATH}/term-sd/task/comfyui_install_extension.sh" # 删除任务文件
    else
        term_sd_echo "取消下载 ComfyUI 插件 / 自定义节点"
    fi
fi
