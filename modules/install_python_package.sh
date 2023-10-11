#!/bin/bash

#安装python软件包功能
function reinstall_python_packages()
{
    proxy_option #代理选择
    pip_install_methon #安装方式选择

    reinstall_python_packages_names=$(dialog --clear --title "Term-SD" --backtitle ""$term_sd_manager_info" pip软件包重装选项" --ok-label "确认" --cancel-label "取消" --inputbox "请输入需要重装的pip软件包名" 25 70 3>&1 1>&2 2>&3)
    if [ $? = 0 ] && [ ! -z "$(echo $reinstall_python_packages_names | awk '{gsub(/[=+<>]/, "")}1')" ];then
        print_line_to_shell "pip软件包安装"
        term_sd_notice "安装$reinstall_python_packages_names中"
        enter_venv
        "$pip_cmd" install $reinstall_python_packages_names $pip_index_mirror $pip_extra_index_mirror $pip_find_mirror $force_pip $pip_install_methon_select --force-reinstall --default-timeout=100 --retries 5
        if [ $? = 0 ];then
            print_line_to_shell
            dialog --clear --title "Term-SD" --backtitle "pip软件包安装结果" --ok-label "确认" --msgbox "以下python软件包安装成功\n------------------------------------------------------------------\n$reinstall_python_packages_names\n------------------------------------------------------------------" 25 70
        else
            print_line_to_shell
            dialog --clear --title "Term-SD" --backtitle "pip软件包安装结果" --ok-label "确认" --msgbox "以下python软件包安装失败\n------------------------------------------------------------------\n$reinstall_python_packages_names\n------------------------------------------------------------------" 25 70
        fi
    fi
}
