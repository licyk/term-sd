#!/bin/bash

#vlad-sd-webui启动参数生成
function generate_vlad_sd_webui_launch()
{
    #清空启动参数
    vlad_sd_webui_launch_option=""

    #展示启动参数选项
    vlad_sd_webui_launch_option_dialog=$(
        dialog --clear --title "A1111-SD-Webui管理" --backtitle "Vlad-SD-Webui启动参数选项" --separate-output --notags --ok-label "确认" --cancel-label "取消" --checklist "请选择Vlad-Stable-Diffusion-Webui启动参数,确认之后将覆盖原有启动参数配置" 25 80 10 \
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

    #根据菜单得到的数据设置变量
    if [ $? = 0 ];then
        for i in $vlad_sd_webui_launch_option_dialog; do
            case $i in
                1)
                    vlad_sd_webui_launch_option="--medvram $vlad_sd_webui_launch_option"
                    ;;
                2)
                    vlad_sd_webui_launch_option="--lowvram $vlad_sd_webui_launch_option"
                    ;;
                3)
                    vlad_sd_webui_launch_option="--allow-code $vlad_sd_webui_launch_option"
                    ;;
                4)
                    vlad_sd_webui_launch_option="--share $vlad_sd_webui_launch_option"
                    ;;
                5)
                    vlad_sd_webui_launch_option="--insecure $vlad_sd_webui_launch_option"
                    ;;
                6)
                    vlad_sd_webui_launch_option="--use-cpu all $vlad_sd_webui_launch_option"
                    ;;
                7)
                    vlad_sd_webui_launch_option="--listen $vlad_sd_webui_launch_option"
                    ;;
                8)
                    vlad_sd_webui_launch_option="--freeze $vlad_sd_webui_launch_option"
                    ;;
                9)
                    vlad_sd_webui_launch_option="--autolaunch $vlad_sd_webui_launch_option"
                    ;;
                10)
                    vlad_sd_webui_launch_option="--docs $vlad_sd_webui_launch_option"
                    ;;
                11)
                    vlad_sd_webui_launch_option="--api-only $vlad_sd_webui_launch_option"
                    ;;
                12)
                    vlad_sd_webui_launch_option="--api-log $vlad_sd_webui_launch_option"
                    ;;
                13)
                    vlad_sd_webui_launch_option="--tls-selfsign $vlad_sd_webui_launch_option"
                    ;;
                14)
                    vlad_sd_webui_launch_option="--no-hashing $vlad_sd_webui_launch_option"
                    ;;
                15)
                    vlad_sd_webui_launch_option="--no-metadata $vlad_sd_webui_launch_option"
                    ;;
                16)
                    vlad_sd_webui_launch_option="--no-download $vlad_sd_webui_launch_option"
                    ;;
                17)
                    vlad_sd_webui_launch_option="--profile $vlad_sd_webui_launch_option"
                    ;;
                18)
                    vlad_sd_webui_launch_option="--disable-queue $vlad_sd_webui_launch_option"
                    ;;
                19)
                    vlad_sd_webui_launch_option="--backend original $vlad_sd_webui_launch_option"
                    ;;
                20)
                    vlad_sd_webui_launch_option="--backend diffusers $vlad_sd_webui_launch_option"
                    ;;
                21)
                    vlad_sd_webui_launch_option="--debug $vlad_sd_webui_launch_option"
                    ;;
                22)
                    vlad_sd_webui_launch_option="--reset $vlad_sd_webui_launch_option"
                    ;;
                23)
                    vlad_sd_webui_launch_option="--upgrade $vlad_sd_webui_launch_option"
                    ;;
                24)
                    vlad_sd_webui_launch_option="--requirements $vlad_sd_webui_launch_option"
                    ;;
                25)
                    vlad_sd_webui_launch_option="--quick $vlad_sd_webui_launch_option"
                    ;;
                26)
                    vlad_sd_webui_launch_option="--use-directml $vlad_sd_webui_launch_option"
                    ;;
                27)
                    vlad_sd_webui_launch_option="--use-openvino $vlad_sd_webui_launch_option"
                    ;;
                28)
                    vlad_sd_webui_launch_option="--use-ipex $vlad_sd_webui_launch_option"
                    ;;
                29)
                    vlad_sd_webui_launch_option="--use-cuda $vlad_sd_webui_launch_option"
                    ;;
                30)
                    vlad_sd_webui_launch_option="--use-rocm $vlad_sd_webui_launch_option"
                    ;;
                31)
                    vlad_sd_webui_launch_option="--use-xformers $vlad_sd_webui_launch_option"
                    ;;
                32)
                    vlad_sd_webui_launch_option="--skip-requirements $vlad_sd_webui_launch_option"
                    ;;
                33)
                    vlad_sd_webui_launch_option="--skip-extensions $vlad_sd_webui_launch_option"
                    ;;
                34)
                    vlad_sd_webui_launch_option="--skip-git $vlad_sd_webui_launch_option"
                    ;;
                35)
                    vlad_sd_webui_launch_option="--skip-torch $vlad_sd_webui_launch_option"
                    ;;
                36)
                    vlad_sd_webui_launch_option="--skip-all $vlad_sd_webui_launch_option"
                    ;;
                37)
                    vlad_sd_webui_launch_option="--experimental $vlad_sd_webui_launch_option"
                    ;;
                38)
                    vlad_sd_webui_launch_option="--reinstall $vlad_sd_webui_launch_option"
                    ;;
                39)
                    vlad_sd_webui_launch_option="--test $vlad_sd_webui_launch_option"
                    ;;
                40)
                    vlad_sd_webui_launch_option="--ignore $vlad_sd_webui_launch_option"
                    ;;
                41)
                    vlad_sd_webui_launch_option="--safe $vlad_sd_webui_launch_option"
                    ;;
            esac
        done
    
        #生成启动脚本
        term_sd_notice "设置启动参数> $vlad_sd_webui_launch_option"
        echo "launch.py $vlad_sd_webui_launch_option" > term-sd-launch.conf
    fi
}

