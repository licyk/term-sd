#!/bin/bash

# a1111-sd-webui启动脚本参数设置
a1111_sd_webui_launch_args_setting()
{
    local a1111_sd_webui_launch_args
    local a1111_sd_webui_launch_args_dialog
    local launch_args

    a1111_sd_webui_launch_args_dialog=$(dialog --erase-on-exit --notags \
        --title "Stable-Diffusion-WebUI 管理" \
        --backtitle "Stable-Diffusion-WebUI 启动参数选项" \
        --ok-label "确认" --cancel-label "取消" \
        --checklist "请选择 A1111-Stable-Diffusion-WebUI 启动参数, 确认之后将覆盖原有启动参数配置" \
        $term_sd_dialog_height $term_sd_dialog_width $term_sd_dialog_menu_height \
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
        "26" "(xformers) 尝试使用 xFormers 优化" ON \
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
        "44" "(autolaunch) 启动 WebUI 完成后自动启动浏览器" ON \
        "45" "(theme dark) 使用黑暗主题" ON \
        "46" "(use-textbox-seed) 使用文本框在 WebUI 中生成的种子" OFF \
        "47" "(disable-console-progressbars) 禁用控制台进度条显示" OFF \
        "48" "(enable-console-prompts) 启用在生图时输出提示词到控制台" OFF \
        "49" "(disable-safe-unpickle) 禁用检查模型是否包含恶意代码" OFF \
        "50" "(api) 启用 API" ON \
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
        "65" "(skip-load-model-at-start) 启动 WebUI 时不加载模型, 加速启动" ON \
        3>&1 1>&2 2>&3)

    if [ $? = 0 ];then
        for i in $a1111_sd_webui_launch_args_dialog; do
            case $i in
                1)
                    a1111_sd_webui_launch_args="--update-all-extensions"
                    ;;
                2)
                    a1111_sd_webui_launch_args="--skip-python-version-check"
                    ;;
                3)
                    a1111_sd_webui_launch_args="--skip-torch-cuda-test"
                    ;;
                4)
                    a1111_sd_webui_launch_args="--reinstall-xformers"
                    ;;
                5)
                    a1111_sd_webui_launch_args="--reinstall-torch"
                    ;;
                6)
                    a1111_sd_webui_launch_args="--update-check"
                    ;;
                7)
                    a1111_sd_webui_launch_args="--test-server"
                    ;;
                8)
                    a1111_sd_webui_launch_args="--log-startup"
                    ;;
                9)
                    a1111_sd_webui_launch_args="--skip-prepare-environment"
                    ;;
                10)
                    a1111_sd_webui_launch_args="--skip-install"
                    ;;
                11)
                    a1111_sd_webui_launch_args="--dump-sysinfo"
                    ;;
                12)
                    a1111_sd_webui_launch_args="--do-not-download-clip"
                    ;;
                13)
                    a1111_sd_webui_launch_args="--no-half"
                    ;;
                14)
                    a1111_sd_webui_launch_args="--no-half-vae"
                    ;;
                15)
                    a1111_sd_webui_launch_args="--no-progressbar-hiding"
                    ;;
                16)
                    a1111_sd_webui_launch_args="--allow-code"
                    ;;
                17)
                    a1111_sd_webui_launch_args="--medvram"
                    ;;
                18)
                    a1111_sd_webui_launch_args="--medvram-sdxl"
                    ;;
                19)
                    a1111_sd_webui_launch_args="--lowvram"
                    ;;
                20)
                    a1111_sd_webui_launch_args="--lowram"
                    ;;
                21)
                    a1111_sd_webui_launch_args="--precision half"
                    ;;
                22)
                    a1111_sd_webui_launch_args="--precision full"
                    ;;
                23)
                    a1111_sd_webui_launch_args="--upcast-sampling"
                    ;;
                24)
                    a1111_sd_webui_launch_args="--share"
                    ;;
                25)
                    a1111_sd_webui_launch_args="--enable-insecure-extension-access"
                    ;;
                26)
                    a1111_sd_webui_launch_args="--xformers"
                    ;;
                27)
                    a1111_sd_webui_launch_args="--force-enable-xformers"
                    ;;
                28)
                    a1111_sd_webui_launch_args="--xformers-flash-attention"
                    ;;
                29)
                    a1111_sd_webui_launch_args="--opt-split-attention"
                    ;;
                30)
                    a1111_sd_webui_launch_args="--opt-sub-quad-attention"
                    ;;
                31)
                    a1111_sd_webui_launch_args="--opt-split-attention-invokeai"
                    ;;
                32)
                    a1111_sd_webui_launch_args="--opt-split-attention-v1"
                    ;;
                33)
                    a1111_sd_webui_launch_args="--opt-sdp-attention"
                    ;;
                34)
                    a1111_sd_webui_launch_args="--opt-sdp-no-mem-attention"
                    ;;
                35)
                    a1111_sd_webui_launch_args="--disable-opt-split-attention"
                    ;;
                36)
                    a1111_sd_webui_launch_args="--disable-nan-check"
                    ;;
                37)
                    a1111_sd_webui_launch_args="--use-cpu all"
                    ;;
                38)
                    a1111_sd_webui_launch_args="--disable-model-loading-ram-optimization"
                    ;;
                39)
                    a1111_sd_webui_launch_args="--listen"
                    ;;
                40)
                    a1111_sd_webui_launch_args="--hide-ui-dir-config"
                    ;;
                41)
                    a1111_sd_webui_launch_args="--freeze-settings"
                    ;;
                42)
                    a1111_sd_webui_launch_args="--gradio-debug"
                    ;;
                43)
                    a1111_sd_webui_launch_args="--opt-channelslast"
                    ;;
                44)
                    a1111_sd_webui_launch_args="--autolaunch"
                    ;;
                45)
                    a1111_sd_webui_launch_args="--theme dark"
                    ;;
                46)
                    a1111_sd_webui_launch_args="--use-textbox-seed"
                    ;;
                47)
                    a1111_sd_webui_launch_args="--disable-console-progressbars"
                    ;;
                48)
                    a1111_sd_webui_launch_args="--enable-console-prompts"
                    ;;
                49)
                    a1111_sd_webui_launch_args="--disable-safe-unpickle"
                    ;;
                50)
                    a1111_sd_webui_launch_args="--api"
                    ;;
                51)
                    a1111_sd_webui_launch_args="--api-log"
                    ;;
                52)
                    a1111_sd_webui_launch_args="--nowebui"
                    ;;
                53)
                    a1111_sd_webui_launch_args="--ui-debug-mode"
                    ;;
                54)
                    a1111_sd_webui_launch_args="--administrator"
                    ;;
                55)
                    a1111_sd_webui_launch_args="--disable-tls-verify"
                    ;;
                56)
                    a1111_sd_webui_launch_args="--no-gradio-queue"
                    ;;
                57)
                    a1111_sd_webui_launch_args="--skip-version-check"
                    ;;
                58)
                    a1111_sd_webui_launch_args="--no-hashing"
                    ;;
                59)
                    a1111_sd_webui_launch_args="--no-download-sd-model"
                    ;;
                60)
                    a1111_sd_webui_launch_args="--add-stop-route"
                    ;;
                61)
                    a1111_sd_webui_launch_args="--api-server-stop"
                    ;;
                62)
                    a1111_sd_webui_launch_args="--disable-all-extensions"
                    ;;
                63)
                    a1111_sd_webui_launch_args="--disable-extra-extensions"
                    ;;
                64)
                    a1111_sd_webui_launch_args="--use-ipex"
                    ;;
                65)
                    a1111_sd_webui_launch_args="--skip-load-model-at-start"
                    ;;
            esac
            launch_args="$a1111_sd_webui_launch_args $launch_args"
        done

        # 生成启动脚本
        term_sd_echo "设置启动参数: $launch_args"
        echo "launch.py $launch_args" > "$start_path"/term-sd/config/sd-webui-launch.conf
    else
        term_sd_echo "取消设置启动参数"
    fi
}

