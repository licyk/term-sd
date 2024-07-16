#!/bin/bash

# Vlad SD WebUI 启动参数配置
# 启动参数保存在 <Start Path>/term-sd/config/vlad-sd-webui-launch.conf
vlad_sd_webui_launch_args_setting() {
    local dialog_arg
    local arg
    local launch_args
    local i

    # 展示启动参数选项
    dialog_arg=$(dialog --erase-on-exit --notags \
        --title "Stable-Diffusion-WebUI 管理" \
        --backtitle "Stable-Diffusion-WebUI 启动参数选项" \
        --ok-label "确认" --cancel-label "取消" \
        --checklist "请选择 SD.NEXT 启动参数, 确认之后将覆盖原有启动参数配置" \
        $(get_dialog_size_menu) \
        "1" "(medvram) 启用显存优化 (显存 < 6g 时推荐使用)" OFF \
        "2" "(lowvram) 启用显存优化(显存 <4g 时推荐使用)" OFF \
        "3" "(allow-code) 允许从 WebUI 执行自定义脚本" OFF \
        "4" "(share) 通过 Gradio 共享" OFF \
        "5" "(insecure) 启用扩展标签" OFF \
        "6" "(use-cpu) 使用 CPU 进行生图" OFF \
        "7" "(listen) 开放远程连接" OFF \
        "8" "(freeze) 冻结 WebUI 设置" OFF \
        "9" "(autolaunch) 启动 WebUI 完成后自动启动浏览器" ON \
        "10" "(docs) 在 /docs 处挂载 Gradio 文档" OFF \
        "11" "(api-only) 在无 WebUI 界面时启用 API" OFF \
        "12" "(api-log) 启用输出所有 API 请求的日志记录" OFF \
        "13" "(tls-selfsign) 使用自签名证书启用 TLS" OFF \
        "14" "(no-hashing) 禁用模型 Hash 检查" OFF \
        "15" "(no-metadata) 禁用从模型中读取元数据" OFF \
        "16" "(no-download) 禁用自动下载模型, 即使模型路径无模型" OFF \
        "17" "(profile) 运行分析器" OFF \
        "18" "(disable-queue) 禁用 Gradio 队列" OFF \
        "19" "(backend original) 使用原始后端进行生图" OFF \
        "20" "(backend diffusers) 使用 Diffusers 后端进行生图" OFF \
        "21" "(debug) 以 Debug 模式运行安装程序" OFF \
        "22" "(reset) 将 WebUI 主仓库重置为最新版本" OFF \
        "23" "(upgrade) 将 WebUI 主仓库升级为最新版本" OFF \
        "24" "(requirements) 强制检查依赖" OFF \
        "25" "(quick) 仅运行启动模块" OFF \
        "26" "(use-directml) 使用 DirectML 作为后端进行生图" OFF \
        "27" "(use-openvino) 使用 OpenVINO 作为后端进行生图" OFF \
        "28" "(use-ipex) 使用 IPEX 作为后端进行生图" OFF \
        "29" "(use-cuda) 使用 CUDA 作为后端进行生图" ON \
        "30" "(use-rocm) 使用 ROCM 作为后端进行生图" OFF \
        "31" "(use-xformers) 使用 xFormers 优化" ON \
        "32" "(skip-requirements) 跳过依赖检查" OFF \
        "33" "(skip-extensions) 跳过运行单个扩展安装程序" OFF \
        "34" "(skip-git) 跳过所有 Git 操作" OFF \
        "35" "(skip-torch) 跳过 PyTorch 检查" OFF \
        "36" "(skip-all) 跳过运行所有检查" OFF \
        "37" "(experimental) 允许使用不受支持版本的库" OFF \
        "38" "(reinstall) 强制重新安装所有要求" OFF \
        "39" "(test) 仅运行测试并退出" OFF \
        "40" "(ignore) 忽略任何错误并尝试继续" OFF \
        "41" "(safe) 在安全模式下运行, 不使用用户扩展" OFF \
        3>&1 1>&2 2>&3)

    if [[ "$?" == 0 ]]; then
        for i in ${dialog_arg}; do
            case "${i}" in
                1)
                    arg="--medvram"
                    ;;
                2)
                    arg="--lowvram"
                    ;;
                3)
                    arg="--allow-code"
                    ;;
                4)
                    arg="--share"
                    ;;
                5)
                    arg="--insecure"
                    ;;
                6)
                    arg="--use-cpu all"
                    ;;
                7)
                    arg="--listen"
                    ;;
                8)
                    arg="--freeze"
                    ;;
                9)
                    arg="--autolaunch"
                    ;;
                10)
                    arg="--docs"
                    ;;
                11)
                    arg="--api-only"
                    ;;
                12)
                    arg="--api-log"
                    ;;
                13)
                    arg="--tls-selfsign"
                    ;;
                14)
                    arg="--no-hashing"
                    ;;
                15)
                    arg="--no-metadata"
                    ;;
                16)
                    arg="--no-download"
                    ;;
                17)
                    arg="--profile"
                    ;;
                18)
                    arg="--disable-queue"
                    ;;
                19)
                    arg="--backend original"
                    ;;
                20)
                    arg="--backend diffusers"
                    ;;
                21)
                    arg="--debug"
                    ;;
                22)
                    arg="--reset"
                    ;;
                23)
                    arg="--upgrade"
                    ;;
                24)
                    arg="--requirements"
                    ;;
                25)
                    arg="--quick"
                    ;;
                26)
                    arg="--use-directml"
                    ;;
                27)
                    arg="--use-openvino"
                    ;;
                28)
                    arg="--use-ipex"
                    ;;
                29)
                    arg="--use-cuda"
                    ;;
                30)
                    arg="--use-rocm"
                    ;;
                31)
                    arg="--use-xformers"
                    ;;
                32)
                    arg="--skip-requirements"
                    ;;
                33)
                    arg="--skip-extensions"
                    ;;
                34)
                    arg="--skip-git"
                    ;;
                35)
                    arg="--skip-torch"
                    ;;
                36)
                    arg="--skip-all"
                    ;;
                37)
                    arg="--experimental"
                    ;;
                38)
                    arg="--reinstall"
                    ;;
                39)
                    arg="--test"
                    ;;
                40)
                    arg="--ignore"
                    ;;
                41)
                    arg="--safe"
                    ;;
            esac
            launch_args="${arg} ${launch_args}"
        done
    
        # 生成启动脚本
        term_sd_echo "设置 SD.NEXT 启动参数: ${launch_args}"
        echo "launch.py ${launch_args}" > "${START_PATH}"/term-sd/config/vlad-sd-webui-launch.conf
    else
        term_sd_echo "取消设置 SD.NEXT 启动参数"
    fi
}

