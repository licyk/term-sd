#!/bin/bash

#a1111-sd-webui启动脚本生成部分
function generate_a1111_sd_webui_launch()
{
    #清空启动参数
    a1111_sd_webui_launch_option=""

    #展示启动参数选项
    a1111_sd_webui_launch_option_dialog=$(
        dialog --clear --title "A1111-SD-Webui管理" --backtitle "A1111-SD-Webui启动参数选项" --separate-output --notags --ok-label "确认" --cancel-label "取消" --checklist "请选择A1111-Stable-Diffusion-Webui启动参数,确认之后将覆盖原有启动参数配置" 25 70 10 \
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

    #根据菜单得到的数据设置变量
    if [ $? = 0 ];then
        for i in $a1111_sd_webui_launch_option_dialog; do
            case $i in
                1)
                    a1111_sd_webui_launch_option="--update-all-extensions $a1111_sd_webui_launch_option"
                    ;;
                2)
                    a1111_sd_webui_launch_option="--skip-python-version-check $a1111_sd_webui_launch_option"
                    ;;
                3)
                    a1111_sd_webui_launch_option="--skip-torch-cuda-test $a1111_sd_webui_launch_option"
                    ;;
                4)
                    a1111_sd_webui_launch_option="--reinstall-xformers $a1111_sd_webui_launch_option"
                    ;;
                5)
                    a1111_sd_webui_launch_option="--reinstall-torch $a1111_sd_webui_launch_option"
                    ;;
                6)
                    a1111_sd_webui_launch_option="--update-check $a1111_sd_webui_launch_option"
                    ;;
                7)
                    a1111_sd_webui_launch_option="--test-server $a1111_sd_webui_launch_option"
                    ;;
                8)
                    a1111_sd_webui_launch_option="--log-startup $a1111_sd_webui_launch_option"
                    ;;
                9)
                    a1111_sd_webui_launch_option="--skip-prepare-environment $a1111_sd_webui_launch_option"
                    ;;
                10)
                    a1111_sd_webui_launch_option="--skip-install $a1111_sd_webui_launch_option"
                    ;;
                11)
                    a1111_sd_webui_launch_option="--dump-sysinfo $a1111_sd_webui_launch_option"
                    ;;
                12)
                    a1111_sd_webui_launch_option="--do-not-download-clip $a1111_sd_webui_launch_option"
                    ;;
                13)
                    a1111_sd_webui_launch_option="--no-half $a1111_sd_webui_launch_option"
                    ;;
                14)
                    a1111_sd_webui_launch_option="--no-half-vae $a1111_sd_webui_launch_option"
                    ;;
                15)
                    a1111_sd_webui_launch_option="--no-progressbar-hiding $a1111_sd_webui_launch_option"
                    ;;
                16)
                    a1111_sd_webui_launch_option="--allow-code $a1111_sd_webui_launch_option"
                    ;;
                17)
                    a1111_sd_webui_launch_option="--medvram $a1111_sd_webui_launch_option"
                    ;;
                18)
                    a1111_sd_webui_launch_option="--medvram-sdxl $a1111_sd_webui_launch_option"
                    ;;
                19)
                    a1111_sd_webui_launch_option="--lowvram $a1111_sd_webui_launch_option"
                    ;;
                20)
                    a1111_sd_webui_launch_option="--lowram $a1111_sd_webui_launch_option"
                    ;;
                21)
                    a1111_sd_webui_launch_option="--precision full $a1111_sd_webui_launch_option"
                    ;;
                22)
                    a1111_sd_webui_launch_option="--upcast-sampling $a1111_sd_webui_launch_option"
                    ;;
                23)
                    a1111_sd_webui_launch_option="--share $a1111_sd_webui_launch_option"
                    ;;
                24)
                    a1111_sd_webui_launch_option="--enable-insecure-extension-access $a1111_sd_webui_launch_option"
                    ;;
                25)
                    a1111_sd_webui_launch_option="--xformers $a1111_sd_webui_launch_option"
                    ;;
                26)
                    a1111_sd_webui_launch_option="--force-enable-xformers $a1111_sd_webui_launch_option"
                    ;;
                27)
                    a1111_sd_webui_launch_option="--xformers-flash-attention $a1111_sd_webui_launch_option"
                    ;;
                28)
                    a1111_sd_webui_launch_option="--opt-split-attention $a1111_sd_webui_launch_option"
                    ;;
                29)
                    a1111_sd_webui_launch_option="--opt-sub-quad-attention $a1111_sd_webui_launch_option"
                    ;;
                30)
                    a1111_sd_webui_launch_option="--opt-split-attention-invokeai $a1111_sd_webui_launch_option"
                    ;;
                31)
                    a1111_sd_webui_launch_option="--opt-split-attention-v1 $a1111_sd_webui_launch_option"
                    ;;
                32)
                    a1111_sd_webui_launch_option="--opt-sdp-attention $a1111_sd_webui_launch_option"
                    ;;
                33)
                    a1111_sd_webui_launch_option="--opt-sdp-no-mem-attention $a1111_sd_webui_launch_option"
                    ;;
                34)
                    a1111_sd_webui_launch_option="--disable-opt-split-attention $a1111_sd_webui_launch_option"
                    ;;
                35)
                    a1111_sd_webui_launch_option="--disable-nan-check $a1111_sd_webui_launch_option"
                    ;;
                36)
                    a1111_sd_webui_launch_option="--use-cpu all $a1111_sd_webui_launch_option"
                    ;;
                37)
                    a1111_sd_webui_launch_option="--disable-model-loading-ram-optimization $a1111_sd_webui_launch_option"
                    ;;
                38)
                    a1111_sd_webui_launch_option="--listen $a1111_sd_webui_launch_option"
                    ;;
                39)
                    a1111_sd_webui_launch_option="--hide-ui-dir-config $a1111_sd_webui_launch_option"
                    ;;
                40)
                    a1111_sd_webui_launch_option="--freeze-settings $a1111_sd_webui_launch_option"
                    ;;
                41)
                    a1111_sd_webui_launch_option="--gradio-debug $a1111_sd_webui_launch_option"
                    ;;
                42)
                    a1111_sd_webui_launch_option="--opt-channelslast $a1111_sd_webui_launch_option"
                    ;;
                43)
                    a1111_sd_webui_launch_option="--autolaunch $a1111_sd_webui_launch_option"
                    ;;
                44)
                    a1111_sd_webui_launch_option="--theme dark $a1111_sd_webui_launch_option"
                    ;;
                45)
                    a1111_sd_webui_launch_option="--use-textbox-seed $a1111_sd_webui_launch_option"
                    ;;
                46)
                    a1111_sd_webui_launch_option="--disable-console-progressbars $a1111_sd_webui_launch_option"
                    ;;
                47)
                    a1111_sd_webui_launch_option="--enable-console-prompts $a1111_sd_webui_launch_option"
                    ;;
                48)
                    a1111_sd_webui_launch_option="--disable-safe-unpickle $a1111_sd_webui_launch_option"
                    ;;
                49)
                    a1111_sd_webui_launch_option="--api $a1111_sd_webui_launch_option"
                    ;;
                50)
                    a1111_sd_webui_launch_option="--api-log $a1111_sd_webui_launch_option"
                    ;;
                51)
                    a1111_sd_webui_launch_option="--nowebui $a1111_sd_webui_launch_option"
                    ;;
                52)
                    a1111_sd_webui_launch_option="--ui-debug-mode $a1111_sd_webui_launch_option"
                    ;;
                53)
                    a1111_sd_webui_launch_option="--administrator $a1111_sd_webui_launch_option"
                    ;;
                54)
                    a1111_sd_webui_launch_option="--disable-tls-verify $a1111_sd_webui_launch_option"
                    ;;
                55)
                    a1111_sd_webui_launch_option="--no-gradio-queue $a1111_sd_webui_launch_option"
                    ;;
                56)
                    a1111_sd_webui_launch_option="--skip-version-check $a1111_sd_webui_launch_option"
                    ;;
                57)
                    a1111_sd_webui_launch_option="--no-hashing $a1111_sd_webui_launch_option"
                    ;;
                58)
                    a1111_sd_webui_launch_option="--no-download-sd-model $a1111_sd_webui_launch_option"
                    ;;
                59)
                    a1111_sd_webui_launch_option="--add-stop-route $a1111_sd_webui_launch_option"
                    ;;
                60)
                    a1111_sd_webui_launch_option="--api-server-stop $a1111_sd_webui_launch_option"
                    ;;
                61)
                    a1111_sd_webui_launch_option="--disable-all-extensions $a1111_sd_webui_launch_option"
                    ;;
                62)
                    a1111_sd_webui_launch_option="--disable-extra-extensions $a1111_sd_webui_launch_option"
                    ;;
            esac
        done
    
        #生成启动脚本
        term_sd_notice "设置启动参数> $a1111_sd_webui_launch_option"
        echo "launch.py $a1111_sd_webui_launch_option" > term-sd-launch.conf
    fi
}

