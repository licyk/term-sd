#!/bin/bash

# A1111 SD WebUI 启动脚本参数设置
# 启动参数保存在 <Start Path>/term-sd/config/sd-webui-launch.conf
a1111_sd_webui_launch_args_setting() {
    local arg
    local dialog_arg
    local launch_args
    local i

    dialog_arg=$(dialog --erase-on-exit --notags \
        --title "Stable-Diffusion-WebUI 管理" \
        --backtitle "Stable-Diffusion-WebUI 启动参数选项" \
        --ok-label "确认" --cancel-label "取消" \
        --checklist "请选择 A1111-Stable-Diffusion-WebUI 启动参数, 确认之后将覆盖原有启动参数配置" \
        $(get_dialog_size_menu) \
        "1" "(update-all-extensions) 启动时更新所有扩展" OFF \
        "2" "(skip-python-version-check) 跳过检查 Python 版本" OFF \
        "3" "(skip-torch-cuda-test) 跳过 CUDA 可用性检查" OFF \
        "4" "(reinstall-xformers) 启动时重新安装 xFormers" OFF \
        "5" "(reinstall-torch) 启动时重新安装 PyTorch" OFF \
        "6" "(update-check) 启动时检查更新" OFF \
        "7" "(test-server) 配置测试服务器" OFF \
        "8" "(log-startup) 显示详细启动日志" OFF \
        "9" "(skip-prepare-environment) 跳过所有环境准备工作" OFF \
        "10" "(skip-install) 跳过软件包的安装" OFF \
        "11" "(dump-sysinfo) 将系统信息文件保存到磁盘并退出" OFF \
        "12" "(do-not-download-clip) 跳过下载 CLIP 模型" OFF \
        "13" "(no-half) 关闭 UNet 半精度优化" OFF \
        "14" "(no-half-vae) 关闭 VAE 模型半精度优化" OFF \
        "15" "(no-progressbar-hiding) 不隐藏 Gradio UI 中进度条" OFF \
        "16" "(allow-code) 允许从 WebUI 执行自定义脚本" OFF \
        "17" "(medvram) 启用显存优化 (显存 < 6g 时推荐使用)" OFF \
        "18" "(medvram-sdxl) 仅在 SDXL 模型启用显存优化 (显存 < 8g 时推荐使用)" OFF \
        "19" "(lowvram) 启用显存优化 (显存 < 4g 时推荐使用)" OFF \
        "20" "(lowram) 将模型加载到显存中而不是内存中" OFF \
        "21" "(precision half) 使用模型半精度" OFF \
        "22" "(precision full) 使用模型全精度" OFF \
        "23" "(upcast-sampling) 使用向上采样法提高精度" OFF \
        "24" "(share) 通过 Gradio 共享" OFF \
        "25" "(enable-insecure-extension-access) 允许在开放远程访问时安装插件" OFF \
        "26" "(xformers) 尝试使用 xFormers 优化" OFF \
        "27" "(force-enable-xformers) 强制使用 xFormers 优化" OFF \
        "28" "(xformers-flash-attention) 使用 xFormers-Flash优化 (仅支持 SD2.x 以上)" OFF \
        "29" "(opt-split-attention) 使用 Split 优化" OFF \
        "30" "(opt-sub-quad-attention) 使用 Sub-Quad 优化" OFF \
        "31" "(opt-split-attention-invokeai) 使用 Sub-Quad-InvokeAI 优化" OFF \
        "32" "(opt-split-attention-v1) 使用 Sub-Quad-V1 优化" OFF \
        "33" "(opt-sdp-attention) 使用 Sdp 优化 (仅限 PyTorch2.0 以上)" OFF \
        "34" "(opt-sdp-no-mem-attention) 使用无高效内存使用的 Sdp 优化" OFF \
        "35" "(disable-opt-split-attention) 禁用 Split 优化" OFF \
        "36" "(disable-nan-check) 禁用潜空间 NAN 检查" OFF \
        "37" "(use-cpu) 使用 CPU 进行生图" OFF \
        "38" "(disable-model-loading-ram-optimization) 禁用减少内存使用的优化" OFF \
        "39" "(listen) 开放远程连接" OFF \
        "40" "(hide-ui-dir-config) 隐藏 WebUI 目录配置" OFF \
        "41" "(freeze-settings) 冻结 WebUI 设置" OFF \
        "42" "(gradio-debug) 以 Debug 模式启用 Gradio" OFF \
        "43" "(opt-channelslast) 使用 Channelslast 内存格式优化" OFF \
        "44" "(autolaunch) 启动 WebUI 完成后自动启动浏览器" OFF \
        "45" "(theme dark) 使用黑暗主题" OFF \
        "46" "(use-textbox-seed) 使用文本框在 WebUI 中生成的种子" OFF \
        "47" "(disable-console-progressbars) 禁用控制台进度条显示" OFF \
        "48" "(enable-console-prompts) 启用在生图时输出提示词到控制台" OFF \
        "49" "(disable-safe-unpickle) 禁用检查模型是否包含恶意代码" OFF \
        "50" "(api) 启用 API" OFF \
        "51" "(api-log) 启用输出所有 API 请求的日志记录" OFF \
        "52" "(nowebui) 不加载 WebUI 界面" OFF \
        "53" "(ui-debug-mode) 不加载模型启动 WebUI (UI Debug)" OFF \
        "54" "(administrator) 启用管理员权限" OFF \
        "55" "(disable-tls-verify) 禁用 TLS 证书验证" OFF \
        "56" "(no-gradio-queue) 禁用 Gradio 队列" OFF \
        "57" "(skip-version-check) 禁用 PyTorch, xFormers 版本检查" OFF \
        "58" "(no-hashing) 禁用模型 Hash 检查" OFF \
        "59" "(no-download-sd-model) 禁用自动下载模型, 即使模型路径无模型" OFF \
        "60" "(add-stop-route) 添加 /_stop 路由以停止服务器" OFF \
        "61" "(api-server-stop) 通过 API 启用服务器停止/重启/终止功能" OFF \
        "62" "(disable-all-extensions) 禁用所有扩展运行" OFF \
        "63" "(disable-extra-extensions) 禁用非内置的扩展运行" OFF \
        "64" "(use-ipex) 使用 Intel XPU 作为生图后端" OFF \
        "65" "(skip-load-model-at-start) 启动 WebUI 时不加载模型, 加速启动" OFF \
        3>&1 1>&2 2>&3)

    if [[ "$?" == 0 ]]; then
        for i in ${dialog_arg}; do
            case "${i}" in
                1)
                    arg="--update-all-extensions"
                    ;;
                2)
                    arg="--skip-python-version-check"
                    ;;
                3)
                    arg="--skip-torch-cuda-test"
                    ;;
                4)
                    arg="--reinstall-xformers"
                    ;;
                5)
                    arg="--reinstall-torch"
                    ;;
                6)
                    arg="--update-check"
                    ;;
                7)
                    arg="--test-server"
                    ;;
                8)
                    arg="--log-startup"
                    ;;
                9)
                    arg="--skip-prepare-environment"
                    ;;
                10)
                    arg="--skip-install"
                    ;;
                11)
                    arg="--dump-sysinfo"
                    ;;
                12)
                    arg="--do-not-download-clip"
                    ;;
                13)
                    arg="--no-half"
                    ;;
                14)
                    arg="--no-half-vae"
                    ;;
                15)
                    arg="--no-progressbar-hiding"
                    ;;
                16)
                    arg="--allow-code"
                    ;;
                17)
                    arg="--medvram"
                    ;;
                18)
                    arg="--medvram-sdxl"
                    ;;
                19)
                    arg="--lowvram"
                    ;;
                20)
                    arg="--lowram"
                    ;;
                21)
                    arg="--precision half"
                    ;;
                22)
                    arg="--precision full"
                    ;;
                23)
                    arg="--upcast-sampling"
                    ;;
                24)
                    arg="--share"
                    ;;
                25)
                    arg="--enable-insecure-extension-access"
                    ;;
                26)
                    arg="--xformers"
                    ;;
                27)
                    arg="--force-enable-xformers"
                    ;;
                28)
                    arg="--xformers-flash-attention"
                    ;;
                29)
                    arg="--opt-split-attention"
                    ;;
                30)
                    arg="--opt-sub-quad-attention"
                    ;;
                31)
                    arg="--opt-split-attention-invokeai"
                    ;;
                32)
                    arg="--opt-split-attention-v1"
                    ;;
                33)
                    arg="--opt-sdp-attention"
                    ;;
                34)
                    arg="--opt-sdp-no-mem-attention"
                    ;;
                35)
                    arg="--disable-opt-split-attention"
                    ;;
                36)
                    arg="--disable-nan-check"
                    ;;
                37)
                    arg="--use-cpu all"
                    ;;
                38)
                    arg="--disable-model-loading-ram-optimization"
                    ;;
                39)
                    arg="--listen"
                    ;;
                40)
                    arg="--hide-ui-dir-config"
                    ;;
                41)
                    arg="--freeze-settings"
                    ;;
                42)
                    arg="--gradio-debug"
                    ;;
                43)
                    arg="--opt-channelslast"
                    ;;
                44)
                    arg="--autolaunch"
                    ;;
                45)
                    arg="--theme dark"
                    ;;
                46)
                    arg="--use-textbox-seed"
                    ;;
                47)
                    arg="--disable-console-progressbars"
                    ;;
                48)
                    arg="--enable-console-prompts"
                    ;;
                49)
                    arg="--disable-safe-unpickle"
                    ;;
                50)
                    arg="--api"
                    ;;
                51)
                    arg="--api-log"
                    ;;
                52)
                    arg="--nowebui"
                    ;;
                53)
                    arg="--ui-debug-mode"
                    ;;
                54)
                    arg="--administrator"
                    ;;
                55)
                    arg="--disable-tls-verify"
                    ;;
                56)
                    arg="--no-gradio-queue"
                    ;;
                57)
                    arg="--skip-version-check"
                    ;;
                58)
                    arg="--no-hashing"
                    ;;
                59)
                    arg="--no-download-sd-model"
                    ;;
                60)
                    arg="--add-stop-route"
                    ;;
                61)
                    arg="--api-server-stop"
                    ;;
                62)
                    arg="--disable-all-extensions"
                    ;;
                63)
                    arg="--disable-extra-extensions"
                    ;;
                64)
                    arg="--use-ipex"
                    ;;
                65)
                    arg="--skip-load-model-at-start"
                    ;;
            esac
            launch_args="${arg} ${launch_args}"
        done

        # 生成启动脚本
        term_sd_echo "设置 A1111-Stable-Diffusion-WebUI 启动参数: ${launch_args}"
        echo "launch.py ${launch_args}" > "${START_PATH}"/term-sd/config/sd-webui-launch.conf
    else
        term_sd_echo "取消设置 A1111-Stable-Diffusion-WebUI 启动参数"
    fi
}

