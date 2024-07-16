#!/bin/bash

# kohya_ss 安装功能
# 使用 KOHYA_SS_DOWNLOAD_MODEL_LIST 全局变量读取要下载的模型
install_kohya_ss() {
    local cmd_sum
    local cmd_point
    local i

    if [ -f "${START_PATH}/term-sd/task/kohya_ss_install.sh" ]; then # 检测到有未完成的安装任务时直接执行安装任务
        cmd_sum=$(( $(cat "${START_PATH}/term-sd/task/kohya_ss_install.sh" | wc -l) + 1 )) # 统计命令行数
        term_sd_print_line "kohya_ss 安装"
        for (( cmd_point = 1; cmd_point <= cmd_sum; cmd_point++ )); do
            term_sd_echo "kohya_ss 安装进度: [${cmd_point}/${cmd_sum}]"

            term_sd_exec_cmd "${START_PATH}/term-sd/task/kohya_ss_install.sh" "${cmd_point}"

            if [[ ! "$?" == 0 ]]; then
                if term_sd_is_use_strict_install_mode; then
                    term_sd_echo "安装命令执行失败, 终止安装程序, 请检查控制台输出的报错信息"
                    term_sd_tmp_enable_proxy # 恢复代理
                    clean_install_config # 清理安装参数
                    term_sd_pause

                    dialog --erase-on-exit \
                        --title "kohya_ss 管理" \
                        --backtitle "kohya_ss 安装结果" \
                        --ok-label "确认" \
                        --msgbox "kohya_ss 安装进程执行失败, 请重试" \
                        $(get_dialog_size)

                    return 1
                else
                    term_sd_echo "忽略执行失败的命令"
                    term_sd_echo "提示: 忽略执行失败的命令可能会导致安装不完整或者缺失文件"
                fi
            fi
        done

        term_sd_tmp_enable_proxy # 恢复代理
        clean_install_config # 清理安装参数
        term_sd_echo "kohya_ss 安装结束"
        rm -f "${START_PATH}/term-sd/task/kohya_ss_install.sh" # 删除任务文件
        term_sd_print_line

        dialog --erase-on-exit \
            --title "kohya_ss 管理" \
            --backtitle "kohya_ss 安装结果" \
            --ok-label "确认" \
            --msgbox "kohya_ss 安装结束, 选择确定进入管理界面" \
            $(get_dialog_size)

        kohya_ss_manager # 进入管理界面
    else # 生成安装任务并执行安装任务
        # 安装前的准备
        download_mirror_select auto_github_mirrror # 下载镜像源选择
        pytorch_version_select # pytorch版本选择
        kohya_ss_download_model_select # 模型选择
        pip_install_mode_select # 安装方式选择

        if term_sd_install_confirm "是否安装 kohya_ss ?"; then
            term_sd_print_line "kohya_ss 安装"
            term_sd_echo "生成安装任务中"
            term_sd_set_install_env_value >> "${START_PATH}/term-sd/task/kohya_ss_install.sh" # 环境变量
            cat "${START_PATH}/term-sd/install/kohya_ss/kohya_ss_core.sh" >> "${START_PATH}/term-sd/task/kohya_ss_install.sh" # 核心组件

            # 模型下载
            if [[ ! -z "${KOHYA_SS_DOWNLOAD_MODEL_LIST}" ]]; then
                echo "__term_sd_task_sys term_sd_echo \"下载模型中\"" >> "${START_PATH}/term-sd/task/kohya_ss_install.sh"
                if is_use_modelscope_src; then
                    # 读取模型
                    for i in ${KOHYA_SS_DOWNLOAD_MODEL_LIST}; do
                        cat "${START_PATH}/term-sd/install/kohya_ss/kohya_ss_ms_model.sh" | grep -w ${i} >> "${START_PATH}/term-sd/task/kohya_ss_install.sh" # 插件所需的模型
                    done
                else
                    # 恢复代理
                    echo "__term_sd_task_sys term_sd_tmp_enable_proxy" >> "${START_PATH}/term-sd/task/kohya_ss_install.sh"
                    for i in ${KOHYA_SS_DOWNLOAD_MODEL_LIST}; do
                        cat "${START_PATH}/term-sd/install/kohya_ss/kohya_ss_hf_model.sh" | grep -w ${i} >> "${START_PATH}/term-sd/task/kohya_ss_install.sh" # 插件所需的模型
                    done
                fi
            fi

            unset KOHYA_SS_DOWNLOAD_MODEL_LIST

            term_sd_echo "任务队列生成完成"
            term_sd_echo "开始安装 kohya_ss"

            cmd_sum=$(( $(cat "${START_PATH}/term-sd/task/kohya_ss_install.sh" | wc -l) + 1 )) # 统计命令行数
            for ((cmd_point=1; cmd_point <= cmd_sum; cmd_point++)); do
                term_sd_echo "kohya_ss 安装进度: [${cmd_point}/${cmd_sum}]"

                term_sd_exec_cmd "${START_PATH}/term-sd/task/kohya_ss_install.sh" "${cmd_point}"

                if [[ ! "$?" == 0 ]]; then
                    if term_sd_is_use_strict_install_mode; then
                        term_sd_echo "安装命令执行失败, 终止安装程序, 请检查控制台输出的报错信息"
                        term_sd_tmp_enable_proxy # 恢复代理
                        clean_install_config # 清理安装参数
                        term_sd_pause

                        dialog --erase-on-exit \
                            --title "kohya_ss 管理" \
                            --backtitle "kohya_ss 安装结果" \
                            --ok-label "确认" \
                            --msgbox "kohya_ss 安装进程执行失败, 请重试" \
                            $(get_dialog_size)

                        return 1
                    else
                        term_sd_echo "忽略执行失败的命令"
                        term_sd_echo "提示: 忽略执行失败的命令可能会导致安装不完整或者缺失文件"
                    fi
                fi
            done

            term_sd_tmp_enable_proxy # 恢复代理
            clean_install_config # 清理安装参数
            term_sd_echo "kohya_ss 安装结束"
            rm -f "${START_PATH}/term-sd/task/kohya_ss_install.sh" # 删除任务文件
            term_sd_print_line

            dialog --erase-on-exit \
                --title "kohya_ss 管理" \
                --backtitle "kohya_ss 安装结果" \
                --ok-label "确认" \
                --msgbox "kohya_ss 安装结束, 选择确定进入管理界面" \
                $(get_dialog_size)

            kohya_ss_manager # 进入管理界面
        else
            unset KOHYA_SS_DOWNLOAD_MODEL_LIST
            clean_install_config # 清理安装参数
        fi
    fi
}

# 模型选择
# 将选择的模型保存在 KOHYA_SS_DOWNLOAD_MODEL_LIST 全局变量中
kohya_ss_download_model_select() {
    local dialog_list_file

    term_sd_echo "生成模型选择列表中"
    if is_use_modelscope_src; then
        dialog_list_file="dialog_kohya_ss_ms_model.sh"
    else
        dialog_list_file="dialog_kohya_ss_hf_model.sh"
    fi

    # 模型选择
    KOHYA_SS_DOWNLOAD_MODEL_LIST=$(dialog --erase-on-exit --notags \
        --title "kohya_ss 安装" \
        --backtitle "kohya_ss 模型下载选项" \
        --ok-label "确认" --no-cancel \
        --checklist "请选择需要下载的 kohya_ss 模型\n注:\n1、模型后面括号内数字为模型的大小\n2、需要根据自己的需求勾选需要下载的模型" \
        $(get_dialog_size_menu) \
        "_null_" "=====基础模型选择=====" ON \
        $(cat "${START_PATH}/term-sd/install/kohya_ss/${dialog_list_file}") \
        3>&1 1>&2 2>&3)
}
