#!/bin/bash

# comfyui启动脚本生成部分
comfyui_launch_args_setting()
{
    local comfyui_launch_args
    local comfyui_launch_args_setting_dialog
    local launch_args

    comfyui_launch_args_setting_dialog=$(
        dialog --erase-on-exit --notags --title "ComfyUI管理" --backtitle "ComfyUI启动参数选项" --ok-label "确认" --cancel-label "取消" --checklist "请选择ComfyUI启动参数,确认之后将覆盖原有启动参数配置" $term_sd_dialog_height $term_sd_dialog_width $term_sd_dialog_menu_height \
        "1" "(listen)开放远程连接" OFF \
        "2" "(auto-launch)启动webui完成后自动启动浏览器" ON \
        "3" "(disable-auto-launch)禁用在启动webui完成后自动启动浏览器" OFF \
        "4" "(cuda-malloc)启用CUDA流顺序内存分配器(Torch2.0+默认启用)" OFF \
        "5" "(disable-cuda-malloc)禁用CUDA流顺序内存分配器" OFF \
        "6" "(dont-upcast-attention)禁用向上注意力优化" OFF \
        "7" "(force-fp32)强制使用fp32" OFF \
        "8" "(force-fp16)强制使用fp16" OFF \
        "9" "(bf16-unet)使用bf16精度运行unet" OFF \
        "10" "(fp16-vae)使用fp16精度运行vae" OFF \
        "11" "(fp32-vae)使用fp32精度运行vae" OFF \
        "12" "(bf16-vae)使用bf16精度运行vae" OFF \
        "13" "(disable-ipex-optimize)禁用ipex优化" OFF \
        "14" "(preview-method none)不使用图片预览" OFF \
        "15" "(preview-method latent2rgb)使用latent2rgb图片预览" OFF \
        "16" "(preview-method taesd)使用taesd图片预览" OFF \
        "17" "(use-split-cross-attention)使用split优化" OFF \
        "18" "(use-quad-cross-attention)使用quad优化" OFF \
        "19" "(use-pytorch-cross-attention)使用PyTorch方案优化" OFF \
        "20" "(disable-xformers)禁用xformers优化" OFF \
        "21" "(gpu-only)将所有模型,文本编码器储存在GPU中" OFF \
        "22" "(highvram)不使用显存优化(生图完成后将模型继续保存在显存中)" OFF \
        "23" "(normalvram)使用默认显存优化" OFF \
        "24" "(lowvram)使用显存优化(将会降低生图速度)" OFF \
        "25" "(novram)使用显存优化(将会大量降低生图速度)" OFF \
        "26" "(cpu)使用CPU进行生图" OFF \
        "27" "(disable-smart-memory)强制保持模型储存在显存中而不是自动卸载到内存中" OFF \
        "28" "(dont-print-server)禁用日志输出" OFF \
        "29" "(quick-test-for-ci)快速测试CI" OFF \
        "30" "(windows-standalone-build)启用Windows独占功能" OFF \
        "31" "(disable-metadata)禁用在文件中保存提示元数据" OFF \
        "32" "(share)通过gradio共享" OFF \
        "33" "(fp8_e4m3fn-text-enc)使用fp8精度(e4m3fn)" OFF \
        "34" "(fp8_e5m2-text-enc)使用fp8精度(e5m2)" OFF \
        3>&1 1>&2 2>&3)

    if [ $? = 0 ];then
        for i in $comfyui_launch_args_setting_dialog; do
            case $i in
                1)
                    comfyui_launch_args="--listen"
                    ;;
                2)    
                    comfyui_launch_args="--auto-launch"
                    ;;
                3)
                    comfyui_launch_args="--disable-auto-launch"
                    ;;
                4)
                    comfyui_launch_args="--cuda-malloc"
                    ;;
                5)
                    comfyui_launch_args="--disable-cuda-malloc"
                    ;;
                6)
                    comfyui_launch_args="--dont-upcast-attention"
                    ;;
                7)
                    comfyui_launch_args="--force-fp32"
                    ;;
                8)
                    comfyui_launch_args="--force-fp16"
                    ;;
                9)
                    comfyui_launch_args="--bf16-unet"
                    ;;
                10)
                    comfyui_launch_args="--fp16-vae"
                    ;;
                11)
                    comfyui_launch_args="--fp32-vae"
                    ;;
                12)
                    comfyui_launch_args="--bf16-vae"
                    ;;
                13)
                    comfyui_launch_args="--disable-ipex-optimize"
                    ;;
                14)
                    comfyui_launch_args="--preview-method none"
                    ;;
                15)
                    comfyui_launch_args="--preview-method latent2rgb"
                    ;;
                16)
                    comfyui_launch_args="--preview-method taesd"
                    ;;
                17)
                    comfyui_launch_args="--use-split-cross-attention"
                    ;;
                18)
                    comfyui_launch_args="--use-quad-cross-attention"
                    ;;
                19)
                    comfyui_launch_args="--use-pytorch-cross-attention"
                    ;;
                20)
                    comfyui_launch_args="--disable-xformers"
                    ;;
                21)
                    comfyui_launch_args="--gpu-only"
                    ;;
                22)
                    comfyui_launch_args="--highvram"
                    ;;
                23)
                    comfyui_launch_args="--normalvram"
                    ;;
                24)
                    comfyui_launch_args="--lowvram"
                    ;;
                25)
                    comfyui_launch_args="--novram"
                    ;;
                26)
                    comfyui_launch_args="--cpu"
                    ;;
                27)
                    comfyui_launch_args="--disable-smart-memory"
                    ;;
                28)
                    comfyui_launch_args="--dont-print-server"
                    ;;
                29)
                    comfyui_launch_args="--quick-test-for-ci"
                    ;;
                30)
                    comfyui_launch_args="--windows-standalone-build"
                    ;;
                31)
                    comfyui_launch_args="--disable-metadata"
                    ;;
                32)
                    comfyui_launch_args="--share"
                    ;;
                33)
                    comfyui_launch_args="--fp8_e4m3fn-text-enc"
                    ;;
                34)
                    comfyui_launch_args="--fp8_e5m2-text-enc"
                    ;;
            esac
            launch_args="$comfyui_launch_args $launch_args"
        done

        # 生成启动脚本
        term_sd_echo "设置启动参数: $launch_args"
        echo "main.py $launch_args" > "$start_path"/term-sd/config/comfyui-launch.conf
    else
        term_sd_echo "取消设置启动参数"
    fi
}

