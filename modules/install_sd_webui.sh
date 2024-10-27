#!/bin/bash

# SD WebUI 安装
# 使用 SD_WEBUI_INSTALL_EXTENSION_LIST 全局变量读取需要安装的 SD WebUI 插件
# 使用 SD_WEBUI_DOWNLOAD_MODEL_LIST 全局变量读取需要下载的模型
install_sd_webui() {
    local cmd_sum
    local cmd_point
    local i

    if [[ -f "${START_PATH}/term-sd/task/sd_webui_install.sh" ]]; then # 检测到有未完成的安装任务时直接执行安装任务
        cmd_sum=$(( $(cat "${START_PATH}/term-sd/task/sd_webui_install.sh" | wc -l) + 1 )) # 统计命令行数
        term_sd_print_line "Stable-Diffusion-WebUI 安装"
        for (( cmd_point=1; cmd_point <= cmd_sum; cmd_point++ )); do
            term_sd_echo "Stable-Diffusion-WebUI 安装进度: [${cmd_point}/${cmd_sum}]"

            term_sd_exec_cmd "${START_PATH}/term-sd/task/sd_webui_install.sh" "${cmd_point}"

            if [[ ! "$?" == 0 ]]; then
                if term_sd_is_use_strict_install_mode; then
                    term_sd_echo "安装命令执行失败, 终止安装程序, 请检查控制台输出的报错信息"
                    term_sd_tmp_enable_proxy # 恢复代理
                    clean_install_config # 清理安装参数
                    term_sd_pause

                    dialog --erase-on-exit \
                        --title "Stable-Diffusion-WebUI 管理" \
                        --backtitle "Stable-Diffusion-WebUI 安装结果" \
                        --ok-label "确认" \
                        --msgbox "Stable-Diffusion-WebUI 安装进程执行失败, 请重试" \
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
        term_sd_echo "Stable-Diffusion-WebUI 安装结束"
        rm -f "${START_PATH}/term-sd/task/sd_webui_install.sh" # 删除任务文件
        term_sd_print_line

        dialog --erase-on-exit \
            --title "Stable-Diffusion-WebUI 管理" \
            --backtitle "Stable-Diffusion-WebUI 安装结果" \
            --ok-label "确认" \
            --msgbox "Stable-Diffusion-WebUI 安装结束, 选择确定进入管理界面" \
            $(get_dialog_size)

        sd_webui_manager # 进入管理界面
    else # 生成安装任务并执行安装任务
        # 安装前的准备
        download_mirror_select # 下载镜像源选择
        pytorch_version_select # PyTorch 版本选择
        select_install_sd_webui_branch # 分支选择
        sd_webui_extension_install_select # 插件选择
        sd_webui_download_model_select # 模型选择
        pip_install_mode_select # 安装方式选择

        if term_sd_install_confirm "是否安装 Stable-Diffusion-WebUI ?"; then
            term_sd_print_line "Stable-Diffusion-WebUI 安装"
            term_sd_echo "生成安装任务中"
            term_sd_set_install_env_value >> "${START_PATH}/term-sd/task/sd_webui_install.sh" # 环境变量
            cat "${START_PATH}/term-sd/install/sd_webui/sd_webui_core.sh" >> "${START_PATH}/term-sd/task/sd_webui_install.sh" # 核心组件

            echo "__term_sd_task_sys term_sd_tmp_enable_proxy" >> "${START_PATH}/term-sd/task/sd_webui_install.sh"

            # 读取插件安装命令
            if [[ ! -z "${SD_WEBUI_INSTALL_EXTENSION_LIST}" ]]; then
                echo "__term_sd_task_sys term_sd_echo \"安装插件中\"" >> "${START_PATH}/term-sd/task/sd_webui_install.sh"
                # 从插件列表读取插件安装命令
                for i in ${SD_WEBUI_INSTALL_EXTENSION_LIST}; do
                    cat "${START_PATH}/term-sd/install/sd_webui/sd_webui_extension.sh" | grep -w ${i} | awk '{sub(" ON "," ") ; sub(" OFF "," ")}1' >> "${START_PATH}/term-sd/task/sd_webui_install.sh" # 插件
                done
            fi

            echo "__term_sd_task_sys term_sd_tmp_disable_proxy" >> "${START_PATH}/term-sd/task/sd_webui_install.sh"

            # 读取模型下载命令
            if [[ ! -z "${SD_WEBUI_DOWNLOAD_MODEL_LIST}" ]]; then
                echo "__term_sd_task_sys term_sd_echo \"下载模型中\"" >> "${START_PATH}/term-sd/task/sd_webui_install.sh"
                if is_use_modelscope_src; then
                    # 读取模型
                    for i in ${SD_WEBUI_DOWNLOAD_MODEL_LIST}; do
                        cat "${START_PATH}/term-sd/install/sd_webui/sd_webui_ms_model.sh" | grep -w ${i} >> "${START_PATH}/term-sd/task/sd_webui_install.sh" # 插件所需的模型
                    done
                    # 读取插件的模型
                    for i in ${SD_WEBUI_DOWNLOAD_MODEL_LIST}; do
                        cat "${START_PATH}/term-sd/install/sd_webui/sd_webui_extension_ms_model.sh" | grep -w ${i} >> "${START_PATH}/term-sd/task/sd_webui_install.sh" # 插件所需的模型
                    done
                else
                    # 恢复代理
                    echo "__term_sd_task_sys term_sd_tmp_enable_proxy" >> "${START_PATH}/term-sd/task/sd_webui_install.sh"
                    # 读取模型
                    for i in ${SD_WEBUI_DOWNLOAD_MODEL_LIST}; do
                        cat "${START_PATH}/term-sd/install/sd_webui/sd_webui_hf_model.sh" | grep -w ${i} >> "${START_PATH}/term-sd/task/sd_webui_install.sh" # 插件所需的模型
                    done
                    # 读取插件的模型
                    for i in ${SD_WEBUI_DOWNLOAD_MODEL_LIST}; do
                        cat "${START_PATH}/term-sd/install/sd_webui/sd_webui_extension_hf_model.sh" | grep -w ${i} >> "${START_PATH}/term-sd/task/sd_webui_install.sh" # 插件所需的模型
                    done
                fi
            fi

            unset SD_WEBUI_INSTALL_EXTENSION_LIST
            unset SD_WEBUI_DOWNLOAD_MODEL_LIST

            term_sd_echo "任务队列生成完成"
            term_sd_echo "开始安装 Stable-Diffusion-WebUI"

            # 执行安装命令
            cmd_sum=$(( $(cat "${START_PATH}/term-sd/task/sd_webui_install.sh" | wc -l) + 1 )) # 统计命令行数
            for ((cmd_point=1; cmd_point <= cmd_sum; cmd_point++)); do
                term_sd_echo "Stable-Diffusion-WebUI 安装进度: [${cmd_point}/${cmd_sum}]"

                term_sd_exec_cmd "${START_PATH}/term-sd/task/sd_webui_install.sh" "${cmd_point}"

                if [[ ! "$?" == 0 ]]; then
                    if term_sd_is_use_strict_install_mode; then
                        term_sd_echo "安装命令执行失败, 终止安装程序, 请检查控制台输出的报错信息"
                        term_sd_tmp_enable_proxy # 恢复代理
                        clean_install_config # 清理安装参数
                        term_sd_pause

                        dialog --erase-on-exit \
                            --title "Stable-Diffusion-WebUI 管理" \
                            --backtitle "Stable-Diffusion-WebUI 安装结果" \
                            --ok-label "确认" \
                            --msgbox "Stable-Diffusion-WebUI 安装进程执行失败, 请重试" \
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
            term_sd_echo "Stable-Diffusion-WebUI 安装结束"
            rm -f "${START_PATH}/term-sd/task/sd_webui_install.sh" # 删除任务文件
            term_sd_print_line

            dialog --erase-on-exit \
                --title "Stable-Diffusion-WebUI 管理" \
                --backtitle "Stable-Diffusion-WebUI 安装结果" \
                --ok-label "确认" \
                --msgbox "Stable-Diffusion-WebUI 安装结束, 选择确定进入管理界面\n注: 初次启动 Stable-Diffusion-WebUI 时将会进行一次依赖完整性检查, 耗时较久" \
                $(get_dialog_size)

            sd_webui_manager # 进入管理界面
        else
            unset SD_WEBUI_INSTALL_EXTENSION_LIST
            unset SD_WEBUI_DOWNLOAD_MODEL_LIST
            clean_install_config # 清理安装参数
        fi
    fi
}

