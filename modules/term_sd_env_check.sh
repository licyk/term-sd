#!/bin/bash

# 检查 ComfyUI 环境完整性
# 如果出现缺失依赖, 将依赖文件路径保存在 <Term-SD>/term-sd/task/comfyui_depend_path_list.sh
# 如何出现冲突依赖, 将分析出来的冲突情况保存在 <Term-SD>/term-sd/task/comfyui_has_conflict_requirement_notice.sh
check_comfyui_env() {
    term_sd_echo "检测 ComfyUI 依赖完整性中"
    rm -f "${START_PATH}/term-sd/task/comfyui_has_conflict_requirement_notice.sh"
    rm -f "${START_PATH}/term-sd/task/comfyui_depend_path_list.sh"

    term_sd_python "${START_PATH}/term-sd/python_modules/check_comfyui_env.py" \
        --comfyui-path "${COMFYUI_ROOT_PATH}" \
        --conflict-depend-notice-path "${START_PATH}/term-sd/task/comfyui_has_conflict_requirement_notice.sh" \
        --requirement-list-path "${START_PATH}/term-sd/task/comfyui_depend_path_list.sh"

    if [[ -f "${START_PATH}/term-sd/task/comfyui_has_conflict_requirement_notice.sh" ]]; then
        term_sd_echo "检测到当前 ComfyUI 环境中安装的插件之间存在依赖冲突情况, 该问题并非致命, 但建议只保留一个插件, 否则部分功能可能无法正常使用"
        term_sd_echo "可在 Term-SD 中的 ComfyUI 管理 -> 管理自定义节点 -> 管理自定义节点 中禁用插件或者卸载插件"
        term_sd_echo "您可以选择按顺序安装依赖, 由于这将向环境中安装不符合版本要求的组件, 您将无法完全解决此问题, 但可避免组件由于依赖缺失而无法启动的情况"
        term_sd_echo "您通常情况下可以选择忽略该警告并继续运行"
        term_sd_print_line "依赖冲突"
        term_sd_echo "检测到冲突的依赖:"
        cat "${START_PATH}/term-sd/task/comfyui_has_conflict_requirement_notice.sh"
        term_sd_print_line
        term_sd_echo "是否按顺序安装冲突依赖 (yes/no) ?"
        term_sd_echo "提示:"
        term_sd_echo "如果不选择按顺序安装冲突依赖, 则跳过安装冲突依赖直接运行 ComfyUI"
        term_sd_echo "输入 yes 或 no 后回车"

        case $(term_sd_read) in
            yes|YES|y|Y)
                term_sd_echo "选择按顺序安装依赖"
                ;;
            *)
                term_sd_echo "忽略警告并继续启动 ComfyUI"
                return 0
                ;;
        esac
    fi

    if [[ -f "${START_PATH}/term-sd/task/comfyui_depend_path_list.sh" ]]; then
        install_comfyui_requirement "${START_PATH}/term-sd/task/comfyui_depend_path_list.sh"
    else
        term_sd_echo "ComfyUI 依赖完整性检测完成"
    fi

    rm -f "${START_PATH}/term-sd/task/comfyui_has_conflict_requirement_notice.sh"
    rm -f "${START_PATH}/term-sd/task/comfyui_depend_path_list.sh"
}

# 安装 ComfyUI 缺失的依赖
# 使用:
# install_comfyui_requirement <ComfyUI 依赖路径记录表文件路径>
install_comfyui_requirement() {
    local requirements_list_path=$@
    local requirement_path
    local cmd_point
    local cmd_sum
    local requirement_name

    cmd_sum=$(cat "${requirements_list_path}" | wc -l) # 统计内容行数
    for (( cmd_point=1; cmd_point <= cmd_sum; cmd_point++ )); do
        requirement_path=$(cat "${requirements_list_path}" | awk 'NR=='${cmd_point}' {print $0}')
        requirement_parent_path=$(dirname "${requirement_path}")
        requirement_name=$(basename "${requirement_parent_path}")

        cd "${requirement_parent_path}"
        term_sd_echo "[${cmd_point}/${cmd_sum}] 安装 ${requirement_name} 依赖中"
        install_python_package -r requirements.txt
        if [[ "$?" == 0 ]]; then
            term_sd_echo "[${cmd_point}/${cmd_sum}] 安装 ${requirement_name} 依赖成功"
        else
            term_sd_echo "[${cmd_point}/${cmd_sum}] 安装 ${requirement_name} 依赖失败, 这可能会影响部分功能"
        fi

        if [[ -f "install.py" ]]; then
            term_sd_echo "[${cmd_point}/${cmd_sum}] 执行 ${requirement_name} 安装脚本中"
            term_sd_try term_sd_python install.py
            if [[ "$?" == 0 ]]; then
                term_sd_echo "[${cmd_point}/${cmd_sum}] 执行 ${requirement_name} 安装脚本成功"
            else
                term_sd_echo "[${cmd_point}/${cmd_sum}] 执行 ${requirement_name} 安装脚本失败, 这可能会影响部分功能"
            fi
        fi
    done

    term_sd_echo "安装 ComfyUI 依赖结束"
    cd "${COMFYUI_ROOT_PATH}"
}

