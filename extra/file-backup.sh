#!/bin/bash

# 主界面
term_sd_file_manager() {
    local dialog_arg
    local file_manager_select

    while true; do
        dialog_arg=$(dialog --erase-on-exit --notags \
            --title "Term-SD" \
            --backtitle "Term-SD 备份选项" \
            --ok-label "确认" --cancel-label "取消" \
            --menu "请选择需要备份的软件\n当前备份文件存储目录: ${START_PATH}/term-sd/backup" \
            $(get_dialog_size_menu) \
            "0" "> 帮助" \
            "1" "> Stable-Diffusion-WebUI 数据管理" \
            "2" "> ComfyUI 数据管理" \
            "3" "> InvokeAI 数据管理" \
            "4" "> Fooocus 数据管理" \
            "5" "> lora-scripts 数据管理" \
            "6" "> kohya_ss 数据管理" \
            "7" "> 退出" \
            3>&1 1>&2 2>&3)
        
        case "${dialog_arg}" in
            0)
                dialog --erase-on-exit \
                    --title "Term-SD" \
                    --backtitle "Term-SD 帮助选项" \
                    --ok-label "确认" \
                    --msgbox "$(term_sd_file_manager_help)" \
                    $(get_dialog_size)
                continue
                ;;
            1)
                file_manager_select="stable-diffusion-webui"
                ;;
            2)
                file_manager_select="ComfyUI"
                ;;
            3)
                file_manager_select="InvokeAI"
                ;;
            4)
                file_manager_select="Fooocus"
                ;;
            5)
                file_manager_select="lora-scripts"
                ;;
            6)
                file_manager_select="kohya_ss"
                ;;
            7)  
                break
                ;;
            *)
                break
                ;;
        esac
        if is_sd_folder_exist "${file_manager_select}"; then
            data_backup_manager "${file_manager_select}"
        else
            dialog --erase-on-exit \
                --title "Term-SD" \
                --backtitle "Term-SD 备份选项" \
                --ok-label "确认" \
                --msgbox "${file_manager_select} 未安装" \
                $(get_dialog_size)
        fi
    done
}

# 管理界面
data_backup_manager() {
    local start_time
    local dialog_arg
    local name=$@

    while true; do
        dialog_arg=$(dialog --erase-on-exit --notags \
            --title "Term-SD" \
            --backtitle "${name} 备份选项" \
            --ok-label "确认" --cancel-label "取消" \
            --menu "请选择要进行的操作" \
            $(get_dialog_size_menu) \
            "0" "> 返回" \
            "1" "> 备份 ${name} 数据" \
            "2" "> 恢复 ${name} 数据" \
            "3" "> 删除 ${name} 数据备份" \
            3>&1 1>&2 2>&3)

        case "${dialog_arg}" in
            1)
                term_sd_echo "是否备份 ${name} 数据 (yes/no) ?"
                term_sd_echo "提示: 输入 yes 或 no 后回车"
                case "$(term_sd_read)" in
                    y|yes|YES|Y)
                        start_time=$(date +%s)
                        term_sd_echo "开始备份 ${name} 数据"
                        term_sd_data_backup ${name}
                        dialog --erase-on-exit \
                            --title "Term-SD" \
                            --backtitle "${name} 备份选项" \
                            --ok-label "确认" \
                            --msgbox "备份 ${name} 数据完成, $(term_sd_file_operate_time $start_time)" \
                            $(get_dialog_size)
                        ;;
                    *)
                        term_sd_echo "取消操作"
                        ;;
                esac
                ;;
            2)
                term_sd_echo "是否恢复 ${name} 数据 (yes/no) ?"
                term_sd_echo "提示: 输入 yes 或 no 后回车"
                case "$(term_sd_read)" in
                    y|yes|YES|Y)
                        if [ -d "term-sd/backup/${name}" ]; then
                            start_time=$(date +%s)
                            term_sd_echo "开始恢复 ${name} 数据"
                            term_sd_data_restore ${name}
                            dialog --erase-on-exit \
                                --title "Term-SD" \
                                --backtitle "${name} 备份选项" \
                                --ok-label "确认" \
                                --msgbox "恢复 ${name} 数据完成, $(term_sd_file_operate_time ${start_time})" \
                                $(get_dialog_size)
                        else
                            dialog --erase-on-exit \
                                --title "Term-SD" \
                                --backtitle "${name} 备份选项" \
                                --ok-label "确认" \
                                --msgbox "${name} 未备份" \
                                $(get_dialog_size)
                        fi
                        ;;
                    *)
                        term_sd_echo "取消操作"
                        ;;
                esac
                ;;
            3)
                term_sd_echo "是否删除 ${name} 数据备份 (yes/no) s?"
                term_sd_echo "提示: 输入 yes 或 no 后回车"
                case "$(term_sd_read)" in
                    y|yes|YES|Y)
                        if [ -d "term-sd/backup/${name}" ]; then
                            start_time=$(date +%s)
                            term_sd_echo "开始删除 ${name} 数据备份"
                            rm -rf term-sd/backup/${name}
                            dialog --erase-on-exit \
                                --title "Term-SD" \
                                --backtitle "${name} 备份选项" \
                                --ok-label "确认" \
                                --msgbox "删除 ${name} 数据备份完成, $(term_sd_file_operate_time ${start_time})" \
                                $(get_dialog_size)
                        else
                            dialog --erase-on-exit \
                                --title "Term-SD" \
                                --backtitle "${name} 备份选项" \
                                --ok-label "确认" \
                                --msgbox "${name} 未备份" \
                                $(get_dialog_size)
                        fi
                        ;;
                    *)
                        term_sd_echo "取消操作"
                        ;;
                esac
                ;;
            *)
                break
                ;;
        esac
    done
}

