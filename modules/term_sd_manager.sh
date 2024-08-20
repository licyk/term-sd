#!/bin/bash

# 启动 AI 软件
# 使用 TERM_SD_MANAGE_OBJECT 全局变量判断要启动的 AI 软件
# 根据对应的 AI 软件读取对应的启动配置文件
# 使用的配置文件:
# A1111 SD WebUI: <Start Path>/term-sd/config/sd-webui-launch.conf
# Vlad SD WebUI: <Start Path>/term-sd/config/vlad-sd-webui-launch.conf
# SD WebUI DirectML: <Start Path>/term-sd/config/sd-webui-directml-launch.conf
# SD WebUI Forge: <Start Path>/term-sd/config/sd-webui-forge-launch.conf
# ComfyUI: <Start Path>/term-sd/config/comfyui-launch.conf
# InvokeAI: <Start Path>/term-sd/config/invokeai-launch.conf
# Fooocus: <Start Path>/term-sd/config/fooocus-launch.conf
# lora-scripts: <Start Path>/term-sd/config/lora-scripts-launch.conf
# kohya_ss: <Start Path>/term-sd/config/kohya_ss-launch.conf
# 读取 <Start Path>/term-sd/config/set-global-github-mirror.conf 配置文件用于设置 SD WebUI 的插件列表的镜像源
# 使用 WEBUI_EXTENSIONS_INDEX 环境变量进行设置
# 读取 <Start Path>/term-sd/config/set-global-huggingface-mirror.conf 配置文件用于设置 Fooocus 的 HuggingFace 镜像源
# 使用 --hf-mirror <hf_mirror> 启动参数进行设置
term_sd_launch() {
    local launch_sd_config
    local use_mirror_for_sd_webui=0
    local use_mirror_for_sd_webui_state=1
    local use_cuda_malloc=0
    local sd_webui_extension_list_url
    local github_mirror_url
    local i
    local ignore_github_mirror
    local hf_mirror_for_fooocus
    local is_sdnext=0
    local tmp_pip_find_links=$PIP_FIND_LINKS
    local use_pip_mirror_for_controlnet_ext=0
    local github_mirror

    case "${TERM_SD_MANAGE_OBJECT}" in
        stable-diffusion-webui)
            case "$(git remote get-url origin | awk -F '/' '{print $NF}')" in # 分支判断
                stable-diffusion-webui|stable-diffusion-webui.git)
                    launch_sd_config="sd-webui-launch.conf"
                    ;;
                automatic|automatic.git)
                    launch_sd_config="vlad-sd-webui-launch.conf"
                    is_sdnext=1
                    ;;
                stable-diffusion-webui-directml|stable-diffusion-webui-directml.git)
                    launch_sd_config="sd-webui-directml-launch.conf"
                    ;;
                stable-diffusion-webui-forge|stable-diffusion-webui-forge.git)
                    launch_sd_config="sd-webui-forge-launch.conf"
                    ;;
                *)
                    launch_sd_config="sd-webui-launch.conf"
                    ;;
            esac

            if [[ -f "${START_PATH}/term-sd/config/set-global-github-mirror.conf" ]]; then # 检测是否设置了github全局镜像源
                ignore_github_mirror="gitclone.com"
                # 判断是否为可使用的镜像源
                for i in ${ignore_github_mirror}; do
                    if [ ! -z "$(cat "${START_PATH}"/term-sd/config/set-global-github-mirror.conf | grep ${i})" ]; then
                        use_mirror_for_sd_webui_state=0
                    fi
                done
                if [[ "${use_mirror_for_sd_webui_state}" == 1 ]]; then
                    use_mirror_for_sd_webui=1
                    github_mirror="$(cat "${START_PATH}"/term-sd/config/set-global-github-mirror.conf)//term_sd_git_user/term_sd_git_repo"
                fi
            fi

            # 为sd webui的插件列表设置镜像源
            if [[ "${use_mirror_for_sd_webui}" == 1 ]]; then
                term_sd_echo "检测到启用了 Github 镜像源, 为 Stable Diffusion WebUI 可下载的插件列表设置镜像源"
                github_mirror_url=$(cat "${START_PATH}"/term-sd/config/set-global-github-mirror.conf | awk '{sub("github.com","raw.githubusercontent.com")}1')
                if [[ "${is_sdnext}" == 0 ]]; then
                    export WEBUI_EXTENSIONS_INDEX="${github_mirror_url}/AUTOMATIC1111/stable-diffusion-webui-extensions/master/index.json"
                fi
                export CLIP_PACKAGE="git+$(git_format_repository_url "${github_mirror}" https://github.com/openai/CLIP)"
            fi

            # 为 ControlNet 插件的依赖安装设置镜像源
            if [[ "$(cat "${START_PATH}/term-sd/config/term-sd-pip-mirror.conf" 2> /dev/null)" == 2 ]]; then
                term_sd_echo "检测到启用了 Pip 镜像源, 为 ControlNet 插件的依赖下载启用镜像源"
                use_pip_mirror_for_controlnet_ext=1
                export PIP_FIND_LINKS="${PIP_FIND_LINKS} https://licyk.github.io/t/pypi/index_ms_mirror.html"
                export INSIGHTFACE_WHEEL="insightface"
                export DEPTH_ANYTHING_WHEEL="depth_anything"
                export HANDREFINER_WHEEL="handrefinerportable"
            fi
            ;;
        ComfyUI)
            launch_sd_config="comfyui-launch.conf"
            ;;
        InvokeAI)
            launch_sd_config="invokeai-launch.conf"
            ;;
        Fooocus)
            launch_sd_config="fooocus-launch.conf"
            if echo $(cat "${START_PATH}"/term-sd/config/${launch_sd_config}) | grep "\-\-language zh" &> /dev/null; then # 添加中文配置
                fooocus_lang_config_file > language/zh.json
            fi

            if echo $(cat "${START_PATH}"/term-sd/config/${launch_sd_config}) | grep "\-\-preset term_sd" &> /dev/null; then # 添加Term-SD风格的预设
                fooocus_preset_file > "$FOOOCUS_PATH"/presets/term_sd.json
            fi

            if [[ -f "${START_PATH}/term-sd/config/set-global-huggingface-mirror.conf" ]]; then
                term_sd_echo "检测到启用了 HuggingFace 镜像源, 为 Fooocus 设置 HuggingFace 镜像源"
                hf_mirror_for_fooocus="--hf-mirror ${HF_ENDPOINT}"
            fi
            ;;
        lora-scripts)
            launch_sd_config="lora-scripts-launch.conf"
            ;;
        kohya_ss)
            launch_sd_config="kohya_ss-launch.conf"
            ;;
    esac

    if [[ -f "${START_PATH}/term-sd/config/set-cuda-memory-alloc.lock" ]]; then
        term_sd_echo "检查显卡是否为 Nvidia 显卡"
        if check_gpu_is_nvidia_drive; then
            use_cuda_malloc=0
            term_sd_echo "显卡为 Nvidia 显卡, 可设置 CUDA 内存分配器"
            if is_cuda_malloc_avaliable; then
                term_sd_echo "设置 CUDA 内存分配器为 CUDA 内置异步分配器"
                export PYTORCH_CUDA_ALLOC_CONF="backend:cudaMallocAsync"
            else
                term_sd_echo "设置 CUDA 内存分配器为 PyTorch 原生分配器"
                export PYTORCH_CUDA_ALLOC_CONF="garbage_collection_threshold:0.9,max_split_size_mb:512"
            fi
        else
            term_sd_echo "显卡非 Nvidia 显卡, 无法设置 CUDA 内存分配器"
        fi
    fi

    if term_sd_is_debug; then
        term_sd_print_line
        echo "当前配置:"
        echo "launch_sd_config: ${launch_sd_config}"
        echo "github_mirror: ${github_mirror}"
        echo "WEBUI_EXTENSIONS_INDEX: ${WEBUI_EXTENSIONS_INDEX}"
        echo "CLIP_PACKAGE: ${CLIP_PACKAGE}"
        echo "PIP_FIND_LINKS: ${PIP_FIND_LINKS}"
        echo "INSIGHTFACE_WHEEL: ${INSIGHTFACE_WHEEL}"
        echo "DEPTH_ANYTHING_WHEEL: ${DEPTH_ANYTHING_WHEEL}"
        echo "HANDREFINER_WHEEL: ${HANDREFINER_WHEEL}"
        echo "PYTORCH_CUDA_ALLOC_CONF: ${PYTORCH_CUDA_ALLOC_CONF}"
        term_sd_print_line
        echo "环境变量:"
        echo "ENV:"
        env 2> /dev/null
    fi

    term_sd_print_line "${TERM_SD_MANAGE_OBJECT} 启动"
    term_sd_echo "提示: 可以按下 Ctrl + C 键终止 AI 软件的运行"
    case "${TERM_SD_MANAGE_OBJECT}" in
        InvokeAI)
            fallback_numpy_version
            invokeai-web --root "${INVOKEAI_PATH}"/invokeai $(cat "${START_PATH}/term-sd/config/${launch_sd_config}")
            [[ ! "$?" == 0 ]] && term_sd_echo "${TERM_SD_MANAGE_OBJECT} 退出状态异常"
            ;;
        *)
            enter_venv
            fallback_numpy_version
            term_sd_python $(cat "${START_PATH}/term-sd/config/${launch_sd_config}") ${hf_mirror_for_fooocus}
            [[ ! "$?" == 0 ]] && term_sd_echo "${TERM_SD_MANAGE_OBJECT} 退出状态异常"
            exit_venv
            ;;
    esac

    if [[ "${use_mirror_for_sd_webui}" == 1 ]]; then # 取消 SD WebUIs 的插件列表镜像源
        unset WEBUI_EXTENSIONS_INDEX
        unset CLIP_PACKAGE
    fi

    if [[ "${use_cuda_malloc}" == 1 ]];then
        unset PYTORCH_CUDA_ALLOC_CONF
    fi

    if [[ "${use_pip_mirror_for_controlnet_ext}" == 1 ]]; then
        export PIP_FIND_LINKS=$tmp_pip_find_links
        unset INSIGHTFACE_WHEEL
        unset INSIGHTFACE_WHEEL
        unset HANDREFINER_WHEEL
    fi

    term_sd_pause
}