# a1111-sd-webui启动界面
a1111_sd_webui_launch()
{
    local a1111_sd_webui_launch_dialog

    if [ ! -f "$start_path/term-sd/config/sd-webui-launch.conf" ]; then # 找不到启动配置时默认生成一个
        term_sd_echo "未找到启动配置文件, 创建中"
        echo "launch.py --theme dark --autolaunch --xformers --api --skip-load-model-at-start" > "$start_path"/term-sd/config/sd-webui-launch.conf
    fi

    while true
    do
        a1111_sd_webui_launch_dialog=$(dialog --erase-on-exit --notags \
            --title "Stable-Diffusion-WebUI 管理" \
            --backtitle "Stable-Diffusion-WebUI 启动选项" \
            --ok-label "确认" --cancel-label "取消" \
            --menu "请选择启动 Stable-Diffusion-WebUI / 修改 Stable-Diffusion-WebUI 启动参数\n当前启动参数:\n$([ $venv_setup_status = 0 ] && echo python || echo "$term_sd_python_path") $(cat "$start_path"/term-sd/config/sd-webui-launch.conf)" \
            $term_sd_dialog_height $term_sd_dialog_width $term_sd_dialog_menu_height \
            "0" "> 返回" \
            "1" "> 启动" \
            "2" "> 配置预设启动参数" \
            "3" "> 修改自定义启动参数" \
            3>&1 1>&2 2>&3)
        
        case $a1111_sd_webui_launch_dialog in
            1)
                term_sd_launch
                ;;
            2)
                a1111_sd_webui_launch_args_setting
                ;;
            3)
                a1111_sd_webui_launch_args_revise
                ;;
            *)
                break
                ;;
        esac
    done
}

# a1111-sd-webui启动参数修改
a1111_sd_webui_launch_args_revise()
{
    local a1111_sd_webui_launch_args

    a1111_sd_webui_launch_args=$(dialog --erase-on-exit \
        --title "Stable-Diffusion-WebUI 管理" \
        --backtitle "Stable-Diffusion-WebUI 自定义启动参数选项" \
        --ok-label "确认" --cancel-label "取消" \
        --inputbox "请输入 Stable-Diffusion-WebUI 启动参数" \
        $term_sd_dialog_height $term_sd_dialog_width \
        "$(cat "$start_path"/term-sd/config/sd-webui-launch.conf | awk '{sub("launch.py ","")}1')" \
        3>&1 1>&2 2>&3)

    if [ $? = 0 ];then
        term_sd_echo "设置启动参数: $a1111_sd_webui_launch_args"
        echo "launch.py $a1111_sd_webui_launch_args" > "$start_path"/term-sd/config/sd-webui-launch.conf
    else
        term_sd_echo "取消启动参数修改"
    fi
}
