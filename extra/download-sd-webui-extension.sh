#!/bin/bash

source ./term-sd/modules/install_prepare.sh
source ./term-sd/modules/get_modelscope_model.sh
source ./term-sd/modules/term_sd_git.sh
source ./term-sd/modules/term_sd_task_manager.sh
source ./term-sd/modules/term_sd_manager.sh
source ./term-sd/modules/term_sd_proxy.sh

install_sd_webui_extension()
{
    [ -f "$start_path/term-sd/task/sd_webui_install_extension.sh" ] && rm -f "$start_path/term-sd/task/sd_webui_install_extension.sh"
    download_mirror_select auto_github_mirrror # 下载镜像源选择
    sd_webui_extension_install_select_list=$(
        dialog --erase-on-exit --notags --title "Stable-Diffusion-WebUI安装" --backtitle "Stable-Diffusion-WebUI插件安装选项" --ok-label "确认" --no-cancel --checklist "请选择需要安装的Stable-Diffusion-Webui插件" $term_sd_dialog_height $term_sd_dialog_width $term_sd_dialog_menu_height \
        $(cat "$start_path/term-sd/install/sd_webui/dialog_sd_webui_extension.sh" | awk '{gsub(" ON"," OFF")}1') \
        3>&1 1>&2 2>&3)
    term_sd_install_confirm # 安装确认
    if [ $? = 0 ];then
        term_sd_echo "生成任务队列"
        touch "$start_path/term-sd/task/sd_webui_install_extension.sh"
        for i in $sd_webui_extension_install_select_list ;do
            cat "$start_path/term-sd/install/sd_webui/sd_webui_extension.sh" | grep -w $i | awk '{sub(" ON "," ") ; sub(" OFF "," ")}1' >> "$start_path/term-sd/task/sd_webui_install_extension.sh" # 插件
        done

        if [ $use_modelscope_model = 1 ];then
            for i in $sd_webui_extension_install_select_list ;do
                cat "$start_path/term-sd/install/sd_webui/sd_webui_extension_hf_model.sh" | grep -w $i >> "$start_path/term-sd/task/sd_webui_install_extension.sh" # 插件所需的模型
            done
        else
            for i in $sd_webui_extension_install_select_list ;do
                cat "$start_path/term-sd/install/sd_webui/sd_webui_extension_ms_model.sh" | grep -w $i >> "$start_path/term-sd/task/sd_webui_install_extension.sh" # 插件所需的模型
            done
        fi

        term_sd_echo "任务队列生成完成"
        term_sd_echo "开始下载stable-diffusion-webui插件"
        cmd_sum=$(( $(cat "$start_path/term-sd/task/sd_webui_install_extension.sh" | wc -l) + 1 )) # 统计命令行数
        for ((cmd_point=1;cmd_point<=cmd_sum;cmd_point++))
        do
            term_sd_echo "stable-diffusion-webui安装进度:[$cmd_point/$cmd_sum]"
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
            term_sd_echo "stable-diffusion-webui插件下载结束"
            rm -f "$start_path/term-sd/task/sd_webui_install_extension.sh" # 删除任务文件
            rm -f "$start_path/term-sd/task/cache.sh"
    else
        term_sd_echo "取消下载stable-diffusion-webui插件"
    fi
}

if [ -d "./stable-diffusion-webui" ];then
    install_sd_webui_extension
else
    term_sd_echo "未安装stable-diffusion-webui"
fi