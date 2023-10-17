#!/bin/bash

#安装python软件包功能
function manage_python_packages()
{
    proxy_option #代理选择
    pip_install_methon #安装方式选择
    pip_install_or_remove_methon #强制安装选择

    manage_python_packages_names=$(dialog --clear --title "Term-SD" --backtitle ""$term_sd_manager_info" pip软件包安装/重装/卸载选项" --ok-label "确认" --cancel-label "取消" --inputbox "请输入需要安装/重装/卸载的pip软件包名" 25 70 3>&1 1>&2 2>&3)
    if [ $? = 0 ] && [ ! -z "$(echo $manage_python_packages_names | awk '{gsub(/[=+<>]/, "")}1')" ];then
        print_line_to_shell "pip软件包$pip_install_or_remove_info"
        term_sd_notice "将"$pip_install_or_remove_info"以下python软件包"
        echo $manage_python_packages_names
        print_line_to_shell
        enter_venv
        if [ $pip_install_or_remove = 1 ];then #常规安装
            pip_cmd install $manage_python_packages_names $pip_index_mirror $pip_extra_index_mirror $pip_find_mirror $force_pip $pip_install_methon_select --default-timeout=100 --retries 5
        elif [ $pip_install_or_remove = 2 ];then #仅安装
            pip_cmd install --no-deps $manage_python_packages_names $pip_index_mirror $pip_extra_index_mirror $pip_find_mirror $force_pip $pip_install_methon_select --default-timeout=100 --retries 5
        elif [ $pip_install_or_remove = 3 ];then #强制重装
            pip_cmd install --force-reinstall $manage_python_packages_names $pip_index_mirror $pip_extra_index_mirror $pip_find_mirror $force_pip $pip_install_methon_select --default-timeout=100 --retries 5
        elif [ $pip_install_or_remove = 4 ];then #仅强制重装
            pip_cmd install --force-reinstall --no-deps $manage_python_packages_names $pip_index_mirror $pip_extra_index_mirror $pip_find_mirror $force_pip $pip_install_methon_select --default-timeout=100 --retries 5
        elif [ $pip_install_or_remove = 5 ];then #卸载
            pip_cmd uninstall -y $manage_python_packages_names
        fi

        if [ $? = 0 ];then
            print_line_to_shell
            dialog --clear --title "Term-SD" --backtitle "pip软件包"$pip_install_or_remove_info"结果" --ok-label "确认" --msgbox "以下python软件包"$pip_install_or_remove_info"成功\n------------------------------------------------------------------\n$manage_python_packages_names\n------------------------------------------------------------------" 25 70
        else
            print_line_to_shell
            dialog --clear --title "Term-SD" --backtitle "pip软件包"$pip_install_or_remove_info"结果" --ok-label "确认" --msgbox "以下python软件包"$pip_install_or_remove_info"失败\n------------------------------------------------------------------\n$manage_python_packages_names\n------------------------------------------------------------------" 25 70
        fi
    fi
}

#pip强制重装软件包功能
function pip_install_or_remove_methon()
{
    pip_install_or_remove_methon_dialog=$(dialog --clear --title "Term-SD" --backtitle "pip操作方式选项" --ok-label "确认" --no-cancel --menu "请选择pip操作方式\n1、常规安装用于安装缺失的软件包\n2、强制重装可解决软件包损坏问题,但同时重新安装软件包所需的依赖,速度较慢\n3、卸载软件包\n注:带有\"仅\"的功能是在安装时只安装用户输入的软件包,而不安装这些软件包的依赖\n安装/重装软件包时可以只写包名,也可以指定包名版本,例:\nxformers\nxformers==0.0.21" 25 70 10 \
        "1" "常规安装(install)" \
        "2" "仅安装(--no-deps)" \
        "3" "强制重装(--force-reinstall)" \
        "4" "仅强制重装(--no-deps --force-reinstall)" \
        "5" "卸载(uninstall)" \
        3>&1 1>&2 2>&3)

    if [ $pip_install_or_remove_methon_dialog = 1 ];then
        pip_install_or_remove_info="安装"
        pip_install_or_remove="1"
    elif [ $pip_install_or_remove_methon_dialog = 2 ];then
        pip_install_or_remove_info="安装(--no-deps)"
        pip_install_or_remove="2"
    elif [ $pip_install_or_remove_methon_dialog = 3 ];then
        pip_install_or_remove_info="强制重装(--force-reinstall)"
        pip_install_or_remove="3"
    elif [ $pip_install_or_remove_methon_dialog = 4 ];then
        pip_install_or_remove_info="强制重装(--no-deps --force-reinstall)"
        pip_install_or_remove="4"
    elif [ $pip_install_or_remove_methon_dialog = 5 ];then
        pip_install_or_remove_info="卸载"
        pip_install_or_remove="5"
    fi
}
