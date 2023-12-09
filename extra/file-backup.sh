#!/bin/bash

# 主界面
term_sd_file_manager()
{
    local file_manager_dialog
    term_sd_echo "请选择进行的操作"
    term_sd_echo "1、stable-diffusion-webui数据管理"
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
            data_backup_manager stable-diffusion-webui
            true
            ;;
        2)
            data_backup_manager ComfyUI
            true
            ;;
        3)
            data_backup_manager InvokeAI
            true
            ;;
        4)
            data_backup_manager Fooocus
            true
            ;;
        5)
            data_backup_manager lora-scripts
            true
            ;;
        6)
            data_backup_manager kohya_ss
            true
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

    if [ ! -d "./${1}" ];then
        term_sd_echo "${1}未安装"
        return 1
    fi

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
                    if [ -d "./term-sd-backup/${1}" ];then
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
                    if [ -d "./term-sd-backup/${1}" ];then
                        start_time=$(date +%s)
                        term_sd_echo "开始删除${1}数据备份"
                        rm -rf ./term-sd-backup/${1}
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
该备份脚本会在Term-SD所在目录生成"term-sd-backup"文件夹,用于储存备份数据
以下为脚本备份的数据:

stable-diffusion-webui
├── cache.json      模型hash缓存
├── config.json     webui设置
├── embeddings      embeddings模型目录
├── extensions      webui插件目录
├── models          模型路径
├── outputs          图片保存路径
├── params.txt      上次生图参数
└── ui-config.json  界面设置

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
    [ ! -d "./term-sd-backup/stable-diffusion-webui" ] && mkdir ./term-sd-backup/stable-diffusion-webui
    cp -rf ./stable-diffusion-webui/embeddings ./term-sd-backup/stable-diffusion-webui/
    cp -rf ./stable-diffusion-webui/models ./term-sd-backup/stable-diffusion-webui/
    cp -rf ./stable-diffusion-webui/outputs ./term-sd-backup/stable-diffusion-webui/
    cp -rf ./stable-diffusion-webui/extensions ./term-sd-backup/stable-diffusion-webui/
    cp -f ./stable-diffusion-webui/cache.json ./term-sd-backup/stable-diffusion-webui/
    cp -f ./stable-diffusion-webui/config.json ./term-sd-backup/stable-diffusion-webui/
    cp -f ./stable-diffusion-webui/ui-config.json ./term-sd-backup/stable-diffusion-webui/
    cp -f ./stable-diffusion-webui/params.txt ./term-sd-backup/stable-diffusion-webui/
}

sd_webui_data_restore()
{
    cp -rf ./term-sd-backup/stable-diffusion-webui/embeddings ./stable-diffusion-webui/
    cp -rf ./term-sd-backup/stable-diffusion-webui/models ./stable-diffusion-webui/
    cp -rf ./term-sd-backup/stable-diffusion-webui/outputs ./stable-diffusion-webui/
    cp -rf ./term-sd-backup/stable-diffusion-webui/extensions ./stable-diffusion-webui/
    cp -f ./term-sd-backup/stable-diffusion-webui/cache.json ./stable-diffusion-webui/
    cp -f ./term-sd-backup/stable-diffusion-webui/config.json ./stable-diffusion-webui/
    cp -f ./term-sd-backup/stable-diffusion-webui/ui-config.json ./stable-diffusion-webui/
    cp -f ./term-sd-backup/stable-diffusion-webui/params.txt ./stable-diffusion-webui/
}

# comfyui
comfyui_data_backup()
{
    [ ! -d "./term-sd-backup/ComfyUI" ] && mkdir ./term-sd-backup/ComfyUI
    cp -rf ./ComfyUI/custom_nodes ./term-sd-backup/ComfyUI/
    cp -rf ./ComfyUI/models ./term-sd-backup/ComfyUI/
    cp -rf ./ComfyUI/output ./term-sd-backup/ComfyUI/
    cp -rf ./ComfyUI/web/extensions ./term-sd-backup/ComfyUI/
    rm -rf ./term-sd-backup/ComfyUI/web/core
    rm -f ./term-sd-backup/ComfyUI/web/logging.js.example
}

