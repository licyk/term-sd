#!/bin/bash

#comfyui插件/自定义节点依赖一键安装部分
function comfyui_extension_depend_install()
{
    if [ $comfyui_extension_info = 1 ];then
        comfyui_extension_info_display="自定义节点"
    else
        comfyui_extension_info_display="插件"
    fi

    proxy_option #代理选择
    pip_install_methon #安装方式选择
    final_install_check #安装前确认
    if [ $final_install_check_exec = 0 ];then
        comfyui_extension_depend_install_process
    fi
}

#comfyui插件/自定义节点依赖一键安装
function comfyui_extension_depend_install_process()
{
    print_line_to_shell "$term_sd_manager_info "$comfyui_extension_info_display"依赖一键安装"
    tmp_disable_proxy
    cd "$start_path/ComfyUI"
    enter_venv
    cd -
    dep_info="" #清除上次运行结果
    extension_dep_to_install="0"
    extension_dep_to_install_="0"

    for i in ./* ;do #统计需要安装的依赖
        [ -f "$i" ] && continue #排除文件
        if [ -f "./$i/install.py" ] || [ -f "./$i/requirements.txt" ];then
            extension_dep_to_install=$(( $extension_dep_to_install + 1 ))
        fi
    done

    for i in ./*;do
        [ -f "$i" ] && continue #排除文件
        cd $i
        if [ -f "./install.py" ] || [ -f "./requirements.txt" ];then
            extension_dep_to_install_=$(( $extension_dep_to_install_ + 1 ))
            term_sd_notice "[$extension_dep_to_install_/$extension_dep_to_install] 安装$(echo $i | awk -F "/" '{print $NF}')"$comfyui_extension_info_display"依赖"
            dep_info="$dep_info $(echo $i | awk -F "/" '{print $NF}'):\n" #作为显示安装结果信息
        fi

        if [ -f "./install.py" ];then #找到install.py文件
            python_cmd install.py
            if [ $? = 0 ];then #记录退出状态
                dep_info="$dep_info     run install.py:成功\n"
            else
                dep_info="$dep_info     run install.py:失败\n"
            fi
        fi

        if [ -f "./requirements.txt" ];then #找到requirement.txt文件
            pip_cmd install -r requirements.txt
            if [ $? = 0 ];then #记录退出状态
                dep_info="$dep_info     install requirements.txt:成功\n"
            else
                dep_info="$dep_info     install requirements.txt:失败\n"
            fi
        fi
        cd ..
    done
    exit_venv
    tmp_enable_proxy
    print_line_to_shell
    dialog --clear --title "ComfyUI管理" --backtitle "ComfyUI"$comfyui_extension_info_display"依赖安装结果" --ok-label "确认" --msgbox "当前依赖的安装情况列表\n------------------------------------------------------------------\n$dep_info------------------------------------------------------------------" 25 70
}

#单独为插件/自定义节点安装依赖的功能
function comfyui_extension_depend_install_single()
{
    if [ $comfyui_extension_info = 1 ];then
        comfyui_extension_info_display="自定义节点"
    else
        comfyui_extension_info_display="插件"
    fi

    cd "$start_path/ComfyUI"
    enter_venv
    cd -
    dep_info="" #清除上次运行结果

    if [ -f "./install.py" ] || [ -f "./requirements.txt" ];then
        term_sd_notice "安装$(echo $comfyui_custom_node_selection | awk -F "/" '{print $NF}')"$comfyui_extension_info_display"依赖"
        dep_info="$dep_info\n $(echo $comfyui_custom_node_selection | awk -F "/" '{print $NF}')"$comfyui_extension_info_display":\n" #作为显示安装结果信息
    fi

    if [ -f "./install.py" ];then #找到install.py文件
        python_cmd install.py
        if [ $? = 0 ];then #记录退出状态
            dep_info="$dep_info     run install.py:成功\n"
        else
            dep_info="$dep_info     run install.py:失败\n"
        fi
    fi

    if [ -f "./requirements.txt" ];then #找到requirement.txt文件
        pip_cmd install -r requirements.txt
        if [ $? = 0 ];then #记录退出状态
            dep_info="$dep_info     install requirements.txt:成功\n"
        else
            dep_info="$dep_info     install requirements.txt:失败\n"
        fi
    fi

    exit_venv
    dialog --clear --title "ComfyUI选项" --backtitle "ComfyUI"$comfyui_extension_info_display"依赖安装结果" --ok-label "确认" --msgbox "当前依赖的安装情况列表\n------------------------------------------------------------------\n$dep_info------------------------------------------------------------------" 25 70
}