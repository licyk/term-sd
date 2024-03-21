#!/bin/bash

# sd-webui-forge启动脚本参数设置
sd_webui_forge_launch_args_setting()
{
    local sd_webui_forge_launch_args
    local sd_webui_forge_launch_args_dialog
    local launch_args

    sd_webui_forge_launch_args_dialog=$(
        dialog --erase-on-exit --notags --title "Stable-Diffusion-WebUI-Forge管理" --backtitle "Stable-Diffusion-WebUI-Forge启动参数选项" --ok-label "确认" --cancel-label "取消" --checklist "请选择Stable-Diffusion-WebUI-Forge启动参数,确认之后将覆盖原有启动参数配置" $term_sd_dialog_height $term_sd_dialog_width $term_sd_dialog_menu_height \
        "1" "(update-all-extensions)启动时更新所有扩展" OFF \
        "2" "(skip-python-version-check)跳过检查Python版本" OFF \
        "3" "(skip-torch-cuda-test)跳过CUDA可用性检查" OFF \
        "4" "(reinstall-xformers)启动时重新安装xformers" OFF \
        "5" "(reinstall-torch)启动时重新安装PyTorch" OFF \
        "6" "(update-check)启动时检查更新" OFF \
        "7" "(test-server)配置测试服务器" OFF \
        "8" "(log-startup)显示详细启动日志" OFF \
        "9" "(skip-prepare-environment)跳过所有环境准备工作" OFF \
        "10" "(skip-install)跳过软件包的安装" OFF \
        "11" "(dump-sysinfo)将系统信息文件保存到磁盘并退出" OFF \
        "12" "(do-not-download-clip)跳过下载CLIP模型" OFF \
        "13" "(no-half)关闭模型半精度优化" OFF \
        "14" "(no-half-vae)关闭VAE模型半精度优化" OFF \
        "15" "(no-progressbar-hiding)不隐藏gradio UI中进度条" OFF \
        "16" "(allow-code)允许从webui执行自定义脚本" OFF \
        "17" "(medvram)启用显存优化(显存<6g时推荐使用)" OFF \
        "18" "(medvram-sdxl)仅在SDXL模型启用显存优化(显存<8g时推荐使用)" OFF \
        "19" "(lowvram)启用显存优化(显存<4g时推荐使用)" OFF \
        "20" "(lowram)将模型加载到显存中而不是内存中" OFF \
        "21" "(precision full)使用模型全精度" OFF \
        "22" "(upcast-sampling)使用向上采样法提高精度" OFF \
        "23" "(share)通过gradio共享" OFF \
        "24" "(enable-insecure-extension-access)允许在开放远程访问时安装插件" OFF \
        "25" "(xformers)尝试使用xformers优化" ON \
        "26" "(force-enable-xformers)强制使用xformers优化" OFF \
        "27" "(xformers-flash-attention)使用xformers-flash优化(仅支持SD2.x以上)" OFF \
        "28" "(opt-split-attention)使用split优化" OFF \
        "29" "(opt-sub-quad-attention)使用sub-quad优化" OFF \
        "30" "(opt-split-attention-invokeai)使用sub-quad-invokeai优化" OFF \
        "31" "(opt-split-attention-v1)使用sub-quad-v1优化" OFF \
        "32" "(opt-sdp-attention)使用sdp优化(仅限PyTorch2.0以上)" OFF \
        "33" "(opt-sdp-no-mem-attention)使用无高效内存使用的sdp优化" OFF \
        "34" "(disable-opt-split-attention)禁用split优化" OFF \
        "35" "(disable-nan-check)禁用潜空间NAN检查" OFF \
        "36" "(use-cpu)使用CPU进行生图" OFF \
        "37" "(disable-model-loading-ram-optimization)禁用减少内存使用的优化" OFF \
        "38" "(listen)开放远程连接" OFF \
        "39" "(hide-ui-dir-config)隐藏webui目录配置" OFF \
        "40" "(freeze-settings)冻结webui设置" OFF \
        "41" "(gradio-debug)以debug模式启用gradio" OFF \
        "42" "(opt-channelslast)使用channelslast内存格式优化" OFF \
        "43" "(autolaunch)启动webui完成后自动启动浏览器" ON \
        "44" "(theme dark)使用黑暗主题" ON \
        "45" "(use-textbox-seed)使用文本框在webui中生成的种子" OFF \
        "46" "(disable-console-progressbars)禁用控制台进度条显示" OFF \
        "47" "(enable-console-prompts)启用在生图时输出提示词到控制台" OFF \
        "48" "(disable-safe-unpickle)禁用检查模型是否包含恶意代码" OFF \
        "49" "(api)启用api" OFF \
        "50" "(api-log)启用输出所有api请求的日志记录" OFF \
        "51" "(nowebui)不加载webui界面" OFF \
        "52" "(ui-debug-mode)不加载模型启动webui(ui debug)" OFF \
        "53" "(administrator)启用管理员权限" OFF \
        "54" "(disable-tls-verify)禁用tls证书验证" OFF \
        "55" "(no-gradio-queue)禁用gradio队列" OFF \
        "56" "(skip-version-check)禁用PyTorch,xformers版本检查" OFF \
        "57" "(no-hashing)禁用模型hash检查" OFF \
        "58" "(no-download-sd-model)禁用自动下载模型,即使模型路径无模型" OFF \
        "59" "(add-stop-route)添加/_stop路由以停止服务器" OFF \
        "60" "(api-server-stop)通过API启用服务器停止/重启/终止功能" OFF \
        "61" "(disable-all-extensions)禁用所有扩展运行" OFF \
        "62" "(disable-extra-extensions)禁用非内置的扩展运行" OFF \
        "63" "(use-ipex)使用intel XPU作为生图后端" OFF \
        "64" "(skip-load-model-at-start)启动webui时不加载模型,加速启动" OFF \
        "65" "(in-browser)启动webui完成后自动启动浏览器" OFF \
        "66" "(disable-in-browser)禁用在启动webui完成后自动启动浏览器" OFF \
        "67" "(async-cuda-allocation)启用CUDA流顺序内存分配器" OFF \
        "68" "(disable-async-cuda-allocation)禁用CUDA流顺序内存分配器" OFF \
        "69" "(disable-attention-upcast)禁用向上注意力优化" OFF \
        "70" "(all-in-fp32)强制使用fp32" OFF \
        "71" "(all-in-fp16)强制使用fp16" OFF \
        "72" "(unet-in-bf16)使用bf16精度运行unet" OFF \
        "73" "(unet-in-fp16)使用fp16精度运行unet" OFF \
        "74" "(unet-in-fp8-e4m3fn)使用fp8(e4m3fn)精度运行unet" OFF \
        "75" "(unet-in-fp8-e5m2)使用fp8(e5m2)精度运行unet" OFF \
        "76" "(vae-in-fp16)使用fp16精度运行vae" OFF \
        "77" "(vae-in-fp32)使用fp32精度运行vae" OFF \
        "78" "(vae-in-bf16)使用bf16精度运行vae" OFF \
        "79" "(vae-in-cpu)将vae移至cpu" OFF \
        "80" "(clip-in-fp8-e4m3fn)使用fp8(e4m3fn)精度运行clip" OFF \
        "81" "(clip-in-fp8-e5m2)使用fp8(e5m2)精度运行clip" OFF \
        "82" "(clip-in-fp16)使用fp16精度运行clip" OFF \
        "83" "(clip-in-fp32)使用fp32精度运行clip" OFF \
        "84" "(disable-ipex-hijack)禁用ipex修复" OFF \
        "85" "(preview-option none)不使用图片预览" OFF \
        "86" "(preview-option fast)使用快速图片预览" OFF \
        "87" "(preview-option taesd)使用taesd图片预览" OFF \
        "88" "(attention-split)使用split优化" OFF \
        "89" "(attention-quad)使用quad优化" OFF \
        "90" "(attention-pytorch)使用PyTorch方案优化" OFF \
        "91" "(disable-xformers)禁用xformers优化" OFF \
        "92" "(always-gpu)将所有模型,文本编码器储存在GPU中" OFF \
        "93" "(always-high-vram)不使用显存优化" OFF \
        "94" "(always-normal-vram)使用默认显存优化" OFF \
        "95" "(always-low-vram)使用显存优化(将会降低生图速度)" OFF \
        "96" "(always-no-vram)使用显存优化(将会大量降低生图速度)" OFF \
        "97" "(always-cpu)使用CPU进行生图" OFF \
        "98" "(always-offload-from-vram)生图完成后将模型从显存中卸载" OFF \
        "99" "(pytorch-deterministic)将PyTorch配置为使用确定性算法" OFF \
        "100" "(disable-server-log)禁用服务端日志输出" OFF \
        "101" "(debug-mode)启用debug模式" OFF \
        "102" "(is-windows-embedded-python)启用Windows独占功能" OFF \
        "103" "(disable-server-info)禁用服务端信息输出" OFF \
        "104" "(multi-user)启用多用户模式" OFF \
        3>&1 1>&2 2>&3)

    if [ $? = 0 ];then
        for i in $sd_webui_forge_launch_args_dialog; do
            case $i in
                1)
                    sd_webui_forge_launch_args="--update-all-extensions"
                    ;;
                2)
                    sd_webui_forge_launch_args="--skip-python-version-check"
                    ;;
                3)
                    sd_webui_forge_launch_args="--skip-torch-cuda-test"
                    ;;
                4)
                    sd_webui_forge_launch_args="--reinstall-xformers"
                    ;;
                5)
                    sd_webui_forge_launch_args="--reinstall-torch"
                    ;;
                6)
                    sd_webui_forge_launch_args="--update-check"
                    ;;
                7)
                    sd_webui_forge_launch_args="--test-server"
                    ;;
                8)
                    sd_webui_forge_launch_args="--log-startup"
                    ;;
                9)
                    sd_webui_forge_launch_args="--skip-prepare-environment"
                    ;;
                10)
                    sd_webui_forge_launch_args="--skip-install"
                    ;;
                11)
                    sd_webui_forge_launch_args="--dump-sysinfo"
                    ;;
                12)
                    sd_webui_forge_launch_args="--do-not-download-clip"
                    ;;
                13)
                    sd_webui_forge_launch_args="--no-half"
                    ;;
                14)
                    sd_webui_forge_launch_args="--no-half-vae"
                    ;;
                15)
                    sd_webui_forge_launch_args="--no-progressbar-hiding"
                    ;;
                16)
                    sd_webui_forge_launch_args="--allow-code"
                    ;;
                17)
                    sd_webui_forge_launch_args="--medvram"
                    ;;
                18)
                    sd_webui_forge_launch_args="--medvram-sdxl"
                    ;;
                19)
                    sd_webui_forge_launch_args="--lowvram"
                    ;;
                20)
                    sd_webui_forge_launch_args="--lowram"
                    ;;
                21)
                    sd_webui_forge_launch_args="--precision full"
                    ;;
                22)
                    sd_webui_forge_launch_args="--upcast-sampling"
                    ;;
                23)
                    sd_webui_forge_launch_args="--share"
                    ;;
                24)
                    sd_webui_forge_launch_args="--enable-insecure-extension-access"
                    ;;
                25)
                    sd_webui_forge_launch_args="--xformers"
                    ;;
                26)
                    sd_webui_forge_launch_args="--force-enable-xformers"
                    ;;
                27)
                    sd_webui_forge_launch_args="--xformers-flash-attention"
                    ;;
                28)
                    sd_webui_forge_launch_args="--opt-split-attention"
                    ;;
                29)
                    sd_webui_forge_launch_args="--opt-sub-quad-attention"
                    ;;
                30)
                    sd_webui_forge_launch_args="--opt-split-attention-invokeai"
                    ;;
                31)
                    sd_webui_forge_launch_args="--opt-split-attention-v1"
                    ;;
                32)
                    sd_webui_forge_launch_args="--opt-sdp-attention"
                    ;;
                33)
                    sd_webui_forge_launch_args="--opt-sdp-no-mem-attention"
                    ;;
                34)
                    sd_webui_forge_launch_args="--disable-opt-split-attention"
                    ;;
                35)
                    sd_webui_forge_launch_args="--disable-nan-check"
                    ;;
                36)
                    sd_webui_forge_launch_args="--use-cpu all"
                    ;;
                37)
                    sd_webui_forge_launch_args="--disable-model-loading-ram-optimization"
                    ;;
                38)
                    sd_webui_forge_launch_args="--listen"
                    ;;
                39)
                    sd_webui_forge_launch_args="--hide-ui-dir-config"
                    ;;
                40)
                    sd_webui_forge_launch_args="--freeze-settings"
                    ;;
                41)
                    sd_webui_forge_launch_args="--gradio-debug"
                    ;;
                42)
                    sd_webui_forge_launch_args="--opt-channelslast"
                    ;;
                43)
                    sd_webui_forge_launch_args="--autolaunch"
                    ;;
                44)
                    sd_webui_forge_launch_args="--theme dark"
                    ;;
                45)
                    sd_webui_forge_launch_args="--use-textbox-seed"
                    ;;
                46)
                    sd_webui_forge_launch_args="--disable-console-progressbars"
                    ;;
                47)
                    sd_webui_forge_launch_args="--enable-console-prompts"
                    ;;
                48)
                    sd_webui_forge_launch_args="--disable-safe-unpickle"
                    ;;
                49)
                    sd_webui_forge_launch_args="--api"
                    ;;
                50)
                    sd_webui_forge_launch_args="--api-log"
                    ;;
                51)
                    sd_webui_forge_launch_args="--nowebui"
                    ;;
                52)
                    sd_webui_forge_launch_args="--ui-debug-mode"
                    ;;
                53)
                    sd_webui_forge_launch_args="--administrator"
                    ;;
                54)
                    sd_webui_forge_launch_args="--disable-tls-verify"
                    ;;
                55)
                    sd_webui_forge_launch_args="--no-gradio-queue"
                    ;;
                56)
                    sd_webui_forge_launch_args="--skip-version-check"
                    ;;
                57)
                    sd_webui_forge_launch_args="--no-hashing"
                    ;;
                58)
                    sd_webui_forge_launch_args="--no-download-sd-model"
                    ;;
                59)
                    sd_webui_forge_launch_args="--add-stop-route"
                    ;;
                60)
                    sd_webui_forge_launch_args="--api-server-stop"
                    ;;
                61)
                    sd_webui_forge_launch_args="--disable-all-extensions"
                    ;;
                62)
                    sd_webui_forge_launch_args="--disable-extra-extensions"
                    ;;
                63)
                    sd_webui_forge_launch_args="--use-ipex"
                    ;;
                64)
                    sd_webui_forge_launch_args="--skip-load-model-at-start"
                    ;;
                65)
                    sd_webui_forge_launch_args="--in-browser"
                    ;;
                66)
                    sd_webui_forge_launch_args="--disable-in-browser"
                    ;;
                67)
                    sd_webui_forge_launch_args="--async-cuda-allocation"
                    ;;
                68)
                    sd_webui_forge_launch_args="--disable-async-cuda-allocation"
                    ;;
                69)
                    sd_webui_forge_launch_args="--disable-attention-upcast"
                    ;;
                70)
                    sd_webui_forge_launch_args="--all-in-fp32"
                    ;;
                71)
                    sd_webui_forge_launch_args="--all-in-fp16"
                    ;;
                72)
                    sd_webui_forge_launch_args="--unet-in-bf16"
                    ;;
                73)
                    sd_webui_forge_launch_args="--unet-in-fp16"
                    ;;
                74)
                    sd_webui_forge_launch_args="--unet-in-fp8-e4m3fn"
                    ;;
                75)
                    sd_webui_forge_launch_args="--unet-in-fp8-e5m2"
                    ;;
                76)
                    sd_webui_forge_launch_args="--vae-in-fp16"
                    ;;
                77)
                    sd_webui_forge_launch_args="--vae-in-fp32"
                    ;;
                78)
                    sd_webui_forge_launch_args="--vae-in-bf16"
                    ;;
                79)
                    sd_webui_forge_launch_args="--vae-in-cpu"
                    ;;
                80)
                    sd_webui_forge_launch_args="--clip-in-fp8-e4m3fn"
                    ;;
                81)
                    sd_webui_forge_launch_args="--clip-in-fp8-e5m2"
                    ;;
                82)
                    sd_webui_forge_launch_args="--clip-in-fp16"
                    ;;
                83)
                    sd_webui_forge_launch_args="--clip-in-fp32"
                    ;;
                84)
                    sd_webui_forge_launch_args="--disable-ipex-hijack"
                    ;;
                85)
                    sd_webui_forge_launch_args="--preview-option none"
                    ;;
                86)
                    sd_webui_forge_launch_args="--preview-option fast"
                    ;;
                87)
                    sd_webui_forge_launch_args="--preview-option taesd"
                    ;;
                88)
                    sd_webui_forge_launch_args="--attention-split"
                    ;;
                89)
                    sd_webui_forge_launch_args="--attention-quad"
                    ;;
                90)
                    sd_webui_forge_launch_args="--attention-pytorch"
                    ;;
                91)
                    sd_webui_forge_launch_args="--disable-xformers"
                    ;;
                92)
                    sd_webui_forge_launch_args="--always-gpu"
                    ;;
                93)
                    sd_webui_forge_launch_args="--always-high-vram"
                    ;;
                94)
                    sd_webui_forge_launch_args="--always-normal-vram"
                    ;;
                95)
                    sd_webui_forge_launch_args="--always-low-vram"
                    ;;
                96)
                    sd_webui_forge_launch_args="--always-no-vram"
                    ;;
                97)
                    sd_webui_forge_launch_args="--always-cpu"
                    ;;
                98)
                    sd_webui_forge_launch_args="--always-offload-from-vram"
                    ;;
                99)
                    sd_webui_forge_launch_args="--pytorch-deterministic"
                    ;;
                100)
                    sd_webui_forge_launch_args="--disable-server-log"
                    ;;
                101)
                    sd_webui_forge_launch_args="--debug-mode"
                    ;;
                102)
                    sd_webui_forge_launch_args="--is-windows-embedded-python"
                    ;;
                103)
                    sd_webui_forge_launch_args="--disable-server-info"
                    ;;
                104)
                    sd_webui_forge_launch_args="--multi-user"
                    ;;
            esac
            launch_args="$sd_webui_forge_launch_args $launch_args"
        done
    
        # 生成启动脚本
        term_sd_echo "设置启动参数: $launch_args"
        echo "launch.py $launch_args" > "$start_path"/term-sd/config/sd-webui-forge-launch.conf
    else
        term_sd_echo "取消设置启动参数"
    fi
}

