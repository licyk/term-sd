#!/bin/bash

function download_hanamizuki_resource_select()
{
    term_sd_notice "请选择绘世启动器下载源"
    term_sd_notice "1、github源(速度可能比较慢)"
    term_sd_notice "2、gitee源"
    term_sd_notice "3、退出"
    read -p "===============================> " download_hanamizuki_resource_select_
    if [ ! -z "$download_hanamizuki_resource_select_" ];then
        if [ $download_hanamizuki_resource_select_ = 1 ];then
            term_sd_notice "选择github源"
            export download_hanamizuki_resource="https://github.com/licyk/README-collection/releases/download/archive/hanamizuki.exe"
        elif [ $download_hanamizuki_resource_select_ = 2 ];then
            term_sd_notice "选择gitee源"
            export download_hanamizuki_resource="https://gitee.com/four-dishes/README-collection/releases/download/v0.0.1/hanamizuki.exe"
        elif [ $download_hanamizuki_resource_select_ = 3 ];then
            download_hanamizuki_info=1
        else
            term_sd_notice "输入有误,请重试"
            download_hanamizuki_resource_select
        fi
    fi
}

function download_hanamizuki()
{
    mkdir term-sd-tmp
    aria2c $download_hanamizuki_resource -d ./term-sd-tmp -o "绘世.exe"
    if [ $? = 0 ];then
        if [ -d "./stable-diffusion-webui" ];then
            if [ ! -f "./stable-diffusion-webui/绘世.exe" ];then
                cp -f "./term-sd-tmp/绘世.exe" ./stable-diffusion-webui
                term_sd_notice "已将绘世启动器复制到stable-diffusion-webui文件夹"
            else
                term_sd_notice "stable-diffusion-webui文件夹已存在绘世启动器"
            fi
        else
            term_sd_notice "未找到stable-diffusion-webui文件夹"
        fi

        if [ -d "./ComfyUI" ];then
            if [ ! -f "./ComfyUI/绘世.exe" ];then
                cp -f "./term-sd-tmp/绘世.exe" ./ComfyUI
                term_sd_notice "已将绘世启动器复制到ComfyUI文件夹"
            else
                term_sd_notice "ComfyUI文件夹已存在绘世启动器"
            fi
        else
            term_sd_notice "未找到ComfyUI文件夹"
        fi
    else
        term_sd_notice "下载失败"
    fi
    rm -rf ./term-sd-tmp    
}

function download_hanamizuki_init()
{
    if [ -d "./stable-diffusion-webui" ] || [ -d "./ComfyUI" ];then
        if [ ! -f "./stable-diffusion-webui/绘世.exe" ] || [ ! -f "./ComfyUI/绘世.exe" ];then
            download_hanamizuki_info=0
            download_hanamizuki_resource_select
            if [ ! $download_hanamizuki_info = 1 ];then
                download_hanamizuki
            fi
        else
            term_sd_notice "绘世启动器已存在stable-diffusion-webui文件夹中或者ComfyUI文件夹中"
        fi
    else
        term_sd_notice "未找到stable-diffusion-webui文件夹或者ComfyUI文件夹"
    fi
}

download_hanamizuki_init