# comfyui启动界面
comfyui_launch()
{
    local comfyui_launch_dialog

    if [ ! -f ""$start_path"/term-sd/config/comfyui-launch.conf" ]; then # 找不到启动配置时默认生成一个
        term_sd_echo "未找到启动配置文件,创建中"
        echo "main.py --auto-launch" > "$start_path"/term-sd/config/comfyui-launch.conf
    fi

    while true
    do
        comfyui_launch_dialog=$(
            dialog --erase-on-exit --notags --title "ComfyUI管理" --backtitle "ComfyUI启动选项" --ok-label "确认" --cancel-label "取消" --menu "请选择启动ComfyUI/修改ComfyUI启动参数\n当前启动参数:\n$([ $venv_setup_status = 0 ] && echo python || echo "$term_sd_python_path") $(cat "$start_path"/term-sd/config/comfyui-launch.conf)" $term_sd_dialog_height $term_sd_dialog_width $term_sd_dialog_menu_height \
            "0" "> 返回" \
            "1" "> 启动" \
            "2" "> 配置预设启动参数" \
            "3" "> 修改自定义启动参数" \
            3>&1 1>&2 2>&3)

        case $comfyui_launch_dialog in
            1)
                term_sd_launch
                ;;
            2)
                comfyui_launch_args_setting
                ;;
            3)
                comfyui_launch_args_revise
                ;;
            *)
                break
                ;;
        esac
    done
}

# comfyui手动输入启动参数界面
comfyui_launch_args_revise()
{
    local comfyui_launch_args

    comfyui_launch_args=$(dialog --erase-on-exit --title "ComfyUI管理" --backtitle "ComfyUI自定义启动参数选项" --ok-label "确认" --cancel-label "取消" --inputbox "请输入ComfyUI启动参数" $term_sd_dialog_height $term_sd_dialog_width "$(cat "$start_path"/term-sd/config/comfyui-launch.conf | awk '{sub("main.py ","")}1')" 3>&1 1>&2 2>&3)

    if [ $? = 0 ];then
        term_sd_echo "设置启动参数: $comfyui_launch_args"
        echo "main.py $comfyui_launch_args" > "$start_path"/term-sd/config/comfyui-launch.conf
    else
        term_sd_echo "取消启动参数修改"
    fi
}