#!/bin/bash

#sd-webui-directml启动参数生成功能
function generate_sd_webui_directml_launch()
{
    #清空启动参数
    sd_webui_directml_launch_option=""

    #展示启动参数选项
    sd_webui_directml_launch_option_dialog=$(
        dialog --clear --title "A1111-SD-Webui管理" --backtitle "SD-Webui-DirectML启动参数选项" --separate-output --notags --ok-label "确认" --cancel-label "取消" --checklist "请选择SD-Webui-DirectML启动参数,确认之后将覆盖原有启动参数配置" 25 80 10 \
        "1" "(update-all-extensions)启动时更新所有扩展" OFF \
        "2" "(skip-python-version-check)跳过检查python版本" OFF \
        "3" "(skip-torch-cuda-test)跳过CUDA可用性检查" ON \
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
        "25" "(xformers)尝试使用xformers优化" OFF \
        "26" "(force-enable-xformers)强制使用xformers优化" OFF \
        "27" "(xformers-flash-attention)使用xformers-flash优化(仅支持SD2.x以上)" OFF \
        "28" "(opt-split-attention)使用opt-split优化" OFF \
        "29" "(opt-sub-quad-attention)使用opt-sub-quad优化" OFF \
        "30" "(opt-split-attention-invokeai)使用opt-sub-quad-invokeai优化" OFF \
        "31" "(opt-split-attention-v1)使用opt-sub-quad-v1优化" OFF \
        "32" "(opt-sdp-attention)使用opt-sdp优化(仅限pytorch2.0以上)" OFF \
        "33" "(opt-sdp-no-mem-attention)使用无高效内存使用的opt-sdp优化" OFF \
        "34" "(disable-opt-split-attention)禁用opt-split优化" OFF \
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
        "52" "(onnx)使用onnx模型" OFF \
        "53" "(olive)使用olive模型" OFF \
        "54" "(backend cuda)使用CUDA作为后端进行生图" OFF \
        "55" "(backend rocm)使用ROCM作为后端进行生图" OFF \
        "56" "(backend directml)使用DirectML作为后端进行生图" ON \
        "57" "(ui-debug-mode)不加载模型启动webui(ui debug)" OFF \
        "58" "(administrator)启用管理员权限" OFF \
        "59" "(disable-tls-verify)禁用tls证书验证" OFF \
        "60" "(no-gradio-queue)禁用gradio队列" OFF \
        "61" "(skip-version-check)禁用pytorch,xformers版本检查" OFF \
        "62" "(no-hashing)禁用模型hash检查" OFF \
        "63" "(no-download-sd-model)禁用自动下载模型,即使模型路径无模型" OFF \
        "64" "(add-stop-route)添加/_stop路由以停止服务器" OFF \
        "65" "(api-server-stop)通过API启用服务器停止/重启/终止功能" OFF \
        "66" "(disable-all-extensions)禁用所有扩展运行" OFF \
        "67" "(disable-extra-extensions)禁用非内置的扩展运行" OFF \
        3>&1 1>&2 2>&3)

    #根据菜单得到的数据设置变量
    if [ $? = 0 ];then
        for i in $sd_webui_directml_launch_option_dialog; do
            case $i in
                1)
                    sd_webui_directml_launch_option="--update-all-extensions $sd_webui_directml_launch_option"
                    ;;
                2)
                    sd_webui_directml_launch_option="--skip-python-version-check $sd_webui_directml_launch_option"
                    ;;
                3)
                    sd_webui_directml_launch_option="--skip-torch-cuda-test $sd_webui_directml_launch_option"
                    ;;
                4)
                    sd_webui_directml_launch_option="--reinstall-xformers $sd_webui_directml_launch_option"
                    ;;
                5)
                    sd_webui_directml_launch_option="--reinstall-torch $sd_webui_directml_launch_option"
                    ;;
                6)
                    sd_webui_directml_launch_option="--update-check $sd_webui_directml_launch_option"
                    ;;
                7)
                    sd_webui_directml_launch_option="--test-server $sd_webui_directml_launch_option"
                    ;;
                8)
                    sd_webui_directml_launch_option="--log-startup $sd_webui_directml_launch_option"
                    ;;
                9)
                    sd_webui_directml_launch_option="--skip-prepare-environment $sd_webui_directml_launch_option"
                    ;;
                10)
                    sd_webui_directml_launch_option="--skip-install $sd_webui_directml_launch_option"
                    ;;
                11)
                    sd_webui_directml_launch_option="--dump-sysinfo $sd_webui_directml_launch_option"
                    ;;
                12)
                    sd_webui_directml_launch_option="--do-not-download-clip $sd_webui_directml_launch_option"
                    ;;
                13)
                    sd_webui_directml_launch_option="--no-half $sd_webui_directml_launch_option"
                    ;;
                14)
                    sd_webui_directml_launch_option="--no-half-vae $sd_webui_directml_launch_option"
                    ;;
                15)
                    sd_webui_directml_launch_option="--no-progressbar-hiding $sd_webui_directml_launch_option"
                    ;;
                16)
                    sd_webui_directml_launch_option="--allow-code $sd_webui_directml_launch_option"
                    ;;
                17)
                    sd_webui_directml_launch_option="--medvram $sd_webui_directml_launch_option"
                    ;;
                18)
                    sd_webui_directml_launch_option="--medvram-sdxl $sd_webui_directml_launch_option"
                    ;;
                19)
                    sd_webui_directml_launch_option="--lowvram $sd_webui_directml_launch_option"
                    ;;
                20)
                    sd_webui_directml_launch_option="--lowram $sd_webui_directml_launch_option"
                    ;;
                21)
                    sd_webui_directml_launch_option="--precision full $sd_webui_directml_launch_option"
                    ;;
                22)
                    sd_webui_directml_launch_option="--upcast-sampling $sd_webui_directml_launch_option"
                    ;;
                23)
                    sd_webui_directml_launch_option="--share $sd_webui_directml_launch_option"
                    ;;
                24)
                    sd_webui_directml_launch_option="--enable-insecure-extension-access $sd_webui_directml_launch_option"
                    ;;
                25)
                    sd_webui_directml_launch_option="--xformers $sd_webui_directml_launch_option"
                    ;;
                26)
                    sd_webui_directml_launch_option="--force-enable-xformers $sd_webui_directml_launch_option"
                    ;;
                27)
                    sd_webui_directml_launch_option="--xformers-flash-attention $sd_webui_directml_launch_option"
                    ;;
                28)
                    sd_webui_directml_launch_option="--opt-split-attention $sd_webui_directml_launch_option"
                    ;;
                29)
                    sd_webui_directml_launch_option="--opt-sub-quad-attention $sd_webui_directml_launch_option"
                    ;;
                30)
                    sd_webui_directml_launch_option="--opt-split-attention-invokeai $sd_webui_directml_launch_option"
                    ;;
                31)
                    sd_webui_directml_launch_option="--opt-split-attention-v1 $sd_webui_directml_launch_option"
                    ;;
                32)
                    sd_webui_directml_launch_option="--opt-sdp-attention $sd_webui_directml_launch_option"
                    ;;
                33)
                    sd_webui_directml_launch_option="--opt-sdp-no-mem-attention $sd_webui_directml_launch_option"
                    ;;
                34)
                    sd_webui_directml_launch_option="--disable-opt-split-attention $sd_webui_directml_launch_option"
                    ;;
                35)
                    sd_webui_directml_launch_option="--disable-nan-check $sd_webui_directml_launch_option"
                    ;;
                36)
                    sd_webui_directml_launch_option="--use-cpu all $sd_webui_directml_launch_option"
                    ;;
                37)
                    sd_webui_directml_launch_option="--disable-model-loading-ram-optimization $sd_webui_directml_launch_option"
                    ;;
                38)
                    sd_webui_directml_launch_option="--listen $sd_webui_directml_launch_option"
                    ;;
                39)
                    sd_webui_directml_launch_option="--hide-ui-dir-config $sd_webui_directml_launch_option"
                    ;;
                40)
                    sd_webui_directml_launch_option="--freeze-settings $sd_webui_directml_launch_option"
                    ;;
                41)
                    sd_webui_directml_launch_option="--gradio-debug $sd_webui_directml_launch_option"
                    ;;
                42)
                    sd_webui_directml_launch_option="--opt-channelslast $sd_webui_directml_launch_option"
                    ;;
                43)
                    sd_webui_directml_launch_option="--autolaunch $sd_webui_directml_launch_option"
                    ;;
                44)
                    sd_webui_directml_launch_option="--theme dark $sd_webui_directml_launch_option"
                    ;;
                45)
                    sd_webui_directml_launch_option="--use-textbox-seed $sd_webui_directml_launch_option"
                    ;;
                46)
                    sd_webui_directml_launch_option="--disable-console-progressbars $sd_webui_directml_launch_option"
                    ;;
                47)
                    sd_webui_directml_launch_option="--enable-console-prompts $sd_webui_directml_launch_option"
                    ;;
                48)
                    sd_webui_directml_launch_option="--disable-safe-unpickle $sd_webui_directml_launch_option"
                    ;;
                49)
                    sd_webui_directml_launch_option="--api $sd_webui_directml_launch_option"
                    ;;
                50)
                    sd_webui_directml_launch_option="--api-log $sd_webui_directml_launch_option"
                    ;;
                51)
                    sd_webui_directml_launch_option="--nowebui $sd_webui_directml_launch_option"
                    ;;
                52)
                    sd_webui_directml_launch_option="--onnx $sd_webui_directml_launch_option"
                    ;;
                53)
                    sd_webui_directml_launch_option="--olive $sd_webui_directml_launch_option"
                    ;;
                54)
                    sd_webui_directml_launch_option="--backend cuda $sd_webui_directml_launch_option"
                    ;;
                55)
                    sd_webui_directml_launch_option="--backend rocm $sd_webui_directml_launch_option"
                    ;;
                56)
                    sd_webui_directml_launch_option="--backend directml $sd_webui_directml_launch_option"
                    ;;
                57)
                    sd_webui_directml_launch_option="--ui-debug-mode $sd_webui_directml_launch_option"
                    ;;
                58)
                    sd_webui_directml_launch_option="--administrator $sd_webui_directml_launch_option"
                    ;;
                59)
                    sd_webui_directml_launch_option="--disable-tls-verify $sd_webui_directml_launch_option"
                    ;;
                60)
                    sd_webui_directml_launch_option="--no-gradio-queue $sd_webui_directml_launch_option"
                    ;;
                61)
                    sd_webui_directml_launch_option="--skip-version-check $sd_webui_directml_launch_option"
                    ;;
                62)
                    sd_webui_directml_launch_option="--no-hashing $sd_webui_directml_launch_option"
                    ;;
                63)
                    sd_webui_directml_launch_option="--no-download-sd-model $sd_webui_directml_launch_option"
                    ;;
                64)
                    sd_webui_directml_launch_option="--add-stop-route $sd_webui_directml_launch_option"
                    ;;
                65)
                    sd_webui_directml_launch_option="--api-server-stop $sd_webui_directml_launch_option"
                    ;;
                66)
                    sd_webui_directml_launch_option="--disable-all-extensions $sd_webui_directml_launch_option"
                    ;;
                67)
                    sd_webui_directml_launch_option="--disable-extra-extensions $sd_webui_directml_launch_option"
                    ;;
            esac
        done
    
        #生成启动脚本
        term_sd_notice "设置启动参数> $sd_webui_directml_launch_option"
        echo "launch.py $sd_webui_directml_launch_option" > term-sd-launch.conf
    fi
}

