#!/bin/bash
echo "######## ######## ########  ##     ##     ######  ########  "
echo "   ##    ##       ##     ## ###   ###    ##    ## ##     ## "
echo "   ##    ##       ##     ## #### ####    ##       ##     ## "
echo "   ##    ######   ########  ## ### ##     ######  ##     ## "
echo "   ##    ##       ##   ##   ##     ##          ## ##     ## "
echo "   ##    ##       ##    ##  ##     ##    ##    ## ##     ## "
echo "   ##    ######## ##     ## ##     ##     ######  ########  "
#使用figlet制作

echo "Term-SD初始化中......"
###############################################################################

#主界面部分

#设置启动时脚本路径
start_path=$(pwd)
#设置虚拟环境
venv_active="enable"
venv_info="启用"

#主界面
function mainmenu()
{
    cd "$start_path" #回到最初路径
    exit_venv 2> /dev/null #确保进行下一步操作前已退出其他虚拟环境
    mainmenu_select=$(
        dialog --clear --title "Term-SD" --yes-label "确认" --no-label "取消" --menu "请使用方向键和回车键进行操作\n当前目录可用空间:$(df ./ -h |awk 'NR==2'|awk -F ' ' ' {print $4} ')\n当前虚拟环境状态:"$venv_info"" 20 60 10 \
        "0" "venv虚拟环境" \
        "1" "AUTOMATIC1111-stable-diffusion-webui" \
        "2" "ComfyUI" \
        "3" "InvokeAI" \
        "4" "lora-scripts" \
        "5" "更新脚本" \
        "6" "扩展脚本" \
        "7" "pip镜像源" \
        "8" "pip缓存清理" \
        "9" "关于" \
        "10" "退出" \
        3>&1 1>&2 2>&3 )

    if [ $? = 0  ];then #选择确认
        if [ "${mainmenu_select}" == '0' ]; then #选择venv虚拟环境
            venv_option
        elif [ "${mainmenu_select}" == '1' ]; then #选择AUTOMATIC1111-stable-diffusion-webui
            a1111_sd_webui_option
        elif [ "${mainmenu_select}" == '2' ]; then #选择ComfyUI
            comfyui_option
        elif [ "${mainmenu_select}" == '3' ]; then #选择InvokeAI
            invokeai_option
        elif [ "${mainmenu_select}" == '4' ]; then #选择lora-scripts
            lora_scripts_option
        elif [ "${mainmenu_select}" == '5' ]; then #选择更新脚本
            update_option
        elif [ "${mainmenu_select}" == '6' ]; then #选择扩展脚本
            term_sd_extension
        elif [ "${mainmenu_select}" == '7' ]; then #选择pip镜像源
            set_proxy_option
        elif [ "${mainmenu_select}" == '8' ]; then #选择pip缓存清理
            pip_cache_clean
        elif [ "${mainmenu_select}" == '9' ]; then #选择关于
            info_option
        elif [ "${mainmenu_select}" == '10' ]; then #选择退出
            exit
        fi
    else #选择取消
        exit
    fi
}

#a1111_sd_webui_option选项
function a1111_sd_webui_option()
{
    cd "$start_path" #回到最初路径
    exit_venv 2> /dev/null #确保进行下一步操作前已退出其他虚拟环境
    if [ -d "stable-diffusion-webui" ];then #找到stable-diffusion-webui目录
        cd stable-diffusion-webui
        final_a1111_sd_webui_option=$(
            dialog --clear --title "A1111-SD-Webui管理" --yes-label "确认" --no-label "取消" --menu "请使用方向键和回车键对A1111-Stable-Diffusion-Webui进行操作\n当前目录可用空间:$(df ./ -h |awk 'NR==2'|awk -F ' ' ' {print $4} ')" 20 60 10 \
            "1" "更新" \
            "2" "卸载" \
            "3" "修复更新" \
            "4" "管理插件" \
            "5" "切换版本" \
            "6" "启动" \
            "7" "重新安装" \
            "8" "重新安装pytorch" \
            "9" "重新生成venv虚拟环境" \
            "10" "返回" \
            3>&1 1>&2 2>&3)

        if [ $? = 0 ];then
            if [ "${final_a1111_sd_webui_option}" == '1' ]; then
                echo "更新A1111-Stable-Diffusion-Webui中"
                git pull
                if [ $? = "0" ];then
                    dialog --clear --title "A1111-SD-Webui管理" --msgbox "更新成功" 20 60
                else
                    dialog --clear --title "A1111-SD-Webui管理" --msgbox "更新失败" 20 60
                fi
                a1111_sd_webui_option
            elif [ "${final_a1111_sd_webui_option}" == '2' ]; then
                if (dialog --clear --title "删除选项" --yesno "是否删除A1111-Stable-Diffusion-Webui" 20 60) then
                    echo "删除A1111-Stable-Diffusion-Webui中"
                    exit_venv
                    cd ..
                    rm -rfv ./stable-diffusion-webui
                else
                    a1111_sd_webui_option
                fi
            elif [ "${final_a1111_sd_webui_option}" == '3' ]; then
                echo "修复更新中"
                git checkout master
                git reset --hard HEAD
                a1111_sd_webui_option
            elif [ "${final_a1111_sd_webui_option}" == '4' ]; then
                cd extensions
                extension_methon
                a1111_sd_webui_option
            elif [ "${final_a1111_sd_webui_option}" == '5' ]; then
                git_checkout_manager
                a1111_sd_webui_option
            elif [ "${final_a1111_sd_webui_option}" == '6' ]; then
                if [ -f "./term-sd-launch.conf" ]; then #找到启动脚本
                    if (dialog --clear --title "stable-diffusion-webui管理" --yes-label "启动" --no-label "修改参数" --yesno "选择直接启动/修改启动参数" 20 60) then
                        term_sd_launch
                        a1111_sd_webui_option
                    else #修改启动脚本
                        generate_a1111_sd_webui_launch
                        term_sd_launch
                        a1111_sd_webui_option
                    fi
                else #找不到启动脚本,并启动脚本生成界面
                generate_a1111_sd_webui_launch
                term_sd_launch
                a1111_sd_webui_option
                fi
            elif [ "${final_a1111_sd_webui_option}" == '7' ]; then
                if (dialog --clear --title "A1111-SD-Webui管理" --yesno "是否重新安装A1111-Stable-Diffusion-Webui" 20 60) then
                cd "$start_path"
                exit_venv
                process_install_a1111_sd_webui
                a1111_sd_webui_option
                fi
            elif [ "${final_a1111_sd_webui_option}" == '8' ]; then
                pytorch_reinstall
                a1111_sd_webui_option
            elif [ "${final_a1111_sd_webui_option}" == '9' ]; then
                venv_generate
                a1111_sd_webui_option
            elif [ "${final_a1111_sd_webui_option}" == '10' ]; then
                mainmenu #回到主界面
            fi
        fi
    else #找不到stable-diffusion-webui目录
        if (dialog --clear --title "A1111-SD-Webui管理" --yesno "检测到当前未安装A1111-Stable-Diffusion-Webui,是否进行安装" 20 60) then
            process_install_a1111_sd_webui
            a1111_sd_webui_option
        fi
    fi
    mainmenu #处理完后返回主界面
}


#comfyui选项
function comfyui_option()
{
    cd "$start_path" #回到最初路径
    exit_venv 2> /dev/null #确保进行下一步操作前已退出其他虚拟环境
    if [ -d "ComfyUI" ];then
        cd ComfyUI
        final_comfyui_option=$(
            dialog --clear --title "ComfyUI管理" --yes-label "确认" --no-label "取消" --menu "请使用方向键和回车键对ComfyUI进行操作\n当前目录可用空间:$(df ./ -h |awk 'NR==2'|awk -F ' ' ' {print $4} ')" 20 60 10 \
            "1" "更新" \
            "2" "卸载" \
            "3" "修复更新" \
            "4" "自定义节点管理" \
            "5" "插件管理" \
            "6" "切换版本" \
            "7" "启动" \
            "8" "重新安装" \
            "9" "重新安装pytorch" \
            "10" "重新生成venv虚拟环境" \
            "11" "返回" \
            3>&1 1>&2 2>&3)

        if [ $? = 0 ];then
            if [ "${final_comfyui_option}" == '1' ]; then
                echo "更新ComfyUI中"
                git pull
                if [ $? = "0" ];then
                    dialog --clear --title "ComfyUI管理" --msgbox "更新成功" 20 60
                else
                    dialog --clear --title "ComfyUI管理" --msgbox "更新失败" 20 60
                fi
                comfyui_option
            elif [ "${final_comfyui_option}" == '2' ]; then
                if (dialog --clear --title "删除选项" --yes-label "是" --no-label "否" --yesno "是否删除ComfyUI" 20 60) then
                    echo "删除ComfyUI中"
                    exit_venv
                    cd ..
                    rm -rfv ./ComfyUI
                else
                    comfyui_option
                fi
            elif [ "${final_comfyui_option}" == '3' ]; then
                echo "修复更新中"
                git checkout master
                git reset --hard HEAD
                comfyui_option
            elif [ "${final_comfyui_option}" == '4' ]; then
                cd custom_nodes
                comfyui_custom_node_methon
                comfyui_option
            elif [ "${final_comfyui_option}" == '5' ]; then
                cd web/extensions
                comfyui_extension_methon
                comfyui_option
            elif [ "${final_comfyui_option}" == '6' ]; then
                git_checkout_manager
                comfyui_option
            elif [ "${final_comfyui_option}" == '7' ]; then
                if [ -f "./term-sd-launch.conf" ]; then #找到启动脚本
                    if (dialog --clear --title "ComfyUI启动选择" --yes-label "启动" --no-label "修改参数" --yesno "选择直接启动/修改启动参数" 20 60) then
                        term_sd_launch
                        comfyui_option
                    else
                        generate_comfyui_launch
                        term_sd_launch
                        comfyui_option
                    fi
                else #找不到启动脚本,并启动脚本生成界面
                    generate_comfyui_launch
                    term_sd_launch
                    comfyui_option
                fi    
            elif [ "${final_comfyui_option}" == '8' ]; then
                if (dialog --clear --title "ComfyUI管理" --yesno "是否重新安装ComfyUI" 20 60) then
                    cd "$start_path"
                    exit_venv
                    process_install_comfyui
                    comfyui_option
                fi
            elif [ "${final_comfyui_option}" == '9' ]; then
                pytorch_reinstall
                comfyui_option
            elif [ "${final_comfyui_option}" == '10' ]; then
                venv_generate
                comfyui_option
            elif [ "${final_comfyui_option}" == '11' ]; then
                mainmenu #回到主界面
            fi
        fi
    else
        if (dialog --clear --title "ComfyUI管理" --yesno "检测到当前未安装ComfyUI,是否进行安装" 20 60) then
            process_install_comfyui
            comfyui_option
        fi
    fi
    mainmenu #处理完后返回主界面界面
}

#InvokeAI选项
function invokeai_option()
{
    cd "$start_path" #回到最初路径
    exit_venv 2> /dev/null #确保进行下一步操作前已退出其他虚拟环境
    if [ -d "InvokeAI" ];then #找到invokeai文件夹
        cd InvokeAI
        venv_generate #尝试重新生成虚拟环境,解决因为路径移动导致虚拟环境无法进入，然后检测不到invokeai
        enter_venv #进入环境
        if which invokeai 2> /dev/null ;then #查找环境中有没有invokeai
            final_invokeai_option=$(
                dialog --clear --title "InvokeAI管理" --yes-label "确认" --no-label "取消" --menu "请使用方向键和回车键对InvokeAI进行操作\n当前目录可用空间:$(df ./ -h |awk 'NR==2'|awk -F ' ' ' {print $4} ')" 20 60 10 \
                "1" "更新" \
                "2" "卸载" \
                "3" "启动" \
                "4" "重新安装" \
                "5" "重新安装pytorch" \
                "6" "返回" \
                3>&1 1>&2 2>&3)

            if [ $? = 0 ];then
                if [ "${final_invokeai_option}" == '1' ]; then
                    proxy_option #代理选择
                    pip_install_methon #安装方式选择
                    final_install_check #安装前确认
                    echo "更新InvokeAI中"
                    pip install $python_proxy $extra_python_proxy $force_pip $pip_install_methon_select --upgrade invokeai --default-timeout=100 --retries 5
                    if [ $? = "0" ];then
                        dialog --clear --title "InvokeAI管理" --msgbox "更新成功" 20 60
                    else
                        dialog --clear --title "InvokeAI管理" --msgbox "更新失败" 20 60
                    fi
                    invokeai_option
                elif [ "${final_invokeai_option}" == '2' ]; then
                    if (dialog --clear --title "删除选项" --yes-label "是" --no-label "否" --yesno "是否删除InvokeAI" 20 60) then
                        echo "删除InvokeAI中"
                        exit_venv
                        cd ..
                        rm -rfv ./InvokeAI
                    else
                        invokeai_option
                    fi
                elif [ "${final_invokeai_option}" == '3' ]; then
                    generate_invokeai_launch
                    invokeai_option
                elif [ "${final_invokeai_option}" == '4' ]; then
                    if (dialog --clear --title "InvokeAI管理" --yesno "是否重新安装InvokeAI" 20 60) then
                        cd "$start_path"
                        exit_venv
                        process_install_invokeai
                        invokeai_option
                    fi
                elif [ "${final_invokeai_option}" == '5' ]; then
                    pytorch_reinstall
                    invokeai_option
                elif [ "${final_invokeai_option}" == '6' ]; then
                    mainmenu #回到主界面
                fi
            fi
        else 
            if (dialog --clear --title "InvokeAI管理" --yesno "检测到当前未安装InvokeAI,是否进行安装" 20 60) then
                cd "$start_path"
                process_install_invokeai
                invokeai_option
            fi
        fi
    else
        if (dialog --clear --title "InvokeAI管理" --yesno "检测到当前未安装InvokeAI,是否进行安装" 20 60) then
          process_install_invokeai
          invokeai_option
        fi
    fi
    mainmenu #处理完后返回主界面界面
}

#lora-scripts选项
function lora_scripts_option()
{
    cd "$start_path" #回到最初路径
    exit_venv 2> /dev/null #确保进行下一步操作前已退出其他虚拟环境
    if [ -d "./lora-scripts" ];then
        cd lora-scripts
        final_lora_scripts_option=$(
            dialog --clear --title "lora-scripts管理" --yes-label "确认" --no-label "取消" --menu "请使用方向键和回车键对lora-scripts进行操作\n当前目录可用空间:$(df ./ -h |awk 'NR==2'|awk -F ' ' ' {print $4} ')" 20 60 10 \
            "1" "更新" \
            "2" "卸载" \
            "3" "修复更新" \
            "4" "版本切换" \
            "5" "启动" \
            "6" "重新安装" \
            "7" "重新安装pytorch" \
            "8" "重新生成venv虚拟环境" \
            "9" "返回" \
            3>&1 1>&2 2>&3)

        if [ $? = 0 ];then
            if [ "${final_lora_scripts_option}" == '1' ]; then
                echo "更新lora-scripts中"
                test_num=1
                git pull
                if [ $? = 0 ];then
                    test_num=0
                fi
                git pull ./sd-scripts
                git pull ./frontend
                git submodule init
                git submodule update #版本不对应，有时会出现各种奇怪的报错
                git submodule
                if [ $test_num = "0" ];then
                    dialog --clear --title "lora-scripts管理" --msgbox "更新成功" 20 60
                else
                    dialog --clear --title "lora-scripts管理" --msgbox "更新失败" 20 60
                fi
                lora_scripts_option
            elif [ "${final_lora_scripts_option}" == '2' ]; then
                if (dialog --clear --title "删除选项" --yes-label "是" --no-label "否" --yesno "是否删除lora-scripts" 20 60) then
                    echo "删除lora-scripts中"
                    exit_venv
                    cd ..
                    rm -rfv ./lora-scripts
                else
                    lora_scripts_option
                fi
            elif [ "${final_lora_scripts_option}" == '3' ]; then
                echo "修复更新中"
                git checkout main
                git reset --hard HEAD #修复lora-scripts
                cd ./sd-scripts
                git checkout main
                git reset --hard HEAD #修复kohya-ss训练模块
                cd ./../frontend
                git checkout master
                git reset --hard HEAD #修复lora-gui-dist
                cd ..
                git submodule init
                git submodule update
                git submodule
                lora_scripts_option
            elif [ "${final_lora_scripts_option}" == '4' ]; then
                git_checkout_manager
                cd "$start_path/lora-scripts"
                git submodule init
                git submodule update
                git submodule
                lora_scripts_option
            elif [ "${final_lora_scripts_option}" == '5' ]; then
                enter_venv
                export HF_HOME=huggingface
                export PYTHONUTF8=1
                if [ $(uname -o) = "Msys" ];then #为了兼容windows系统
                    python ./gui.py
                else
                    python3 ./gui.py
                fi
                lora_scripts_option
            elif [ "${final_lora_scripts_option}" == '6' ]; then
                if (dialog --clear --title "lora-scripts管理" --yesno "是否重新安装lora_scripts" 20 60) then
                    cd "$start_path"
                    exit_venv
                    process_install_lora_scripts
                    lora_scripts_option
                fi
            elif [ "${final_lora_scripts_option}" == '7' ]; then
                pytorch_reinstall
                lora_scripts_option
            elif [ "${final_lora_scripts_option}" == '8' ]; then
                venv_generate
                lora_scripts_option
            elif [ "${final_lora_scripts_option}" == '9' ]; then
                mainmenu #回到主界面
            fi
        fi
    else
        if (dialog --clear --title "lora-scripts管理" --yesno "检测到当前未安装lora_scripts,是否进行安装" 20 60) then
            process_install_lora_scripts
            lora_scripts_option
        fi
    fi
    mainmenu #处理完后返回主界面界面
}

