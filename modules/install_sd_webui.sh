#!/bin/bash

# sd-webui安装
install_sd_webui()
{
    local install_cmd
    local cmd_sum
    local cmd_point

    if [ -f "$start_path/term-sd/task/sd_webui_install.sh" ];then # 检测到有未完成的安装任务时直接执行安装任务
        cmd_sum=$(( $(cat "$start_path/term-sd/task/sd_webui_install.sh" | wc -l) + 1 )) # 统计命令行数
        for ((cmd_point=1;cmd_point<=cmd_sum;cmd_point++))
        do
            term_sd_echo "stable-diffusion-webui安装进度:[$cmd_point/$cmd_sum]"
            install_cmd=$(term_sd_get_task_cmd $(cat "$start_path/term-sd/task/sd_webui_install.sh" | awk 'NR=='${cmd_point}'{print$0}'))

            if [ -z "$(echo "$(cat "$start_path/term-sd/task/sd_webui_install.sh" | awk 'NR=='${cmd_point}'{print$0}')" | grep -o __term_sd_task_done_ )" ];then # 检测命令是否需要执行
                echo "$install_cmd" > "$start_path/term-sd/task/cache.sh" # 取出命令并放入缓存文件中
                source "$start_path/term-sd/task/cache.sh" # 执行命令
            else
                true
            fi

            if [ $? = 0 ];then
                term_sd_task_cmd_revise "$start_path/term-sd/task/sd_webui_install.sh" ${cmd_point} # 将执行成功的命令标记为完成
            else
                if [ $term_sd_install_mode = 0 ];then
                    term_sd_echo "安装命令执行失败,终止安装程序"
                    term_sd_tmp_enable_proxy # 恢复代理
                    sleep 5
                    return 1
                else
                    term_sd_echo "忽略执行失败的命令"
                fi
            fi
        done

        term_sd_tmp_enable_proxy # 恢复代理
        term_sd_echo "stable-diffusion-webui安装结束"
        rm -f "$start_path/term-sd/task/sd_webui_install.sh" # 删除任务文件
        rm -f "$start_path/term-sd/task/cache.sh"
        sd_webui_manager # 进入管理界面
    else # 生成安装任务并执行安装任务
        # 安装前的准备
        download_mirror_select auto_github_mirrror # 下载镜像源选择
        pytorch_version_select # pytorch版本选择
        sd_webui_extension_install_select # 插件选择
        pip_install_mode_select # 安装方式选择
        term_sd_install_confirm # 安装确认
        if [ $? = 0 ];then
            term_sd_echo "生成安装任务中"
            term_sd_set_install_env_value >> "$start_path/term-sd/task/sd_webui_install.sh" # 环境变量
            cat "$start_path/term-sd/install/sd_webui/sd_webui_core.md" >> "$start_path/term-sd/task/sd_webui_install.sh" # 核心组件
            for i in $sd_webui_extension_install_select_list ;do
                cat "$start_path/term-sd/install/sd_webui/sd_webui_extension.md" | grep -w $i | awk '{sub(" ON "," ") ; sub(" OFF "," ")}1' >> "$start_path/term-sd/task/sd_webui_install.sh" # 插件
            done

            if [ $use_modelscope_model = 1 ];then
                cat "$start_path/term-sd/install/sd_webui/sd_webui_hf_model.md" >> "$start_path/term-sd/task/sd_webui_install.sh" # 模型
                for i in $sd_webui_extension_install_select_list ;do
                    cat "$start_path/term-sd/install/sd_webui/sd_webui_extension_hf_model.md" | grep -w $i >> "$start_path/term-sd/task/sd_webui_install.sh" # 插件所需的模型
                done
            else
                cat "$start_path/term-sd/install/sd_webui/sd_webui_ms_model.md" >> "$start_path/term-sd/task/sd_webui_install.sh" # 模型
                for i in $sd_webui_extension_install_select_list ;do
                    cat "$start_path/term-sd/install/sd_webui/sd_webui_extension_ms_model.md" | grep -w $i >> "$start_path/term-sd/task/sd_webui_install.sh" # 插件所需的模型
                done
            fi

            term_sd_echo "任务队列生成完成"
            term_sd_echo "开始安装stable-diffusion-webui"

            cmd_sum=$(( $(cat "$start_path/term-sd/task/sd_webui_install.sh" | wc -l) + 1 )) # 统计命令行数
            for ((cmd_point=1;cmd_point<=cmd_sum;cmd_point++))
            do
                term_sd_echo "stable-diffusion-webui安装进度:[$cmd_point/$cmd_sum]"
                install_cmd=$(term_sd_get_task_cmd $(cat "$start_path/term-sd/task/sd_webui_install.sh" | awk 'NR=='${cmd_point}'{print$0}'))
                
                if [ -z "$(echo "$(cat "$start_path/term-sd/task/sd_webui_install.sh" | awk 'NR=='${cmd_point}'{print$0}')" | grep -o __term_sd_task_done_ )" ];then # 检测命令是否需要执行
                    echo "$install_cmd" > "$start_path/term-sd/task/cache.sh" # 取出命令并放入缓存文件中
                    source "$start_path/term-sd/task/cache.sh" # 执行命令
                else
                    true
                fi

                if [ $? = 0 ];then
                    term_sd_task_cmd_revise "$start_path/term-sd/task/sd_webui_install.sh" ${cmd_point} # 将执行成功的命令标记为完成
                else
                    if [ $term_sd_install_mode = 0 ];then
                        term_sd_echo "安装命令执行失败,终止安装程序"
                        term_sd_tmp_enable_proxy # 恢复代理
                        sleep 5
                        return 1
                    else
                        term_sd_echo "忽略执行失败的命令"
                    fi
                fi
            done

            term_sd_tmp_enable_proxy # 恢复代理
            term_sd_echo "stable-diffusion-webui安装结束"
            rm -f "$start_path/term-sd/task/sd_webui_install.sh" # 删除任务文件
            rm -f "$start_path/term-sd/task/cache.sh"
            sd_webui_manager # 进入管理界面
        fi
    fi
}

# 插件选择
sd_webui_extension_install_select()
{
    sd_webui_extension_install_select_list=$(
        dialog --erase-on-exit --notags --title "Stable-Diffusion-WebUI安装" --backtitle "Stable-Diffusion-WebUI插件安装选项" --ok-label "确认" --cancel-label "取消" --checklist "请选择需要安装的Stable-Diffusion-Webui插件" 25 80 10 \
        $(cat "$start_path/term-sd/install/sd_webui/dialog_sd_webui_extension.md") \
        3>&1 1>&2 2>&3)
}