#a1111-sd-webui启动界面
function sd_webui_directml_launch()
{
    sd_webui_directml_launch_dialog=$(dialog --clear --title "A1111-SD-Webui管理" --backtitle "SD-Webui-DirectML启动选项" --ok-label "确认" --cancel-label "取消" --menu "请选择启动SD-Webui-DirectML/修改SD-Webui-DirectML启动参数\n当前启动参数:\n$([ $venv_active = 0 ] && echo python || echo "$term_sd_python_path") $(cat ./term-sd-launch.conf)" 25 80 10 \
        "1" "启动" \
        "2" "选择预设启动参数" \
        "3" "自定义启动参数" \
        "4" "返回" \
        3>&1 1>&2 2>&3)
    
    if [ $? = 0 ];then
        case $sd_webui_directml_launch_dialog in
            1)
                term_sd_launch
                sd_webui_directml_launch
                ;;
            2)
                generate_sd_webui_directml_launch
                sd_webui_directml_launch
                ;;
            3)
                sd_webui_directml_manual_launch
                sd_webui_directml_launch
                ;;
        esac
    fi
}

#a1111-sd-webui手动输入启动参数界面
function sd_webui_directml_manual_launch()
{
    sd_webui_directml_manual_launch_parameter=$(dialog --clear --title "A1111-SD-Webui管理" --backtitle "SD-Webui-DirectML自定义启动参数选项" --ok-label "确认" --cancel-label "取消" --inputbox "请输入SD-Webui-DirectML启动参数" 25 80 "$(cat ./term-sd-launch.conf | awk '{sub("launch.py ","")}1')" 3>&1 1>&2 2>&3)

    if [ $? = 0 ];then
        term_sd_notice "设置启动参数> $sd_webui_directml_manual_launch_parameter"
        echo "launch.py $sd_webui_directml_manual_launch_parameter" > term-sd-launch.conf 
    fi
}