###############################################################################

#启动脚本生成部分

#a1111-sd-webui启动脚本生成部分
function generate_a1111_sd_webui_launch()
{
    #清空启动参数
    a1111_launch_option_1=""
    a1111_launch_option_2=""
    a1111_launch_option_3=""
    a1111_launch_option_4=""
    a1111_launch_option_5=""
    a1111_launch_option_6=""
    a1111_launch_option_7=""
    a1111_launch_option_8=""
    a1111_launch_option_9=""
    a1111_launch_option_10=""
    a1111_launch_option_11=""
    a1111_launch_option_12=""
    a1111_launch_option_13=""
    a1111_launch_option_14=""
    a1111_launch_option_15=""
    a1111_launch_option_16=""
    a1111_launch_option_17=""
    a1111_launch_option_18=""
    a1111_launch_option_19=""
    a1111_launch_option_20=""
    a1111_launch_option_21=""
    a1111_launch_option_22=""
    a1111_launch_option_23=""
    a1111_launch_option_24=""
    a1111_launch_option_25=""
    a1111_launch_option_26=""
    a1111_launch_option_27=""
    a1111_launch_option_28=""

    #展示启动参数选项
    final_generate_a1111_sd_webui_launch_=$(
        dialog --clear --separate-output --notags --yes-label "确认" --no-cancel --checklist "A1111-Stable-Diffusion-Webui启动参数选择" 20 60 10 \
        "1" "skip-torch-cuda-test" OFF \
        "2" "no-half" OFF \
        "3" "no-half-vae" OFF \
        "4" "medvram" OFF \
        "5" "lowvram" OFF \
        "6" "lowram" OFF \
        "7" "enable-insecure-extension-access" OFF \
        "8" "theme dark" ON \
        "9" "autolaunch" ON \
        "10" "xformers" ON \
        "11" "listen" OFF \
        "12" "precision full" OFF \
        "13" "force-enable-xformers" OFF \
        "14" "xformers-flash-attention" OFF \
        "15" "api" OFF \
        "16" "ui-debug-mode" OFF \
        "17" "share" OFF \
        "18" "opt-split-attention-invokeai" OFF \
        "19" "opt-split-attention-v1" OFF \
        "20" "opt-sdp-attention" OFF \
        "21" "opt-sdp-no-mem-attention" OFF \
        "22" "disable-opt-split-attention" OFF \
        "23" "use-cpu all" OFF \
        "24" "opt-channelslast" OFF \
        "25" "no-gradio-queue" OFF \
        "26" "no-hashing" OFF \
        "27" "backend directml" OFF \
        "28" "opt-sub-quad-attention" OFF \
        3>&1 1>&2 2>&3)

    #根据菜单得到的数据设置变量
    if [ $? = 0 ];then
        if [ ! -z "$final_generate_a1111_sd_webui_launch_" ]; then
            for final_generate_a1111_sd_webui_launch in $final_generate_a1111_sd_webui_launch_; do
            case "$final_generate_a1111_sd_webui_launch" in
            "1")
            a1111_launch_option_1="--skip-torch-cuda-test"
            ;;
            "2")
            a1111_launch_option_2="--no-half"
            ;;
            "3")
            a1111_launch_option_3="--no-half-vae"
            ;;
            "4")
            a1111_launch_option_4="--medvram"
            ;;
            "5")
            a1111_launch_option_5="--lowvram"
            ;;
            "6")
            a1111_launch_option_6="--lowram"
            ;;
            "7")
            a1111_launch_option_7="--enable-insecure-extension-access"
            ;;
            "8")
            a1111_launch_option_8="--theme dark"
            ;;
            "9")
            a1111_launch_option_9="--autolaunch"
            ;;
            "10")
            a1111_launch_option_10="--xformers"
            ;;
            "11")
            a1111_launch_option_11="--listen"
            ;;
            "12")
            a1111_launch_option_12="--precision full"
            ;;
            "13")
            a1111_launch_option_13="--force-enable-xformers"
            ;;
            "14")
            a1111_launch_option_14="--xformers-flash-attention"
            ;;
            "15")
            a1111_launch_option_15="--api"
            ;;
            "16")
            a1111_launch_option_16="--ui-debug-mode"
            ;;
            "17")
            a1111_launch_option_17="--share"
            ;;
            "18")
            a1111_launch_option_18="--opt-split-attention-invokeai"
            ;;
            "19")
            a1111_launch_option_19="--opt-split-attention-v1"
            ;;
            "20")
            a1111_launch_option_20="--opt-sdp-attention"
            ;;
            "21")
            a1111_launch_option_21="--opt-sdp-no-mem-attention"
            ;;
            "22")
            a1111_launch_option_22="--disable-opt-split-attention"
            ;;
            "23")
            a1111_launch_option_23="--use-cpu all"
            ;;
            "24")
            a1111_launch_option_24="--opt-channelslast"
            ;;
            "25")
            a1111_launch_option_25="--no-gradio-queue"
            ;;
            "26")
            a1111_launch_option_26="--no-hashing"
            ;;
            "27")
            a1111_launch_option_27="--backend directml"
            ;;
            "28")
            a1111_launch_option_28="--opt-sub-quad-attention"
            ;;
            *)
            exit 1
            ;;    
            esac
            done
        fi
    
        #生成启动脚本
        if [ -f "./term-sd-launch.conf" ];then
            rm -v ./term-sd-launch.conf
        fi
        echo "设置启动参数" "$a1111_launch_option_1" "$a1111_launch_option_2" "$a1111_launch_option_3" "$a1111_launch_option_4" "$a1111_launch_option_5" "$a1111_launch_option_6" "$a1111_launch_option_7" "$a1111_launch_option_8" "$a1111_launch_option_9" "$a1111_launch_option_10" "$a1111_launch_option_11" "$a1111_launch_option_12" "$a1111_launch_option_13" "$a1111_launch_option_14" "$a1111_launch_option_15" "$a1111_launch_option_16" "$a1111_launch_option_17" "$a1111_launch_option_18" "$a1111_launch_option_19" "$a1111_launch_option_20" "$a1111_launch_option_21" "$a1111_launch_option_22" "$a1111_launch_option_23" "$a1111_launch_option_24" "$a1111_launch_option_25" "$a1111_launch_option_26" "$a1111_launch_option_27" "$a1111_launch_option_28"
        echo "launch.py "$a1111_launch_option_1" "$a1111_launch_option_2" "$a1111_launch_option_3" "$a1111_launch_option_4" "$a1111_launch_option_5" "$a1111_launch_option_6" "$a1111_launch_option_7" "$a1111_launch_option_8" "$a1111_launch_option_9" "$a1111_launch_option_10" "$a1111_launch_option_11" "$a1111_launch_option_12" "$a1111_launch_option_13" "$a1111_launch_option_14" "$a1111_launch_option_15" "$a1111_launch_option_16" "$a1111_launch_option_17" "$a1111_launch_option_18" "$a1111_launch_option_19" "$a1111_launch_option_20" "$a1111_launch_option_21" "$a1111_launch_option_22" "$a1111_launch_option_23" "$a1111_launch_option_24" "$a1111_launch_option_25" "$a1111_launch_option_26" "$a1111_launch_option_27" "$a1111_launch_option_28" " >term-sd-launch.conf
    fi
}

#comfyui启动脚本生成部分
function generate_comfyui_launch()
{
    comfyui_launch_option_1=""
    comfyui_launch_option_2=""
    comfyui_launch_option_3=""
    comfyui_launch_option_4=""
    comfyui_launch_option_5=""
    comfyui_launch_option_6=""
    comfyui_launch_option_7=""
    comfyui_launch_option_8=""
    comfyui_launch_option_9=""
    comfyui_launch_option_10=""
    comfyui_launch_option_11=""
    comfyui_launch_option_12=""
    comfyui_launch_option_13=""
    comfyui_launch_option_14=""
    comfyui_launch_option_15=""

    final_generate_comfyui_launch_=$(
        dialog --clear --separate-output --notags --yes-label "确认" --no-cancel --checklist "ComfyUI启动参数选择" 20 60 10 \
        "1" "listen" OFF \
        "2" "auto-launch" OFF \
        "3" "dont-upcast-attention" OFF \
        "4" "force-fp32" OFF\
        "5" "use-split-cross-attention" OFF \
        "6" "use-pytorch-cross-attention" OFF \
        "7" "disable-xformers" OFF \
        "8" "gpu-only" OFF \
        "9" "highvram" OFF \
        "10" "normalvram" OFF \
        "11" "lowvram" OFF \
        "12" "novram" OFF \
        "13" "cpu" OFF \
        "14" "quick-test-for-ci" OFF \
        "15" "directml" OFF \
        3>&1 1>&2 2>&3)

    if [ $? = 0 ];then
        if [ ! -z "$final_generate_comfyui_launch_" ]; then
            for final_generate_comfyui_launch in $final_generate_comfyui_launch_; do
            case "$final_generate_comfyui_launch" in
            "1")
            comfyui_launch_option_1="--listen"
            ;;
            "2")    
            comfyui_launch_option_2="--auto-launch"
            ;;
            "3")
            comfyui_launch_option_3="--dont-upcast-attention"
            ;;
            "4")
            comfyui_launch_option_4="--force-fp32"
            ;;
            "5")
            comfyui_launch_option_5="--use-split-cross-attention"
            ;;
            "6")
            comfyui_launch_option_6="--use-pytorch-cross-attention"
            ;;
            "7")
            comfyui_launch_option_7="--disable-xformers"
            ;;
            "8")
            comfyui_launch_option_8="--gpu-only"
            ;;
            "9")
            comfyui_launch_option_9="--highvram"
            ;;
            "10")
            comfyui_launch_option_10="--normalvram"
            ;;
            "11")
            comfyui_launch_option_11="--lowvram"
            ;;
            "12")
            comfyui_launch_option_12="--novram"
            ;;
            "13")
            comfyui_launch_option_13="--cpu"
            ;;
            "14")
            comfyui_launch_option_14="--quick-test-for-ci"
            ;;
            "15")
            comfyui_launch_option_15="--directml"
            ;;
            *)
            exit 1
            ;;    
            esac
            done
        fi

        if [ -f "./term-sd-launch.conf" ];then
            rm -v ./term-sd-launch.conf
        fi
        echo "设置启动参数" "$comfyui_launch_option_1" "$comfyui_launch_option_2" "$comfyui_launch_option_3" "$comfyui_launch_option_4" "$comfyui_launch_option_5" "$comfyui_launch_option_6" "$comfyui_launch_option_7" "$comfyui_launch_option_8" "$comfyui_launch_option_9" "$comfyui_launch_option_10" "$comfyui_launch_option_11" "$comfyui_launch_option_12" "$comfyui_launch_option_13" "$comfyui_launch_option_14" "$comfyui_launch_option_15"
        echo "main.py "$comfyui_launch_option_1" "$comfyui_launch_option_2" "$comfyui_launch_option_3" "$comfyui_launch_option_4" "$comfyui_launch_option_5" "$comfyui_launch_option_6" "$comfyui_launch_option_7" "$comfyui_launch_option_8" "$comfyui_launch_option_9" "$comfyui_launch_option_10" "$comfyui_launch_option_11" "$comfyui_launch_option_12" "$comfyui_launch_option_13" "$comfyui_launch_option_14" "$comfyui_launch_option_15"" >term-sd-launch.conf
    fi
}

#invokeai启动脚本生成部分
function generate_invokeai_launch()
{
    invokeai_launch_option=$(
        dialog --clear --title "InvokeAI启动选项" --yes-label "确认" --no-label "取消" --menu "请使用方向键和回车键选择启动参数" 20 60 10 \
        "1" "invokeai-configure" \
        "2" "invokeai" \
        "3" "invokeai --web" \
        "4" "invokeai-ti --gui" \
        "5" "invokeai-merge --gui" \
        "6" "自定义启动参数" \
        "7" "返回" \
        3>&1 1>&2 2>&3 )
    if [ $? = 0 ];then
        if [ "${invokeai_launch_option}" == '1' ]; then 
            invokeai-configure --root ./invokeai
        elif [ "${invokeai_launch_option}" == '2' ]; then 
            invokeai --root ./invokeai
        elif [ "${invokeai_launch_option}" == '3' ]; then 
            invokeai --web --root ./invokeai
        elif [ "${invokeai_launch_option}" == '4' ]; then 
            invokeai-ti --gui --root ./invokeai
        elif [ "${invokeai_launch_option}" == '5' ]; then 
            invokeai-merge --gui --root ./invokeai
        elif [ "${invokeai_launch_option}" == '6' ]; then 
            if [ -f "./term-sd-launch.conf" ];then
                if (dialog --clear --title "InvokeAI启动选择" --yes-label "启动" --no-label "修改参数" --yesno "选择直接启动/修改启动参数" 20 60) then
                    term_sd_launch_info=$(cat ./term-sd-launch.conf)
                    invokeai $term_sd_launch_info
                else
                    generate_invokeai_launch_cust
                    term_sd_launch_info=$(cat ./term-sd-launch.conf)
                    invokeai $term_sd_launch_info
                fi
            else #找不到启动配置
                generate_invokeai_launch_cust
                term_sd_launch_info=$(cat ./term-sd-launch.conf)
                invokeai $term_sd_launch_info
            fi
        elif [ "${invokeai_launch_option}" == '7' ]; then 
            echo
        fi
    fi
}

#invokeai自定义启动参数生成
function generate_invokeai_launch_cust()
{
    cust_invokeai_launch_option_1=""
    cust_invokeai_launch_option_2=""
    cust_invokeai_launch_option_3=""
    cust_invokeai_launch_option_4=""
    cust_invokeai_launch_option_5=""
    cust_invokeai_launch_option_6=""
    cust_invokeai_launch_option_7=""
    cust_invokeai_launch_option_8=""
    cust_invokeai_launch_option_9=""
    cust_invokeai_launch_option_10=""
    cust_invokeai_launch_option_11=""
    cust_invokeai_launch_option_12=""

    final_invokeai_launch_option_=$(
        dialog --clear --separate-output --notags --yes-label "确认" --no-cancel --checklist "InvokeAI启动参数选择" 20 60 10 \
        "1" "web" ON \
        "2" "free_gpu_mem" OFF \
        "3" "precision auto" ON \
        "4" "precision fp32" OFF\
        "5" "precision fp16" OFF \
        "6" "no-xformers_enabled" OFF \
        "7" "xformers_enabled" ON \
        "8" "no-patchmatch" OFF \
        "9" "always_use_cpu" OFF \
        "10" "no-esrgan" OFF \
        "11" "no-internet_available" OFF \
        "12" "host" OFF \
        3>&1 1>&2 2>&3)

    if [ $? = 0 ];then
        if [ ! -z "$final_invokeai_launch_option_" ]; then
            for final_invokeai_launch_option in $final_invokeai_launch_option_; do
            case "$final_invokeai_launch_option" in
            "1")
            cust_invokeai_launch_option_1="--web"
            ;;
            "2")
            cust_invokeai_launch_option_2="--free_gpu_mem"
            ;;
            "3")
            cust_invokeai_launch_option_3="--precision auto"
            ;;
            "4")
            cust_invokeai_launch_option_4="--precision fp32"
            ;;
            "5")
            cust_invokeai_launch_option_5="--precision fp16"
            ;;
            "6")
            cust_invokeai_launch_option_6="--no-xformers_enabled"
            ;;
            "7")
            cust_invokeai_launch_option_7="--xformers_enabled"
            ;;
            "8")
            cust_invokeai_launch_option_8="--no-patchmatch"
            ;;
            "9")
            cust_invokeai_launch_option_9="--always_use_cpu"
            ;;
            "10")
            cust_invokeai_launch_option_10="--no-esrgan"
            ;;
            "11")
            cust_invokeai_launch_option_11="--no-internet_available"
            ;;
            "12")
            cust_invokeai_launch_option_12="--host 0.0.0.0"
            ;;
            *)
            exit 1
            ;;    
            esac
            done

            #生成启动脚本
            if [ -f "./term-sd-launch.conf" ];then
                rm -v ./term-sd-launch.conf
            fi
            echo "设置启动参数 $cust_invokeai_launch_option_1 $cust_invokeai_launch_option_2 $cust_invokeai_launch_option_3 $cust_invokeai_launch_option_4 $cust_invokeai_launch_option_5 $cust_invokeai_launch_option_6 $cust_invokeai_launch_option_7 $cust_invokeai_launch_option_8 $cust_invokeai_launch_option_9 $cust_invokeai_launch_option_10 $cust_invokeai_launch_option_11 $cust_invokeai_launch_option_12"
            echo "--root ./invokeai $cust_invokeai_launch_option_1 $cust_invokeai_launch_option_2 $cust_invokeai_launch_option_3 $cust_invokeai_launch_option_4 $cust_invokeai_launch_option_5 $cust_invokeai_launch_option_6 $cust_invokeai_launch_option_7 $cust_invokeai_launch_option_8 $cust_invokeai_launch_option_9 $cust_invokeai_launch_option_10 $cust_invokeai_launch_option_11 $cust_invokeai_launch_option_12" > term-sd-launch.conf
        fi
    fi
}

function term_sd_launch()
{
    enter_venv
    term_sd_launch_info=$(cat ./term-sd-launch.conf)
    if [ $(uname -o) = "Msys" ];then #为了兼容windows系统
        python $term_sd_launch_info
    else
        python3 $term_sd_launch_info
    fi
}

###############################################################################

#term-sd其他选项

