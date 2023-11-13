#!/bin/bash

# 远程源的种类检测
git_remote_type_test()
{
    if [ ! -z "$(git remote -v | awk 'NR==1 {print $2}' | grep github.com)" ];then #检测远程源的原地址是否属于github地址
        echo "github"
    else
        echo "other"
    fi
}

# 修改远程源(先判断远程源是否符合修改要求)
# 使用格式: git_repo_remote_revise <链接格式>
git_repo_remote_revise()
{
    local git_repo_name
    git_repo_name=$(git remote -v | awk 'NR==1 {print $2}' | awk -F '/' '{print $NF}' | awk '{sub(".git","")}1') # 获取项目名称
    if [ "$(git_remote_type_test)" = "github" ];then # 判断远程源种类
        git_repository_remote_revise $1 # 执行远程源替换
        if [ $? = 0 ];then
            term_sd_echo "替换${git_repo_name}源为$(echo $1 | awk '{sub("https://","") ; gsub(/\//," ")}1' | awk '{print$1}')源"
            git_repo_remote_revise_req="$git_repo_remote_revise_req ${git_repo_name}更新源替换成功\n"
        else
            true
            term_sd_echo "${git_repo_name}更新源无需替换"
            git_repo_remote_revise_req="$git_repo_remote_revise_req ${git_repo_name}更新源无需替换\n"
        fi
    else
        true
        term_sd_echo "${git_repo_name}更新源非github地址,不执行替换"
        git_repo_remote_revise_req="$git_repo_remote_revise_req ${git_repo_name}更新源非github地址,不执行替换\n"
    fi
}

# git远程源选择
git_remote_url_select()
{
    local git_remote_url_select_dialog
    export git_repo_remote_revise_cmd
    git_repo_remote_revise_req= # 清除运行结果

    git_remote_url_select_dialog=$(
        dialog --erase-on-exit --notags --title "Term-SD" --backtitle "更新源选择界面" --ok-label "确认" --cancel-label "取消" --menu "选择要修改成的更新源\n当前将要修改更新源的AI软件:$term_sd_manager_info" 25 80 10 \
        "0" "> 返回" \
        "1" "> 官方源(github.com)" \
        "2" "> 代理源1(ghproxy.com)" \
        "3" "> 代理源2(gitclone.com)" \
        "4" "> 代理源3(gh-proxy.com)" \
        "5" "> 代理源4(ghps.cc)" \
        "6" "> 代理源5(gh.idayer.com)" \
        3>&1 1>&2 2>&3)

    case $git_remote_url_select_dialog in
        1)
            term_sd_print_line "更新源一键替换"
            git_repo_remote_revise_cmd="git_repo_remote_revise https://github.com/term_sd_git_user/term_sd_git_repo"
            return 0
            ;;
        2)
            term_sd_print_line "更新源一键替换"
            git_repo_remote_revise_cmd="git_repo_remote_revise https://ghproxy.com/https://github.com/term_sd_git_user/term_sd_git_repo"
            return 0
            ;;
        3)
            term_sd_print_line "更新源一键替换"
            git_repo_remote_revise_cmd="git_repo_remote_revise https://gitclone.com/github.com/term_sd_git_user/term_sd_git_repo"
            return 0
            ;;
        4)
            term_sd_print_line "更新源一键替换"
            git_repo_remote_revise_cmd="git_repo_remote_revise https://gh-proxy.com/https://github.com/term_sd_git_user/term_sd_git_repo"
            return 0
            ;;
        5)
            term_sd_print_line "更新源一键替换"
            git_repo_remote_revise_cmd="git_repo_remote_revise https://ghps.cc/https://github.com/term_sd_git_user/term_sd_git_repo"
            return 0
            ;;
        6)
            term_sd_print_line "更新源一键替换"
            git_repo_remote_revise_cmd="git_repo_remote_revise https://gh.idayer.com/https://github.com/term_sd_git_user/term_sd_git_repo"
            return 0
            ;;
        *)
            term_sd_echo "取消替换更新源操作"
            return 1 #不执行替换
            ;;
    esac
}

