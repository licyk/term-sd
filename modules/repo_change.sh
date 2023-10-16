#!/bin/bash

#将远程源替换成代理源
function change_repo_to_proxy()
{
    repo_remote_address=$(git remote -v | awk 'NR==1 {print $2}') #获取项目远程地址
    if [ ! -z $(echo $repo_remote_address | grep github.com) ];then #检测到属于github的地址再执行操作
        if [ -z $(echo $repo_remote_address | grep ghproxy.com) ];then
            term_sd_notice "替换$(echo $repo_remote_address | awk -F "/" '{print $NF}' | awk '{sub(".git","")}1')更新源为镜像源"
            repo_remote_address="https://ghproxy.com/$repo_remote_address"
            git remote set-url origin $repo_remote_address
            if [ $? = 0 ];then
                change_repo_return="$change_repo_return $(echo $repo_remote_address | awk -F "/" '{print $NF}' | awk '{sub(".git","")}1')更新源替换成功\n"
            else
                change_repo_return="$change_repo_return $(echo $repo_remote_address | awk -F "/" '{print $NF}' | awk '{sub(".git","")}1')更新源替换失败\n"
            fi
        else
            term_sd_notice "$(echo $repo_remote_address | awk -F "/" '{print $NF}' | awk '{sub(".git","")}1')更新源无需替换"
            change_repo_return="$change_repo_return $(echo $repo_remote_address | awk -F "/" '{print $NF}' | awk '{sub(".git","")}1')更新源无需替换\n"
        fi
    else
        term_sd_notice "$(echo $repo_remote_address | awk -F "/" '{print $NF}' | awk '{sub(".git","")}1')更新源非github地址,不执行替换"
        change_repo_return="$change_repo_return $(echo $repo_remote_address | awk -F "/" '{print $NF}' | awk '{sub(".git","")}1')更新源非github地址,无需替换\n"
    fi
}

#恢复原始的远程源
function change_repo_to_origin()
{
    repo_remote_address=$(git remote -v | awk 'NR==1 {print $2}') #获取项目远程地址
    if [ ! -z $(echo $repo_remote_address | grep github.com) ];then
        if [ ! -z $(echo $repo_remote_address | grep ghproxy.com) ];then
            term_sd_notice "替换$(echo $repo_remote_address | awk -F "/" '{print $NF}' | awk '{sub(".git","")}1')更新源为官方源"
            repo_remote_address=$(echo $repo_remote_address | awk '{sub("https://ghproxy.com/","")}1') #使用awk的替换功能将"https://ghproxy.com/"字段替换成空字符
            git remote set-url origin $repo_remote_address
            if [ $? = 0 ];then
                change_repo_return="$change_repo_return $(echo $repo_remote_address | awk -F "/" '{print $NF}' | awk '{sub(".git","")}1')更新源替换成功\n"
            else
                change_repo_return="$change_repo_return $(echo $repo_remote_address | awk -F "/" '{print $NF}' | awk '{sub(".git","")}1')更新源替换失败\n"
            fi
        else
            term_sd_notice "$(echo $repo_remote_address | awk -F "/" '{print $NF}' | awk '{sub(".git","")}1')更新源无需替换"
            change_repo_return="$change_repo_return $(echo $repo_remote_address | awk -F "/" '{print $NF}' | awk '{sub(".git","")}1')更新源无需替换\n"
        fi
    else
        term_sd_notice "$(echo $repo_remote_address | awk -F "/" '{print $NF}' | awk '{sub(".git","")}1')更新源非github地址,不执行替换"
        change_repo_return="$change_repo_return $(echo $repo_remote_address | awk -F "/" '{print $NF}' | awk '{sub(".git","")}1')更新源非github地址,无需替换\n"
    fi
}

