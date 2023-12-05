#!/bin/bash

# pytorch重装
pytorch_reinstall()
{
    if (dialog --erase-on-exit --title "Term-SD" --backtitle "pytorch重装选项" --yes-label "是" --no-label "否" --yesno "是否重新安装pytorch?" $term_sd_dialog_height $term_sd_dialog_width);then
        # 安装前的准备
        download_mirror_select # 下载镜像源选择
        pytorch_version_select # pytorch版本选择
        pip_install_mode_select # 安装方式选择
        term_sd_install_confirm # 安装前确认

        if [ $? = 0 ];then
            # 开始安装pytorch
            term_sd_print_line "pytorch安装"
            term_sd_tmp_disable_proxy
            create_venv
            enter_venv
            install_pytorch
            exit_venv
            term_sd_tmp_enable_proxy
            term_sd_echo "pytorch安装结束"
            term_sd_pause
        fi
    fi
}

# pytorch安装
install_pytorch()
{
    if [ ! -z "$(echo $pytorch_install_version | awk '{gsub(/[=+]/,"")}1')" ];then
        term_sd_watch term_sd_pip install $pytorch_install_version $pip_index_mirror $pip_extra_index_mirror $pip_find_mirror $pip_break_system_package $pip_install_mode --prefer-binary
        return $?
    else
        term_sd_echo "未指定pytorch版本,跳过安装"
        return 0
    fi
}