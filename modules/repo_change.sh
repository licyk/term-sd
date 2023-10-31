#!/bin/bash

#远程源的种类检测
function term_sd_git_remote_test()
{
    git_repo_remote_address=$(git remote -v | awk 'NR==1 {print $2}') #获取项目远程地址
    if [ ! -z $(echo $git_repo_remote_address | grep github.com) ];then #检测远程源的原地址是否属于github地址
        git_repo_remote_change_info=0 #启用替换功能
        if [ ! -z $(echo $git_repo_remote_address | grep ghproxy.com) ];then #检测远程源的地址属于ghproxy.com代理源
            term_sd_git_remote_test_info="github_ghproxy"
        elif [ ! -z $(echo $git_repo_remote_address | grep gitclone.com) ];then #检测远程源的地址属于gitclone.com代理源
            term_sd_git_remote_test_info="github_gitclone"
        else #检测远程源的地址属于github.com源
            term_sd_git_remote_test_info="github"
        fi
    else
        git_repo_remote_change_info=1 #禁用替换功能
        term_sd_git_remote_test_info="other"
    fi
}

#将远程源替换成代理源(ghproxy.com)
function change_repo_to_proxy_ghproxy()
{
    term_sd_git_remote_test #检测远程源的种类(同时获取远程地址git_repo_remote_address)
    if [ $git_repo_remote_change_info = 0 ];then
        case $term_sd_git_remote_test_info in
            github)
                term_sd_notice "替换$(echo $git_repo_remote_address | awk -F "/" '{print $NF}' | awk '{sub(".git","")}1')更新源为代理源(ghproxy.com)"
                git remote set-url origin $(echo $git_repo_remote_address | awk '{sub("https://github.com/","https://ghproxy.com/github.com/")}1')
                if [ $? = 0 ];then
                    change_repo_return="$change_repo_return $(echo $git_repo_remote_address | awk -F "/" '{print $NF}' | awk '{sub(".git","")}1')更新源替换成功\n"
                else
                    change_repo_return="$change_repo_return $(echo $git_repo_remote_address | awk -F "/" '{print $NF}' | awk '{sub(".git","")}1')更新源替换失败\n"
                fi
                ;;
            github_gitclone)
                term_sd_notice "替换$(echo $git_repo_remote_address | awk -F "/" '{print $NF}' | awk '{sub(".git","")}1')更新源为代理源(ghproxy.com)"
                git remote set-url origin $(echo $git_repo_remote_address | awk '{sub("https://gitclone.com/github.com/","https://ghproxy.com/github.com/")}1')
                if [ $? = 0 ];then
                    change_repo_return="$change_repo_return $(echo $git_repo_remote_address | awk -F "/" '{print $NF}' | awk '{sub(".git","")}1')更新源替换成功\n"
                else
                    change_repo_return="$change_repo_return $(echo $git_repo_remote_address | awk -F "/" '{print $NF}' | awk '{sub(".git","")}1')更新源替换失败\n"
                fi
                ;;
            github_ghproxy)
                term_sd_notice "$(echo $git_repo_remote_address | awk -F "/" '{print $NF}' | awk '{sub(".git","")}1')更新源无需替换"
                change_repo_return="$change_repo_return $(echo $git_repo_remote_address | awk -F "/" '{print $NF}' | awk '{sub(".git","")}1')更新源无需替换\n"
                ;;
        esac
    else
        term_sd_notice "$(echo $git_repo_remote_address | awk -F "/" '{print $NF}' | awk '{sub(".git","")}1')更新源非github地址,不执行替换"
        change_repo_return="$change_repo_return $(echo $git_repo_remote_address | awk -F "/" '{print $NF}' | awk '{sub(".git","")}1')更新源非github地址,不执行替换\n"
    fi
}

