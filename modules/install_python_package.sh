#!/bin/bash

#安装python软件包功能
function reinstall_python_packages()
{
    proxy_option #代理选择
    pip_install_methon #安装方式选择

    reinstall_python_packages_names=$(dialog --clear --title "Term-SD" --backtitle ""$term_sd_manager_info" pip软件包重装选项" --ok-label "确认" --cancel-label "取消" --inputbox "请输入需要重装的pip软件包名" 23 70 3>&1 1>&2 2>&3)

    if [ ! -z "$(echo $install_python_packages_names | awk '{gsub(/[=+<>]/, "")}1')" ];then
        print_line_to_shell "pip软件包安装"
        enter_venv
        "$pip_cmd" install $reinstall_python_packages_names $pip_index_mirror $pip_extra_index_mirror $pip_find_mirror $force_pip $pip_install_methon_select --force-reinstall --default-timeout=100 --retries 5
        if [ $? = 0 ];then
            print_line_to_shell
            dialog --clear --title "Term-SD" --backtitle "pip软件包安装结果" --ok-label "确认" --msgbox ""$term_sd_manager_info"安装成功" 23 70
        else
            print_line_to_shell
            dialog --clear --title "Term-SD" --backtitle "pip软件包安装结果" --ok-label "确认" --msgbox ""$term_sd_manager_info"安装失败" 23 70
        fi
    fi
}