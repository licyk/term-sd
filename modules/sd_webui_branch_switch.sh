#!/bin/bash

# sd-webui分支切换功能
sd_webui_branch_switch()
{
    download_mirror_select # 切换前前代理选择
    sd_webui_branch_switch_dialog=$(
        dialog --erase-on-exit --notags --title "A1111-SD-Webui管理" --backtitle "A1111-SD-Webui分支切换选项" --ok-label "确认" --cancel-label "取消" --menu "请选择要切换的SD-Webui分支\n当前更新源:$(git remote -v | awk 'NR==1 {print $2}')" $term_sd_dialog_height $term_sd_dialog_width $term_sd_dialog_menu_height \
            "0" "> 返回" \
            "1" "> AUTOMATIC1111/stable-diffusion-webui主分支" \
            "2" "> AUTOMATIC1111/stable-diffusion-webui测试分支" \
            "3" "> vladmandic/SD.NEXT主分支" \
            "4" "> vladmandic/SD.NEXT测试分支" \
            "5" "> lshqqytiger/stable-diffusion-webui-directml主分支" \
            "6" "> lshqqytiger/stable-diffusion-webui-directml测试分支" \
            3>&1 1>&2 2>&3)
    
    case $sd_webui_branch_switch_dialog in
        1)
            term_sd_print_line "$term_sd_manager_info 分支切换"
            term_sd_echo "切换到AUTOMATIC1111/stable-diffusion-webui主分支"
            git remote set-url origin "$github_proxy"https://github.com/AUTOMATIC1111/stable-diffusion-webui
            git submodule deinit --all -f
            term_sd_watch git fetch
            git checkout master
            term_sd_watch git pull --rebase
            mv -f ./repositories/blip ./repositories/BLIP
            sd_webui_branch_file_restore
            term_sd_echo "分支切换完成"
            term_sd_print_line
            ;;
        2)
            term_sd_print_line "$term_sd_manager_info 分支切换"
            term_sd_echo "切换到AUTOMATIC1111/stable-diffusion-webui主分支"
            git remote set-url origin "$github_proxy"https://github.com/AUTOMATIC1111/stable-diffusion-webui
            git submodule deinit --all -f
            term_sd_watch git fetch
            git checkout dev
            term_sd_watch git pull --rebase
            mv -f ./repositories/blip ./repositories/BLIP
            sd_webui_branch_file_restore
            term_sd_echo "分支切换完成"
            term_sd_print_line
            ;;
        3)
            term_sd_print_line "$term_sd_manager_info 分支切换"
            term_sd_echo "切换到vladmandic/SD.NEXT主分支"
            git remote set-url origin "$github_proxy"https://github.com/vladmandic/automatic
            term_sd_watch git fetch --recurse-submodules
            git checkout master
            git submodule init
            git submodule update
            term_sd_watch git pull --rebase --recurse-submodules
            mv -f ./repositories/BLIP ./repositories/blip
            sd_webui_branch_file_restore
            term_sd_echo "分支切换完成"
            term_sd_print_line
            ;;
        4)
            term_sd_print_line "$term_sd_manager_info 分支切换"
            term_sd_echo "切换到vladmandic/SD.NEXT测试分支"
            git remote set-url origin "$github_proxy"https://github.com/vladmandic/automatic
            term_sd_watch git fetch --recurse-submodules
            git checkout dev
            git submodule init
            git submodule update
            term_sd_watch git pull --rebase --recurse-submodules
            mv -f ./repositories/BLIP ./repositories/blip
            sd_webui_branch_file_restore
            term_sd_echo "分支切换完成"
            term_sd_print_line
            ;;
        5)
            term_sd_print_line "$term_sd_manager_info 分支切换"
            term_sd_echo "切换到lshqqytiger/stable-diffusion-webui-directml主分支"
            git remote set-url origin "$github_proxy"https://github.com/lshqqytiger/stable-diffusion-webui-directml
            git submodule deinit --all -f
            term_sd_watch git fetch
            git checkout master
            term_sd_watch git pull --rebase
            mv -f ./repositories/blip ./repositories/BLIP
            sd_webui_branch_file_restore
            term_sd_echo "分支切换完成"
            term_sd_print_line
            ;;
        6)
            term_sd_print_line "$term_sd_manager_info 分支切换"
            term_sd_echo "切换到lshqqytiger/stable-diffusion-webui-directml测试分支"
            git remote set-url origin "$github_proxy"https://github.com/lshqqytiger/stable-diffusion-webui-directml
            git submodule deinit --all -f
            term_sd_watch git fetch
            git checkout dev
            term_sd_watch git pull --rebase
            mv -f ./repositories/blip ./repositories/BLIP
            sd_webui_branch_file_restore
            term_sd_echo "分支切换完成"
            term_sd_print_line
            ;;
    esac

}

# sd-webui分支切换后的重置功能
sd_webui_branch_file_restore()
{
    if [ -d "./repositories" ];then
        cd ./repositories
        for i in ./* ;do
            [ ! -d "./$i/.git" ] && continue # 排除没有.git文件夹的目录
            cd $i
            git reset --recurse-submodules --hard HEAD
            git restore --recurse-submodules --source=HEAD :/
            cd ..
        done
        cd ..
    fi
    rm -rf ./extensions-builtin
    git reset --recurse-submodules --hard HEAD
    git restore --recurse-submodules --source=HEAD :/
}