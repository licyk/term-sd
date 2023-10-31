#!/bin/bash

#fooocus启动脚本生成部分
function generate_fooocus_launch()
{
    fooocus_launch_option=""

    fooocus_launch_option_dialog=$(
        dialog --erase-on-exit --title "Fooocus管理" --backtitle "Fooocus启动参数选项" --separate-output --notags --ok-label "确认" --cancel-label "取消" --checklist "请选择Fooocus启动参数,确认之后将覆盖原有启动参数配置" 25 80 10 \
        "1" "(listen)开放远程连接" OFF \
        "2" "(auto-launch)启动webui完成后自动启动浏览器" ON \
        "3" "(disable-auto-launch)禁用在启动webui完成后自动启动浏览器" OFF \
        "4" "(cuda-malloc)启用CUDA流顺序内存分配器(Torch2.0+默认启用)" OFF\
        "5" "(disable-cuda-malloc)禁用CUDA流顺序内存分配器" OFF \
        "6" "(dont-upcast-attention)禁用向上注意力优化" OFF \
        "7" "(force-fp32)强制使用fp32" OFF \
        "8" "(force-fp16)强制使用 fp16" OFF \
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
        "19" "(use-pytorch-cross-attention)使用pytorch方案优化" OFF \
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
        3>&1 1>&2 2>&3)

    if [ $? = 0 ];then
        for i in $fooocus_launch_option_dialog; do
            case $i in
                1)
                    fooocus_launch_option="--listen $fooocus_launch_option"
                    ;;
                2)    
                    fooocus_launch_option="--auto-launch $fooocus_launch_option"
                    ;;
                3)
                    fooocus_launch_option="--disable-auto-launch $fooocus_launch_option"
                    ;;
                4)
                    fooocus_launch_option="--cuda-malloc $fooocus_launch_option"
                    ;;
                5)
                    fooocus_launch_option="--disable-cuda-malloc $fooocus_launch_option"
                    ;;
                6)
                    fooocus_launch_option="--dont-upcast-attention $fooocus_launch_option"
                    ;;
                7)
                    fooocus_launch_option="--force-fp32 $fooocus_launch_option"
                    ;;
                8)
                    fooocus_launch_option="--force-fp16 $fooocus_launch_option"
                    ;;
                9)
                    fooocus_launch_option="--bf16-unet $fooocus_launch_option"
                    ;;
                10)
                    fooocus_launch_option="--fp16-vae $fooocus_launch_option"
                    ;;
                11)
                    fooocus_launch_option="--fp32-vae $fooocus_launch_option"
                    ;;
                12)
                    fooocus_launch_option="--bf16-vae $fooocus_launch_option"
                    ;;
                13)
                    fooocus_launch_option="--disable-ipex-optimize $fooocus_launch_option"
                    ;;
                14)
                    fooocus_launch_option="--preview-method none $fooocus_launch_option"
                    ;;
                15)
                    fooocus_launch_option="--preview-method latent2rgb $fooocus_launch_option"
                    ;;
                16)
                    fooocus_launch_option="--preview-method taesd $fooocus_launch_option"
                    ;;
                17)
                    fooocus_launch_option="--use-split-cross-attention $fooocus_launch_option"
                    ;;
                18)
                    fooocus_launch_option="--use-quad-cross-attention $fooocus_launch_option"
                    ;;
                19)
                    fooocus_launch_option="--use-pytorch-cross-attention $fooocus_launch_option"
                    ;;
                20)
                    fooocus_launch_option="--disable-xformers $fooocus_launch_option"
                    ;;
                21)
                    fooocus_launch_option="--gpu-only $fooocus_launch_option"
                    ;;
                22)
                    fooocus_launch_option="--highvram $fooocus_launch_option"
                    ;;
                23)
                    fooocus_launch_option="--normalvram $fooocus_launch_option"
                    ;;
                24)
                    fooocus_launch_option="--lowvram $fooocus_launch_option"
                    ;;
                25)
                    fooocus_launch_option="--novram $fooocus_launch_option"
                    ;;
                26)
                    fooocus_launch_option="--cpu $fooocus_launch_option"
                    ;;
                27)
                    fooocus_launch_option="--disable-smart-memory $fooocus_launch_option"
                    ;;
                28)
                    fooocus_launch_option="--dont-print-server $fooocus_launch_option"
                    ;;
                29)
                    fooocus_launch_option="--quick-test-for-ci $fooocus_launch_option"
                    ;;
                30)
                    fooocus_launch_option="--windows-standalone-build $fooocus_launch_option"
                    ;;
                31)
                    fooocus_launch_option="--disable-metadata $fooocus_launch_option"
                    ;;
                32)
                    fooocus_launch_option="--share $fooocus_launch_option"
                    ;;
            esac
        done

        term_sd_notice "设置启动参数> $fooocus_launch_option"
        echo "launch.py $fooocus_launch_option" > term-sd-launch.conf
    fi
}

#fooocus启动界面
function fooocus_launch()
{
    fooocus_launch_dialog=$(dialog --erase-on-exit --title "Fooocus管理" --backtitle "Fooocus启动选项" --ok-label "确认" --cancel-label "取消" --menu "请选择启动Fooocus/修改Fooocus启动参数\n当前启动参数:\n$([ $venv_active = 0 ] && echo python || echo "$term_sd_python_path") $(cat ./term-sd-launch.conf)" 25 80 10 \
        "1" "启动" \
        "2" "选择预设启动参数" \
        "3" "自定义启动参数" \
        "4" "返回" \
        3>&1 1>&2 2>&3)

    if [ $? = 0 ];then
        case $fooocus_launch_dialog in
            1)
                term_sd_launch
                fooocus_launch
                ;;
            2)
                generate_fooocus_launch
                fooocus_launch
                ;;
            3)
                fooocus_manual_launch
                fooocus_launch
                ;;
        esac
    fi
}

#fooocus手动输入启动参数界面
function fooocus_manual_launch()
{
    fooocus_manual_launch_parameter=$(dialog --erase-on-exit --title "Fooocus管理" --backtitle "Fooocus自定义启动参数选项" --ok-label "确认" --cancel-label "取消" --inputbox "请输入Fooocus启动参数" 25 80 "$(cat ./term-sd-launch.conf | awk '{sub("launch.py ","")}1')" 3>&1 1>&2 2>&3)

    if [ $? = 0 ];then
        term_sd_notice "设置启动参数> $fooocus_manual_launch_parameter"
        echo "launch.py $fooocus_manual_launch_parameter" > term-sd-launch.conf
    fi
}