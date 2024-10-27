#!/bin/bash

# SD WebUI 分支切换功能
# 使用 GITHUB_MIRROR 环境变量设置 GIthub 镜像源
sd_webui_branch_switch() {
    local sd_webui_branch
    local dialog_arg
    local remote_url

    case "$(git remote get-url origin | awk -F '/' '{print $NF}')" in # 分支判断
        stable-diffusion-webui|stable-diffusion-webui.git)
            sd_webui_branch="AUTOMATIC1111 webui $(git_branch_display)"
            ;;
        automatic|automatic.git)
            sd_webui_branch="vladmandic webui $(git_branch_display)"
            ;;
        stable-diffusion-webui-directml|stable-diffusion-webui-directml.git|stable-diffusion-webui-amdgpu|stable-diffusion-webui-amdgpu.git)
            sd_webui_branch="lshqqytiger webui $(git_branch_display)"
            ;;
        stable-diffusion-webui-forge|stable-diffusion-webui-forge.git)
            sd_webui_branch="lllyasviel webui $(git_branch_display)"
            ;;
        stable-diffusion-webui-reForge|stable-diffusion-webui-reForge.git)
            sd_webui_branch="Panchovix webui $(git_branch_display)"
            ;;
        *)
            dialog --erase-on-exit \
                --title "Stable-Diffusion-WebUI 管理" \
                --backtitle "Stable-Diffusion-WebUI 更新结果" \
                --ok-label "确认" \
                --msgbox "Stable-Diffusion-WebUI 非 Git 安装, 无法切换分支" \
                $(get_dialog_size)

            return 10
            ;;
    esac

    download_mirror_select # 切换前选择 Github 源
    dialog_arg=$(dialog --erase-on-exit --notags \
        --title "Stable-Diffusion-WebUI 管理" \
        --backtitle "Stable-Diffusion-WebUI 分支切换选项" \
        --ok-label "确认" --cancel-label "取消" \
        --menu "请选择要切换的 Stable-Diffusion-WebUI 分支\n当前更新源: $(git_remote_display)\n当前分支: ${sd_webui_branch}" \
        $(get_dialog_size_menu) \
        "0" "> 返回" \
        "1" "> AUTOMATIC1111 - Stable-Diffusion-WebUI 主分支" \
        "2" "> AUTOMATIC1111 - Stable-Diffusion-WebUI 测试分支" \
        "3" "> lllyasviel - Stable-Diffusion-WebUI-Forge 分支" \
        "4" "> Panchovix - stable-diffusion-webui-reForge 主分支" \
        "5" "> Panchovix - stable-diffusion-webui-reForge 测试分支" \
        "6" "> lshqqytiger - Stable-Diffusion-WebUI-AMDGPU 分支" \
        "7" "> vladmandic - SD.NEXT 主分支" \
        "8" "> vladmandic - SD.NEXT 测试分支" \
        3>&1 1>&2 2>&3)

    case "${dialog_arg}" in
        1)
            term_sd_print_line "Stable-Diffusion-WebUI 分支切换"
            term_sd_echo "切换到 AUTOMATIC1111 - Stable-Diffusion-WebUI 主分支"
            remote_url=$(git_format_repository_url "${GITHUB_MIRROR}" https://github.com/AUTOMATIC1111/stable-diffusion-webui)
            git_switch_branch "${remote_url}" master
            if [[ "$?" == 0 ]];then
                mv -f "${SD_WEBUI_PATH}"/repositories/blip "${SD_WEBUI_PATH}"/repositories/BLIP &> /dev/null
                term_sd_echo "Stable-Diffusion-WebUI 分支切换完成"
            else
                term_sd_echo "Stable-Diffusion-WebUI 分支切换失败"
            fi
            term_sd_pause
            ;;
        2)
            term_sd_print_line "Stable-Diffusion-WebUI 分支切换"
            term_sd_echo "切换到 AUTOMATIC1111 - Stable-Diffusion-WebUI 测试分支"
            remote_url=$(git_format_repository_url "${GITHUB_MIRROR}" https://github.com/AUTOMATIC1111/stable-diffusion-webui)
            git_switch_branch "${remote_url}" dev
            if [[ "$?" == 0 ]];then
                mv -f "${SD_WEBUI_PATH}"/repositories/blip "${SD_WEBUI_PATH}"/repositories/BLIP &> /dev/null
                term_sd_echo "Stable-Diffusion-WebUI 分支切换完成"
            else
                term_sd_echo "Stable-Diffusion-WebUI 分支切换失败"
            fi
            term_sd_pause
            ;;
        3)
            term_sd_print_line "Stable-Diffusion-WebUI 分支切换"
            term_sd_echo "切换到 lllyasviel - Stable-Diffusion-WebUI-Forge 主分支"
            remote_url=$(git_format_repository_url "${GITHUB_MIRROR}" https://github.com/lllyasviel/stable-diffusion-webui-forge)
            git_switch_branch "${remote_url}" main
            if [[ "$?" == 0 ]];then
                mv -f "${SD_WEBUI_PATH}"/repositories/blip "${SD_WEBUI_PATH}"/repositories/BLIP &> /dev/null
                term_sd_echo "Stable-Diffusion-WebUI 分支切换完成"
            else
                term_sd_echo "Stable-Diffusion-WebUI 分支切换失败"
            fi
            term_sd_pause
            ;;
        4)
            term_sd_print_line "Stable-Diffusion-WebUI 分支切换"
            term_sd_echo "切换到 Panchovix - stable-diffusion-webui-reForge 主分支"
            remote_url=$(git_format_repository_url "${GITHUB_MIRROR}" https://github.com/Panchovix/stable-diffusion-webui-reForge)
            git_switch_branch "${remote_url}" main
            if [[ "$?" == 0 ]];then
                mv -f "${SD_WEBUI_PATH}"/repositories/blip "${SD_WEBUI_PATH}"/repositories/BLIP &> /dev/null
                term_sd_echo "Stable-Diffusion-WebUI 分支切换完成"
            else
                term_sd_echo "Stable-Diffusion-WebUI 分支切换失败"
            fi
            term_sd_pause
            ;;
        5)
            term_sd_print_line "Stable-Diffusion-WebUI 分支切换"
            term_sd_echo "切换到 Panchovix - stable-diffusion-webui-reForge 测试分支"
            remote_url=$(git_format_repository_url "${GITHUB_MIRROR}" https://github.com/Panchovix/stable-diffusion-webui-reForge)
            git_switch_branch "${remote_url}" dev_upstream
            if [[ "$?" == 0 ]];then
                mv -f "${SD_WEBUI_PATH}"/repositories/blip "${SD_WEBUI_PATH}"/repositories/BLIP &> /dev/null
                term_sd_echo "Stable-Diffusion-WebUI 分支切换完成"
            else
                term_sd_echo "Stable-Diffusion-WebUI 分支切换失败"
            fi
            term_sd_pause
            ;;
        6)
            term_sd_print_line "Stable-Diffusion-WebUI 分支切换"
            term_sd_echo "切换到 lshqqytiger - Stable-Diffusion-WebUI-AMDGPU 主分支"
            remote_url=$(git_format_repository_url "${GITHUB_MIRROR}" https://github.com/lshqqytiger/stable-diffusion-webui-amdgpu)
            git_switch_branch "${remote_url}" master
            if [[ "$?" == 0 ]];then
                mv -f "${SD_WEBUI_PATH}"/repositories/blip "${SD_WEBUI_PATH}"/repositories/BLIP &> /dev/null
                term_sd_echo "Stable-Diffusion-WebUI 分支切换完成"
            else
                term_sd_echo "Stable-Diffusion-WebUI 分支切换失败"
            fi
            term_sd_pause
            ;;
        7)
            term_sd_print_line "Stable-Diffusion-WebUI 分支切换"
            term_sd_echo "切换到 vladmandic - SD.NEXT 主分支"
            remote_url=$(git_format_repository_url "${GITHUB_MIRROR}" https://github.com/vladmandic/automatic)
            git_switch_branch "${remote_url}" master --submod
            if [[ "$?" == 0 ]];then
                mv -f "${SD_WEBUI_PATH}"/repositories/BLIP "${SD_WEBUI_PATH}"/repositories/blip &> /dev/null
                term_sd_echo "Stable-Diffusion-WebUI 分支切换完成"
            else
                term_sd_echo "Stable-Diffusion-WebUI 分支切换失败"
            fi
            term_sd_pause
            ;;
        8)
            term_sd_print_line "Stable-Diffusion-WebUI 分支切换"
            term_sd_echo "切换到 vladmandic - SD.NEXT 测试分支"
            remote_url=$(git_format_repository_url "${GITHUB_MIRROR}" https://github.com/vladmandic/automatic)
            git_switch_branch "${remote_url}" dev --submod
            if [[ "$?" == 0 ]];then
                mv -f "${SD_WEBUI_PATH}"/repositories/BLIP "${SD_WEBUI_PATH}"/repositories/blip &> /dev/null
                term_sd_echo "Stable-Diffusion-WebUI 分支切换完成"
            else
                term_sd_echo "Stable-Diffusion-WebUI 分支切换失败"
            fi
            term_sd_pause
            ;;
    esac
    clean_install_config # 清理安装参数
}
