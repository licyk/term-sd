#!/bin/bash

# modelscope下载链接格式(旧版)
# https://modelscope.cn/api/v1/models/作者/仓库/repo?Revision=分支名&FilePath=文件名
# https://modelscope.cn/api/v1/models/作者/仓库/repo?Revision=分支名&FilePath=文件夹/文件名

# modelscope模型下载
# 使用格式:
# get_modelscope_model 作者/仓库/仓库分支/仓库文件路径/文件名 本地下载路径
# get_modelscope_model 作者/仓库/仓库分支/文件名 本地下载路径
# 例:
# get_modelscope_model licyks/sd-model/master/sd_1.5/v1-5-pruned-emaonly.safetensors ./stable-diffusion-webui/models/Stable-diffusion
# get_modelscope_model licyks/controlnet_v1.1/master/t2iadapter_zoedepth_sd15v1.pth ./stable-diffusion-webui/

get_modelscope_model() {
    local url=$1 # 链接
    local path=$2 # 下载路径
    local name=$3 # 要保存的名称
    local aria2_tmp_path # Aria2 缓存文件
    local file_path # 下载到本地的文件
    local modelscope_user # ModelScope 用户名
    local modelscope_model_name # ModelScope 仓库名
    local modelscope_model_branch # ModelScope 仓库分支
    local modelscope_model_path # ModelScope 仓库文件路径

    # 处理 ModelScope 链接
    modelscope_user=$(echo ${url} | awk '{gsub(/[/]/, " ")}1' | awk '{print $1}')
    modelscope_model_name=$(echo ${url} | awk '{gsub(/[/]/, " ")}1' | awk '{print $2}')
    modelscope_model_branch=$(echo ${url} | awk '{gsub(/[/]/, " ")}1' | awk '{print $3}')
    modelscope_model_path=$(echo ${url} | awk '{sub("'${modelscope_user}/${modelscope_model_name}/${modelscope_model_branch}/'","")}1')
    url="https://modelscope.cn/models/${modelscope_user}/${modelscope_model_name}/resolve/${modelscope_model_branch}/${modelscope_model_path}"

    if [[ -z "${path}" ]]; then # 下载路径为空时
        path=$(pwd)
        name=$(basename "${url}")
    elif [[ -z "${name}" ]]; then # 要保存的名称为空时
        # 去除下载路径中末尾的 / 字符
        path=$(awk '{ if (substr($0, length($0), 1) == "/") { print substr($0, 1, length($0) - 1) } else { print $0 } }' <<< ${path})
        name=$(basename "${url}")
    else
        # 去除下载路径中末尾的 / 字符
        path=$(awk '{ if (substr($0, length($0), 1) == "/") { print substr($0, 1, length($0) - 1) } else { print $0 } }' <<< ${path})
    fi

    aria2_tmp_path="${path}/${name}.aria2"
    file_path="${path}/${name}"

    if term_sd_is_debug; then
        term_sd_echo "url: ${url}"
        term_sd_echo "name: ${name}"
        term_sd_echo "path: ${path}"
        term_sd_echo "aria2_tmp_path: ${aria2_tmp_path}"
        term_sd_echo "file_path: ${file_path}"
        term_sd_echo "modelscope_user: ${modelscope_user}"
        term_sd_echo "modelscope_model_name: ${modelscope_model_name}"
        term_sd_echo "modelscope_model_branch: ${modelscope_model_branch}"
        term_sd_echo "modelscope_model_path: ${modelscope_model_path}"
        term_sd_echo "ARIA2_MULTI_THREAD: ${ARIA2_MULTI_THREAD}"
        term_sd_echo "cmd: aria2c --file-allocation=none --summary-interval=0 --console-log-level=error -s 64 -c -x ${ARIA2_MULTI_THREAD} -k 1M ${url} -d ${path} -o ${name}"
    fi
    
    if [[ ! -f "${file_path}" ]]; then
        term_sd_echo "下载 ${name} 中, 路径: ${file_path}"
        term_sd_try aria2c --file-allocation=none --summary-interval=0 --console-log-level=error -s 64 -c -x "${ARIA2_MULTI_THREAD}" -k 1M "${url}" -d "${path}" -o "${name}"
    else
        if [[ -f "${aria2_tmp_path}" ]]; then
            term_sd_echo "恢复下载 ${name} 中, 路径: ${file_path}"
            term_sd_try aria2c --file-allocation=none --summary-interval=0 --console-log-level=error -s 64 -c -x "${ARIA2_MULTI_THREAD}" -k 1M "${url}" -d "${path}" -o "${name}"
        else
            term_sd_echo "${name} 文件已存在, 路径: ${file_path}"
        fi
    fi
}