# 帮助
term_sd_file_manager_help() {
    cat<<EOF
该备份脚本会在Term-SD目录生成"term-sd/backup"文件夹,用于储存备份数据
以下为脚本备份的数据:

Stable-Diffusion-WebUI
├── cache.json      模型 Hash 缓存
├── config.json     WebUI 设置
├── embeddings      Embeddings 模型目录
├── extensions      WebUI 插件目录
├── models          模型路径
├── outputs         图片保存路径
├── params.txt      上次生图参数
├── ui-config.json  界面设置
└── styles.csv      提示词预设

ComfyUI
├── custom_nodes    自定义节点路径
├── models          模型路径
├── output          图片保存路径
└── web
    └── extensions  插件路径（少见）

InvokeAI
└── invokeai        模型，图片，配置文件路径

Fooocus
├── config.txt      Fooocus 设置
├── models          模型目录
└── outputs         图片保存路径

lora-scripts
├── config
│   └── autosave    训练参数保存路径
├── logs            日志路径
├── output          模型保存路径
├── sd-models       训练底模路径
└── train           训练集路径

kohya_ss
├── output          模型保存路径
├── models          训练底模路径
└── train           训练集路径
EOF
}

# 检测文件夹存在
is_sd_folder_exist() {
    case "$@" in
        stable-diffusion-webui)
            [ -d "${SD_WEBUI_PATH}" ] && return 0 || return 1
            ;;
        ComfyUI)
            [ -d "${COMFYUI_PATH}" ] && return 0 || return 1
            ;;
        InvokeAI)
            [ -d "${INVOKEAI_PATH}" ] && return 0 || return 1
            ;;
        Fooocus)
            [ -d "${FOOOCUS_PATH}" ] && return 0 || return 1
            ;;
        lora-scripts)
            [ -d "${LORA_SCRIPTS_PATH}" ] && return 0 || return 1
            ;;
        kohya_ss)
            [ -d "${KOHYA_SS_PATH}" ] && return 0 || return 1
            ;;
    esac
}

# 备份选择
term_sd_data_backup() {
    case "$@" in
        stable-diffusion-webui)
            sd_webui_data_backup
            ;;
        ComfyUI)
            comfyui_data_backup
            ;;
        InvokeAI)
            invokeai_data_backup
            ;;
        Fooocus)
            fooocus_data_backup
            ;;
        lora-scripts)
            lora_scripts_data_backup
            ;;
        kohya_ss)
            kohya_ss_data_backup
            ;;
    esac
}

# 恢复数据选择
term_sd_data_restore() {
    case "$@" in
        stable-diffusion-webui)
            sd_webui_data_restore
            ;;
        ComfyUI)
            comfyui_data_restore
            ;;
        InvokeAI)
            invokeai_data_restore
            ;;
        Fooocus)
            fooocus_data_restore
            ;;
        lora-scripts)
            lora_scripts_data_restore
            ;;
        kohya_ss)
            kohya_ss_data_restore
            ;;
    esac
}

