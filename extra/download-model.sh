#!/bin/bash

# 加载模块
. ./term-sd/modules/term_sd_manager.sh
. ./term-sd/modules/term_sd_task_manager.sh
. ./term-sd/modules/get_modelscope_model.sh
. ./term-sd/modules/install_prepare.sh
. ./term-sd/modules/term_sd_proxy.sh

# 模型选择
sd_model_download_select()
{
    local file_manager_dialog
    local file_manager_select

    while true
    do
        file_manager_dialog=$(dialog --erase-on-exit --notags \
            --title "Term-SD" \
            --backtitle "Term-SD 模型下载" \
            --ok-label "确认" --cancel-label "取消" \
            --menu "请选择需要下载模型的 AI 软件" \
            $term_sd_dialog_height $term_sd_dialog_width $term_sd_dialog_menu_height \
            "1" "> Stable-Diffusion-WebUI" \
            "2" "> ComfyUI" \
            "3" "> InvokeAI" \
            "4" "> Fooocus" \
            "5" "> lora-scripts" \
            "6" "> kohya_ss" \
            "7" "> 退出" \
            3>&1 1>&2 2>&3)

        case $file_manager_dialog in
            1)
                file_manager_select="stable-diffusion-webui"
                ;;
            2)
                file_manager_select="ComfyUI"
                ;;
            3)
                file_manager_select="InvokeAI"
                ;;
            4)
                file_manager_select="Fooocus"
                ;;
            5)
                file_manager_select="lora-scripts"
                ;;
            6)
                file_manager_select="kohya_ss"
                ;;
            7)  
                break
                ;;
            *)
                break
                ;;
        esac
        if [ "$(is_sd_folder_exist "$file_manager_select")" = 0 ];then
            mdoel_download_interface "$file_manager_select"
            break
        else
            dialog --erase-on-exit \
                --title "Term-SD" \
                --backtitle "Term-SD 模型下载" \
                --ok-label "确认" \
                --msgbox "${file_manager_select} 未安装" \
                $term_sd_dialog_height $term_sd_dialog_width
        fi
    done
}

mdoel_download_interface()
{
    local model_download_interface_dialog
    local cmd_sum
    local cmd_point
    local install_cmd

    download_mirror_select # 下载镜像源选择

    model_download_interface_dialog=$(dialog --erase-on-exit --notags \
        --title "Term-SD" \
        --backtitle "${1} 模型下载选项" \
        --ok-label "确认" --no-cancel \
        --checklist "请选择需要下载的 ${1} 模型" \
        $term_sd_dialog_height $term_sd_dialog_width $term_sd_dialog_menu_height \
        $(cat "$start_path"/term-sd/install/$(get_model_list_file_path ${1} dialog) | awk '{sub($3,"OFF")}1') \
        3>&1 1>&2 2>&3)

    term_sd_install_confirm "是否下载 ${1} 模型?" # 安装确认

    if [ $? = 0 ];then
        term_sd_echo "生成任务队列"
        rm -f "$start_path/term-sd/task/model_download.sh" # 删除上次未清除的任务列表
       
        # 代理
        echo "__term_sd_task_sys term_sd_tmp_disable_proxy" >> "$start_path/term-sd/task/model_download.sh"
        echo "__term_sd_task_sys term_sd_tmp_enable_proxy" >> "$start_path/term-sd/task/model_download.sh"

        # 模型
        for i in $model_download_interface_dialog ; do
            cat "$start_path"/term-sd/install/$(get_model_list_file_path ${1}) | grep -w $i >> "$start_path/term-sd/task/model_download.sh"
        done

        term_sd_echo "任务队列生成完成"
        term_sd_echo "开始下载 ${1} 模型"

        cmd_sum=$(cat "$start_path/term-sd/task/model_download.sh" | wc -l)
        for ((cmd_point=1;cmd_point<=cmd_sum;cmd_point++))
        do
            term_sd_echo "${1} 模型下载进度: [$cmd_point/$cmd_sum]"
            install_cmd=$(term_sd_get_task_cmd $(cat "$start_path/term-sd/task/model_download.sh" | awk 'NR=='${cmd_point}'{print$0}'))
            echo "$install_cmd" > "$start_path/term-sd/task/cache.sh" # 取出命令并放入缓存文件中
            term_sd_exec_cmd # 执行命令
        done

        rm -f "$start_path/term-sd/task/model_download.sh" # 删除任务文件
        rm -f "$start_path/term-sd/task/cache.sh"
        term_sd_echo "${1} 模型下载结束"

    else
        term_sd_echo "取消下载模型"
    fi
}

# 获取模型列表路径
get_model_list_file_path()
{
    local sd_name
    local download_source_name

    case ${1} in
        stable-diffusion-webui)
            sd_name="sd_webui"
            ;;
        ComfyUI)
            sd_name="comfyui"
            ;;
        InvokeAI)
            sd_name="invokeai"
            ;;
        Fooocus)
            sd_name="fooocus"
            ;;
        lora-scripts)
            sd_name="lora_scripts"
            ;;
        kohya_ss)
            sd_name="kohya_ss"
            ;;
    esac

    if [ $use_modelscope_model = 1 ];then
        download_source_name="hf"
    else
        download_source_name="ms"
    fi

    if [ ! -z "$2" ] && [ "$2" = "dialog" ];then
        echo "${sd_name}/dialog_${sd_name}_${download_source_name}_model.sh"
    else
        echo "${sd_name}/${sd_name}_${download_source_name}_model.sh"
    fi
}

# 检测文件夹存在
is_sd_folder_exist()
{
    case ${1} in
        stable-diffusion-webui)
            [ -d "$sd_webui_path" ] && echo 0 || echo 1
            ;;
        ComfyUI)
            [ -d "$comfyui_path" ] && echo 0 || echo 1
            ;;
        InvokeAI)
            [ -d "$invokeai_path" ] && echo 0 || echo 1
            ;;
        Fooocus)
            [ -d "$fooocus_path" ] && echo 0 || echo 1
            ;;
        lora-scripts)
            [ -d "$lora_scripts_path" ] && echo 0 || echo 1
            ;;
        kohya_ss)
            [ -d "$kohya_ss_path" ] && echo 0 || echo 1
            ;;
    esac
}


#############################

sd_model_download_select