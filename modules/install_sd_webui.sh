#!/bin/bash

# sd-webui安装
install_sd_webui()
{
    local cmd_sum
    local cmd_point

    if [ -f "$start_path/term-sd/task/sd_webui_install.sh" ];then # 检测到有未完成的安装任务时直接执行安装任务
        cmd_sum=$(( $(cat "$start_path/term-sd/task/sd_webui_install.sh" | wc -l) + 1 )) # 统计命令行数
        term_sd_print_line "Stable-Diffusion-WebUI 安装"
        for ((cmd_point=1; cmd_point <= cmd_sum; cmd_point++))
        do
            term_sd_echo "Stable-Diffusion-WebUI 安装进度: [$cmd_point/$cmd_sum]"

            term_sd_exec_cmd "$start_path/term-sd/task/sd_webui_install.sh" $cmd_point

            if [ ! $? = 0 ];then
                if [ $term_sd_install_mode = 0 ];then
                    term_sd_echo "安装命令执行失败, 终止安装程序"
                    term_sd_tmp_enable_proxy # 恢复代理
                    term_sd_pause

                    dialog --erase-on-exit \
                        --title "Stable-Diffusion-WebUI 管理" \
                        --backtitle "Stable-Diffusion-WebUI 安装结果" \
                        --ok-label "确认" \
                        --msgbox "Stable-Diffusion-WebUI 安装进程执行失败, 请重试" \
                        $term_sd_dialog_height $term_sd_dialog_width

                    return 1
                else
                    term_sd_echo "忽略执行失败的命令"
                fi
            fi
        done

        term_sd_tmp_enable_proxy # 恢复代理
        term_sd_echo "Stable-Diffusion-WebUI 安装结束"
        rm -f "$start_path/term-sd/task/sd_webui_install.sh" # 删除任务文件
        term_sd_print_line

        dialog --erase-on-exit \
            --title "Stable-Diffusion-WebUI 管理" \
            --backtitle "Stable-Diffusion-WebUI 安装结果" \
            --ok-label "确认" \
            --msgbox "Stable-Diffusion-WebUI 安装结束, 选择确定进入管理界面" \
            $term_sd_dialog_height $term_sd_dialog_width

        sd_webui_manager # 进入管理界面
    else # 生成安装任务并执行安装任务
        # 安装前的准备
        download_mirror_select auto_github_mirrror # 下载镜像源选择
        pytorch_version_select # pytorch版本选择
        sd_webui_extension_install_select # 插件选择
        sd_webui_download_model_select # 模型选择
        pip_install_mode_select # 安装方式选择
        term_sd_install_confirm "是否安装 Stable-Diffusion-WebUI ?" # 安装确认
        if [ $? = 0 ];then
            local sd_webui_extension_model_list
            term_sd_print_line "Stable-Diffusion-WebUI 安装"
            term_sd_echo "生成安装任务中"
            term_sd_set_install_env_value >> "$start_path/term-sd/task/sd_webui_install.sh" # 环境变量
            cat "$start_path/term-sd/install/sd_webui/sd_webui_core.sh" >> "$start_path/term-sd/task/sd_webui_install.sh" # 核心组件

            # 添加安装插件提示并启用代理
            [ ! -z "$sd_webui_extension_install_select_list" ] && \
            term_sd_add_blank_line "$start_path/term-sd/task/sd_webui_install.sh" && \
            echo "__term_sd_task_sys term_sd_echo "安装插件中"" >> "$start_path/term-sd/task/sd_webui_install.sh" && \
            echo "__term_sd_task_sys term_sd_tmp_enable_proxy" >> "$start_path/term-sd/task/sd_webui_install.sh"

            # 从插件列表读取插件安装命令
            for i in $sd_webui_extension_install_select_list ;do
                cat "$start_path/term-sd/install/sd_webui/sd_webui_extension.sh" | grep -w $i | awk '{sub(" ON "," ") ; sub(" OFF "," ")}1' >> "$start_path/term-sd/task/sd_webui_install.sh" # 插件
            done
    
            # 取消代理并添加下载模型提示
            [ ! -z "$sd_webui_extension_install_select_list" ] && \
            echo "__term_sd_task_sys term_sd_tmp_disable_proxy" >> "$start_path/term-sd/task/sd_webui_install.sh" && \
            echo "__term_sd_task_sys term_sd_echo "下载模型中"" >> "$start_path/term-sd/task/sd_webui_install.sh"

            # 读取模型下载命令
            if [ $use_modelscope_model = 1 ];then
                # 恢复代理
                echo "__term_sd_task_sys term_sd_tmp_enable_proxy" >> "$start_path/term-sd/task/sd_webui_install.sh"
                # 读取模型
                for i in $sd_webui_download_model_select_list ;do
                    cat "$start_path/term-sd/install/sd_webui/sd_webui_hf_model.sh" | grep -w $i >> "$start_path/term-sd/task/sd_webui_install.sh" # 插件所需的模型
                done
                # 读取插件的模型
                for i in $sd_webui_download_model_select_list ;do
                    cat "$start_path/term-sd/install/sd_webui/sd_webui_extension_hf_model.sh" | grep -w $i >> "$start_path/term-sd/task/sd_webui_install.sh" # 插件所需的模型
                done
            else
                # 读取模型
                for i in $sd_webui_download_model_select_list ;do
                    cat "$start_path/term-sd/install/sd_webui/sd_webui_ms_model.sh" | grep -w $i >> "$start_path/term-sd/task/sd_webui_install.sh" # 插件所需的模型
                done
                # 读取插件的模型
                for i in $sd_webui_download_model_select_list ;do
                    cat "$start_path/term-sd/install/sd_webui/sd_webui_extension_ms_model.sh" | grep -w $i >> "$start_path/term-sd/task/sd_webui_install.sh" # 插件所需的模型
                done
            fi

            term_sd_echo "任务队列生成完成"
            term_sd_echo "开始安装 Stable-Diffusion-WebUI"

            # 执行安装命令
            cmd_sum=$(( $(cat "$start_path/term-sd/task/sd_webui_install.sh" | wc -l) + 1 )) # 统计命令行数
            for ((cmd_point=1; cmd_point <= cmd_sum; cmd_point++))
            do
                term_sd_echo "Stable-Diffusion-WebUI 安装进度: [$cmd_point/$cmd_sum]"

                term_sd_exec_cmd "$start_path/term-sd/task/sd_webui_install.sh" $cmd_point

                if [ ! $? = 0 ];then
                    if [ $term_sd_install_mode = 0 ];then
                        term_sd_echo "安装命令执行失败, 终止安装程序"
                        term_sd_tmp_enable_proxy # 恢复代理
                        term_sd_pause

                        dialog --erase-on-exit \
                            --title "Stable-Diffusion-WebUI 管理" \
                            --backtitle "Stable-Diffusion-WebUI 安装结果" \
                            --ok-label "确认" \
                            --msgbox "Stable-Diffusion-WebUI 安装进程执行失败, 请重试" \
                            $term_sd_dialog_height $term_sd_dialog_width

                        return 1
                    else
                        term_sd_echo "忽略执行失败的命令"
                    fi
                fi
            done

            term_sd_tmp_enable_proxy # 恢复代理
            term_sd_echo "Stable-Diffusion-WebUI 安装结束"
            rm -f "$start_path/term-sd/task/sd_webui_install.sh" # 删除任务文件
            term_sd_print_line

            dialog --erase-on-exit \
                --title "Stable-Diffusion-WebUI 管理" \
                --backtitle "Stable-Diffusion-WebUI 安装结果" \
                --ok-label "确认" \
                --msgbox "Stable-Diffusion-WebUI 安装结束, 选择确定进入管理界面" \
                $term_sd_dialog_height $term_sd_dialog_width

            sd_webui_manager # 进入管理界面
        fi
    fi
}