# Vlad SD WebUI 启动界面
vlad_sd_webui_launch() {
    local dialog_arg
    local launch_args

    add_vlad_sd_webui_normal_launch_args

    while true; do
        launch_args=$(cat "${START_PATH}"/term-sd/config/vlad-sd-webui-launch.conf)

        if is_use_venv; then
            launch_args="python ${launch_args}"
        else
            launch_args="${TERM_SD_PYTHON_PATH} ${launch_args}"
        fi

        dialog_arg=$(dialog --erase-on-exit --notags \
            --title "Stable-Diffusion-WebUI 管理" \
            --backtitle "Stable-Diffusion-WebUI 启动选项" \
            --ok-label "确认" --cancel-label "取消" \
            --menu "请选择启动 SD.NEXT / 修改 SD.NEXT 启动参数\n当前启动参数: ${launch_args}" \
            $(get_dialog_size_menu) \
            "0" "> 返回" \
            "1" "> 启动" \
            "2" "> 配置预设启动参数" \
            "3" "> 修改自定义启动参数" \
            "4" "> 重置启动参数" \
            3>&1 1>&2 2>&3)

        case "${dialog_arg}" in
            1)
                term_sd_launch
                ;;
            2)
                vlad_sd_webui_launch_args_setting
                ;;
            3)
                vlad_sd_webui_launch_args_revise
                ;;
            4)
                add_vlad_sd_webui_normal_launch_args
                ;;
            *)
                break
                ;;
        esac
    done
}

# Vlad SD WebUI 启动参数修改界面
# 修改前从 <Start Path>/term-sd/config/vlad-sd-webui-launch.conf 读取启动参数
# 可在上次的基础上修改
vlad_sd_webui_launch_args_revise() {
    local dialog_arg
    local launch_args

    launch_args=$(cat "${START_PATH}"/term-sd/config/vlad-sd-webui-launch.conf | awk '{sub("launch.py ","")}1')

    dialog_arg=$(dialog --erase-on-exit \
        --title "Stable-Diffusion-WebUI 管理" \
        --backtitle "Stable-Diffusion-WebUI 自定义启动参数选项" \
        --ok-label "确认" --cancel-label "取消" \
        --inputbox "请输入 SD.NEXT 启动参数" \
        $(get_dialog_size) \
        "${launch_args}" \
        3>&1 1>&2 2>&3)

    if [[ "$?" == 0 ]]; then
        term_sd_echo "设置 SD.NEXT 启动参数: ${dialog_arg}"
        echo "launch.py ${dialog_arg}" > "${START_PATH}"/term-sd/config/vlad-sd-webui-launch.conf
    else
        term_sd_echo "取消修改 SD.NEXT 启动参数"
    fi
}

# 添加默认启动参数配置
add_vlad_sd_webui_normal_launch_args() {
    if [[ ! -f "${START_PATH}/term-sd/config/vlad-sd-webui-launch.conf" ]]; then # 找不到启动配置时默认生成一个
        echo "launch.py --autolaunch --use-cuda --use-xformers" > "${START_PATH}"/term-sd/config/vlad-sd-webui-launch.conf
    fi
}

# 重置启动参数
restore_vlad_sd_webui_launch_args() {
    if (dialog --erase-on-exit \
        --title "Stable-Diffusion-WebUI 管理" \
        --backtitle "Stable-Diffusion-WebUI 重置启动参数选项选项" \
        --yes-label "是" --no-label "否" \
        --yesno "是否重置 SD.NEXT 启动参数" \
        $(get_dialog_size)); then

        term_sd_echo "重置启动参数"
        rm -f "${START_PATH}"/term-sd/config/vlad-sd-webui-launch.conf
        add_vlad_sd_webui_normal_launch_args
    else
        term_sd_echo "取消重置操作"
    fi
}