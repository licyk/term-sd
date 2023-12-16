#!/bin/bash

#安装python软件包功能
python_package_manager()
{
    local python_package_name
    # 安装前的准备
    download_mirror_select # 下载镜像源选择
    pip_install_mode_select # 安装方式选择
    pip_manage_package_methon_select # 强制安装选择

    python_package_name=$(dialog --erase-on-exit --title "Term-SD" --backtitle ""$term_sd_manager_info" pip软件包安装/重装/卸载选项" --ok-label "确认" --cancel-label "取消" --inputbox "请输入需要安装/重装/卸载的pip软件包名" $term_sd_dialog_height $term_sd_dialog_width 3>&1 1>&2 2>&3)
    if [ $? = 0 ] && [ ! -z "$(echo $python_package_name | awk '{gsub(/[=+<>]/, "")}1')" ];then
        term_sd_print_line "pip软件包$pip_manage_package_methon_info"
        term_sd_echo "将"$pip_manage_package_methon_info"以下python软件包"
        echo $python_package_name
        term_sd_print_line
        enter_venv

        case $pip_manage_package_methon in # 选择pip包管理器管理方法
            1) # 常规安装
                term_sd_watch term_sd_pip install $python_package_name $pip_index_mirror $pip_extra_index_mirror $pip_find_mirror $pip_break_system_package $pip_install_mode
                ;;
            2) # 仅安装
                term_sd_watch term_sd_pip install --no-deps $python_package_name $pip_index_mirror $pip_extra_index_mirror $pip_find_mirror $pip_break_system_package $pip_install_mode
                ;;
            3) # 强制重装
                term_sd_watch term_sd_pip install --force-reinstall $python_package_name $pip_index_mirror $pip_extra_index_mirror $pip_find_mirror $pip_break_system_package $pip_install_mode
                ;;
            4) # 仅强制重装
                term_sd_watch term_sd_pip install --force-reinstall --no-deps $python_package_name $pip_index_mirror $pip_extra_index_mirror $pip_find_mirror $pip_break_system_package $pip_install_mode
                ;;
            5) # 卸载
                term_sd_watch term_sd_pip uninstall -y $python_package_name
                ;;
        esac

        term_sd_echo "${pip_manage_package_methon_info}python软件包结束"

        if [ $? = 0 ];then
            term_sd_print_line
            dialog --erase-on-exit --title "Term-SD" --backtitle "pip软件包"$pip_manage_package_methon_info"结果" --ok-label "确认" --msgbox "以下python软件包"$pip_manage_package_methon_info"成功\n${term_sd_delimiter}\n$python_package_name\n${term_sd_delimiter}" $term_sd_dialog_height $term_sd_dialog_width
        else
            term_sd_print_line
            dialog --erase-on-exit --title "Term-SD" --backtitle "pip软件包"$pip_manage_package_methon_info"结果" --ok-label "确认" --msgbox "以下python软件包"$pip_manage_package_methon_info"失败\n${term_sd_delimiter}\n$python_package_name\n${term_sd_delimiter}" $term_sd_dialog_height $term_sd_dialog_width
        fi
    fi
}

# pip管理软件包方法选择
pip_manage_package_methon_select()
{
    local pip_manage_package_methon_select_dialog

    pip_manage_package_methon_select_dialog=$(
        dialog --erase-on-exit --notags --title "Term-SD" --backtitle "pip操作方式选项" --ok-label "确认" --no-cancel --menu "请选择pip操作方式\n1、常规安装用于安装缺失的软件包\n2、强制重装可解决软件包损坏问题,但同时重新安装软件包所需的依赖,速度较慢\n3、卸载软件包\n注:带有\"仅\"的功能是在安装时只安装用户输入的软件包,而不安装这些软件包的依赖\n安装/重装软件包时可以只写包名,也可以指定包名版本\n可以输入多个软件包的包名,并使用空格隔开\n例:\nxformers\nxformers==0.0.21\nxformers==0.0.21 numpy" $term_sd_dialog_height $term_sd_dialog_width $term_sd_dialog_menu_height \
        "1" "> 常规安装(install)" \
        "2" "> 仅安装(--no-deps)" \
        "3" "> 强制重装(--force-reinstall)" \
        "4" "> 仅强制重装(--no-deps --force-reinstall)" \
        "5" "> 卸载(uninstall)" \
        3>&1 1>&2 2>&3)

    if [ $? = 0 ];then
        case $pip_manage_package_methon_select_dialog in
            1)
                pip_manage_package_methon_info="安装"
                pip_manage_package_methon="1"
                ;;
            2)
                pip_manage_package_methon_info="安装(--no-deps)"
                pip_manage_package_methon="2"
                ;;
            3)
                pip_manage_package_methon_info="强制重装(--force-reinstall)"
                pip_manage_package_methon="3"
                ;;
            4)
                pip_manage_package_methon_info="强制重装(--no-deps --force-reinstall)"
                pip_manage_package_methon="4"
                ;;
            5)
                pip_manage_package_methon_info="卸载"
                pip_manage_package_methon="5"
                ;;
        esac
    fi
}

# python软件包更新
python_package_update()
{
    cat "$@" > tmp-python-package-update-list.txt # 生成要更新的软件包名单
    local ignore_update_python_package_list="torch torchvision torchaudio xformers InvokeAI bitsandbytes" # 忽略更新的软件包名单
    for i in $ignore_update_python_package_list; do
        sed -i '/'$i'/d' tmp-python-package-update-list.txt 2> /dev/null  # 将忽略的软件包从名单删除
    done
    # 更新python软件包
    term_sd_watch term_sd_pip install -r tmp-python-package-update-list.txt --prefer-binary --upgrade $pip_index_mirror $pip_extra_index_mirror $pip_find_mirror $pip_break_system_package $pip_break_system_package
    rm -rf tmp-python-package-update-list.txt # 删除列表缓存
}