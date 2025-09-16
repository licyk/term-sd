#!/bin/bash

# Fooocus 启动参数设置
# 设置的启动参数保存在 <Start Path>/term-sd/config/fooocus-launch.conf
fooocus_launch_args_setting() {
    local arg
    local dialog_arg
    local launch_args
    local i

    dialog_arg=$(dialog --erase-on-exit --notags \
        --title "Fooocus 管理" \
        --backtitle "Fooocus 启动参数选项" \
        --ok-label "确认" --cancel-label "取消" \
        --checklist "请选择 Fooocus 启动参数, 确认之后将覆盖原有启动参数配置" \
        $(get_dialog_size_menu) \
        "1" "(listen) 开放远程连接" OFF \
        "2" "(disable-header-check) 禁用请求头部检查" OFF \
        "3" "(in-browser) 启动后自动打开浏览器" OFF \
        "4" "(disable-in-browser) 禁用自动打开浏览器" OFF \
        "5" "(async-cuda-allocation) 启用 CUDA 流顺序内存分配器" OFF \
        "6" "(disable-async-cuda-allocation) 禁用 CUDA 流顺序内存分配器" OFF \
        "7" "(disable-attention-upcast) 使用向上采样法提高精度" OFF \
        "8" "(all-in-fp32) 强制使用 FP32" OFF \
        "9" "(all-in-fp16) 强制使用 FP16" OFF \
        "10" "(unet-in-bf16) 使用 BF16 精度运行 UNet" OFF \
        "11" "(unet-in-fp16) 使用 FP16 精度运行 UNet" OFF \
        "12" "(unet-in-fp8-e4m3fn) 使用 FP8(e4m3fn) 精度运行 UNet" OFF \
        "13" "(unet-in-fp8-e5m2) 使用 FP8(e5m2) 精度运行 UNet" OFF \
        "14" "(vae-in-fp16) 使用 FP16 精度运行 VAE" OFF \
        "15" "(vae-in-fp32) 使用 FP32 精度运行 VAE" OFF \
        "16" "(vae-in-bf16) 使用 BF16 精度运行 VAE" OFF \
        "17" "(clip-in-fp8-e4m3fn) 使用 FP8(e4m3fn) 精度运行文本编码器" OFF \
        "18" "(clip-in-fp8-e5m2) 使用 FP8(e5m2) 精度运行文本编码器" OFF \
        "19" "(clip-in-fp16) 使用 FP16精度运行文本编码器" OFF \
        "20" "(clip-in-fp32) 使用 FP32精度运行文本编码器" OFF \
        "21" "(directml) 使用 DirectML 作为后端" OFF \
        "22" "(disable-ipex-hijack) 禁用 IPEX 修复" OFF \
        "23" "(attention-split) 使用 Split 优化" OFF \
        "24" "(attention-quad) 使用 Quad 优化" OFF \
        "25" "(attention-pytorch) 使用 PyTorch 方案优化" OFF \
        "26" "(disable-xformers) 禁用 xFormers 优化" OFF \
        "27" "(always-gpu) 将所有模型, 文本编码器储存在 GPU 中" OFF \
        "28" "(always-high-vram) 不使用显存优化" OFF \
        "29" "(always-normal-vram) 使用默认显存优化" OFF \
        "30" "(always-low-vram) 使用显存优化 (将会降低生图速度)" OFF \
        "31" "(always-no-vram) 使用显存优化 (将会大量降低生图速度)" OFF \
        "32" "(always-cpu) 使用 CPU 进行生图" OFF \
        "33" "(always-offload-from-vram) 生图完成后将模型从显存中卸载" OFF \
        "34" "(pytorch-deterministic) 将 PyTorch 配置为使用确定性算法" OFF \
        "35" "(disable-server-log) 禁用服务端日志输出" OFF \
        "36" "(debug-mode) 启用 Debug 模式" OFF \
        "37" "(is-windows-embedded-python) 启用 Windows 独占功能" OFF \
        "38" "(disable-server-info) 禁用服务端信息输出" OFF \
        "39" "(language zh) 启用中文" OFF \
        "40" "(theme dark) 使用黑暗主题" OFF \
        "41" "(disable-image-log) 禁用将图像和日志写入硬盘" OFF \
        "42" "(disable-analytics) 禁用 Gradio 分析" OFF \
        "43" "(preset default) 使用默认模型预设" OFF \
        "44" "(preset sai) 使用 SAI 模型预设" OFF \
        "45" "(preset lcm) 使用 LCM 模型预设" OFF \
        "46" "(preset anime) 使用 Anime 模型预设" OFF \
        "47" "(preset realistic) 使用 Realistic 模型预设" OFF \
        "48" "(preset term_sd) 使用 Term-SD 模型预设" OFF \
        "49" "(share) 启用 Gradio 共享" OFF \
        "50" "(disable-offload-from-vram) 禁用显存自动卸载" OFF \
        "51" "(multi-user) 启用多用户支持" OFF \
        "52" "(disable-image-log) 禁用保存图片日志" OFF \
        "53" "(disable-analytics) 禁用 Gradio 分析" OFF \
        "54" "(disable-metadata) 禁用保存生图信息到图片中" OFF \
        "55" "(disable-preset-download) 禁用下载预设中的模型" OFF \
        "56" "(enable-describe-uov-image) 为 uov 图像描述提示词" OFF \
        "57" "(always-download-new-model) 总是下载最新的模型" ON \
        3>&1 1>&2 2>&3)

    if [[ "$?" == 0 ]]; then
        for i in ${dialog_arg}; do
            case "${i}" in
                1)
                    arg="--listen"
                    ;;
                2)
                    arg="--disable-header-check"
                    ;;
                3)
                    arg="--in-browser"
                    ;;
                4)
                    arg="--disable-in-browser"
                    ;;
                5)
                    arg="--async-cuda-allocation"
                    ;;
                6)
                    arg="--disable-async-cuda-allocation"
                    ;;
                7)
                    arg="--disable-attention-upcast"
                    ;;
                8)
                    arg="--all-in-fp32"
                    ;;
                9)
                    arg="--all-in-fp16"
                    ;;
                10)
                    arg="--unet-in-bf16"
                    ;;
                11)
                    arg="--unet-in-fp16"
                    ;;
                12)
                    arg="--unet-in-fp8-e4m3fn"
                    ;;
                13)
                    arg="--unet-in-fp8-e5m2"
                    ;;
                14)
                    arg="--vae-in-fp16"
                    ;;
                15)
                    arg="--vae-in-fp32"
                    ;;
                16)
                    arg="--vae-in-bf16"
                    ;;
                17)
                    arg="--clip-in-fp8-e4m3fn"
                    ;;
                18)
                    arg="--clip-in-fp8-e5m2"
                    ;;
                19)
                    arg="--clip-in-fp16"
                    ;;
                20)
                    arg="--clip-in-fp32"
                    ;;
                21)
                    arg="--directml"
                    ;;
                22)
                    arg="--disable-ipex-hijack"
                    ;;
                23)
                    arg="--attention-split"
                    ;;
                24)
                    arg="--attention-quad"
                    ;;
                25)
                    arg="--attention-pytorch"
                    ;;
                26)
                    arg="--disable-xformers"
                    ;;
                27)
                    arg="--always-gpu"
                    ;;
                28)
                    arg="--always-high-vram"
                    ;;
                29)
                    arg="--always-normal-vram"
                    ;;
                30)
                    arg="--always-low-vram"
                    ;;
                31)
                    arg="--always-no-vram"
                    ;;
                32)
                    arg="--always-cpu"
                    ;;
                33)
                    arg="--always-offload-from-vram"
                    ;;
                34)
                    arg="--pytorch-deterministic"
                    ;;
                35)
                    arg="--disable-server-log"
                    ;;
                36)
                    arg="--debug-mode"
                    ;;
                37)
                    arg="--is-windows-embedded-python"
                    ;;
                38)
                    arg="--disable-server-info"
                    ;;
                39)
                    arg="--language zh"
                    ;;
                40)
                    arg="--theme dark"
                    ;;
                41)
                    arg="--disable-image-log"
                    ;;
                42)
                    arg="--disable-analytics"
                    ;;
                43)
                    arg="--preset default"
                    ;;
                44)
                    arg="--preset sai"
                    ;;
                45)
                    arg="--preset lcm"
                    ;;
                46)
                    arg="--preset anime"
                    ;;
                47)
                    arg="--preset realistic"
                    ;;
                48)
                    arg="--preset term_sd"
                    ;;
                49)
                    arg="--share"
                    ;;
                50)
                    arg="--disable-offload-from-vram"
                    ;;
                51)
                    arg="--multi-user"
                    ;;
                52)
                    arg="--disable-image-log"
                    ;;
                53)
                    arg="--disable-analytics"
                    ;;
                54)
                    arg="--disable-metadata"
                    ;;
                55)
                    arg="--disable-preset-download"
                    ;;
                56)
                    arg="--enable-describe-uov-image"
                    ;;
                57)
                    arg="--always-download-new-model"
                    ;;
            esac
            launch_args="${arg} ${launch_args}"
        done

        term_sd_echo "设置 Fooocus 启动参数: ${launch_args}"
        echo "launch.py ${launch_args}" > "${START_PATH}"/term-sd/config/fooocus-launch.conf
    else
        term_sd_echo "取消 Fooocus 设置启动参数"
    fi
}

