#!/bin/bash

# 该脚本用于生成 Dialog 界面所需的选项

# 生成插件列表
build_list() {
    local point
    local name
    local describe
    local count=1
    local flag=0
    local input_file=$1
    local output_file=$2

    while true; do
        point=$(cat ${input_file} | awk 'NR=='${count}' {print $1}')
        name=$(cat ${input_file} | awk 'NR=='${count}' {print $3}' | awk -F '/' '{print $NF}')
        describe=$(cat ${input_file} | awk 'NR=='${count}' {print $5}')

        if [[ -z "${point}" ]]; then
            break
        else
            if [[ -z "$(echo ${point} | grep __term_sd_task_sys)" ]]; then
                echo "${point} ${name} ${describe}" >> "${output_file}"
            fi
        fi
        count=$(( count + 1 ))
    done
}

# 生成模型列表
build_list_for_model() {
    local input_file=$1
    local output_file=$2
    cat "${input_file}" | awk '{if ($NF!="") {print $1 " " $(NF-1) " " $NF} }' >> "${output_file}"
}

# 生成 Dialog 列表
build_dialog_list() {
    local start_time=$(date +'%Y-%m-%d %H:%M:%S')
    local start_time_seconds=$(date --date="${start_time}" +%s)
    local input_file=$1
    local output_file=$2
    local end_time
    local end_time_seconds
    local time_span
    if [[ -f "${output_file}" ]]; then
        rm -f "${output_file}"
    fi
    echo ":: 生成 ${output_file} 中"
    build_list "${input_file}" "${output_file}"
    end_time=$(date +'%Y-%m-%d %H:%M:%S')
    end_time_seconds=$(date --date="${end_time}" +%s)
    time_span=$(( end_time_seconds - start_time_seconds )) # 计算相隔时间
    echo ":: 完成, 用时: ${time_span} sec"
}

# 生成 SD WebUI 插件说明
build_dialog_list_sd_webui() {
    local start_time=$(date +'%Y-%m-%d %H:%M:%S')
    local start_time_seconds=$(date --date="${start_time}" +%s)
    local input_file=$1
    local output_file=$2
    local cache_file="task/dialog_cache.sh"
    local flag=0
    local count=1
    local end_time
    local end_time_seconds
    local time_span
    if [[ -f "${output_file}" ]]; then
        rm -f "${output_file}"
    fi
    echo ":: 生成 ${output_file} 中"
    echo "Stable Diffusion WebUI 插件说明：" >> "${output_file}"
    echo "注：" >> "${output_file}"
    echo "1、有些插件因为年久失修，可能会出现兼容性问题。具体介绍请通过链接查看项目的说明" >> "${output_file}"
    echo "2、在名称右上角标 * 的为安装时默认勾选的插件" >> "${output_file}"

    while true; do
        extension_url=$(cat "${input_file}" | awk 'NR=='${count}' {print $3}')
        extension_name=$(cat "${input_file}" | awk 'NR=='${count}' {print $3}' | awk -F '/' '{print $NF}')
        extension_description=$(cat "${input_file}" | awk 'NR=='${count}' {print $7}')
        list_head=$(cat "${input_file}" | awk 'NR=='${count}' {print $1}')
        normal_install_info=$([ "$(cat "${input_file}" | awk 'NR=='${count}' {print $5}')" = "ON" ] && echo "*")
        if [[ -z "${list_head}" ]]; then
            break
        else
            if [[ -z "$(grep __term_sd_task_sys <<< ${list_head})" ]]; then
                echo "" >> "${output_file}"
                echo "${count}、${extension_name}${normal_install_info}"  >> "${output_file}"
                echo "描述：${extension_description}" >> "${output_file}"
                echo "链接：${extension_url}" >> "${output_file}"
            fi
        fi
        count=$(( count + 1 ))
    done
    end_time=$(date +'%Y-%m-%d %H:%M:%S')
    end_time_seconds=$(date --date="${end_time}" +%s)
    time_span=$(( end_time_seconds - start_time_seconds )) # 计算相隔时间
    echo ":: 完成, 用时: ${time_span} sec"
}

