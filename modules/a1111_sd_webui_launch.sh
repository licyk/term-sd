#!/bin/bash

# a1111-sd-webui启动脚本参数设置
a1111_sd_webui_launch_args_setting()
{
    local a1111_sd_webui_launch_args
    local a1111_sd_webui_launch_args_dialog

    a1111_sd_webui_launch_args_dialog=$(
        dialog --erase-on-exit --title "Stable-Diffusion-WebUI管理" --backtitle "Stable-Diffusion-WebUI启动参数选项" --separate-output --notags --ok-label "确认" --cancel-label "取消" --checklist "请选择A1111-Stable-Diffusion-Webui启动参数,确认之后将覆盖原有启动参数配置" 25 80 10 \
        "1" "(update-all-extensions)启动时更新所有扩展" OFF \
        "2" "(skip-python-version-check)跳过检查python版本" OFF \
        "3" "(skip-torch-cuda-test)跳过CUDA可用性检查" OFF \
        "4" "(reinstall-xformers)启动时重新安装xformers" OFF \
        "5" "(reinstall-torch)启动时重新安装pytorch" OFF \
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
        "17" "(medvram)启用显存优化,(显存<6g时推荐使用)" OFF \
        "18" "(medvram-sdxl)仅在SDXL模型启用显存优化,(显存<8g时推荐使用)" OFF \
        "19" "(lowvram)启用显存优化,(显存<4g时推荐使用)" OFF \
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
        "32" "(opt-sdp-attention)使用sdp优化(仅限pytorch2.0以上)" OFF \
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
        "56" "(skip-version-check)禁用pytorch,xformers版本检查" OFF \
        "57" "(no-hashing)禁用模型hash检查" OFF \
        "58" "(no-download-sd-model)禁用自动下载模型,即使模型路径无模型" OFF \
        "59" "(add-stop-route)添加/_stop路由以停止服务器" OFF \
        "60" "(api-server-stop)通过API启用服务器停止/重启/终止功能" OFF \
        "61" "(disable-all-extensions)禁用所有扩展运行" OFF \
        "62" "(disable-extra-extensions)禁用非内置的扩展运行" OFF \
        3>&1 1>&2 2>&3)

    if [ $? = 0 ];then
        for i in $a1111_sd_webui_launch_args_dialog; do
            case $i in
                1)
                    a1111_sd_webui_launch_args="--update-all-extensions $a1111_sd_webui_launch_args"
                    ;;
                2)
                    a1111_sd_webui_launch_args="--skip-python-version-check $a1111_sd_webui_launch_args"
                    ;;
                3)
                    a1111_sd_webui_launch_args="--skip-torch-cuda-test $a1111_sd_webui_launch_args"
                    ;;
                4)
                    a1111_sd_webui_launch_args="--reinstall-xformers $a1111_sd_webui_launch_args"
                    ;;
                5)
                    a1111_sd_webui_launch_args="--reinstall-torch $a1111_sd_webui_launch_args"
                    ;;
                6)
                    a1111_sd_webui_launch_args="--update-check $a1111_sd_webui_launch_args"
                    ;;
                7)
                    a1111_sd_webui_launch_args="--test-server $a1111_sd_webui_launch_args"
                    ;;
                8)
                    a1111_sd_webui_launch_args="--log-startup $a1111_sd_webui_launch_args"
                    ;;
                9)
                    a1111_sd_webui_launch_args="--skip-prepare-environment $a1111_sd_webui_launch_args"
                    ;;
                10)
                    a1111_sd_webui_launch_args="--skip-install $a1111_sd_webui_launch_args"
                    ;;
                11)
                    a1111_sd_webui_launch_args="--dump-sysinfo $a1111_sd_webui_launch_args"
                    ;;
                12)
                    a1111_sd_webui_launch_args="--do-not-download-clip $a1111_sd_webui_launch_args"
                    ;;
                13)
                    a1111_sd_webui_launch_args="--no-half $a1111_sd_webui_launch_args"
                    ;;
                14)
                    a1111_sd_webui_launch_args="--no-half-vae $a1111_sd_webui_launch_args"
                    ;;
                15)
                    a1111_sd_webui_launch_args="--no-progressbar-hiding $a1111_sd_webui_launch_args"
                    ;;
                16)
                    a1111_sd_webui_launch_args="--allow-code $a1111_sd_webui_launch_args"
                    ;;
                17)
                    a1111_sd_webui_launch_args="--medvram $a1111_sd_webui_launch_args"
                    ;;
                18)
                    a1111_sd_webui_launch_args="--medvram-sdxl $a1111_sd_webui_launch_args"
                    ;;
                19)
                    a1111_sd_webui_launch_args="--lowvram $a1111_sd_webui_launch_args"
                    ;;
                20)
                    a1111_sd_webui_launch_args="--lowram $a1111_sd_webui_launch_args"
                    ;;
                21)
                    a1111_sd_webui_launch_args="--precision full $a1111_sd_webui_launch_args"
                    ;;
                22)
                    a1111_sd_webui_launch_args="--upcast-sampling $a1111_sd_webui_launch_args"
                    ;;
                23)
                    a1111_sd_webui_launch_args="--share $a1111_sd_webui_launch_args"
                    ;;
                24)
                    a1111_sd_webui_launch_args="--enable-insecure-extension-access $a1111_sd_webui_launch_args"
                    ;;
                25)
                    a1111_sd_webui_launch_args="--xformers $a1111_sd_webui_launch_args"
                    ;;
                26)
                    a1111_sd_webui_launch_args="--force-enable-xformers $a1111_sd_webui_launch_args"
                    ;;
                27)
                    a1111_sd_webui_launch_args="--xformers-flash-attention $a1111_sd_webui_launch_args"
                    ;;
                28)
                    a1111_sd_webui_launch_args="--opt-split-attention $a1111_sd_webui_launch_args"
                    ;;
                29)
                    a1111_sd_webui_launch_args="--opt-sub-quad-attention $a1111_sd_webui_launch_args"
                    ;;
                30)
                    a1111_sd_webui_launch_args="--opt-split-attention-invokeai $a1111_sd_webui_launch_args"
                    ;;
                31)
                    a1111_sd_webui_launch_args="--opt-split-attention-v1 $a1111_sd_webui_launch_args"
                    ;;
                32)
                    a1111_sd_webui_launch_args="--opt-sdp-attention $a1111_sd_webui_launch_args"
                    ;;
                33)
                    a1111_sd_webui_launch_args="--opt-sdp-no-mem-attention $a1111_sd_webui_launch_args"
                    ;;
                34)
                    a1111_sd_webui_launch_args="--disable-opt-split-attention $a1111_sd_webui_launch_args"
                    ;;
                35)
                    a1111_sd_webui_launch_args="--disable-nan-check $a1111_sd_webui_launch_args"
                    ;;
                36)
                    a1111_sd_webui_launch_args="--use-cpu all $a1111_sd_webui_launch_args"
                    ;;
                37)
                    a1111_sd_webui_launch_args="--disable-model-loading-ram-optimization $a1111_sd_webui_launch_args"
                    ;;
                38)
                    a1111_sd_webui_launch_args="--listen $a1111_sd_webui_launch_args"
                    ;;
                39)
                    a1111_sd_webui_launch_args="--hide-ui-dir-config $a1111_sd_webui_launch_args"
                    ;;
                40)
                    a1111_sd_webui_launch_args="--freeze-settings $a1111_sd_webui_launch_args"
                    ;;
                41)
                    a1111_sd_webui_launch_args="--gradio-debug $a1111_sd_webui_launch_args"
                    ;;
                42)
                    a1111_sd_webui_launch_args="--opt-channelslast $a1111_sd_webui_launch_args"
                    ;;
                43)
                    a1111_sd_webui_launch_args="--autolaunch $a1111_sd_webui_launch_args"
                    ;;
                44)
                    a1111_sd_webui_launch_args="--theme dark $a1111_sd_webui_launch_args"
                    ;;
                45)
                    a1111_sd_webui_launch_args="--use-textbox-seed $a1111_sd_webui_launch_args"
                    ;;
                46)
                    a1111_sd_webui_launch_args="--disable-console-progressbars $a1111_sd_webui_launch_args"
                    ;;
                47)
                    a1111_sd_webui_launch_args="--enable-console-prompts $a1111_sd_webui_launch_args"
                    ;;
                48)
                    a1111_sd_webui_launch_args="--disable-safe-unpickle $a1111_sd_webui_launch_args"
                    ;;
                49)
                    a1111_sd_webui_launch_args="--api $a1111_sd_webui_launch_args"
                    ;;
                50)
                    a1111_sd_webui_launch_args="--api-log $a1111_sd_webui_launch_args"
                    ;;
                51)
                    a1111_sd_webui_launch_args="--nowebui $a1111_sd_webui_launch_args"
                    ;;
                52)
                    a1111_sd_webui_launch_args="--ui-debug-mode $a1111_sd_webui_launch_args"
                    ;;
                53)
                    a1111_sd_webui_launch_args="--administrator $a1111_sd_webui_launch_args"
                    ;;
                54)
                    a1111_sd_webui_launch_args="--disable-tls-verify $a1111_sd_webui_launch_args"
                    ;;
                55)
                    a1111_sd_webui_launch_args="--no-gradio-queue $a1111_sd_webui_launch_args"
                    ;;
                56)
                    a1111_sd_webui_launch_args="--skip-version-check $a1111_sd_webui_launch_args"
                    ;;
                57)
                    a1111_sd_webui_launch_args="--no-hashing $a1111_sd_webui_launch_args"
                    ;;
                58)
                    a1111_sd_webui_launch_args="--no-download-sd-model $a1111_sd_webui_launch_args"
                    ;;
                59)
                    a1111_sd_webui_launch_args="--add-stop-route $a1111_sd_webui_launch_args"
                    ;;
                60)
                    a1111_sd_webui_launch_args="--api-server-stop $a1111_sd_webui_launch_args"
                    ;;
                61)
                    a1111_sd_webui_launch_args="--disable-all-extensions $a1111_sd_webui_launch_args"
                    ;;
                62)
                    a1111_sd_webui_launch_args="--disable-extra-extensions $a1111_sd_webui_launch_args"
                    ;;
            esac
        done
    
        # 生成启动脚本
        term_sd_echo "设置启动参数> $a1111_sd_webui_launch_args"
        echo "launch.py $a1111_sd_webui_launch_args" > term-sd-launch.conf
    fi
}