# 回滚 Numpy 版本
fallback_numpy_version() {
    local np_major_ver

    np_major_ver=$(term_sd_python -c "$(py_get_numpy_ver)")

    if (( np_major_ver > 1 )); then
        term_sd_echo "检测到 Numpy 版本过高, 尝试回退版本中"
        install_python_package numpy==1.26.4
        if [[ "$?" == 0 ]]; then
            term_sd_echo "Numpy 版本回退成功"
        else
            term_sd_echo "Numpy 版本回退失败"
        fi
    fi
}

# 获取 Numpy 大版本
py_get_numpy_ver() {
    cat<<EOF
import importlib.metadata
from importlib.metadata import version
try:
    print(version("numpy").split(".")[0])
except importlib.metadata.PackageNotFoundError:
    print("-1")
EOF
}

# Aria2 下载工具
# 使用格式: aria2_download <下载链接> <下载路径> <文件名>
# 使用 ARIA2_MULTI_THREAD 全局变量设置 Aria2 的下载线程数
aria2_download() {
    local url=$1 # 链接
    local path=$2 # 下载路径
    local name=$3 # 要保存的名称
    local aria2_tmp_path # Aria2 缓存文件
    local file_path # 下载到本地的文件

    if [[ -z "${path}" ]]; then # 下载路径为空时
        path=$(pwd)
        name=$(basename "${url}")
    elif [[ -z "${name}" ]]; then # 要保存的名称为空时
        # 去除下载路径中末尾的 / 字符
        path=$(awk '{ if (substr($0, length($0), 1) == "/") { print substr($0, 1, length($0) - 1) } else { print $0 } }' <<< ${path})
        name=$(basename "${url}")
    else
        # 去除下载路径中末尾的 / 字符
        path=$(awk '{ if (substr($0, length($0), 1) == "/") { print substr($0, 1, length($0) - 1) } else { print $0 } }' <<< ${path})
    fi

    aria2_tmp_path="${path}/${name}.aria2"
    file_path="${path}/${name}"

    if term_sd_is_debug; then
        term_sd_echo "url: ${url}"
        term_sd_echo "name: ${name}"
        term_sd_echo "path: ${path}"
        term_sd_echo "aria2_tmp_path: ${aria2_tmp_path}"
        term_sd_echo "file_path: ${file_path}"
        term_sd_echo "ARIA2_MULTI_THREAD: ${ARIA2_MULTI_THREAD}"
        term_sd_echo "cmd: aria2c --file-allocation=none --summary-interval=0 --console-log-level=error -s 64 -c -x ${ARIA2_MULTI_THREAD} ${url} -d ${path} -o ${name}"
    fi

    if [[ ! -f "${file_path}" ]]; then
        term_sd_echo "下载 ${name} 中, 路径: ${file_path}"
        term_sd_try aria2c --file-allocation=none --summary-interval=0 --console-log-level=error -s 64 -c -x "${ARIA2_MULTI_THREAD}" "${url}" -d "${path}" -o "${name}"
        if [[ "$?" == 0 ]]; then
            term_sd_echo "${name} 下载成功"
        else
            term_sd_echo "${name} 下载失败"
            return 1
        fi
    else
        if [[ -f "${aria2_tmp_path}" ]]; then
            term_sd_echo "恢复下载 ${name} 中, 路径: ${file_path}"
            term_sd_try aria2c --file-allocation=none --summary-interval=0 --console-log-level=error -s 64 -c -x "${ARIA2_MULTI_THREAD}" "${url}" -d "${path}" -o "${name}"
            if [[ "$?" == 0 ]]; then
                term_sd_echo "${name} 下载成功"
            else
                term_sd_echo "${name} 下载失败"
                return 1
            fi
        else
            term_sd_echo "${name} 文件已存在, 路径: ${file_path}"
        fi
    fi
}

