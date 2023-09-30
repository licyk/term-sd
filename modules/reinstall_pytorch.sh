#!/bin/bash

#选择重新安装pytorch
function pytorch_reinstall()
{
    #安装前的准备
    proxy_option #代理选择
    pytorch_version_select #pytorch选择
    pip_install_methon #安装方式选择
    final_install_check #安装前确认

    if [ $final_install_check_exec = 0 ];then
        #开始安装pytorch
        print_word_to_shell="pytorch安装"
        print_line_to_shell
        create_venv
        enter_venv
        pip install $pytorch_install_version $pip_mirror $extra_pip_mirror $force_pip $pip_install_methon_select --force-reinstall --default-timeout=100 --retries 5
        exit_venv
        print_line_to_shell
    fi
}