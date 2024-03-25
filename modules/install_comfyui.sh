#!/bin/bash

install_comfyui()
{
    local install_cmd
    local cmd_sum
    local cmd_point

    if [ -f "$start_path/term-sd/task/comfyui_install.sh" ];then # 检测到有未完成的安装任务时直接执行安装任务
        cmd_sum=$(( $(cat "$start_path/term-sd/task/comfyui_install.sh" | wc -l) + 1 )) # 统计命令行数
        term_sd_print_line "ComfyUI 安装"
        for ((cmd_point=1; cmd_point <= cmd_sum; cmd_point++))
        do
            term_sd_echo "ComfyUI安装进度: [$cmd_point/$cmd_sum]"
            install_cmd=$(term_sd_get_task_cmd $(cat "$start_path/term-sd/task/comfyui_install.sh" | awk 'NR=='${cmd_point}'{print$0}'))

            if [ -z "$(echo "$(cat "$start_path/term-sd/task/comfyui_install.sh" | awk 'NR=='${cmd_point}'{print$0}')" | grep -o __term_sd_task_done_ )" ];then # 检测命令是否需要执行
                echo "$install_cmd" > "$start_path/term-sd/task/cache.sh" # 取出命令并放入缓存文件中
                [ $term_sd_debug_mode = 0 ] && term_sd_echo "执行命令: \"$install_cmd\""
                term_sd_exec_cmd # 执行命令
            else
                [ $term_sd_debug_mode = 0 ] && term_sd_echo "跳过执行命令: \"$install_cmd\""
                true
            fi

            if [ $? = 0 ];then
                term_sd_task_cmd_revise "$start_path/term-sd/task/comfyui_install.sh" ${cmd_point} # 将执行成功的命令标记为完成
            else
                if [ $term_sd_install_mode = 0 ];then
                    term_sd_echo "安装命令执行失败, 终止安装程序"
                    term_sd_tmp_enable_proxy # 恢复代理
                    term_sd_pause

                    dialog --erase-on-exit \
                        --title "ComfyUI 管理" \
                        --backtitle "ComfyUI 安装结果" \
                        --ok-label "确认" \
                        --msgbox "ComfyUI 安装进程执行失败, 请重试" \
                        $term_sd_dialog_height $term_sd_dialog_width

                    return 1
                else
                    term_sd_echo "忽略执行失败的命令"
                fi
            fi
        done

        term_sd_tmp_enable_proxy # 恢复代理
        term_sd_echo "ComfyUI 安装结束"
        rm -f "$start_path/term-sd/task/comfyui_install.sh" # 删除任务文件
        rm -f "$start_path/term-sd/task/cache.sh"
        term_sd_print_line

        dialog --erase-on-exit \
            --title "ComfyUI 管理" \
            --backtitle "ComfyUI 安装结果" \
            --ok-label "确认" \
            --msgbox "ComfyUI 安装结束, 选择确定进入管理界面\n注:\n建议在进入ComfyUI管理界面后, 进入 \"管理自定义节点\" , 选择 \"安装全部自定义节点依赖\" 为自定义节点安装依赖, 保证自定义节点的正常运行" \
            $term_sd_dialog_height $term_sd_dialog_width

        comfyui_manager # 进入管理界面
    else
        # 安装前的准备
        download_mirror_select auto_github_mirrror # 下载镜像源选择
        pytorch_version_select # pytorch版本选择
        comfyui_extension_install_select # 插件选择
        comfyui_custom_node_install_select # 自定义节点选择
        comfyui_download_model_select # 模型选择
        pip_install_mode_select # 安装方式选择
        term_sd_install_confirm "是否安装 ComfUI ?" # 安装确认

        if [ $? = 0 ];then
            term_sd_print_line "ComfyUI 安装"
            term_sd_echo "生成安装任务中"
            term_sd_set_install_env_value >> "$start_path/term-sd/task/comfyui_install.sh" # 环境变量
            cat "$start_path/term-sd/install/comfyui/comfyui_core.sh" >> "$start_path/term-sd/task/comfyui_install.sh" # 核心组件

            # 启用代理
            term_sd_add_blank_line "$start_path/term-sd/task/comfyui_install.sh" && \
            echo "__term_sd_task_sys term_sd_tmp_enable_proxy" >> "$start_path/term-sd/task/comfyui_install.sh"

            # 读取安装插件命令
            if [ ! -z "$comfyui_extension_install_select_list" ];then
                echo "__term_sd_task_sys term_sd_echo "安装插件中"" >> "$start_path/term-sd/task/comfyui_install.sh"
                # 读取安装插件命令列表
                for i in $comfyui_extension_install_select_list ;do
                    cat "$start_path/term-sd/install/comfyui/comfyui_extension.sh" | grep -w $i | awk '{sub(" ON "," ") ; sub(" OFF "," ")}1' >> "$start_path/term-sd/task/comfyui_install.sh" # 插件
                done
            fi

            # 读取安装自定义节点命令
            if [ ! -z "$comfyui_custom_node_install_select_list" ];then
                echo "__term_sd_task_sys term_sd_echo "安装自定义节点中"" >> "$start_path/term-sd/task/comfyui_install.sh"
                # 读取安装自定义节点列表
                for i in $comfyui_custom_node_install_select_list ;do
                    cat "$start_path/term-sd/install/comfyui/comfyui_custom_node.sh" | grep -w $i | awk '{sub(" ON "," ") ; sub(" OFF "," ")}1' >> "$start_path/term-sd/task/comfyui_install.sh" # 插件
                done
            fi

            # 取消代理
            echo "__term_sd_task_sys term_sd_tmp_disable_proxy" >> "$start_path/term-sd/task/comfyui_install.sh"

            # 读取模型下载命令
            if [ $use_modelscope_model = 1 ];then
                # 恢复代理
                echo "__term_sd_task_sys term_sd_tmp_enable_proxy" >> "$start_path/term-sd/task/comfyui_install.sh"
                # 读取模型
                for i in $comfyui_download_model_select_list ;do
                    cat "$start_path/term-sd/install/comfyui/comfyui_hf_model.sh" | grep -w $i >> "$start_path/term-sd/task/comfyui_install.sh" # 插件所需的模型
                done
                # 读取扩展的模型
                for i in $comfyui_download_model_select_list ;do
                    cat "$start_path/term-sd/install/comfyui/comfyui_custom_node_hf_model.sh" | grep -w $i >> "$start_path/term-sd/task/comfyui_install.sh" # 自定义节点所需的模型
                done
            else
                # 读取模型
                for i in $comfyui_download_model_select_list ;do
                    cat "$start_path/term-sd/install/comfyui/comfyui_ms_model.sh" | grep -w $i >> "$start_path/term-sd/task/comfyui_install.sh" # 插件所需的模型
                done
                # 读取扩展的模型
                for i in $comfyui_download_model_select_list ;do
                    cat "$start_path/term-sd/install/comfyui/comfyui_custom_node_ms_model.sh" | grep -w $i >> "$start_path/term-sd/task/comfyui_install.sh" # 自定义节点所需的模型
                done
            fi

            term_sd_echo "任务队列生成完成"
            term_sd_echo "开始安装 ComfyUI"

            # 执行安装命令
            cmd_sum=$(( $(cat "$start_path/term-sd/task/comfyui_install.sh" | wc -l) + 1 )) # 统计命令行数
            for ((cmd_point=1; cmd_point <= cmd_sum; cmd_point++))
            do
                term_sd_echo "ComfyUI安装进度: [$cmd_point/$cmd_sum]"
                install_cmd=$(term_sd_get_task_cmd $(cat "$start_path/term-sd/task/comfyui_install.sh" | awk 'NR=='${cmd_point}'{print$0}'))
                
                if [ -z "$(echo "$(cat "$start_path/term-sd/task/comfyui_install.sh" | awk 'NR=='${cmd_point}'{print$0}')" | grep -o __term_sd_task_done_ )" ];then # 检测命令是否需要执行
                    echo "$install_cmd" > "$start_path/term-sd/task/cache.sh" # 取出命令并放入缓存文件中
                    [ $term_sd_debug_mode = 0 ] && term_sd_echo "执行命令: \"$install_cmd\""
                    term_sd_exec_cmd # 执行命令
                else
                    [ $term_sd_debug_mode = 0 ] && term_sd_echo "跳过执行命令: \"$install_cmd\""
                    true
                fi

                if [ $? = 0 ];then
                    term_sd_task_cmd_revise "$start_path/term-sd/task/comfyui_install.sh" ${cmd_point} # 将执行成功的命令标记为完成
                else
                    if [ $term_sd_install_mode = 0 ];then
                        term_sd_echo "安装命令执行失败, 终止安装程序"
                        term_sd_tmp_enable_proxy # 恢复代理
                        term_sd_pause

                        dialog --erase-on-exit \
                            --title "ComfyUI 管理" \
                            --backtitle "ComfyUI 安装结果" \
                            --ok-label "确认" \
                            --msgbox "ComfyUI 安装进程执行失败, 请重试" \
                            $term_sd_dialog_height $term_sd_dialog_width

                        return 1
                    else
                        term_sd_echo "忽略执行失败的命令"
                    fi
                fi
            done

            term_sd_tmp_enable_proxy # 恢复代理
            term_sd_echo "ComfyUI 安装结束"
            rm -f "$start_path/term-sd/task/comfyui_install.sh" # 删除任务文件
            rm -f "$start_path/term-sd/task/cache.sh"
            term_sd_print_line

            dialog --erase-on-exit \
                --title "ComfyUI 管理" \
                --backtitle "ComfyUI 安装结果" \
                --ok-label "确认" \
                --msgbox "ComfyUI 安装结束, 选择确定进入管理界面\n注:\n建议在进入 ComfyUI 管理界面后, 进入 \"管理自定义节点\" , 选择 \"安装全部自定义节点依赖\" 为自定义节点安装依赖, 保证自定义节点的正常运行" \
                $term_sd_dialog_height $term_sd_dialog_width

            comfyui_manager # 进入管理界面
        fi
    fi
}