# 回滚 Numpy 版本
fallback_numpy_version() {
    local np_major_ver

    term_sd_echo "检测 Numpy 版本中"
    np_major_ver=$(term_sd_python "${START_PATH}/term-sd/python_modules/get_numpy_ver.py")

    if (( np_major_ver > 1 )); then
        term_sd_echo "检测到 Numpy 版本过高, 尝试回退版本中"
        install_python_package numpy==1.26.4
        if [[ "$?" == 0 ]]; then
            term_sd_echo "Numpy 版本回退成功"
        else
            term_sd_echo "Numpy 版本回退失败"
        fi
    else
        term_sd_echo "Numpy 无版本问题"
    fi
}

# 修复 PyTorch 的 libomp 问题
fix_pytorch() {
    if is_windows_platform; then
        term_sd_echo "检测 PyTorch 的 libomp 问题"
        term_sd_python "${START_PATH}/term-sd/python_modules/fix_torch.py"
    fi
}

# 验证内核依赖完整新
# 使用:
# validate_requirements <依赖表文件路径>
validate_requirements() {
    local path=$@
    local status
    local current_path=$(pwd)
    local dir_path

    term_sd_echo "检测 ${TERM_SD_MANAGE_OBJECT} 内核依赖完整性中"
    if [[ ! -f "${path}" ]]; then
        term_sd_echo "依赖表文件缺失, 无法进行检测"
        return 1
    fi

    dir_path=$(dirname "${path}")
    status=$(term_sd_python "${START_PATH}/term-sd/python_modules/validate_requirements.py" \
        --requirement-path "${path}" \
    )

    if [[ "${status}" == "False" ]]; then
        term_sd_echo "检测到 ${TERM_SD_MANAGE_OBJECT} 依赖有缺失, 将安装依赖"
        cd "${dir_path}"
        install_python_package -r "${path}"
        if [[ "$?" == 0 ]]; then
            term_sd_echo "${TERM_SD_MANAGE_OBJECT} 依赖安装成功"
        else
            term_sd_echo "${TERM_SD_MANAGE_OBJECT} 依赖安装失败"
        fi
    else
        term_sd_echo "${TERM_SD_MANAGE_OBJECT} 无缺失依赖"
    fi

    cd "${current_path}"
    term_sd_echo "检测 ${TERM_SD_MANAGE_OBJECT} 内核依赖完整性检测结束"
}

# 检查 onnxruntime-gpu 版本
check_onnxruntime_gpu_ver() {
    local status

    term_sd_echo "检测 onnxruntime-gpu 所支持的 CUDA 版本是否匹配 PyTorch 所支持的 CUDA 版本"
    status=$(term_sd_python "${START_PATH}/term-sd/python_modules/check_onnxruntime_gpu.py")

    if [[ "${status}" == "cu118" ]]; then
        term_sd_echo "检测到 onnxruntime-gpu 所支持的 CUDA 版本 和 PyTorch 所支持的 CUDA 版本不匹配, 将执行重装操作"
        uninstall_onnxruntime_gpu
        term_sd_echo "重新安装 onnxruntime-gpu"
        term_sd_try term_sd_pip install onnxruntime-gpu==1.18.1 --no-cache-dir
    elif [[ "${status}" == "cu121cudnn9" ]]; then
        term_sd_echo "检测到 onnxruntime-gpu 所支持的 CUDA 版本 和 PyTorch 所支持的 CUDA 版本不匹配, 将执行重装操作"
        uninstall_onnxruntime_gpu
        term_sd_echo "重新安装 onnxruntime-gpu"
        term_sd_pip install "onnxruntime-gpu>=1.19.0" --no-cache-dir
    elif [[ "${status}" == "cu121cudnn8" ]]; then
        term_sd_echo "检测到 onnxruntime-gpu 所支持的 CUDA 版本 和 PyTorch 所支持的 CUDA 版本不匹配, 将执行重装操作"
        uninstall_onnxruntime_gpu
        term_sd_echo "重新安装 onnxruntime-gpu"
        PIP_INDEX_URL="https://aiinfra.pkgs.visualstudio.com/PublicPackages/_packaging/onnxruntime-cuda-12/pypi/simple/" \
        term_sd_try term_sd_pip install onnxruntime-gpu==1.17.1 --no-cache-dir
    else
        term_sd_echo "onnxruntime-gpu 无版本问题"
        return 0
    fi

    if [[ "$?" == 0 ]]; then
        term_sd_echo "重新安装 onnxruntime-gpu 成功"
    else
        term_sd_echo "重新安装 onnxruntime-gpu 失败, 这可能导致部分功能无法正常使用, 如使用反推模型无法正常调用 GPU 导致推理降速"
    fi
}

