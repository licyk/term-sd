#!/bin/bash

# 该脚本用于生成dialog界面所需的选项

build_list()
{
    local args_1
    local args_2
    local args_3
    local count=1
    local flag=0
    local input_file="$1"
    local output_file="$2"

    while true
    do
        args_1=$(cat $input_file | awk 'NR=='${count}' {print$1}')
        args_2=$(cat $input_file | awk 'NR=='${count}' {print$4}')
        args_3=$(cat $input_file | awk 'NR=='${count}' {print$6}')
        args_2=$(echo $args_2 | awk -F '/' '{print$NF}')
        if [ -z "$args_1" ];then
            break
        else
            if [ -z "$(echo $args_1 | grep __term_sd_task_sys)" ];then
                echo "$args_1 $args_2 $args_3" >> $output_file
            fi
        fi
        count=$(($count + 1))
    done
}

build_list_for_model()
{
    cat $1 | awk '{if ($NF!="") {print $1 " " $(NF-1) " " $NF} }' >> $2
}

build_dialog_list()
{
    local start_time=$(date +'%Y-%m-%d %H:%M:%S')
    local start_time_seconds=$(date --date="$start_time" +%s)
    local input_file="$1"
    local cache_file="task/dialog_cache.sh"
    local output_file="$2"
    local end_time
    local end_time_seconds
    local time_span
    if [ -f "$output_file" ];then
        rm -f $output_file
    fi
    echo "生成 ${output_file} 中"
    cat $input_file | awk '{sub(" --submod","")}1' >> $cache_file
    build_list $cache_file $output_file
    rm -f $cache_file
    end_time=$(date +'%Y-%m-%d %H:%M:%S')
    end_time_seconds=$(date --date="$end_time" +%s)
    time_span=$(( $end_time_seconds - $start_time_seconds )) # 计算相隔时间
    echo "完成, 用时: ${time_span} sec"
}

build_dialog_list_sd_webui()
{
    local start_time=$(date +'%Y-%m-%d %H:%M:%S')
    local start_time_seconds=$(date --date="$start_time" +%s)
    local input_file="$1"
    local output_file="$2"
    local cache_file="task/dialog_cache.sh"
    local flag=0
    local count=1
    local end_time
    local end_time_seconds
    local time_span
    if [ -f "$output_file" ];then
        rm -f $output_file
    fi
    echo "生成 ${output_file} 中"
    cat $input_file | awk '{sub(" --submod","")}1' >> $cache_file
    echo "Stable Diffusion WebUI 插件说明：" >> $output_file
    echo "注：有些插件因为年久失修，可能会出现兼容性问题。具体介绍请在 Github 上搜索项目" >> $output_file

    while (($flag==0))
    do
        extension_url=$(cat $cache_file | awk 'NR=='${count}' {print$4}')
        extension_name=$(cat $cache_file | awk 'NR=='${count}' {print$4}' | awk -F '/' '{print$NF}')
        extension_description=$(cat $cache_file | awk 'NR=='${count}' {print$8}')
        list_head=$(cat $cache_file | awk 'NR=='${count}' {print$1}')
        if [ -z "$list_head" ];then
            flag=1
        else
            if [ -z "$(echo $list_head | grep __term_sd_task_sys)" ];then
                echo "" >> $output_file
                echo "$count、$extension_name："  >> $output_file
                echo "描述：$extension_description" >> $output_file
                echo "链接：$extension_url" >> $output_file
            fi
        fi
        count=$(($count + 1))
    done
    rm -f $cache_file
    end_time=$(date +'%Y-%m-%d %H:%M:%S')
    end_time_seconds=$(date --date="$end_time" +%s)
    time_span=$(( $end_time_seconds - $start_time_seconds )) # 计算相隔时间
    echo "完成, 用时: ${time_span} sec"
}

