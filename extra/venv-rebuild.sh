#!/bin/bash

#设置启动时脚本路径
export start_path=$(pwd)

#主界面
function mainmenu()
{
    cd "$start_path" #回到最初路径
    exit_venv 2> /dev/null #确保进行下一步操作前已退出其他虚拟环境

    mainmenu_=$(dialog --clear --title "Term-SD" --backtitle "主界面" --yes-label "确认" --no-label "取消" --menu "请选择Term-SD的功能\n当前目录可用空间:$(df ./ -h |awk 'NR==2'|awk -F ' ' ' {print $4} ')" 22 70 12 \
        "1" "AUTOMATIC1111-stable-diffusion-webui管理" \
        "2" "ComfyUI管理" \
        "3" "InvokeAI管理" \
        "4" "lora-scripts管理" \
        "5" "pip镜像源" \
        "6" "pip缓存清理" \
        "7" "退出" \
        3>&1 1>&2 2>&3)

    if [ $? = 0 ];then
        if [ $mainmenu_ = 1 ];then
            a1111_sd_webui_option
        elif [ $mainmenu_ = 2 ];then
            comfyui_option
        elif [ $mainmenu_ = 3 ];then
            invokeai_option
        elif [ $mainmenu_ = 4 ];then
            lora_scripts_option
        elif [ $mainmenu_ = 5 ];then
            set_pip_mirrors_option
        elif [ $mainmenu_ = 6 ];then
            pip_cache_clean
        elif [ $mainmenu_ = 7 ];then
            exit 1
        fi
    else
        exit 1
    fi
}

#a1111_sd_webui_option选项
function a1111_sd_webui_option()
{
    cd "$start_path" #回到最初路径
    exit_venv 2> /dev/null #确保进行下一步操作前已退出其他虚拟环境
    if [ -d "stable-diffusion-webui" ];then #找到stable-diffusion-webui目录
        cd stable-diffusion-webui
        if (dialog --clear --title "A1111-SD-Webui管理" --backtitle "A1111-SD-Webui虚拟环境重建选项" --yes-label "是" --no-label "否" --yesno "是否重建A1111-SD-Webui的虚拟环境" 22 70);then
            a1111_sd_webui_venv_rebuild
        fi
    else
        dialog --clear --title "A1111-SD-Webui管理" --backtitle "A1111-SD-Webui虚拟环境重建选项" --msgbox "当前目录下未找到A1111-SD-Webui" 22 70
    fi
    mainmenu
}

#comfyui选项
function comfyui_option()
{
    cd "$start_path" #回到最初路径
    exit_venv 2> /dev/null #确保进行下一步操作前已退出其他虚拟环境
    if [ -d "ComfyUI" ];then
        cd ComfyUI
        if (dialog --clear --title "ComfyUI管理" --backtitle "ComfyUI虚拟环境重建选项" --yes-label "是" --no-label "否" --yesno "是否重建ComfyUI的虚拟环境" 22 70);then
            comfyui_venv_rebuild
        fi
    else
        dialog --clear --title "ComfyUI管理" --backtitle "ComfyUI虚拟环境重建选项" --msgbox "当前目录下未找到ComfyUI" 22 70
    fi
    mainmenu
}

#InvokeAI选项
function invokeai_option()
{
    cd "$start_path" #回到最初路径
    exit_venv 2> /dev/null #确保进行下一步操作前已退出其他虚拟环境
    if [ -d "InvokeAI" ];then
        cd InvokeAI
        if (dialog --clear --title "InvokeAI管理" --backtitle "InvokeAI虚拟环境重建选项" --yes-label "是" --no-label "否" --yesno "是否重建InvokeAI的虚拟环境" 22 70);then
            invokeai_venv_rebuild
        fi
    else
        dialog --clear --title "InvokeAI管理" --backtitle "InvokeAI虚拟环境重建选项" --msgbox "当前目录下未找到InvokeAI" 22 70
    fi
    mainmenu
}

