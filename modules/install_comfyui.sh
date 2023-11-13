#!/bin/bash

install_comfyui()
{
    local install_cmd
    local cmd_sum
    local cmd_point

    if [ -f "$start_path/term-sd/task/comfyui_install.sh" ];then # 检测到有未完成的安装任务时直接执行安装任务
        cmd_sum=$(( $(cat "$start_path/term-sd/task/comfyui_install.sh" | wc -l) + 1 )) # 统计命令行数
        for ((cmd_point=1;cmd_point<=cmd_sum;cmd_point++))
        do
            term_sd_echo "ComfyUI安装进度:[$cmd_point/$cmd_sum]"
            install_cmd=$(term_sd_get_task_cmd $(cat "$start_path/term-sd/task/comfyui_install.sh" | awk 'NR=='${cmd_point}'{print$0}'))

            if [ -z "$(echo "$(cat "$start_path/term-sd/task/comfyui_install.sh" | awk 'NR=='${cmd_point}'{print$0}')" | grep -o __term_sd_task_done_ )" ];then # 检测命令是否需要执行
                echo "$install_cmd" > "$start_path/term-sd/task/cache.sh" # 取出命令并放入缓存文件中
                [ $term_sd_debug_mode = 0 ] && term_sd_echo "执行命令: \"$install_cmd\""
                source "$start_path/term-sd/task/cache.sh" # 执行命令
            else
                [ $term_sd_debug_mode = 0 ] && term_sd_echo "跳过执行命令: \"$install_cmd\""
                true
            fi

            if [ $? = 0 ];then
                term_sd_task_cmd_revise "$start_path/term-sd/task/comfyui_install.sh" ${cmd_point} # 将执行成功的命令标记为完成
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
        term_sd_echo "ComfyUI安装结束"
        rm -f "$start_path/term-sd/task/comfyui_install.sh" # 删除任务文件
        rm -f "$start_path/term-sd/task/cache.sh"
        comfyui_manager # 进入管理界面
    else
        # 安装前的准备
        download_mirror_select auto_github_mirrror # 下载镜像源选择
        pytorch_version_select # pytorch版本选择
        comfyui_extension_install_select # 插件选择
        comfyui_custom_node_install_select # 自定义节点选择
        pip_install_mode_select # 安装方式选择
        term_sd_install_confirm # 安装确认
        if [ $? = 0 ];then
            term_sd_echo "生成安装任务中"
            term_sd_set_install_env_value >> "$start_path/term-sd/task/comfyui_install.sh" # 环境变量
            cat "$start_path/term-sd/install/comfyui/comfyui_core.md" >> "$start_path/term-sd/task/comfyui_install.sh" # 核心组件
            [ ! -z "$comfyui_extension_install_select_list" ] && echo "" >> "$start_path/term-sd/task/comfyui_install.sh" && echo "__term_sd_task_sys term_sd_echo "安装插件中"" >> "$start_path/term-sd/task/comfyui_install.sh"
            for i in $comfyui_extension_install_select_list ;do
                cat "$start_path/term-sd/install/comfyui/comfyui_extension.md" | grep -w $i | awk '{sub(" ON "," ") ; sub(" OFF "," ")}1' >> "$start_path/term-sd/task/comfyui_install.sh" # 插件
            done

            [ ! -z "$comfyui_custom_node_install_select_list" ] && echo "" >> "$start_path/term-sd/task/comfyui_install.sh" && echo "__term_sd_task_sys term_sd_echo "安装自定义节点中"" >> "$start_path/term-sd/task/comfyui_install.sh" # 核心组件
            for i in $comfyui_custom_node_install_select_list ;do
                cat "$start_path/term-sd/install/comfyui/comfyui_custom_node.md" | grep -w $i | awk '{sub(" ON "," ") ; sub(" OFF "," ")}1' >> "$start_path/term-sd/task/comfyui_install.sh" # 插件
            done

            if [ $use_modelscope_model = 1 ];then
                cat "$start_path/term-sd/install/comfyui/comfyui_hf_model.md" >> "$start_path/term-sd/task/comfyui_install.sh" # 模型
                for i in $comfyui_custom_node_install_select_list ;do
                    cat "$start_path/term-sd/install/comfyui/comfyui_custom_node_hf_model.md" | grep -w $i >> "$start_path/term-sd/task/comfyui_install.sh" # 自定义节点所需的模型
                done
            else
                cat "$start_path/term-sd/install/comfyui/comfyui_ms_model.md" >> "$start_path/term-sd/task/comfyui_install.sh" # 模型
                for i in $comfyui_custom_node_install_select_list ;do
                    cat "$start_path/term-sd/install/comfyui/comfyui_custom_node_ms_model.md" | grep -w $i >> "$start_path/term-sd/task/comfyui_install.sh" # 自定义节点所需的模型
                done
            fi

            term_sd_echo "任务队列生成完成"
            term_sd_echo "开始安装ComfyUI"

            cmd_sum=$(( $(cat "$start_path/term-sd/task/comfyui_install.sh" | wc -l) + 1 )) # 统计命令行数
            for ((cmd_point=1;cmd_point<=cmd_sum;cmd_point++))
            do
                term_sd_echo "ComfyUI安装进度:[$cmd_point/$cmd_sum]"
                install_cmd=$(term_sd_get_task_cmd $(cat "$start_path/term-sd/task/comfyui_install.sh" | awk 'NR=='${cmd_point}'{print$0}'))
                
                if [ -z "$(echo "$(cat "$start_path/term-sd/task/comfyui_install.sh" | awk 'NR=='${cmd_point}'{print$0}')" | grep -o __term_sd_task_done_ )" ];then # 检测命令是否需要执行
                    echo "$install_cmd" > "$start_path/term-sd/task/cache.sh" # 取出命令并放入缓存文件中
                    [ $term_sd_debug_mode = 0 ] && term_sd_echo "执行命令: \"$install_cmd\""
                    source "$start_path/term-sd/task/cache.sh" # 执行命令
                else
                    [ $term_sd_debug_mode = 0 ] && term_sd_echo "跳过执行命令: \"$install_cmd\""
                    true
                fi

                if [ $? = 0 ];then
                    term_sd_task_cmd_revise "$start_path/term-sd/task/comfyui_install.sh" ${cmd_point} # 将执行成功的命令标记为完成
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
            term_sd_echo "ComfyUI安装结束"
            rm -f "$start_path/term-sd/task/comfyui_install.sh" # 删除任务文件
            rm -f "$start_path/term-sd/task/cache.sh"
            comfyui_manager # 进入管理界面
        fi
    fi
}

# 插件选择
comfyui_extension_install_select()
{
    comfyui_extension_install_select_list=$(
        dialog --erase-on-exit --notags --title "ComfyUI安装" --backtitle "ComfyUI插件安装选项" --ok-label "确认" --no-cancel --checklist "请选择需要安装的ComfyUI插件" 25 80 10 \
        $(cat "$start_path/term-sd/install/comfyui/dialog_comfyui_extension.md") \
        3>&1 1>&2 2>&3)
}

# 自定义节点选择
comfyui_custom_node_install_select()
{
    comfyui_custom_node_install_select_list=$(
        dialog --erase-on-exit --notags --title "ComfyUI安装" --backtitle "ComfyUI插件安装选项" --ok-label "确认" --no-cancel --checklist "请选择需要安装的ComfyUI插件" 25 80 10 \
        $(cat "$start_path/term-sd/install/comfyui/dialog_comfyui_custom_node.md") \
        3>&1 1>&2 2>&3)
}