# 时间统计
term_sd_file_operate_time() {
    local start_time=$@
    local end_time=$(date +%s)
    local time_span
    time_span=$((end_time - start_time))
    echo "用时: ${time_span} sec"
}

# sd-webui
sd_webui_data_backup() {
    term_sd_mkdir "${START_PATH}"/term-sd/backup/stable-diffusion-webui
    cp -rf "${SD_WEBUI_PATH}"/embeddings "${START_PATH}"/term-sd/backup/stable-diffusion-webui/
    cp -rf "${SD_WEBUI_PATH}"/models "${START_PATH}"/term-sd/backup/stable-diffusion-webui/
    cp -rf "${SD_WEBUI_PATH}"/outputs "${START_PATH}"/term-sd/backup/stable-diffusion-webui/
    cp -rf "${SD_WEBUI_PATH}"/extensions "${START_PATH}"/term-sd/backup/stable-diffusion-webui/
    cp -f "${SD_WEBUI_PATH}"/cache.json "${START_PATH}"/term-sd/backup/stable-diffusion-webui/
    cp -f "${SD_WEBUI_PATH}"/config.json "${START_PATH}"/term-sd/backup/stable-diffusion-webui/
    cp -f "${SD_WEBUI_PATH}"/ui-config.json "${START_PATH}"/term-sd/backup/stable-diffusion-webui/
    cp -f "${SD_WEBUI_PATH}"/params.txt "${START_PATH}"/term-sd/backup/stable-diffusion-webui/
    cp -f "${SD_WEBUI_PATH}"/styles.csv "${START_PATH}"/term-sd/backup/stable-diffusion-webui/
}

sd_webui_data_restore() {
    cp -rf "${START_PATH}"/term-sd/backup/stable-diffusion-webui/embeddings "${SD_WEBUI_PATH}"/
    cp -rf "${START_PATH}"/term-sd/backup/stable-diffusion-webui/models "${SD_WEBUI_PATH}"/
    cp -rf "${START_PATH}"/term-sd/backup/stable-diffusion-webui/outputs "${SD_WEBUI_PATH}"/
    cp -rf "${START_PATH}"/term-sd/backup/stable-diffusion-webui/extensions "${SD_WEBUI_PATH}"/
    cp -f "${START_PATH}"/term-sd/backup/stable-diffusion-webui/cache.json "${SD_WEBUI_PATH}"/
    cp -f "${START_PATH}"/term-sd/backup/stable-diffusion-webui/config.json "${SD_WEBUI_PATH}"/
    cp -f "${START_PATH}"/term-sd/backup/stable-diffusion-webui/ui-config.json "${SD_WEBUI_PATH}"/
    cp -f "${START_PATH}"/term-sd/backup/stable-diffusion-webui/params.txt "${SD_WEBUI_PATH}"/
    cp -f "${START_PATH}"/term-sd/backup/stable-diffusion-webui/styles.csv "${SD_WEBUI_PATH}"/
}

# comfyui
comfyui_data_backup() {
    term_sd_mkdir "${START_PATH}"/term-sd/backup/ComfyUI
    cp -rf "${COMFYUI_PATH}"/custom_nodes "${START_PATH}"/term-sd/backup/ComfyUI/
    cp -rf "${COMFYUI_PATH}"/models "${START_PATH}"/term-sd/backup/ComfyUI/
    cp -rf "${COMFYUI_PATH}"/output "${START_PATH}"/term-sd/backup/ComfyUI/
    cp -rf "${COMFYUI_PATH}"/web/extensions "${START_PATH}"/term-sd/backup/ComfyUI/
    [[ -f "${COMFYUI_PATH}/extra_model_paths.yaml" ]] && cp -f "${COMFYUI_PATH}"/extra_model_paths.yaml "${START_PATH}"/term-sd/backup/ComfyUI/
    rm -rf "${START_PATH}"/term-sd/backup/ComfyUI/web/extensions/core
    rm -f "${START_PATH}"/term-sd/backup/ComfyUI/web/extensions/logging.js.example
}