# 显示版本信息
term_sd_version() {
    local platform_info
    local term_sd_ver
    local python_ver
    local python_major_version
    local python_minor_version
    local pip_ver
    local aria2_ver
    local git_ver
    local dialog_ver
    local curl_ver

    term_sd_echo "统计版本信息中"
    platform_info=$(is_windows_platform && echo Windows || uname -o)
    term_sd_ver="${TERM_SD_VER} - $(git -C term-sd show -s --format="%cd" --date=format:"%Y-%m-%d %H:%M:%S")"
    python_ver=$(term_sd_python --version | awk 'NR==1 {print $2}')
    python_major_version=$(echo ${python_ver} | awk -F '.' '{print $1}')
    python_minor_version=$(echo ${python_ver} | awk -F '.' '{print $2}')
    if (( python_major_version == 3 )); then
        if (( python_minor_version >= 9 )) && (( python_minor_version <= 11 )); then
            true
        else
            python_ver="${python_ver} (版本不兼容!)"
        fi
    else
        python_ver="${python_ver} (版本不兼容!)"
    fi
    pip_ver=$(term_sd_pip --version | awk 'NR==1{print $2}')
    aria2_ver=$(aria2c --version | awk 'NR==1{print $3}')
    git_ver=$(git --version | awk 'NR==1{print $3}')
    dialog_ver=$(dialog --version | awk 'NR==1{print $2}')
    curl_ver=$(curl --version | awk 'NR==1{print $2}')

    dialog --erase-on-exit \
        --title "Term-SD" \
        --backtitle "Term-SD开始界面" \
        --ok-label "确认" \
        --msgbox "版本信息:\n\n
系统: ${platform_info}\n
Term-SD: ${term_sd_ver}\n
Python: ${python_ver}\n
Pip: ${pip_ver}\n
Aria2: ${aria2_ver}\n
Git: ${git_ver}\n
Dialog: ${dialog_ver}\n
Curl: ${curl_ver}\n
\n
提示:\n
使用方向键, Tab 键移动光标, 方向键 / F, B 键翻页 (鼠标滚轮无法翻页) , Enter 键进行选择, Space 键勾选或取消勾选 (已勾选时显示 [*] ), Ctrl+Shift+V 快捷键粘贴文本, 鼠标左键可点击按钮 (右键无效)\n
第一次使用 Term-SD 时先在主界面选择 Term-SD 帮助查看使用说明, 参数说明和注意的地方, 内容不定期更新" \
    $(get_dialog_size)
}

