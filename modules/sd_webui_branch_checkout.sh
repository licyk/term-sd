#!/bin/bash

#sd-webui分支切换功能
function sd_webui_branch_switch()
{
    proxy_option #切换前前代理选择
    sd_webui_branch_switch_dialog=$(
        dialog --clear --title "A1111-SD-Webui管理" --backtitle "A1111-SD-Webui分支切换选项" --ok-label "确认" --cancel-label "取消" --menu "请选择要切换的SD-Webui分支\n当前更新源:$(git remote -v | awk 'NR==1 {print $2}')" 25 80 10 \
            "1" "AUTOMATIC1111/stable-diffusion-webui主分支" \
            "2" "AUTOMATIC1111/stable-diffusion-webui测试分支" \
            "3" "vladmandic/SD.NEXT主分支" \
            "4" "vladmandic/SD.NEXT测试分支" \
            "5" "lshqqytiger/stable-diffusion-webui-directml主分支" \
            "6" "lshqqytiger/stable-diffusion-webui-directml测试分支" \
            "7" "返回" \
            3>&1 1>&2 2>&3)

    if [ $? = 0 ];then
        case $sd_webui_branch_switch_dialog in
            1)
                print_line_to_shell "$term_sd_manager_info 分支切换"
                term_sd_notice "切换到AUTOMATIC1111/stable-diffusion-webui主分支"
                git remote set-url origin "$github_proxy"https://github.com/AUTOMATIC1111/stable-diffusion-webui
                git fetch
                git checkout master
                git pull --rebase
                print_line_to_shell
                ;;
            2)
                print_line_to_shell "$term_sd_manager_info 分支切换"
                term_sd_notice "切换到AUTOMATIC1111/stable-diffusion-webui主分支"
                git remote set-url origin "$github_proxy"https://github.com/AUTOMATIC1111/stable-diffusion-webui
                git fetch
                git checkout dev
                git pull --rebase
                print_line_to_shell
                ;;
            3)
                print_line_to_shell "$term_sd_manager_info 分支切换"
                term_sd_notice "切换到vladmandic/SD.NEXT主分支"
                git remote set-url origin "$github_proxy"https://github.com/vladmandic/automatic
                git fetch
                git checkout master
                git pull --rebase
                print_line_to_shell
                ;;
            4)
                print_line_to_shell "$term_sd_manager_info 分支切换"
                term_sd_notice "切换到vladmandic/SD.NEXT测试分支"
                git remote set-url origin "$github_proxy"https://github.com/vladmandic/automatic
                git fetch
                git checkout dev
                git pull --rebase
                print_line_to_shell
                ;;
            5)
                print_line_to_shell "$term_sd_manager_info 分支切换"
                term_sd_notice "切换到lshqqytiger/stable-diffusion-webui-directml主分支"
                git remote set-url origin "$github_proxy"https://github.com/lshqqytiger/stable-diffusion-webui-directml
                git fetch
                git checkout master
                git pull --rebase
                print_line_to_shell
                ;;
            6)
                print_line_to_shell "$term_sd_manager_info 分支切换"
                term_sd_notice "切换到lshqqytiger/stable-diffusion-webui-directml测试分支"
                git remote set-url origin "$github_proxy"https://github.com/lshqqytiger/stable-diffusion-webui-directml
                git fetch
                git checkout dev
                git pull --rebase
                print_line_to_shell
        esac
    fi
}