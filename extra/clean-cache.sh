#!/bin/bash

. ./term-sd/modules/term_sd_python_cmd.sh
. ./term-sd/modules/term_sd_git.sh

term_sd_echo "开始清理缓存中"

if [[ -d "${SD_WEBUI_PATH}" ]]; then
    term_sd_echo "清理 Stable-Diffusion—WebUI 缓存中"
    git -C "${SD_WEBUI_PATH}" gc
    for i in "${SD_WEBUI_PATH}"/repositories/*
    do
        if is_git_repo "${i}"; then
            term_sd_echo "清理 $(basename "${i}") 组件缓存中"
            git -C "${i}" gc
        fi
    done
    term_sd_echo "清理 Stable-Diffusion—WebUI 插件缓存中"
    for i in "${SD_WEBUI_PATH}"/extensions/*; do
        if is_git_repo "${i}"; then
            term_sd_echo "清理 $(basename "${i}") 插件缓存中"
            git -C "${i}" gc
        fi
    done
    term_sd_echo "清理 Stable-Diffusion—WebUI 缓存完成"
fi

if [[ -d "${COMFYUI_PATH}" ]]; then
    term_sd_echo "清理 ComfyUI 缓存中"
    git -C "${COMFYUI_PATH}" gc
    term_sd_echo "清理 ComfyUI 插件缓存中"
    for i in "${COMFYUI_PATH}"/web/extensions/*; do
        if is_git_repo "${i}"; then
            term_sd_echo "清理 $(basename "${i}") 插件缓存中"
            git -C "${i}" gc
        fi
    done
    term_sd_echo "清理 ComfyUI 自定义节点缓存中"
    for i in "${COMFYUI_PATH}"/custom_nodes/*; do
        if is_git_repo "${i}"; then
            term_sd_echo "清理 $(basename "${i}") 自定义节点缓存中"
            git -C "${i}" gc
        fi
    done
    term_sd_echo "清理 ComfyUI 缓存完成"
fi

if [[ -d "${FOOOCUS_PATH}" ]]; then
    term_sd_echo "清理 Fooocus 缓存中"
    git -C "${FOOOCUS_PATH}" gc
    term_sd_echo "清理 Fooocus 缓存完成"
fi

if [[ -d "${LORA_SCRIPTS_PATH}" ]]; then
    term_sd_echo "清理 lora-scrips 缓存中"
    git -C "${LORA_SCRIPTS_PATH}" gc
    term_sd_echo "清理 lora-scrips 缓存完成"
fi

if [[ -d "${KOHYA_SS_PATH}" ]]; then
    term_sd_echo "清理 kohya_ss 缓存中"
    git -C "${KOHYA_SS_PATH}" gc
    term_sd_echo "清理 kohya_ss 缓存完成"
fi

term_sd_echo "清理 Term-SD 缓存中"
git -C "${START_PATH}"/term-sd gc
term_sd_echo "清理 Term-SD 缓存完成"

term_sd_echo "清理 Pip 缓存中"
term_sd_pip cache purge
term_sd_echo "清理 Pip 缓存完成"

term_sd_echo "缓存清理结束"