#term-sd更新选项
function update_option()
{
    if (dialog --clear --title "更新选项" --yes-label "是" --no-label "否" --yesno "更新时是否选择代理" 20 60) then
        aria2c https://ghproxy.com/https://raw.githubusercontent.com/licyk/sd-webui-script/main/term-sd.sh -d ./term-sd-update-tmp/
        if [ "$?"="0" ];then
            cp -fv ./term-sd-update-tmp/term-sd.sh ./
            rm -rfv ./term-sd-update-tmp
            chmod u+x term-sd.sh
            if (dialog --clear --title "更新选项" --msgbox "更新成功" 20 60);then
                source ./term-sd.sh
            fi
        else
            dialog --clear --title "更新选项" --msgbox "更新失败，请重试" 20 60
        fi
    else
        aria2c https://raw.githubusercontent.com/licyk/sd-webui-script/main/term-sd.sh -d ./term-sd-update-tmp/
        if [ "$?"="0" ];then
            cp -fv ./term-sd-update-tmp/term-sd.sh ./
            rm -rfv ./term-sd-update-tmp
            chmod u+x term-sd.sh
            if (dialog --clear --title "更新选项" --msgbox "更新成功" 20 60);then
                source ./term-sd.sh
            fi
        else
            dialog --clear --title "更新选项" --msgbox "更新失败，请重试" 20 60
        fi
    fi
    mainmenu
}

#扩展脚本选项
function term_sd_extension()
{
    term_sd_extension_proxy=""
    term_sd_extension_option_1="0"
    term_sd_extension_option_2="0"

    if [ -f "./sd-webui-extension.sh" ];then
        term_sd_extension_1="ON"
    else
        term_sd_extension_1="OFF"
    fi

    if [ -f "./comfyui-extension.sh" ];then
        term_sd_extension_2="ON"
    else
        term_sd_extension_2="OFF"
    fi

    term_sd_extension_select_=$(
        dialog --clear --separate-output --notags --checklist "term-sd扩展脚本列表\n勾选以下载,如果脚本已下载，则会执行更更新；取消勾选以删除\n下载的脚本将会放在term-sd脚本所在目录下\n推荐勾选\"下载代理\"" 20 60 10 \
            "1" "下载代理" ON \
            "2" "sd-webui-extension" "$term_sd_extension_1" \
            "3" "comfyui-extension" "$term_sd_extension_2" \
            3>&1 1>&2 2>&3)
        
    if [ $? = 0 ];then
        for term_sd_extension_select in $term_sd_extension_select_;do
        case "$term_sd_extension_select" in
        "1")
        term_sd_extension_proxy="https://ghproxy.com"
        ;;
        "2")
        term_sd_extension_option_1="1"
        ;;
        "3")
        term_sd_extension_option_2="1"
        ;;
        *)
        exit 1
        ;;
        esac
        done

        if [ $term_sd_extension_option_1 = "1" ];then
            aria2c $term_sd_extension_proxy/https://raw.githubusercontent.com/licyk/sd-webui-script/main/other/sd-webui-extension.sh -d ./term-sd-update-tmp/ -o sd-webui-extension.sh
            
            if [ $? = 0 ];then
                term_sd_extension_info_1="下载成功"
                cp -fv ./term-sd-update-tmp/sd-webui-extension.sh ./
                chmod +x ./sd-webui-extension.sh
                rm -rfv ./term-sd-update-tmp/
            else
                term_sd_extension_info_1="下载失败"
            fi
        else
            rm -rfv ./sd-webui-extension.sh
            term_sd_extension_info_1="已删除"
        fi

        if [ $term_sd_extension_option_2 = "1" ];then
            aria2c $term_sd_extension_proxy/https://raw.githubusercontent.com/licyk/sd-webui-script/main/other/comfyui-extension.sh -d ./term-sd-update-tmp/ -o comfyui-extension.sh
            if [ $? = 0 ];then
                term_sd_extension_info_2="下载成功"
                cp -fv ./term-sd-update-tmp/comfyui-extension.sh ./
                chmod +x ./comfyui-extension.sh
                rm -rfv ./term-sd-update-tmp/
            else
                term_sd_extension_info_2="下载失败"
            fi
        else
            rm -rfv ./comfyui-extension.sh
            term_sd_extension_info_2="已删除"
        fi

        dialog --clear --title "扩展脚本" --msgbox "扩展插件状态：\nsd-webui-extension:$term_sd_extension_info_1\nsd-webui-gui-launch:$term_sd_extension_info_2" 20 60
        term_sd_extension
    else
        mainmenu
    fi
}

#pip镜像源选项
function set_proxy_option()
{
    if (dialog --clear --title "pip镜像源选项" --yes-label "是" --no-label "否" --yesno "是否启用pip镜像源" 20 60) then
        #pip config set global.index-url "https://mirror.sjtu.edu.cn/pypi/web/simple"
        pip config set global.index-url "https://mirrors.bfsu.edu.cn/pypi/web/simple"
        pip config set global.extra-index-url "https://mirror.sjtu.edu.cn/pytorch-wheels"
    else
        pip config unset global.index-url
        pip config unset global.extra-index-url
    fi
    mainmenu
}

#pip缓存清理功能
function pip_cache_clean()
{
    echo "统计pip缓存信息中"
    if (dialog --clear --title "pip缓存清理" --yes-label "是" --no-label "否" --yesno "pip缓存信息:\npip缓存路径:$(pip cache dir)\n包索引页面缓存大小:$(pip cache info |awk NR==2 | awk -F ':'  '{print $2 $3 $4}')\n本地构建的wheel包大小:$(pip cache info |awk NR==5 | awk -F ':'  '{print $2 $3 $4}')\n是否删除pip缓存?" 20 60);then
        pip cache purge
    fi
    mainmenu
}

#term-sd版本信息
function info_option()
{
    dialog --clear --title "关于" --msgbox "Term-SD是基于终端显示的管理器,可以对项目进行简单的管理  \n
支持的项目如下: \n
1、AUTOMATIC1111-stable-diffusion-webui \n
2、ComfyUI \n
3、InvokeAI \n
4、lora-scripts \n
(项目都主要基于stable-diffusion)\n
\n
使用说明：\n
1、使用方向键、Tab键、Enter进行选择，Space键勾选或取消选项 \n
Ctrl+C可中断指令的运行 \n
2、安装项目的路径和Term-SD脚本所在路径相同，方便管理\n
3、若项目使用了venv虚拟环境，移动项目到新的路径后需要使用Term-SD的“重新生成venv虚拟环境”功能，才能使venv虚拟环境正常工作\n
4、若更新项目或者插件失败时，可使用“修复”功能，再重新更新\n
5、Term-SD只能实现简单的安装，管理功能，若要导入模型等操作需手动在文件管理器上操作\n
5、如果没有质量较好的科学上网工具，建议在安装时使用git代理和python镜像源\n
6、建议保持启用虚拟环境，因为不同项目对软件包的版本要求不同\n
7、若没有设置过python镜像源，推荐在\"python镜像源\"为系统设置python镜像源\n
8、AUTOMATIC1111-stable-diffusion-webui安装好后，可以使用秋叶aaaki制作的启动器来启动sd-webui。将秋叶的启动器放入stable-diffusion-webui文件夹中，双击启动（仅限windows,因为秋叶的启动器只有window的版本）\n
9、ComfyUI安装插件后，推荐运行一次“安装依赖”功能\n
10、有时候在安装sd-webui时选择安装插件，会因为插件兼容问题而导致报错，然后启动失败。一种解决办法是在安装选择时取消所有要安装的插件，然后安装并启动，等能够成功进入sd-weui时再用扩展脚本中的sd-webui-extension.sh来安装脚本\n
11、torch版本的选择：nvidia显卡选择cuda（Windows，linux平台），amd显卡在linux平台选择rocm，amd显卡和intel显卡在windows平台选择directml\n
12、InvokeAI在安装好后，要运行一次invokeai-configure，到\"install stable diffusion models\"界面时，可以把所有的模型取消勾选，因为有的模型是从civitai下载的，如果没有科学上网会导致下载失败\n
13、在更新或者切换版本失败时可以使用“更新修复”解决，然后再点一次“更新”\n
\n
\n
stable diffusion webui的启动参数：\n
skip-torch-cuda-test:不检查CUDA是否正常工作\n
no-half:不将模型切换为16位浮点数\n
no-half-vae:不将VAE模型切换为16位浮点数\n
medvram:启用稳定扩散模型优化,以牺牲速度换取低VRAM使用\n
lowvram:启用稳定扩散模型优化,大幅牺牲速度换取极低VRAM使用\n
lowram:将稳定扩散检查点权重加载到VRAM而不是RAM中\n
enable-insecure-extension-access:启用不安全的扩展访问\n
theme dark:启用黑色主题\n
autolaunch:自动启动浏览器打开webui界面\n
xformers:使用的xFormers加速\n
listen:允许局域网的设备访问\n
precision-full:全精度\n
force-enable-xformers:强制启用xformers加速\n
xformers-flash-attention:启用具有Flash Attention的xformer以提高再现性\n
api:启动API服务器\n
ui-debug-mode:不加载模型而快速启动ui界面\n
share:为gradio使用share=True,并通过其网站使UI可访问\n
opt-split-attention-invokeai:在自动选择优化时优先使用InvokeAI的交叉注意力层优化\n
opt-split-attention-v1:在自动选择优化时优先使用较旧版本的分裂注意力优化\n
opt-sdp-attention:在自动选择优化时优先使用缩放点积交叉注意力层优化;需要PyTorch 2\n
opt-sdp-no-mem-attention:在自动选择优化时优先使用不带内存高效注意力的缩放点积交叉注意力层优化,使图像生成确定性;需要PyTorch 2\n
disable-opt-split-attention:在自动选择优化时优先不使用交叉注意力层优化\n
use-cpu-all:使用cpu进行图像生成\n
opt-channelslast:将稳定扩散的内存类型更改为channels last\n
no-gradio-queue:禁用gradio队列;导致网页使用http请求而不是websocket\n
no-hashing:禁用检查点的sha256哈希运算,以帮助提高加载性能\n
backend directml:使用directml运行torch,解决amd显卡和intel显卡无法使用ai画图的问题\n
opt-sub-quad-attention:优先考虑内存高效的次二次复杂度交叉注意力层优化,用于自动选择\n
\n
ComfyUI启动参数:\n
listen:允许局域网的设备访问\n
auto-launch:自动在默认浏览器中启动 ComfyUI\n
dont-upcast-attention:禁用对注意力机制的提升转换。可提升速度，但增加图片变黑的概率\n
force-fp32:强制使用 fp32\n
use-split-cross-attention:使用分割交叉注意力优化。使用 xformers 时忽略此选项\n
use-pytorch-cross-attention:使用新的 pytorch 2.0 交叉注意力功能\n
disable-xformers:禁用 xformers加速\n
gpu-only:将所有内容(文本编码器/CLIP 模型等)存储和运行在 GPU 上\n
highvram:默认情况下,模型使用后会被卸载到 CPU内存。此选项使它们保留在 GPU 内存中\n
normalvram:当 lowvram 被自动启用时,强制使用普通vram用法\n
lowvram:拆分unet以使用更少的显存\n
novram:当 lowvram 不足时使用\n
cpu:对所有内容使用 CPU(缓慢)\n
quick-test-for-ci:为 CI 快速测试\n
directml:使用directml运行torch,解决amd显卡和intel显卡无法使用ai画图的问题\n
\n
InvokeAI启动参数：\n
invokeai-configure:参数配置\n
invokeai：无参数启动\n
invokeai --web：启用webui界面\n
invokeai-ti --gui:使用终端界面\n
invokeai-merge --gui：启动模型合并\n
其他的自定义参数：\n
web:启用webui界面\n
free_gpu_mem：每次操作后积极释放 GPU 内存;这将允许您在低VRAM环境中运行，但会降低一些性能\n
precision auto：自动选择浮点精度\n
precision fp32：使用fp32浮点精度\n
precision fp16：使用fp16浮点精度\n
no-xformers_enabled：禁用xformers加速\n
xformers_enabled：启用xformers加速\n
no-patchmatch：禁用“补丁匹配”算法\n
always_use_cpu:使用cpu进行图片生成\n
no-esrgan:不使用esrgan进行图片高清修复\n
no-internet_available：禁用联网下载资源\n
host:允许局域网的设备访问\n
\n
\n
该脚本的编写参考了https://gitee.com/skymysky/linux \n
脚本在理论上支持全平台(Windows平台需安装msys2,Android平台需要安装Termux)\n
\n
stable-diffusion相关链接：\n
https://huggingface.co/\n
https://civitai.com/\n
https://www.bilibili.com/read/cv22159609\n
\n
学习stable-diffusion-webui的教程：\n
https://licyk.netlify.app/2023/08/01/stable-diffusion-tutorial/\n
\n
\n
" 20 60

    #返回主菜单  
    mainmenu
}

###############################################################################

#venv虚拟环境处理

function venv_option()
{
    if (dialog --clear --title "venv虚拟环境" --yes-label "启用" --no-label "禁用" --yesno "是否启用venv虚拟环境,默认为启用状态,推荐启用" 20 60) then
        venv_active="enable"
        venv_info="启用"
    else
        venv_active="disable"
        venv_info="禁用"
    fi
    mainmenu
}

function venv_generate()
{
    if [ "$venv_active" = "enable" ];then
        if [ $(uname -o) = "Msys" ];then #为了兼容windows系统
            echo "创建venv虚拟环境"
            python -m venv venv
        else
            echo "创建venv虚拟环境"
            python3 -m venv venv
        fi
    else
        echo "忽略创建venv虚拟环境"
    fi
}

function enter_venv()
{
    if [ "$venv_active" = "enable" ];then
        if [ $(uname -o) = "Msys" ];then #为了兼容windows系统
            echo "进入venv虚拟环境"
            source ./venv/Scripts/activate
        else
            echo "进入venv虚拟环境"
            source ./venv/bin/activate
        fi
    else
        echo "忽略进入venv虚拟环境"
    fi
}

function exit_venv()
{
    echo "退出venv虚拟环境"
    deactivate
}

###############################################################################

#安装部分

#安装前代理选择
function proxy_option()
{
    python_proxy="-i https://pypi.python.org/simple"
    extra_python_proxy="-f https://download.pytorch.org/whl"
    github_proxy=""
    force_pip=""
    final_install_check_python="禁用"
    final_install_check_github="禁用"
    final_install_check_force_pip="禁用"

    final_proxy_options=$(
        dialog --clear --separate-output --notags --title "代理选择" --yes-label "确认" --no-cancel --checklist "请选择代理，强制使用pip一般情况下不选" 20 60 10 \
        "1" "启用pip镜像源" ON \
        "2" "启用github代理" ON \
        "3" "强制使用pip" OFF 3>&1 1>&2 2>&3)

    if [ ! -z "$final_proxy_options" ]; then
        for final_proxy_option in $final_proxy_options; do
        case "$final_proxy_option" in
        "1")
        #python_proxy="-i https://mirror.sjtu.edu.cn/pypi/web/simple" #上海交大的镜像源有点问题，在安装invokeai时会报错，可能是软件包版本的问题
        python_proxy="-i https://mirrors.bfsu.edu.cn/pypi/web/simple"
        extra_python_proxy="-f https://mirror.sjtu.edu.cn/pytorch-wheels/torch_stable.html"
        final_install_check_python="启用"
        ;;
        "2")
        github_proxy="https://ghproxy.com/"
        final_install_check_github="启用"
        ;;
        "3")
        force_pip="--break-system-packages"
        final_install_check_force_pip="启用"
        ;;
        *)
        exit 1
        ;;
        esac
        done
    fi
}

#pytorch安装选择
function python_dep_install()
{
    ins_pytorch=""

    final_python_dep_install=$(
        dialog --clear --title "pytorch安装" --yes-label "确认" --no-cancel --menu "请使用方向键和回车键选择安装的pytorch版本" 20 60 10 \
        "1" "Torch 1.12.1(CUDA11.3)+xFormers 0.014" \
        "2" "Torch 1.13.1(CUDA11.7)+xFormers 0.016" \
        "3" "Torch 2.0.0(CUDA11.8)+xFormers 0.018" \
        "4" "Torch 2.0.1(CUDA11.8)+xFormers 0.020" \
        "5" "Torch 2.0.1+RoCM 5.4.2" \
        "6" "Torch 2.0.1+CPU" \
        "7" "Torch-Directml" \
        "0" "跳过安装" \
        3>&1 1>&2 2>&3)

    if [ "${final_python_dep_install}" == '0' ]; then
        ins_pytorch=""
    elif [ "${final_python_dep_install}" == '1' ]; then
        ins_pytorch="torch==1.12.1+cu113 torchvision==0.13.1+cu113 xformers==0.0.14"
    elif [ "${final_python_dep_install}" == '2' ]; then
        ins_pytorch="torch==1.13.1+cu117 torchvision==0.14.1+cu117 xformers==0.0.16"
    elif [ "${final_python_dep_install}" == '3' ]; then
        ins_pytorch="torch==2.0.0+cu118 torchvision==0.15.1+cu118 xformers==0.0.18"
    elif [ "${final_python_dep_install}" == '4' ]; then
        ins_pytorch="torch==2.0.1+cu118 torchvision==0.15.2+cu118 xformers==0.0.20"
    elif [ "${final_python_dep_install}" == '5' ]; then
        ins_pytorch="torch==2.0.1+rocm5.4.2 torchvision==0.15.2+rocm5.4.2"
    elif [ "${final_python_dep_install}" == '6' ]; then
        ins_pytorch="torch==2.0.1+cpu torchvision==0.15.2+cpu"
    elif [ "${final_python_dep_install}" == '7' ]; then
        ins_pytorch="torch==2.0.0 torchvision==0.15.1 torch-directml"
    fi
}