# 生成 ComfyUI 扩展说明
build_dialog_list_comfyui() {
    local start_time=$(date +'%Y-%m-%d %H:%M:%S')
    local start_time_seconds=$(date --date="${start_time}" +%s)
    local input_file_1=$1
    local input_file_2=$2
    local output_file=$3
    local count=1
    local end_time
    local end_time_seconds
    local time_span
    if [[ -f "${output_file}" ]]; then
        rm -f "${output_file}"
    fi

    echo ":: 生成 ${output_file} 中"
    echo "ComfyUI 插件 / 自定义节点说明：" >> "${output_file}"
    echo "注：" >> "${output_file}"
    echo "1、有些插件因为年久失修，可能会出现兼容性问题。具体介绍请通过链接查看项目的说明" >> "${output_file}"
    echo "2、在名称右上角标 * 的为安装时默认勾选的插件" >> "${output_file}"
    echo "" >> "${output_file}"
    echo "插件：" >> "${output_file}"

    while true; do
        extension_url=$(cat "${input_file_1}" | awk 'NR=='${count}' {print $3}')
        extension_name=$(cat "${input_file_1}" | awk 'NR=='${count}' {print $3}' | awk -F '/' '{print $NF}')
        extension_description=$(cat "${input_file_1}" | awk 'NR=='${count}' {print $7}')
        list_head=$(cat "${input_file_1}" | awk 'NR=='${count}' {print $1}')
        normal_install_info=$([ "$(cat "${input_file_1}" | awk 'NR=='${count}' {print $5}')" = "ON" ] && echo "*")
        if [[ -z "${list_head}" ]]; then
            break
        else
            if [ -z "$(echo "${list_head}" | grep __term_sd_task_sys)" ]; then
                echo "" >> "${output_file}"
                echo "${count}、${extension_name}${normal_install_info}"  >> "${output_file}"
                echo "描述：${extension_description}" >> "${output_file}"
                echo "链接：${extension_url}" >> "${output_file}"
            fi
        fi
        count=$(( count + 1 ))
    done

    echo "" >> "${output_file}"
    echo "自定义节点：" >> "${output_file}"

    count=1

    while true; do
        extension_url=$(cat "${input_file_2}" | awk 'NR=='${count}' {print $3}')
        extension_name=$(cat "${input_file_2}" | awk 'NR=='${count}' {print $3}' | awk -F '/' '{print $NF}')
        extension_description=$(cat "${input_file_2}" | awk 'NR=='${count}' {print $7}')
        list_head=$(cat "${input_file_2}" | awk 'NR=='${count}' {print $1}')
        normal_install_info=$([ "$(cat "${input_file_2}" | awk 'NR=='${count}' {print $5}')" = "ON" ] && echo "*")
        if [[ -z "${list_head}" ]]; then
            break
        else
            if [[ -z "$(echo "${list_head}" | grep __term_sd_task_sys)" ]]; then
                echo "" >> "${output_file}"
                echo "$count、${extension_name}${normal_install_info}"  >> "${output_file}"
                echo "描述：${extension_description}" >> "${output_file}"
                echo "链接：${extension_url}" >> "${output_file}"
            fi
        fi
        count=$(( count + 1 ))
    done
    end_time=$(date +'%Y-%m-%d %H:%M:%S')
    end_time_seconds=$(date --date="${end_time}" +%s)
    time_span=$(( end_time_seconds - start_time_seconds )) # 计算相隔时间
    echo ":: 完成, 用时: ${time_span} sec"
}

# 生成 InvokeAI 自定义节点说明
build_dialog_list_invokeai() {
    local start_time=$(date +'%Y-%m-%d %H:%M:%S')
    local start_time_seconds=$(date --date="${start_time}" +%s)
    local input_file=$1
    local output_file=$2
    local cache_file="task/dialog_cache.sh"
    local flag=0
    local count=1
    local end_time
    local end_time_seconds
    local time_span
    if [[ -f "${output_file}" ]]; then
        rm -f "${output_file}"
    fi
    echo ":: 生成 ${output_file} 中"
    echo "InvokeAI 自定义节点说明：" >> "${output_file}"
    echo "注：" >> "${output_file}"
    echo "1、有些插件因为年久失修，可能会出现兼容性问题。具体介绍请通过链接查看项目的说明" >> "${output_file}"
    echo "2、在名称右上角标 * 的为安装时默认勾选的插件" >> "${output_file}"

    while true; do
        extension_url=$(cat "${input_file}" | awk 'NR=='${count}' {print $3}')
        extension_name=$(cat "${input_file}" | awk 'NR=='${count}' {print $3}' | awk -F '/' '{print $NF}')
        extension_description=$(cat "${input_file}" | awk 'NR=='${count}' {print $7}')
        list_head=$(cat "${input_file}" | awk 'NR=='${count}' {print $1}')
        normal_install_info=$([ "$(cat "${input_file}" | awk 'NR=='${count}' {print $5}')" = "ON" ] && echo "*")
        if [[ -z "${list_head}" ]]; then
            break
        else
            if [[ -z "$(grep __term_sd_task_sys <<< ${list_head})" ]]; then
                echo "" >> "${output_file}"
                echo "${count}、${extension_name}${normal_install_info}"  >> "${output_file}"
                echo "描述：${extension_description}" >> "${output_file}"
                echo "链接：${extension_url}" >> "${output_file}"
            fi
        fi
        count=$(( count + 1 ))
    done
    end_time=$(date +'%Y-%m-%d %H:%M:%S')
    end_time_seconds=$(date --date="${end_time}" +%s)
    time_span=$(( end_time_seconds - start_time_seconds )) # 计算相隔时间
    echo ":: 完成, 用时: ${time_span} sec"
}