build_dialog_list_comfyui()
{
    local start_time=$(date +'%Y-%m-%d %H:%M:%S')
    local start_time_seconds=$(date --date="$start_time" +%s)
    local input_file_1="$1"
    local input_file_2="$2"
    local cache_file_1="task/dialog_cache_1.sh"
    local cache_file_2="task/dialog_cache_2.sh"
    local output_file="$3"
    local flag=0
    local count=1
    local end_time
    local end_time_seconds
    local time_span
    if [ -f "$output_file" ];then
        rm -f $output_file
    fi

    echo "生成 ${output_file} 中"
    cat $input_file_1 | awk '{sub(" --submod","")}1' >> $cache_file_1
    cat $input_file_2 | awk '{sub(" --submod","")}1' >> $cache_file_2
    echo "ComfyUI 插件 / 自定义节点说明：" >> $output_file
    echo "注：有些插件 / 自定义节点因为年久失修，可能会出现兼容性问题。具体介绍请在 Github 上搜索项目" >> $output_file
    echo "" >> $output_file
    echo "插件：" >> $output_file

    while (($flag==0))
    do
        extension_url=$(cat $cache_file_1 | awk 'NR=='${count}' {print$4}')
        extension_name=$(cat $cache_file_1 | awk 'NR=='${count}' {print$4}' | awk -F '/' '{print$NF}')
        extension_description=$(cat $cache_file_1 | awk 'NR=='${count}' {print$8}')
        list_head=$(cat $cache_file_1 | awk 'NR=='${count}' {print$1}')
        if [ -z "$list_head" ];then
            flag=1
        else
            if [ -z "$(echo $list_head | grep __term_sd_task_sys)" ];then
                echo "" >> $output_file
                echo "$count、$extension_name："  >> $output_file
                echo "描述：$extension_description" >> $output_file
                echo "链接：$extension_url" >> $output_file
            fi
        fi
        count=$(($count + 1))
    done

    echo "" >> $output_file
    echo "自定义节点：" >> $output_file

    count=1
    flag=0
    while (($flag==0))
    do
        extension_url=$(cat $cache_file_2 | awk 'NR=='${count}' {print$4}')
        extension_name=$(cat $cache_file_2 | awk 'NR=='${count}' {print$4}' | awk -F '/' '{print$NF}')
        extension_description=$(cat $cache_file_2 | awk 'NR=='${count}' {print$8}')
        list_head=$(cat $cache_file_2 | awk 'NR=='${count}' {print$1}')
        if [ -z "$list_head" ];then
            flag=1
        else
            if [ -z "$(echo $list_head | grep __term_sd_task_sys)" ];then
                echo "" >> $output_file
                echo "$count、$extension_name："  >> $output_file
                echo "描述：$extension_description" >> $output_file
                echo "链接：$extension_url" >> $output_file
            fi
        fi
        count=$(($count + 1))
    done
    rm -f $cache_file_1
    rm -f $cache_file_2
    end_time=$(date +'%Y-%m-%d %H:%M:%S')
    end_time_seconds=$(date --date="$end_time" +%s)
    time_span=$(( $end_time_seconds - $start_time_seconds )) # 计算相隔时间
    echo "完成, 用时: ${time_span} sec"
}

build_dialog_list_model()
{
    local start_time=$(date +'%Y-%m-%d %H:%M:%S')
    local start_time_seconds=$(date --date="$start_time" +%s)
    local input_file="$1"
    local output_file="$2"
    local end_time
    local end_time_seconds
    local time_span
    if [ -f "$output_file" ];then
        rm -f $output_file
    fi
    echo "生成 ${output_file} 中"
    build_list_for_model $input_file $output_file
    end_time=$(date +'%Y-%m-%d %H:%M:%S')
    end_time_seconds=$(date --date="$end_time" +%s)
    time_span=$(( $end_time_seconds - $start_time_seconds )) # 计算相隔时间
    echo "完成, 用时: ${time_span} sec"
}

get_task_cmd()
{
    local task_cmd_sign
    local task_cmd
    task_cmd_sign=$(echo $@ | awk '{print $1}')
    task_cmd=$(echo $@ | awk '{sub("'$task_cmd_sign' ","")}1')
    echo $task_cmd
}

sort_head_point()
{
    local cmd_sum
    local cmd_point
    local input_file="$2"
    local input_file_name=$(basename "$2")
    local start_time=$(date +'%Y-%m-%d %H:%M:%S')
    local start_time_seconds=$(date --date="$start_time" +%s)
    local head_point="$1"
    local end_time
    local end_time_seconds
    local time_span

    echo "生成 ${input_file} 中"
    mv $input_file task/

    cmd_sum=$(( $(cat "task/$input_file_name" | wc -l) + 1)) # 统计命令行数

    for ((cmd_point=1; cmd_point <= cmd_sum; cmd_point++))
    do
        install_cmd=$(get_task_cmd $(cat "task/$input_file_name" | awk 'NR=='${cmd_point}'{print$0}'))
        if [ ! -z "$install_cmd" ];then
            echo "${head_point}${cmd_point} $install_cmd" >> "$input_file"
        fi
    done

    rm task/$input_file_name

    end_time=$(date +'%Y-%m-%d %H:%M:%S')
    end_time_seconds=$(date --date="$end_time" +%s)
    time_span=$(( $end_time_seconds - $start_time_seconds )) # 计算相隔时间
    echo "完成, 用时: ${time_span} sec"
}


#############################


if [ ! -d "modules" ] || [ ! -d "install" ] || [ ! -d "task" ] || [ ! -d "help" ];then
    echo "目录错误"
    exit 1
elif [ ! "$(dirname "$(echo $0)")" = "." ];then
    echo "目录错误"
    exit 1
fi