#pip安装模式选择
function pip_install_methon()
{
    pip_install_methon_select=""
    final_install_check_pip_methon="常规安装(setup.py)"

    final_pip_install_methon=$(
        dialog --clear --title "pip安装模式选择" --yes-label "确认" --no-cancel --menu "选择pip安装方式\n1、常规安装可能会有问题,但速度较快\n2、标准构建安装可解决一些报错问题,但速度较慢" 20 60 10 \
        "1" "常规安装(setup.py)" \
        "2" "标准构建安装(--use-pep517)" \
        3>&1 1>&2 2>&3 )

    if [ $final_pip_install_methon = "1" ];then
        pip_install_methon_select=""
        final_install_check_pip_methon="常规安装(setup.py)"
    elif [ $final_pip_install_methon = "2" ];then
        pip_install_methon_select="--use-pep517"
        final_install_check_pip_methon="标准构建安装(--use-pep517)"
    fi
}
    
#automatic1111-webui插件选择
function a1111_sd_webui_extension_option()
{
    #清空插件选择
    extension_1=""
    extension_2=""
    extension_3=""
    extension_4="" 
    extension_5="" 
    extension_6="" 
    extension_7=""
    extension_8="" 
    extension_9="" 
    extension_10="" 
    extension_11="" 
    extension_12=""
    extension_13=""
    extension_14="" 
    extension_15="" 
    extension_16=""
    extension_17=""
    extension_18=""
    extension_19=""
    extension_20=""
    extension_21=""
    extension_22=""
    extension_23=""
    extension_24=""
    extension_25=""
    extension_26=""
    extension_27=""
    extension_28="" 
    extension_29=""
    extension_30=""
    extension_31=""
    extension_32=""
    extension_33=""
    extension_34=""
    extension_35=""
    extension_36=""
    extension_37=""
    extension_38=""
    extension_39=""
    extension_40=""
    extension_41=""
    extension_42=""
    extension_43=""
    extension_44=""
    extension_45=""
    extension_46=""
    extension_47=""

    final_extension_options=$(
        dialog --separate-output --notags --yes-label "确认" --no-cancel --checklist "A1111-Stable-Diffusion-Webui插件选择" 20 60 10 \
        "1" "kohya-config-webui" OFF \
        "2" "sd-webui-additional-networks" ON \
        "3" "a1111-sd-webui-tagcomplete" ON \
        "4" "multidiffusion-upscaler-for-automatic1111" ON \
        "5" "sd-dynamic-thresholding" ON \
        "6" "sd-webui-cutoff" ON \
        "7" "sd-webui-model-converter" OFF \
        "8" "sd-webui-supermerger" OFF \
        "9" "stable-diffusion-webui-localization-zh_Hans" ON \
        "10" "stable-diffusion-webui-wd14-tagger" ON \
        "11" "sd-webui-regional-prompter" ON \
        "12" "stable-diffusion-webui-baidu-netdisk" ON \
        "13" "stable-diffusion-webui-anti-burn" ON \
        "14" "loopback_scaler" OFF \
        "15" "latentcoupleregionmapper" ON \
        "16" "ultimate-upscale-for-automatic1111" ON \
        "17" "deforum-for-automatic1111" OFF \
        "18" "stable-diffusion-webui-images-browser" ON \
        "19" "stable-diffusion-webui-huggingface" OFF \
        "20" "sd-civitai-browser" OFF \
        "21" "a1111-stable-diffusion-webui-vram-estimator" OFF \
        "22" "openpose-editor" ON \
        "23" "sd-webui-depth-lib" OFF \
        "24" "posex" OFF \
        "25" "sd-webui-tunnels" OFF \
        "26" "batchlinks-webui" OFF \
        "27" "stable-diffusion-webui-catppuccin" ON \
        "28" "a1111-sd-webui-lycoris" OFF \
        "29" "stable-diffusion-webui-rembg" ON \
        "30" "stable-diffusion-webui-two-shot" ON \
        "31" "sd-webui-lora-block-weight" ON \
        "32" "sd-face-editor" OFF \
        "33" "sd-webui-segment-anything" OFF \
        "34" "sd-webui-controlnet" ON \
        "35" "sd-webui-prompt-all-in-one" ON \
        "36" "sd-webui-comfyui" OFF \
        "37" "a1111-sd-webui-lycoris" OFF \
        "38" "sd-webui-photopea-embed" ON \
        "39" "sd-webui-openpose-editor" ON \
        "40" "sd-webui-llul" ON \
        "41" "sd-webui-bilingual-localization" OFF \
        "42" "adetailer" ON \
        "43" "sd-webui-mov2mov" OFF \
        "44" "sd-webui-IS-NET-pro" ON \
        "45" "ebsynth_utility" OFF \
        "46" "sd_dreambooth_extension" OFF \
        "47" "sd-webui-memory-release" ON \
        3>&1 1>&2 2>&3)

    if [ ! -z "$final_extension_options" ]; then
        for final_extension_option in $final_extension_options; do
        case "$final_extension_option" in
        "1")
        extension_1="https://github.com/WSH032/kohya-config-webui"
        ;;
        "2")
        extension_2="https://github.com/kohya-ss/sd-webui-additional-networks"
        ;;
        "3")
        extension_3="https://github.com/DominikDoom/a1111-sd-webui-tagcomplete"
        ;;
        "4")
        extension_4="https://github.com/pkuliyi2015/multidiffusion-upscaler-for-automatic1111"
        ;;
        "5")
        extension_5="https://github.com/mcmonkeyprojects/sd-dynamic-thresholding"
        ;;
        "6")
        extension_6="https://github.com/hnmr293/sd-webui-cutoff"
        ;;
        "7")
        extension_7="https://github.com/Akegarasu/sd-webui-model-converter"
        ;;
        "8")
        extension_8="https://github.com/hako-mikan/sd-webui-supermerger"
        ;;
        "9")
        extension_9="https://github.com/hanamizuki-ai/stable-diffusion-webui-localization-zh_Hans"
        ;;
        "10")
        extension_10="https://github.com/picobyte/stable-diffusion-webui-wd14-tagger"
        ;;
        "11")
        extension_11="https://github.com/hako-mikan/sd-webui-regional-prompter"
        ;;
        "12")
        extension_12="https://github.com/zanllp/stable-diffusion-webui-baidu-netdisk"
        ;;
        "13")
        extension_13="https://github.com/klimaleksus/stable-diffusion-webui-anti-burn"
        ;;
        "14")
        extension_14="https://github.com/Elldreth/loopback_scaler"
        ;;
        "15")
        extension_15="https://github.com/CodeZombie/latentcoupleregionmapper"
        ;;
        "16")
        extension_16="https://github.com/Coyote-A/ultimate-upscale-for-automatic1111"
        ;;
        "17")
        extension_17="https://github.com/deforum-art/deforum-for-automatic1111-webui"
        ;;
        "18")
        extension_18="https://github.com/AlUlkesh/stable-diffusion-webui-images-browser"
        ;;
        "19")
        extension_19="https://github.com/camenduru/stable-diffusion-webui-huggingface"
        ;;
        "20")
        extension_20="https://github.com/camenduru/sd-civitai-browser"
        ;;
        "21")
        extension_21="https://github.com/space-nuko/a1111-stable-diffusion-webui-vram-estimator"
        ;;
        "22")
        extension_22="https://github.com/camenduru/openpose-editor"
        ;;
        "23")
        extension_23="https://github.com/jexom/sd-webui-depth-lib"
        ;;
        "24")
        extension_24="https://github.com/hnmr293/posex"
        ;;
        "25")
        extension_25="https://github.com/camenduru/sd-webui-tunnels"
        ;;
        "26")
        extension_26="https://github.com/etherealxx/batchlinks-webui"
        ;;
        "27")
        extension_27="https://github.com/camenduru/stable-diffusion-webui-catppuccin"
        ;;
        "28")
        extension_28="https://github.com/KohakuBlueleaf/a1111-sd-webui-lycoris"
        ;;
        "29")
        extension_29="https://github.com/AUTOMATIC1111/stable-diffusion-webui-rembg"
        ;;
        "30")
        extension_30="https://github.com/ashen-sensored/stable-diffusion-webui-two-shot"
        ;;
        "31")
        extension_31="https://github.com/hako-mikan/sd-webui-lora-block-weight"
        ;;
        "32")
        extension_32="https://github.com/ototadana/sd-face-editor"
        ;;
        "33")
        extension_33="https://github.com/continue-revolution/sd-webui-segment-anything"
        ;;
        "34")
        extension_34="https://github.com/Mikubill/sd-webui-controlnet"
        ;;
        "35")
        extension_35="https://github.com/Physton/sd-webui-prompt-all-in-one"
        ;;
        "36")
        extension_36="https://github.com/ModelSurge/sd-webui-comfyui"
        ;;
        "37")
        extension_37="https://github.com/KohakuBlueleaf/a1111-sd-webui-lycoris"
        ;;
        "38")
        extension_38="https://github.com/yankooliveira/sd-webui-photopea-embed"
        ;;
        "39")
        extension_39="https://github.com/huchenlei/sd-webui-openpose-editor"
        ;;
        "40")
        extension_40="https://github.com/hnmr293/sd-webui-llul"
        ;;
        "41")
        extension_41="https://github.com/journey-ad/sd-webui-bilingual-localization"
        ;;
        "42")
        extension_42="https://github.com/Bing-su/adetailer"
        ;;
        "43")
        extension_43="https://github.com/Scholar01/sd-webui-mov2mov"
        ;;
        "44")
        extension_44="https://github.com/ClockZinc/sd-webui-IS-NET-pro"
        ;;
        "45")
        extension_45="https://github.com/s9roll7/ebsynth_utility"
        ;;
        "46")
        extension_46="https://github.com/d8ahazard/sd_dreambooth_extension"
        ;;
        "47")
        extension_47="https://github.com/Haoming02/sd-webui-memory-release"
        ;;
        *)
        exit 1
        ;;
        esac
        done
    fi
}

#comfyui插件选择
function comfyui_extension_option()
{
    #清除插件选择
    comfyui_extension_1=""
    comfyui_extension_2=""

    final_comfyui_extension_option=$(
        dialog --separate-output --notags --yes-label "确认" --no-cancel --checklist "ComfyUI插件选择" 20 60 10 \
        "1" "ComfyUI-extensions" OFF \
        "2" "graphNavigator" OFF \
        3>&1 1>&2 2>&3)

    if [ ! -z "$final_comfyui_extension_option" ]; then
        for final_comfyui_extension_option_ in $final_comfyui_extension_option; do
        case "$final_comfyui_extension_option_" in
        "1")
        comfyui_extension_1="https://github.com/diffus3/ComfyUI-extensions"
        ;;
        "2")
        comfyui_extension_2="https://github.com/rock-land/graphNavigator"
        ;;
        *)
        exit 1
        ;;
        esac
        done
    fi
}

#comfyui自定义节点选择
function comfyui_custom_node_option()
{
    #清除自定义节点选择
    comfyui_custom_node_1=""
    comfyui_custom_node_2=""
    comfyui_custom_node_3=""
    comfyui_custom_node_4=""
    comfyui_custom_node_5=""
    comfyui_custom_node_6=""
    comfyui_custom_node_7=""
    comfyui_custom_node_8=""
    comfyui_custom_node_9=""
    comfyui_custom_node_10=""
    comfyui_custom_node_11=""
    comfyui_custom_node_12=""
    comfyui_custom_node_13=""
    comfyui_custom_node_14=""
    comfyui_custom_node_15=""
    comfyui_custom_node_16=""
    comfyui_custom_node_17=""
    comfyui_custom_node_18=""
    comfyui_custom_node_19=""
    comfyui_custom_node_20=""
    comfyui_custom_node_21=""
    comfyui_custom_node_22=""
    comfyui_custom_node_23=""
    comfyui_custom_node_24=""
    comfyui_custom_node_25=""
    comfyui_custom_node_26=""
    comfyui_custom_node_27=""
    comfyui_custom_node_28=""
    comfyui_custom_node_29=""
    comfyui_custom_node_30=""
    comfyui_custom_node_31=""
    comfyui_custom_node_32=""
    comfyui_custom_node_33=""
    comfyui_custom_node_34=""
    comfyui_custom_node_35=""
    comfyui_custom_node_36=""
    comfyui_custom_node_37=""
    comfyui_custom_node_38=""

    final_comfyui_custom_node_option=$(
        dialog --separate-output --notags --yes-label "确认" --no-cancel --checklist "ComfyUi自定义节点选择" 20 60 10 \
        "1" "was-node-suite-comfyui" ON \
        "2" "ComfyUI_Cutoff" OFF \
        "3" "ComfyUI_TiledKSampler" OFF \
        "4" "ComfyUI_ADV_CLIP_emb" OFF \
        "5" "ComfyUI_Noise" OFF \
        "6" "ComfyUI_Dave_CustomNode" OFF \
        "7" "ComfyUI-Impact-Pack" OFF \
        "8" "ComfyUI-Manager" OFF \
        "9" "ComfyUI-Custom-Nodes" OFF \
        "10" "ComfyUI-Custom-Scripts" OFF \
        "11" "NodeGPT" OFF \
        "12" "Derfuu_ComfyUI_ModdedNodes" OFF \
        "13" "efficiency-nodes-comfyui" OFF \
        "14" "ComfyUI_node_Lilly" OFF \
        "15" "ComfyUI-nodes-hnmr" OFF \
        "16" "ComfyUI-Vextra-Nodes" OFF \
        "17" "ComfyUI-QualityOfLifeSuit_Omar92" OFF \
        "18" "FN16-ComfyUI-nodes" OFF \
        "19" "masquerade-nodes-comfyui" OFF \
        "20" "ComfyUI-post-processing-nodes" OFF \
        "21" "images-grid-comfy-plugin" OFF \
        "22" "ComfyUI-CLIPSeg" OFF \
        "23" rembg-comfyui-node"" OFF \
        "24" "ComfyUI_tinyterraNodes" OFF \
        "25" "yk-node-suite-comfyui" OFF \
        "26" "ComfyUI_experiments" OFF \
        "27" "ComfyUI_tagger" OFF \
        "28" "MergeBlockWeighted_fo_ComfyUI" OFF \
        "29" "ComfyUI-Saveaswebp" OFF \
        "30" "trNodes" OFF \
        "31" "ComfyUI_NetDist" OFF \
        "32" "ComfyUI-Image-Selector" OFF \
        "33" "ComfyUI-Strimmlarns-Aesthetic-Score" OFF \
        "34" "ComfyUI_UltimateSDUpscale" OFF \
        "35" "ComfyUI-Disco-Diffusion" OFF \
        "36" "ComfyUI-Waveform-Extensions" OFF \
        "37" "ComfyUI_Custom_Nodes_AlekPet" OFF \
        "38" "comfy_controlnet_preprocessors" ON \
        3>&1 1>&2 2>&3)

    if [ ! -z "$final_comfyui_custom_node_option" ]; then
        for final_comfyui_custom_node_option_ in $final_comfyui_custom_node_option; do
        case "$final_comfyui_custom_node_option_" in
        "1")
        comfyui_custom_node_1="https://github.com/WASasquatch/was-node-suite-comfyui"
        ;;
        "2")
        comfyui_custom_node_2="https://github.com/BlenderNeko/ComfyUI_Cutoff"
        ;;
        "3")
        comfyui_custom_node_3="https://github.com/BlenderNeko/ComfyUI_TiledKSampler"
        ;;
        "4")
        comfyui_custom_node_4="https://github.com/BlenderNeko/ComfyUI_ADV_CLIP_emb"
        ;;
        "5")
        comfyui_custom_node_5="https://github.com/BlenderNeko/ComfyUI_Noise"
        ;;
        "6")
        comfyui_custom_node_6="https://github.com/Davemane42/ComfyUI_Dave_CustomNode"
        ;;
        "7")
        comfyui_custom_node_7="https://github.com/ltdrdata/ComfyUI-Impact-Pack"
        ;;
        "8")
        comfyui_custom_node_8="https://github.com/ltdrdata/ComfyUI-Manager"
        ;;
        "9")
        comfyui_custom_node_9="https://github.com/Zuellni/ComfyUI-Custom-Nodes"
        ;;
        "10")
        comfyui_custom_node_10="https://github.com/pythongosssss/ComfyUI-Custom-Scripts"
        ;;
        "11")
        comfyui_custom_node_11="https://github.com/xXAdonesXx/NodeGPT"
        ;;
        "12")
        comfyui_custom_node_12="https://github.com/Derfuu/Derfuu_ComfyUI_ModdedNodes"
        ;;
        "13")
        comfyui_custom_node_13="https://github.com/LucianoCirino/efficiency-nodes-comfyui"
        ;;
        "14")
        comfyui_custom_node_14="https://github.com/lilly1987/ComfyUI_node_Lilly"
        ;;
        "15")
        comfyui_custom_node_15="https://github.com/hnmr293/ComfyUI-nodes-hnmr"
        ;;
        "16")
        comfyui_custom_node_16="https://github.com/diontimmer/ComfyUI-Vextra-Nodes"
        ;;
        "17")
        comfyui_custom_node_17="https://github.com/omar92/ComfyUI-QualityOfLifeSuit_Omar92"
        ;;
        "18")
        comfyui_custom_node_18="https://github.com/Fannovel16/FN16-ComfyUI-nodes"
        ;;
        "19")
        comfyui_custom_node_19="https://github.com/BadCafeCode/masquerade-nodes-comfyui"
        ;;
        "20")
        comfyui_custom_node_20="https://github.com/EllangoK/ComfyUI-post-processing-nodes"
        ;;
        "21")
        comfyui_custom_node_21="https://github.com/LEv145/images-grid-comfy-plugin"
        ;;
        "22")
        comfyui_custom_node_22="https://github.com/biegert/ComfyUI-CLIPSeg"
        ;;
        "23")
        comfyui_custom_node_23="https://github.com/Jcd1230/rembg-comfyui-node"
        ;;
        "24")
        comfyui_custom_node_24="https://github.com/TinyTerra/ComfyUI_tinyterraNodes"
        ;;
        "25")
        comfyui_custom_node_25="https://github.com/guoyk93/yk-node-suite-comfyui"
        ;;
        "26")
        comfyui_custom_node_26="https://github.com/comfyanonymous/ComfyUI_experiments"
        ;;
        "27")
        comfyui_custom_node_27="https://github.com/gamert/ComfyUI_tagger"
        ;;
        "28")
        comfyui_custom_node_28="https://github.com/YinBailiang/MergeBlockWeighted_fo_ComfyUI"
        ;;
        "29")
        comfyui_custom_node_29="https://github.com/Kaharos94/ComfyUI-Saveaswebp"
        ;;
        "30")
        comfyui_custom_node_30="https://github.com/trojblue/trNodes"
        ;;
        "31")
        comfyui_custom_node_31="https://github.com/city96/ComfyUI_NetDist"
        ;;
        "32")
        comfyui_custom_node_32="https://github.com/SLAPaper/ComfyUI-Image-Selector"
        ;;
        "33")
        comfyui_custom_node_33="https://github.com/strimmlarn/ComfyUI-Strimmlarns-Aesthetic-Score"
        ;;
        "34")
        comfyui_custom_node_34="https://github.com/ssitu/ComfyUI_UltimateSDUpscale"
        ;;
        "35")
        comfyui_custom_node_35="https://github.com/space-nuko/ComfyUI-Disco-Diffusion"
        ;;
        "36")
        comfyui_custom_node_36="https://github.com/Bikecicle/ComfyUI-Waveform-Extensions"
        ;;
        "37")
        comfyui_custom_node_37="https://github.com/AlekPet/ComfyUI_Custom_Nodes_AlekPet"
        ;;
        "38")
        comfyui_custom_node_38="https://github.com/Fannovel16/comfy_controlnet_preprocessors"
        ;;
        *)
        exit 1
        ;;
        esac
        done
    fi
}

