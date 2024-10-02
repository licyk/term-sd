#!/bin/bash

. "${START_PATH}"/term-sd/modules/install_prepare.sh
. "${START_PATH}"/term-sd/modules/get_modelscope_model.sh
. "${START_PATH}"/term-sd/modules/term_sd_git.sh
. "${START_PATH}"/term-sd/modules/term_sd_task_manager.sh
. "${START_PATH}"/term-sd/modules/term_sd_manager.sh
. "${START_PATH}"/term-sd/modules/term_sd_proxy.sh
. "${START_PATH}"/term-sd/modules/term_sd_try.sh


if [[ ! -d "${SD_WEBUI_PATH}" ]]; then
    term_sd_echo "未安装 Stable-Diffusion-WebUI"
else
    # 删除 SD WebUI 插件安装任务文件
    rm -f "${START_PATH}/term-sd/task/sd_webui_install_extension.sh"
    download_mirror_select # 下载镜像源选择

    # 插件选择
    SD_WEBUI_INSTALL_EXTENSION_LIST=$(dialog --erase-on-exit --notags \
        --title "Stable-Diffusion-WebUI 安装" \
        --backtitle "Stable-Diffusion-WebUI 插件安装选项" \
        --ok-label "确认" --no-cancel \
        --checklist "请选择需要安装的 Stable-Diffusion-WebUI 插件" \
        $(get_dialog_size_menu) \
        $(cat "${START_PATH}/term-sd/install/sd_webui/dialog_sd_webui_extension.sh" | awk '{print $1 " " $2 " OFF"}') \
        3>&1 1>&2 2>&3)

    # 插件模型列表选择
    if is_use_modelscope_src; then
        sd_webui_extension_model_list_file="sd_webui_extension_ms_model.sh"
    else
        sd_webui_extension_model_list_file="sd_webui_extension_hf_model.sh"
    fi

    term_sd_echo "生成模型选择列表中"

    # 查找插件对应模型的编号
    for i in ${SD_WEBUI_INSTALL_EXTENSION_LIST}; do
        sd_webui_extension_model_list="${sd_webui_extension_model_list} $(cat "${START_PATH}"/term-sd/install/sd_webui/${sd_webui_extension_model_list_file} | grep -w ${i} | awk 'NR==1{if ($NF!="") {print $1 " " $(NF-1) " " $NF} }' | awk '{sub($NF,"OFF")}1')"
    done

    # 模型选择
    SD_WEBUI_DOWNLOAD_MODEL_LIST=$(dialog --erase-on-exit --notags \
        --title "Stable-Diffusion-WebUI 安装" \
        --backtitle "Stable-Diffusion-WebUI 插件模型下载选项" \
        --ok-label "确认" --no-cancel \
        --checklist "请选择需要下载的 Stable-Diffusion-WebUI 插件模型" \
        $(get_dialog_size_menu) \
        "_null_" "=====插件模型选择=====" OFF \
        ${sd_webui_extension_model_list} \
        3>&1 1>&2 2>&3)

    # 安装确认
    if term_sd_install_confirm "是否安装 Stable-Diffusion-WebUI 插件 ?"; then
        term_sd_echo "生成任务队列"
        touch "${START_PATH}/term-sd/task/sd_webui_install_extension.sh"

        # 插件
        if [[ ! -z "${SD_WEBUI_INSTALL_EXTENSION_LIST}" ]]; then
            echo "__term_sd_task_sys term_sd_echo \"下载插件中\"" >> "${START_PATH}/term-sd/task/sd_webui_install_extension.sh"
            for i in ${SD_WEBUI_INSTALL_EXTENSION_LIST}; do
                cat "${START_PATH}/term-sd/install/sd_webui/sd_webui_extension.sh" | grep -w ${i} | awk '{sub(" ON "," ") ; sub(" OFF "," ")}1' >> "${START_PATH}/term-sd/task/sd_webui_install_extension.sh" # 插件
            done
        fi

        # 插件模型
        if [[ ! -z "${SD_WEBUI_DOWNLOAD_MODEL_LIST}" ]]; then
            echo "__term_sd_task_sys term_sd_echo \"下载模型中\"" >> "${START_PATH}/term-sd/task/sd_webui_install_extension.sh"
            if is_use_modelscope_src; then
                echo "__term_sd_task_sys term_sd_tmp_disable_proxy" >> "${START_PATH}/term-sd/task/sd_webui_install_extension.sh"
                for i in ${SD_WEBUI_DOWNLOAD_MODEL_LIST}; do
                    cat "${START_PATH}/term-sd/install/sd_webui/sd_webui_extension_ms_model.sh" | grep -w ${i} >> "${START_PATH}/term-sd/task/sd_webui_install_extension.sh" # 插件所需的模型
                done
            else
                for i in ${SD_WEBUI_DOWNLOAD_MODEL_LIST}; do
                    cat "${START_PATH}/term-sd/install/sd_webui/sd_webui_extension_hf_model.sh" | grep -w ${i} >> "${START_PATH}/term-sd/task/sd_webui_install_extension.sh" # 插件所需的模型
                done
            fi
        fi

        term_sd_echo "任务队列生成完成"
        term_sd_echo "开始下载 Stable-Diffusion-WebUI 插件"

        cmd_sum=$(( $(cat "${START_PATH}/term-sd/task/sd_webui_install_extension.sh" | wc -l) + 1 )) # 统计命令行数
        for (( cmd_point=1; cmd_point<=cmd_sum; cmd_point++ )); do
            term_sd_echo "Stable-Diffusion-WebUI 安装进度: [${cmd_point}/${cmd_sum}]"
            term_sd_exec_cmd "${START_PATH}/term-sd/task/sd_webui_install_extension.sh" "${cmd_point}"
        done

        term_sd_tmp_enable_proxy # 恢复代理
        term_sd_echo "Stable-Diffusion-WebUI 插件下载结束"
        rm -f "${START_PATH}/term-sd/task/sd_webui_install_extension.sh" # 删除任务文件
    else
        term_sd_echo "取消下载 Stable-Diffusion-WebUI 插件"
    fi
fi