comfyui_data_restore() {
    cp -rf "${START_PATH}"/term-sd/backup/ComfyUI/custom_nodes "${COMFYUI_PATH}"/
    cp -rf "${START_PATH}"/term-sd/backup/ComfyUI/models "${COMFYUI_PATH}"/
    cp -rf "${START_PATH}"/term-sd/backup/ComfyUI/output "${COMFYUI_PATH}"/
    cp -rf "${START_PATH}"/term-sd/backup/ComfyUI/web/extensions "${COMFYUI_PATH}"/
    [ -f "${START_PATH}/term-sd/backup/ComfyUI/extra_model_paths.yaml" ] && cp -f "${START_PATH}"/term-sd/backup/ComfyUI/extra_model_paths.yaml "${COMFYUI_PATH}"/
}

# invokeai
invokeai_data_backup() {
    term_sd_mkdir "${START_PATH}"term-sd/backup/InvokeAI
    cp -rf "${INVOKEAI_PATH}"/invokeai/autoimport "${START_PATH}"/term-sd/backup/InvokeAI/
    cp -rf "${INVOKEAI_PATH}"/invokeai/configs "${START_PATH}"/term-sd/backup/InvokeAI/
    cp -rf "${INVOKEAI_PATH}"/invokeai/databases "${START_PATH}"/term-sd/backup/InvokeAI/
    cp -rf "${INVOKEAI_PATH}"/invokeai/nodes "${START_PATH}"/term-sd/backup/InvokeAI/
    cp -rf "${INVOKEAI_PATH}"/invokeai/outputs "${START_PATH}"/term-sd/backup/InvokeAI/
    cp -rf "${INVOKEAI_PATH}"/invokeai/text-inversion-output "${START_PATH}"/term-sd/backup/InvokeAI/
    cp -rf "${INVOKEAI_PATH}"/invokeai/text-inversion-training-data "${START_PATH}"/term-sd/backup/InvokeAI/
    cp -f "${INVOKEAI_PATH}"/invokeai/invokeai.yaml "${START_PATH}"/term-sd/backup/InvokeAI/
    term_sd_mkdir "${START_PATH}"/term-sd/backup/InvokeAI/models
    cp -rf "${INVOKEAI_PATH}"/invokeai/models/any "${START_PATH}"/term-sd/backup/InvokeAI/models/
    cp -rf "${INVOKEAI_PATH}"/invokeai/models/core "${START_PATH}"/term-sd/backup/InvokeAI/models/
    cp -rf "${INVOKEAI_PATH}"/invokeai/models/sd-1 "${START_PATH}"/term-sd/backup/InvokeAI/models/
    cp -rf "${INVOKEAI_PATH}"/invokeai/models/sd-2 "${START_PATH}"/term-sd/backup/InvokeAI/models/
    cp -rf "${INVOKEAI_PATH}"/invokeai/models/sdxl "${START_PATH}"/term-sd/backup/InvokeAI/models/
    cp -rf "${INVOKEAI_PATH}"/invokeai/models/sdxl-refiner "${START_PATH}"/term-sd/backup/InvokeAI/models/
}

invokeai_data_restore() {
    cp -rf "${START_PATH}"/term-sd/backup/InvokeAI/autoimport "${INVOKEAI_PATH}"/invokeai/
    cp -rf "${START_PATH}"/term-sd/backup/InvokeAI/configs "${INVOKEAI_PATH}"/invokeai/
    cp -rf "${START_PATH}"/term-sd/backup/InvokeAI/databases "${INVOKEAI_PATH}"/invokeai/
    cp -rf "${START_PATH}"/term-sd/backup/InvokeAI/nodes "${INVOKEAI_PATH}"/invokeai
    cp -rf "${START_PATH}"/term-sd/backup/InvokeAI/outputs "${INVOKEAI_PATH}"/invokeai/
    cp -rf "${START_PATH}"/term-sd/backup/InvokeAI/text-inversion-output "${INVOKEAI_PATH}"/invokeai/
    cp -rf "${START_PATH}"/term-sd/backup/InvokeAI/text-inversion-training-data "${INVOKEAI_PATH}"/invokeai/
    cp -f "${START_PATH}"/term-sd/backup/InvokeAI/invokeai.yaml "${INVOKEAI_PATH}"/invokeai/
    term_sd_mkdir "${INVOKEAI_PATH}"/invokeai/models
    cp -rf "${START_PATH}"/term-sd/backup/InvokeAI/models/any "${INVOKEAI_PATH}"/invokeai/models/
    cp -rf "${START_PATH}"/term-sd/backup/InvokeAI/models/core "${INVOKEAI_PATH}"/invokeai/models/
    cp -rf "${START_PATH}"/term-sd/backup/InvokeAI/models/sd-1 "${INVOKEAI_PATH}"/invokeai/models/
    cp -rf "${START_PATH}"/term-sd/backup/InvokeAI/models/sd-2 "${INVOKEAI_PATH}"/invokeai/models/
    cp -rf "${START_PATH}"/term-sd/backup/InvokeAI/models/sdxl "${INVOKEAI_PATH}"/invokeai/models/
    cp -rf "${START_PATH}"/term-sd/backup/InvokeAI/models/sdxl-refiner "${INVOKEAI_PATH}"/invokeai/models/
}