# 插件选择
# 将选择的插件保存在 SD_WEBUI_INSTALL_EXTENSION_LIST 全局变量中
sd_webui_extension_install_select() {
    SD_WEBUI_INSTALL_EXTENSION_LIST=$(dialog --erase-on-exit --notags \
        --title "Stable-Diffusion-WebUI 安装" \
        --backtitle "Stable-Diffusion-WebUI 插件安装选项" \
        --ok-label "确认" --no-cancel \
        --checklist "请选择需要安装的 Stable-Diffusion-WebUI 插件" \
        $(get_dialog_size_menu) \
        $(cat "${START_PATH}/term-sd/install/sd_webui/dialog_sd_webui_extension.sh") \
        3>&1 1>&2 2>&3)
}

# 模型选择
# 将选择的模型保存在 SD_WEBUI_DOWNLOAD_MODEL_LIST 全局变量中
sd_webui_download_model_select() {
    local dialog_list_file
    local model_list
    local sd_webui_model_list_file
    local i
    # 插件模型列表选择
    if is_use_modelscope_src; then
        dialog_list_file="sd_webui_extension_ms_model.sh"
        sd_webui_model_list_file="dialog_sd_webui_ms_model.sh"
    else
        dialog_list_file="sd_webui_extension_hf_model.sh"
        sd_webui_model_list_file="dialog_sd_webui_hf_model.sh"
    fi

    term_sd_echo "生成模型选择列表中"
    # 查找插件对应模型的编号
    for i in ${SD_WEBUI_INSTALL_EXTENSION_LIST}; do
        model_list="${model_list} $(cat "${START_PATH}"/term-sd/install/sd_webui/${dialog_list_file} | grep -w ${i} | awk 'NR==1{if ($NF!="") {print $1 " " $(NF-1) " " $NF} }')"
    done

    # 模型选择(包含基础模型和插件的模型)
    SD_WEBUI_DOWNLOAD_MODEL_LIST=$(dialog --erase-on-exit --notags \
        --title "Stable-Diffusion-WebUI 安装" \
        --backtitle "Stable-Diffusion-WebUI 模型下载选项" \
        --ok-label "确认" --no-cancel \
        --checklist "请选择需要下载的 Stable-Diffusion-WebUI 模型\n注:\n1、模型后面括号内数字为模型的大小\n2、需要根据自己的需求勾选需要下载的模型" \
        $(get_dialog_size_menu) \
        "_null_" "=====基础模型选择=====" ON \
        $(cat "${START_PATH}/term-sd/install/sd_webui/${sd_webui_model_list_file}") \
        "_null_" "=====插件模型选择=====" ON \
        ${model_list} \
        3>&1 1>&2 2>&3)
}

