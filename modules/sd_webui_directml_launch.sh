#!/bin/bash

# sd-webui-directml启动参数生成功能
sd_webui_directml_launch_args_setting()
{
    local sd_webui_directml_launch_args_setting_dialog
    local sd_webui_directml_launch_args
    local launch_args

    sd_webui_directml_launch_args_setting_dialog=$(dialog --erase-on-exit --notags \
        --title "Stable-Diffusion-WebUI 管理" \
        --backtitle "Stable-Diffusion-WebUI-DirectML 启动参数选项" \
        --ok-label "确认" --cancel-label "取消" \
        --checklist "请选择 Stable-Diffusion-WebUI-DirectML 启动参数, 确认之后将覆盖原有启动参数配置" \
        $term_sd_dialog_height $term_sd_dialog_width $term_sd_dialog_menu_height \
        "1" "(update-all-extensions) 启动时更新所有扩展" OFF \
        "2" "(skip-python-version-check) 跳过检查 Python 版本" OFF \
        "3" "(skip-torch-cuda-test) 跳过 CUDA 可用性检查" ON \
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
        "19" "(lowvram) 启用显存优化 (显存 < 4g时推荐使用)" OFF \
        "20" "(lowram) 将模型加载到显存中而不是内存中" OFF \
        "21" "(precision full) 使用模型全精度" OFF \
        "22" "(upcast-sampling) 使用向上采样法提高精度" OFF \
        "23" "(share) 通过 Gradio 共享" OFF \
        "24" "(enable-insecure-extension-access) 允许在开放远程访问时安装插件" OFF \
        "25" "(xformers) 尝试使用 xFormers 优化" OFF \
        "26" "(force-enable-xformers) 强制使用 xFormers 优化" OFF \
        "27" "(xformers-flash-attention) 使用 xFormers-Flash 优化 (仅支持 SD2.x 以上)" OFF \
        "28" "(opt-split-attention) 使用 Opt-Split 优化" OFF \
        "29" "(opt-sub-quad-attention) 使用 Opt-Sub-Quad优化" OFF \
        "30" "(opt-split-attention-invokeai) 使用 Opt-Sub-Quad-InvokeAI 优化" OFF \
        "31" "(opt-split-attention-v1) 使用 Opt-Sub-Quad-V1优化" OFF \
        "32" "(opt-sdp-attention) 使用 Opt-Sdp优化(仅限 PyTorch2.0 以上)" OFF \
        "33" "(opt-sdp-no-mem-attention) 使用无高效内存使用的 Opt-Sdp 优化" OFF \
        "34" "(disable-opt-split-attention) 禁用 Opt-Split 优化" OFF \
        "35" "(disable-nan-check) 禁用潜空间 NAN 检查" OFF \
        "36" "(use-cpu) 使用 CPU 进行生图" OFF \
        "37" "(disable-model-loading-ram-optimization) 禁用减少内存使用的优化" OFF \
        "38" "(listen) 开放远程连接" OFF \
        "39" "(hide-ui-dir-config) 隐藏 WebUI 目录配置" OFF \
        "40" "(freeze-settings) 冻结 WebUI 设置" OFF \
        "41" "(gradio-debug) 以 Debug 模式启用 Gradio" OFF \
        "42" "(opt-channelslast) 使用 ChannelsLast 内存格式优化" OFF \
        "43" "(autolaunch) 启动 WebUI 完成后自动启动浏览器" ON \
        "44" "(theme dark) 使用黑暗主题" ON \
        "45" "(use-textbox-seed) 使用文本框在 WebUI 中生成的种子" OFF \
        "46" "(disable-console-progressbars) 禁用控制台进度条显示" OFF \
        "47" "(enable-console-prompts) 启用在生图时输出提示词到控制台" OFF \
        "48" "(disable-safe-unpickle) 禁用检查模型是否包含恶意代码" OFF \
        "49" "(api) 启用 API" ON \
        "50" "(api-log) 启用输出所有 API 请求的日志记录" OFF \
        "51" "(nowebui) 不加载 WebUI 界面" OFF \
        "52" "(onnx) 使用 ONNX 模型" OFF \
        "53" "(olive) 使用 OLIVE 模型" OFF \
        "54" "(backend cuda) 使用 CUDA 作为后端进行生图" OFF \
        "55" "(backend rocm) 使用 ROCM 作为后端进行生图" OFF \
        "56" "(backend directml) 使用 DirectML 作为后端进行生图" ON \
        "57" "(ui-debug-mode) 不加载模型启动 WebUI (UI Debug)" OFF \
        "58" "(administrator) 启用管理员权限" OFF \
        "59" "(disable-tls-verify) 禁用 TLS 证书验证" OFF \
        "60" "(no-gradio-queue) 禁用 Gradio 队列" OFF \
        "61" "(skip-version-check) 禁用 PyTorch, xformers 版本检查" OFF \
        "62" "(no-hashing) 禁用模型 Hash 检查" OFF \
        "63" "(no-download-sd-model) 禁用自动下载模型, 即使模型路径无模型" OFF \
        "64" "(add-stop-route) 添加 /_stop 路由以停止服务器" OFF \
        "65" "(api-server-stop) 通过 API 启用服务器停止 / 重启 / 终止功能" OFF \
        "66" "(disable-all-extensions) 禁用所有扩展运行" OFF \
        "67" "(disable-extra-extensions) 禁用非内置的扩展运行" OFF \
        3>&1 1>&2 2>&3)

    if [ $? = 0 ];then
        for i in $sd_webui_directml_launch_args_setting_dialog; do
            case $i in
                1)
                    sd_webui_directml_launch_args="--update-all-extensions"
                    ;;
                2)
                    sd_webui_directml_launch_args="--skip-python-version-check"
                    ;;
                3)
                    sd_webui_directml_launch_args="--skip-torch-cuda-test"
                    ;;
                4)
                    sd_webui_directml_launch_args="--reinstall-xformers"
                    ;;
                5)
                    sd_webui_directml_launch_args="--reinstall-torch"
                    ;;
                6)
                    sd_webui_directml_launch_args="--update-check"
                    ;;
                7)
                    sd_webui_directml_launch_args="--test-server"
                    ;;
                8)
                    sd_webui_directml_launch_args="--log-startup"
                    ;;
                9)
                    sd_webui_directml_launch_args="--skip-prepare-environment"
                    ;;
                10)
                    sd_webui_directml_launch_args="--skip-install"
                    ;;
                11)
                    sd_webui_directml_launch_args="--dump-sysinfo"
                    ;;
                12)
                    sd_webui_directml_launch_args="--do-not-download-clip"
                    ;;
                13)
                    sd_webui_directml_launch_args="--no-half"
                    ;;
                14)
                    sd_webui_directml_launch_args="--no-half-vae"
                    ;;
                15)
                    sd_webui_directml_launch_args="--no-progressbar-hiding"
                    ;;
                16)
                    sd_webui_directml_launch_args="--allow-code"
                    ;;
                17)
                    sd_webui_directml_launch_args="--medvram"
                    ;;
                18)
                    sd_webui_directml_launch_args="--medvram-sdxl"
                    ;;
                19)
                    sd_webui_directml_launch_args="--lowvram"
                    ;;
                20)
                    sd_webui_directml_launch_args="--lowram"
                    ;;
                21)
                    sd_webui_directml_launch_args="--precision full"
                    ;;
                22)
                    sd_webui_directml_launch_args="--upcast-sampling"
                    ;;
                23)
                    sd_webui_directml_launch_args="--share"
                    ;;
                24)
                    sd_webui_directml_launch_args="--enable-insecure-extension-access"
                    ;;
                25)
                    sd_webui_directml_launch_args="--xformers"
                    ;;
                26)
                    sd_webui_directml_launch_args="--force-enable-xformers"
                    ;;
                27)
                    sd_webui_directml_launch_args="--xformers-flash-attention"
                    ;;
                28)
                    sd_webui_directml_launch_args="--opt-split-attention"
                    ;;
                29)
                    sd_webui_directml_launch_args="--opt-sub-quad-attention"
                    ;;
                30)
                    sd_webui_directml_launch_args="--opt-split-attention-invokeai"
                    ;;
                31)
                    sd_webui_directml_launch_args="--opt-split-attention-v1"
                    ;;
                32)
                    sd_webui_directml_launch_args="--opt-sdp-attention"
                    ;;
                33)
                    sd_webui_directml_launch_args="--opt-sdp-no-mem-attention"
                    ;;
                34)
                    sd_webui_directml_launch_args="--disable-opt-split-attention"
                    ;;
                35)
                    sd_webui_directml_launch_args="--disable-nan-check"
                    ;;
                36)
                    sd_webui_directml_launch_args="--use-cpu all"
                    ;;
                37)
                    sd_webui_directml_launch_args="--disable-model-loading-ram-optimization"
                    ;;
                38)
                    sd_webui_directml_launch_args="--listen"
                    ;;
                39)
                    sd_webui_directml_launch_args="--hide-ui-dir-config"
                    ;;
                40)
                    sd_webui_directml_launch_args="--freeze-settings"
                    ;;
                41)
                    sd_webui_directml_launch_args="--gradio-debug"
                    ;;
                42)
                    sd_webui_directml_launch_args="--opt-channelslast"
                    ;;
                43)
                    sd_webui_directml_launch_args="--autolaunch"
                    ;;
                44)
                    sd_webui_directml_launch_args="--theme dark"
                    ;;
                45)
                    sd_webui_directml_launch_args="--use-textbox-seed"
                    ;;
                46)
                    sd_webui_directml_launch_args="--disable-console-progressbars"
                    ;;
                47)
                    sd_webui_directml_launch_args="--enable-console-prompts"
                    ;;
                48)
                    sd_webui_directml_launch_args="--disable-safe-unpickle"
                    ;;
                49)
                    sd_webui_directml_launch_args="--api"
                    ;;
                50)
                    sd_webui_directml_launch_args="--api-log"
                    ;;
                51)
                    sd_webui_directml_launch_args="--nowebui"
                    ;;
                52)
                    sd_webui_directml_launch_args="--onnx"
                    ;;
                53)
                    sd_webui_directml_launch_args="--olive"
                    ;;
                54)
                    sd_webui_directml_launch_args="--backend cuda"
                    ;;
                55)
                    sd_webui_directml_launch_args="--backend rocm"
                    ;;
                56)
                    sd_webui_directml_launch_args="--backend directml"
                    ;;
                57)
                    sd_webui_directml_launch_args="--ui-debug-mode"
                    ;;
                58)
                    sd_webui_directml_launch_args="--administrator"
                    ;;
                59)
                    sd_webui_directml_launch_args="--disable-tls-verify"
                    ;;
                60)
                    sd_webui_directml_launch_args="--no-gradio-queue"
                    ;;
                61)
                    sd_webui_directml_launch_args="--skip-version-check"
                    ;;
                62)
                    sd_webui_directml_launch_args="--no-hashing"
                    ;;
                63)
                    sd_webui_directml_launch_args="--no-download-sd-model"
                    ;;
                64)
                    sd_webui_directml_launch_args="--add-stop-route"
                    ;;
                65)
                    sd_webui_directml_launch_args="--api-server-stop"
                    ;;
                66)
                    sd_webui_directml_launch_args="--disable-all-extensions"
                    ;;
                67)
                    sd_webui_directml_launch_args="--disable-extra-extensions"
                    ;;
            esac
            launch_args="$sd_webui_directml_launch_args $launch_args"
        done
    
        # 生成启动脚本
        term_sd_echo "设置启动参数: $launch_args"
        echo "launch.py $launch_args" > "$start_path"/term-sd/config/sd-webui-directml-launch.conf
    else
        term_sd_echo "取消设置启动参数"
    fi
}

