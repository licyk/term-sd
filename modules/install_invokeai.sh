#!/bin/bash

# invokeai安装
install_invokeai()
{
    local cmd_sum
    local cmd_point

    if [ -f "$start_path/term-sd/task/invokeai_install.sh" ];then # 检测到有未完成的安装任务时直接执行安装任务
        cmd_sum=$(( $(cat "$start_path/term-sd/task/invokeai_install.sh" | wc -l) + 1 )) # 统计命令行数
        term_sd_print_line "InvokeAI 安装"
        for ((cmd_point=1; cmd_point <= cmd_sum; cmd_point++))
        do
            term_sd_echo "InvokeAI 安装进度: [$cmd_point/$cmd_sum]"

            term_sd_exec_cmd "$start_path/term-sd/task/invokeai_install.sh" $cmd_point

            if [ ! $? = 0 ];then
                if [ $term_sd_install_mode = 0 ];then
                    term_sd_echo "安装命令执行失败, 终止安装程序"
                    term_sd_tmp_enable_proxy # 恢复代理
                    term_sd_pause

                    dialog --erase-on-exit \
                        --title "InvokeAI 管理" \
                        --backtitle "InvokeAI 安装结果" \
                        --ok-label "确认" \
                        --msgbox "InvokeAI 安装进程执行失败, 请重试" \
                        $term_sd_dialog_height $term_sd_dialog_width

                    return 1
                else
                    term_sd_echo "忽略执行失败的命令"
                fi
            fi
        done

        term_sd_tmp_enable_proxy # 恢复代理
        term_sd_echo "InvokeAI 安装结束"
        rm -f "$start_path/term-sd/task/invokeai_install.sh" # 删除任务文件
        term_sd_print_line

        dialog --erase-on-exit \
            --title "InvokeAI 管理" \
            --backtitle "InvokeAI 安装结果" \
            --ok-label "确认" \
            --msgbox "InvokeAI 安装结束, 选择确定进入管理界面" \
            $term_sd_dialog_height $term_sd_dialog_width

        invokeai_manager # 进入管理界面
    else # 生成安装任务并执行安装任务
        # 安装前的准备
        download_mirror_select # 下载镜像源选择
        pytorch_version_select # pytorch版本选择
        invokeai_download_model_select # 模型选择
        pip_install_mode_select # 安装方式选择
        term_sd_install_confirm "是否安装 InvokeAI ?" # 安装确认

        if [ $? = 0 ];then
            term_sd_print_line "InvokeAI 安装"
            term_sd_echo "生成安装任务中"
            term_sd_set_install_env_value >> "$start_path/term-sd/task/invokeai_install.sh" # 环境变量
            cat "$start_path/term-sd/install/invokeai/invokeai_core.sh" >> "$start_path/term-sd/task/invokeai_install.sh" # 核心组件
            term_sd_add_blank_line "$start_path/term-sd/task/invokeai_install.sh"

            # 模型下载
            if [ $use_modelscope_model = 1 ];then
                # 恢复代理
                echo "__term_sd_task_sys term_sd_tmp_enable_proxy" >> "$start_path/term-sd/task/invokeai_install.sh"
                # 读取模型
                for i in $invokeai_download_model_select_list ;do
                    cat "$start_path/term-sd/install/invokeai/invokeai_hf_model.sh" | grep -w $i >> "$start_path/term-sd/task/invokeai_install.sh" # 插件所需的模型
                done
            else
                for i in $invokeai_download_model_select_list ;do
                    cat "$start_path/term-sd/install/invokeai/invokeai_ms_model.sh" | grep -w $i >> "$start_path/term-sd/task/invokeai_install.sh" # 插件所需的模型
                done
            fi

            term_sd_echo "任务队列生成完成"
            term_sd_echo "开始安装 InvokeAI"

            # 执行命令
            cmd_sum=$(( $(cat "$start_path/term-sd/task/invokeai_install.sh" | wc -l) + 1 )) # 统计命令行数
            for ((cmd_point=1; cmd_point <= cmd_sum; cmd_point++))
            do
                term_sd_echo "InvokeAI 安装进度: [$cmd_point/$cmd_sum]"

                term_sd_exec_cmd "$start_path/term-sd/task/invokeai_install.sh" $cmd_point

                if [ ! $? = 0 ];then
                    if [ $term_sd_install_mode = 0 ];then
                        term_sd_echo "安装命令执行失败, 终止安装程序"
                        term_sd_tmp_enable_proxy # 恢复代理
                        term_sd_pause

                        dialog --erase-on-exit \
                            --title "InvokeAI 管理" \
                            --backtitle "InvokeAI 安装结果" \
                            --ok-label "确认" \
                            --msgbox "InvokeAI 安装进程执行失败, 请重试" \
                            $term_sd_dialog_height $term_sd_dialog_width

                        return 1
                    else
                        term_sd_echo "忽略执行失败的命令"
                    fi
                fi
            done

            term_sd_tmp_enable_proxy # 恢复代理
            term_sd_echo "InvokeAI 安装结束"
            rm -f "$start_path/term-sd/task/invokeai_install.sh" # 删除任务文件
            term_sd_print_line

            dialog --erase-on-exit \
                --title "InvokeAI 管理" \
                --backtitle "InvokeAI 安装结果" \
                --ok-label "确认" \
                --msgbox "InvokeAI 安装结束, 选择确定进入管理界面" \
                $term_sd_dialog_height $term_sd_dialog_width

            invokeai_manager # 进入管理界面
        fi
    fi
}

# 模型选择
invokeai_download_model_select()
{
    local invokeai_custom_node_model_list
    local invokeai_model_list_file

    term_sd_echo "生成模型选择列表中"
    if [ $use_modelscope_model = 0 ];then
        invokeai_model_list_file="dialog_invokeai_ms_model.sh"
    else
        invokeai_model_list_file="dialog_invokeai_hf_model.sh"
    fi

    # 模型选择
    invokeai_download_model_select_list=$(dialog --erase-on-exit --notags \
        --title "InvokeAI 安装" \
        --backtitle "InvokeAI 模型下载选项" \
        --ok-label "确认" --no-cancel \
        --checklist "请选择需要下载的 InvokeAI 模型" \
        $term_sd_dialog_height $term_sd_dialog_width $term_sd_dialog_menu_height \
        "_null_" "=====基础模型选择=====" ON \
        $(cat "$start_path/term-sd/install/invokeai/$invokeai_model_list_file") \
        3>&1 1>&2 2>&3)
}
