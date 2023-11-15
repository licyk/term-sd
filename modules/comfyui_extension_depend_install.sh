#!/bin/bash

# comfyui插件/自定义节点依赖一键安装
comfyui_extension_depend_install()
{
    # 安装前的准备
    download_mirror_select # 下载镜像源选择
    pip_install_mode_select # 安装方式选择
    term_sd_install_confirm # 安装前确认

    if [ $? = 0 ];then
        local comfyui_extension_depend_install_req
        local comfyui_extension_depend_install_count=0
        local comfyui_extension_depend_install_sum=0

        term_sd_print_line "$term_sd_manager_info ${1}依赖一键安装"
        term_sd_tmp_disable_proxy
        cd "$start_path/ComfyUI"
        enter_venv
        cd -

        for i in ./* ;do # 统计需要安装的依赖
            [ -f "$i" ] && continue # 排除文件
            if [ -f "./$i/install.py" ] || [ -f "./$i/requirements.txt" ];then
                comfyui_extension_depend_install_count=$(( $comfyui_extension_depend_install_count + 1 ))
            fi
        done

        for i in ./*;do
            [ -f "$i" ] && continue # 排除文件
            cd $i
            if [ -f "./install.py" ] || [ -f "./requirements.txt" ];then
                comfyui_extension_depend_install_sum=$(( $comfyui_extension_depend_install_sum + 1 ))
                term_sd_echo "[$comfyui_extension_depend_install_sum/$comfyui_extension_depend_install_count] 安装$(echo $i | awk -F "/" '{print $NF}')${1}依赖"
                comfyui_extension_depend_install_req="$comfyui_extension_depend_install_req $(echo $i | awk -F "/" '{print $NF}'):\n" # 作为显示安装结果信息
            fi

            if [ -f "./install.py" ];then # 找到install.py文件
                term_sd_watch term_sd_python install.py
                if [ $? = 0 ];then # 记录退出状态
                    comfyui_extension_depend_install_req="$comfyui_extension_depend_install_req     run install.py:成功\n"
                else
                    comfyui_extension_depend_install_req="$comfyui_extension_depend_install_req     run install.py:失败\n"
                fi
            fi

            if [ -f "./requirements.txt" ];then # 找到requirement.txt文件
                term_sd_watch term_sd_pip install -r requirements.txt
                if [ $? = 0 ];then # 记录退出状态
                    comfyui_extension_depend_install_req="$comfyui_extension_depend_install_req     install requirements.txt:成功\n"
                else
                    comfyui_extension_depend_install_req="$comfyui_extension_depend_install_req     install requirements.txt:失败\n"
                fi
            fi
            cd ..
        done
        exit_venv
        term_sd_tmp_enable_proxy
        term_sd_print_line
        dialog --erase-on-exit --title "ComfyUI管理" --backtitle "ComfyUI${1}依赖安装结果" --ok-label "确认" --msgbox "当前依赖的安装情况列表\n------------------------------------------------------------------\n$comfyui_extension_depend_install_req------------------------------------------------------------------" $term_sd_dialog_width $term_sd_dialog_height
    fi
}

# 单独为插件/自定义节点安装依赖的功能
comfyui_extension_depend_install_single()
{
    cd "$start_path/ComfyUI"
    enter_venv
    cd -
    local comfyui_extension_depend_install_req

    if [ -f "./install.py" ] || [ -f "./requirements.txt" ];then
        term_sd_echo "安装$(pwd | awk -F "/" '{print $NF}')${1}依赖"
        comfyui_extension_depend_install_req="$comfyui_extension_depend_install_req\n $(pwd | awk -F "/" '{print $NF}')${1}:\n" # 作为显示安装结果信息
    fi

    if [ -f "./install.py" ];then # 找到install.py文件
        term_sd_watch term_sd_python install.py
        if [ $? = 0 ];then # 记录退出状态
            comfyui_extension_depend_install_req="$comfyui_extension_depend_install_req     run install.py:成功\n"
        else
            comfyui_extension_depend_install_req="$comfyui_extension_depend_install_req     run install.py:失败\n"
        fi
    fi

    if [ -f "./requirements.txt" ];then # 找到requirement.txt文件
        term_sd_watch term_sd_pip install -r requirements.txt
        if [ $? = 0 ];then # 记录退出状态
            comfyui_extension_depend_install_req="$comfyui_extension_depend_install_req     install requirements.txt:成功\n"
        else
            comfyui_extension_depend_install_req="$comfyui_extension_depend_install_req     install requirements.txt:失败\n"
        fi
    fi

    exit_venv
    dialog --erase-on-exit --title "ComfyUI选项" --backtitle "ComfyUI${1}依赖安装结果" --ok-label "确认" --msgbox "当前依赖的安装情况列表\n------------------------------------------------------------------\n$comfyui_extension_depend_install_req------------------------------------------------------------------" $term_sd_dialog_width $term_sd_dialog_height
}