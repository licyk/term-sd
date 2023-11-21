#!/bin/bash

download_hanamizuki_resource_select()
{
    term_sd_echo "请选择绘世启动器下载源"
    term_sd_echo "1、github源(速度可能比较慢)"
    term_sd_echo "2、gitee源"
    term_sd_echo "3、退出"
    case $(term_sd_read) in
        1)
            term_sd_echo "选择github源"
            download_hanamizuki_resource="https://github.com/licyk/term-sd/releases/download/archive/hanamizuki.exe"
            ;;
        2)
            term_sd_echo "选择gitee源"
            download_hanamizuki_resource="https://gitee.com/licyk/term-sd/releases/download/archive/hanamizuki.exe"
            ;;
        3)
            download_hanamizuki_info=1
            ;;
        *)
            term_sd_echo "输入有误,请重试"
            download_hanamizuki_resource_select
            ;;
    esac
}

download_hanamizuki()
{
    mkdir term-sd-tmp
    aria2c $download_hanamizuki_resource -d ./term-sd-tmp -o "绘世.exe"
    if [ $? = 0 ];then
        if [ -d "./stable-diffusion-webui" ];then
            if [ ! -f "./stable-diffusion-webui/绘世.exe" ];then
                cp -f "./term-sd-tmp/绘世.exe" ./stable-diffusion-webui
                term_sd_echo "已将绘世启动器复制到stable-diffusion-webui文件夹"
            else
                term_sd_echo "stable-diffusion-webui文件夹中已存在绘世启动器"
            fi
        else
            term_sd_echo "未找到stable-diffusion-webui文件夹"
        fi

        if [ -d "./ComfyUI" ];then
            if [ ! -f "./ComfyUI/绘世.exe" ];then
                cp -f "./term-sd-tmp/绘世.exe" ./ComfyUI
                term_sd_echo "已将绘世启动器复制到ComfyUI文件夹"
            else
                term_sd_echo "ComfyUI文件夹中已存在绘世启动器"
            fi
        else
            term_sd_echo "未找到ComfyUI文件夹"
        fi

        if [ -d "./Fooocus" ];then
            if [ ! -f "./Fooocus/绘世.exe" ];then
                cp -f "./term-sd-tmp/绘世.exe" ./Fooocus
                term_sd_echo "已将绘世启动器复制到Fooocus文件夹"
            else
                term_sd_echo "Fooocus文件夹中已存在绘世启动器"
            fi
        else
            term_sd_echo "未找到Fooocus文件夹"
        fi

    else
        term_sd_echo "下载失败"
    fi
    rm -rf ./term-sd-tmp    
}

download_hanamizuki_init()
{
    if [ -d "./stable-diffusion-webui" ] || [ -d "./ComfyUI" ] || [ -d "./Fooocus" ];then
        if [ ! -f "./stable-diffusion-webui/绘世.exe" ] || [ ! -f "./ComfyUI/绘世.exe" ] || [ ! -f "./Fooocus/绘世.exe" ];then
            download_hanamizuki_info=0
            download_hanamizuki_resource_select
            if [ ! $download_hanamizuki_info = 1 ];then
                download_hanamizuki
            fi
        else
            term_sd_echo "绘世启动器已存在stable-diffusion-webui,ComfyUI,Fooocus文件夹中"
        fi
    else
        term_sd_echo "未找到stable-diffusion-webui,ComfyUI,Fooocus文件夹"
    fi
}

download_hanamizuki_init