# 主界面
term_sd_manager() {
    local dialog_arg
    local proxy_address_available
    local github_mirror_info
    local huggingface_mirror_info
    local venv_info
    local proxy_info

    while true; do
        
        cd "${START_PATH}" # 回到最初路径
        exit_venv # 确保进行下一步操作前已退出其他虚拟环境

        # 检测代理地址是否可用
        if [[ ! -z "${HTTP_PROXY}" ]]; then
            term_sd_echo "测试代理地址连通性中"
            curl -s --connect-timeout 1 "${HTTP_PROXY}"
            if [[ "$?" == 0 ]]; then
                proxy_address_available="(可用 ✓)"
            else
                proxy_address_available="(连接异常 ×)"
            fi
        fi

        if is_use_venv; then
            venv_info="启用"
        else
            venv_info="禁用"
        fi

        if [[ -f "${START_PATH}/term-sd/config/set-global-github-mirror.conf" ]]; then
            github_mirror_info=$(cat "${START_PATH}/term-sd/config/set-global-github-mirror.conf" | awk '{sub("/https://github.com","") sub("/github.com","")}1')
        else
            github_mirror_info="未设置"
        fi

        if [[ -f "${START_PATH}/term-sd/config/set-global-huggingface-mirror.conf" ]]; then
            huggingface_mirror_info=$HF_ENDPOINT
        else
            huggingface_mirror_info="未设置"
        fi

        if [[ ! -z "${HTTP_PROXY}" ]]; then
            proxy_info="${HTTP_PROXY} ${proxy_address_available}"
        else
            proxy_info="未设置"
        fi

        dialog_arg=$(dialog --erase-on-exit --notags \
            --title "Term-SD" \
            --backtitle "主界面" \
            --ok-label "确认" --cancel-label "退出" \
            --menu "请选择Term-SD的功能\n当前虚拟环境状态: ${venv_info}\n当前 Github 镜像源设置: ${github_mirror_info}\n当前 HuggingFace 镜像源设置: ${huggingface_mirror_info}\n当前代理设置: ${proxy_info}" \
            $(get_dialog_size_menu) \
            "0" "> Term-SD 更新管理" \
            "1" "> Stable-Diffusion-WebUI 管理" \
            "2" "> ComfyUI 管理" \
            "3" "> InvokeAI 管理" \
            "4" "> Fooocus 管理" \
            "5" "> lora-scripts 管理" \
            "6" "> kohya_ss 管理" \
            "7" "> Term-SD 设置" \
            "8" "> Term-SD 帮助" \
            "9" "> 退出 Term-SD" \
            3>&1 1>&2 2>&3 )

        case "${dialog_arg}" in
            0)
                # 选择 Term-SD 更新
                term_sd_update_manager
                ;;
            1)
                # 选择 Stable-Diffusion-WebUI
                term_sd_install_task_manager stable-diffusion-webui
                ;;
            2)
                # 选择 ComfyUI
                term_sd_install_task_manager ComfyUI
                ;;
            3)
                # 选择 InvokeAI
                term_sd_install_task_manager InvokeAI
                ;;
            4)
                # 选择 Fooocus
                term_sd_install_task_manager Fooocus
                ;;
            5)
                # 选择 lora-scripts
                term_sd_install_task_manager lora-scripts
                ;;
            6)
                # 选择 kohya_ss
                term_sd_install_task_manager kohya_ss
                ;;
            7)
                # 选择设置
                term_sd_setting
                ;;
            8)
                # 选择帮助
                term_sd_help
                ;;
            *)
                # 选择退出
                term_sd_print_line
                term_sd_echo "退出 Term-SD"
                exit 0
                ;;
        esac
    done
}