#将远程源替换成代理源(gitclone.com)
function change_repo_to_proxy_gitclone()
{
    term_sd_git_remote_test #检测远程源的种类(同时获取远程地址git_repo_remote_address)
    if [ $git_repo_remote_change_info = 0 ];then
        case $term_sd_git_remote_test_info in
            github)
                term_sd_notice "替换$(echo $git_repo_remote_address | awk -F "/" '{print $NF}' | awk '{sub(".git","")}1')更新源为代理源(gitclone.com)"
                git remote set-url origin $(echo $git_repo_remote_address | awk '{sub("https://github.com/","https://gitclone.com/github.com/")}1')
                if [ $? = 0 ];then
                    change_repo_return="$change_repo_return $(echo $git_repo_remote_address | awk -F "/" '{print $NF}' | awk '{sub(".git","")}1')更新源替换成功\n"
                else
                    change_repo_return="$change_repo_return $(echo $git_repo_remote_address | awk -F "/" '{print $NF}' | awk '{sub(".git","")}1')更新源替换失败\n"
                fi
                ;;
            github_ghproxy)
                term_sd_notice "替换$(echo $git_repo_remote_address | awk -F "/" '{print $NF}' | awk '{sub(".git","")}1')更新源为代理源(gitclone.com)"
                git remote set-url origin $(echo $git_repo_remote_address | awk '{sub("https://ghproxy.com/github.com/","https://gitclone.com/github.com/")}1')
                if [ $? = 0 ];then
                    change_repo_return="$change_repo_return $(echo $git_repo_remote_address | awk -F "/" '{print $NF}' | awk '{sub(".git","")}1')更新源替换成功\n"
                else
                    change_repo_return="$change_repo_return $(echo $git_repo_remote_address | awk -F "/" '{print $NF}' | awk '{sub(".git","")}1')更新源替换失败\n"
                fi
                ;;
            github_gitclone)
                term_sd_notice "$(echo $git_repo_remote_address | awk -F "/" '{print $NF}' | awk '{sub(".git","")}1')更新源无需替换"
                change_repo_return="$change_repo_return $(echo $git_repo_remote_address | awk -F "/" '{print $NF}' | awk '{sub(".git","")}1')更新源无需替换\n"
                ;;
        esac
    else
        term_sd_notice "$(echo $git_repo_remote_address | awk -F "/" '{print $NF}' | awk '{sub(".git","")}1')更新源非github地址,不执行替换"
        change_repo_return="$change_repo_return $(echo $git_repo_remote_address | awk -F "/" '{print $NF}' | awk '{sub(".git","")}1')更新源非github地址,不执行替换\n"
    fi
}

#恢复原始的远程源
function change_repo_to_origin()
{
    term_sd_git_remote_test #检测远程源的种类(同时获取远程地址git_repo_remote_address)
    if [ $git_repo_remote_change_info = 0 ];then
        case $term_sd_git_remote_test_info in
            github_gitclone|github_ghproxy)
                term_sd_notice "替换$(echo $git_repo_remote_address | awk -F "/" '{print $NF}' | awk '{sub(".git","")}1')更新源为官方源(github.com)"
                git remote set-url origin https://github.com/$(echo $git_repo_remote_address | awk -F "github.com/" '{print $NF}')
                if [ $? = 0 ];then
                    change_repo_return="$change_repo_return $(echo $git_repo_remote_address | awk -F "/" '{print $NF}' | awk '{sub(".git","")}1')更新源替换成功\n"
                else
                    change_repo_return="$change_repo_return $(echo $git_repo_remote_address | awk -F "/" '{print $NF}' | awk '{sub(".git","")}1')更新源替换失败\n"
                fi
                ;;
            github)
                term_sd_notice "$(echo $git_repo_remote_address | awk -F "/" '{print $NF}' | awk '{sub(".git","")}1')更新源无需替换"
                change_repo_return="$change_repo_return $(echo $git_repo_remote_address | awk -F "/" '{print $NF}' | awk '{sub(".git","")}1')更新源无需替换\n"
                ;;
        esac
    else
        term_sd_notice "$(echo $git_repo_remote_address | awk -F "/" '{print $NF}' | awk '{sub(".git","")}1')更新源非github地址,不执行替换"
        change_repo_return="$change_repo_return $(echo $git_repo_remote_address | awk -F "/" '{print $NF}' | awk '{sub(".git","")}1')更新源非github地址,不执行替换\n"
    fi
}

#代理源选择界面
function select_repo()
{
    select_repo_exec=0
    change_repo_return="" #清除上次运行结果

    select_repo_dialog=$(dialog --erase-on-exit --title "Term-SD" --backtitle "更新源选择界面" --ok-label "确认" --cancel-label "取消" --menu "选择要修改成的更新源\n当前将要修改更新源的AI软件:$term_sd_manager_info" 25 80 10 \
        "1" "官方源" \
        "2" "代理源1(ghproxy.com)" \
        "3" "代理源2(gitclone.com)" \
        "4" "返回" \
        3>&1 1>&2 2>&3)

    if [ $? = 0 ];then
        case $select_repo_dialog in
            1)
                print_line_to_shell "更新源一键替换"
                export change_repo_cmd="change_repo_to_origin"
                ;;
            2)
                print_line_to_shell "更新源一键替换"
                export change_repo_cmd="change_repo_to_proxy_ghproxy"
                ;;
            3)
                print_line_to_shell "更新源一键替换"
                export change_repo_cmd="change_repo_to_proxy_gitclone"
                ;;
            4)
                select_repo_exec=1 #不执行替换
                ;;
        esac
    else
        select_repo_exec=1
    fi
}