# git远程源选择(针对单个插件/自定义节点)
git_remote_url_select_single()
{
    if [ -d "./.git" ];then # 检测目录中是否有.git文件夹
        local git_remote_url_select_single_dialog
        git_repo_remote_revise_req= # 清除运行结果

        git_remote_url_select_single_dialog=$(
            dialog --erase-on-exit --notags --title "Term-SD" --backtitle "更新源选择界面" --ok-label "确认" --cancel-label "取消" --menu "选择要修改成的更新源\n当前更新源:$(git remote -v | awk 'NR==1 {print $2}')" 25 80 10 \
            "0" "> 返回" \
            "1" "> 官方源(github.com)" \
            "2" "> 代理源1(ghproxy.com)" \
            "3" "> 代理源2(gitclone.com)" \
            "4" "> 代理源3(gh-proxy.com)" \
            "5" "> 代理源4(ghps.cc)" \
            "6" "> 代理源5(gh.idayer.com)" \
            3>&1 1>&2 2>&3)

        case $git_remote_url_select_single_dialog in
            1)
                git_repo_remote_revise https://github.com/term_sd_git_user/term_sd_git_repo
                dialog --erase-on-exit --title "Term-SD" --backtitle "更新源替换结果" --ok-label "确认" --msgbox "当前更新源替换情况列表\n------------------------------------------------------------------\n$git_repo_remote_revise_req------------------------------------------------------------------" 25 80
                ;;
            2)
                git_repo_remote_revise https://ghproxy.com/https://github.com/term_sd_git_user/term_sd_git_repo
                dialog --erase-on-exit --title "Term-SD" --backtitle "更新源替换结果" --ok-label "确认" --msgbox "当前更新源替换情况列表\n------------------------------------------------------------------\n$git_repo_remote_revise_req------------------------------------------------------------------" 25 80
                ;;
            3)
                git_repo_remote_revise https://gitclone.com/github.com/term_sd_git_user/term_sd_git_repo
                dialog --erase-on-exit --title "Term-SD" --backtitle "更新源替换结果" --ok-label "确认" --msgbox "当前更新源替换情况列表\n------------------------------------------------------------------\n$git_repo_remote_revise_req------------------------------------------------------------------" 25 80
                ;;
            4)
                git_repo_remote_revise https://gh-proxy.com/https://github.com/term_sd_git_user/term_sd_git_repo
                dialog --erase-on-exit --title "Term-SD" --backtitle "更新源替换结果" --ok-label "确认" --msgbox "当前更新源替换情况列表\n------------------------------------------------------------------\n$git_repo_remote_revise_req------------------------------------------------------------------" 25 80
                ;;
            5)
                git_repo_remote_revise https://ghps.cc/https://github.com/term_sd_git_user/term_sd_git_repo
                dialog --erase-on-exit --title "Term-SD" --backtitle "更新源替换结果" --ok-label "确认" --msgbox "当前更新源替换情况列表\n------------------------------------------------------------------\n$git_repo_remote_revise_req------------------------------------------------------------------" 25 80
                ;;
            6)
                git_repo_remote_revise https://gh.idayer.com/https://github.com/term_sd_git_user/term_sd_git_repo
                dialog --erase-on-exit --title "Term-SD" --backtitle "更新源替换结果" --ok-label "确认" --msgbox "当前更新源替换情况列表\n------------------------------------------------------------------\n$git_repo_remote_revise_req------------------------------------------------------------------" 25 80
                ;;
            *)
                term_sd_echo "取消替换更新源操作"
                ;;
        esac
    else
        term_sd_echo "$(git remote -v | awk 'NR==1 {print $2}' | awk -F "/" '{print $NF}' | awk '{sub(".git","")}1')非git安装,无法切换更新源"
        return 10
    fi
}

