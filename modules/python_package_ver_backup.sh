#!/bin/bash

# Python 依赖库版本备份与恢复功能
# 使用 TERM_SD_MANAGE_OBJECT 全局变量判断要进行备份依赖的 AI 软件
python_package_ver_backup_manager() {
    local dialog_arg
    local req_file_info
    local backup_req_file_name
    # 如果没有存放备份文件的文件夹时就创建一个新的用于存放备份的依赖信息
    term_sd_mkdir "${START_PATH}"/term-sd/requirements-backup

    case "${TERM_SD_MANAGE_OBJECT}" in
        stable-diffusion-webui)
            term_sd_mkdir "${START_PATH}"/term-sd/requirements-backup/stable-diffusion-webui
            backup_req_file_name="stable-diffusion-webui"
            enter_venv "${SD_WEBUI_PATH}"
            ;;
        ComfyUI)
            term_sd_mkdir "${START_PATH}"/term-sd/requirements-backup/ComfyUI
            backup_req_file_name="ComfyUI"
            enter_venv "${COMFYUI_PATH}"
            ;;
        InvokeAI)
            term_sd_mkdir "${START_PATH}"/term-sd/requirements-backup/InvokeAI
            backup_req_file_name="InvokeAI"
            enter_venv "${INVOKEAI_PATH}"
            ;;
        Fooocus)
            term_sd_mkdir "${START_PATH}"/term-sd/requirements-backup/Fooocus
            backup_req_file_name="Fooocus"
            enter_venv "${FOOOCUS_PATH}"
            ;;
        lora-scripts)
            term_sd_mkdir "${START_PATH}"/term-sd/requirements-backup/lora-scripts
            backup_req_file_name="lora-scripts"
            enter_venv "${LORA_SCRIPTS_PATH}"
            ;;
        kohya_ss)
            term_sd_mkdir "${START_PATH}"/term-sd/requirements-backup/kohya_ss
            backup_req_file_name="kohya_ss"
            enter_venv "${KOHYA_SS_PATH}"
            ;;
    esac

    while true; do
        if term_sd_is_dir_empty "${START_PATH}"/term-sd/requirements-backup/"${backup_req_file_name}"; then
            req_file_info="无"
        else
            req_file_info=$(ls -lht "${START_PATH}"/term-sd/requirements-backup/${backup_req_file_name} --time-style=+"%Y-%m-%d" | awk 'NR==2 {print $7}' )
        fi

        dialog_arg=$(dialog --erase-on-exit --notags \
            --title "Term-SD" \
            --backtitle "${backup_req_file_name} 依赖库版本管理选项" \
            --ok-label "确认" --cancel-label "取消" \
            --menu "请选择 Term-SD 的依赖库版本管理功能\n当前 ${backup_req_file_name} 依赖库版本备份情况: ${req_file_info}" \
            $(get_dialog_size_menu) \
            "0" "> 返回" \
            "1" "> 备份 Python 依赖库版本" \
            "2" "> Python 依赖库版本管理" \
            3>&1 1>&2 2>&3)

        case "${dialog_arg}" in
            1)
                if (dialog --erase-on-exit \
                    --title "Term-SD" \
                    --backtitle "${backup_req_file_name} 依赖库版本备份选项" \
                    --yes-label "是" --no-label "否" \
                    --yesno "是否备份 ${backup_req_file_name} 依赖库 ?" \
                    $(get_dialog_size)); then

                    backup_python_package_ver "${backup_req_file_name}"

                    if [[ "$?" == 0 ]]; then
                        dialog --erase-on-exit \
                            --title "Term-SD" \
                            --backtitle "${backup_req_file_name} 依赖库版本备份选项" \
                            --ok-label "确认" \
                            --msgbox "${backup_req_file_name} 依赖库版本备份成功" \
                            $(get_dialog_size)
                    else
                        dialog --erase-on-exit \
                            --title "Term-SD" \
                            --backtitle "${backup_req_file_name} 依赖库版本备份选项" \
                            --ok-label "确认" \
                            --msgbox "${backup_req_file_name} 依赖库版本备份失败" \
                            $(get_dialog_size)
                    fi
                fi
                ;;
            2)
                python_package_ver_backup_list "${backup_req_file_name}"
                ;;
            *)
                exit_venv
                break
                ;;
        esac
    done
}