#镜像源选择界面
function select_repo()
{
    select_repo_exec=0
    change_repo_return="" #清除上次运行结果
    if [ $term_sd_manager_info = "stable-diffusion-webui" ];then #设置点击返回时指定返回的界面
        return_dialog_panel="a1111_sd_webui_option"
    elif [ $term_sd_manager_info = "ComfyUI" ];then
        return_dialog_panel="comfyui_option"
    elif [ $term_sd_manager_info = "lora-scripts" ];then
        return_dialog_panel="lora-scripts"
    else
        return_dialog_panel="mainmenu"
    fi

    select_repo_=$(dialog --clear --title "Term-SD" --backtitle "更新源选择界面" --ok-label "确认" --cancel-label "取消" --menu "选择要修改成的更新源\n当前将要修改更新源的AI软件:$term_sd_manager_info" 25 70 10 \
        "1" "官方源" \
        "2" "镜像源" \
        "3" "返回" \
        3>&1 1>&2 2>&3)

    if [ $? = 0 ];then
        if [ $select_repo_ = 1 ];then
            print_line_to_shell "更新源一键替换"
            export change_repo_cmd="change_repo_to_origin"
        elif [ $select_repo_ = 2 ];then
            print_line_to_shell "更新源一键替换"
            export change_repo_cmd="change_repo_to_proxy"
        elif [ $select_repo_ = 3 ];then
            select_repo_exec=1
        fi
    else
        select_repo_exec=1
    fi
}

#镜像源选择界面(针对单个插件/自定义节点),并立即处理
function select_repo_single()
{
    change_repo_return="" #清除上次运行结果
    select_repo_single_=$(dialog --clear --title "Term-SD" --backtitle "更新源选择界面" --ok-label "确认" --cancel-label "取消" --menu "选择要修改成的更新源\n当前更新源:$(git remote -v | awk 'NR==1 {print $2}')" 25 70 10 \
        "1" "官方源" \
        "2" "镜像源" \
        "3" "返回" \
        3>&1 1>&2 2>&3)

    if [ $? = 0 ];then
        if [ $select_repo_single_ = 1 ];then
            change_repo_to_origin
            dialog --clear --title "Term-SD" --backtitle "更新源替换结果" --ok-label "确认" --msgbox "当前更新源替换情况列表\n------------------------------------------------------------------\n$change_repo_return------------------------------------------------------------------" 25 70
        elif [ $select_repo_single_ = 2 ];then
            change_repo_to_proxy
            dialog --clear --title "Term-SD" --backtitle "更新源替换结果" --ok-label "确认" --msgbox "当前更新源替换情况列表\n------------------------------------------------------------------\n$change_repo_return------------------------------------------------------------------" 25 70
        fi
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
        for repositories_folder in ./* ;do
            if [ -d "$repositories_folder/.git" ];then
                cd "./$repositories_folder"
                $change_repo_cmd
                cd - > /dev/null
            fi
        done

        #插件
        cd "$start_path/stable-diffusion-webui/extensions"
        for extension_folder in ./* ;do
            if [ -d "$extension_folder/.git" ];then
                cd "./$extension_folder"
                $change_repo_cmd
                cd - > /dev/null
            fi
        done

        term_sd_notice "替换结束"
        print_line_to_shell
        dialog --clear --title "Term-SD" --backtitle "更新源替换结果" --ok-label "确认" --msgbox "当前更新源替换情况列表\n------------------------------------------------------------------\n$change_repo_return------------------------------------------------------------------" 25 70
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
        for extension_folder in ./* ;do
            if [ -d "$extension_folder" ];then
                if [ -d "$extension_folder/.git" ];then
                    cd "./$extension_folder"
                    $change_repo_cmd
                    cd - > /dev/null
                fi
            fi
        done

        #自定义节点
        cd "$start_path/ComfyUI/custom_nodes"
        for extension_folder in ./* ;do
            if [ -d "$extension_folder" ];then
                if [ -d "$extension_folder/.git" ];then
                    cd "./$extension_folder"
                    $change_repo_cmd
                    cd - > /dev/null
                fi
            fi
        done

        term_sd_notice "替换结束"
        print_line_to_shell
        dialog --clear --title "Term-SD" --backtitle "更新源替换结果" --ok-label "确认" --msgbox "当前更新源替换情况列表\n------------------------------------------------------------------\n$change_repo_return------------------------------------------------------------------" 25 70
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
        dialog --clear --title "Term-SD" --backtitle "更新源替换结果" --ok-label "确认" --msgbox "当前更新源替换情况列表\n------------------------------------------------------------------\n$change_repo_return------------------------------------------------------------------" 25 70
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
        dialog --clear --title "Term-SD" --backtitle "更新源替换结果" --ok-label "确认" --msgbox "当前更新源替换情况列表\n------------------------------------------------------------------\n$change_repo_return------------------------------------------------------------------" 25 70
    fi
}