# 生成模型选择列表
build_dialog_list_model() {
    local start_time=$(date +'%Y-%m-%d %H:%M:%S')
    local start_time_seconds=$(date --date="${start_time}" +%s)
    local input_file=$1
    local output_file=$2
    local end_time
    local end_time_seconds
    local time_span
    if [[ -f "${output_file}" ]]; then
        rm -f "${output_file}"
    fi
    echo ":: 生成 ${output_file} 中"
    build_list_for_model "${input_file}" "${output_file}"
    end_time=$(date +'%Y-%m-%d %H:%M:%S')
    end_time_seconds=$(date --date="${end_time}" +%s)
    time_span=$(( end_time_seconds - start_time_seconds )) # 计算相隔时间
    echo ":: 完成, 用时: ${time_span} sec"
}

# 从列表截取命令
get_task_cmd() {
    local task_cmd_sign
    local task_cmd
    task_cmd_sign=$(echo $@ | awk '{print $1}')
    task_cmd=$(echo $@ | awk '{sub("'$task_cmd_sign' ","")}1')
    echo "${task_cmd}"
}

# 重排序标签
sort_head_point() {
    local cmd_sum
    local cmd_point
    local input_file=$2
    local input_file_name=$(basename "${input_file}")
    local start_time=$(date +'%Y-%m-%d %H:%M:%S')
    local start_time_seconds=$(date --date="${start_time}" +%s)
    local head_point=$1
    local end_time
    local end_time_seconds
    local time_span

    echo ":: 生成 ${input_file} 中"
    mv "${input_file}" task/

    cmd_sum=$(( $(cat "task/${input_file_name}" | wc -l) + 1)) # 统计命令行数

    for (( cmd_point=1; cmd_point <= cmd_sum; cmd_point++ )); do
        install_cmd=$(get_task_cmd $(cat "task/${input_file_name}" | awk 'NR=='${cmd_point}'{print $0}'))
        if [[ ! -z "${install_cmd}" ]]; then
            echo "${head_point}${cmd_point} ${install_cmd}" >> "${input_file}"
        fi
    done

    rm "task/${input_file_name}"

    end_time=$(date +'%Y-%m-%d %H:%M:%S')
    end_time_seconds=$(date --date="${end_time}" +%s)
    time_span=$(( end_time_seconds - start_time_seconds )) # 计算相隔时间
    echo ":: 完成, 用时: ${time_span} sec"
}

# 链接查重
detect_uplicate() {
    local list_type=$1
    local file_path=$2
    local cmd_sum=$(( $(cat "${file_path}" | wc -l) + 1)) # 统计命令行数
    local start_time=$(date +'%Y-%m-%d %H:%M:%S')
    local start_time_seconds=$(date --date="${start_time}" +%s)
    local end_time
    local end_time_seconds
    local time_span
    local flag=0
    local install_cmd_1
    local install_cmd_2

    if [[ "${list_type}" == "model" ]]; then
        list_column=3
        type_name="模型链接"
    elif [[ "${list_type}" == "extension" ]]; then
        list_column=4
        type_name="扩展链接"
    fi

    echo ":: 检测 $file_path 中重复的${type_name}中"

    for ((i = 1; i <= cmd_sum; i++)); do
        if [[ "${list_type}" == "model" ]]; then
            install_cmd_1=$(cat "${file_path}" | awk 'NR=='${i}' { print $3 }')
        elif [[ "${list_type}" == "extension" ]]; then
            install_cmd_1=$(cat "${file_path}" | awk 'NR=='${i}' { print $4 }')
        fi

        for (( j = i; j <= cmd_sum; j++ )); do
            [[ "${i}" = "${j}" ]] && continue

            if [[ "${list_type}" == "model" ]]; then
                install_cmd_2=$(cat "${file_path}" | awk 'NR=='${j}'{print $3}')
            elif [[ "${list_type}" = "extension" ]]; then
                install_cmd_2=$(cat "${file_path}" | awk 'NR=='${j}'{print $4}')
            fi

            if [[ "${install_cmd_1}" == "${install_cmd_2}" ]]; then
                echo ":: 检测到重复${type_name}, 出现在第 ${i} 行和第 ${j} 行"
                flag=1
            fi
        done
    done

    end_time=$(date +'%Y-%m-%d %H:%M:%S')
    end_time_seconds=$(date --date="${end_time}" +%s)
    time_span=$(( end_time_seconds - start_time_seconds )) # 计算相隔时间
    if [[ "${flag}" == 0 ]]; then
        echo ":: 无重复${type_name}"
    else
        echo ":: 出现重复${type_name}, 待解决"
    fi
    echo ":: 完成, 用时: ${time_span} sec"
}


