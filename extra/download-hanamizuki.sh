#!/bin/bash

. "${START_PATH}"/term-sd/modules/term_sd_try.sh
. "${START_PATH}"/term-sd/modules/term_sd_manager.sh

# 下载源选择
download_hanamizuki_resource_select() {
    while true; do
        term_sd_echo "请选择绘世启动器下载源"
        term_sd_echo "1、Github 源 (速度可能比较慢)"
        term_sd_echo "2、Gitee 源"
        term_sd_echo "3、退出"
        case "$(term_sd_read)" in
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
download_hanamizuki() {
    aria2_download ${download_hanamizuki_resource} term-sd/task "绘世.exe"
    if [[ "$?" == 0 ]]; then
        install_hanamizuki "$SD_WEBUI_PATH" "Stable-Diffusion-WebUI"
        install_hanamizuki "$COMFYUI_PATH" "ComfyUI"
        install_hanamizuki "$FOOOCUS_PATH" "Fooocus"
        install_hanamizuki "$LORA_SCRIPTS_PATH" "lora-scripts"
        rm -f "term-sd/task/绘世.exe"
    else
        term_sd_echo "下载失败"
    fi
}

# 将绘世启动器复制到 AI 软件目录中
install_hanamizuki() {
    local install_path=$1
    local sd_name=$2

    if [[ -d "${install_path}" ]]; then
        if [[ -f "${install_path}"/*绘世*.exe ]] \
            || [[ -f "${install_path}"/A*.exe ]] \
            || [[ -f "${install_path}"/*启动器.exe ]]; then

            term_sd_echo "绘世启动器已存在于 ${sd_name} 文件夹中"
        else
            term_sd_echo "将绘世启动器复制到 ${sd_name} 文件夹: ${install_path}"
            cp -f "term-sd/task/绘世.exe" "${install_path}"
        fi
    else
        term_sd_echo "${sd_name} 未安装"
    fi
}

#############################

if is_windows_platform; then
    if download_hanamizuki_resource_select; then
        download_hanamizuki
    else
        term_sd_echo "取消下载绘世启动器"
    fi
else
    term_sd_echo "检测到系统不是 Windows 系统, 无法使用绘世启动器"
fi