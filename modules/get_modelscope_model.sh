#!/bin/bash

# modelscope下载链接格式
# https://modelscope.cn/api/v1/models/作者/仓库/repo?Revision=分支名&FilePath=文件名
# https://modelscope.cn/api/v1/models/作者/仓库/repo?Revision=分支名&FilePath=文件夹/文件名

# modelscope模型下载
# 使用格式:
# get_modelscope_model 作者/仓库/仓库分支/仓库文件路径/文件名 本地下载路径
# get_modelscope_model 作者/仓库/仓库分支/文件名 本地下载路径
# 例:
# get_modelscope_model licyks/sd-model/master/sd_1.5/v1-5-pruned-emaonly.safetensors ./stable-diffusion-webui/models/Stable-diffusion
# get_modelscope_model licyks/controlnet_v1.1/master/t2iadapter_zoedepth_sd15v1.pth ./stable-diffusion-webui/

get_modelscope_model()
{
    local modelscope_user=$(echo $@ | awk '{gsub(/[/]/, " ")}1' | awk '{print$1}')
    local modelscope_name=$(echo $@ | awk '{gsub(/[/]/, " ")}1' | awk '{print$2}')
    local modelscope_branch=$(echo $@ | awk '{gsub(/[/]/, " ")}1' | awk '{print$3}')
    local modelscope_model_path=$(echo $1 | awk '{sub("'${modelscope_user}/${modelscope_name}/${modelscope_branch}/'","")}1')
    local modelscope_model_url="https://modelscope.cn/api/v1/models/${modelscope_user}/${modelscope_name}/repo?Revision=${modelscope_branch}&FilePath=${modelscope_model_path}"
    local local_file_parent_path
    local modelscope_model_name
    local local_aria_cache_path
    local local_file_path

    if [ -z "$2" ];then # 只有链接时
        local_file_path="./$(basename "$1")"
        local_aria_cache_path="${local_file_path}.aria2"
        modelscope_model_name=$(basename "$local_file_path")
        local_file_parent_path=$(dirname "$local_file_path")
    elif [ -z "$3" ];then # 有链接和下载位置
        local_file_path="${2}/$(basename "$1")"
        local_aria_cache_path="${2}/$(basename "$1").aria2"
        modelscope_model_name=$(basename "$local_file_path")
        local_file_parent_path=$(dirname "$local_file_path")
    else # 链接,下载位置和下载文件名都有
        local_file_path="${2}/${3}"
        local_aria_cache_path="${2}/${3}.aria2"
        modelscope_model_name=$(basename "$local_file_path")
        local_file_parent_path=$(dirname "$local_file_path")
    fi
    
    if [ ! -f "$local_file_path" ];then
        term_sd_echo "下载${modelscope_model_name}中"
        term_sd_watch aria2c -c $aria2_multi_threaded $modelscope_model_url -d "$local_file_parent_path" -o "$modelscope_model_name"
    else
        if [ -f "$local_aria_cache_path" ];then
            term_sd_echo "恢复下载${modelscope_model_name}中"
            term_sd_watch aria2c -c $aria2_multi_threaded $modelscope_model_url -d "$local_file_parent_path" -o "$modelscope_model_name"
        else
            term_sd_echo "${modelscope_model_name}文件已存在,跳过下载该文件"
        fi
    fi
}