# 插件选择
sd_webui_extension_install_select()
{
    sd_webui_extension_install_select_list=$(dialog --erase-on-exit --notags \
        --title "Stable-Diffusion-WebUI 安装" \
        --backtitle "Stable-Diffusion-WebUI 插件安装选项" \
        --ok-label "确认" --no-cancel \
        --checklist "请选择需要安装的 Stable-Diffusion-WebUI 插件" \
        $term_sd_dialog_height $term_sd_dialog_width $term_sd_dialog_menu_height \
        $(cat "$start_path/term-sd/install/sd_webui/dialog_sd_webui_extension.sh") \
        3>&1 1>&2 2>&3)
}

# 模型选择
sd_webui_download_model_select()
{
    local sd_webui_extension_model_list_file
    local sd_webui_extension_model_list
    local sd_webui_model_list_file
    # 插件模型列表选择
    if [ $use_modelscope_model = 0 ];then
        sd_webui_extension_model_list_file="sd_webui_extension_ms_model.sh"
        sd_webui_model_list_file="dialog_sd_webui_ms_model.sh"
    else
        sd_webui_extension_model_list_file="sd_webui_extension_hf_model.sh"
        sd_webui_model_list_file="dialog_sd_webui_hf_model.sh"
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
        "_null_" "=====基础模型选择=====" ON \
        $(cat "$start_path/term-sd/install/sd_webui/$sd_webui_model_list_file") \
        "_null_" "=====插件模型选择=====" ON \
        $sd_webui_extension_model_list \
        3>&1 1>&2 2>&3)
}

# sd-webui配置文件
sd_webui_config_file()
{
    cat<<EOF
{
    "quicksettings_list": [
        "sd_model_checkpoint",
        "sd_vae",
        "CLIP_stop_at_last_layers"
    ],
    "save_to_dirs": false,
    "grid_save_to_dirs": false,
    "export_for_4chan": false,
    "CLIP_stop_at_last_layers": 2,
    "localization": "zh-Hans (Stable)",
    "show_progress_every_n_steps": 1,
    "js_live_preview_in_modal_lightbox": true,
    "upscaler_for_img2img": "Lanczos",
    "emphasis": "No norm",
    "samples_filename_pattern": "[datetime<%Y%m%d_%H%M%S>]_[model_name]_[sampler]"
}
EOF
}
