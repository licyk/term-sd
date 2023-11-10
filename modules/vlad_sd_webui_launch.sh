#!/bin/bash

# vlad-sd-webui启动参数生成
vlad_sd_webui_launch_args_setting()
{
    # 清空启动参数
    local vlad_sd_webui_launch_args_setting_dialog
    local vlad_sd_webui_launch_args

    # 展示启动参数选项
    vlad_sd_webui_launch_args_setting_dialog=$(
        dialog --erase-on-exit --title "Stable-Diffusion-WebUI管理" --backtitle "Vlad-Stable-Diffusion-WebUI启动参数选项" --separate-output --notags --ok-label "确认" --cancel-label "取消" --checklist "请选择Vlad-Stable-Diffusion-Webui启动参数,确认之后将覆盖原有启动参数配置" 25 80 10 \
        "1" "(medvram)启用显存优化,(显存<6g时推荐使用)" OFF \
        "2" "(lowvram)启用显存优化,(显存<4g时推荐使用)" OFF \
        "3" "(allow-code)允许从webui执行自定义脚本" OFF \
        "4" "(share)通过gradio共享" OFF \
        "5" "(insecure)启用扩展标签" OFF \
        "6" "(use-cpu)使用CPU进行生图" OFF \
        "7" "(listen)开放远程连接" OFF \
        "8" "(freeze)冻结webui设置" OFF \
        "9" "(autolaunch)启动webui完成后自动启动浏览器" ON \
        "10" "(docs)在/docs处挂载gradio文档" OFF \
        "11" "(api-only)在无webui界面时启用api" OFF \
        "12" "(api-log)启用输出所有api请求的日志记录" OFF \
        "13" "(tls-selfsign)使用自签名证书启用tls" OFF \
        "14" "(no-hashing)禁用模型hash检查" OFF \
        "15" "(no-metadata)禁用从模型中读取元数据" OFF \
        "16" "(no-download)禁用自动下载模型,即使模型路径无模型" OFF \
        "17" "(profile)运行分析器" OFF \
        "18" "(disable-queue)禁用gradio队列" OFF \
        "19" "(backend original)使用原始后端进行生图" OFF \
        "20" "(backend diffusers)使用diffusers后端进行生图" OFF \
        "21" "(debug)以debug模式运行安装程序" OFF \
        "22" "(reset)将webui主仓库重置为最新版本" OFF \
        "23" "(upgrade)将webui主仓库升级为最新版本" OFF \
        "24" "(requirements)强制检查依赖" OFF \
        "25" "(quick)仅运行启动模块" OFF \
        "26" "(use-directml)使用DirectML作为后端进行生图" OFF \
        "27" "(use-openvino)使用OpenVINO作为后端进行生图" OFF \
        "28" "(use-ipex)使用IPEX作为后端进行生图" OFF \
        "29" "(use-cuda)使用CUDA作为后端进行生图" ON \
        "30" "(use-rocm)使用ROCM作为后端进行生图" OFF \
        "31" "(use-xformers)使用xformers优化" ON \
        "32" "(skip-requirements)跳过依赖检查" OFF \
        "33" "(skip-extensions)跳过运行单个扩展安装程序" OFF \
        "34" "(skip-git)跳过所有git操作" OFF \
        "35" "(skip-torch)跳过pytorch检查" OFF \
        "36" "(skip-all)跳过运行所有检查" OFF \
        "37" "(experimental)允许使用不受支持版本的库" OFF \
        "38" "(reinstall)强制重新安装所有要求" OFF \
        "39" "(test)仅运行测试并退出" OFF \
        "40" "(ignore)忽略任何错误并尝试继续" OFF \
        "41" "(safe)在安全模式下运行,不使用用户扩展" OFF \
        3>&1 1>&2 2>&3)

    if [ $? = 0 ];then
        for i in $vlad_sd_webui_launch_args_setting_dialog; do
            case $i in
                1)
                    vlad_sd_webui_launch_args="--medvram $vlad_sd_webui_launch_args"
                    ;;
                2)
                    vlad_sd_webui_launch_args="--lowvram $vlad_sd_webui_launch_args"
                    ;;
                3)
                    vlad_sd_webui_launch_args="--allow-code $vlad_sd_webui_launch_args"
                    ;;
                4)
                    vlad_sd_webui_launch_args="--share $vlad_sd_webui_launch_args"
                    ;;
                5)
                    vlad_sd_webui_launch_args="--insecure $vlad_sd_webui_launch_args"
                    ;;
                6)
                    vlad_sd_webui_launch_args="--use-cpu all $vlad_sd_webui_launch_args"
                    ;;
                7)
                    vlad_sd_webui_launch_args="--listen $vlad_sd_webui_launch_args"
                    ;;
                8)
                    vlad_sd_webui_launch_args="--freeze $vlad_sd_webui_launch_args"
                    ;;
                9)
                    vlad_sd_webui_launch_args="--autolaunch $vlad_sd_webui_launch_args"
                    ;;
                10)
                    vlad_sd_webui_launch_args="--docs $vlad_sd_webui_launch_args"
                    ;;
                11)
                    vlad_sd_webui_launch_args="--api-only $vlad_sd_webui_launch_args"
                    ;;
                12)
                    vlad_sd_webui_launch_args="--api-log $vlad_sd_webui_launch_args"
                    ;;
                13)
                    vlad_sd_webui_launch_args="--tls-selfsign $vlad_sd_webui_launch_args"
                    ;;
                14)
                    vlad_sd_webui_launch_args="--no-hashing $vlad_sd_webui_launch_args"
                    ;;
                15)
                    vlad_sd_webui_launch_args="--no-metadata $vlad_sd_webui_launch_args"
                    ;;
                16)
                    vlad_sd_webui_launch_args="--no-download $vlad_sd_webui_launch_args"
                    ;;
                17)
                    vlad_sd_webui_launch_args="--profile $vlad_sd_webui_launch_args"
                    ;;
                18)
                    vlad_sd_webui_launch_args="--disable-queue $vlad_sd_webui_launch_args"
                    ;;
                19)
                    vlad_sd_webui_launch_args="--backend original $vlad_sd_webui_launch_args"
                    ;;
                20)
                    vlad_sd_webui_launch_args="--backend diffusers $vlad_sd_webui_launch_args"
                    ;;
                21)
                    vlad_sd_webui_launch_args="--debug $vlad_sd_webui_launch_args"
                    ;;
                22)
                    vlad_sd_webui_launch_args="--reset $vlad_sd_webui_launch_args"
                    ;;
                23)
                    vlad_sd_webui_launch_args="--upgrade $vlad_sd_webui_launch_args"
                    ;;
                24)
                    vlad_sd_webui_launch_args="--requirements $vlad_sd_webui_launch_args"
                    ;;
                25)
                    vlad_sd_webui_launch_args="--quick $vlad_sd_webui_launch_args"
                    ;;
                26)
                    vlad_sd_webui_launch_args="--use-directml $vlad_sd_webui_launch_args"
                    ;;
                27)
                    vlad_sd_webui_launch_args="--use-openvino $vlad_sd_webui_launch_args"
                    ;;
                28)
                    vlad_sd_webui_launch_args="--use-ipex $vlad_sd_webui_launch_args"
                    ;;
                29)
                    vlad_sd_webui_launch_args="--use-cuda $vlad_sd_webui_launch_args"
                    ;;
                30)
                    vlad_sd_webui_launch_args="--use-rocm $vlad_sd_webui_launch_args"
                    ;;
                31)
                    vlad_sd_webui_launch_args="--use-xformers $vlad_sd_webui_launch_args"
                    ;;
                32)
                    vlad_sd_webui_launch_args="--skip-requirements $vlad_sd_webui_launch_args"
                    ;;
                33)
                    vlad_sd_webui_launch_args="--skip-extensions $vlad_sd_webui_launch_args"
                    ;;
                34)
                    vlad_sd_webui_launch_args="--skip-git $vlad_sd_webui_launch_args"
                    ;;
                35)
                    vlad_sd_webui_launch_args="--skip-torch $vlad_sd_webui_launch_args"
                    ;;
                36)
                    vlad_sd_webui_launch_args="--skip-all $vlad_sd_webui_launch_args"
                    ;;
                37)
                    vlad_sd_webui_launch_args="--experimental $vlad_sd_webui_launch_args"
                    ;;
                38)
                    vlad_sd_webui_launch_args="--reinstall $vlad_sd_webui_launch_args"
                    ;;
                39)
                    vlad_sd_webui_launch_args="--test $vlad_sd_webui_launch_args"
                    ;;
                40)
                    vlad_sd_webui_launch_args="--ignore $vlad_sd_webui_launch_args"
                    ;;
                41)
                    vlad_sd_webui_launch_args="--safe $vlad_sd_webui_launch_args"
                    ;;
            esac
        done
    
        # 生成启动脚本
        term_sd_echo "设置启动参数> $vlad_sd_webui_launch_args"
        echo "launch.py $vlad_sd_webui_launch_args" > term-sd-launch.conf
    fi
}

