#!/bin/bash

. ./term-sd/modules/install_prepare.sh
. ./term-sd/modules/get_modelscope_model.sh
. ./term-sd/modules/term_sd_git.sh
. ./term-sd/modules/term_sd_task_manager.sh
. ./term-sd/modules/term_sd_manager.sh
. ./term-sd/modules/term_sd_proxy.sh

install_sd_webui_extension()
{
    [ -f "$start_path/term-sd/task/sd_webui_install_extension.sh" ] && rm -f "$start_path/term-sd/task/sd_webui_install_extension.sh"
    download_mirror_select auto_github_mirrror # 下载镜像源选择
    
    sd_webui_extension_install_select_list=$(dialog --erase-on-exit --notags \
        --title "Stable-Diffusion-WebUI 安装" \
        --backtitle "Stable-Diffusion-WebUI 插件安装选项" \
        --ok-label "确认" --no-cancel \
        --checklist "请选择需要安装的 Stable-Diffusion-WebUI 插件" \
        $term_sd_dialog_height $term_sd_dialog_width $term_sd_dialog_menu_height \
        $(cat "$start_path/term-sd/install/sd_webui/dialog_sd_webui_extension.sh" | awk '{sub($3,"OFF")}1') \
        3>&1 1>&2 2>&3)

    # 插件模型列表选择
    if [ $use_modelscope_model = 0 ];then
        sd_webui_extension_model_list_file="sd_webui_extension_ms_model.sh"
    else
        sd_webui_extension_model_list_file="sd_webui_extension_hf_model.sh"
    fi

    term_sd_echo "生成模型选择列表中"
    # 查找插件对应模型的编号
    for i in $sd_webui_extension_install_select_list
    do
        sd_webui_extension_model_list="$sd_webui_extension_model_list $(cat "$start_path"/term-sd/install/sd_webui/$sd_webui_extension_model_list_file | grep -w $i | awk 'NR==1{if ($NF!="") {print $1 " " $(NF-1) " " $NF} }')"
    done

    # 模型选择(包含基础模型和插件的模型)
    if [ ! -z "$sd_webui_extension_model_list" ];then
        sd_webui_download_model_select_list=$(dialog --erase-on-exit --notags \
            --title "Stable-Diffusion-WebUI 安装" \
            --backtitle "Stable-Diffusion-WebUI 插件模型下载选项" \
            --ok-label "确认" --no-cancel \
            --checklist "请选择需要下载的 Stable-Diffusion-WebUI 模型" \
            $term_sd_dialog_height $term_sd_dialog_width $term_sd_dialog_menu_height \
            $sd_webui_extension_model_list \
            3>&1 1>&2 2>&3)
    else
        term_sd_echo "无可选扩展的模型, 跳过模型选择"
    fi

    term_sd_install_confirm "是否安装 Stable-Diffusion-WebUI 插件?" # 安装确认
    if [ $? = 0 ];then
        term_sd_echo "生成任务队列"
        touch "$start_path/term-sd/task/sd_webui_install_extension.sh"
        for i in $sd_webui_extension_install_select_list ;do
            cat "$start_path/term-sd/install/sd_webui/sd_webui_extension.sh" | grep -w $i | awk '{sub(" ON "," ") ; sub(" OFF "," ")}1' >> "$start_path/term-sd/task/sd_webui_install_extension.sh" # 插件
        done

        if [ $use_modelscope_model = 1 ];then
            for i in $sd_webui_download_model_select_list ;do
                cat "$start_path/term-sd/install/sd_webui/sd_webui_extension_hf_model.sh" | grep -w $i >> "$start_path/term-sd/task/sd_webui_install_extension.sh" # 插件所需的模型
            done
        else
            for i in $sd_webui_download_model_select_list ;do
                cat "$start_path/term-sd/install/sd_webui/sd_webui_extension_ms_model.sh" | grep -w $i >> "$start_path/term-sd/task/sd_webui_install_extension.sh" # 插件所需的模型
            done
        fi

        term_sd_echo "任务队列生成完成"
        term_sd_echo "开始下载 Stable-Diffusion-WebUI 插件"
        cmd_sum=$(( $(cat "$start_path/term-sd/task/sd_webui_install_extension.sh" | wc -l) + 1 )) # 统计命令行数
        for ((cmd_point=1;cmd_point<=cmd_sum;cmd_point++))
        do
            term_sd_echo "Stable-Diffusion-WebUI 安装进度: [$cmd_point/$cmd_sum]"
            install_cmd=$(term_sd_get_task_cmd $(cat "$start_path/term-sd/task/sd_webui_install_extension.sh" | awk 'NR=='${cmd_point}'{print$0}'))

            if [ -z "$(echo "$(cat "$start_path/term-sd/task/sd_webui_install_extension.sh" | awk 'NR=='${cmd_point}'{print$0}')" | grep -o __term_sd_task_done_ )" ];then # 检测命令是否需要执行
                echo "$install_cmd" > "$start_path/term-sd/task/cache.sh" # 取出命令并放入缓存文件中
                [ $term_sd_debug_mode = 0 ] && term_sd_echo "执行命令: \"$install_cmd\""
                term_sd_exec_cmd # 执行命令
            else
                [ $term_sd_debug_mode = 0 ] && term_sd_echo "跳过执行命令: \"$install_cmd\""
                true
            fi

            done

            term_sd_tmp_enable_proxy # 恢复代理
            term_sd_echo "Stable-Diffusion-WebUI 插件下载结束"
            rm -f "$start_path/term-sd/task/sd_webui_install_extension.sh" # 删除任务文件
            rm -f "$start_path/term-sd/task/cache.sh"
    else
        term_sd_echo "取消下载 Stable-Diffusion-WebUI 插件"
    fi
}

# 模型选择
sd_webui_download_model_select()
{
    local sd_webui_extension_model_list_file
    local sd_webui_extension_model_list
    # 插件模型列表选择
    if [ $use_modelscope_model = 0 ];then
        sd_webui_extension_model_list_file="sd_webui_extension_ms_model.sh"
    else
        sd_webui_extension_model_list_file="sd_webui_extension_hf_model.sh"
    fi

    term_sd_echo "生成模型选择列表中"
    # 查找插件对应模型的编号
    for i in $sd_webui_extension_install_select_list
    do
        sd_webui_extension_model_list="$sd_webui_extension_model_list $(cat "$start_path"/term-sd/install/sd_webui/$sd_webui_extension_model_list_file | grep -w $i | awk 'NR==1{if ($NF!="") {print $1 " " $(NF-1) " " $NF} }')"
    done

    # 模型选择(包含基础模型和插件的模型)
    sd_webui_download_model_select_list=$(dialog --erase-on-exit --notags \
        --title "Stable-Diffusion-WebUI 安装" \
        --backtitle "Stable-Diffusion-WebUI 模型下载选项" \
        --ok-label "确认" --no-cancel \
        --checklist "请选择需要下载的 Stable-Diffusion-WebUI 模型" \
        $term_sd_dialog_height $term_sd_dialog_width $term_sd_dialog_menu_height \
        $sd_webui_extension_model_list \
        3>&1 1>&2 2>&3)
}

if [ -d "$sd_webui_path" ];then
    install_sd_webui_extension
else
    term_sd_echo "未安装 Stable-Diffusion-WebUI"
fi