# Fooocus 启动界面
fooocus_launch() {
    local dialog_arg
    local launch_args

    add_fooocus_normal_launch_args

    while true; do
        launch_args=$(cat "${START_PATH}"/term-sd/config/fooocus-launch.conf)
        if is_use_venv; then
            launch_args="python ${launch_args}"
        else
            launch_args="${TERM_SD_PYTHON_PATH} ${launch_args}"
        fi

        dialog_arg=$(dialog --erase-on-exit --notags \
            --title "Fooocus 管理" \
            --backtitle "Fooocus 启动选项" \
            --ok-label "确认" --cancel-label "取消" \
            --menu "请选择启动 Fooocus / 修改 Fooocus 启动参数\n当前启动参数: ${launch_args}" \
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
                fooocus_launch_args_setting
                ;;
            3)
                fooocus_manual_launch
                ;;
            4)
                restore_fooocus_launch_args
                ;;
            *)
                break
                ;;
        esac
    done
}

# Fooocus 修改启动参数功能
# 启动修改界面时将从 <Start Path>/term-sd/config/fooocus-launch.conf 中读取启动参数
# 可接着上次的启动参数进行修改
fooocus_manual_launch() {
    local dialog_arg
    local launch_args

    launch_args=$(cat "${START_PATH}"/term-sd/config/fooocus-launch.conf | awk '{sub("launch.py ","")}1')

    dialog_arg=$(dialog --erase-on-exit \
        --title "Fooocus 管理" \
        --backtitle "Fooocus 自定义启动参数选项" \
        --ok-label "确认" --cancel-label "取消" \
        --inputbox "请输入 Fooocus 启动参数" \
        $(get_dialog_size) \
        "${launch_args}" \
        3>&1 1>&2 2>&3)

    if [[ "$?" == 0 ]]; then
        term_sd_echo "设置 Fooocus 启动参数: ${dialog_arg}"
        echo "launch.py ${dialog_arg}" > "${START_PATH}"/term-sd/config/fooocus-launch.conf
    else
        term_sd_echo "取消修改 Fooocus 启动参数"
    fi
}

# 添加 Fooocus 默认启动参数配置
add_fooocus_normal_launch_args() {
    if [[ ! -f "${START_PATH}/term-sd/config/fooocus-launch.conf" ]]; then # 找不到启动配置时默认生成一个
        echo "launch.py --language zh --preset term_sd --disable-offload-from-vram --disable-analytics --always-download-new-model" > "${START_PATH}"/term-sd/config/fooocus-launch.conf
    fi
}

# 重置启动参数
restore_fooocus_launch_args() {
    if (dialog --erase-on-exit \
        --title "Fooocus 管理" \
        --backtitle "Fooocus 重置启动参数选项选项" \
        --yes-label "是" --no-label "否" \
        --yesno "是否重置 Fooocus 启动参数 ?" \
        $(get_dialog_size)); then

        term_sd_echo "重置 Fooocus 启动参数"
        rm -f "${START_PATH}"/term-sd/config/fooocus-launch.conf
        add_fooocus_normal_launch_args
    else
        term_sd_echo "取消重置 Fooocus 启动参数操作"
    fi
}