# A1111 SD WebUI 启动界面
a1111_sd_webui_launch() {
    local dialog_arg
    local launch_args

    add_a1111_sd_webui_normal_launch_args # 当没有设置启动参数时默认生成一个启动参数

    while true; do
        launch_args=$(cat "${START_PATH}"/term-sd/config/sd-webui-launch.conf)
        if is_use_venv; then
            launch_args="python ${launch_args}"
        else
            launch_args="${TERM_SD_PYTHON_PATH} ${launch_args}"
        fi

        dialog_arg=$(dialog --erase-on-exit --notags \
            --title "Stable-Diffusion-WebUI 管理" \
            --backtitle "Stable-Diffusion-WebUI 启动选项" \
            --ok-label "确认" --cancel-label "取消" \
            --menu "请选择启动 A1111-Stable-Diffusion-WebUI / 修改 A1111-Stable-Diffusion-WebUI 启动参数\n当前启动参数: ${launch_args}" \
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
                a1111_sd_webui_launch_args_setting
                ;;
            3)
                a1111_sd_webui_launch_args_revise
                ;;
            4)
                restore_a1111_sd_webui_launch_args
                ;;
            *)
                break
                ;;
        esac
    done
}

# A1111 SD WebUI 启动参数修改
# 启动修改界面时将从 <Start Path>/term-sd/config/sd-webui-launch.conf 中读取启动参数
# 可接着上次的启动参数进行修改
a1111_sd_webui_launch_args_revise() {
    local dialog_arg
    local launch_args

    launch_args=$(cat "${START_PATH}"/term-sd/config/sd-webui-launch.conf | awk '{sub("launch.py ","")}1')

    dialog_arg=$(dialog --erase-on-exit \
        --title "Stable-Diffusion-WebUI 管理" \
        --backtitle "Stable-Diffusion-WebUI 自定义启动参数选项" \
        --ok-label "确认" --cancel-label "取消" \
        --inputbox "请输入 A1111-Stable-Diffusion-WebUI 启动参数" \
        $(get_dialog_size) \
        "${launch_args}" \
        3>&1 1>&2 2>&3)

    if [[ "$?" == 0 ]]; then
        term_sd_echo "设置 A1111-Stable-Diffusion-WebUI 启动参数: ${dialog_arg}"
        echo "launch.py ${dialog_arg}" > "${START_PATH}"/term-sd/config/sd-webui-launch.conf
    else
        term_sd_echo "取消修改 A1111-Stable-Diffusion-WebUI 启动参数"
    fi
}

