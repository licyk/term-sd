#!/bin/bash

function mainmenu()
{
    echo "是否将快捷指令添加到shell环境中?"
    echo "添加后可使用\"termsd\"指令启动Term-SD"
    echo "1、添加"
    echo "2、删除"
    echo "3、退出"
    echo "提示:输入数字后回车"
    read -p "==>" install_to_shell_option

    if [ ! -z $install_to_shell_option ];then
        if [ $install_to_shell_option = 1 ];then
            install_config_to_shell
            exit 1
        elif [ $install_to_shell_option = 2 ];then
            remove_config_from_shell
            exit 1
        elif [ $install_to_shell_option = 3 ];then
            exit 1
        else
            echo "输入有误,请重试"
            mainmenu
        fi
    else
        echo "未输入,请重试"
        mainmenu
    fi
}

function install_config_to_shell()
{
    cd ~
    if [ $user_shell = bash ];then
        if cat ./.bashrc | grep termsd > /dev/null ;then
            echo "配置已存在,添加前请删除原有配置"
        else
            echo $term_sd_shell_config >> .bashrc
            echo "配置添加完成,重启shell以生效"
        fi
    elif [ $user_shell = zsh ];then
        if cat ./.zshrc | grep termsd > /dev/null ;then
            echo "配置已存在,添加前请删除原有配置"
        else
            echo $term_sd_shell_config >> .zshrc
            echo "配置添加完成,重启shell以生效"
        fi
    fi
    cd - > /dev/null
}

function remove_config_from_shell()
{
    cd ~
    sed -i '/termsd(){/d' ."$user_shell"rc
    echo "配置已删除,重启shell以生效"
    cd - > /dev/null
}

#################################################

term_sd_install_path=$(pwd) #读取term-sd安装位置

#将要向.bashrc写入的配置
term_sd_shell_config="termsd(){ user_input_for_term_sd=$(echo \"\$1 \$2 \$3 \$4 \$5 \$6 \$7 \$8 \$9\") ; term_sd_start_path=\$(pwd) ; cd \"$term_sd_install_path\" ; ./term-sd.sh \$user_input_for_term_sd ; cd \"\$term_sd_start_path\" > /dev/null ; }"

user_shell=$(echo $SHELL | awk -F "/" '{print $NF}') #读取用户所使用的shell

if [ $user_shell = bash ] | [ $user_shell = zsh ];then
    mainmenu
else
    echo "不支持该shell"
    exit 1
fi
