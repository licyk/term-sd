#!/bin/bash

# 主界面
term_sd_file_manager()
{
    local file_manager_dialog
    term_sd_echo "请选择进行的操作"
    term_sd_echo "1、Stable-Diffusion-WebUI数据管理"
    term_sd_echo "2、ComfyUI数据管理"
    term_sd_echo "3、InvokeAI数据管理"
    term_sd_echo "4、Fooocus数据管理"
    term_sd_echo "5、lora-scripts数据管理"
    term_sd_echo "6、kohya_ss数据管理"
    term_sd_echo "7、帮助"
    term_sd_echo "8、退出"
    term_sd_echo "提示:输入数字并回车"

    case $(term_sd_read) in
        1)
            if [ -d "$sd_webui_path" ];then
                data_backup_manager stable-diffusion-webui
            else
                term_sd_echo "未安装Stable-Diffusion-WebUI"
            fi
            ;;
        2)
            if [-d "$comfyui_path" ];then
                data_backup_manager ComfyUI
            else
                term_sd_echo "未安装ComfyUI"
            fi
            ;;
        3)
            if [ -d "$invokeai_path" ];then
                data_backup_manager InvokeAI
            else
                term_sd_echo "未安装InvokeAI"
            fi
            ;;
        4)
            if [ -d "$fooocus_path" ];then
                data_backup_manager Fooocus
            else
                term_sd_echo "未安装Fooocus"
            fi
            ;;
        5)
            if [ -d "$lora_scripts_path" ];then
                data_backup_manager lora-scripts
            else
                term_sd_echo "未安转lora-scripts"
            fi
            ;;
        6)
            if [ -d "$kohya_ss_path" ];then
                data_backup_manager kohya_ss
            else
                term_sd_echo "未安装kohya_ss"
            fi
            ;;
        7)
            term_sd_file_manager_help
            ;;
        8)
            return 1
            ;;
        *)
            term_sd_echo "输入有误,请重试"
            ;;
    esac
}

# 管理界面
data_backup_manager()
{
    local start_time

    term_sd_echo "请选择要进行的操作"
    term_sd_echo "1、备份${1}数据"
    term_sd_echo "2、恢复${1}数据"
    term_sd_echo "3、删除${1}数据备份"
    term_sd_echo "4、返回"
    term_sd_echo "提示:输入数字并回车"

    case $(term_sd_read) in
        1)
            term_sd_echo "是否备份${1}数据(yes/no)"
            term_sd_echo "提示:输入yes或no后回车"
            case $(term_sd_read) in
                y|yes|YES|Y)
                    start_time=$(date +%s)
                    term_sd_echo "开始备份${1}数据"
                    term_sd_data_backup ${1}
                    term_sd_echo "备份${1}数据完成"
                    term_sd_file_operate_time $start_time
                    data_backup_manager ${1}
                    ;;
                *)
                    term_sd_echo "取消操作"
                    data_backup_manager ${1}
                    ;;
            esac
            ;;
        2)
            term_sd_echo "是否恢复${1}数据(yes/no)"
            term_sd_echo "提示:输入yes或no后回车"
            case $(term_sd_read) in
                y|yes|YES|Y)
                    if [ -d "term-sd/backup/${1}" ];then
                        start_time=$(date +%s)
                        term_sd_echo "开始恢复${1}数据"
                        term_sd_data_restore ${1}
                        term_sd_echo "恢复${1}数据完成"
                        term_sd_file_operate_time $start_time
                    else
                        term_sd_echo "${1}未备份"
                    fi
                    data_backup_manager ${1}
                    ;;
                *)
                    term_sd_echo "取消操作"
                    data_backup_manager ${1}
                    ;;
            esac
            ;;
        3)
            term_sd_echo "是否删除${1}数据备份(yes/no)"
            term_sd_echo "提示:输入yes或no后回车"
            case $(term_sd_read) in
                y|yes|YES|Y)
                    if [ -d "term-sd/backup/${1}" ];then
                        start_time=$(date +%s)
                        term_sd_echo "开始删除${1}数据备份"
                        rm -rf term-sd/backup/${1}
                        term_sd_echo "删除${1}数据备份完成"
                        term_sd_file_operate_time $start_time
                    else
                        term_sd_echo "${1}未备份"
                    fi
                    data_backup_manager ${1}
                    ;;
                *)
                    term_sd_echo "取消操作"
                    data_backup_manager ${1}
                    ;;
            esac
            ;;
        4)
            term_sd_echo "返回主界面"
            ;;
        *)
            term_sd_echo "输入有误,请重试"
            data_backup_manager ${1}
            ;;
    esac
}

# 帮助
term_sd_file_manager_help()
{
    term_sd_print_line "备份脚本帮助"
    cat<<EOF
该备份脚本会在Term-SD目录生成"term-sd/backup"文件夹,用于储存备份数据
以下为脚本备份的数据:

Stable-Diffusion-WebUI
├── cache.json      模型hash缓存
├── config.json     webui设置
├── embeddings      embeddings模型目录
├── extensions      webui插件目录
├── models          模型路径
├── outputs          图片保存路径
├── params.txt      上次生图参数
├── ui-config.json  界面设置
└── styles.csv       提示词预设

ComfyUI
├── custom_nodes    自定义节点路径
├── models          模型路径
├── output          图片保存路径
└── web
    └── extensions  插件路径（少见）

InvokeAI
└── invokeai        模型，图片，配置文件路径

Fooocus
├── config.txt      fooocus设置
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
    term_sd_print_line
}