comfyui_data_restore()
{
    cp -rf ./term-sd-backup/ComfyUI/custom_nodes ./ComfyUI/
    cp -rf ./term-sd-backup/ComfyUI/models ./ComfyUI/
    cp -rf ./term-sd-backup/ComfyUI/output ./ComfyUI/
    cp -rf ./term-sd-backup/ComfyUI/web/extensions ./ComfyUI/
}

# invokeai
invokeai_data_backup()
{
    [ ! -d "./term-sd-backup/InvokeAI" ] && mkdir ./term-sd-backup/InvokeAI
    cp -rf ./InvokeAI/invokeai ./term-sd-backup/InvokeAI/
}

invokeai_data_restore()
{
    cp -rf ./term-sd-backup/InvokeAI/invokeai ./InvokeAI/
}

# fooocus
fooocus_data_backup()
{
    [ ! -d "./term-sd-backup/Fooocus" ] && mkdir ./term-sd-backup/Fooocus
    cp -rf ./Fooocus/models ./term-sd-backup/Fooocus/
    cp -rf ./Fooocus/outputs ./term-sd-backup/Fooocus/
    cp -f ./Fooocus/config.txt ./term-sd-backup/Fooocus/
}

fooocus_data_restore()
{
    cp -rf ./term-sd-backup/Fooocus/models ./Fooocus/
    cp -rf ./term-sd-backup/Fooocus/outputs ./Fooocus/
    cp -f ./term-sd-backup/Fooocus/config.txt ./Fooocus/
}

# lora-scripts
lora_scripts_data_backup()
{
    [ ! -d "./term-sd-backup/lora-scripts" ] && mkdir ./term-sd-backup/lora-scripts
    cp -rf ./lora-scripts/config/autosave ./term-sd-backup/lora-scripts/
    cp -rf ./lora-scripts/logs ./term-sd-backup/lora-scripts/
    cp -rf ./lora-scripts/output ./term-sd-backup/lora-scripts/
    cp -rf ./lora-scripts/sd-models ./term-sd-backup/lora-scripts/
    cp -rf ./lora-scripts/train ./term-sd-backup/lora-scripts/
}

lora_scripts_data_restore()
{
    cp -rf ./term-sd-backup/lora-scripts/config/autosave ./lora-scripts/
    cp -rf ./term-sd-backup/lora-scripts/logs ./lora-scripts/
    cp -rf ./term-sd-backup/lora-scripts/output ./lora-scripts/
    cp -rf ./term-sd-backup/lora-scripts/sd-models ./lora-scripts/
    cp -rf ./term-sd-backup/lora-scripts/train ./lora-scripts/
}

# kohya_ss
kohya_ss_data_backup()
{
    [ ! -d "./term-sd-backup/kohya_ss" ] && mkdir ./term-sd-backup/kohya_ss
    cp -rf ./kohya_ss/output ./term-sd-backup/kohya_ss/
    cp -rf ./kohya_ss/train ./term-sd-backup/kohya_ss/
    cp -rf ./kohya_ss/models ./term-sd-backup/kohya_ss/
}

kohya_ss_data_restore()
{
    cp -rf ./term-sd-backup/kohya_ss/output ./kohya_ss/
    cp -rf ./term-sd-backup/kohya_ss/train ./kohya_ss/
    cp -rf ./term-sd-backup/kohya_ss/models ./kohya_ss/
}

#################################################

if [ -d "./term-sd-backup" ];then
    term_sd_echo "备份数据文件夹路径:${start_path}/term-sd-backup"
else
    term_sd_echo "创建备份数据文件夹中,路径:${start_path}/term-sd-backup"
    mkdir ./term-sd-backup
fi

while (($? == 0));do
    term_sd_file_manager
done
