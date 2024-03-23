#!/bin/bash

# comfyui插件/自定义节点依赖一键安装
comfyui_extension_depend_install()
{
    # 安装前的准备
    download_mirror_select # 下载镜像源选择
    pip_install_mode_select # 安装方式选择
    term_sd_install_confirm "是否安装 ComfyUI 插件/自定义节点依赖?" # 安装前确认

    if [ $? = 0 ];then
        local comfyui_extension_depend_install_req
        local comfyui_extension_depend_install_count=0
        local comfyui_extension_depend_install_sum=0
        local depend_sum=0
        local success_count=0
        local fail_count=0

        term_sd_print_line "${term_sd_manager_info} ${1}依赖一键安装"
        term_sd_tmp_disable_proxy
        enter_venv "$comfyui_path"

        for i in * ;do # 统计需要安装的依赖
            [ -f "$i" ] && continue # 排除文件
            if [ -f "$i/install.py" ] || [ -f "$i/requirements.txt" ];then
                comfyui_extension_depend_install_count=$(( $comfyui_extension_depend_install_count + 1 ))
            fi
        done

        for i in *;do
            [ -f "$i" ] && continue # 排除文件
            cd "$i"
            if [ -f "install.py" ] || [ -f "requirements.txt" ];then
                comfyui_extension_depend_install_sum=$(( $comfyui_extension_depend_install_sum + 1 ))
                term_sd_echo "[$comfyui_extension_depend_install_sum/$comfyui_extension_depend_install_count] 安装 $(echo $i | awk -F "/" '{print $NF}') ${1}依赖"
                comfyui_extension_depend_install_req="$comfyui_extension_depend_install_req $(basename "$i"):\n" # 作为显示安装结果信息
            fi

            if [ -f "install.py" ];then # 找到install.py文件
                depend_sum=$(( $depend_sum + 1 ))
                term_sd_try term_sd_python install.py
                if [ $? = 0 ];then # 记录退出状态
                    comfyui_extension_depend_install_req="$comfyui_extension_depend_install_req     run install.py: 成功 ✓\n"
                    success_count=$((success_count + 1))
                else
                    comfyui_extension_depend_install_req="$comfyui_extension_depend_install_req     run install.py: 失败 ×\n"
                    fail_count=$((fail_count + 1))
                fi
            fi

            if [ -f "requirements.txt" ];then # 找到requirement.txt文件
                depend_sum=$(( $depend_sum + 1 ))
                term_sd_try term_sd_pip install -r requirements.txt
                if [ $? = 0 ];then # 记录退出状态
                    comfyui_extension_depend_install_req="$comfyui_extension_depend_install_req     install requirements.txt: 成功 ✓\n"
                    success_count=$((success_count + 1))
                else
                    comfyui_extension_depend_install_req="$comfyui_extension_depend_install_req     install requirements.txt: 失败 ×\n"
                    fail_count=$((fail_count + 1))
                fi
            fi
            cd ..
        done
        exit_venv
        term_sd_tmp_enable_proxy
        term_sd_print_line

        dialog --erase-on-exit \
            --title "ComfyUI管理" \
            --backtitle "ComfyUI${1}依赖安装结果" \
            --ok-label "确认" \
            --msgbox "当前依赖的安装情况列表\n[●: $depend_sum | ✓: $success_count | ×: $fail_count]\n${term_sd_delimiter}\n$comfyui_extension_depend_install_req${term_sd_delimiter}" \
            $term_sd_dialog_height $term_sd_dialog_width
    fi
}

# 单独为插件/自定义节点安装依赖的功能
comfyui_extension_depend_install_single()
{
    enter_venv "$comfyui_path"
    local comfyui_extension_depend_install_req

    if [ -f "install.py" ] || [ -f "requirements.txt" ];then
        term_sd_echo "安装 $(pwd | awk -F "/" '{print $NF}') ${1}依赖"
        comfyui_extension_depend_install_req="$comfyui_extension_depend_install_req\n $(pwd | awk -F "/" '{print $NF}')${1}:\n" # 作为显示安装结果信息
    fi

    if [ -f "install.py" ];then # 找到install.py文件
        term_sd_try term_sd_python install.py
        if [ $? = 0 ];then # 记录退出状态
            comfyui_extension_depend_install_req="$comfyui_extension_depend_install_req     run install.py: 成功 ✓\n"
        else
            comfyui_extension_depend_install_req="$comfyui_extension_depend_install_req     run install.py: 失败 ×\n"
        fi
    fi

    if [ -f "requirements.txt" ];then # 找到requirement.txt文件
        term_sd_try term_sd_pip install -r requirements.txt
        if [ $? = 0 ];then # 记录退出状态
            comfyui_extension_depend_install_req="$comfyui_extension_depend_install_req     install requirements.txt: 成功 ✓\n"
        else
            comfyui_extension_depend_install_req="$comfyui_extension_depend_install_req     install requirements.txt: 失败 ×\n"
        fi
    fi

    exit_venv

    dialog --erase-on-exit \
        --title "ComfyUI选项" \
        --backtitle "ComfyUI${1}依赖安装结果" \
        --ok-label "确认" \
        --msgbox "当前依赖的安装情况列表\n${term_sd_delimiter}\n$comfyui_extension_depend_install_req${term_sd_delimiter}" \
        $term_sd_dialog_height $term_sd_dialog_width
}

# 插件/自定义节点依赖安装(自动)
# 使用:
# comfyui_extension_depend_install_auto "提示内容" "目录"
# comfyui_custom_node_dep_notice变量用于返回安装依赖的信息
comfyui_extension_depend_install_auto()
{
    if [ -f "$2/requirements.txt" ] || [ -f "$2/install.py" ];then
        term_sd_echo "开始安装 ${2} ${1}依赖"
        comfyui_custom_node_dep_notice="$comfyui_custom_node_dep_notice\n\n${2} ${1}依赖安装:\n"
    
        enter_venv "$comfyui_path"
        cd "$2"

        if [ -f "install.py" ];then # 找到install.py文件
            term_sd_try term_sd_python install.py
            if [ $? = 0 ];then # 记录退出状态
                comfyui_custom_node_dep_notice="$comfyui_custom_node_dep_notice     run install.py: 成功 ✓\n"
            else
                comfyui_custom_node_dep_notice="$comfyui_custom_node_dep_notice     run install.py: 失败 ×\n"
            fi
        fi

        if [ -f "requirements.txt" ];then # 找到requirement.txt文件
            term_sd_try term_sd_pip install -r requirements.txt
            if [ $? = 0 ];then # 记录退出状态
                comfyui_custom_node_dep_notice="$comfyui_custom_node_dep_notice     install requirements.txt: 成功 ✓\n"
            else
                comfyui_custom_node_dep_notice="$comfyui_custom_node_dep_notice     install requirements.txt: 失败 ×\n"
            fi
        fi
        cd ..
        exit_venv
    fi
}