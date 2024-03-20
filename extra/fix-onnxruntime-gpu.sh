#!/bin/bash

. ./term-sd/modules/term_sd_manager.sh
. ./term-sd/modules/python_venv.sh
. ./term-sd/modules/term_sd_python_cmd.sh

term_sd_fix_onnxruntime()
{
    local fix_onnxruntime_select
    while true
    do
        term_sd_echo "请选择要修复onnxruntime-gpu组件的AI软件"
        term_sd_echo "1、stable-diffusion-webui"
        term_sd_echo "2、ComfyUI"
        term_sd_echo "3、InvokeAI"
        term_sd_echo "4、Fooocus"
        term_sd_echo "5、lora-scripts" 
        term_sd_echo "6、kohya_ss"
        term_sd_echo "7、退出"
        term_sd_echo "提示：输入数字后回车"

        case $(term_sd_read) in
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
                return 1
                ;;
            *)
                term_sd_echo "输入有误,请重试"
                continue
                ;;
        esac
        if [ "$(is_sd_folder_exist "$fix_onnxruntime_select")" = 0 ];then
            term_sd_echo "是否修复${fix_onnxruntime_select}的onnxruntime-gpu(yes/no)"
            term_sd_echo "提示:输入yes或no后回车"
            case $(term_sd_read) in
                y|yes|Y|YES)
                    term_sd_echo "开始修复${fix_onnxruntime_select}的onnxruntime-gpu"
                    fix_onnxruntime "$fix_onnxruntime_select"
                    ;;
                *)
                    term_sd_echo "取消修复操作"
                    ;;
            esac
        else
            term_sd_echo "${fix_onnxruntime_select}未安装"
        fi
    done
}

# 检测文件夹存在
is_sd_folder_exist()
{
    case ${1} in
        stable-diffusion-webui)
            [ -d "$sd_webui_path" ] && echo 0 || echo 1
            ;;
        ComfyUI)
            [ -d "$comfyui_path" ] && echo 0 || echo 1
            ;;
        InvokeAI)
            [ -d "$invokeai_path" ] && echo 0 || echo 1
            ;;
        Fooocus)
            [ -d "$fooocus_path" ] && echo 0 || echo 1
            ;;
        lora-scripts)
            [ -d "$lora_scripts_path" ] && echo 0 || echo 1
            ;;
        kohya_ss)
            [ -d "$kohya_ss_path" ] && echo 0 || echo 1
            ;;
    esac
}

fix_onnxruntime()
{
    local onnxruntime_ver
    case ${1} in
        stable-diffusion-webui)
            create_venv "$sd_webui_path"
            enter_venv "$sd_webui_path"
            ;;
        ComfyUI)
            create_venv "$comfyui_path"
            enter_venv "$comfyui_path"
            ;;
        InvokeAI)
            create_venv "$invokeai_path"
            enter_venv "$invokeai_path"
            ;;
        Fooocus)
            create_venv "$fooocus_path"
            enter_venv "$fooocus_path"
            ;;
        lora-scripts)
            create_venv "$lora_scripts_path"
            enter_venv "$lora_scripts_path"
            ;;
        kohya_ss)
            create_venv  "$kohya_ss_path"
            enter_venv "$kohya_ss_path"
            ;;
    esac
    onnxruntime_ver=$(term_sd_pip freeze | grep onnxruntime== | awk -F '==' '{print $NF}')
    term_sd_echo "卸载原有onnxruntime-gpu"
    term_sd_try term_sd_pip uninstall onnxruntime-gpu -y
    term_sd_echo "重新安装onnxruntime-gpu"
    PIP_EXTRA_INDEX_URL="https://aiinfra.pkgs.visualstudio.com/PublicPackages/_packaging/onnxruntime-cuda-12/pypi/simple" \
    term_sd_try term_sd_pip install onnxruntime-gpu==$onnxruntime_ver --no-cache-dir || \
    PIP_EXTRA_INDEX_URL="https://aiinfra.pkgs.visualstudio.com/PublicPackages/_packaging/onnxruntime-cuda-12/pypi/simple" \
    term_sd_try term_sd_pip install onnxruntime-gpu --no-cache-dir
    if [ $? = 0 ];then
        term_sd_echo "修复${1}的onnxruntime-gpu成功"
    else
        term_sd_echo "修复${1}的onnxruntime-gpu失败"
    fi
    exit_venv
}

########################

term_sd_fix_onnxruntime