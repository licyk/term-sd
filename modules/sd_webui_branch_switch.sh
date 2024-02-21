#!/bin/bash

# sd-webui分支切换功能
sd_webui_branch_switch()
{
    local sd_webui_branch_info
    local sd_webui_branch_switch_dialog

    case $(git remote -v | awk 'NR==1 {print $2}' | awk -F'/' '{print $NF}') in # 分支判断
        stable-diffusion-webui|stable-diffusion-webui.git)
            sd_webui_branch_info="AUTOMATIC1111 webui $(git_branch_display)"
            ;;
        automatic|automatic.git)
            sd_webui_branch_info="vladmandic webui $(git_branch_display)"
            ;;
        stable-diffusion-webui-directml|stable-diffusion-webui-directml.git)
            sd_webui_branch_info="lshqqytiger webui $(git_branch_display)"
            ;;
        stable-diffusion-webui-forge|stable-diffusion-webui-forge.git)
            sd_webui_branch_info="lshqqytiger webui $(git_branch_display)"
            ;;
        *)
            dialog --erase-on-exit --title "Stable-Diffusion-WebUI管理" --backtitle "Stable-Diffusion-WebUI更新结果" --ok-label "确认" --msgbox "Stable-Diffusion-WebUI非git安装,无法切换分支" $term_sd_dialog_height $term_sd_dialog_width
            return 10
            ;;
    esac

    download_mirror_select # 切换前选择github源
    sd_webui_branch_switch_dialog=$(
        dialog --erase-on-exit --notags --title "Stable-Diffusion-WebUI管理" --backtitle "Stable-Diffusion-WebUI分支切换选项" --ok-label "确认" --cancel-label "取消" --menu "请选择要切换的Stable-Diffusion-WebUI分支\n当前更新源:$(git_remote_display)\n当前分支:$sd_webui_branch_info" $term_sd_dialog_height $term_sd_dialog_width $term_sd_dialog_menu_height \
            "0" "> 返回" \
            "1" "> AUTOMATIC1111/Stable-Diffusion-WebUI主分支" \
            "2" "> AUTOMATIC1111/Stable-Diffusion-WebUI测试分支" \
            "3" "> vladmandic/SD.NEXT主分支" \
            "4" "> vladmandic/SD.NEXT测试分支" \
            "5" "> lshqqytiger/Stable-Diffusion-WebUI-DirectML主分支" \
            "6" "> lshqqytiger/Stable-Diffusion-WebUI-DirectML测试分支" \
            "7" "> lllyasviel/stable-diffusion-webui-forge分支" \
            3>&1 1>&2 2>&3)
    
    case $sd_webui_branch_switch_dialog in
        1)
            term_sd_print_line "$term_sd_manager_info 分支切换"
            term_sd_echo "切换到AUTOMATIC1111/Stable-Diffusion-WebUI主分支"
            git remote set-url origin $(git_format_repository_url $github_mirror https://github.com/AUTOMATIC1111/stable-diffusion-webui)
            git submodule deinit --all -f
            term_sd_watch git fetch
            git checkout master
            term_sd_watch git pull --rebase
            mv -f repositories/blip repositories/BLIP
            sd_webui_branch_file_restore
            term_sd_echo "分支切换完成"
            term_sd_pause
            ;;
        2)
            term_sd_print_line "$term_sd_manager_info 分支切换"
            term_sd_echo "切换到AUTOMATIC1111/Stable-Diffusion-WebUI主分支"
            git remote set-url origin $(git_format_repository_url $github_mirror https://github.com/AUTOMATIC1111/stable-diffusion-webui)
            git submodule deinit --all -f
            term_sd_watch git fetch
            git checkout dev
            term_sd_watch git pull --rebase
            mv -f repositories/blip repositories/BLIP
            sd_webui_branch_file_restore
            term_sd_echo "分支切换完成"
            term_sd_pause
            ;;
        3)
            term_sd_print_line "$term_sd_manager_info 分支切换"
            term_sd_echo "切换到vladmandic/SD.NEXT主分支"
            git remote set-url origin $(git_format_repository_url $github_mirror https://github.com/vladmandic/automatic)
            term_sd_watch git fetch --recurse-submodules
            git checkout master
            git submodule init
            term_sd_watch git submodule update
            term_sd_watch git pull --rebase --recurse-submodules
            git submodule init
            term_sd_watch git pull --recurse-submodules
            mv -f repositories/BLIP repositories/blip
            sd_webui_branch_file_restore sd_next
            term_sd_echo "分支切换完成"
            term_sd_pause
            ;;
        4)
            term_sd_print_line "$term_sd_manager_info 分支切换"
            term_sd_echo "切换到vladmandic/SD.NEXT测试分支"
            git remote set-url origin $(git_format_repository_url $github_mirror https://github.com/vladmandic/automatic)
            term_sd_watch git fetch --recurse-submodules
            git checkout dev
            git submodule init
            term_sd_watch git submodule update
            term_sd_watch git pull --rebase --recurse-submodules
            git submodule init
            term_sd_watch git pull --recurse-submodules
            mv -f repositories/BLIP repositories/blip
            sd_webui_branch_file_restore sd_next
            term_sd_echo "分支切换完成"
            term_sd_pause
            ;;
        5)
            term_sd_print_line "$term_sd_manager_info 分支切换"
            term_sd_echo "切换到lshqqytiger/Stable-Diffusion-WebUI-DirectML主分支"
            git remote set-url origin $(git_format_repository_url $github_mirror https://github.com/lshqqytiger/stable-diffusion-webui-directml)
            git submodule deinit --all -f
            term_sd_watch git fetch
            git checkout master
            term_sd_watch git pull --rebase
            mv -f repositories/blip repositories/BLIP
            sd_webui_branch_file_restore
            term_sd_echo "分支切换完成"
            term_sd_pause
            ;;
        6)
            term_sd_print_line "$term_sd_manager_info 分支切换"
            term_sd_echo "切换到lshqqytiger/Stable-Diffusion-WebUI-DirectML测试分支"
            git remote set-url origin $(git_format_repository_url $github_mirror https://github.com/lshqqytiger/stable-diffusion-webui-directml)
            git submodule deinit --all -f
            term_sd_watch git fetch
            git checkout dev
            term_sd_watch git pull --rebase
            mv -f repositories/blip repositories/BLIP
            sd_webui_branch_file_restore
            term_sd_echo "分支切换完成"
            term_sd_pause
            ;;
        7)
            term_sd_print_line "$term_sd_manager_info 分支切换"
            term_sd_echo "切换到lllyasviel/stable-diffusion-webui-forge分支"
            git remote set-url origin $(git_format_repository_url $github_mirror https://github.com/lllyasviel/stable-diffusion-webui-forge)
            git submodule deinit --all -f
            term_sd_watch git fetch
            git checkout main
            term_sd_watch git pull --rebase
            mv -f repositories/blip repositories/BLIP
            sd_webui_branch_file_restore
            term_sd_echo "分支切换完成"
            term_sd_pause
            ;;
    esac

}

# sd-webui分支切换后的重置功能
sd_webui_branch_file_restore()
{
    if [ -d "repositories" ];then
        cd repositories
        for i in * ;do
            [ ! -d "$i/.git" ] && continue # 排除没有.git文件夹的目录
            cd $i
            git reset --recurse-submodules --hard HEAD
            git restore --recurse-submodules --source=HEAD :/
            cd ..
        done
        cd ..
    fi
    case $1 in
        sd_next)
            ;;
        *)
            rm -rf extensions-builtin
            ;;
    esac
    git reset --recurse-submodules --hard HEAD
    git restore --recurse-submodules --source=HEAD :/
}
