#!/bin/bash

# fooocus启动脚本生成部分
fooocus_launch_args_setting()
{
    local fooocus_launch_args
    local fooocus_launch_args_setting_dialog
    local launch_args

    fooocus_launch_args_setting_dialog=$(dialog --erase-on-exit --notags \
        --title "Fooocus 管理" \
        --backtitle "Fooocus 启动参数选项" \
        --ok-label "确认" --cancel-label "取消" \
        --checklist "请选择 Fooocus 启动参数, 确认之后将覆盖原有启动参数配置" \
        $term_sd_dialog_height $term_sd_dialog_width $term_sd_dialog_menu_height \
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
        "39" "(language zh) 启用中文" ON \
        "40" "(theme dark) 使用黑暗主题" OFF \
        "41" "(disable-image-log) 禁用将图像和日志写入硬盘" OFF \
        "42" "(disable-analytics) 禁用 Gradio 分析" OFF \
        "43" "(preset default) 使用默认模型预设" OFF \
        "44" "(preset sai) 使用 SAI 模型预设" ON \
        "45" "(preset lcm) 使用 LCM 模型预设" OFF \
        "46" "(preset anime) 使用 Anime 模型预设" OFF \
        "47" "(preset realistic) 使用 Realistic 模型预设" OFF \
        3>&1 1>&2 2>&3)

    if [ $? = 0 ];then
        for i in $fooocus_launch_args_setting_dialog; do
            case $i in
                1)
                    fooocus_launch_args="--listen"
                    ;;
                2)
                    fooocus_launch_args="--disable-header-check"
                    ;;
                3)
                    fooocus_launch_args="--in-browser"
                    ;;
                4)
                    fooocus_launch_args="--disable-in-browser"
                    ;;
                5)
                    fooocus_launch_args="--async-cuda-allocation"
                    ;;
                6)
                    fooocus_launch_args="--disable-async-cuda-allocation"
                    ;;
                7)
                    fooocus_launch_args="--disable-attention-upcast"
                    ;;
                8)
                    fooocus_launch_args="--all-in-fp32"
                    ;;
                9)
                    fooocus_launch_args="--all-in-fp16"
                    ;;
                10)
                    fooocus_launch_args="--unet-in-bf16"
                    ;;
                11)
                    fooocus_launch_args="--unet-in-fp16"
                    ;;
                12)
                    fooocus_launch_args="--unet-in-fp8-e4m3fn"
                    ;;
                13)
                    fooocus_launch_args="--unet-in-fp8-e5m2"
                    ;;
                14)
                    fooocus_launch_args="--vae-in-fp16"
                    ;;
                15)
                    fooocus_launch_args="--vae-in-fp32"
                    ;;
                16)
                    fooocus_launch_args="--vae-in-bf16"
                    ;;
                17)
                    fooocus_launch_args="--clip-in-fp8-e4m3fn"
                    ;;
                18)
                    fooocus_launch_args="--clip-in-fp8-e5m2"
                    ;;
                19)
                    fooocus_launch_args="--clip-in-fp16"
                    ;;
                20)
                    fooocus_launch_args="--clip-in-fp32"
                    ;;
                21)
                    fooocus_launch_args="--directml"
                    ;;
                22)
                    fooocus_launch_args="--disable-ipex-hijack"
                    ;;
                23)
                    fooocus_launch_args="--attention-split"
                    ;;
                24)
                    fooocus_launch_args="--attention-quad"
                    ;;
                25)
                    fooocus_launch_args="--attention-pytorch"
                    ;;
                26)
                    fooocus_launch_args="--disable-xformers"
                    ;;
                27)
                    fooocus_launch_args="--always-gpu"
                    ;;
                28)
                    fooocus_launch_args="--always-high-vram"
                    ;;
                29)
                    fooocus_launch_args="--always-normal-vram"
                    ;;
                30)
                    fooocus_launch_args="--always-low-vram"
                    ;;
                31)
                    fooocus_launch_args="--always-no-vram"
                    ;;
                32)
                    fooocus_launch_args="--always-cpu"
                    ;;
                33)
                    fooocus_launch_args="--always-offload-from-vram"
                    ;;
                34)
                    fooocus_launch_args="--pytorch-deterministic"
                    ;;
                35)
                    fooocus_launch_args="--disable-server-log"
                    ;;
                36)
                    fooocus_launch_args="--debug-mode"
                    ;;
                37)
                    fooocus_launch_args="--is-windows-embedded-python"
                    ;;
                38)
                    fooocus_launch_args="--disable-server-info"
                    ;;
                39)
                    fooocus_launch_args="--language zh"
                    ;;
                40)
                    fooocus_launch_args="--theme dark"
                    ;;
                41)
                    fooocus_launch_args="--disable-image-log"
                    ;;
                42)
                    fooocus_launch_args="--disable-analytics"
                    ;;
                43)
                    fooocus_launch_args="--preset default"
                    ;;
                44)
                    fooocus_launch_args="--preset sai"
                    ;;
                45)
                    fooocus_launch_args="--preset lcm"
                    ;;
                46)
                    fooocus_launch_args="--preset anime"
                    ;;
                47)
                    fooocus_launch_args="--preset realistic"
                    ;;
            esac
            launch_args="$fooocus_launch_args $launch_args"
        done

        term_sd_echo "设置启动参数: $launch_args"
        echo "launch.py $launch_args" > "$start_path"/term-sd/config/fooocus-launch.conf
    else
        term_sd_echo "取消设置启动参数"
    fi
}