# vlad-sd-webui启动界面
vlad_sd_webui_launch()
{
    local vlad_sd_webui_launch_dialog

    vlad_sd_webui_launch_dialog=$(dialog --erase-on-exit --title "Stable-Diffusion-WebUI管理" --backtitle "Vlad-Stable-Diffusion-WebUI启动选项" --ok-label "确认" --cancel-label "取消" --menu "请选择启动Vlad-Stable-Diffusion-WebUI/修改Vlad-Stable-Diffusion-WebUI启动参数\n当前启动参数:\n$([ $venv_active = 0 ] && echo python || echo "$term_sd_python_path") $(cat ./term-sd-launch.conf)" 25 80 10 \
        "1" "启动" \
        "2" "选择预设启动参数" \
        "3" "自定义启动参数" \
        "4" "返回" \
        3>&1 1>&2 2>&3)
    
    case $vlad_sd_webui_launch_dialog in
        1)
            term_sd_launch
            vlad_sd_webui_launch
            ;;
        2)
            vlad_sd_webui_launch_args_setting
            vlad_sd_webui_launch
            ;;
        3)
            vlad_sd_webui_launch_args_revise
            vlad_sd_webui_launch
            ;;
    esac
}

# vlad-sd-webui手动输入启动参数界面
vlad_sd_webui_launch_args_revise()
{
    local vlad_sd_webui_launch_args
    vlad_sd_webui_launch_args=$(dialog --erase-on-exit --title "Stable-Diffusion-WebUI管理" --backtitle "Vlad-Stable-Diffusion-WebUI自定义启动参数选项" --ok-label "确认" --cancel-label "取消" --inputbox "请输入Vlad-Stable-Diffusion-WebUI启动参数" 25 80 "$(cat ./term-sd-launch.conf | awk '{sub("launch.py ","")}1')" 3>&1 1>&2 2>&3)

    if [ $? = 0 ];then
        term_sd_echo "设置启动参数> $vlad_sd_webui_launch_args"
        echo "launch.py $vlad_sd_webui_launch_args" > term-sd-launch.conf 
    fi
}
