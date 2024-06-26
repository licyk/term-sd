#!/bin/bash

# kohya_ss安装功能
install_kohya_ss()
{
    local cmd_sum
    local cmd_point

    if [ -f "$start_path/term-sd/task/kohya_ss_install.sh" ];then # 检测到有未完成的安装任务时直接执行安装任务
        cmd_sum=$(( $(cat "$start_path/term-sd/task/kohya_ss_install.sh" | wc -l) + 1 )) # 统计命令行数
        term_sd_print_line "kohya_ss 安装"
        for ((cmd_point=1; cmd_point <= cmd_sum; cmd_point++))
        do
            term_sd_echo "kohya_ss安装进度: [$cmd_point/$cmd_sum]"

            term_sd_exec_cmd "$start_path/term-sd/task/kohya_ss_install.sh" $cmd_point

            if [ ! $? = 0 ];then
                if [ $term_sd_install_mode = 0 ];then
                    term_sd_echo "安装命令执行失败, 终止安装程序"
                    term_sd_tmp_enable_proxy # 恢复代理
                    term_sd_pause

                    dialog --erase-on-exit \
                        --title "kohya_ss 管理" \
                        --backtitle "kohya_ss 安装结果" \
                        --ok-label "确认" \
                        --msgbox "kohya_ss 安装进程执行失败, 请重试" \
                        $term_sd_dialog_height $term_sd_dialog_width

                    return 1
                else
                    term_sd_echo "忽略执行失败的命令"
                fi
            fi
        done

        term_sd_tmp_enable_proxy # 恢复代理
        term_sd_echo "kohya_ss 安装结束"
        rm -f "$start_path/term-sd/task/kohya_ss_install.sh" # 删除任务文件
        term_sd_print_line

        dialog --erase-on-exit \
            --title "kohya_ss 管理" \
            --backtitle "kohya_ss 安装结果" \
            --ok-label "确认" \
            --msgbox "kohya_ss 安装结束, 选择确定进入管理界面" \
            $term_sd_dialog_height $term_sd_dialog_width

        kohya_ss_manager # 进入管理界面
    else # 生成安装任务并执行安装任务
        # 安装前的准备
        download_mirror_select auto_github_mirrror # 下载镜像源选择
        pytorch_version_select # pytorch版本选择
        kohya_ss_download_model_select # 模型选择
        pip_install_mode_select # 安装方式选择
        term_sd_install_confirm "是否安装 kohya_ss ?" # 安装确认

        if [ $? = 0 ];then
            term_sd_print_line "kohya_ss 安装"
            term_sd_echo "生成安装任务中"
            term_sd_set_install_env_value >> "$start_path/term-sd/task/kohya_ss_install.sh" # 环境变量
            cat "$start_path/term-sd/install/kohya_ss/kohya_ss_core.sh" >> "$start_path/term-sd/task/kohya_ss_install.sh" # 核心组件
            term_sd_add_blank_line "$start_path/term-sd/task/kohya_ss_install.sh"

            # 模型下载
            if [ $use_modelscope_model = 1 ];then
                # 恢复代理
                echo "__term_sd_task_sys term_sd_tmp_enable_proxy" >> "$start_path/term-sd/task/kohya_ss_install.sh"
                # 读取模型
                for i in $kohya_ss_download_model_select_list ;do
                    cat "$start_path/term-sd/install/kohya_ss/kohya_ss_hf_model.sh" | grep -w $i >> "$start_path/term-sd/task/kohya_ss_install.sh" # 插件所需的模型
                done
            else
                for i in $kohya_ss_download_model_select_list ;do
                    cat "$start_path/term-sd/install/kohya_ss/kohya_ss_ms_model.sh" | grep -w $i >> "$start_path/term-sd/task/kohya_ss_install.sh" # 插件所需的模型
                done
            fi

            term_sd_echo "任务队列生成完成"
            term_sd_echo "开始安装 kohya_ss"

            cmd_sum=$(( $(cat "$start_path/term-sd/task/kohya_ss_install.sh" | wc -l) + 1 )) # 统计命令行数
            for ((cmd_point=1; cmd_point <= cmd_sum; cmd_point++))
            do
                term_sd_echo "kohya_ss安装进度: [$cmd_point/$cmd_sum]"

                term_sd_exec_cmd "$start_path/term-sd/task/kohya_ss_install.sh" $cmd_point

                if [ ! $? = 0 ];then
                    if [ $term_sd_install_mode = 0 ];then
                        term_sd_echo "安装命令执行失败, 终止安装程序"
                        term_sd_tmp_enable_proxy # 恢复代理
                        term_sd_pause

                        dialog --erase-on-exit \
                            --title "kohya_ss 管理" \
                            --backtitle "kohya_ss 安装结果" \
                            --ok-label "确认" \
                            --msgbox "kohya_ss 安装进程执行失败, 请重试" \
                            $term_sd_dialog_height $term_sd_dialog_width

                        return 1
                    else
                        term_sd_echo "忽略执行失败的命令"
                    fi
                fi
            done

            term_sd_tmp_enable_proxy # 恢复代理
            term_sd_echo "kohya_ss 安装结束"
            rm -f "$start_path/term-sd/task/kohya_ss_install.sh" # 删除任务文件
            term_sd_print_line

            dialog --erase-on-exit \
                --title "kohya_ss 管理" \
                --backtitle "kohya_ss 安装结果" \
                --ok-label "确认" \
                --msgbox "kohya_ss 安装结束, 选择确定进入管理界面" \
                $term_sd_dialog_height $term_sd_dialog_width

            kohya_ss_manager # 进入管理界面
        fi
    fi
}

# 模型选择
kohya_ss_download_model_select()
{
    local kohya_ss_custom_node_model_list
    local kohya_ss_model_list_file

    term_sd_echo "生成模型选择列表中"
    if [ $use_modelscope_model = 0 ];then
        kohya_ss_model_list_file="dialog_kohya_ss_ms_model.sh"
    else
        kohya_ss_model_list_file="dialog_kohya_ss_hf_model.sh"
    fi

    # 模型选择
    kohya_ss_download_model_select_list=$(dialog --erase-on-exit --notags \
        --title "kohya_ss 安装" \
        --backtitle "kohya_ss 模型下载选项" \
        --ok-label "确认" --no-cancel \
        --checklist "请选择需要下载的 kohya_ss 模型" \
        $term_sd_dialog_height $term_sd_dialog_width $term_sd_dialog_menu_height \
        "_null_" "=====基础模型选择=====" ON \
        $(cat "$start_path/term-sd/install/kohya_ss/$kohya_ss_model_list_file") \
        3>&1 1>&2 2>&3)
}