# fooocus启动界面
fooocus_launch()
{
    local fooocus_launch_dialog

    if [ ! -f "$start_path/term-sd/config/fooocus-launch.conf" ]; then # 找不到启动配置时默认生成一个
        term_sd_echo "未找到启动配置文件, 创建中"
        echo "launch.py --language zh --preset sai" > "$start_path"/term-sd/config/fooocus-launch.conf
    fi

    while true
    do
        fooocus_launch_dialog=$(dialog --erase-on-exit --notags \
            --title "Fooocus 管理" \
            --backtitle "Fooocus 启动选项" \
            --ok-label "确认" --cancel-label "取消" \
            --menu "请选择启动 Fooocus / 修改 Fooocus 启动参数\n当前启动参数:\n$([ $venv_setup_status = 0 ] && echo python || echo "$term_sd_python_path") $(cat "$start_path"/term-sd/config/fooocus-launch.conf)" \
            $term_sd_dialog_height $term_sd_dialog_width $term_sd_dialog_menu_height \
            "0" "> 返回" \
            "1" "> 启动" \
            "2" "> 配置预设启动参数" \
            "3" "> 修改自定义启动参数" \
            3>&1 1>&2 2>&3)

        case $fooocus_launch_dialog in
            1)
                term_sd_launch
                ;;
            2)
                fooocus_launch_args_setting
                ;;
            3)
                fooocus_manual_launch
                ;;
            *)
                break
                ;;
        esac
    done
}

# fooocus手动输入启动参数界面
fooocus_manual_launch()
{
    local fooocus_launch_args

    fooocus_launch_args=$(dialog --erase-on-exit \
        --title "Fooocus 管理" \
        --backtitle "Fooocus 自定义启动参数选项" \
        --ok-label "确认" --cancel-label "取消" \
        --inputbox "请输入 Fooocus 启动参数" \
        $term_sd_dialog_height $term_sd_dialog_width \
        "$(cat "$start_path"/term-sd/config/fooocus-launch.conf | awk '{sub("launch.py ","")}1')" \
        3>&1 1>&2 2>&3)

    if [ $? = 0 ];then
        term_sd_echo "设置启动参数: $fooocus_launch_args"
        echo "launch.py $fooocus_launch_args" > "$start_path"/term-sd/config/fooocus-launch.conf
    else
        term_sd_echo "取消启动参数修改"
    fi
}