#############################


if [[ ! -d "modules" ]] || [[ ! -d "install" ]] || [[ ! -d "task" ]] || [[ ! -d "help" ]]; then
    echo ":: 目录错误"
    exit 1
elif [[ ! "$(dirname "$0")" = "." ]]; then
    echo ":: 目录错误"
    exit 1
fi

if [[ ! -z "$@" ]]; then
    echo "----------build----------"
    start_time_sum=$(date +'%Y-%m-%d %H:%M:%S')
    start_time_seconds_sum=$(date --date="$start_time_sum" +%s)
    for n in $@ ;do
        case "${n}" in
            --fix)
                echo ":: 格式转换"
                list=$(find extra config help install modules task python_modules)
                for i in ${list}; do
                    if [[ -f "${i}" ]]; then
                    dos2unix "${i}"
                    fi
                done
                dos2unix term-sd.sh
                dos2unix build.sh
                dos2unix README.md
                ;;
            --build)
                echo ":: 构建列表"
                build_dialog_list install/sd_webui/sd_webui_extension.sh install/sd_webui/dialog_sd_webui_extension.sh
                build_dialog_list install/comfyui/comfyui_custom_node.sh install/comfyui/dialog_comfyui_custom_node.sh
                build_dialog_list install/comfyui/comfyui_extension.sh install/comfyui/dialog_comfyui_extension.sh
                build_dialog_list install/invokeai/invokeai_custom_node.sh install/invokeai/dialog_invokeai_custom_node.sh

                build_dialog_list_sd_webui install/sd_webui/sd_webui_extension.sh help/sd_webui_extension_description.md
                build_dialog_list_comfyui install/comfyui/comfyui_extension.sh install/comfyui/comfyui_custom_node.sh help/comfyui_extension_description.md
                build_dialog_list_invokeai install/invokeai/invokeai_custom_node.sh help/invokeai_custom_node_description.md

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

                sort_head_point __term_sd_task_pre_ext_ install/sd_webui/sd_webui_extension.sh
                sort_head_point __term_sd_task_pre_ext_ install/comfyui/comfyui_custom_node.sh
                sort_head_point __term_sd_task_pre_ext_ install/comfyui/comfyui_extension.sh
                sort_head_point __term_sd_task_pre_ext_ install/invokeai/invokeai_custom_node.sh
                ;;
            --check)
                echo ":: 重复链接检测"
                detect_uplicate model install/sd_webui/sd_webui_hf_model.sh
                detect_uplicate model install/sd_webui/sd_webui_ms_model.sh

                detect_uplicate model install/comfyui/comfyui_hf_model.sh
                detect_uplicate model install/comfyui/comfyui_ms_model.sh

                detect_uplicate model install/fooocus/fooocus_hf_model.sh
                detect_uplicate model install/fooocus/fooocus_ms_model.sh

                detect_uplicate model install/invokeai/invokeai_hf_model.sh
                detect_uplicate model install/invokeai/invokeai_ms_model.sh

                detect_uplicate model install/lora_scripts/lora_scripts_hf_model.sh
                detect_uplicate model install/lora_scripts/lora_scripts_ms_model.sh

                detect_uplicate model install/kohya_ss/kohya_ss_hf_model.sh
                detect_uplicate model install/kohya_ss/kohya_ss_ms_model.sh

                detect_uplicate extension install/sd_webui/sd_webui_extension.sh
                detect_uplicate extension install/comfyui/comfyui_custom_node.sh
                detect_uplicate extension install/comfyui/comfyui_extension.sh
                detect_uplicate extension install/invokeai/invokeai_custom_node.sh
                ;;
            *)
                echo ":: 未知参数: \"${n}\""
                ;;
        esac
    done

    echo "----------done----------"
    end_time_sum=$(date +'%Y-%m-%d %H:%M:%S')
    end_time_seconds_sum=$(date --date="${end_time_sum}" +%s)
    time_span_sum=$(( end_time_seconds_sum - start_time_seconds_sum )) # 计算相隔时间
    echo ":: 总共用时: ${time_span_sum} sec"
else
    echo ":: 使用："
    echo "build.sh [--fix] [--build] [--sort] [--check]"
    echo ":: 未指定操作"
fi