# sd-webui-directml启动界面
sd_webui_directml_launch()
{
    local sd_webui_directml_launch_dialog

    add_sd_webui_directml_normal_launch_args

    while true
    do
        sd_webui_directml_launch_dialog=$(dialog --erase-on-exit --notags \
            --title "Stable-Diffusion-WebUI 管理" \
            --backtitle "Stable-Diffusion-WebUI-DirectML 启动选项" \
            --ok-label "确认" --cancel-label "取消" \
            --menu "请选择启动 Stable-Diffusion-WebUI-DirectML / 修改 Stable-Diffusion-WebUI-DirectML 启动参数\n当前启动参数:\n$([ $venv_setup_status = 0 ] && echo python || echo "$term_sd_python_path") $(cat "$start_path"/term-sd/config/sd-webui-directml-launch.conf)" \
            $term_sd_dialog_height $term_sd_dialog_width $term_sd_dialog_menu_height \
            "0" "> 返回" \
            "1" "> 启动" \
            "2" "> 配置预设启动参数" \
            "3" "> 修改自定义启动参数" \
            "4" "> 重置启动参数" \
            3>&1 1>&2 2>&3)

        case $sd_webui_directml_launch_dialog in
            1)
                term_sd_launch
                ;;
            2)
                sd_webui_directml_launch_args_setting
                ;;
            3)
                sd_webui_directml_launch_args_revise
                ;;
            4)
                restore_sd_webui_directml_launch_args
                ;;
            *)
                break
                ;;
        esac
    done
}