# Python 依赖库备份功能
# 使用:
# backup_python_package_ver <要备份软件包的 AI 软件名>
# 依赖信息文件保存在 <Start Path>/term-sd/requirements-backup/<要备份软件包的 AI 软件名> 中
# 获取 TERM_SD_MANAGE_OBJECT 全局变量作为文件名
backup_python_package_ver() {
    local req_file
    local backup_name=$@
    local name

    term_sd_echo "备份 ${backup_name} 的 Python 依赖库版本中"
    # 生成一个文件名
    case "${TERM_SD_MANAGE_OBJECT}" in
        stable-diffusion-webui)
            case "$(git remote get-url origin | awk -F '/' '{print $NF}')" in # 分支判断
                stable-diffusion-webui|stable-diffusion-webui.git)
                    name="stable-diffusion-webui"
                    ;;
                automatic|automatic.git)
                    name="sdnext"
                    ;;
                stable-diffusion-webui-directml|stable-diffusion-webui-directml.git|stable-diffusion-webui-amdgpu|stable-diffusion-webui-amdgpu.git)
                    name="stable-diffusion-webui-directml"
                    ;;
                stable-diffusion-webui-forge|stable-diffusion-webui-forge.git)
                    name="stable-diffusion-webui-forge"
                    ;;
                stable-diffusion-webui-reForge|stable-diffusion-webui-reForge.git)
                    name="stable-diffusion-webui-reForge"
                    ;;
                sd-webui-forge-classic|sd-webui-forge-classic.git)
                    name="sd-webui-forge-classic"
                    ;;
                *)
                    name="stable-diffusion-webui"
                    ;;
            esac
            ;;
        ComfyUI|InvokeAI|Fooocus|lora-scripts|kohya_ss)
            name=$TERM_SD_MANAGE_OBJECT
            ;;
    esac
    req_file="${name}-$(date "+%Y-%m-%d-%H-%M-%S").txt"

    # 将python依赖库中各个包和包版本备份到文件中
    get_python_env_pkg > "${START_PATH}/term-sd/requirements-backup/${backup_name}/${req_file}"
    if [[ "$?" == 0 ]]; then
        term_sd_echo "备份 ${backup_name} 依赖库版本成功"
        return 0
    else
        term_sd_echo "备份 ${backup_name} 依赖库版本失败"
        rm -f "${START_PATH}/term-sd/requirements-backup/${backup_name}/${req_file}"
        return 1
    fi
}

# 备份文件列表浏览器
# 使用:
# python_package_ver_backup_list <要备份软件包的 AI 软件名>
python_package_ver_backup_list() {
    local backup_name=$@
    while true; do
        get_dir_list "${START_PATH}/term-sd/requirements-backup/${backup_name}" # 获取当前目录下的所有文件夹

        if term_sd_is_bash_ver_lower; then # Bash 版本低于 4 时使用旧版列表显示方案
            req_file_name=$(dialog --erase-on-exit \
                --ok-label "确认" --cancel-label "取消" \
                --title "Term-SD" \
                --backtitle "${backup_name} 依赖库版本记录列表选项" \
                --menu "使用上下键请选择依赖库版本记录" \
                $(get_dialog_size_menu) \
                "-->返回<--" "<---------" \
                "${LOCAL_DIR_LIST}" \
                3>&1 1>&2 2>&3)
        else
            req_file_name=$(dialog --erase-on-exit \
                --ok-label "确认" --cancel-label "取消" \
                --title "Term-SD" \
                --backtitle "${backup_name} 依赖库版本记录列表选项" \
                --menu "使用上下键请选择依赖库版本记录" \
                $(get_dialog_size_menu) \
                "-->返回<--" "<---------" \
                "${LOCAL_DIR_LIST[@]}" \
                3>&1 1>&2 2>&3)
        fi

        if [[ "$?" == 0 ]]; then
            if [[ "${req_file_name}" == "-->返回<--" ]]; then
                break
            elif [[ -f "${START_PATH}/term-sd/requirements-backup/${backup_name}/${req_file_name}" ]]; then # 选择的是文件
                process_python_package_ver_backup "${backup_name}" "${req_file_name}"
            elif [[ -f "${START_PATH}/term-sd/requirements-backup/${backup_name}/${req_file_name}" ]]; then # 选择的是文件夹
                dialog --erase-on-exit \
                    --title "Term-SD" \
                    --backtitle "${backup_name} 依赖库版本记录列表选项" \
                    --ok-label "确认" \
                    --msgbox "选中的项目不是依赖记录文件, 请重新选择" \
                    $(get_dialog_size)
            fi
        else
            break
        fi
    done
}