# 插件选择
comfyui_extension_install_select()
{
    comfyui_extension_install_select_list=$(
        dialog --erase-on-exit --notags \
            --title "ComfyUI 安装" \
            --backtitle "ComfyUI 插件安装选项" \
            --ok-label "确认" --no-cancel \
            --checklist "请选择需要安装的 ComfyUI 插件" \
            $term_sd_dialog_height $term_sd_dialog_width $term_sd_dialog_menu_height \
            $(cat "$start_path/term-sd/install/comfyui/dialog_comfyui_extension.sh") \
            3>&1 1>&2 2>&3)
}

# 自定义节点选择
comfyui_custom_node_install_select()
{
    comfyui_custom_node_install_select_list=$(
        dialog --erase-on-exit --notags \
            --title "ComfyUI 安装" \
            --backtitle "ComfyUI 插件安装选项" \
            --ok-label "确认" --no-cancel \
            --checklist "请选择需要安装的 ComfyUI 插件" \
            $term_sd_dialog_height $term_sd_dialog_width $term_sd_dialog_menu_height \
            $(cat "$start_path/term-sd/install/comfyui/dialog_comfyui_custom_node.sh") \
            3>&1 1>&2 2>&3)
}

# 模型选择
comfyui_download_model_select()
{
    local comfyui_custom_node_model_list_file
    local comfyui_model_list_file
    local comfyui_custom_node_model_list
    # 插件模型列表选择
    if [ $use_modelscope_model = 0 ];then
        comfyui_custom_node_model_list_file="comfyui_custom_node_ms_model.sh"
        comfyui_model_list_file="dialog_comfyui_ms_model.sh"
    else
        comfyui_custom_node_model_list_file="comfyui_custom_node_hf_model.sh"
        comfyui_model_list_file="dialog_comfyui_hf_model.sh"
    fi

    term_sd_echo "生成模型选择列表中"
    # 查找插件对应模型的编号
    for i in $comfyui_custom_node_install_select_list
    do
        comfyui_custom_node_model_list="$comfyui_custom_node_model_list $(cat "$start_path"/term-sd/install/comfyui/$comfyui_custom_node_model_list_file | grep -w $i | awk 'NR==1{if ($NF!="") {print $1 " " $(NF-1) " " $NF} }')"
    done

    # 模型选择(包含基础模型和插件的模型)
    comfyui_download_model_select_list=$(dialog --erase-on-exit --notags \
        --title "ComfyUI 安装" \
        --backtitle "ComfyUI 模型下载选项" \
        --ok-label "确认" --no-cancel \
        --checklist "请选择需要下载的 ComfyUI 模型" \
        $term_sd_dialog_height $term_sd_dialog_width $term_sd_dialog_menu_height \
        "_null_" "====基础模型选择====" ON \
        $(cat "$start_path/term-sd/install/comfyui/$comfyui_model_list_file") \
        "_null_" "====插件模型选择====" ON \
        $comfyui_custom_node_model_list \
        3>&1 1>&2 2>&3)
}