#!/bin/bash

. ./term-sd/modules/term_sd_python_cmd.sh

term_sd_echo "开始清理缓存中"

if [ -d "$sd_webui_path" ];then
    term_sd_echo "清理 Stable-Diffusion—WebUI 缓存中"
    git -C "$sd_webui_path" gc
    for i in "$sd_webui_path"/repositories/*
    do
        if [ -d "$i/.git" ];then
            term_sd_echo "清理 $(basename "$i") 组件缓存中"
            git -C "$i" gc
        fi
    done
    term_sd_echo "清理 Stable-Diffusion—WebUI 插件缓存中"
    for i in "$sd_webui_path"/extensions/*
    do
        if [ -d "$i/.git" ];then
            term_sd_echo "清理 $(basename "$i") 插件缓存中"
            git -C "$i" gc
        fi
    done
    term_sd_echo "清理 Stable-Diffusion—WebUI 缓存完成"
fi

if [ -d "$comfyui_path" ];then
    term_sd_echo "清理 ComfyUI 缓存中"
    git -C "$comfyui_path" gc
    term_sd_echo "清理 ComfyUI 插件缓存中"
    for i in "$comfyui_path"/web/extensions/*
    do
        if [ -d "$i/.git" ];then
            term_sd_echo "清理 $(basename "$i") 插件缓存中"
            git -C "$i" gc
        fi
    done
    term_sd_echo "清理 ComfyUI 自定义节点缓存中"
    for i in "$comfyui_path"/custom_nodes/*
    do
        if [ -d "$i/.git" ];then
            term_sd_echo "清理 $(basename "$i") 自定义节点缓存中"
            git -C "$i" gc
        fi
    done
    term_sd_echo "清理 ComfyUI 缓存完成"
fi

if [ -d "$fooocus_path" ];then
    term_sd_echo "清理 Fooocus 缓存中"
    git -C "$fooocus_path" gc
    term_sd_echo "清理 Fooocus 缓存完成"
fi

if [ -d "$lora_scripts_path" ];then
    term_sd_echo "清理 lora-scrips 缓存中"
    git -C "$lora_scripts_path" gc
    term_sd_echo "清理 lora-scrips 缓存完成"
fi

if [ -d "$kohya_ss_path" ];then
    term_sd_echo "清理 kohya_ss 缓存中"
    git -C "$kohya_ss_path" gc
    term_sd_echo "清理 kohya_ss 缓存完成"
fi

term_sd_echo "清理 Term-SD 缓存中"
git -C term-sd gc
term_sd_echo "清理 Term-SD 缓存完成"

term_sd_echo "清理 Pip 缓存中"
term_sd_pip cache purge
term_sd_echo "清理 Pip 缓存完成"

term_sd_echo "缓存清理结束"