#代理源选择界面(针对单个插件/自定义节点),并立即处理
function select_repo_single()
{
    change_repo_return="" #清除上次运行结果
    select_repo_single_dialog=$(dialog --erase-on-exit --title "Term-SD" --backtitle "更新源选择界面" --ok-label "确认" --cancel-label "取消" --menu "选择要修改成的更新源\n当前更新源:$(git remote -v | awk 'NR==1 {print $2}')" 25 80 10 \
        "1" "官方源" \
        "2" "代理源1(ghproxy.com)" \
        "3" "代理源2(gitclone.com)" \
        "4" "返回" \
        3>&1 1>&2 2>&3)

    if [ $? = 0 ];then
        case $select_repo_single_dialog in
            1)
                change_repo_to_origin
                dialog --erase-on-exit --title "Term-SD" --backtitle "更新源替换结果" --ok-label "确认" --msgbox "当前更新源替换情况列表\n------------------------------------------------------------------\n$change_repo_return------------------------------------------------------------------" 25 80
                ;;
            2)
                change_repo_to_proxy_ghproxy
                dialog --erase-on-exit --title "Term-SD" --backtitle "更新源替换结果" --ok-label "确认" --msgbox "当前更新源替换情况列表\n------------------------------------------------------------------\n$change_repo_return------------------------------------------------------------------" 25 80
                ;;
            3)
                change_repo_to_proxy_gitclone
                dialog --erase-on-exit --title "Term-SD" --backtitle "更新源替换结果" --ok-label "确认" --msgbox "当前更新源替换情况列表\n------------------------------------------------------------------\n$change_repo_return------------------------------------------------------------------" 25 80
                ;;
        esac
    fi
}

#a1111-sd-webui远程源替换功能
function a1111_sd_webui_change_repo()
{
    select_repo #选择更新源

    if [ $select_repo_exec = 0 ];then
        #执行替换功能
        #主体部分
        $change_repo_cmd

        #组件部分
        cd "$start_path/stable-diffusion-webui/repositories"
        for i in ./* ;do
            if [ -d "$i/.git" ];then
                cd "./$i"
                $change_repo_cmd
                cd - > /dev/null
            fi
        done

        #插件
        cd "$start_path/stable-diffusion-webui/extensions"
        for i in ./* ;do
            if [ -d "$i/.git" ];then
                cd "./$i"
                $change_repo_cmd
                cd - > /dev/null
            fi
        done

        term_sd_notice "替换结束"
        print_line_to_shell
        dialog --erase-on-exit --title "Term-SD" --backtitle "更新源替换结果" --ok-label "确认" --msgbox "当前更新源替换情况列表\n------------------------------------------------------------------\n$change_repo_return------------------------------------------------------------------" 25 80
    fi
}

#ComfyUI远程源替换功能
function comfyui_change_repo()
{
    select_repo #选择更新源

    if [ $select_repo_exec = 0 ];then
        #执行替换功能
        #主体部分
        $change_repo_cmd

        #插件
        cd "$start_path/ComfyUI/web/extensions"
        for i in ./* ;do
            if [ -d "$i" ];then
                if [ -d "$i/.git" ];then
                    cd "./$i"
                    $change_repo_cmd
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
                    $change_repo_cmd
                    cd - > /dev/null
                fi
            fi
        done

        term_sd_notice "替换结束"
        print_line_to_shell
        dialog --erase-on-exit --title "Term-SD" --backtitle "更新源替换结果" --ok-label "确认" --msgbox "当前更新源替换情况列表\n------------------------------------------------------------------\n$change_repo_return------------------------------------------------------------------" 25 80
    fi

}

#lora-scripts远程源替换功能
function lora_scripts_change_repo()
{
    select_repo #选择更新源

    if [ $select_repo_exec = 0 ];then
        $change_repo_cmd
        cd "$start_path/lora-scripts/frontend"
        $change_repo_cmd
        cd "$start_path/lora-scripts/sd-scripts"
        $change_repo_cmd
        term_sd_notice "替换结束"
        print_line_to_shell
        dialog --erase-on-exit --title "Term-SD" --backtitle "更新源替换结果" --ok-label "确认" --msgbox "当前更新源替换情况列表\n------------------------------------------------------------------\n$change_repo_return------------------------------------------------------------------" 25 80
    fi
}

#Fooocus切换更新源功能
function fooocus_change_repo()
{
    select_repo #选择更新源

    if [ $select_repo_exec = 0 ];then
        $change_repo_cmd
        cd "$start_path/Fooocus/repositories/ComfyUI-from-StabilityAI-Official"
        $change_repo_cmd
        term_sd_notice "替换结束"
        print_line_to_shell
        dialog --erase-on-exit --title "Term-SD" --backtitle "更新源替换结果" --ok-label "确认" --msgbox "当前更新源替换情况列表\n------------------------------------------------------------------\n$change_repo_return------------------------------------------------------------------" 25 80
    fi
}