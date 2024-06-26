#!/bin/bash

# 启动ai软件
term_sd_launch()
{
    local launch_sd_config
    local use_mirror_for_sd_webui=1
    local use_mirror_for_sd_webui_state=0
    local sd_webui_extension_list_url
    local github_mirror_url
    local i
    local ignore_github_mirror
    local hf_mirror_for_fooocus

    case $term_sd_manager_info in
        stable-diffusion-webui)
            if [ -f "$start_path/term-sd/config/set-global-github-mirror.conf" ];then # 检测是否设置了github全局镜像源
                ignore_github_mirror="gitclone.com"
                # 判断是否为可使用的镜像源
                for i in $ignore_github_mirror
                do
                    if [ ! -z $(cat "$start_path"/term-sd/config/set-global-github-mirror.conf | grep $i) ];then
                        use_mirror_for_sd_webui_state=1
                    fi
                done
                if [ $use_mirror_for_sd_webui_state = 0 ];then
                    use_mirror_for_sd_webui=0
                fi
            fi

            # 为sd webui的插件列表设置镜像源
            if [ $use_mirror_for_sd_webui = 0 ];then
                term_sd_echo "检测到启用了 Github 镜像源, 为 Stable Diffusion WebUI 可下载的插件列表设置镜像源"
                github_mirror_url=$(cat "$start_path"/term-sd/config/set-global-github-mirror.conf | awk '{sub("github.com","raw.githubusercontent.com")}1')
                sd_webui_extension_list_url=$(echo https://raw.githubusercontent.com/AUTOMATIC1111/stable-diffusion-webui-extensions/master/index.json | awk '{sub("https://raw.githubusercontent.com","'$github_mirror_url'")}1')
                export WEBUI_EXTENSIONS_INDEX=$sd_webui_extension_list_url
            fi

            case $(git remote -v | awk 'NR==1 {print $2}' | awk -F'/' '{print $NF}') in # 分支判断
                stable-diffusion-webui|stable-diffusion-webui.git)
                    launch_sd_config="sd-webui-launch.conf"
                    ;;
                automatic|automatic.git)
                    launch_sd_config="vlad-sd-webui-launch.conf"
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
            ;;
        ComfyUI)
            launch_sd_config="comfyui-launch.conf"
            ;;
        InvokeAI)
            launch_sd_config="invokeai-launch.conf"
            ;;
        Fooocus)
            launch_sd_config="fooocus-launch.conf"
            if echo $(cat "$start_path"/term-sd/config/$launch_sd_config) | grep "\-\-language zh" &> /dev/null ;then # 添加中文配置
                fooocus_lang_config_file > language/zh.json
            fi

            if echo $(cat "$start_path"/term-sd/config/$launch_sd_config) | grep "\-\-preset term_sd" &> /dev/null ;then # 添加Term-SD风格的预设
                fooocus_preset_file > "$fooocus_path"/presets/term_sd.json
            fi

            if [ -f "$start_path/term-sd/config/set-global-huggingface-mirror.conf" ];then
                term_sd_echo "检测到启用了 HuggingFace 镜像源, 为 Fooocus 设置 HuggingFace 镜像源"
                hf_mirror_for_fooocus="--hf-mirror $HF_ENDPOINT"
            fi
            ;;
        lora-scripts)
            launch_sd_config="lora-scripts-launch.conf"
            ;;
        kohya_ss)
            launch_sd_config="kohya_ss-launch.conf"
            ;;
    esac

    term_sd_print_line "${term_sd_manager_info} 启动"
    term_sd_echo "提示: 可以按下 Ctrl+C 键终止 AI 软件的运行"
    case $term_sd_manager_info in
        InvokeAI)
            fallback_numpy_version
            invokeai-web --root "$invokeai_path"/invokeai $(cat "$start_path"/term-sd/config/$launch_sd_config)
            ;;
        *)
            enter_venv
            fallback_numpy_version
            term_sd_python $(cat "$start_path"/term-sd/config/$launch_sd_config) $hf_mirror_for_fooocus
            exit_venv
            ;;
    esac

    if [ $use_mirror_for_sd_webui = 0 ];then # 取消sd webui的插件列表镜像源
        unset WEBUI_EXTENSIONS_INDEX
    fi
    term_sd_pause
}