# 备份选择
term_sd_data_backup()
{
    case ${1} in
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
term_sd_data_restore()
{
    case ${1} in
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
term_sd_file_operate_time()
{
    local start_time=$1
    local end_time=$(date +%s)
    local time_span
    time_span=$((end_time - start_time))
    term_sd_echo "用时:${time_span} sec"
}

# sd-webui
sd_webui_data_backup()
{
    term_sd_mkdir term-sd/backup/stable-diffusion-webui
    cp -rf "$sd_webui_path"/embeddings term-sd/backup/stable-diffusion-webui/
    cp -rf "$sd_webui_path"/models term-sd/backup/stable-diffusion-webui/
    cp -rf "$sd_webui_path"/outputs term-sd/backup/stable-diffusion-webui/
    cp -rf "$sd_webui_path"/extensions term-sd/backup/stable-diffusion-webui/
    cp -f "$sd_webui_path"/cache.json term-sd/backup/stable-diffusion-webui/
    cp -f "$sd_webui_path"/config.json term-sd/backup/stable-diffusion-webui/
    cp -f "$sd_webui_path"/ui-config.json term-sd/backup/stable-diffusion-webui/
    cp -f "$sd_webui_path"/params.txt term-sd/backup/stable-diffusion-webui/
    cp -f "$sd_webui_path"/styles.csv term-sd/backup/stable-diffusion-webui/
}

sd_webui_data_restore()
{
    cp -rf term-sd/backup/stable-diffusion-webui/embeddings "$sd_webui_path"/
    cp -rf term-sd/backup/stable-diffusion-webui/models "$sd_webui_path"/
    cp -rf term-sd/backup/stable-diffusion-webui/outputs "$sd_webui_path"/
    cp -rf term-sd/backup/stable-diffusion-webui/extensions "$sd_webui_path"/
    cp -f term-sd/backup/stable-diffusion-webui/cache.json "$sd_webui_path"/
    cp -f term-sd/backup/stable-diffusion-webui/config.json "$sd_webui_path"/
    cp -f term-sd/backup/stable-diffusion-webui/ui-config.json "$sd_webui_path"/
    cp -f term-sd/backup/stable-diffusion-webui/params.txt "$sd_webui_path"/
    cp -f term-sd/backup/stable-diffusion-webui/styles.csv "$sd_webui_path"/
}

# comfyui
comfyui_data_backup()
{
    term_sd_mkdir term-sd/backup/ComfyUI
    cp -rf "$comfyui_path"/custom_nodes term-sd/backup/ComfyUI/
    cp -rf "$comfyui_path"/models term-sd/backup/ComfyUI/
    cp -rf "$comfyui_path"/output term-sd/backup/ComfyUI/
    cp -rf "$comfyui_path"/web/extensions term-sd/backup/ComfyUI/
    [ -f "$comfyui_path/extra_model_paths.yaml" ] && cp -rf "$comfyui_path"/extra_model_paths.yaml term-sd/backup/ComfyUI/
    rm -rf term-sd/backup/ComfyUI/web/extensions/core
    rm -f term-sd/backup/ComfyUI/web/extensions/logging.js.example
}

comfyui_data_restore()
{
    cp -rf term-sd/backup/ComfyUI/custom_nodes "$comfyui_path"/
    cp -rf term-sd/backup/ComfyUI/models "$comfyui_path"/
    cp -rf term-sd/backup/ComfyUI/output "$comfyui_path"/
    cp -rf term-sd/backup/ComfyUI/web/extensions "$comfyui_path"/
    [ -f "term-sd/backup/ComfyUI/extra_model_paths.yaml" ] && cp -f term-sd/backup/ComfyUI/extra_model_paths.yaml "$comfyui_path"/
}

# invokeai
invokeai_data_backup()
{
    term_sd_mkdir term-sd/backup/InvokeAI
    cp -rf "$invokeai_path"/invokeai/autoimport term-sd/backup/InvokeAI/
    cp -rf "$invokeai_path"/invokeai/configs term-sd/backup/InvokeAI/
    cp -rf "$invokeai_path"/invokeai/databases term-sd/backup/InvokeAI/
    cp -rf "$invokeai_path"/invokeai/nodes term-sd/backup/InvokeAI/
    cp -rf "$invokeai_path"/invokeai/outputs term-sd/backup/InvokeAI/
    cp -rf "$invokeai_path"/invokeai/text-inversion-output term-sd/backup/InvokeAI/
    cp -rf "$invokeai_path"/invokeai/text-inversion-training-data term-sd/backup/InvokeAI/
    cp -f "$invokeai_path"/invokeai/invokeai.yaml term-sd/backup/InvokeAI/
    term_sd_mkdir -p term-sd/backup/InvokeAI/models
    cp -rf "$invokeai_path"/invokeai/models/any term-sd/backup/InvokeAI/models/
    cp -rf "$invokeai_path"/invokeai/models/core term-sd/backup/InvokeAI/models/
    cp -rf "$invokeai_path"/invokeai/models/sd-1 term-sd/backup/InvokeAI/models/
    cp -rf "$invokeai_path"/invokeai/models/sd-2 term-sd/backup/InvokeAI/models/
    cp -rf "$invokeai_path"/invokeai/models/sdxl term-sd/backup/InvokeAI/models/
    cp -rf "$invokeai_path"/invokeai/models/sdxl-refiner term-sd/backup/InvokeAI/models/
}

invokeai_data_restore()
{
    cp -rf term-sd/backup/InvokeAI/autoimport "$invokeai_path"/invokeai/
    cp -rf term-sd/backup/InvokeAI/configs "$invokeai_path"/invokeai/
    cp -rf term-sd/backup/InvokeAI/databases "$invokeai_path"/invokeai/
    cp -rf term-sd/backup/InvokeAI/nodes "$invokeai_path"/invokeai
    cp -rf term-sd/backup/InvokeAI/outputs "$invokeai_path"/invokeai/
    cp -rf term-sd/backup/InvokeAI/text-inversion-output "$invokeai_path"/invokeai/
    cp -rf term-sd/backup/InvokeAI/text-inversion-training-data "$invokeai_path"/invokeai/
    cp -f term-sd/backup/InvokeAI/invokeai.yaml "$invokeai_path"/invokeai/
    term_sd_mkdir -p "$invokeai_path"/invokeai/models
    cp -rf term-sd/backup/InvokeAI/models/any "$invokeai_path"/invokeai/models/
    cp -rf term-sd/backup/InvokeAI/models/core "$invokeai_path"/invokeai/models/
    cp -rf term-sd/backup/InvokeAI/models/sd-1 "$invokeai_path"/invokeai/models/
    cp -rf term-sd/backup/InvokeAI/models/sd-2 "$invokeai_path"/invokeai/models/
    cp -rf term-sd/backup/InvokeAI/models/sdxl "$invokeai_path"/invokeai/models/
    cp -rf term-sd/backup/InvokeAI/models/sdxl-refiner "$invokeai_path"/invokeai/models/
}

# fooocus
fooocus_data_backup()
{
    term_sd_mkdir term-sd/backup/Fooocus
    cp -rf "$fooocus_path"/models term-sd/backup/Fooocus/
    cp -rf "$fooocus_path"/outputs term-sd/backup/Fooocus/
    cp -f "$fooocus_path"/config.txt term-sd/backup/Fooocus/
}

fooocus_data_restore()
{
    cp -rf term-sd/backup/Fooocus/models "$fooocus_path"/
    cp -rf term-sd/backup/Fooocus/outputs "$fooocus_path"/
    cp -f term-sd/backup/Fooocus/config.txt "$fooocus_path"/
}

# lora-scripts
lora_scripts_data_backup()
{
    term_sd_mkdir term-sd/backup/lora-scripts
    cp -rf "$lora_scripts_path"/config/autosave term-sd/backup/lora-scripts/
    cp -rf "$lora_scripts_path"/logs term-sd/backup/lora-scripts/
    cp -rf "$lora_scripts_path"/output term-sd/backup/lora-scripts/
    cp -rf "$lora_scripts_path"/sd-models term-sd/backup/lora-scripts/
    cp -rf "$lora_scripts_path"/train term-sd/backup/lora-scripts/
}

lora_scripts_data_restore()
{
    cp -rf term-sd/backup/lora-scripts/config/autosave "$lora_scripts_path"/
    cp -rf term-sd/backup/lora-scripts/logs "$lora_scripts_path"/
    cp -rf term-sd/backup/lora-scripts/output "$lora_scripts_path"/
    cp -rf term-sd/backup/lora-scripts/sd-models "$lora_scripts_path"/
    cp -rf term-sd/backup/lora-scripts/train "$lora_scripts_path"/
}

# kohya_ss
kohya_ss_data_backup()
{
    term_sd_mkdir term-sd/backup/kohya_ss
    cp -rf "$kohya_ss_path"/output term-sd/backup/kohya_ss/
    cp -rf "$kohya_ss_path"/train term-sd/backup/kohya_ss/
    cp -rf "$kohya_ss_path"/models term-sd/backup/kohya_ss/
}

kohya_ss_data_restore()
{
    cp -rf term-sd/backup/kohya_ss/output "$kohya_ss_path"/
    cp -rf term-sd/backup/kohya_ss/train "$kohya_ss_path"/
    cp -rf term-sd/backup/kohya_ss/models "$kohya_ss_path"/
}

#################################################

if [ -d "term-sd/backup" ];then
    term_sd_echo "备份数据文件夹路径:${start_path}/term-sd/backup"
else
    term_sd_echo "创建备份数据文件夹中,路径:${start_path}/term-sd/backup"
    term_sd_mkdir term-sd/backup
fi

while (($? == 0));do
    term_sd_file_manager
done