# 依赖库备份文件处理选项
# 使用:
# process_python_package_ver_backup <要备份软件包的 AI 软件名> <依赖文件的文件名>
process_python_package_ver_backup() {
    local dialog_arg
    local backup_name=$1
    local req_file_name=$2

    while true; do
        dialog_arg=$(dialog --erase-on-exit --notags \
            --title "Term-SD" \
            --backtitle "依赖库版本记录管理选项" \
            --ok-label "确认" --cancel-label "取消" \
            --menu "请选择 Term-SD 的依赖库版本记录管理功能\n当前版本记录: ${req_file_name%.txt}" \
            $(get_dialog_size_menu) \
            "0" "> 返回" \
            "1" "> 恢复该版本记录" \
            "2" "> 删除该版本记录" \
            3>&1 1>&2 2>&3)
        
        case "${dialog_arg}" in
            1)
                if (dialog --erase-on-exit \
                    --title "Term-SD" \
                    --backtitle "依赖库版本恢复确认选项" \
                    --yes-label "是" --no-label "否" \
                    --yesno "是否恢复该版本记录 ?" \
                    $(get_dialog_size)); then

                    restore_python_package_ver "${backup_name}" "${req_file_name}"
                fi
                ;;
            2)
                if (dialog --erase-on-exit \
                    --title "Term-SD" \
                    --backtitle "安装确认选项" \
                    --yes-label "是" --no-label "否" \
                    --yesno "是否删除该版本记录 ?" \
                    $(get_dialog_size)); then

                    term_sd_echo "删除 ${req_file_name%.txt} 记录中"
                    rm -f "${START_PATH}/term-sd/requirements-backup/${backup_name}/${req_file_name}"
                    dialog --erase-on-exit \
                        --title "Term-SD" \
                        --backtitle "${backup_name} 依赖库版本记录列表选项" \
                        --ok-label "确认" \
                        --msgbox "${req_file_name%.txt} 记录删除完成" \
                        $(get_dialog_size)

                    break
                fi
                ;;
            *)
                break
                ;;
        esac
    done
}