# sd-webui-forge启动界面
sd_webui_forge_launch()
{
    local sd_webui_forge_launch_dialog

    if [ ! -f "$start_path/term-sd/config/sd-webui-forge-launch.conf" ]; then # 找不到启动配置时默认生成一个
        term_sd_echo "未找到启动配置文件,创建中"
        echo "launch.py --theme dark --autolaunch --xformers" > "$start_path"/term-sd/config/sd-webui-forge-launch.conf
    fi

    while true
    do
        sd_webui_forge_launch_dialog=$(
            dialog --erase-on-exit --notags --title "Stable-Diffusion-WebUI-Forge管理" --backtitle "Stable-Diffusion-WebUI-Forge启动选项" --ok-label "确认" --cancel-label "取消" --menu "请选择启动Stable-Diffusion-WebUI-Forge/修改Stable-Diffusion-WebUI-Forge启动参数\n当前启动参数:\n$([ $venv_setup_status = 0 ] && echo python || echo "$term_sd_python_path") $(cat "$start_path"/term-sd/config/sd-webui-forge-launch.conf)" $term_sd_dialog_height $term_sd_dialog_width $term_sd_dialog_menu_height \
            "0" "> 返回" \
            "1" "> 启动" \
            "2" "> 配置预设启动参数" \
            "3" "> 修改自定义启动参数" \
            3>&1 1>&2 2>&3)
        
        case $sd_webui_forge_launch_dialog in
            1)
                term_sd_launch
                ;;
            2)
                sd_webui_forge_launch_args_setting
                ;;
            3)
                sd_webui_forge_launch_args_revise
                ;;
            *)
                break
                ;;
        esac
    done
}

# sd-webui-forge启动参数修改
sd_webui_forge_launch_args_revise()
{
    local sd_webui_forge_launch_args

    sd_webui_forge_launch_args=$(dialog --erase-on-exit --title "Stable-Diffusion-WebUI-Forge管理" --backtitle "Stable-Diffusion-WebUI-Forge自定义启动参数选项" --ok-label "确认" --cancel-label "取消" --inputbox "请输入Stable-Diffusion-WebUI-Forge启动参数" $term_sd_dialog_height $term_sd_dialog_width "$(cat "$start_path"/term-sd/config/sd-webui-forge-launch.conf | awk '{sub("launch.py ","")}1')" 3>&1 1>&2 2>&3)

    if [ $? = 0 ];then
        term_sd_echo "设置启动参数: $sd_webui_forge_launch_args"
        echo "launch.py $sd_webui_forge_launch_args" > "$start_path"/term-sd/config/sd-webui-forge-launch.conf
    else
        term_sd_echo "取消启动参数修改"
    fi
}