#lora-scripts选项
function lora_scripts_option()
{
    cd "$start_path" #回到最初路径
    exit_venv 2> /dev/null #确保进行下一步操作前已退出其他虚拟环境
    if [ -d "lora-scripts" ];then
        cd lora-scripts
        if (dialog --clear --title "lora-scripts管理" --backtitle "lora-scripts虚拟环境重建选项" --yes-label "是" --no-label "否" --yesno "是否重建lora-scripts的虚拟环境" 22 70);then
            lora_scripts_venv_rebuild
        fi
    else
        dialog --clear --title "lora-scripts管理" --backtitle "lora-scripts虚拟环境重建选项" --msgbox "当前目录下未找到lora-scripts" 22 70
    fi
    mainmenu
}

###############################################################################

#安装部分

#安装前代理选择
function proxy_option()
{
    pip_mirror="-i https://pypi.python.org/simple"
    extra_pip_mirror="-f https://download.pytorch.org/whl/torch_stable.html"
    #extra_pip_mirror="--extra-index-url https://download.pytorch.org/whl"
    github_proxy=""
    force_pip=""
    final_install_check_python="禁用"
    final_install_check_github="禁用"
    final_install_check_force_pip="禁用"

    final_proxy_options=$(
        dialog --clear --title "Term-SD" --backtitle "安装代理选项" --separate-output --notags --title "代理选择" --ok-label "确认" --no-cancel --checklist "请选择代理(强制使用pip一般情况下不选)" 22 70 12 \
        "1" "启用pip镜像源" ON \
        "2" "启用github代理" ON \
        "3" "强制使用pip" OFF 3>&1 1>&2 2>&3)

    if [ ! -z "$final_proxy_options" ]; then
        for final_proxy_option in $final_proxy_options; do
        case "$final_proxy_option" in
        "1")
        #pip_mirror="-i https://mirror.sjtu.edu.cn/pypi/web/simple" #上海交大的镜像源有点问题,在安装invokeai时会报错,可能是软件包版本的问题
        pip_mirror="-i https://mirrors.bfsu.edu.cn/pypi/web/simple"
        #extra_pip_mirror="-f https://mirror.sjtu.edu.cn/pytorch-wheels/torch_stable.html"
        extra_pip_mirror="-f https://mirrors.aliyun.com/pytorch-wheels/torch_stable.html"
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
function pytorch_version_select()
{
    pytorch_install_version=""

    final_pytorch_version_select=$(
        dialog --clear --title "Term-SD" --backtitle "pytorch安装版本选项" --ok-label "确认" --no-cancel --menu "请选择要安装的pytorch版本" 22 70 12 \
        "1" "Torch 2.0.1" \
        "2" "Torch 2.0.1+CPU" \
        "3" "Torch 2.0.0+Torch-Directml" \
        "4" "Torch 2.0.1+RoCM 5.4.2" \
        "5" "Torch 1.12.1(CUDA11.3)+xFormers 0.014" \
        "6" "Torch 1.13.1(CUDA11.7)+xFormers 0.016" \
        "7" "Torch 2.0.0(CUDA11.8)+xFormers 0.018" \
        "8" "Torch 2.0.1(CUDA11.8)+xFormers 0.020" \
        "9" "Torch 2.0.1(CUDA11.8)+xFormers 0.021" \
        "0" "跳过安装" \
        3>&1 1>&2 2>&3)

    if [ "${final_pytorch_version_select}" == '0' ]; then
        pytorch_install_version=""
    elif [ "${final_pytorch_version_select}" == '1' ]; then
        pytorch_install_version="torch==2.0.1 torchvision==0.15.2"
    elif [ "${final_pytorch_version_select}" == '2' ]; then
        pytorch_install_version="torch==2.0.1+cpu torchvision==0.15.2+cpu"
    elif [ "${final_pytorch_version_select}" == '3' ]; then
        pytorch_install_version="torch==2.0.0 torchvision==0.15.1 torch-directml"
    elif [ "${final_pytorch_version_select}" == '4' ]; then
        pytorch_install_version="torch==2.0.1+rocm5.4.2 torchvision==0.15.2+rocm5.4.2"
    elif [ "${final_pytorch_version_select}" == '5' ]; then
        pytorch_install_version="torch==1.12.1+cu113 torchvision==0.13.1+cu113 xformers==0.0.14"
    elif [ "${final_pytorch_version_select}" == '6' ]; then
        pytorch_install_version="torch==1.13.1+cu117 torchvision==0.14.1+cu117 xformers==0.0.16"
    elif [ "${final_pytorch_version_select}" == '7' ]; then
        pytorch_install_version="torch==2.0.0+cu118 torchvision==0.15.1+cu118 xformers==0.0.18"
    elif [ "${final_pytorch_version_select}" == '8' ]; then
        pytorch_install_version="torch==2.0.1+cu118 torchvision==0.15.2+cu118 xformers==0.0.20"
    elif [ "${final_pytorch_version_select}" == '9' ]; then
        pytorch_install_version="torch==2.0.1+cu118 torchvision==0.15.2+cu118 xformers==0.0.21"
    fi
}