# 写入 SD WebUI 配置文件
# 保存在 <SD WebUI Path>/config.json 中
set_sd_webui_normal_config() {
    term_sd_echo "写入 Stable-Diffusion-WebUI 默认配置中"
    cp -f "${START_PATH}/term-sd/install/sd_webui/sd_webui_config.json" "${SD_WEBUI_PATH}"/config.json
}

# SD WebUI 分支选择
# 通过 SD_WEBUI_REPO 全局变量设置 SD WebUI 分支的 Git 链接
# 通过 SD_WEBUI_BRANCH 设置要切换到的 SD WebUI 分支
select_install_sd_webui_branch() {
    local dialog_arg

    dialog_arg=$(dialog --erase-on-exit --notags \
        --title "Stable-Diffusion-WebUI 安装" \
        --backtitle "Stable-Diffusion-WebUI 分支选择选项" \
        --ok-label "确认" --no-cancel \
        --menu "请选择要安装的 Stable-Diffusion-WebUI 分支, 注:\n1. 推荐使用 AUTOMATIC1111 - Stable-Diffusion-WebUI 分支, 稳定性较高\n2.如果有 FLUX 模型的需求或者更好的显存优化, 可选择 lllyasviel - Stable-Diffusion-WebUI-Forge 分支, 但该分支可能会导致部分插件不兼容\n3. Panchovix - stable-diffusion-webui-reForge 分支基于 lllyasviel - Stable-Diffusion-WebUI-Forge 分支, 使用 Gradio3 前端, 对插件的兼容性好一些" \
        $(get_dialog_size_menu) \
        "1" "> AUTOMATIC1111 - Stable-Diffusion-WebUI 主分支" \
        "2" "> AUTOMATIC1111 - Stable-Diffusion-WebUI 测试分支" \
        "3" "> lllyasviel - Stable-Diffusion-WebUI-Forge 分支" \
        "4" "> Panchovix - stable-diffusion-webui-reForge 主分支" \
        "5" "> Panchovix - stable-diffusion-webui-reForge 测试分支" \
        "6" "> lshqqytiger - Stable-Diffusion-WebUI-AMDGPU 分支" \
        "7" "> vladmandic - SD.NEXT 主分支" \
        "8" "> vladmandic - SD.NEXT 测试分支" \
        3>&1 1>&2 2>&3)

    case "${dialog_arg}" in
        1)
            SD_WEBUI_REPO="https://github.com/AUTOMATIC1111/stable-diffusion-webui"
            SD_WEBUI_BRANCH="master"
            ;;
        2)
            SD_WEBUI_REPO="https://github.com/AUTOMATIC1111/stable-diffusion-webui"
            SD_WEBUI_BRANCH="dev"
            ;;
        3)
            SD_WEBUI_REPO="https://github.com/lllyasviel/stable-diffusion-webui-forge"
            SD_WEBUI_BRANCH="main"
            ;;
        4)
            SD_WEBUI_REPO="https://github.com/Panchovix/stable-diffusion-webui-reForge"
            SD_WEBUI_BRANCH="main"
            ;;
        5)
            SD_WEBUI_REPO="https://github.com/Panchovix/stable-diffusion-webui-reForge"
            SD_WEBUI_BRANCH="dev_upstream"
            ;;
        6)
            SD_WEBUI_REPO="https://github.com/lshqqytiger/stable-diffusion-webui-amdgpu"
            SD_WEBUI_BRANCH="master"
            ;;
        7)
            SD_WEBUI_REPO="https://github.com/vladmandic/automatic"
            SD_WEBUI_BRANCH="master"
            ;;
        8)
            SD_WEBUI_REPO="https://github.com/vladmandic/automatic"
            SD_WEBUI_BRANCH="dev"
            ;;
        *)
            SD_WEBUI_REPO="https://github.com/AUTOMATIC1111/stable-diffusion-webui"
            SD_WEBUI_BRANCH="master"
            ;;
    esac

    if term_sd_is_debug; then
        term_sd_echo "SD WebUI 远程地址: ${SD_WEBUI_REPO}"
        term_sd_echo "SD WebUI 分支: ${SD_WEBUI_BRANCH}"
    fi
}

# 切换 SD WebUI 的分支
# 使用:
# switch_sd_webui_branch <SD WebUI 的分支>
switch_sd_webui_branch() {
    local branch=$@

    term_sd_echo "检查 Stable-Diffusion-WebUI 子模块状态"
    if [[ ! -z "$(git -C "${SD_WEBUI_PATH}" submodule status)" ]]; then # 检测是否有子模块
        term_sd_echo "初始化 Git 子模块"
        use_submodules="--recurse-submodules"
        git -C "${SD_WEBUI_PATH}" submodule update --init --recursive || return 1
    else
        term_sd_echo "禁用 Git 子模块"
        use_submodules=""
        git -C "${SD_WEBUI_PATH}" submodule deinit --all -f || return 1
    fi

    term_sd_echo "切换 Stable-Diffusion-WebUI 分支至 ${branch}"
    git -C "${SD_WEBUI_PATH}" checkout "${branch}" ${use_submodules} || return 1
}