# 卸载原有的 onnxruntime-gpu
uninstall_onnxruntime_gpu() {
    if get_python_env_pkg 2> /dev/null | grep -q "onnxruntime-gpu"; then
        term_sd_echo "卸载原有 onnxruntime-gpu"
        term_sd_try term_sd_pip uninstall onnxruntime-gpu -y
    fi
}

# 获取 SD WebUI 的 PYTHONPATH
get_sd_webui_python_path() {
    local path

    path=$(term_sd_python "${START_PATH}/term-sd/python_modules/get_sd_webui_python_path.py")

    echo "${path}"
}

# 安装 SD WebUI 的插件依赖
# 使用:
# check_sd_webui_extension_requirement <SD WebUI 参数配置文件>
check_sd_webui_extension_requirement() {
    local py_path
    local extension_name
    local i
    local status
    local launch_sd_config=$@
    local cancel_install_extension_requirement=0
    local install_script_path
    local count=0
    local sum=0

    py_path=$(get_sd_webui_python_path)

    # 统计需要安装依赖的插件数量
    for i in "${SD_WEBUI_ROOT_PATH}/extensions"/*; do
        [[ -f "${i}" ]] && continue
        [[ -f "${i}/install.py" ]] && sum=$(( sum + 1 ))
    done

    # 检查启动参数中是否包含禁用所有插件的启动参数
    if cat "${START_PATH}"/term-sd/config/${launch_sd_config} | grep "\-\-disable\-all\-extensions" &> /dev/null \
        || cat "${START_PATH}"/term-sd/config/${launch_sd_config} | grep "\-\-disable\-extra\-extensions" &> /dev/null; then

        cancel_install_extension_requirement=1
    fi

    if ! is_sd_webui_disable_all_extension && [[ "${cancel_install_extension_requirement}" == 0 ]]; then
        term_sd_echo "检查 ${TERM_SD_MANAGE_OBJECT} 插件依赖中"
        for i in "${SD_WEBUI_ROOT_PATH}/extensions"/*; do
            if [[ -f "${i}" ]]; then
                continue
            fi

            extension_name=$(basename "${i}")
            install_script_path="${i}/install.py"
            if [[ -f "${install_script_path}" ]]; then
                count=$(( count + 1 ))
                if ! is_sd_webui_extension_disabled "${extension_name}"; then
                    term_sd_echo "[${count}/${sum}] 执行 ${extension_name} 插件的依赖安装脚本中"
                    PYTHONPATH=$py_path term_sd_try term_sd_python "${install_script_path}"
                    if [[ "$?" == 0 ]]; then
                        term_sd_echo "[${count}/${sum}] ${extension_name} 插件的依赖安装脚本执行成功"
                    else
                        term_sd_echo "[${count}/${sum}] ${extension_name} 插件的依赖安装脚本执行失败, 这可能会导致 ${extension_name} 插件部分功能无法正常使用"
                    fi
                else
                    term_sd_echo "[${count}/${sum}] ${extension_name} 插件已禁用, 不执行该插件的依赖安装脚本"
                fi
            fi
        done
    fi
}

# 检查 SD WebUI Forge 内置插件依赖
# 使用:
# check_sd_webui_built_in_extension_requirement <SD WebUI 参数配置文件>
check_sd_webui_built_in_extension_requirement() {
    local py_path
    local extension_name
    local i
    local status
    local launch_sd_config=$@
    local cancel_install_extension_requirement=0
    local install_script_path
    local count=0
    local sum=0

    py_path=$(get_sd_webui_python_path)

    # 统计需要安装依赖的插件数量
    for i in "${SD_WEBUI_ROOT_PATH}/extensions-builtin"/*; do
        [[ -f "${i}" ]] && continue
        [[ -f "${i}/install.py" ]] && sum=$(( sum + 1 ))
    done

    # 检查启动参数中是否包含禁用所有插件的启动参数
    if cat "${START_PATH}"/term-sd/config/${launch_sd_config} | grep "\-\-disable\-all\-extensions" &> /dev/null \
        || cat "${START_PATH}"/term-sd/config/${launch_sd_config} | grep "\-\-disable\-extra\-extensions" &> /dev/null; then

        cancel_install_extension_requirement=1
    fi

    if ! is_sd_webui_disable_all_extension && [[ "${cancel_install_extension_requirement}" == 0 ]]; then
        term_sd_echo "检查 ${TERM_SD_MANAGE_OBJECT} 内置插件依赖中"
        for i in "${SD_WEBUI_ROOT_PATH}/extensions-builtin"/*; do
            if [[ -f "${i}" ]]; then
                continue
            fi

            extension_name=$(basename "${i}")
            install_script_path="${i}/install.py"
            if [[ -f "${install_script_path}" ]]; then
                count=$(( count + 1 ))
                if ! is_sd_webui_extension_disabled "${extension_name}"; then
                    term_sd_echo "[${count}/${sum}] 执行 ${extension_name} 内置插件的依赖安装脚本中"
                    PYTHONPATH=$py_path term_sd_try term_sd_python "${install_script_path}"
                    if [[ "$?" == 0 ]]; then
                        term_sd_echo "[${count}/${sum}] ${extension_name} 内置插件的依赖安装脚本执行成功"
                    else
                        term_sd_echo "[${count}/${sum}] ${extension_name} 内置插件的依赖安装脚本执行失败, 这可能会导致 ${extension_name} 内置插件部分功能无法正常使用"
                    fi
                else
                    term_sd_echo "[${count}/${sum}] ${extension_name} 内置插件已禁用, 不执行该内置插件的依赖安装脚本"
                fi
            fi
        done
    fi
}

# 查询 SD WebUI 是否禁用了所有插件
is_sd_webui_disable_all_extension() {
    local status

    status=$(term_sd_python "${START_PATH}/term-sd/python_modules/get_sd_webui_disable_all_extension_status.py" \
        --config-path "${SD_WEBUI_ROOT_PATH}/config.json" \
    )

    if [[ "${status}" == "True" ]]; then
        return 0
    else
        return 1
    fi
}

# 检查 controlnet_aux
check_controlnet_aux() {
    local controlnet_aux_ver

    term_sd_echo "检查 controlnet_aux 模块是否已安装"
    controlnet_aux_ver=$(term_sd_python "${START_PATH}/term-sd/python_modules/check_controlnet_aux.py")

    if [[ "${controlnet_aux_ver}" == "None" ]]; then
        term_sd_echo "controlnet_aux 已安装"
    else
        term_sd_echo "检测到 controlnet_aux 缺失, 尝试安装中"
        term_sd_python -m pip uninstall controlnet_aux -y
        install_python_package "${controlnet_aux_ver}" --use-pep517 --no-cache-dir
        if [[ "$?" == 0 ]]; then
            term_sd_echo "controlnet_aux 安装成功"
        else
            term_sd_echo "controlnet_aux 安装失败, 可能会导致 InvokeAI 启动异常"
        fi
    fi
}

# 运行环境检测设置
env_check_setting() {
    local dialog_arg
    local env_check_info

    while true; do
        if [[ ! -f "${START_PATH}/term-sd/config/disable-env-check.lock" ]]; then
            env_check_info="启用"
        else
            env_check_info="禁用"
        fi

        dialog_arg=$(dialog --erase-on-exit --notags \
            --title "Term-SD" \
            --backtitle "运行环境检测设置" \
            --ok-label "确认" --cancel-label "取消" \
            --menu "该功能用于设置运行环境检测设置, 运行环境检查包括: Numpy 版本检测, 依赖完整性检测, 冲突组件检测, PyTorch libomp 问题检测, onnxruntime-gpu 版本检测. 这些检测将找出运行环境中出现的问题并修复, 注意, 禁用后可能会导致 Term-SD 无法发现并修复运行环境中存在的问题, 导致部分功能不可用\n当前运行环境检测: ${env_check_info}\n是否启用运行环境检测 ?" \
            $(get_dialog_size_menu) \
            "0" "> 返回" \
            "1" "> 启用" \
            "2" "> 禁用" \
            3>&1 1>&2 2>&3)

        case "${dialog_arg}" in
            1)
                rm -f "${START_PATH}/term-sd/config/disable-env-check.lock"

                dialog --erase-on-exit \
                    --title "Term-SD" \
                    --backtitle "运行环境检测设置" \
                    --ok-label "确认" \
                    --msgbox "启用运行环境检测成功" \
                    $(get_dialog_size)
                ;;
            2)
                touch "${START_PATH}/term-sd/config/disable-env-check.lock"

                dialog --erase-on-exit \
                    --title "Term-SD" \
                    --backtitle "运行环境检测设置" \
                    --ok-label "确认" \
                    --msgbox "禁用运行环境检测成功" \
                    $(get_dialog_size)
                ;;
            *)
                break
                ;;
        esac
    done
}
