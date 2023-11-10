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
	local input_file="./$1"
	local output_file="./$2"
	if [ -f "$output_file" ];then
		rm -f $output_file
	fi
	echo "生成${output_file}中"
	echo $(build_list $input_file) >> $output_file
	echo "完成"
}

if [ ! -d "./modules" ] || [ ! -d "./install" ] || [ ! -d "./task" ] || [ ! -d "./help" ];then
    echo "目录错误"
    exit 1
fi

start_time=$(date +'%Y-%m-%d %H:%M:%S')
start_time_seconds=$(date --date="$start_time" +%s)

build_dialog_list install/comfyui/comfyui_custom_node.md install/comfyui/dialog_comfyui_custom_node.md
build_dialog_list install/comfyui/comfyui_extension.md install/comfyui/dialog_comfyui_extension.md
build_dialog_list install/sd_webui/sd_webui_extension.md install/sd_webui/dialog_sd_webui_extension.md

end_time=$(date +'%Y-%m-%d %H:%M:%S')
end_time_seconds=$(date --date="$end_time" +%s)
time_span=$(( $end_time_seconds - $start_time_seconds )) # 计算相隔时间
echo "用时:${time_span} sec"
