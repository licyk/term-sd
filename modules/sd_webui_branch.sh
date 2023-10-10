#!/bin/bash

#sd-web启动分支选项
function sd_webui_launch()
{
    sd_webui_branch=$(git remote -v | awk 'NR==1' | awk '{print $2}')
    if [ ! -z "$(echo $sd_webui_branch | grep stable-diffusion-webui)" ];then
        a1111_sd_webui_launch
    elif [ ! -z "$(echo $sd_webui_branch | grep automatic)" ];then
        vlad_sd_webui_launch
    elif [ ! -z "$(echo $sd_webui_branch | grep stable-diffusion-webui-directml)" ];then
        sd_webui_directml_launch
    fi
}

#sd-web启动参数修改分支选项
function generate_sd_webui_launch()
{
    sd_webui_branch=$(git remote -v | awk 'NR==1' | awk '{print $2}')
    if [ ! -z "$(echo $sd_webui_branch | grep stable-diffusion-webui)" ];then
        generate_a1111_sd_webui_launch
    elif [ ! -z "$(echo $sd_webui_branch | grep automatic)" ];then
        generate_vlad_sd_webui_launch
    elif [ ! -z "$(echo $sd_webui_branch | grep stable-diffusion-webui-directml)" ];then
        generate_sd_webui_directml_launch
    fi
}

#sd-webui分支切换功能
function sd_webui_branch_switch()
{
    sd_webui_branch_switch_dialog=$(
        dialog --clear --title "A1111-SD-Webui管理" --backtitle "A1111-SD-Webui分支切换选项" --ok-label "确认" --cancel-label "取消" --menu "请选择SD-Webui分支\n当前更新源:$(git remote -v | awk 'NR==1' | awk '{print $2}')" 23 70 12 \
            "1" "更新" \
            "2" "卸载" \
            "3" "修复更新" \
            "4" "管理插件" \
            "5" "切换版本" \
            "6" "更新源替换" \
            "7" "返回" \
            3>&1 1>&2 2>&3)
    
    if [ $? = 0 ];then
        if [ $sd_webui_branch_switch_dialog = 1 ];then
            print_line_to_shell "$term_sd_manager_info 分支切换"
            term_sd_notice "切换到AUTOMATIC1111/stable-diffusion-webui主分支"
            git remote set-url origin https://github.com/AUTOMATIC1111/stable-diffusion-webui
            git fetch
            git checkout master
            git pull --rebase
            print_line_to_shell
        elif [ $sd_webui_branch_switch_dialog = 2 ];then
            print_line_to_shell "$term_sd_manager_info 分支切换"
            term_sd_notice "切换到AUTOMATIC1111/stable-diffusion-webui主分支"
            git remote set-url origin https://github.com/AUTOMATIC1111/stable-diffusion-webui
            git fetch
            git checkout dev
            git pull --rebase
            print_line_to_shell
        elif [ $sd_webui_branch_switch_dialog = 3 ];then
            print_line_to_shell "$term_sd_manager_info 分支切换"
            term_sd_notice "切换到vladmandic/SD.NEXT主分支"
            git remote set-url origin https://github.com/vladmandic/automatic
            git fetch
            git checkout master
            git pull --rebase
            print_line_to_shell
        elif [ $sd_webui_branch_switch_dialog = 4 ];then
            print_line_to_shell "$term_sd_manager_info 分支切换"
            term_sd_notice "切换到vladmandic/SD.NEXT测试分支"
            git remote set-url origin https://github.com/vladmandic/automatic
            git fetch
            git checkout dev
            git pull --rebase
            print_line_to_shell
        elif [ $sd_webui_branch_switch_dialog = 5 ];then
            print_line_to_shell "$term_sd_manager_info 分支切换"
            term_sd_notice "切换到lshqqytiger/stable-diffusion-webui-directml主分支"
            git remote set-url origin https://github.com/lshqqytiger/stable-diffusion-webui-directml
            git fetch
            git checkout master
            git pull --rebase
            print_line_to_shell
        elif [ $sd_webui_branch_switch_dialog = 6 ];then
            print_line_to_shell "$term_sd_manager_info 分支切换"
            term_sd_notice "切换到lshqqytiger/stable-diffusion-webui-directml测试分支"
            git remote set-url origin https://github.com/lshqqytiger/stable-diffusion-webui-directml
            git fetch
            git checkout dev
            git pull --rebase
            print_line_to_shell
        fi
    fi
}