#a1111-sd-webui启动界面
function a1111_sd_webui_launch()
{
    a1111_sd_webui_launch_dialog=$(
        dialog --clear --title "A1111-SD-Webui管理" --backtitle "A1111-SD-Webui启动选项" --ok-label "确认" --cancel-label "取消" --menu "请选择启动A1111-SD-Webui/修改A1111-SD-Webui启动参数\n当前启动参数:\n$([ $venv_active = 0 ] && echo python || echo "$term_sd_python_path") $(cat ./term-sd-launch.conf)" 25 70 10 \
        "1" "启动" \
        "2" "选择预设启动参数" \
        "3" "自定义启动参数" \
        "4" "返回" \
        3>&1 1>&2 2>&3)
    
    if [ $? = 0 ];then
        case $a1111_sd_webui_launch_dialog in
            1)
                term_sd_launch
                a1111_sd_webui_launch
                ;;
            2)
                generate_a1111_sd_webui_launch
                a1111_sd_webui_launch
                ;;
            3)
                a1111_sd_webui_manual_launch
                a1111_sd_webui_launch
                ;;
        esac
    fi
}

#a1111-sd-webui手动输入启动参数界面
function a1111_sd_webui_manual_launch()
{
    a1111_sd_webui_manual_launch_parameter=$(dialog --clear --title "A1111-SD-Webui管理" --backtitle "A1111-SD-Webui自定义启动参数选项" --ok-label "确认" --cancel-label "取消" --inputbox "请输入A1111-SD-Webui启动参数" 25 70 "$(cat ./term-sd-launch.conf | awk '{sub("launch.py ","")}1')" 3>&1 1>&2 2>&3)

    if [ $? = 0 ];then
        term_sd_notice "设置启动参数> $a1111_sd_webui_manual_launch_parameter"
        echo "launch.py $a1111_sd_webui_manual_launch_parameter" > term-sd-launch.conf
    fi
}