# sd-webui远程源替换
sd_webui_remote_revise()
{
    git_remote_url_select # 选择更新源

    if [ $? = 0 ];then
        term_sd_echo "开始替换stable-diffusion-webui更新源"
        # 执行替换功能
        # 主体部分
        $git_repo_remote_revise_cmd

        # 组件部分
        cd "$start_path/stable-diffusion-webui/repositories"
        for i in ./* ;do
            if [ -d "$i/.git" ];then
                cd "./$i"
                $git_repo_remote_revise_cmd
                cd - > /dev/null
            fi
        done

        # 插件部分
        cd "$start_path/stable-diffusion-webui/extensions"
        for i in ./* ;do
            if [ -d "$i/.git" ];then
                cd "./$i"
                $git_repo_remote_revise_cmd
                cd - > /dev/null
            fi
        done

        term_sd_echo "stable-diffusion-webui更新源替换结束"
        term_sd_print_line
        dialog --erase-on-exit --title "Term-SD" --backtitle "更新源替换结果" --ok-label "确认" --msgbox "当前更新源替换情况列表\n------------------------------------------------------------------\n$git_repo_remote_revise_req------------------------------------------------------------------" 25 80
    fi
}

# ComfyUI远程源替换功能
comfyui_remote_revise()
{
    git_remote_url_select #选择更新源

    if [ $? = 0 ];then
        term_sd_echo "开始替换ComfyUI更新源"
        #执行替换功能
        #主体部分
        $git_repo_remote_revise_cmd

        #插件
        cd "$start_path/ComfyUI/web/extensions"
        for i in ./* ;do
            if [ -d "$i" ];then
                if [ -d "$i/.git" ];then
                    cd "./$i"
                    $git_repo_remote_revise_cmd
                    cd - > /dev/null
                fi
            fi
        done

        #自定义节点
        cd "$start_path/ComfyUI/custom_nodes"
        for i in ./* ;do
            if [ -d "$i" ];then
                if [ -d "$i/.git" ];then
                    cd "./$i"
                    $git_repo_remote_revise_cmd
                    cd - > /dev/null
                fi
            fi
        done

        term_sd_echo "ComfyUI更新源替换结束"
        term_sd_print_line
        dialog --erase-on-exit --title "Term-SD" --backtitle "更新源替换结果" --ok-label "确认" --msgbox "当前更新源替换情况列表\n------------------------------------------------------------------\n$git_repo_remote_revise_req------------------------------------------------------------------" 25 80
    fi

}

#lora-scripts远程源替换功能
lora_scripts_remote_revise()
{
    git_remote_url_select #选择更新源

    if [ $? = 0 ];then
        term_sd_echo "开始替换lora-scripts更新源"
        $git_repo_remote_revise_cmd
        cd "$start_path/lora-scripts/frontend"
        $git_repo_remote_revise_cmd
        cd "$start_path/lora-scripts/sd-scripts"
        $git_repo_remote_revise_cmd
        term_sd_echo "lora-scripts更新源替换结束"
        term_sd_print_line
        dialog --erase-on-exit --title "Term-SD" --backtitle "更新源替换结果" --ok-label "确认" --msgbox "当前更新源替换情况列表\n------------------------------------------------------------------\n$git_repo_remote_revise_req------------------------------------------------------------------" 25 80
    fi
}

#Fooocus切换更新源功能
fooocus_remote_revise()
{
    git_remote_url_select #选择更新源

    if [ $? = 0 ];then
        term_sd_echo "开始替换Fooocus更新源"
        $git_repo_remote_revise_cmd
        cd "$start_path/Fooocus/repositories/ComfyUI-from-StabilityAI-Official"
        $git_repo_remote_revise_cmd
        term_sd_echo "Fooocus更新源替换结束"
        term_sd_print_line
        dialog --erase-on-exit --title "Term-SD" --backtitle "更新源替换结果" --ok-label "确认" --msgbox "当前更新源替换情况列表\n------------------------------------------------------------------\n$git_repo_remote_revise_req------------------------------------------------------------------" 25 80
    fi
}