# 回滚numpy版本
fallback_numpy_version()
{
    local np_ver
    local np_major_ver

    np_ver=$(term_sd_pip freeze | grep "numpy==" | awk -F '==' '{print $NF}')
    np_major_ver=$(echo $np_ver | awk -F '.' '{print $1}')

    if [ $np_major_ver -gt 1 ];then
        term_sd_echo "检测到 Numpy 版本过高, 尝试回退版本中"
        install_python_package numpy==1.26.4
        if [ $? = 0 ];then
            term_sd_echo "Numpy 版本回退成功"
        else
            term_sd_echo "Numpy 版本回退失败"
        fi
    fi
}

# aria2下载工具
# 使用格式: aria2_download <下载链接> <下载路径> <文件名>
aria2_download()
{
    local model_url=$1
    local local_file_path
    local local_aria_cache_path
    local file_name
    local local_file_parent_path

    if [ -z "$2" ];then # 只有链接时
        local_file_path="$(basename $1)"
        local_aria_cache_path="${local_file_path}.aria2"
        file_name=$(basename "$local_file_path")
        local_file_parent_path=$(dirname "$local_file_path")
    elif [ -z "$3" ];then # 有链接和下载位置
        local_file_path="${2}/$(basename $1)"
        local_aria_cache_path="${local_file_path}.aria2"
        file_name=$(basename "$local_file_path")
        local_file_parent_path=$(dirname "$local_file_path")
    else # 链接,下载位置和下载文件名都有
        local_file_path="${2}/${3}"
        local_aria_cache_path="${local_file_path}.aria2"
        file_name=$(basename "$local_file_path")
        local_file_parent_path=$(dirname "$local_file_path")
    fi

    if [ ! -f "$local_file_path" ];then
        term_sd_echo "下载 ${file_name} 中"
        term_sd_try aria2c --file-allocation=none --summary-interval=0 --console-log-level=error -s 64 -c $aria2_multi_threaded $model_url -d "$local_file_parent_path" -o "$file_name"
    else
        if [ -f "$local_aria_cache_path" ];then
            term_sd_echo "恢复下载 ${file_name} 中"
            term_sd_try aria2c --file-allocation=none --summary-interval=0 --console-log-level=error -s 64 -c $aria2_multi_threaded $model_url -d "$local_file_parent_path" -o "$file_name"
        else
            term_sd_echo "${file_name} 文件已存在, 跳过下载该文件"
        fi
    fi
}

# 显示版本信息
term_sd_version()
{
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
    term_sd_ver="$term_sd_version_info - $(git -C term-sd show -s --format="%cd" --date=format:"%Y-%m-%d %H:%M:%S")"
    python_ver=$(term_sd_python --version | awk 'NR==1 {print $2}')
    python_major_version=$(echo $python_ver | awk -F '.' '{print $1}')
    python_minor_version=$(echo $python_ver | awk -F '.' '{print $2}')
    if [ $python_major_version = 3 ];then
        if [ $python_minor_version -ge 9 ] && [ $python_minor_version -le 11 ];then
            true
        else
            python_ver="$python_ver (版本不兼容!)"
        fi
    else
        python_ver="$python_ver (版本不兼容!)"
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
系统: $platform_info\n
Term-SD: $term_sd_ver\n
Python: $python_ver\n
Pip: $pip_ver\n
Aria2: $aria2_ver\n
Git: $git_ver\n
Dialog: $dialog_ver\n
Curl: $curl_ver\n
\n
提示:\n
使用方向键, Tab 键移动光标, 方向键 / F, B 键翻页 (鼠标滚轮无法翻页) , Enter 键进行选择, Space 键勾选或取消勾选 (已勾选时显示 [*] ), Ctrl+Shift+V 快捷键粘贴文本, 鼠标左键可点击按钮 (右键无效)\n
第一次使用 Term-SD 时先在主界面选择 Term-SD 帮助查看使用说明, 参数说明和注意的地方, 内容不定期更新" \
    $term_sd_dialog_height $term_sd_dialog_width
}