#pip安装模式选择
function pip_install_methon()
{
    pip_install_methon_select=""
    final_install_check_pip_methon="常规安装(setup.py)"

    final_pip_install_methon=$(
        dialog --clear --title "Term-SD" --backtitle "pip安装模式选项" --ok-label "确认" --no-cancel --menu "请选择pip安装方式\n1、常规安装可能会有问题,但速度较快\n2、标准构建安装可解决一些报错问题,但速度较慢" 22 70 12 \
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

#安装前确认界面
function final_install_check()
{
    if (dialog --clear --title "Term-SD" --backtitle "安装确认选项" --yes-label "是" --no-label "否" --yesno "是否进行安装? \n
pip镜像源:$final_install_check_python \n
github代理:$final_install_check_github\n
强制使用pip:$final_install_check_force_pip\n
pytorch:$pytorch_install_version\n
pip安装方式:$final_install_check_pip_methon\n
" 22 70);then
        echo "安装参数设置完成"
    else
        mainmenu
    fi
}

###############################################################################

#重构功能部分

#a1111_sd_webui虚拟环境重构部分
function a1111_sd_webui_venv_rebuild()
{
    #安装前的准备
    proxy_option #代理选择
    pytorch_version_select #pytorch选择
    pip_install_methon #安装方式选择
    final_install_check #安装前确认
    echo "开始重构虚拟环境"
    echo "删除原有虚拟环境中"
    rm -rf ./venv
    echo "删除完成"
    venv_generate
    enter_venv

    pip install $pytorch_install_version $pip_mirror $extra_pip_mirror $force_pip $pip_install_methon_select --default-timeout=100 --retries 5 #"--default-timeout=100 --retries 5"在网络差导致下载中断时重试下载
    pip install git+"$github_proxy"https://github.com/TencentARC/GFPGAN.git --prefer-binary $pip_mirror $extra_pip_mirror $force_pip $pip_install_methon_select --default-timeout=100 --retries 5
    pip install git+"$github_proxy"https://github.com/openai/CLIP.git --prefer-binary $pip_mirror $extra_pip_mirror $force_pip $pip_install_methon_select --default-timeout=100 --retries 5
    pip install git+"$github_proxy"https://github.com/mlfoundations/open_clip.git --prefer-binary $pip_mirror $extra_pip_mirror $force_pip $pip_install_methon_select --default-timeout=100 --retries 5
    pip install -r ./repositories/CodeFormer/requirements.txt --prefer-binary $pip_mirror $extra_pip_mirror $force_pip $pip_install_methon_select --default-timeout=100 --retries 5
    pip install -r ./requirements.txt --prefer-binary $pip_mirror $extra_pip_mirror $force_pip $pip_install_methon_select --default-timeout=100 --retries 5 #安装stable-diffusion-webui的依赖

    echo "重构结束"
    exit_venv
}

#comfyui虚拟环境重构部分
function comfyui_venv_rebuild()
{
    #安装前的准备
    proxy_option #代理选择
    pytorch_version_select #pytorch选择
    pip_install_methon #安装方式选择
    final_install_check #安装前确认
    echo "开始重构虚拟环境"
    echo "删除原有虚拟环境中"
    rm -rf ./venv
    echo "删除完成"
    venv_generate
    enter_venv

    pip install $pytorch_install_version $pip_mirror $extra_pip_mirror $force_pip $pip_install_methon_select --default-timeout=100 --retries 5
    pip install -r ./requirements.txt  --prefer-binary $pip_mirror $extra_pip_mirror $force_pip $pip_install_methon_select --default-timeout=100 --retries 5

    echo "重构结束"
    exit_venv
}

#invokeai虚拟环境重构部分
function invokeai_venv_rebuild()
{
    #安装前的准备
    proxy_option #代理选择
    pytorch_version_select #pytorch选择
    pip_install_methon #安装方式选择
    final_install_check #安装前确认
    echo "开始重构虚拟环境"
    echo "删除原有虚拟环境中"
    rm -rf ./venv
    echo "删除完成"
    venv_generate
    enter_venv

    pip install invokeai $pytorch_install_version $pip_mirror $extra_pip_mirror $force_pip $pip_install_methon_select --default-timeout=100 --retries 5

    echo "重构结束"
    exit_venv
}

#lora_scripts虚拟环境重构部分
function lora_scripts_venv_rebuild()
{
    #安装前的准备
    proxy_option #代理选择
    pytorch_version_select #pytorch选择
    pip_install_methon #安装方式选择
    final_install_check #安装前确认
    echo "开始重构虚拟环境"
    echo "删除原有虚拟环境中"
    rm -rf ./venv
    echo "删除完成"
    venv_generate
    enter_venv

    pip install $pytorch_install_version $pip_mirror $extra_pip_mirror $force_pip $pip_install_methon_select --default-timeout=100 --retries 5
    cd ./sd-scripts
    pip install $pip_mirror $extra_pip_mirror $force_pip $pip_install_methon_select --upgrade -r requirements.txt --default-timeout=100 --retries 5 #sd-scripts目录下还有个_typos.toml，在安装requirements.txt里的依赖时会指向这个文件
    cd ..
    pip install $pip_mirror $extra_pip_mirror $force_pip $pip_install_methon_select --upgrade lion-pytorch dadaptation prodigyopt lycoris-lora fastapi uvicorn wandb scipy --default-timeout=100 --retries 5
    pip install $pip_mirror $extra_pip_mirror $force_pip $pip_install_methon_select --upgrade -r requirements.txt --default-timeout=100 --retries 5 #lora-scripts安装依赖

    echo "重构结束"
    exit_venv
}


###############################################################################

#venv虚拟环境处理

function venv_generate()
{
    if [ $(uname -o) = "Msys" ];then #为了兼容windows系统
        echo "创建venv虚拟环境"
        python -m venv venv
    else
        echo "创建venv虚拟环境"
        python3 -m venv venv
    fi
}

function enter_venv()
{
    if [ $(uname -o) = "Msys" ];then #为了兼容windows系统
        echo "进入venv虚拟环境"
        source ./venv/Scripts/activate
    else
        echo "进入venv虚拟环境"
        source ./venv/bin/activate
    fi
}

function exit_venv()
{
    echo "退出venv虚拟环境"
    deactivate
}

###############################################################################

#其他功能

#pip镜像源选项
function set_pip_mirrors_option()
{
    echo "获取pip全局配置"
    if (dialog --clear --title "Term-SD" --backtitle "pip镜像源选项" --yes-label "是" --no-label "否" --yesno "pip全局配置:\n$(pip config list)\n是否启用pip镜像源?" 22 70) then
        #pip config set global.index-url "https://mirror.sjtu.edu.cn/pypi/web/simple"
        pip config set global.index-url "https://mirrors.bfsu.edu.cn/pypi/web/simple"
        #pip config set global.extra-index-url "https://mirror.sjtu.edu.cn/pytorch-wheels"
        #pip config set global.extra-index-url "https://mirrors.aliyun.com/pytorch-wheels"
        pip config set global.find-links "https://mirrors.aliyun.com/pytorch-wheels/torch_stable.html"
    else
        pip config unset global.index-url
        pip config unset global.find-links
    fi
    mainmenu
}

#pip缓存清理功能
function pip_cache_clean()
{
    echo "统计pip缓存信息中"
    if (dialog --clear --title "Term-SD" --backtitle "pip缓存清理选项" --yes-label "是" --no-label "否" --yesno "pip缓存信息:\npip缓存路径:$(pip cache dir)\n包索引页面缓存大小:$(pip cache info |awk NR==2 | awk -F ':'  '{print $2 $3 $4}')\n本地构建的wheel包大小:$(pip cache info |awk NR==5 | awk -F ':'  '{print $2 $3 $4}')\n是否删除pip缓存?" 22 70);then
        pip cache purge
    fi
    mainmenu
}

###############################################################################
#启动部分

mainmenu