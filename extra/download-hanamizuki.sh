#!/bin/bash

download_hanamizuki_resource_select()
{
    while true
    do
        term_sd_echo "请选择绘世启动器下载源"
        term_sd_echo "1、github源(速度可能比较慢)"
        term_sd_echo "2、gitee源"
        term_sd_echo "3、退出"
        case $(term_sd_read) in
            1)
                term_sd_echo "选择github源"
                download_hanamizuki_resource="https://github.com/licyk/term-sd/releases/download/archive/hanamizuki.exe"
                return 0
                ;;
            2)
                term_sd_echo "选择gitee源"
                download_hanamizuki_resource="https://gitee.com/licyk/term-sd/releases/download/archive/hanamizuki.exe"
                return 0
                ;;
            3)
                return 1
                ;;
            *)
                term_sd_echo "输入有误,请重试"
                ;;
        esac
    done
}

download_hanamizuki()
{
    aria2c $download_hanamizuki_resource -d term-sd/task -o "绘世.exe"
    if [ $? = 0 ];then
        if [ -d "$sd_webui_path" ];then
            if [ ! -f "$sd_webui_path/绘世.exe" ];then
                cp -f "term-sd/task/绘世.exe" "$sd_webui_path"
                term_sd_echo "已将绘世启动器复制到stable-diffusion-webui文件夹"
            else
                term_sd_echo "stable-diffusion-webui文件夹中已存在绘世启动器"
            fi
        else
            term_sd_echo "未找到stable-diffusion-webui文件夹"
        fi

        if [ -d "$comfyui_path" ];then
            if [ ! -f "$comfyui_path/绘世.exe" ];then
                cp -f "term-sd/task/绘世.exe" "$comfyui_path"
                term_sd_echo "已将绘世启动器复制到ComfyUI文件夹"
            else
                term_sd_echo "ComfyUI文件夹中已存在绘世启动器"
            fi
        else
            term_sd_echo "未找到ComfyUI文件夹"
        fi

        if [ -d "$fooocus_path" ];then
            if [ ! -f "$fooocus_path/绘世.exe" ];then
                cp -f "term-sd/task/绘世.exe" "$fooocus_path"
                term_sd_echo "已将绘世启动器复制到Fooocus文件夹"
            else
                term_sd_echo "Fooocus文件夹中已存在绘世启动器"
            fi
        else
            term_sd_echo "未找到Fooocus文件夹"
        fi
        rm -f "term-sd/task/绘世.exe"
    else
        term_sd_echo "下载失败"
    fi
}

if [ -d "$sd_webui_path" ] || [ -d "$comfyui_path" ] || [ -d "$fooocus_path" ];then
    if [ ! -f "$sd_webui_path/绘世.exe" ] || [ ! -f "$comfyui_path/绘世.exe" ] || [ ! -f "$fooocus_path/绘世.exe" ];then
        download_hanamizuki_resource_select
        if [ $? = 0 ];then
            download_hanamizuki
        fi
    else
        term_sd_echo "绘世启动器已存在stable-diffusion-webui,ComfyUI,Fooocus文件夹中"
    fi
else
    term_sd_echo "未找到stable-diffusion-webui,ComfyUI,Fooocus文件夹"
fi