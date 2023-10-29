#!/bin/bash

#启动项目功能
function term_sd_launch()
{
    print_line_to_shell "$term_sd_manager_info 启动"
    term_sd_notice "提示:可以使用\"Ctrl+C\"终止ai软件的运行"
    if [ $term_sd_manager_info = "InvokeAI" ];then
        invokeai $(cat ./term-sd-launch.conf)
    else
        enter_venv
        python_cmd $(cat ./term-sd-launch.conf)
    fi
    print_line_to_shell
}