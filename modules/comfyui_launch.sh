#!/bin/bash

# ComfyUI 启动脚本生成部分
# 启动参数保存在 <Start Path>/term-sd/config/comfyui-launch.conf
comfyui_launch_args_setting() {
    local arg
    local dialog_arg
    local launch_args
    local i

    dialog_arg=$(dialog --erase-on-exit --notags \
        --title "ComfyUI 管理" \
        --backtitle "ComfyUI 启动参数选项" \
        --ok-label "确认" --cancel-label "取消" \
        --checklist "请选择 ComfyUI 启动参数, 确认之后将覆盖原有启动参数配置" \
        $(get_dialog_size_menu) \
        "1" "(listen) 开放远程连接" OFF \
        "2" "(auto-launch) 启动 WebUI 完成后自动启动浏览器" OFF \
        "3" "(disable-auto-launch) 禁用在启动 WebUI 完成后自动启动浏览器" OFF \
        "4" "(cuda-malloc) 启用 CUDA 流顺序内存分配器 (Torch2.0+ 默认启用)" OFF \
        "5" "(disable-cuda-malloc) 禁用 CUDA 流顺序内存分配器" OFF \
        "6" "(dont-upcast-attention) 禁用向上注意力优化" OFF \
        "7" "(force-fp32) 强制使用 FP32" OFF \
        "8" "(force-fp16) 强制使用 FP16" OFF \
        "9" "(bf16-unet) 使用 BF16 精度运行 UNet" OFF \
        "10" "(fp16-vae) 使用 FP16 精度运行 VAE" OFF \
        "11" "(fp32-vae) 使用 FP32 精度运行 VAE" OFF \
        "12" "(bf16-vae) 使用 BF16 精度运行 VAE" OFF \
        "13" "(disable-ipex-optimize) 禁用 IPEX 优化" OFF \
        "14" "(preview-method none) 不使用图片预览" OFF \
        "15" "(preview-method auto) 自动选择图片预览方式" OFF \
        "16" "(preview-method latent2rgb) 使用 Latent2Rgb 图片预览" OFF \
        "17" "(preview-method taesd) 使用 TAESD 图片预览" OFF \
        "18" "(use-split-cross-attention) 使用 Split优化" OFF \
        "19" "(use-quad-cross-attention) 使用 Quad 优化" OFF \
        "20" "(use-pytorch-cross-attention) 使用 PyTorch 方案优化" OFF \
        "21" "(disable-xformers) 禁用 xFormers 优化" OFF \
        "22" "(gpu-only) 将所有模型, 文本编码器储存在 GPU 中" OFF \
        "23" "(highvram) 不使用显存优化 (生图完成后将模型继续保存在显存中)" OFF \
        "24" "(normalvram) 使用默认显存优化" OFF \
        "25" "(lowvram) 使用显存优化 (将会降低生图速度)" OFF \
        "26" "(novram) 使用显存优化 (将会大量降低生图速度)" OFF \
        "27" "(cpu) 使用CPU进行生图" OFF \
        "28" "(disable-smart-memory) 强制保持模型储存在显存中而不是自动卸载到内存中" OFF \
        "29" "(dont-print-server) 禁用日志输出" OFF \
        "30" "(quick-test-for-ci) 快速测试 CI" OFF \
        "31" "(windows-standalone-build) 启用 Windows 独占功能" OFF \
        "32" "(disable-metadata) 禁用在文件中保存提示元数据" OFF \
        "33" "(fp8_e4m3fn-text-enc) 使用 FP8 精度 (e4m3fn)" OFF \
        "34" "(fp8_e5m2-text-enc) 使用 FP8 精度 (e5m2)" OFF \
        "35" "(multi-user) 启用多用户支持" OFF \
        "36" "(verbose) 显示更多调试信息" OFF \
        3>&1 1>&2 2>&3)

    if [[ "$?" == 0 ]]; then
        for i in ${dialog_arg}; do
            case "${i}" in
                1)
                    arg="--listen"
                    ;;
                2)    
                    arg="--auto-launch"
                    ;;
                3)
                    arg="--disable-auto-launch"
                    ;;
                4)
                    arg="--cuda-malloc"
                    ;;
                5)
                    arg="--disable-cuda-malloc"
                    ;;
                6)
                    arg="--dont-upcast-attention"
                    ;;
                7)
                    arg="--force-fp32"
                    ;;
                8)
                    arg="--force-fp16"
                    ;;
                9)
                    arg="--bf16-unet"
                    ;;
                10)
                    arg="--fp16-vae"
                    ;;
                11)
                    arg="--fp32-vae"
                    ;;
                12)
                    arg="--bf16-vae"
                    ;;
                13)
                    arg="--disable-ipex-optimize"
                    ;;
                14)
                    arg="--preview-method none"
                    ;;
                15)
                    arg="--preview-method auto"
                    ;;
                16)
                    arg="--preview-method latent2rgb"
                    ;;
                17)
                    arg="--preview-method taesd"
                    ;;
                18)
                    arg="--use-split-cross-attention"
                    ;;
                19)
                    arg="--use-quad-cross-attention"
                    ;;
                20)
                    arg="--use-pytorch-cross-attention"
                    ;;
                21)
                    arg="--disable-xformers"
                    ;;
                22)
                    arg="--gpu-only"
                    ;;
                23)
                    arg="--highvram"
                    ;;
                24)
                    arg="--normalvram"
                    ;;
                25)
                    arg="--lowvram"
                    ;;
                26)
                    arg="--novram"
                    ;;
                27)
                    arg="--cpu"
                    ;;
                28)
                    arg="--disable-smart-memory"
                    ;;
                29)
                    arg="--dont-print-server"
                    ;;
                30)
                    arg="--quick-test-for-ci"
                    ;;
                31)
                    arg="--windows-standalone-build"
                    ;;
                32)
                    arg="--disable-metadata"
                    ;;
                33)
                    arg="--fp8_e4m3fn-text-enc"
                    ;;
                34)
                    arg="--fp8_e5m2-text-enc"
                    ;;
                35)
                    arg="--multi-user"
                    ;;
                36)
                    arg="--verbose"
                    ;;
            esac
            launch_args="${arg} ${launch_args}"
        done

        # 生成启动脚本
        term_sd_echo "设置 ComfyUI 启动参数: ${launch_args}"
        echo "main.py ${launch_args}" > "${START_PATH}"/term-sd/config/comfyui-launch.conf
    else
        term_sd_echo "取消设置 ComfyUI 启动参数"
    fi
}