# 帮助列表
# 帮助文件保存在 <Start Path>/term-sd/help
term_sd_help() {
    local dialog_arg

    while true; do
        dialog_arg=$(dialog --erase-on-exit --notags \
            --title "Term-SD" \
            --backtitle "Term-SD 帮助选项" \
            --ok-label "确认" \
            --cancel-label "取消" \
            --menu "请选择帮助" \
            $(get_dialog_size_menu) \
            "0" "> 返回" \
            "1" "> 关于 Term-SD" \
            "2" "> Term-SD 使用方法" \
            "3" "> 目录说明" \
            "4" "> Stable-Diffusion-WebUI 插件说明" \
            "5" "> ComfyUI 插件 / 自定义节点说明" \
            "6" "> 用户协议" \
            3>&1 1>&2 2>&3)

        case "${dialog_arg}" in
            1)
                dialog --erase-on-exit \
                    --title "Term-SD" \
                    --backtitle "Term-SD 帮助选项" \
                    --ok-label "确认" \
                    --msgbox "$(cat term-sd/help/about.md)" \
                    $(get_dialog_size)
                ;;
            2)
                less --mouse \
                --prompt="[Term-SD] 提示\: 使用方向键 \/ U, D 键 \/ 鼠标滚轮进行翻页, 按下 Q 键返回帮助列表" \
                term-sd/help/how_to_use_term_sd.md
                ;;
            3)
                dialog --erase-on-exit \
                    --title "Term-SD" \
                    --backtitle "Term-SD 帮助选项" \
                    --ok-label "确认" \
                    --msgbox "$(cat term-sd/help/directory_description.md)" \
                    $(get_dialog_size)
                ;;
            4)
                dialog --erase-on-exit \
                    --title "Term-SD" \
                    --backtitle "Term-SD 帮助选项" \
                    --ok-label "确认" \
                    --msgbox "$(cat term-sd/help/sd_webui_extension_description.md)" \
                    $(get_dialog_size)
                ;;
            5)
                dialog --erase-on-exit \
                    --title "Term-SD" \
                    --backtitle "Term-SD 帮助选项" \
                    --ok-label "确认" \
                    --msgbox "$(cat term-sd/help/comfyui_extension_description.md)" \
                    $(get_dialog_size)
                ;;
            6)
                dialog --erase-on-exit \
                    --title "Term-SD" \
                    --backtitle "Term-SD 帮助选项" \
                    --ok-label "确认" \
                    --msgbox "$(cat term-sd/help/user_agreement.md)" \
                    $(get_dialog_size)
                ;;
            *)
                break
                ;;
        esac
    done
}

# 检测 Term-SD 是否处于 Debug 模式, 如果是则返回 0
term_sd_is_debug() {
    if [[ "${TERM_SD_ENABLE_DEBUG}" == 1 ]];then
        return 0
    else
        return 1
    fi
}

# 返回 Bash 的版本是否小于 4, 如果小于 4 则返回 0
term_sd_is_bash_ver_lower() {
    if (( BASH_MAJOR_VERSION < 4 )); then
        return 0
    else
        return 1
    fi
}