#!/bin/bash

# modelscope下载链接格式
# https://modelscope.cn/api/v1/models/作者/仓库/repo?Revision=分支名&FilePath=文件名
# https://modelscope.cn/api/v1/models/作者/仓库/repo?Revision=分支名&FilePath=文件夹/文件名

# modelscope模型下载
# 使用格式 get_modelscope_model 作者/仓库/仓库分支 仓库文件路径 本地下载路径
# 例: get_modelscope_model licyks/sd-model/master sd_1.5/v1-5-pruned-emaonly.safetensors ./stable-diffusion-webui/models/Stable-diffusion
function get_modelscope_model()
{
    modelscope_user=$(echo $@ | awk '{gsub(/[/]/, " ")}1' | awk '{print$1}')
    modelscope_name=$(echo $@ | awk '{gsub(/[/]/, " ")}1' | awk '{print$2}')
    modelscope_branch=$(echo $@ | awk '{gsub(/[/]/, " ")}1' | awk '{print$3}')
    cmd_daemon aria2c $aria2_multi_threaded "https://modelscope.cn/api/v1/models/${modelscope_user}/${modelscope_name}/repo?Revision=${modelscope_branch}&FilePath=${2}" -d ${3} -o $(echo $2 | awk -F'/' '{print$NF}')
}