#!/bin/bash

# 返回 CUDA 内存分配器可用状态
is_cuda_malloc_avaliable() {
    local status

    status=$(term_sd_python "${START_PATH}/term-sd/python_modules/check_cuda_malloc_avaliable.py")

    if [[ "${status}" == True ]]; then
        return 0
    else
        return 1
    fi
}

# 返回显示是否为 Nvidia 显卡的状态
check_gpu_is_nvidia_drive() {
    local status

    status=$(term_sd_python "${START_PATH}/term-sd/python_modules/check_gpu_is_nvidia_drive.py")

    if [[ "${status}" == True ]]; then
        return 0
    else
        return 1
    fi
}

# CUDA 内存分配设置
# 参考:
# https://blog.csdn.net/MirageTanker/article/details/127998036
# https://github.com/AUTOMATIC1111/stable-diffusion-webui/wiki/Optimizations
# CUDA 内存分配配置保存在 <Start Path>/term-sd/config/set-cuda-memory-alloc.lock
cuda_memory_alloc_setting() {
    local dialog_arg
    local cuda_alloc_info

    while true; do
        if [[ -f "${START_PATH}/term-sd/config/set-cuda-memory-alloc.lock" ]]; then
            cuda_alloc_info="启用"
        else
            cuda_alloc_info="禁用"
        fi

        dialog_arg=$(dialog --erase-on-exit --notags \
            --title "Term-SD" \
            --backtitle "CUDA 内存分配设置界面" \
            --ok-label "确认" --cancel-label "取消" \
            --menu "该功能用于更换底层 CUDA 内存分配器 (仅支持 Nvidia 显卡, 且 CUDA 版本需要大于 11.4)\n当前内存分配器设置: ${cuda_alloc_info}\n是否启用 CUDA 内存分配器 ?" \
            $(get_dialog_size_menu) \
            "0" "> 返回" \
            "1" "> 启用" \
            "2" "> 禁用" \
            3>&1 1>&2 2>&3)

        case "${dialog_arg}" in
            1)
                touch "${START_PATH}/term-sd/config/set-cuda-memory-alloc.lock"

                dialog --erase-on-exit \
                    --title "Term-SD" \
                    --backtitle "CUDA 内存分配设置界面" \
                    --ok-label "确认" \
                    --msgbox "启用 CUDA 内存分配器成功" \
                    $(get_dialog_size)
                ;;
            2)
                rm -f "${START_PATH}/term-sd/config/set-cuda-memory-alloc.lock"

                dialog --erase-on-exit \
                    --title "Term-SD" \
                    --backtitle "CUDA 内存分配设置界面" \
                    --ok-label "确认" \
                    --msgbox "禁用 CUDA 内存分配器成功" \
                    $(get_dialog_size)
                ;;
            *)
                break
                ;;
        esac
    done
}