# sd-webui-directml手动输入启动参数界面
sd_webui_directml_launch_args_revise()
{
    local sd_webui_directml_launch_args

    sd_webui_directml_launch_args=$(dialog --erase-on-exit \
        --title "Stable-Diffusion-WebUI 管理" \
        --backtitle "Stable-Diffusion-WebUI-DirectML 自定义启动参数选项" \
        --ok-label "确认" --cancel-label "取消" \
        --inputbox "请输入 Stable-Diffusion-WebUI-DirectML 启动参数" \
        $term_sd_dialog_height $term_sd_dialog_width \
        "$(cat "$start_path"/term-sd/config/sd-webui-directml-launch.conf | awk '{sub("launch.py ","")}1')" \
        3>&1 1>&2 2>&3)

    if [ $? = 0 ];then
        term_sd_echo "设置启动参数: $sd_webui_directml_launch_args"
        echo "launch.py $sd_webui_directml_launch_args" > "$start_path"/term-sd/config/sd-webui-directml-launch.conf
    else
        term_sd_echo "取消启动参数修改"
    fi
}

# 添加默认启动参数配置
add_sd_webui_directml_normal_launch_args()
{
    if [ ! -f "$start_path/term-sd/config/sd-webui-directml-launch.conf" ]; then # 找不到启动配置时默认生成一个
        echo "launch.py --theme dark --autolaunch --api --skip-torch-cuda-test --backend directml" > "$start_path"/term-sd/config/sd-webui-directml-launch.conf
    fi
}

# 重置启动参数
restore_sd_webui_directml_launch_args()
{
    if (dialog --erase-on-exit \
        --title "Stable-Diffusion-WebUI 管理" \
        --backtitle "Stable-Diffusion-WebUI-DirectML 重置启动参数选项选项" \
        --yes-label "是" --no-label "否" \
        --yesno "是否重置 Stable-Diffusion-WebUI-DirectML 启动参数" \
        $term_sd_dialog_height $term_sd_dialog_width) then

        term_sd_echo "重置启动参数"
        rm -f "$start_path"/term-sd/config/sd-webui-directml-launch.conf
        add_sd_webui_directml_normal_launch_args
    else
        term_sd_echo "取消重置操作"
    fi
}