#!/bin/bash

#安装python软件包功能
function reinstall_python_packages()
{
    proxy_option #代理选择
    pip_install_methon #安装方式选择
    pip_force_reinstall_methon #强制安装选择

    reinstall_python_packages_names=$(dialog --clear --title "Term-SD" --backtitle ""$term_sd_manager_info" pip软件包重装选项" --ok-label "确认" --cancel-label "取消" --inputbox "请输入需要重装的pip软件包名" 25 70 3>&1 1>&2 2>&3)
    if [ $? = 0 ] && [ ! -z "$(echo $reinstall_python_packages_names | awk '{gsub(/[=+<>]/, "")}1')" ];then
        print_line_to_shell "pip软件包安装"
        term_sd_notice "安装$reinstall_python_packages_names中"
        enter_venv
        "$pip_cmd" install $reinstall_python_packages_names $pip_index_mirror $pip_extra_index_mirror $pip_find_mirror $force_pip $pip_install_methon_select $pip_force_reinstall --default-timeout=100 --retries 5
        if [ $? = 0 ];then
            print_line_to_shell
            dialog --clear --title "Term-SD" --backtitle "pip软件包安装结果" --ok-label "确认" --msgbox "以下python软件包安装成功\n------------------------------------------------------------------\n$reinstall_python_packages_names\n------------------------------------------------------------------" 25 70
        else
            print_line_to_shell
            dialog --clear --title "Term-SD" --backtitle "pip软件包安装结果" --ok-label "确认" --msgbox "以下python软件包安装失败\n------------------------------------------------------------------\n$reinstall_python_packages_names\n------------------------------------------------------------------" 25 70
        fi
    fi
}

#pip强制重装软件包功能
function pip_force_reinstall_methon()
{
    pip_force_reinstall_methon_dialog=$(dialog --clear --title "Term-SD" --backtitle "pip强制重装选项" --ok-label "确认" --no-cancel --menu "请选择pip安装方式\n1、常规安装用于安装缺失的软件包\n2、强制重装可解决软件包损坏问题,但同时重新安装软件包所需的依赖,速度较慢" 25 70 10 \
        "1" "常规安装" \
        "2" "强制重装(--force-reinstall)" \
        3>&1 1>&2 2>&3)

    if [ $pip_force_reinstall_methon_dialog = 1 ];then
        pip_force_reinstall=""
    elif [ $pip_force_reinstall_methon_dialog = 2 ];then
        pip_force_reinstall="--force-reinstall"
    fi
}
