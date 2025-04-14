#!/bin/bash

# SD WebUI reForge 启动参数配置
# 启动参数将保存在 <Start Path>/term-sd/config/sd-webui-reforge-launch.conf
sd_webui_reforge_launch_args_setting() {
    local arg
    local dialog_arg
    local launch_args
    local i

    dialog_arg=$(dialog --erase-on-exit --notags \
        --title "Stable-Diffusion-WebUI 管理" \
        --backtitle "Stable-Diffusion-WebUI 启动参数选项" \
        --ok-label "确认" --cancel-label "取消" \
        --checklist "请选择 Stable-Diffusion-WebUI-reForge 启动参数, 确认之后将覆盖原有启动参数配置" \
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
        "21" "(precision full) 使用模型全精度" OFF \
        "22" "(upcast-sampling) 使用向上采样法提高精度" OFF \
        "23" "(share) 通过 Gradio 共享" OFF \
        "24" "(enable-insecure-extension-access) 允许在开放远程访问时安装插件" OFF \
        "25" "(xformers) 尝试使用 xFormers 优化" OFF \
        "26" "(force-enable-xformers) 强制使用 xFormers 优化" OFF \
        "27" "(xformers-flash-attention) 使用 xFormers-Flash优化 (仅支持 SD2.x 以上)" OFF \
        "28" "(opt-split-attention) 使用 Split 优化" OFF \
        "29" "(opt-sub-quad-attention) 使用 Sub-Quad 优化" OFF \
        "30" "(opt-split-attention-invokeai) 使用 Sub-Quad-InvokeAI 优化" OFF \
        "31" "(opt-split-attention-v1) 使用 Sub-Quad-V1 优化" OFF \
        "32" "(opt-sdp-attention) 使用 Sdp 优化 (仅限 PyTorch2.0 以上)" OFF \
        "33" "(opt-sdp-no-mem-attention) 使用无高效内存使用的 Sdp 优化" OFF \
        "34" "(disable-opt-split-attention) 禁用 Split 优化" OFF \
        "35" "(disable-nan-check) 禁用潜空间 NAN 检查" OFF \
        "36" "(use-cpu) 使用 CPU 进行生图" OFF \
        "37" "(disable-model-loading-ram-optimization) 禁用减少内存使用的优化" OFF \
        "38" "(listen) 开放远程连接" OFF \
        "39" "(hide-ui-dir-config) 隐藏 WebUI 目录配置" OFF \
        "40" "(freeze-settings) 冻结 WebUI 设置" OFF \
        "41" "(gradio-debug) 以 Debug 模式启用 Gradio" OFF \
        "42" "(opt-channelslast) 使用 ChannelsLast 内存格式优化" OFF \
        "43" "(autolaunch) 启动 WebUI 完成后自动启动浏览器" OFF \
        "44" "(theme dark) 使用黑暗主题" OFF \
        "45" "(use-textbox-seed) 使用文本框在 WebUI 中生成的种子" OFF \
        "46" "(disable-console-progressbars) 禁用控制台进度条显示" OFF \
        "47" "(enable-console-prompts) 启用在生图时输出提示词到控制台" OFF \
        "48" "(disable-safe-unpickle) 禁用检查模型是否包含恶意代码" OFF \
        "49" "(api) 启用 API" OFF \
        "50" "(api-log) 启用输出所有 API 请求的日志记录" OFF \
        "51" "(nowebui) 不加载 WebUI 界面" OFF \
        "52" "(ui-debug-mode) 不加载模型启动 WebUI (UI Debug)" OFF \
        "53" "(administrator) 启用管理员权限" OFF \
        "54" "(disable-tls-verify) 禁用 TLS 证书验证" OFF \
        "55" "(no-gradio-queue) 禁用 Gradio 队列" OFF \
        "56" "(skip-version-check) 禁用 PyTorch, xFormers 版本检查" OFF \
        "57" "(no-hashing) 禁用模型 Hash 检查" OFF \
        "58" "(no-download-sd-model) 禁用自动下载模型, 即使模型路径无模型" OFF \
        "59" "(add-stop-route) 添加 /_stop 路由以停止服务器" OFF \
        "60" "(api-server-stop) 通过 API 启用服务器停止 / 重启 / 终止功能" OFF \
        "61" "(disable-all-extensions) 禁用所有扩展运行" OFF \
        "62" "(disable-extra-extensions) 禁用非内置的扩展运行" OFF \
        "63" "(use-ipex) 使用 Intel XPU 作为生图后端" OFF \
        "64" "(skip-load-model-at-start) 启动 WebUI 时不加载模型, 加速启动" OFF \
        "65" "(in-browser) 启动 WebUI 完成后自动启动浏览器" OFF \
        "66" "(disable-in-browser) 禁用在启动 WebUI 完成后自动启动浏览器" OFF \
        "67" "(async-cuda-allocation) 启用 CUDA 流顺序内存分配器" OFF \
        "68" "(disable-async-cuda-allocation) 禁用 CUDA 流顺序内存分配器" OFF \
        "69" "(disable-attention-upcast) 禁用向上注意力优化" OFF \
        "70" "(all-in-fp32) 强制使用 FP32" OFF \
        "71" "(all-in-fp16) 强制使用 FP16" OFF \
        "72" "(unet-in-bf16) 使用 BF16 精度运行 UNet" OFF \
        "73" "(unet-in-fp16) 使用 FP16 精度运行 UNet" OFF \
        "74" "(unet-in-fp8-e4m3fn) 使用 FP8(e4m3fn) 精度运行 UNet" OFF \
        "75" "(unet-in-fp8-e5m2) 使用 FP8(e5m2) 精度运行 UNet" OFF \
        "76" "(vae-in-fp16) 使用 FP16 精度运行 VAE" OFF \
        "77" "(vae-in-fp32) 使用 FP32 精度运行 VAE" OFF \
        "78" "(vae-in-bf16) 使用 BF16 精度运行 VAE" OFF \
        "79" "(vae-in-cpu) 将 VAE 移至 CPU" OFF \
        "80" "(clip-in-fp8-e4m3fn) 使用 FP8(e4m3fn) 精度运行 CLIP" OFF \
        "81" "(clip-in-fp8-e5m2) 使用 FP8(e5m2) 精度运行 CLIP" OFF \
        "82" "(clip-in-fp16) 使用 FP16 精度运行 CLIP" OFF \
        "83" "(clip-in-fp32) 使用 FP32 精度运行 CLIP" OFF \
        "84" "(disable-ipex-hijack) 禁用 IEPX 修复" OFF \
        "85" "(preview-option none) 不使用图片预览" OFF \
        "86" "(preview-option fast) 使用快速图片预览" OFF \
        "87" "(preview-option taesd) 使用 TAESD 图片预览" OFF \
        "88" "(attention-split) 使用 Split 优化" OFF \
        "89" "(attention-quad) 使用 Quad 优化" OFF \
        "90" "(attention-pytorch) 使用 PyTorch 方案优化" OFF \
        "91" "(disable-xformers) 禁用 xFormers 优化" OFF \
        "92" "(always-gpu) 将所有模型, 文本编码器储存在 GPU 中" OFF \
        "93" "(always-high-vram) 不使用显存优化" OFF \
        "94" "(always-normal-vram) 使用默认显存优化" OFF \
        "95" "(always-low-vram) 使用显存优化 (将会降低生图速度)" OFF \
        "96" "(always-no-vram) 使用显存优化 (将会大量降低生图速度)" OFF \
        "97" "(always-cpu) 使用 CPU 进行生图" OFF \
        "98" "(always-offload-from-vram) 生图完成后将模型从显存中卸载" OFF \
        "99" "(pytorch-deterministic) 将 PyTorch 配置为使用确定性算法" OFF \
        "100" "(disable-server-log) 禁用服务端日志输出" OFF \
        "101" "(debug-mode) 启用 Debug 模式" OFF \
        "102" "(is-windows-embedded-python) 启用 Windows 独占功能" OFF \
        "103" "(disable-server-info) 禁用服务端信息输出" OFF \
        "104" "(multi-user) 启用多用户模式" OFF \
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
                    arg="--precision full"
                    ;;
                22)
                    arg="--upcast-sampling"
                    ;;
                23)
                    arg="--share"
                    ;;
                24)
                    arg="--enable-insecure-extension-access"
                    ;;
                25)
                    arg="--xformers"
                    ;;
                26)
                    arg="--force-enable-xformers"
                    ;;
                27)
                    arg="--xformers-flash-attention"
                    ;;
                28)
                    arg="--opt-split-attention"
                    ;;
                29)
                    arg="--opt-sub-quad-attention"
                    ;;
                30)
                    arg="--opt-split-attention-invokeai"
                    ;;
                31)
                    arg="--opt-split-attention-v1"
                    ;;
                32)
                    arg="--opt-sdp-attention"
                    ;;
                33)
                    arg="--opt-sdp-no-mem-attention"
                    ;;
                34)
                    arg="--disable-opt-split-attention"
                    ;;
                35)
                    arg="--disable-nan-check"
                    ;;
                36)
                    arg="--use-cpu all"
                    ;;
                37)
                    arg="--disable-model-loading-ram-optimization"
                    ;;
                38)
                    arg="--listen"
                    ;;
                39)
                    arg="--hide-ui-dir-config"
                    ;;
                40)
                    arg="--freeze-settings"
                    ;;
                41)
                    arg="--gradio-debug"
                    ;;
                42)
                    arg="--opt-channelslast"
                    ;;
                43)
                    arg="--autolaunch"
                    ;;
                44)
                    arg="--theme dark"
                    ;;
                45)
                    arg="--use-textbox-seed"
                    ;;
                46)
                    arg="--disable-console-progressbars"
                    ;;
                47)
                    arg="--enable-console-prompts"
                    ;;
                48)
                    arg="--disable-safe-unpickle"
                    ;;
                49)
                    arg="--api"
                    ;;
                50)
                    arg="--api-log"
                    ;;
                51)
                    arg="--nowebui"
                    ;;
                52)
                    arg="--ui-debug-mode"
                    ;;
                53)
                    arg="--administrator"
                    ;;
                54)
                    arg="--disable-tls-verify"
                    ;;
                55)
                    arg="--no-gradio-queue"
                    ;;
                56)
                    arg="--skip-version-check"
                    ;;
                57)
                    arg="--no-hashing"
                    ;;
                58)
                    arg="--no-download-sd-model"
                    ;;
                59)
                    arg="--add-stop-route"
                    ;;
                60)
                    arg="--api-server-stop"
                    ;;
                61)
                    arg="--disable-all-extensions"
                    ;;
                62)
                    arg="--disable-extra-extensions"
                    ;;
                63)
                    arg="--use-ipex"
                    ;;
                64)
                    arg="--skip-load-model-at-start"
                    ;;
                65)
                    arg="--in-browser"
                    ;;
                66)
                    arg="--disable-in-browser"
                    ;;
                67)
                    arg="--async-cuda-allocation"
                    ;;
                68)
                    arg="--disable-async-cuda-allocation"
                    ;;
                69)
                    arg="--disable-attention-upcast"
                    ;;
                70)
                    arg="--all-in-fp32"
                    ;;
                71)
                    arg="--all-in-fp16"
                    ;;
                72)
                    arg="--unet-in-bf16"
                    ;;
                73)
                    arg="--unet-in-fp16"
                    ;;
                74)
                    arg="--unet-in-fp8-e4m3fn"
                    ;;
                75)
                    arg="--unet-in-fp8-e5m2"
                    ;;
                76)
                    arg="--vae-in-fp16"
                    ;;
                77)
                    arg="--vae-in-fp32"
                    ;;
                78)
                    arg="--vae-in-bf16"
                    ;;
                79)
                    arg="--vae-in-cpu"
                    ;;
                80)
                    arg="--clip-in-fp8-e4m3fn"
                    ;;
                81)
                    arg="--clip-in-fp8-e5m2"
                    ;;
                82)
                    arg="--clip-in-fp16"
                    ;;
                83)
                    arg="--clip-in-fp32"
                    ;;
                84)
                    arg="--disable-ipex-hijack"
                    ;;
                85)
                    arg="--preview-option none"
                    ;;
                86)
                    arg="--preview-option fast"
                    ;;
                87)
                    arg="--preview-option taesd"
                    ;;
                88)
                    arg="--attention-split"
                    ;;
                89)
                    arg="--attention-quad"
                    ;;
                90)
                    arg="--attention-pytorch"
                    ;;
                91)
                    arg="--disable-xformers"
                    ;;
                92)
                    arg="--always-gpu"
                    ;;
                93)
                    arg="--always-high-vram"
                    ;;
                94)
                    arg="--always-normal-vram"
                    ;;
                95)
                    arg="--always-low-vram"
                    ;;
                96)
                    arg="--always-no-vram"
                    ;;
                97)
                    arg="--always-cpu"
                    ;;
                98)
                    arg="--always-offload-from-vram"
                    ;;
                99)
                    arg="--pytorch-deterministic"
                    ;;
                100)
                    arg="--disable-server-log"
                    ;;
                101)
                    arg="--debug-mode"
                    ;;
                102)
                    arg="--is-windows-embedded-python"
                    ;;
                103)
                    arg="--disable-server-info"
                    ;;
                104)
                    arg="--multi-user"
                    ;;
            esac
            launch_args="${arg} ${launch_args}"
        done
    
        # 生成启动脚本
        term_sd_echo "设置 Stable-Diffusion-WebUI-reForge 启动参数: ${launch_args}"
        echo "launch.py ${launch_args}" > "${START_PATH}"/term-sd/config/sd-webui-reforge-launch.conf
    else
        term_sd_echo "取消设置 Stable-Diffusion-WebUI-reForge 启动参数"
    fi
}