if [ ! -z "$*" ];then
    echo "----------build----------"
    start_time_sum=$(date +'%Y-%m-%d %H:%M:%S')
    start_time_seconds_sum=$(date --date="$start_time_sum" +%s)
    for n in $@ ;do
        case $n in
            --fix)
                echo ":: 格式转换"
                list=$(find extra config help install modules task)
                for i in $list; do
                    if [ -f $i ];then
                    dos2unix $i
                    fi
                done
                dos2unix term-sd.sh
                dos2unix build.sh
                dos2unix README.md
                ;;
            --build)
                echo ":: 构建列表"
                build_dialog_list install/comfyui/comfyui_custom_node.sh install/comfyui/dialog_comfyui_custom_node.sh
                build_dialog_list install/comfyui/comfyui_extension.sh install/comfyui/dialog_comfyui_extension.sh
                build_dialog_list install/sd_webui/sd_webui_extension.sh install/sd_webui/dialog_sd_webui_extension.sh

                build_dialog_list_sd_webui install/sd_webui/sd_webui_extension.sh help/sd_webui_extension_description.md
                build_dialog_list_comfyui install/comfyui/comfyui_extension.sh install/comfyui/comfyui_custom_node.sh help/comfyui_extension_description.md

                build_dialog_list_model install/sd_webui/sd_webui_hf_model.sh install/sd_webui/dialog_sd_webui_hf_model.sh
                build_dialog_list_model install/sd_webui/sd_webui_ms_model.sh install/sd_webui/dialog_sd_webui_ms_model.sh

                build_dialog_list_model install/comfyui/comfyui_hf_model.sh install/comfyui/dialog_comfyui_hf_model.sh
                build_dialog_list_model install/comfyui/comfyui_ms_model.sh install/comfyui/dialog_comfyui_ms_model.sh

                build_dialog_list_model install/fooocus/fooocus_hf_model.sh install/fooocus/dialog_fooocus_hf_model.sh
                build_dialog_list_model install/fooocus/fooocus_ms_model.sh install/fooocus/dialog_fooocus_ms_model.sh

                build_dialog_list_model install/invokeai/invokeai_hf_model.sh install/invokeai/dialog_invokeai_hf_model.sh
                build_dialog_list_model install/invokeai/invokeai_ms_model.sh install/invokeai/dialog_invokeai_ms_model.sh

                build_dialog_list_model install/lora_scripts/lora_scripts_hf_model.sh install/lora_scripts/dialog_lora_scripts_hf_model.sh
                build_dialog_list_model install/lora_scripts/lora_scripts_ms_model.sh install/lora_scripts/dialog_lora_scripts_ms_model.sh
                
                build_dialog_list_model install/kohya_ss/kohya_ss_hf_model.sh install/kohya_ss/dialog_kohya_ss_hf_model.sh
                build_dialog_list_model install/kohya_ss/kohya_ss_ms_model.sh install/kohya_ss/dialog_kohya_ss_ms_model.sh
                ;;
            --sort)
                echo ":: 头标签排序"
                sort_head_point __term_sd_task_pre_model_ install/sd_webui/sd_webui_hf_model.sh
                sort_head_point __term_sd_task_pre_model_ install/sd_webui/sd_webui_ms_model.sh

                sort_head_point __term_sd_task_pre_model_ install/comfyui/comfyui_hf_model.sh
                sort_head_point __term_sd_task_pre_model_ install/comfyui/comfyui_ms_model.sh

                sort_head_point __term_sd_task_pre_model_ install/fooocus/fooocus_hf_model.sh
                sort_head_point __term_sd_task_pre_model_ install/fooocus/fooocus_ms_model.sh

                sort_head_point __term_sd_task_pre_model_ install/invokeai/invokeai_hf_model.sh
                sort_head_point __term_sd_task_pre_model_ install/invokeai/invokeai_ms_model.sh

                sort_head_point __term_sd_task_pre_model_ install/lora_scripts/lora_scripts_hf_model.sh
                sort_head_point __term_sd_task_pre_model_ install/lora_scripts/lora_scripts_ms_model.sh

                sort_head_point __term_sd_task_pre_model_ install/kohya_ss/kohya_ss_hf_model.sh
                sort_head_point __term_sd_task_pre_model_ install/kohya_ss/kohya_ss_ms_model.sh

                sort_head_point __term_sd_task_pre_ext_ install/comfyui/comfyui_custom_node.sh
                sort_head_point __term_sd_task_pre_ext_ install/comfyui/comfyui_extension.sh
                sort_head_point __term_sd_task_pre_ext_ install/sd_webui/sd_webui_extension.sh
                ;;
            *)
                echo "未知参数: \"$n\""
                ;;
        esac
    done

    echo "----------done----------"
    end_time_sum=$(date +'%Y-%m-%d %H:%M:%S')
    end_time_seconds_sum=$(date --date="$end_time_sum" +%s)
    time_span_sum=$(( $end_time_seconds_sum - $start_time_seconds_sum )) # 计算相隔时间
    echo "总共用时: ${time_span_sum} sec"
else
    echo "使用："
    echo "build.sh [--fix] [--build] [--sort]"
    echo "未指定操作"
fi
