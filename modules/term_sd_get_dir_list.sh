#!/bin/bash

# 获取当前目录下的所有文件夹
# 使用:
# get_dir_folder_list <路径>
# 执行完成后返回一个全局变量(数组) LOCAL_DIR_LIST
# 使用 ${LOCAL_DIR_LIST[@]} 进行调用
# 在 Bash 版本低于 4 时需要使用 ${LOCAL_DIR_LIST} 进行调用
get_dir_folder_list() {
    local i
    local path
    local file_name
    unset LOCAL_DIR_LIST

    if [[ -z "$@" ]]; then
        path="."
    else
        path=$@
    fi

    term_sd_echo "检索当前目录中"
    if term_sd_is_bash_ver_lower; then # Bash 4 版本才支持使用数组, 当 Bash 版本低于 4 时使用旧版获取列表方案
        LOCAL_DIR_LIST=$(ls -l "${path}" --time-style=+"%Y-%m-%d" | awk '{ print $7 " " $6 }')
    else
        for i in "${path}"/*; do
            if [[ -d "${i}" ]]; then # 将文件夹添加到列表里
                file_name=${i#${path}/}
                LOCAL_DIR_LIST+=("${file_name}" "<---------")
            fi
        done
    fi
}