# SD WebUI reForge 启动界面
sd_webui_reforge_launch() {
    local dialog_arg
    local launch_args

    add_sd_webui_reforge_normal_launch_args

    while true; do
        launch_args=$(cat "${START_PATH}"/term-sd/config/sd-webui-reforge-launch.conf)

        if is_use_venv; then
            launch_args="python ${launch_args}"
        else
            launch_args="${TERM_SD_PYTHON_PATH} ${launch_args}"
        fi

        dialog_arg=$(dialog --erase-on-exit --notags \
            --title "Stable-Diffusion-WebUI 管理" \
            --backtitle "Stable-Diffusion-WebUI 启动选项" \
            --ok-label "确认" --cancel-label "取消" \
            --menu "请选择启动 Stable-Diffusion-WebUI-reForge / 修改 Stable-Diffusion-WebUI-reForge 启动参数\n当前启动参数: ${launch_args}" \
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
                sd_webui_reforge_launch_args_setting
                ;;
            3)
                sd_webui_reforge_launch_args_revise
                ;;
            4)
                restore_sd_webui_reforge_launch_args
                ;;
            *)
                break
                ;;
        esac
    done
}

# SD WebUI reForge 启动参数修改
sd_webui_reforge_launch_args_revise() {
    local dialog_arg
    local launch_args

    launch_args=$(cat "${START_PATH}"/term-sd/config/sd-webui-reforge-launch.conf | awk '{sub("launch.py ","")}1')

    dialog_arg=$(dialog --erase-on-exit \
        --title "Stable-Diffusion-WebUI 管理" \
        --backtitle "Stable-Diffusion-WebUI 自定义启动参数选项" \
        --ok-label "确认" --cancel-label "取消" \
        --inputbox "请输入 Stable-Diffusion-WebUI-reForge 启动参数" \
        $(get_dialog_size) \
        "${launch_args}" \
        3>&1 1>&2 2>&3)

    if [[ "$?" == 0 ]]; then
        term_sd_echo "设置 Stable-Diffusion-WebUI-reForge 启动参数: ${dialog_arg}"
        echo "launch.py ${dialog_arg}" > "${START_PATH}"/term-sd/config/sd-webui-reforge-launch.conf
    else
        term_sd_echo "取消修改 Stable-Diffusion-WebUI-reForge 启动参数"
    fi
}

# 添加默认启动参数配置
add_sd_webui_reforge_normal_launch_args() {
    if [[ ! -f "${START_PATH}/term-sd/config/sd-webui-reforge-launch.conf" ]]; then # 找不到启动配置时默认生成一个
        echo "launch.py --theme dark --autolaunch --xformers --api" > "${START_PATH}"/term-sd/config/sd-webui-reforge-launch.conf
    fi
}

# 重置启动参数
restore_sd_webui_reforge_launch_args() {
    if (dialog --erase-on-exit \
        --title "Stable-Diffusion-WebUI 管理" \
        --backtitle "Stable-Diffusion-WebUI 重置启动参数选项选项" \
        --yes-label "是" --no-label "否" \
        --yesno "是否重置 Stable-Diffusion-WebUI-reForge 启动参数" \
        $(get_dialog_size)); then

        term_sd_echo "重置 Stable-Diffusion-WebUI-reForge 启动参数"
        rm -f "${START_PATH}"/term-sd/config/sd-webui-reforge-launch.conf
        add_sd_webui_reforge_normal_launch_args
    else
        term_sd_echo "取消重置 Stable-Diffusion-WebUI-reForge 启动参数操作"
    fi
}
