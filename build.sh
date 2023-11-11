#!/bin/bash

# 该脚本用于生成dialog界面所需的选项

build_list()
{
    local args_1
    local args_2
    local args_3
    local count=1
    local flag=0
    local input_file="./$@"
    
    while (($flag==0))
    do
        args_1=$(cat $input_file | awk 'NR=='${count}' {print$1}')
        args_2=$(cat $input_file | awk 'NR=='${count}' {print$4}')
        args_3=$(cat $input_file | awk 'NR=='${count}' {print$6}')
        args_2=$(echo $args_2 | awk -F '/' '{print$NF}')
        if [ -z "$args_1" ];then
            flag=1
        else
            if [ -z "$(echo $args_1 | grep __term_sd_task_sys)" ];then
                echo $args_1 $args_2 $args_3
            fi
        fi
        count=$(($count + 1))
    done
}

build_dialog_list()
{
    local start_time=$(date +'%Y-%m-%d %H:%M:%S')
    local start_time_seconds=$(date --date="$start_time" +%s)
    local input_file="./$1"
    local output_file="./$2"
    local end_time
    local end_time_seconds
    local time_span
    if [ -f "$output_file" ];then
        rm -f $output_file
    fi
    echo "生成${output_file}中"
    echo $(build_list $input_file) >> $output_file
    end_time=$(date +'%Y-%m-%d %H:%M:%S')
    end_time_seconds=$(date --date="$end_time" +%s)
    time_span=$(( $end_time_seconds - $start_time_seconds )) # 计算相隔时间
    echo "完成,用时:${time_span} sec"
}

build_dialog_list_sd_webui()
{
    local start_time=$(date +'%Y-%m-%d %H:%M:%S')
    local start_time_seconds=$(date --date="$start_time" +%s)
    local input_file="./$1"
    local output_file="./$2"
    local flag=0
    local count=1
    local end_time
    local end_time_seconds
    local time_span
    if [ -f "$output_file" ];then
        rm -f $output_file
    fi
    echo "生成${output_file}中"
    echo "AUTOMATIC1111-stable-diffusion-webui插件说明：" >> $output_file
    echo "注：有些插件因为年久失修，可能会出现兼容性问题。具体介绍请在github上搜索项目\n" >> $output_file

    while (($flag==0))
    do
        extension_url=$(cat $input_file | awk 'NR=='${count}' {print$4}')
        extension_name=$(cat $input_file | awk 'NR=='${count}' {print$4}' | awk -F '/' '{print$NF}')
        extension_description=$(cat $input_file | awk 'NR=='${count}' {print$8}')
        list_head=$(cat $input_file | awk 'NR=='${count}' {print$1}')
        if [ -z "$list_head" ];then
            flag=1
        else
            if [ -z "$(echo $list_head | grep __term_sd_task_sys)" ];then
                echo "" >> $output_file
                echo "$(( $count -1 ))、$extension_name："  >> $output_file
                echo "描述：$extension_description" >> $output_file
                echo "链接：$extension_url" >> $output_file
            fi
        fi
        count=$(($count + 1))
    done

    end_time=$(date +'%Y-%m-%d %H:%M:%S')
    end_time_seconds=$(date --date="$end_time" +%s)
    time_span=$(( $end_time_seconds - $start_time_seconds )) # 计算相隔时间
    echo "完成,用时:${time_span} sec"
}

build_dialog_list_comfyui()
{
    local start_time=$(date +'%Y-%m-%d %H:%M:%S')
    local start_time_seconds=$(date --date="$start_time" +%s)
    local input_file_1="./$1"
    local input_file_2="./$2"
    local output_file="./$3"
    local flag=0
    local count=1
    local end_time
    local end_time_seconds
    local time_span
    if [ -f "$output_file" ];then
        rm -f $output_file
    fi

    echo "生成${output_file}中"

    echo "ComfyUI插件/自定义节点说明：" >> $output_file
    echo "注：有些插件/自定义节点因为年久失修，可能会出现兼容性问题。具体介绍请在github上搜索项目" >> $output_file
    echo "" >> $output_file
    echo "插件：" >> $output_file

    while (($flag==0))
    do
        extension_url=$(cat $input_file_1 | awk 'NR=='${count}' {print$4}')
        extension_name=$(cat $input_file_1 | awk 'NR=='${count}' {print$4}' | awk -F '/' '{print$NF}')
        extension_description=$(cat $input_file_1 | awk 'NR=='${count}' {print$8}')
        list_head=$(cat $input_file_1 | awk 'NR=='${count}' {print$1}')
        if [ -z "$list_head" ];then
            flag=1
        else
            if [ -z "$(echo $list_head | grep __term_sd_task_sys)" ];then
                echo "" >> $output_file
                echo "$(( $count -1 ))、$extension_name："  >> $output_file
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
        extension_url=$(cat $input_file_2 | awk 'NR=='${count}' {print$4}')
        extension_name=$(cat $input_file_2 | awk 'NR=='${count}' {print$4}' | awk -F '/' '{print$NF}')
        extension_description=$(cat $input_file_2 | awk 'NR=='${count}' {print$8}')
        list_head=$(cat $input_file_2 | awk 'NR=='${count}' {print$1}')
        if [ -z "$list_head" ];then
            flag=1
        else
            if [ -z "$(echo $list_head | grep __term_sd_task_sys)" ];then
                echo "" >> $output_file
                echo "$(( $count -1 ))、$extension_name："  >> $output_file
                echo "描述：$extension_description" >> $output_file
                echo "链接：$extension_url" >> $output_file
            fi
        fi
        count=$(($count + 1))
    done

    end_time=$(date +'%Y-%m-%d %H:%M:%S')
    end_time_seconds=$(date --date="$end_time" +%s)
    time_span=$(( $end_time_seconds - $start_time_seconds )) # 计算相隔时间
    echo "完成,用时:${time_span} sec"
}


if [ ! -d "./modules" ] || [ ! -d "./install" ] || [ ! -d "./task" ] || [ ! -d "./help" ];then
    echo "目录错误"
    exit 1
fi

echo "----------build----------"
start_time_sum=$(date +'%Y-%m-%d %H:%M:%S')
start_time_seconds_sum=$(date --date="$start_time_sum" +%s)

build_dialog_list install/comfyui/comfyui_custom_node.md install/comfyui/dialog_comfyui_custom_node.md
build_dialog_list install/comfyui/comfyui_extension.md install/comfyui/dialog_comfyui_extension.md
build_dialog_list install/sd_webui/sd_webui_extension.md install/sd_webui/dialog_sd_webui_extension.md
build_dialog_list_sd_webui install/sd_webui/sd_webui_extension.md help/sd_webui_extension_description.md
build_dialog_list_comfyui install/comfyui/comfyui_extension.md install/comfyui/comfyui_custom_node.md help/comfyui_extension_description.md

echo "----------done----------"
end_time_sum=$(date +'%Y-%m-%d %H:%M:%S')
end_time_seconds_sum=$(date --date="$end_time_sum" +%s)
time_span_sum=$(( $end_time_seconds_sum - $start_time_seconds_sum )) # 计算相隔时间
echo "总共用时:${time_span_sum} sec"