#主界面
term_sd_manager()
{
    local term_sd_manager_dialog
    local proxy_address_available
    export term_sd_manager_info=
    cd "$start_path" # 回到最初路径
    exit_venv # 确保进行下一步操作前已退出其他虚拟环境

    # 检测代理地址是否可用
    if [ ! -z "$http_proxy" ];then
        term_sd_echo "测试代理地址连通性中"
        curl -s --connect-timeout 1 "$http_proxy"
        if [ $? = 0 ];then
            proxy_address_available="(可用 ✓)"
        else
            proxy_address_available="(连接异常 ×)"
        fi
    fi

    term_sd_manager_dialog=$(dialog --erase-on-exit --notags \
        --title "Term-SD" \
        --backtitle "主界面" \
        --ok-label "确认" --cancel-label "退出" \
        --menu "请选择Term-SD的功能\n当前虚拟环境状态: $([ $venv_setup_status = 0 ] && echo "启用" || echo "禁用")\n当前 Github 镜像源设置: $([ -f "term-sd/config/set-global-github-mirror.conf" ] && echo "$(cat term-sd/config/set-global-github-mirror.conf | awk '{sub("/https://github.com","") sub("/github.com","")}1')" || echo "未设置")\n当前 HuggingFace 镜像源设置: $([ -f "term-sd/config/set-global-huggingface-mirror.conf" ] && echo "$HF_ENDPOINT" || echo "未设置")\n当前代理设置: $([ -z $http_proxy ] && echo "无" || echo "$http_proxy ${proxy_address_available}")" \
        $term_sd_dialog_height $term_sd_dialog_width $term_sd_dialog_menu_height \
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

    case $term_sd_manager_dialog in
        0) # 选择Term-SD更新
            term_sd_update_manager
            ;;
        1) # 选择stable-diffusion-webui
            term_sd_install_task_manager stable-diffusion-webui
            ;;
        2) # 选择ComfyUI
            term_sd_install_task_manager ComfyUI
            ;;
        3) # 选择InvokeAI
            term_sd_install_task_manager InvokeAI
            ;;
        4) # 选择fooocus
            term_sd_install_task_manager Fooocus
            ;;
        5) # 选择lora-scripts
            term_sd_install_task_manager lora-scripts
            ;;
        6) # 选择kohya_ss
            term_sd_install_task_manager kohya_ss
            ;;
        7) # 选择设置
            term_sd_setting
            ;;
        8) # 选择帮助
            term_sd_help
            ;;
        *) # 选择退出
            term_sd_print_line
            term_sd_echo "退出 Term-SD"
            exit 0
            ;;
    esac
}

# 帮助列表
term_sd_help()
{
    local term_sd_help_dialog

    while true
    do
        term_sd_help_dialog=$(dialog --erase-on-exit --notags \
            --title "Term-SD" \
            --backtitle "Term-SD 帮助选项" \
            --ok-label "确认" \
            --cancel-label "取消" \
            --menu "请选择帮助" \
            $term_sd_dialog_height $term_sd_dialog_width $term_sd_dialog_menu_height \
            "0" "> 返回" \
            "1" "> 关于 Term-SD" \
            "2" "> Term-SD 使用方法" \
            "3" "> 目录说明" \
            "4" "> Stable-Diffusion-WebUI 插件说明" \
            "5" "> ComfyUI 插件 / 自定义节点说明" \
            "6" "> 用户协议" \
            3>&1 1>&2 2>&3)

        case $term_sd_help_dialog in
            1)
                dialog --erase-on-exit \
                    --title "Term-SD" \
                    --backtitle "Term-SD 帮助选项" \
                    --ok-label "确认" \
                    --msgbox "$(cat term-sd/help/about.md)" \
                    $term_sd_dialog_height $term_sd_dialog_width
                ;;
            2)
                less --mouse \
                --prompt="[Term-SD] 提示\: 使用方向键 \/ U, D 键 \/ 鼠标滚轮进行翻页, 按下 Q 键返回帮助列表" term-sd/help/how_to_use_term_sd.md
                ;;
            3)
                dialog --erase-on-exit \
                    --title "Term-SD" \
                    --backtitle "Term-SD 帮助选项" \
                    --ok-label "确认" \
                    --msgbox "$(cat term-sd/help/directory_description.md)" \
                    $term_sd_dialog_height $term_sd_dialog_width
                ;;
            4)
                dialog --erase-on-exit \
                    --title "Term-SD" \
                    --backtitle "Term-SD 帮助选项" \
                    --ok-label "确认" \
                    --msgbox "$(cat term-sd/help/sd_webui_extension_description.md)" \
                    $term_sd_dialog_height $term_sd_dialog_width
                ;;
            5)
                dialog --erase-on-exit \
                    --title "Term-SD" \
                    --backtitle "Term-SD 帮助选项" \
                    --ok-label "确认" \
                    --msgbox "$(cat term-sd/help/comfyui_extension_description.md)" \
                    $term_sd_dialog_height $term_sd_dialog_width
                ;;
            6)
                dialog --erase-on-exit \
                    --title "Term-SD" \
                    --backtitle "Term-SD 帮助选项" \
                    --ok-label "确认" \
                    --msgbox "$(cat term-sd/help/user_agreement.md)" \
                    $term_sd_dialog_height $term_sd_dialog_width
                ;;
            *)
                break
                ;;
        esac
    done
}