# 添加默认启动参数配置
add_a1111_sd_webui_normal_launch_args() {
    if [ ! -f "${START_PATH}/term-sd/config/sd-webui-launch.conf" ]; then # 找不到启动配置时默认生成一个
        if [[ "${OSTYPE}" == "darwin"* ]]; then
            echo "launch.py --theme dark --autolaunch --api --skip-load-model-at-start --skip-torch-cuda-test --upcast-sampling --no-half-vae --use-cpu interrogate" > "${START_PATH}"/term-sd/config/sd-webui-launch.conf
        else
            echo "launch.py --theme dark --autolaunch --xformers --api --skip-load-model-at-start" > "${START_PATH}"/term-sd/config/sd-webui-launch.conf
        fi
    fi
}

# 重置启动参数
restore_a1111_sd_webui_launch_args() {
    if (dialog --erase-on-exit \
        --title "Stable-Diffusion-WebUI 管理" \
        --backtitle "Stable-Diffusion-WebUI 重置启动参数选项选项" \
        --yes-label "是" --no-label "否" \
        --yesno "是否重置 A1111-Stable-Diffusion-WebUI 启动参数 ?" \
        $(get_dialog_size)); then

        term_sd_echo "重置 A1111-Stable-Diffusion-WebUI 启动参数"
        rm -f "${START_PATH}"/term-sd/config/sd-webui-launch.conf
        add_a1111_sd_webui_normal_launch_args
    else
        term_sd_echo "取消重置 A1111-Stable-Diffusion-WebUI 启动参数操作"
    fi
}