#vlad-sd-webui启动界面
function vlad_sd_webui_launch()
{
    vlad_sd_webui_launch_dialog=$(dialog --clear --title "A1111-SD-Webui管理" --backtitle "Vlad-SD-Webui启动选项" --ok-label "确认" --cancel-label "取消" --menu "请选择启动Vlad-SD-Webui/修改Vlad-SD-Webui启动参数\n当前启动参数:\n$([ $venv_active = 0 ] && echo python || echo "$term_sd_python_path") $(cat ./term-sd-launch.conf)" 25 80 10 \
        "1" "启动" \
        "2" "选择预设启动参数" \
        "3" "自定义启动参数" \
        "4" "返回" \
        3>&1 1>&2 2>&3)
    
    if [ $? = 0 ];then
        case $vlad_sd_webui_launch_dialog in
            1)
                term_sd_launch
                vlad_sd_webui_launch
                ;;
            2)
                generate_vlad_sd_webui_launch
                vlad_sd_webui_launch
                ;;
            3)
                vlad_sd_webui_manual_launch
                vlad_sd_webui_launch
                ;;
        esac
    fi
}

#vlad-sd-webui手动输入启动参数界面
function vlad_sd_webui_manual_launch()
{
    vlad_sd_webui_manual_launch_parameter=$(dialog --clear --title "A1111-SD-Webui管理" --backtitle "Vlad-SD-Webui自定义启动参数选项" --ok-label "确认" --cancel-label "取消" --inputbox "请输入Vlad-SD-Webui启动参数" 25 80 "$(cat ./term-sd-launch.conf | awk '{sub("launch.py ","")}1')" 3>&1 1>&2 2>&3)

    if [ $? = 0 ];then
        term_sd_notice "设置启动参数> $vlad_sd_webui_manual_launch_parameter"
        echo "launch.py $vlad_sd_webui_manual_launch_parameter" > term-sd-launch.conf 
    fi
}