# a1111-sd-webui启动界面
a1111_sd_webui_launch()
{
    local a1111_sd_webui_launch_dialog

    a1111_sd_webui_launch_dialog=$(
        dialog --erase-on-exit --title "Stable-Diffusion-WebUI管理" --backtitle "Stable-Diffusion-WebUI启动选项" --ok-label "确认" --cancel-label "取消" --menu "请选择启动Stable-Diffusion-WebUI/修改Stable-Diffusion-WebUI启动参数\n当前启动参数:\n$([ $venv_active = 0 ] && echo python || echo "$term_sd_python_path") $(cat ./term-sd-launch.conf)" 25 80 10 \
        "1" "启动" \
        "2" "选择预设启动参数" \
        "3" "自定义启动参数" \
        "4" "返回" \
        3>&1 1>&2 2>&3)
    
    case $a1111_sd_webui_launch_dialog in
        1)
            term_sd_launch
            a1111_sd_webui_launch
            ;;
        2)
            a1111_sd_webui_launch_args_setting
            a1111_sd_webui_launch
            ;;
        3)
            a1111_sd_webui_launch_args_revise
            a1111_sd_webui_launch
            ;;
    esac
}

# a1111-sd-webui启动参数修改
a1111_sd_webui_launch_args_revise()
{
    local a1111_sd_webui_launch_args

    a1111_sd_webui_launch_args=$(dialog --erase-on-exit --title "Stable-Diffusion-WebUI管理" --backtitle "Stable-Diffusion-WebUI自定义启动参数选项" --ok-label "确认" --cancel-label "取消" --inputbox "请输入Stable-Diffusion-WebUI启动参数" 25 80 "$(cat ./term-sd-launch.conf | awk '{sub("launch.py ","")}1')" 3>&1 1>&2 2>&3)

    if [ $? = 0 ];then
        term_sd_echo "设置启动参数> $a1111_sd_webui_launch_args"
        echo "launch.py $a1111_sd_webui_launch_args" > term-sd-launch.conf
    fi
}
