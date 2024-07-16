#!/bin/bash

. "${START_PATH}"/term-sd/modules/term_sd_manager.sh
. "${START_PATH}"/term-sd/modules/python_venv.sh
. "${START_PATH}"/term-sd/modules/term_sd_python_cmd.sh
. "${START_PATH}"/term-sd/modules/term_sd_try.sh

# 主界面
term_sd_fix_onnxruntime() {
    local fix_onnxruntime_select
    while true; do
        term_sd_echo "请选择要修复 onnxruntime-gpu 组件的 AI 软件"
        term_sd_echo "1、stable-diffusion-webui"
        term_sd_echo "2、ComfyUI"
        term_sd_echo "3、InvokeAI"
        term_sd_echo "4、Fooocus"
        term_sd_echo "5、lora-scripts" 
        term_sd_echo "6、kohya_ss"
        term_sd_echo "7、退出"
        term_sd_echo "提示: 输入数字后回车"

        case "$(term_sd_read)" in
            1)
                fix_onnxruntime_select="stable-diffusion-webui"
                ;;
            2)
                fix_onnxruntime_select="ComfyUI"
                ;;
            3)
                fix_onnxruntime_select="InvokeAI"
                ;;
            4)
                fix_onnxruntime_select="Fooocus"
                ;;
            5)
                fix_onnxruntime_select="lora-scripts"
                ;;
            6)
                fix_onnxruntime_select="kohya_ss"
                ;;
            7)
                break
                ;;
            *)
                term_sd_echo "输入有误, 请重试"
                continue
                ;;
        esac
        if is_sd_folder_exist "${fix_onnxruntime_select}"; then
            term_sd_echo "是否修复 ${fix_onnxruntime_select} 的 onnxruntime-gpu (yes/no) ?"
            term_sd_echo "提示: 输入 yes 或 no 后回车"
            case "$(term_sd_read)" in
                y|yes|Y|YES)
                    term_sd_echo "开始修复 ${fix_onnxruntime_select} 的 onnxruntime-gpu"
                    fix_onnxruntime "${fix_onnxruntime_select}"
                    ;;
                *)
                    term_sd_echo "取消修复操作"
                    ;;
            esac
        else
            term_sd_echo "${fix_onnxruntime_select} 未安装"
        fi
    done
}

# 检测文件夹存在
is_sd_folder_exist() {
    case "$@" in
        stable-diffusion-webui)
            [[ -d "${SD_WEBUI_PATH}" ]] && return 0 || return 1
            ;;
        ComfyUI)
            [[ -d "${COMFYUI_PATH}" ]] && return 0 || return 1
            ;;
        InvokeAI)
            [[ -d "${INVOKEAI_PATH}" ]] && return 0 || return 1
            ;;
        Fooocus)
            [[ -d "${FOOOCUS_PATH}" ]] && return 0 || return 1
            ;;
        lora-scripts)
            [[ -d "${LORA_SCRIPTS_PATH}" ]] && return 0 || return 1
            ;;
        kohya_ss)
            [[ -d "${KOHYA_SS_PATH}" ]] && return 0 || return 1
            ;;
    esac
}

# 修复onnxruntime
fix_onnxruntime() {
    local onnxruntime_ver
    local name=$1
    case "${name}" in
        stable-diffusion-webui)
            create_venv "${SD_WEBUI_PATH}"
            enter_venv "${SD_WEBUI_PATH}"
            ;;
        ComfyUI)
            create_venv "${COMFYUI_PATH}"
            enter_venv "${COMFYUI_PATH}"
            ;;
        InvokeAI)
            create_venv "${INVOKEAI_PATH}"
            enter_venv "${INVOKEAI_PATH}"
            ;;
        Fooocus)
            create_venv "${FOOOCUS_PATH}"
            enter_venv "${FOOOCUS_PATH}"
            ;;
        lora-scripts)
            create_venv "${LORA_SCRIPTS_PATH}"
            enter_venv "${LORA_SCRIPTS_PATH}"
            ;;
        kohya_ss)
            create_venv  "$KOHYA_S{S_PATH"
            enter_venv "${KOHYA_SS_PATH}"
            ;;
    esac
    onnxruntime_ver=$(term_sd_pip freeze | grep" onnxruntime==" | awk -F '==' '{print $NF}')
    if term_sd_pip freeze | grep -q "onnxruntime-gpu" ;then
        term_sd_echo "卸载原有 onnxruntime-gpu"
        term_sd_try term_sd_pip uninstall onnxruntime-gpu -y
    fi
    term_sd_echo "重新安装 onnxruntime-gpu"

    PIP_EXTRA_INDEX_URL="https://aiinfra.pkgs.visualstudio.com/PublicPackages/_packaging/onnxruntime-cuda-12/pypi/simple" \
    term_sd_try term_sd_pip install onnxruntime-gpu==${onnxruntime_ver} --no-cache-dir || \
    PIP_EXTRA_INDEX_URL="https://aiinfra.pkgs.visualstudio.com/PublicPackages/_packaging/onnxruntime-cuda-12/pypi/simple" \
    term_sd_try term_sd_pip install onnxruntime-gpu --no-cache-dir

    if [[ "$?" == 0 ]]; then
        term_sd_echo "修复 ${name} 的 onnxruntime-gpu 成功"
    else
        term_sd_echo "修复 ${name} 的 onnxruntime-gpu 失败"
    fi
    exit_venv
    term_sd_print_line
}

########################

term_sd_fix_onnxruntime