# ComfyUI 启动界面
comfyui_launch() {
    local dialog_arg
    local launch_args

    add_comfyui_normal_launch_args # 没有启动参数时自动生成一个

    while true; do
        launch_args=$(cat "${START_PATH}"/term-sd/config/comfyui-launch.conf)
        if is_use_venv; then
            launch_args="python ${launch_args}"
        else
            launch_args=${TERM_SD_PYTHON_PATH}" ${launch_args}"
        fi

        dialog_arg=$(dialog --erase-on-exit --notags \
            --title "ComfyUI 管理" \
            --backtitle "ComfyUI 启动选项" \
            --ok-label "确认" --cancel-label "取消" \
            --menu "请选择启动 ComfyUI / 修改 ComfyUI 启动参数\n当前启动参数: ${launch_args}" \
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
                comfyui_launch_args_setting
                ;;
            3)
                comfyui_launch_args_revise
                ;;
            4)
                restore_comfyui_launch_args
                ;;
            *)
                break
                ;;
        esac
    done
}

# ComfyUI 手动输入启动参数界面
# 启动修改界面时将从 <Strat Path>/term-sd/config/comfyui-launch.conf 中读取启动参数
# 可接着上次的启动参数进行修改
comfyui_launch_args_revise() {
    local dialog_arg
    local launch_args

    launch_args=$(cat "${START_PATH}"/term-sd/config/comfyui-launch.conf | awk '{sub("main.py ","")}1')

    dialog_arg=$(dialog --erase-on-exit \
        --title "ComfyUI 管理" \
        --backtitle "ComfyUI 自定义启动参数选项" \
        --ok-label "确认" --cancel-label "取消" \
        --inputbox "请输入 ComfyUI 启动参数" \
        $(get_dialog_size) \
        "${launch_args}" \
        3>&1 1>&2 2>&3)

    if [[ "$?" == 0 ]]; then
        term_sd_echo "设置 ComfyUI 启动参数: ${dialog_arg}"
        echo "main.py ${dialog_arg}" > "${START_PATH}"/term-sd/config/comfyui-launch.conf
    else
        term_sd_echo "取消修改 ComfyUI 启动参数"
    fi
}

# 添加 ComfyUI 默认启动参数配置
add_comfyui_normal_launch_args() {
    if [ ! -f "${START_PATH}/term-sd/config/comfyui-launch.conf" ]; then # 找不到启动配置时默认生成一个
        echo "main.py --auto-launch --preview-method auto --disable-smart-memory" > "${START_PATH}"/term-sd/config/comfyui-launch.conf
    fi
}

# 重置启动参数
restore_comfyui_launch_args() {
    if (dialog --erase-on-exit \
        --title "ComfyUI 管理" \
        --backtitle "ComfyUI 重置启动参数选项选项" \
        --yes-label "是" --no-label "否" \
        --yesno "是否重置 ComfyUI 启动参数 ?" \
        $(get_dialog_size)); then

        term_sd_echo "重置 ComfyUI 启动参数"
        rm -f "${START_PATH}"/term-sd/config/comfyui-launch.conf
        add_comfyui_normal_launch_args
    else
        term_sd_echo "取消重置 ComfyUI 启动参数操作"
    fi
}