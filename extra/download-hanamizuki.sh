#!/bin/bash

. ./term-sd/modules/term_sd_try.sh
. ./term-sd/modules/term_sd_manager.sh

# 下载源选择
download_hanamizuki_resource_select()
{
    while true
    do
        term_sd_echo "请选择绘世启动器下载源"
        term_sd_echo "1、Github 源 (速度可能比较慢)"
        term_sd_echo "2、Gitee 源"
        term_sd_echo "3、退出"
        case $(term_sd_read) in
            1)
                term_sd_echo "选择 Github 源"
                download_hanamizuki_resource="https://github.com/licyk/term-sd/releases/download/archive/hanamizuki.exe"
                return 0
                ;;
            2)
                term_sd_echo "选择 Gitee 源"
                download_hanamizuki_resource="https://gitee.com/licyk/term-sd/releases/download/archive/hanamizuki.exe"
                return 0
                ;;
            3)
                return 1
                ;;
            *)
                term_sd_echo "输入有误, 请重试"
                ;;
        esac
    done
}

# 绘世启动器下载
download_hanamizuki()
{
    aria2_download $download_hanamizuki_resource term-sd/task "绘世.exe"
    if [ $? = 0 ];then
        if [ -d "$sd_webui_path" ];then
            if [ ! -f "$sd_webui_path/绘世.exe" ];then
                cp -f "term-sd/task/绘世.exe" "$sd_webui_path"
                term_sd_echo "已将绘世启动器复制到 Stable-Diffusion-WebUI 文件夹"
            else
                term_sd_echo "Stable-Diffusion-WebUI 文件夹中已存在绘世启动器"
            fi
        else
            term_sd_echo "未找到 Stable-Diffusion-WebUI 文件夹"
        fi

        if [ -d "$comfyui_path" ];then
            if [ ! -f "$comfyui_path/绘世.exe" ];then
                cp -f "term-sd/task/绘世.exe" "$comfyui_path"
                term_sd_echo "已将绘世启动器复制到 ComfyUI 文件夹"
            else
                term_sd_echo "ComfyUI 文件夹中已存在绘世启动器"
            fi
        else
            term_sd_echo "未找到 ComfyUI 文件夹"
        fi

        if [ -d "$fooocus_path" ];then
            if [ ! -f "$fooocus_path/绘世.exe" ];then
                cp -f "term-sd/task/绘世.exe" "$fooocus_path"
                term_sd_echo "已将绘世启动器复制到 Fooocus 文件夹"
            else
                term_sd_echo "Fooocus 文件夹中已存在绘世启动器"
            fi
        else
            term_sd_echo "未找到 Fooocus 文件夹"
        fi
        rm -f "term-sd/task/绘世.exe"
    else
        term_sd_echo "下载失败"
    fi
}

#############################

if [ -d "$sd_webui_path" ] || [ -d "$comfyui_path" ] || [ -d "$fooocus_path" ];then
    if [ ! -f "$sd_webui_path/绘世.exe" ] || [ ! -f "$comfyui_path/绘世.exe" ] || [ ! -f "$fooocus_path/绘世.exe" ];then
        download_hanamizuki_resource_select
        if [ $? = 0 ];then
            download_hanamizuki
        fi
    else
        term_sd_echo "绘世启动器已存在 Stable-Diffusion-WebUI, ComfyUI, Fooocus 文件夹中"
    fi
else
    term_sd_echo "未找到 Stable-Diffusion-WebUI, ComfyUI, Fooocus 文件夹"
fi