#安装前确认界面
function final_install_check()
{
    if (dialog --clear --title "安装确认" --yes-label "是" --no-label "否" --yesno "是否进行安装? \n
pip镜像源:$final_install_check_python \n
github代理:$final_install_check_github\n
强制使用pip:$final_install_check_force_pip\n
pytorch:$ins_pytorch\n
pip安装方式:$final_install_check_pip_methon\n
" 20 60);then
        echo "安装参数设置完成"
    else
        mainmenu
    fi
}

###############################################################################

#a1111-sd-webui安装处理部分
function process_install_a1111_sd_webui()
{

    #安装前的准备
    proxy_option #代理选择
    python_dep_install #pytorch选择
    a1111_sd_webui_extension_option #插件选择
    pip_install_methon #安装方式选择
    final_install_check #安装前确认

    #开始安装
    echo "开始安装stable-diffusion-webui"
    git clone "$github_proxy"https://github.com/AUTOMATIC1111/stable-diffusion-webui.git

    cd ./stable-diffusion-webui
    venv_generate
    enter_venv
    cd ..

    pip install $ins_pytorch $python_proxy $extra_python_proxy $force_pip $pip_install_methon_select --default-timeout=100 --retries 5 #"--default-timeout=100 --retries 5"在网络差导致下载中断时重试下载

    #安装的依赖参考"stable-diffusion-webui/modules/launch_utils.py"
    if [ ! -d "./stable-diffusion-webui/repositories" ];then
        mkdir ./stable-diffusion-webui/repositories
    fi
    #git clone "$github_proxy"https://github.com/CompVis/stable-diffusion.git ./stable-diffusion-webui/repositories/stable-diffusion
    #git clone "$github_proxy"https://github.com/CompVis/taming-transformers.git ./stable-diffusion-webui/repositories/taming-transformers
    git clone "$github_proxy"https://github.com/sczhou/CodeFormer.git ./stable-diffusion-webui/repositories/CodeFormer
    git clone "$github_proxy"https://github.com/salesforce/BLIP.git ./stable-diffusion-webui/repositories/BLIP
    git clone "$github_proxy"https://github.com/Stability-AI/stablediffusion.git/ ./stable-diffusion-webui/repositories/stable-diffusion-stability-ai
    git clone "$github_proxy"https://github.com/Stability-AI/generative-models.git ./stable-diffusion-webui/repositories/generative-models
    git clone "$github_proxy"https://github.com/crowsonkb/k-diffusion.git ./stable-diffusion-webui/repositories/k-diffusion

    pip install -U numpy --prefer-binary $python_proxy $force_pip --default-timeout=100 --retries 5
    #pip install git+"$github_proxy"https://github.com/crowsonkb/k-diffusion.git --prefer-binary $python_proxy $force_pip $pip_install_methon_select --default-timeout=100 --retries 5
    pip install git+"$github_proxy"https://github.com/TencentARC/GFPGAN.git --prefer-binary $python_proxy $force_pip $pip_install_methon_select --default-timeout=100 --retries 5
    pip install git+"$github_proxy"https://github.com/openai/CLIP.git --prefer-binary $python_proxy $force_pip $pip_install_methon_select --default-timeout=100 --retries 5
    pip install git+"$github_proxy"https://github.com/mlfoundations/open_clip.git --prefer-binary $python_proxy $force_pip $pip_install_methon_select --default-timeout=100 --retries 5

    pip install -r ./stable-diffusion-webui/repositories/CodeFormer/requirements.txt --prefer-binary $python_proxy $force_pip $pip_install_methon_select --default-timeout=100 --retries 5
    pip install -r ./stable-diffusion-webui/requirements.txt --prefer-binary $python_proxy $force_pip $pip_install_methon_select --default-timeout=100 --retries 5 #安装stable-diffusion-webui的依赖

    echo "生成配置中"
    echo "{" > config-for-sd-webui.json
    echo "    \"quicksettings_list\": [" >> config-for-sd-webui.json
    echo "        \"sd_model_checkpoint\"," >> config-for-sd-webui.json
    echo "        \"sd_vae\"," >> config-for-sd-webui.json
    echo "        \"CLIP_stop_at_last_layers\"" >> config-for-sd-webui.json   
    echo "    ]," >> config-for-sd-webui.json
    echo "    \"save_to_dirs\": false," >> config-for-sd-webui.json
    echo "    \"grid_save_to_dirs\": false," >> config-for-sd-webui.json
    echo "    \"CLIP_stop_at_last_layers\": 2" >> config-for-sd-webui.json
    echo "}" >> config-for-sd-webui.json
    mv -fv config-for-sd-webui.json ./stable-diffusion-webui
    mv -fv ./stable-diffusion-webui/config-for-sd-webui.json ./stable-diffusion-webui/config.json

    echo "安装插件中"
    if [ ! $extension_1 = "" ];then
        git clone "$github_proxy"$extension_1 ./stable-diffusion-webui/extensions/kohya-config-webui
    fi

    if [ ! $extension_2 = "" ];then
        git clone "$github_proxy"$extension_2 ./stable-diffusion-webui/extensions/sd-webui-additional-networks
    fi

    if [ ! $extension_3 = "" ];then
        git clone "$github_proxy"$extension_3 ./stable-diffusion-webui/extensions/a1111-sd-webui-tagcomplete
    fi

    if [ ! $extension_4 = "" ];then
        git clone "$github_proxy"$extension_4 ./stable-diffusion-webui/extensions/multidiffusion-upscaler-for-automatic1111
    fi

    if [ ! $extension_5 = "" ];then
        git clone "$github_proxy"$extension_5 ./stable-diffusion-webui/extensions/sd-dynamic-thresholding
    fi

    if [ ! $extension_6 = "" ];then
        git clone "$github_proxy"$extension_6 ./stable-diffusion-webui/extensions/sd-webui-cutoff
    fi

    if [ ! $extension_7 = "" ];then
        git clone "$github_proxy"$extension_7 ./stable-diffusion-webui/extensions/sd-webui-model-converter
    fi

    if [ ! $extension_8 = "" ];then
        git clone "$github_proxy"$extension_8 ./stable-diffusion-webui/extensions/sd-webui-supermerger
    fi

    if [ ! $extension_9 = "" ];then
        git clone "$github_proxy"$extension_9 ./stable-diffusion-webui/extensions/stable-diffusion-webui-localization-zh_Hans
    fi

    if [ ! $extension_10 = "" ];then
        git clone "$github_proxy"$extension_10 ./stable-diffusion-webui/extensions/stable-diffusion-webui-wd14-tagger
    fi

    if [ ! $extension_11 = "" ];then
        git clone "$github_proxy"$extension_11 ./stable-diffusion-webui/extensions/sd-webui-regional-prompter
    fi

    if [ ! $extension_12 = "" ];then
        git clone "$github_proxy"$extension_12 ./stable-diffusion-webui/extensions/stable-diffusion-webui-baidu-netdisk
    fi

    if [ ! $extension_13 = "" ];then
        git clone "$github_proxy"$extension_13 ./stable-diffusion-webui/extensions/stable-diffusion-webui-anti-burn
    fi

    if [ ! $extension_14 = "" ];then
        git clone "$github_proxy"$extension_14 ./stable-diffusion-webui/extensions/loopback_scaler
    fi

    if [ ! $extension_15 = "" ];then
        git clone "$github_proxy"$extension_15 ./stable-diffusion-webui/extensions/latentcoupleregionmapper
    fi

    if [ ! $extension_16 = "" ];then
        git clone "$github_proxy"$extension_16 ./stable-diffusion-webui/extensions/ultimate-upscale-for-automatic1111
    fi

    if [ ! $extension_17 = "" ];then
        git clone "$github_proxy"$extension_17 ./stable-diffusion-webui/extensions/deforum-for-automatic1111-webui
    fi

    if [ ! $extension_18 = "" ];then
        git clone "$github_proxy"$extension_18 ./stable-diffusion-webui/extensions/stable-diffusion-webui-images-browser
    fi

    if [ ! $extension_19 = "" ];then
        git clone "$github_proxy"$extension_19 ./stable-diffusion-webui/extensions/stable-diffusion-webui-huggingface
    fi

    if [ ! $extension_20 = "" ];then
        git clone "$github_proxy"$extension_20 ./stable-diffusion-webui/extensions/sd-civitai-browser
    fi

    if [ ! $extension_21 = "" ];then
        git clone "$github_proxy"$extension_21 ./stable-diffusion-webui/extensions/a1111-stable-diffusion-webui-vram-estimator
    fi

    if [ ! $extension_22 = "" ];then
        git clone "$github_proxy"$extension_22 ./stable-diffusion-webui/extensions/openpose-editor
    fi

    if [ ! $extension_23 = "" ];then
        git clone "$github_proxy"$extension_23 ./stable-diffusion-webui/extensions/sd-webui-depth-lib
    fi

    if [ ! $extension_24 = "" ];then
        git clone "$github_proxy"$extension_24 ./stable-diffusion-webui/extensions/posex
    fi

    if [ ! $extension_25 = "" ];then
        git clone "$github_proxy"$extension_25 ./stable-diffusion-webui/extensions/sd-webui-tunnels
    fi

    if [ ! $extension_26 = "" ];then
        git clone "$github_proxy"$extension_26 ./stable-diffusion-webui/extensions/batchlinks-webui
    fi

    if [ ! $extension_27 = "" ];then
        git clone "$github_proxy"$extension_27 ./stable-diffusion-webui/extensions/stable-diffusion-webui-catppuccin
    fi

    if [ ! $extension_28 = "" ];then
        git clone "$github_proxy"$extension_28 ./stable-diffusion-webui/extensions/a1111-sd-webui-lycoris
    fi

    if [ ! $extension_29 = "" ];then
        git clone "$github_proxy"$extension_29 ./stable-diffusion-webui/extensions/stable-diffusion-webui-rembg
    fi

    if [ ! $extension_30 = "" ];then
        git clone "$github_proxy"$extension_30 ./stable-diffusion-webui/extensions/stable-diffusion-webui-two-shot
    fi

    if [ ! $extension_31 = "" ];then
        git clone "$github_proxy"$extension_31 ./stable-diffusion-webui/extensions/sd-webui-lora-block-weight
    fi

    if [ ! $extension_32 = "" ];then
        git clone "$github_proxy"$extension_32 ./stable-diffusion-webui/extensions/sd-face-editor
    fi

    if [ ! $extension_33 = "" ];then
        git clone "$github_proxy"$extension_33 ./stable-diffusion-webui/extensions/sd-webui-segment-anything
    fi

    if [ ! $extension_34 = "" ];then
        git clone "$github_proxy"$extension_34 ./stable-diffusion-webui/extensions/sd-webui-controlnet
    fi

    if [ ! $extension_35 = "" ];then
        git clone "$github_proxy"$extension_35 ./stable-diffusion-webui/extensions/sd-webui-prompt-all-in-one
    fi

    if [ ! $extension_36 = "" ];then
        git clone "$github_proxy"$extension_36 ./stable-diffusion-webui/extensions/sd-webui-comfyui
    fi

    if [ ! $extension_37 = "" ];then
        git clone "$github_proxy"$extension_37 ./stable-diffusion-webui/extensions/a1111-sd-webui-lycoris
    fi

    if [ ! $extension_38 = "" ];then
        git clone "$github_proxy"$extension_38 ./stable-diffusion-webui/extensions/sd-webui-photopea-embed
    fi

    if [ ! $extension_39 = "" ];then
        git clone "$github_proxy"$extension_39 ./stable-diffusion-webui/extensions/sd-webui-openpose-editor
    fi

    if [ ! $extension_40 = "" ];then
        git clone "$github_proxy"$extension_40 ./stable-diffusion-webui/extensions/sd-webui-llul
    fi

    if [ ! $extension_41 = "" ];then
        git clone "$github_proxy"$extension_41 ./stable-diffusion-webui/extensions/sd-webui-bilingual-localization
    fi

    if [ ! $extension_42 = "" ];then
        git clone "$github_proxy"$extension_42 ./stable-diffusion-webui/extensions/adetailer
    fi

    if [ ! $extension_43 = "" ];then
        git clone "$github_proxy"$extension_43 ./stable-diffusion-webui/extensions/sd-webui-mov2mov
    fi

    if [ ! $extension_44 = "" ];then
        git clone "$github_proxy"$extension_44 ./stable-diffusion-webui/extensions/sd-webui-IS-NET-pro
    fi

    if [ ! $extension_45 = "" ];then
        git clone "$github_proxy"$extension_45 ./stable-diffusion-webui/extensions/ebsynth_utility
    fi

    if [ ! $extension_46 = "" ];then
        git clone "$github_proxy"$extension_46 ./stable-diffusion-webui/extensions/sd_dreambooth_extension
    fi

    if [ ! $extension_47 = "" ];then
        git clone "$github_proxy"$extension_47 ./stable-diffusion-webui/extensions/sd-webui-memory-release
    fi

    echo "下载模型中"
    aria2c https://huggingface.co/runwayml/stable-diffusion-v1-5/resolve/main/v1-5-pruned-emaonly.ckpt -d ./stable-diffusion-webui/models/Stable-diffusion -o sd-v1-5.ckpt
    aria2c https://huggingface.co/licyk/sd-upscaler-models/resolve/main/ESRGAN/4x-UltraSharp.pth -d ./stable-diffusion-webui/models/ESRGAN -o 4x-UltraSharp.pth
    aria2c https://huggingface.co/licyk/sd-upscaler-models/resolve/main/ESRGAN/BSRGAN.pth -d ./stable-diffusion-webui/models/ESRGAN -o BSRGAN.pth
    aria2c https://huggingface.co/licyk/sd-upscaler-models/resolve/main/ESRGAN/ESRGAN_4x.pth -d ./stable-diffusion-webui/models/ESRGAN -o ESRGAN_4x.pth
    aria2c https://huggingface.co/licyk/sd-upscaler-models/resolve/main/GFPGAN/GFPGANv1.4.pth -d ./stable-diffusion-webui/models/ESRGAN -o GFPGANv1.4.pth
    aria2c https://huggingface.co/licyk/sd-upscaler-models/resolve/main/GFPGAN/detection_Resnet50_Final.pth -d ./stable-diffusion-webui/models/ESRGAN -o detection_Resnet50_Final.pth
    aria2c https://huggingface.co/licyk/sd-upscaler-models/resolve/main/GFPGAN/parsing_bisenet.pth -d ./stable-diffusion-webui/models/ESRGAN -o parsing_bisenet.pth
    aria2c https://huggingface.co/licyk/sd-upscaler-models/resolve/main/GFPGAN/parsing_parsenet.pth -d ./stable-diffusion-webui/models/ESRGAN -o parsing_parsenet.pth
    aria2c https://huggingface.co/licyk/sd-upscaler-models/resolve/main/RealESRGAN/RealESRGAN_x4plus.pth -d ./stable-diffusion-webui/models/ESRGAN -o RealESRGAN_x4plus.pth
    aria2c https://huggingface.co/licyk/sd-upscaler-models/resolve/main/RealESRGAN/RealESRGAN_x4plus_anime_6B.pth -d ./stable-diffusion-webui/models/ESRGAN -o RealESRGAN_x4plus_anime_6B.pth

    aria2c https://huggingface.co/licyk/sd-embeddings/resolve/main/EasyNegativeV2.safetensors -d ./stable-diffusion-webui/embeddings/negative -o EasyNegativeV2.safetensors
    aria2c https://huggingface.co/licyk/sd-embeddings/resolve/main/bad-artist-anime.pt -d ./stable-diffusion-webui/embeddings/negative -o bad-artist-anime.pt
    aria2c https://huggingface.co/licyk/sd-embeddings/resolve/main/bad-artist.pt -d ./stable-diffusion-webui/embeddings/negative -o bad-artist.pt
    aria2c https://huggingface.co/licyk/sd-embeddings/resolve/main/bad-hands-5.pt -d ./stable-diffusion-webui/embeddings/negative -o bad-hands-5.pt
    aria2c https://huggingface.co/licyk/sd-embeddings/resolve/main/bad-image-v2-39000.pt -d ./stable-diffusion-webui/embeddings/negative -o bad-image-v2-39000.pt
    aria2c https://huggingface.co/licyk/sd-embeddings/resolve/main/bad_prompt_version2.pt -d ./stable-diffusion-webui/embeddings/negative -o bad_prompt_version2.pt
    aria2c https://huggingface.co/licyk/sd-embeddings/resolve/main/ng_deepnegative_v1_75t.pt -d ./stable-diffusion-webui/embeddings/negative -o ng_deepnegative_v1_75t.pt
    aria2c https://huggingface.co/licyk/sd-embeddings/resolve/main/verybadimagenegative_v1.3.pt -d ./stable-diffusion-webui/embeddings/negative -o verybadimagenegative_v1.3.pt
    aria2c https://huggingface.co/licyk/sd-embeddings/resolve/main/yaguru%20magiku.pt -d ./stable-diffusion-webui/embeddings -o yaguru_magiku.pt

    if [ ! $extension_34 = "" ];then #安装controlnet时再下载相关模型
        aria2c https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/control_v11e_sd15_ip2p_fp16.safetensors -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o control_v11e_sd15_ip2p_fp16.safetensors
        aria2c https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/control_v11e_sd15_shuffle_fp16.safetensors -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o control_v11e_sd15_shuffle_fp16.safetensors
        aria2c https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/control_v11p_sd15_canny_fp16.safetensors -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o control_v11p_sd15_canny_fp16.safetensors
        aria2c https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/control_v11f1p_sd15_depth_fp16.safetensors -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o control_v11f1p_sd15_depth_fp16.safetensors
        aria2c https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/control_v11p_sd15_inpaint_fp16.safetensors -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o control_v11p_sd15_inpaint_fp16.safetensors
        aria2c https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/control_v11p_sd15_lineart_fp16.safetensors -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o control_v11p_sd15_lineart_fp16.safetensors
        aria2c https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/control_v11p_sd15_mlsd_fp16.safetensors -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o control_v11p_sd15_mlsd_fp16.safetensors
        aria2c https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/control_v11p_sd15_normalbae_fp16.safetensors -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o control_v11p_sd15_normalbae_fp16.safetensors
        aria2c https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/control_v11p_sd15_openpose_fp16.safetensors -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o control_v11p_sd15_openpose_fp16.safetensors
        aria2c https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/control_v11p_sd15_scribble_fp16.safetensors -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o control_v11p_sd15_scribble_fp16.safetensors
        aria2c https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/control_v11p_sd15_seg_fp16.safetensors -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o control_v11p_sd15_seg_fp16.safetensors
        aria2c https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/control_v11p_sd15_softedge_fp16.safetensors -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o control_v11p_sd15_softedge_fp16.safetensors
        aria2c https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/control_v11p_sd15s2_lineart_anime_fp16.safetensors -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o control_v11p_sd15s2_lineart_anime_fp16.safetensors
        aria2c https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/control_v11f1e_sd15_tile_fp16.safetensors -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o control_v11f1e_sd15_tile_fp16.safetensors
        aria2c https://huggingface.co/ckpt/ControlNet-v1-1/raw/main/control_v11e_sd15_ip2p_fp16.yaml -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o control_v11e_sd15_ip2p_fp16.yaml
        aria2c https://huggingface.co/ckpt/ControlNet-v1-1/raw/main/control_v11e_sd15_shuffle_fp16.yaml -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o control_v11e_sd15_shuffle_fp16.yaml
        aria2c https://huggingface.co/ckpt/ControlNet-v1-1/raw/main/control_v11p_sd15_canny_fp16.yaml -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o control_v11p_sd15_canny_fp16.yaml
        aria2c https://huggingface.co/ckpt/ControlNet-v1-1/raw/main/control_v11f1p_sd15_depth_fp16.yaml -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o control_v11f1p_sd15_depth_fp16.yaml
        aria2c https://huggingface.co/ckpt/ControlNet-v1-1/raw/main/control_v11p_sd15_inpaint_fp16.yaml -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o control_v11p_sd15_inpaint_fp16.yaml
        aria2c https://huggingface.co/ckpt/ControlNet-v1-1/raw/main/control_v11p_sd15_lineart_fp16.yaml -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o control_v11p_sd15_lineart_fp16.yaml
        aria2c https://huggingface.co/ckpt/ControlNet-v1-1/raw/main/control_v11p_sd15_mlsd_fp16.yaml -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o control_v11p_sd15_mlsd_fp16.yaml
        aria2c https://huggingface.co/ckpt/ControlNet-v1-1/raw/main/control_v11p_sd15_normalbae_fp16.yaml -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o control_v11p_sd15_normalbae_fp16.yaml
        aria2c https://huggingface.co/ckpt/ControlNet-v1-1/raw/main/control_v11p_sd15_openpose_fp16.yaml -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o control_v11p_sd15_openpose_fp16.yaml
        aria2c https://huggingface.co/ckpt/ControlNet-v1-1/raw/main/control_v11p_sd15_scribble_fp16.yaml -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o control_v11p_sd15_scribble_fp16.yaml
        aria2c https://huggingface.co/ckpt/ControlNet-v1-1/raw/main/control_v11p_sd15_seg_fp16.yaml -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o control_v11p_sd15_seg_fp16.yaml
        aria2c https://huggingface.co/ckpt/ControlNet-v1-1/raw/main/control_v11p_sd15_softedge_fp16.yaml -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o control_v11p_sd15_softedge_fp16.yaml
        aria2c https://huggingface.co/ckpt/ControlNet-v1-1/raw/main/control_v11p_sd15s2_lineart_anime_fp16.yaml -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o control_v11p_sd15s2_lineart_anime_fp16.yaml
        aria2c https://huggingface.co/ckpt/ControlNet-v1-1/raw/main/control_v11f1e_sd15_tile_fp16.yaml -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o control_v11f1e_sd15_tile_fp16.yaml
        aria2c https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/t2iadapter_style_sd14v1.pth -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o t2iadapter_style_sd14v1.pth
        aria2c https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/t2iadapter_sketch_sd14v1.pth -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o t2iadapter_sketch_sd14v1.pth
        aria2c https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/t2iadapter_seg_sd14v1.pth -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o t2iadapter_seg_sd14v1.pth
        aria2c https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/t2iadapter_openpose_sd14v1.pth -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o t2iadapter_openpose_sd14v1.pth
        aria2c https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/t2iadapter_keypose_sd14v1.pth -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o t2iadapter_keypose_sd14v1.pth
        aria2c https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/t2iadapter_depth_sd14v1.pth -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o t2iadapter_depth_sd14v1.pth
        aria2c https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/t2iadapter_color_sd14v1.pth -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o t2iadapter_color_sd14v1.pth
        aria2c https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/t2iadapter_canny_sd14v1.pth -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o t2iadapter_canny_sd14v1.pth
        aria2c https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/t2iadapter_canny_sd15v2.pth -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o t2iadapter_canny_sd15v2.pth
        aria2c https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/t2iadapter_depth_sd15v2.pth -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o t2iadapter_depth_sd15v2.pth
        aria2c https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/t2iadapter_sketch_sd15v2.pth -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o t2iadapter_sketch_sd15v2.pth
        aria2c https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/t2iadapter_zoedepth_sd15v1.pth -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o t2iadapter_zoedepth_sd15v1.pth
        aria2c https://huggingface.co/ioclab/ioc-controlnet/resolve/main/models/control_v1p_sd15_brightness.safetensors -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o control_v1p_sd15_brightness.safetensors
        aria2c https://huggingface.co/ioclab/ioc-controlnet/resolve/main/models/control_v1p_sd15_illumination.safetensors -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o control_v1p_sd15_illumination.safetensors
        aria2c https://huggingface.co/monster-labs/control_v1p_sd15_qrcode_monster/resolve/main/control_v1p_sd15_qrcode_monster.safetensors -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o control_v1p_sd15_qrcode_monster.safetensors
        aria2c https://huggingface.co/monster-labs/control_v1p_sd15_qrcode_monster/resolve/main/control_v1p_sd15_qrcode_monster.yaml -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o control_v1p_sd15_qrcode_monster.yaml
    fi

    if [ ! $extension_42 = "" ];then #安装adetailer插件相关模型
        aria2c https://huggingface.co/Bingsu/adetailer/resolve/main/deepfashion2_yolov8s-seg.pt -d ./stable-diffusion-webui/models/adetailer -o deepfashion2_yolov8s-seg.pt
        aria2c https://huggingface.co/Bingsu/adetailer/resolve/main/face_yolov8m.pt -d ./stable-diffusion-webui/models/adetailer -o face_yolov8m.pt
        aria2c https://huggingface.co/Bingsu/adetailer/resolve/main/face_yolov8n.pt -d ./stable-diffusion-webui/models/adetailer -o face_yolov8n.pt
        aria2c https://huggingface.co/Bingsu/adetailer/resolve/main/face_yolov8n_v2.pt -d ./stable-diffusion-webui/models/adetailer -o face_yolov8n_v2.pt
        aria2c https://huggingface.co/Bingsu/adetailer/resolve/main/face_yolov8s.pt -d ./stable-diffusion-webui/models/adetailer -o face_yolov8s.pt
        aria2c https://huggingface.co/Bingsu/adetailer/resolve/main/hand_yolov8n.pt -d ./stable-diffusion-webui/models/adetailer -o hand_yolov8n.pt
        aria2c https://huggingface.co/Bingsu/adetailer/resolve/main/hand_yolov8s.pt -d ./stable-diffusion-webui/models/adetailer -o hand_yolov8s.pt
        aria2c https://huggingface.co/Bingsu/adetailer/resolve/main/person_yolov8m-seg.pt -d ./stable-diffusion-webui/models/adetailer -o person_yolov8m-seg.pt
        aria2c https://huggingface.co/Bingsu/adetailer/resolve/main/person_yolov8n-seg.pt -d ./stable-diffusion-webui/models/adetailer -o person_yolov8n-seg.pt
        aria2c https://huggingface.co/Bingsu/adetailer/resolve/main/person_yolov8s-seg.pt -d ./stable-diffusion-webui/models/adetailer -o person_yolov8s-seg.pt
    fi

    if [ ! $extension_44 = "" ];then #安装sd-webui-IS-NET-pro插件相关模型
        aria2c https://huggingface.co/ClockZinc/IS-NET_pth/resolve/main/isnet-general-use.pth -d ./stable-diffusion-webui/extensions/sd-webui-IS-NET-pro/saved_models/IS-Net -o isnet-general-use.pth
    fi

    echo "安装结束"
    exit_venv
}

#comfyui安装处理部分
function process_install_comfyui()
{
    #安装前的准备
    proxy_option #代理选择
    python_dep_install #pytorch选择
    comfyui_extension_option #comfyui插件选择
    comfyui_custom_node_option #comfyui自定义节点选择
    pip_install_methon #安装方式选择
    final_install_check #安装前确认

    #开始安装comfyui
    echo "开始安装comfyui"
    git clone "$github_proxy"https://github.com/comfyanonymous/ComfyUI.git

    cd ./ComfyUI
    venv_generate
    enter_venv
    cd ..

    pip install $ins_pytorch $python_proxy $extra_python_proxy $force_pip $pip_install_methon_select --default-timeout=100 --retries 5
    pip install -r ./ComfyUI/requirements.txt  --prefer-binary $python_proxy $force_pip $pip_install_methon_select --default-timeout=100 --retries 5

    echo "安装插件中"
    if [ ! $comfyui_extension_1 = "" ];then
        git clone "$github_proxy"$comfyui_extension_1 ./ComfyUI/web/extensions/ComfyUI-extensions
    fi

    if [ ! $comfyui_extension_2 = "" ];then
        git clone "$github_proxy"$comfyui_extension_2 ./ComfyUI/web/extensions/graphNavigator
    fi

    echo "安装自定义节点中"

    if [ ! $comfyui_custom_node_1 = "" ];then
        git clone "$github_proxy"$comfyui_custom_node_1 ./ComfyUI/custom_nodes/was-node-suite-comfyui
    fi

    if [ ! $comfyui_custom_node_2 = "" ];then
        git clone "$github_proxy"$comfyui_custom_node_2 ./ComfyUI/custom_nodes/ComfyUI_Cutoff
    fi

    if [ ! $comfyui_custom_node_3 = "" ];then
        git clone "$github_proxy"$comfyui_custom_node_3 ./ComfyUI/custom_nodes/ComfyUI_TiledKSampler
    fi

    if [ ! $comfyui_custom_node_4 = "" ];then
        git clone "$github_proxy"$comfyui_custom_node_4 ./ComfyUI/custom_nodes/ComfyUI_ADV_CLIP_emb
    fi

    if [ ! $comfyui_custom_node_5 = "" ];then
        git clone "$github_proxy"$comfyui_custom_node_5 ./ComfyUI/custom_nodes/ComfyUI_Noise
    fi

    if [ ! $comfyui_custom_node_6 = "" ];then
        git clone "$github_proxy"$comfyui_custom_node_6 ./ComfyUI/custom_nodes/ComfyUI_Dave_CustomNode
    fi

    if [ ! $comfyui_custom_node_7 = "" ];then
        git clone "$github_proxy"$comfyui_custom_node_7 ./ComfyUI/custom_nodes/ComfyUI-Impact-Pack
    fi

    if [ ! $comfyui_custom_node_8 = "" ];then
        git clone "$github_proxy"$comfyui_custom_node_8 ./ComfyUI/custom_nodes/ComfyUI-Manager
    fi

    if [ ! $comfyui_custom_node_9 = "" ];then
        git clone "$github_proxy"$comfyui_custom_node_9 ./ComfyUI/custom_nodes/ComfyUI-Custom-Nodes
    fi

    if [ ! $comfyui_custom_node_10 = "" ];then
        git clone "$github_proxy"$comfyui_custom_node_10 ./ComfyUI/custom_nodesComfyUI-Custom-Scripts
    fi

    if [ ! $comfyui_custom_node_11 = "" ];then
        git clone "$github_proxy"$comfyui_custom_node_11 ./ComfyUI/custom_nodes/NodeGPT
    fi

    if [ ! $comfyui_custom_node_12 = "" ];then
        git clone "$github_proxy"$comfyui_custom_node_12 ./ComfyUI/custom_nodes/Derfuu_ComfyUI_ModdedNodes
    fi

    if [ ! $comfyui_custom_node_13 = "" ];then
        git clone "$github_proxy"$comfyui_custom_node_13 ./ComfyUI/custom_nodes/efficiency-nodes-comfyui
    fi

    if [ ! $comfyui_custom_node_14 = "" ];then
        git clone "$github_proxy"$comfyui_custom_node_14 ./ComfyUI/custom_nodes/ComfyUI_node_Lilly
    fi

    if [ ! $comfyui_custom_node_15 = "" ];then
        git clone "$github_proxy"$comfyui_custom_node_15 ./ComfyUI/custom_nodes/ComfyUI-nodes-hnmr
    fi

    if [ ! $comfyui_custom_node_16 = "" ];then
        git clone "$github_proxy"$comfyui_custom_node_16 ./ComfyUI/custom_nodes/ComfyUI-Vextra-Nodes
    fi

    if [ ! $comfyui_custom_node_17 = "" ];then
        git clone "$github_proxy"$comfyui_custom_node_17 ./ComfyUI/custom_nodes/ComfyUI-QualityOfLifeSuit_Omar92
    fi

    if [ ! $comfyui_custom_node_18 = "" ];then
        git clone "$github_proxy"$comfyui_custom_node_18 ./ComfyUI/custom_nodes/FN16-ComfyUI-nodes
    fi

    if [ ! $comfyui_custom_node_19 = "" ];then
        git clone "$github_proxy"$comfyui_custom_node_19 ./ComfyUI/custom_nodes/masquerade-nodes-comfyui
    fi

    if [ ! $comfyui_custom_node_20 = "" ];then
        git clone "$github_proxy"$comfyui_custom_node_20 ./ComfyUI/custom_nodes/ComfyUI-post-processing-nodes
    fi

    if [ ! $comfyui_custom_node_21 = "" ];then
        git clone "$github_proxy"$comfyui_custom_node_21 ./ComfyUI/custom_nodes/images-grid-comfy-plugin
    fi

    if [ ! $comfyui_custom_node_22 = "" ];then
        git clone "$github_proxy"$comfyui_custom_node_22 ./ComfyUI/custom_nodes/ComfyUI-CLIPSeg
    fi

    if [ ! $comfyui_custom_node_23 = "" ];then
        git clone "$github_proxy"$comfyui_custom_node_23 ./ComfyUI/custom_nodes/rembg-comfyui-node
    fi

    if [ ! $comfyui_custom_node_24 = "" ];then
        git clone "$github_proxy"$comfyui_custom_node_24 ./ComfyUI/custom_nodes/ComfyUI_tinyterraNodes
    fi

    if [ ! $comfyui_custom_node_25 = "" ];then
        git clone "$github_proxy"$comfyui_custom_node_25 ./ComfyUI/custom_nodes/yk-node-suite-comfyui
    fi

    if [ ! $comfyui_custom_node_26 = "" ];then
        git clone "$github_proxy"$comfyui_custom_node_26 ./ComfyUI/custom_nodes/ComfyUI_experiments
    fi

    if [ ! $comfyui_custom_node_27 = "" ];then
        git clone "$github_proxy"$comfyui_custom_node_27 ./ComfyUI/custom_nodes/ComfyUI_tagger
    fi

    if [ ! $comfyui_custom_node_28 = "" ];then
        git clone "$github_proxy"$comfyui_custom_node_28 ./ComfyUI/custom_nodes/MergeBlockWeighted_fo_ComfyUI
    fi

    if [ ! $comfyui_custom_node_29 = "" ];then
        git clone "$github_proxy"$comfyui_custom_node_29 ./ComfyUI/custom_nodes/ComfyUI-Saveaswebp
    fi

    if [ ! $comfyui_custom_node_30 = "" ];then
        git clone "$github_proxy"$comfyui_custom_node_30 ./ComfyUI/custom_nodes/trNodes
    fi

    if [ ! $comfyui_custom_node_31 = "" ];then
        git clone "$github_proxy"$comfyui_custom_node_31 ./ComfyUI/custom_nodes/ComfyUI_NetDist
    fi

    if [ ! $comfyui_custom_node_32 = "" ];then
        git clone "$github_proxy"$comfyui_custom_node_32 ./ComfyUI/custom_nodes/ComfyUI-Image-Selector
    fi

    if [ ! $comfyui_custom_node_33 = "" ];then
        git clone "$github_proxy"$comfyui_custom_node_33 ./ComfyUI/custom_nodes/ComfyUI-Strimmlarns-Aesthetic-Score
    fi

    if [ ! $comfyui_custom_node_34 = "" ];then
        git clone "$github_proxy"$comfyui_custom_node_34 ./ComfyUI/custom_nodes/ComfyUI_UltimateSDUpscale
    fi

    if [ ! $comfyui_custom_node_35 = "" ];then
        git clone "$github_proxy"$comfyui_custom_node_35 ./ComfyUI/custom_nodes/ComfyUI-Disco-Diffusion
    fi

    if [ ! $comfyui_custom_node_36 = "" ];then
        git clone "$github_proxy"$comfyui_custom_node_36 ./ComfyUI/custom_nodes/ComfyUI-Waveform-Extensions
    fi

    if [ ! $comfyui_custom_node_37 = "" ];then
        git clone "$github_proxy"$comfyui_custom_node_37 ./ComfyUI/custom_nodes/ComfyUI_Custom_Nodes_AlekPet
    fi

    if [ ! $comfyui_custom_node_38 = "" ];then
        git clone "$github_proxy"$comfyui_custom_node_38 ./ComfyUI/custom_nodes/comfy_controlnet_preprocessors
    fi

    echo "下载模型中"
    aria2c https://huggingface.co/runwayml/stable-diffusion-v1-5/resolve/main/v1-5-pruned-emaonly.ckpt -d ./ComfyUI/models/checkpoints/ -o sd-v1-5.ckpt

    if [ ! $comfyui_custom_node_38 = "" ];then
        echo "下载controlnet模型中"
        aria2c https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/control_v11e_sd15_ip2p_fp16.safetensors -d ./ComfyUI/models/controlnet -o control_v11e_sd15_ip2p_fp16.safetensors
        aria2c https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/control_v11e_sd15_shuffle_fp16.safetensors -d ./ComfyUI/models/controlnet -o control_v11e_sd15_shuffle_fp16.safetensors
        aria2c https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/control_v11p_sd15_canny_fp16.safetensors -d ./ComfyUI/models/controlnet -o control_v11p_sd15_canny_fp16.safetensors
        aria2c https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/control_v11f1p_sd15_depth_fp16.safetensors -d ./ComfyUI/models/controlnet -o control_v11f1p_sd15_depth_fp16.safetensors
        aria2c https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/control_v11p_sd15_inpaint_fp16.safetensors -d ./ComfyUI/models/controlnet -o control_v11p_sd15_inpaint_fp16.safetensors
        aria2c https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/control_v11p_sd15_lineart_fp16.safetensors -d ./ComfyUI/models/controlnet -o control_v11p_sd15_lineart_fp16.safetensors
        aria2c https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/control_v11p_sd15_mlsd_fp16.safetensors -d ./ComfyUI/models/controlnet -o control_v11p_sd15_mlsd_fp16.safetensors
        aria2c https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/control_v11p_sd15_normalbae_fp16.safetensors -d ./ComfyUI/models/controlnet -o control_v11p_sd15_normalbae_fp16.safetensors
        aria2c https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/control_v11p_sd15_openpose_fp16.safetensors -d ./ComfyUI/models/controlnet -o control_v11p_sd15_openpose_fp16.safetensors
        aria2c https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/control_v11p_sd15_scribble_fp16.safetensors -d ./ComfyUI/models/controlnet -o control_v11p_sd15_scribble_fp16.safetensors
        aria2c https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/control_v11p_sd15_seg_fp16.safetensors -d ./ComfyUI/models/controlnet -o control_v11p_sd15_seg_fp16.safetensors
        aria2c https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/control_v11p_sd15_softedge_fp16.safetensors -d ./ComfyUI/models/controlnet -o control_v11p_sd15_softedge_fp16.safetensors
        aria2c https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/control_v11p_sd15s2_lineart_anime_fp16.safetensors -d ./ComfyUI/models/controlnet -o control_v11p_sd15s2_lineart_anime_fp16.safetensors
        aria2c https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/control_v11f1e_sd15_tile_fp16.safetensors -d ./ComfyUI/models/controlnet -o control_v11f1e_sd15_tile_fp16.safetensors
        aria2c https://huggingface.co/ckpt/ControlNet-v1-1/raw/main/control_v11e_sd15_ip2p_fp16.yaml -d ./ComfyUI/models/controlnet -o control_v11e_sd15_ip2p_fp16.yaml
        aria2c https://huggingface.co/ckpt/ControlNet-v1-1/raw/main/control_v11e_sd15_shuffle_fp16.yaml -d ./ComfyUI/models/controlnet -o control_v11e_sd15_shuffle_fp16.yaml
        aria2c https://huggingface.co/ckpt/ControlNet-v1-1/raw/main/control_v11p_sd15_canny_fp16.yaml -d ./ComfyUI/models/controlnet -o control_v11p_sd15_canny_fp16.yaml
        aria2c https://huggingface.co/ckpt/ControlNet-v1-1/raw/main/control_v11f1p_sd15_depth_fp16.yaml -d ./ComfyUI/models/controlnet -o control_v11f1p_sd15_depth_fp16.yaml
        aria2c https://huggingface.co/ckpt/ControlNet-v1-1/raw/main/control_v11p_sd15_inpaint_fp16.yaml -d ./ComfyUI/models/controlnet -o control_v11p_sd15_inpaint_fp16.yaml
        aria2c https://huggingface.co/ckpt/ControlNet-v1-1/raw/main/control_v11p_sd15_lineart_fp16.yaml -d ./ComfyUI/models/controlnet -o control_v11p_sd15_lineart_fp16.yaml
        aria2c https://huggingface.co/ckpt/ControlNet-v1-1/raw/main/control_v11p_sd15_mlsd_fp16.yaml -d ./ComfyUI/models/controlnet -o control_v11p_sd15_mlsd_fp16.yaml
        aria2c https://huggingface.co/ckpt/ControlNet-v1-1/raw/main/control_v11p_sd15_normalbae_fp16.yaml -d ./ComfyUI/models/controlnet -o control_v11p_sd15_normalbae_fp16.yaml
        aria2c https://huggingface.co/ckpt/ControlNet-v1-1/raw/main/control_v11p_sd15_openpose_fp16.yaml -d ./ComfyUI/models/controlnet -o control_v11p_sd15_openpose_fp16.yaml
        aria2c https://huggingface.co/ckpt/ControlNet-v1-1/raw/main/control_v11p_sd15_scribble_fp16.yaml -d ./ComfyUI/models/controlnet -o control_v11p_sd15_scribble_fp16.yaml
        aria2c https://huggingface.co/ckpt/ControlNet-v1-1/raw/main/control_v11p_sd15_seg_fp16.yaml -d ./ComfyUI/models/controlnet -o control_v11p_sd15_seg_fp16.yaml
        aria2c https://huggingface.co/ckpt/ControlNet-v1-1/raw/main/control_v11p_sd15_softedge_fp16.yaml -d ./ComfyUI/models/controlnet -o control_v11p_sd15_softedge_fp16.yaml
        aria2c https://huggingface.co/ckpt/ControlNet-v1-1/raw/main/control_v11p_sd15s2_lineart_anime_fp16.yaml -d ./ComfyUI/models/controlnet -o control_v11p_sd15s2_lineart_anime_fp16.yaml
        aria2c https://huggingface.co/ckpt/ControlNet-v1-1/raw/main/control_v11f1e_sd15_tile_fp16.yaml -d ./ComfyUI/models/controlnet -o control_v11f1e_sd15_tile_fp16.yaml
        aria2c https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/t2iadapter_style_sd14v1.pth -d ./ComfyUI/models/controlnet -o t2iadapter_style_sd14v1.pth
        aria2c https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/t2iadapter_sketch_sd14v1.pth -d ./ComfyUI/models/controlnet -o t2iadapter_sketch_sd14v1.pth
        aria2c https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/t2iadapter_seg_sd14v1.pth -d ./ComfyUI/models/controlnet -o t2iadapter_seg_sd14v1.pth
        aria2c https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/t2iadapter_openpose_sd14v1.pth -d ./ComfyUI/models/controlnet -o t2iadapter_openpose_sd14v1.pth
        aria2c https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/t2iadapter_keypose_sd14v1.pth -d ./ComfyUI/models/controlnet -o t2iadapter_keypose_sd14v1.pth
        aria2c https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/t2iadapter_depth_sd14v1.pth -d ./ComfyUI/models/controlnet -o t2iadapter_depth_sd14v1.pth
        aria2c https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/t2iadapter_color_sd14v1.pth -d ./ComfyUI/models/controlnet -o t2iadapter_color_sd14v1.pth
        aria2c https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/t2iadapter_canny_sd14v1.pth -d ./ComfyUI/models/controlnet -o t2iadapter_canny_sd14v1.pth
        aria2c https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/t2iadapter_canny_sd15v2.pth -d ./ComfyUI/models/controlnet -o t2iadapter_canny_sd15v2.pth
        aria2c https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/t2iadapter_depth_sd15v2.pth -d ./ComfyUI/models/controlnet -o t2iadapter_depth_sd15v2.pth
        aria2c https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/t2iadapter_sketch_sd15v2.pth -d ./ComfyUI/models/controlnet -o t2iadapter_sketch_sd15v2.pth
        aria2c https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/t2iadapter_zoedepth_sd15v1.pth -d ./ComfyUI/models/controlnet -o t2iadapter_zoedepth_sd15v1.pth
        aria2c https://huggingface.co/ioclab/ioc-controlnet/resolve/main/models/control_v1p_sd15_brightness.safetensors -d ./ComfyUI/models/controlnet -o control_v1p_sd15_brightness.safetensors
        aria2c https://huggingface.co/ioclab/ioc-controlnet/resolve/main/models/control_v1p_sd15_illumination.safetensors -d ./ComfyUI/models/controlnet -o control_v1p_sd15_illumination.safetensors
        aria2c https://huggingface.co/monster-labs/control_v1p_sd15_qrcode_monster/resolve/main/control_v1p_sd15_qrcode_monster.safetensors -d ./ComfyUI/models/controlnet -o control_v1p_sd15_qrcode_monster.safetensors
        aria2c https://huggingface.co/monster-labs/control_v1p_sd15_qrcode_monster/resolve/main/control_v1p_sd15_qrcode_monster.yaml -d ./ComfyUI/models/controlnet -o control_v1p_sd15_qrcode_monster.yaml
    fi
    echo "安装结束"
    exit_venv
}

#invokeai安装处理部分
function process_install_invokeai()
{
    #安装前准备
    proxy_option #代理选择
    python_dep_install #pytorch选择
    pip_install_methon #安装方式选择
    final_install_check #安装前确认

    #开始安装invokeai
    echo "开始安装invokeai"
    if [ ! -d "./InvokeAI" ];then
        mkdir InvokeAI
    fi
    cd ./InvokeAI
    venv_generate
    enter_venv
    if [ ! -d "./invokeai" ];then
        mkdir ./invokeai
    fi
    pip install invokeai $ins_pytorch $python_proxy $extra_python_proxy $force_pip $pip_install_methon_select --default-timeout=100 --retries 5
    aria2c https://huggingface.co/licyk/sd-upscaler-models/resolve/main/invokeai/RealESRGAN_x4plus.pth -d ./invokeai/models/core/upscaling/realesrgan -o RealESRGAN_x4plus.pth
    aria2c https://huggingface.co/licyk/sd-upscaler-models/resolve/main/invokeai/RealESRGAN_x4plus_anime_6B.pth -d ./invokeai/models/core/upscaling/realesrgan -o RealESRGAN_x4plus_anime_6B.pth
    aria2c https://huggingface.co/licyk/sd-upscaler-models/resolve/main/invokeai/ESRGAN_SRx4_DF2KOST_official-ff704c30.pth -d ./invokeai/models/core/upscaling/realesrgan -o ESRGAN_SRx4_DF2KOST_official-ff704c30.pth
    aria2c https://huggingface.co/licyk/sd-upscaler-models/resolve/main/invokeai/RealESRGAN_x2plus.pth -d ./invokeai/models/core/upscaling/realesrgan -o RealESRGAN_x2plus.pth
    echo "安装结束"
    exit_venv
}

#lora-scipts安装处理部分
function process_install_lora_scripts()
{
    #安装前的准备
    proxy_option #代理选择
    python_dep_install #pytorch选择
    pip_install_methon #安装方式选择
    final_install_check #安装前确认

    #参考lora-scripts里的install.bash写的
    echo "开始安装lora-scipts"
    git clone "$github_proxy"https://github.com/Akegarasu/lora-scripts.git #lora-scripts本体
    git clone "$github_proxy"https://github.com/kohya-ss/sd-scripts.git ./lora-scripts/sd-scripts #lora-scripts后端
    git clone "$github_proxy"https://github.com/hanamizuki-ai/lora-gui-dist ./lora-scripts/frontend #lora-scripts前端
    cd ./lora-scripts
    git submodule init
    git submodule update
    git submodule
    venv_generate
    enter_venv
    pip install $ins_pytorch $python_proxy $extra_python_proxy $force_pip $pip_install_methon_select --default-timeout=100 --retries 5
    pip install $python_proxy $extra_python_proxy $force_pip $pip_install_methon_select --upgrade -r requirements.txt  --default-timeout=100 --retries 5
    cd ./sd-scripts
    pip install $python_proxy $extra_python_proxy $force_pip $pip_install_methon_select --upgrade -r requirements.txt  --default-timeout=100 --retries 5 #sd-scripts目录下还有个_typos.toml，在安装requirements.txt里的依赖时会指向这个文件
    cd ../..
    aria2c https://huggingface.co/runwayml/stable-diffusion-v1-5/resolve/main/v1-5-pruned-emaonly.ckpt -d ./lora-scripts/sd-models/ -o model.ckpt
    echo "安装结束"
    exit_venv
}

#选择重新安装pytorch
function pytorch_reinstall()
{
    #安装前的准备
    proxy_option #代理选择
    python_dep_install #pytorch选择
    pip_install_methon #安装方式选择
    final_install_check #安装前确认

    #开始安装pytorch
    venv_generate
    enter_venv
    pip install $ins_pytorch $python_proxy $extra_python_proxy $force_pip $pip_install_methon_select --force-reinstall --default-timeout=100 --retries 5
    exit_venv
}

###############################################################################

#插件管理部分

#a1111-sd-webui

#插件的安装或管理选项(该部分最先被调用)
function extension_methon()
{
    #功能选择界面
    final_extension_methon=$(
        dialog --clear --title "插件管理" --yes-label "确认" --no-label "取消" --menu "请使用方向键和回车键进行操作" 20 60 10 \
        "1" "安装" \
        "2" "管理" \
        "3" "更新全部插件" \
        "4" "返回" \
        3>&1 1>&2 2>&3 )

    if [ $? = 0 ];then
        if [ "${final_extension_methon}" == '1' ]; then #选择安装
            extension_install
            extension_methon
        elif [ "${final_extension_methon}" == '2' ]; then #选择管理
            extension_manager
            extension_methon
        elif [ "${final_extension_methon}" == '3' ]; then #选择更新全部插件
            extension_all_update
            extension_methon
        elif [ "${final_extension_methon}" == '4' ]; then #选择返回
            echo
        fi
    fi
}

#插件管理界面
function extension_manager()
{
    dir_list=$(ls -l --time-style=+"%Y-%m-%d"  | awk -F ' ' ' { print $7 " " $6 } ') #当前目录文件和文件夹信息

    extension_selection=$(
        dialog --clear --yes-label "确认" --no-label "取消" --title "插件管理" \
        --menu "使用上下键选择要操作的插件并回车确认" 20 60 10 \
        $dir_list \
        3>&1 1>&2 2>&3)
    if [ $? = 0 ];then
        if [[ -d "$extension_selection" ]]; then  # 选择文件夹
            cd "$extension_selection"
            operate_extension #调用operate_extension函数处理插件
            extension_manager
        elif [[ -f "$extension_selection" ]]; then
            extension_manager #留在当前目录
        else
            extension_manager #留在当前目录
        fi
    fi
}

#插件安装模块
function extension_install()
{
    extension_address=$(dialog --clear --title "插件安装" --yes-label "确认" --no-label "取消" --inputbox "输入插件的github或其他下载地址" 20 60 3>&1 1>&2 2>&3)

    if [ $? = 0 ]; then
        git clone $extension_address
        if [ $? = "0" ];then
            dialog --clear --title "插件管理" --msgbox "安装成功\n$extension_dep_notice" 20 60
        else
            dialog --clear --title "插件管理" --msgbox "安装失败" 20 60
        fi
    fi
}

#插件处理模块
function operate_extension() 
{
    final_operate_extension=$(
        dialog --clear --title "操作选择" --yes-label "确认" --no-label "取消" --menu "请使用方向键和回车键选择对该插件进行的操作" 20 60 10 \
        "1" "更新" \
        "2" "卸载" \
        "3" "修复更新" \
        "4" "版本切换" \
        "5" "返回" \
        3>&1 1>&2 2>&3)
    if [ $? = 0 ];then
        if [ "${final_operate_extension}" == '1' ]; then
            echo "更新"$extension_selection"中"
            git pull
            if [ $? = "0" ];then
                dialog --clear --title "插件管理" --msgbox "更新成功" 20 60
            else
                dialog --clear --title "插件管理" --msgbox "更新失败" 20 60
            fi
            cd ..
        elif [ "${final_operate_extension}" == '2' ]; then
            if (dialog --clear --title "删除选项" --yes-label "是" --no-label "否" --yesno "是否删除该插件" 20 60) then
                echo "删除"$extension_selection"插件中"
                cd ..
                rm -rfv ./$extension_selection
            else
                cd ..
            fi
        elif [ "${final_operate_extension}" == '3' ]; then
            echo "修复更新中"
            git reset --hard HEAD
            cd ..
        elif [ "${final_operate_extension}" == '4' ]; then
            git_checkout_manager
        elif [ "${final_operate_extension}" == '5' ]; then
            cd ..
        fi
    else
        cd ..
    fi
}

#comfyui
#comfyui的扩展分为两种，一种是前端节点，另一种是后端扩展 详见：https://github.com/comfyanonymous/ComfyUI/discussions/631

#comfyui前端节点管理
#自定义节点的安装或管理选项(该部分最先被调用)
function comfyui_custom_node_methon()
{
    #功能选择界面
    final_comfyui_custom_node_methon=$(
        dialog --clear --title "自定义节点管理" --yes-label "确认" --no-label "取消" --menu "请使用方向键和回车键进行操作" 20 60 10 \
        "1" "安装" \
        "2" "管理" \
        "3" "更新全部自定义节点" \
        "4" "安装全部自定义节点依赖" \
        "5" "返回" \
        3>&1 1>&2 2>&3 )

    if [ $? = 0 ];then
        if [ "${final_comfyui_custom_node_methon}" == '1' ]; then #选择安装
            comfyui_custom_node_install
            comfyui_custom_node_methon
        elif [ "${final_comfyui_custom_node_methon}" == '2' ]; then #选择管理
            comfyui_custom_node_manager
            comfyui_custom_node_methon
        elif [ "${final_comfyui_custom_node_methon}" == '3' ]; then #选择更新全部自定义节点
            extension_all_update
            comfyui_custom_node_methon
        elif [ "${final_comfyui_custom_node_methon}" == '4' ]; then #选择安装全部插件依赖
            comfyui_extension_dep_install
            comfyui_custom_node_methon
        elif [ "${final_comfyui_custom_node_methon}" == '5' ]; then #选择返回
            echo
        fi
    fi
}

#自定义节点管理界面
function comfyui_custom_node_manager()
{
    dir_list=$(ls -l --time-style=+"%Y-%m-%d" | awk -F ' ' ' { print $7 " " $6 } ') #当前目录文件和文件夹信息

    comfyui_custom_node_selection=$(
        dialog --clear --yes-label "确认" --no-label "取消" --title "自定义节点管理" \
        --menu "使用上下键选择要操作的插件并回车确认" 20 60 10 \
        $dir_list \
        3>&1 1>&2 2>&3)
    if [ $? = 0 ];then
        if [[ -d "$comfyui_custom_node_selection" ]]; then  # 选择文件夹
            cd "$comfyui_custom_node_selection"
            operate_comfyui_custom_node #调用operate_extension函数处理插件
            comfyui_custom_node_manager
        elif [[ -f "$extension_selection" ]]; then
            comfyui_custom_node_manager #留在当前目录
        else
            comfyui_custom_node_manager #留在当前目录
        fi
    fi
}

#自定义节点安装模块
function comfyui_custom_node_install()
{
    comfyui_custom_node_address=$(dialog --clear --title "自定义节点安装" --yes-label "确认" --no-label "取消" --inputbox "输入自定义节点的github或其他下载地址" 20 60 3>&1 1>&2 2>&3)

    if [ $? = 0 ]; then
        git clone $comfyui_custom_node_address
        git_req=$?
        comfyui_custom_node_dep_notice=""
        if [ -f "./$(awk -F "/" '{print $NF}' <<< "$comfyui_custom_node_address")/requirements.txt" ];then
            comfyui_custom_node_dep_notice="检测到该自定义节点需要安装依赖，请进入自定义节点管理功能，选中该自定义节点，运行一次\"安装依赖\"功能"
        elif [ -f "./$(awk -F "/" '{print $NF}' <<< "$comfyui_custom_node_address")/install.py" ];then
            comfyui_custom_node_dep_notice="检测到该自定义节点需要安装依赖，请进入自定义节点管理功能，选中该自定义节点，运行一次\"安装依赖\"功能"
        fi

        if [ $git_req = "0" ];then
            dialog --clear --title "自定义节点管理" --msgbox "安装成功\n$comfyui_custom_node_dep_notice" 20 60
        else
            dialog --clear --title "自定义节点管理" --msgbox "安装失败" 20 60
        fi
    fi
}

#自定义节点处理模块
function operate_comfyui_custom_node() 
{
    final_operate_comfyui_custom_node=$(
        dialog --clear --title "操作选择" --yes-label "确认" --no-label "取消" --menu "请使用方向键和回车键选择对该自定义节点进行的操作" 20 60 10 \
        "1" "更新" \
        "2" "安装依赖" \
        "3" "卸载" \
        "4" "修复更新" \
        "5" "版本切换" \
        "6" "返回" \
        3>&1 1>&2 2>&3)
    if [ $? = 0 ];then
        if [ "${final_operate_comfyui_custom_node}" == '1' ]; then
            echo "更新"$comfyui_custom_node_selection"中"
            git pull
            if [ $? = "0" ];then
                dialog --clear --title "自定义节点管理" --msgbox "更新成功" 20 60
            else
                dialog --clear --title "自定义节点管理" --msgbox "更新失败" 20 60
            fi
            cd ..
        elif [ "${final_operate_comfyui_custom_node}" == '2' ]; then #comfyui并不像a1111-sd-webui自动为插件安装依赖，所以只能手动装
            cd "$start_path/ComfyUI"
            enter_venv
            cd -
            if [ -f "./install.py" ];then
                if [ $(uname -o) = "Msys" ];then #为了兼容windows系统
                    python install.py
                else
                    python3 install.py
                fi
            fi

            if [ -f "./requirements.txt" ];then
                pip install -r requirements.txt
            fi
            exit_venv
            cd ..
        elif [ "${final_operate_comfyui_custom_node}" == '3' ]; then
            if (dialog --clear --title "删除选项" --yes-label "是" --no-label "否" --yesno "是否删除该自定义节点" 20 60) then
                echo "删除"$comfyui_custom_node_selection"自定义节点中"
                cd ..
                rm -rfv ./$comfyui_custom_node_selection
            else
                cd ..
            fi
        elif [ "${final_operate_comfyui_custom_node}" == '4' ]; then
            echo "修复更新中"
            git reset --hard HEAD
            cd ..
        elif [ "${final_operate_comfyui_custom_node}" == '5' ]; then
            git_checkout_manager
        elif [ "${final_operate_comfyui_custom_node}" == '6' ]; then
            cd ..
        fi
    else
        cd ..
    fi
}

#comfyui后端插件管理
#插件的安装或管理选项(该部分最先被调用)
function comfyui_extension_methon()
{
    #功能选择界面
    final_comfyui_extension_methon=$(
        dialog --clear --title "插件管理" --yes-label "确认" --no-label "取消" --menu "请使用方向键和回车键进行操作" 20 60 10 \
        "1" "安装" \
        "2" "管理" \
        "3" "更新全部插件" \
        "4" "安装全部插件依赖" \
        "5" "返回" \
        3>&1 1>&2 2>&3 )

    if [ $? = 0 ];then
        if [ "${final_comfyui_extension_methon}" == '1' ]; then #选择安装
            comfyui_extension_install
            comfyui_extension_methon
        elif [ "${final_comfyui_extension_methon}" == '2' ]; then #选择管理
            comfyui_extension_manager
            comfyui_extension_methon
        elif [ "${final_comfyui_extension_methon}" == '3' ]; then #选择更新全部插件
            extension_all_update
            comfyui_extension_methon
        elif [ "${final_comfyui_extension_methon}" == '4' ]; then #选择安装全部插件依赖
            comfyui_extension_dep_install
            comfyui_extension_methon
        elif [ "${final_comfyui_extension_methon}" == '5' ]; then #选择返回
            echo
        fi
    fi
}

#插件管理界面
function comfyui_extension_manager()
{
    dir_list=$(ls -l --time-style=+"%Y-%m-%d" | awk -F ' ' ' { print $7 " " $6 } ') #当前目录文件和文件夹信息

    comfyui_extension_selection=$(
        dialog --clear --yes-label "确认" --no-label "取消" --title "插件管理" \
        --menu "使用上下键选择要操作的插件并回车确认" 20 60 10 \
        $dir_list \
        3>&1 1>&2 2>&3)
    if [ $? = 0 ];then
        if [[ -d "$comfyui_extension_selection" ]]; then  # 选择文件夹
            cd "$comfyui_extension_selection"
            operate_comfyui_extension #调用operate_extension函数处理插件
            comfyui_extension_manager
        elif [[ -f "$extension_selection" ]]; then
            comfyui_extension_manager #留在当前目录
        else
            comfyui_extension_manager #留在当前目录
        fi
    fi
}

#插件安装模块
function comfyui_extension_install()
{
    comfyui_extension_address=$(dialog --clear --title "插件安装" --yes-label "确认" --no-label "取消" --inputbox "输入插件的github或其他下载地址" 20 60 3>&1 1>&2 2>&3)

    if [ $? = 0 ]; then
        git clone $comfyui_extension_address
        git_req=$?
        comfyui_extension_dep_notice=""
        if [ -f "./$(awk -F "/" '{print $NF}' <<< "$comfyui_extension_address")/requirements.txt" ];then
            comfyui_extension_dep_notice="检测到该插件需要安装依赖，请进入插件管理功能，选中该插件，运行一次\"安装依赖\"功能"
        elif [ -f "./$(awk -F "/" '{print $NF}' <<< "$comfyui_extension_address")/install.py" ];then
            comfyui_extension_dep_notice="检测到该插件需要安装依赖，请进入插件管理功能，选中该插件，运行一次\"安装依赖\"功能"
        fi

        if [ $git_req = "0" ];then
            dialog --clear --title "插件管理" --msgbox "安装成功\n$comfyui_extension_dep_notice" 20 60
        else
            dialog --clear --title "插件管理" --msgbox "安装失败" 20 60
        fi
    fi
}

#插件处理模块
function operate_comfyui_extension() 
{
    final_operate_comfyui_extension=$(
        dialog --clear --title "操作选择" --yes-label "确认" --no-label "取消" --menu "请使用方向键和回车键选择对该插件进行的操作" 20 60 10 \
        "1" "更新" \
        "2" "安装依赖" \
        "3" "卸载" \
        "4" "修复更新" \
        "5" "版本切换" \
        "6" "返回" \
        3>&1 1>&2 2>&3)

    if [ $? = 0 ];then
        if [ "${final_operate_comfyui_extension}" == '1' ]; then
            echo "更新"$comfyui_extension_selection"中"
            git pull
            if [ $? = "0" ];then
                dialog --clear --title "插件管理" --msgbox "更新成功" 20 60
            else
                dialog --clear --title "插件管理" --msgbox "更新失败" 20 60
            fi
            cd ..
        elif [ "${final_operate_comfyui_extension}" == '2' ]; then #comfyui并不像a1111-sd-webui自动为插件安装依赖，所以只能手动装
            cd "$start_path/ComfyUI"
            enter_venv
            cd -
            if [ -f "./install.py" ];then
                if [ $(uname -o) = "Msys" ];then #为了兼容windows系统
                    python install.py
                else
                    python3 install.py
                fi
            fi

            if [ -f "./requirements.txt" ];then
                pip install -r requirements.txt
            fi
            exit_venv
            cd ..
        elif [ "${final_operate_comfyui_extension}" == '3' ]; then
            if (dialog --clear --title "删除选项" --yes-label "是" --no-label "否" --yesno "是否删除该插件" 20 60) then
                echo "删除"$comfyui_extension_selection"插件中"
                cd ..
                rm -rfv ./$comfyui_extension_selection
            else
                cd ..
            fi
        elif [ "${final_operate_comfyui_extension}" == '4' ]; then
            echo "修复更新中"
            git reset --hard HEAD
            cd ..
        elif [ "${final_operate_comfyui_extension}" == '5' ]; then
            git_checkout_manager
        elif [ "${final_operate_comfyui_extension}" == '6' ]; then
            cd ..
        fi
    else
        cd ..
    fi
}

#comfyui插件/自定义节点依赖安装部分
function comfyui_extension_dep_install()
{
    cd "$start_path/ComfyUI"
    enter_venv
    cd -
    for extension_folder in ./*
    do
        [ -f "$extension_folder" ] && continue #排除文件
        cd $extension_folder
        if [ -f "./install.py" ];then
            echo "安装"$extension_folder"依赖"
            if [ $(uname -o) = "Msys" ];then #为了兼容windows系统
                python install.py
            else
                python3 install.py
            fi
        fi

        if [ -f "./requirements.txt" ];then
            echo "安装"$extension_folder"依赖"
            pip install -r requirements.txt
        fi
        cd ..
    done
    exit_venv
}

###############################################################################

#这些功能在a1111-sd-webui,comfyui,lora-script中共用的

#版本切换模块
function git_checkout_manager()
{
    commit_lists=$(git log --date=short --pretty=format:"%H %cd" --date=format:"%Y-%m-%d|%H:%M:%S" | awk -F  ' ' ' {print $1 " " $2} ')

    commit_selection=$(
        dialog --clear --yes-label "确认" --no-label "取消" --title "版本管理" \
        --menu "使用上下键选择要切换的版本并回车确认\n当前版本:\n$(git show -s --format="%H %cd" --date=format:"%Y-%m-%d %H:%M:%S")" 20 70 10 \
        $commit_lists \
        3>&1 1>&2 2>&3)

    if [ "$?" = "0" ];then
        git checkout $commit_selection
    fi
    cd ..
}

#一键更新全部插件功能
function extension_all_update()
{
    echo "更新插件"
    for extension_folder in ./*
    do
        [ -f "$extension_folder" ] && continue #排除文件
        cd "$extension_folder"
        echo "更新"$extension_folder"插件中"
        git pull
        cd ..
    done
}

###############################################################################

#启动程序部分

term_sd_version_="0.3.3"

if [ $(uname -o) = "Msys" ];then #为了兼容windows系统
    test_python="python"
else
    test_python="python3"
fi

#显示版本信息
function term_sd_version()
{
    dialog --clear --title "版本信息" --msgbox "系统:$(uname -o) \n
Term-SD:"$term_sd_version_" \n
python:$($test_python --version | awk 'NR==1'| awk -F  ' ' ' {print  " " $2} ') \n
pip:$(pip --version | awk 'NR==1'| awk -F  ' ' ' {print  " " $2} ') \n
aria2:$(aria2c --version | awk 'NR==1'| awk -F  ' ' ' {print  " " $3} ') \n
git:$(git --version | awk 'NR==1'| awk -F  ' ' ' {print  " " $3} ') \n
dialog:$(dialog --version | awk 'NR==1'| awk -F  ' ' ' {print  " " $2} ') \n
\n
提示: \n
使用方向键、Tab键、Enter进行选择，Space键勾选或取消选项 \n
Ctrl+C可中断指令的运行 \n
第一次使用Term-SD时先在主界面选择“关于”查看使用说明" 20 60
    mainmenu
}

#判断系统是否安装必须使用的软件
echo "检测依赖软件是否安装"
test_num=0
if which dialog > /dev/null ;then
    test_num=$(( $test_num + 1 ))
else
    echo "未安装dialog"
fi

if which aria2c > /dev/null ;then
    test_num=$(( $test_num + 1 ))
else
    echo "未安装aria2"
fi

if which $test_python > /dev/null;then
    test_num=$(( $test_num + 1 ))
else
    echo "未安装python"
fi

if which pip >/dev/null;then
    test_num=$(( $test_num + 1 ))
else
    echo "未安装pip"
fi

if which git > /dev/null;then
    test_num=$(( $test_num + 1 ))
else
    echo "未安装git"
fi


#启动term-sd

if [ $test_num -ge 5 ];then
    echo "初始化Term-SD完成"
    echo "启动Term-SD中"
    term_sd_version
else
    echo "未满足依赖要求,请安装后重试"
    exit
fi