# 恢复依赖库版本功能
# 使用:
# restore_python_package_ver <要备份软件包的 AI 软件名> <依赖文件的文件名>
restore_python_package_ver() {
    local backup_name=$1
    local req_file_name=$2
    local i
    local tmp_py_pkg_has_ver_list_path="${START_PATH}/term-sd/task/tmp-${TERM_SD_MANAGE_OBJECT}-python-pkg-has-vers.txt" # 含有版本的 Python 软件包列表(环境)
    local tmp_py_pkg_no_ver_list_path="${START_PATH}/term-sd/task/tmp-${TERM_SD_MANAGE_OBJECT}-python-pkg-no-vers.txt" # 无版本的 Python 软件包列表(环境)
    local tmp_py_pkg_no_ver_bak_list_path="${START_PATH}/term-sd/task/tmp-${TERM_SD_MANAGE_OBJECT}-python-pkg-no-vers-bak.txt" # 无版本的 Python 软件包列表(备份列表)
    local ipex_mirror
    # 安装前的准备
    download_mirror_select # 下载镜像源选择
    pip_install_mode_select # 安装方式选择

    if term_sd_install_confirm "是否恢复依赖库版本 ?"; then
        term_sd_print_line "Python 软件包版本恢复"
        term_sd_echo "开始恢复依赖库版本中, 版本: ${req_file_name%.txt}"
        term_sd_echo "统计需要安装和卸载的 Python 软件包中"

        rm -f "${tmp_py_pkg_has_ver_list_path}"
        rm -f "${tmp_py_pkg_no_ver_list_path}"
        rm -f "${tmp_py_pkg_no_ver_bak_list_path}"

        cat "${START_PATH}"/term-sd/requirements-backup/${backup_name}/${req_file_name} | awk -F'==' '{print $1}' | awk -F '@' '{print $1}' > "${tmp_py_pkg_no_ver_bak_list_path}" # 生成一份无版本的备份列表
        get_python_env_pkg > "${tmp_py_pkg_has_ver_list_path}" # 生成一份含有版本的现有列表

        # 生成一份软件包卸载名单
        for i in $(cat "${tmp_py_pkg_no_ver_bak_list_path}"); do
            sed -i '/'$i'==/d' "${tmp_py_pkg_has_ver_list_path}" 2> /dev/null
            sed -i '/'$i' @/d' "${tmp_py_pkg_has_ver_list_path}" 2> /dev/null
        done
        sed -i '/-e /d' "${tmp_py_pkg_has_ver_list_path}" 2> /dev/null

        cat "${tmp_py_pkg_has_ver_list_path}" | awk -F '==' '{print $1}' | awk -F '@' '{print $1}' > "${tmp_py_pkg_no_ver_list_path}" # 生成一份无版本的卸载列表

        term_sd_tmp_disable_proxy # 临时取消代理,避免一些不必要的网络减速
        if [[ ! -z "$(cat "${tmp_py_pkg_no_ver_list_path}")" ]]; then
            term_sd_print_line "Python 软件包卸载列表"
            term_sd_echo "将要卸载以下 Python 软件包"
            cat "${tmp_py_pkg_no_ver_list_path}"
            term_sd_print_line
            term_sd_echo "卸载多余 Python 软件包中"
            term_sd_pip uninstall -y -r "${tmp_py_pkg_no_ver_list_path}" # 卸载名单中的依赖包
        else
            term_sd_echo "无需卸载 Python 软件包"
        fi

        term_sd_print_line "Python 软件包安装列表"
        term_sd_echo "将要安装以下 Python 软件包"
        cat "${START_PATH}/term-sd/requirements-backup/${backup_name}/${req_file_name}"
        term_sd_print_line
        term_sd_echo "恢复依赖库版本中"
        if is_use_pip_mirror; then
            ipex_mirror="--extra-index-url https://pytorch-extension.intel.com/release-whl/stable/xpu/cn"
        else
            ipex_mirror="--extra-index-url https://pytorch-extension.intel.com/release-whl/stable/xpu/us"
        fi
        install_python_package -r "${START_PATH}/term-sd/requirements-backup/${backup_name}/${req_file_name}" --no-deps ${ipex_mirror} # 安装原有版本的依赖包
        term_sd_tmp_enable_proxy # 恢复原有的代理
        rm -f "${tmp_py_pkg_has_ver_list_path}"
        rm -f "${tmp_py_pkg_no_ver_list_path}"
        rm -f "${tmp_py_pkg_no_ver_bak_list_path}"
        term_sd_echo "恢复依赖库版本完成"
        term_sd_pause
    fi
    clean_install_config # 清理安装参数
}

# 获取 Python 软件包版本列表
get_python_env_pkg() {
    term_sd_pip freeze \
        || PIP_DISABLE_PIP_VERSION_CHECK=1 term_sd_pip list | awk 'NR>2 { if ($2 != "" && $3 == "" && $1 != "pip") {print $1 "==" $2} }'
}