# fooocus
fooocus_data_backup() {
    term_sd_mkdir "${START_PATH}"term-sd/backup/Fooocus
    cp -rf "${FOOOCUS_PATH}"/models "${START_PATH}"term-sd/backup/Fooocus/
    cp -rf "${FOOOCUS_PATH}"/outputs "${START_PATH}"term-sd/backup/Fooocus/
    cp -f "${FOOOCUS_PATH}"/config.txt "${START_PATH}"term-sd/backup/Fooocus/
}

fooocus_data_restore() {
    cp -rf "${START_PATH}"/term-sd/backup/Fooocus/models "${FOOOCUS_PATH}"/
    cp -rf "${START_PATH}"/term-sd/backup/Fooocus/outputs "${FOOOCUS_PATH}"/
    cp -f "${START_PATH}"/term-sd/backup/Fooocus/config.txt "${FOOOCUS_PATH}"/
}

# lora-scripts
lora_scripts_data_backup() {
    term_sd_mkdir "${START_PATH}"term-sd/backup/lora-scripts
    cp -rf "${LORA_SCRIPTS_PATH}"/config/autosave "${START_PATH}"term-sd/backup/lora-scripts/
    cp -rf "${LORA_SCRIPTS_PATH}"/logs "${START_PATH}"term-sd/backup/lora-scripts/
    cp -rf "${LORA_SCRIPTS_PATH}"/output "${START_PATH}"term-sd/backup/lora-scripts/
    cp -rf "${LORA_SCRIPTS_PATH}"/sd-models "${START_PATH}"term-sd/backup/lora-scripts/
    cp -rf "${LORA_SCRIPTS_PATH}"/train "${START_PATH}"term-sd/backup/lora-scripts/
}

lora_scripts_data_restore() {
    cp -rf "${START_PATH}"/term-sd/backup/lora-scripts/config/autosave "${LORA_SCRIPTS_PATH}"/
    cp -rf "${START_PATH}"/term-sd/backup/lora-scripts/logs "${LORA_SCRIPTS_PATH}"/
    cp -rf "${START_PATH}"/term-sd/backup/lora-scripts/output "${LORA_SCRIPTS_PATH}"/
    cp -rf "${START_PATH}"/term-sd/backup/lora-scripts/sd-models "${LORA_SCRIPTS_PATH}"/
    cp -rf "${START_PATH}"/term-sd/backup/lora-scripts/train "${LORA_SCRIPTS_PATH}"/
}

# kohya_ss
kohya_ss_data_backup() {
    term_sd_mkdir "${START_PATH}"term-sd/backup/kohya_ss
    cp -rf "${KOHYA_SS_PATH}"/output "${START_PATH}"/term-sd/backup/kohya_ss/
    cp -rf "${KOHYA_SS_PATH}"/train "${START_PATH}"/term-sd/backup/kohya_ss/
    cp -rf "${KOHYA_SS_PATH}"/models "${START_PATH}"/term-sd/backup/kohya_ss/
}

kohya_ss_data_restore() {
    cp -rf "${START_PATH}"/term-sd/backup/kohya_ss/output "${KOHYA_SS_PATH}"/
    cp -rf "${START_PATH}"/term-sd/backup/kohya_ss/train "${KOHYA_SS_PATH}"/
    cp -rf "${START_PATH}"/term-sd/backup/kohya_ss/models "${KOHYA_SS_PATH}"/
}

#################################################

if [[ -d "${START_PATH}/term-sd/backup" ]]; then
    term_sd_echo "备份数据文件夹路径: ${START_PATH}/term-sd/backup"
else
    term_sd_echo "创建备份数据文件夹中, 路径: ${START_PATH}/term-sd/backup"
    term_sd_mkdir "${START_PATH}/term-sd/backup"
fi

term_sd_file_manager
