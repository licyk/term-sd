#!/bin/bash

#安装前代理选择
function proxy_option()
{
    pip_index_mirror="--index-url https://pypi.python.org/simple"
    pip_extra_index_mirror=""
    pip_find_mirror="--find-links https://download.pytorch.org/whl/torch_stable.html"
    #extra_pip_mirror="--extra-index-url https://download.pytorch.org/whl"
    github_proxy=""
    force_pip=""
    only_hugggingface_proxy=1
    final_install_check_python="禁用"
    final_install_check_github="禁用"
    only_hugggingface_proxy_info="禁用"
    final_install_check_force_pip="禁用"

    proxy_option_dialog=$(
        dialog --clear --title "Term-SD" --backtitle "安装代理选项" --separate-output --notags --title "Term-SD" --ok-label "确认" --no-cancel --checklist "请选择代理(强制使用pip一般情况下不选)" 25 70 10 \
        "1" "启用pip镜像源" ON \
        "2" "启用github代理" ON \
        "3" "huggingface独占代理" ON \
        "4" "强制使用pip" OFF \
        3>&1 1>&2 2>&3)

    if [ ! -z "$proxy_option_dialog" ]; then
        for proxy_option_dialog_ in $proxy_option_dialog; do
        case "$proxy_option_dialog_" in
        "1")
        #pip_mirror="-i https://mirror.sjtu.edu.cn/pypi/web/simple" #上海交大的镜像源有点问题,在安装invokeai时会报错,可能是软件包版本的问题
        #extra_pip_mirror="-f https://mirror.sjtu.edu.cn/pytorch-wheels/torch_stable.html"
        pip_index_mirror="--index-url https://mirrors.bfsu.edu.cn/pypi/web/simple"
        pip_extra_index_mirror="--extra-index-url https://mirrors.hit.edu.cn/pypi/web/simple --extra-index-url https://pypi.tuna.tsinghua.edu.cn/simple --extra-index-url https://mirrors.pku.edu.cn/pypi/web/simple"
        pip_find_mirror="--find-links https://mirrors.aliyun.com/pytorch-wheels/torch_stable.html --find-links https://mirror.sjtu.edu.cn/pytorch-wheels/torch_stable.html"
        final_install_check_python="启用"
        ;;
        "2")
        github_proxy="https://ghproxy.com/"
        final_install_check_github="启用"
        ;;
        "3")
        only_hugggingface_proxy=0
        only_hugggingface_proxy_info="启用"
        ;;
        "4")
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

    pytorch_version_select_dialog=$(
        dialog --clear --title "Term-SD" --backtitle "pytorch安装版本选项" --ok-label "确认" --no-cancel --menu "请选择要安装的pytorch版本" 25 70 10 \
        "0" "Torch+xformers" \
        "1" "Torch" \
        "2" "Torch 2.0.0+Torch-Directml" \
        "3" "Torch 2.1.0+CPU" \
        "4" "Torch 2.1.0+RoCM 5.6" \
        "5" "Torch 1.12.1(CUDA11.3)+xFormers 0.014" \
        "6" "Torch 1.13.1(CUDA11.7)+xFormers 0.016" \
        "7" "Torch 2.0.0(CUDA11.8)+xFormers 0.018" \
        "8" "Torch 2.0.1(CUDA11.8)+xFormers 0.022" \
        "9" "Torch 2.1.0(CUDA12.1)+xFormers 0.022" \
        "20" "跳过安装" \
        3>&1 1>&2 2>&3)

    if [ $pytorch_version_select_dialog = 20 ]; then
        pytorch_install_version=""
    elif [ $pytorch_version_select_dialog = 0 ]; then
        pytorch_install_version="torch torchvision xformers"
    elif [ $pytorch_version_select_dialog = 1 ]; then
        pytorch_install_version="torch torchvision"
    elif [ $pytorch_version_select_dialog = 2 ]; then
        pytorch_install_version="torch==2.0.0 torchvision==0.15.1 torch-directml"
    elif [ $pytorch_version_select_dialog = 3 ]; then
        pytorch_install_version="torch==2.1.0+cpu torchvision==0.16.0+cpu"
    elif [ $pytorch_version_select_dialog = 4 ]; then
        pytorch_install_version="torch==2.1.0+rocm5.6 torchvision==0.16.0+rocm5.6"
    elif [ $pytorch_version_select_dialog = 5 ]; then
        pytorch_install_version="torch==1.12.1+cu113 torchvision==0.13.1+cu113 xformers==0.0.14"
    elif [ $pytorch_version_select_dialog = 6 ]; then
        pytorch_install_version="torch==1.13.1+cu117 torchvision==0.14.1+cu117 xformers==0.0.16"
    elif [ $pytorch_version_select_dialog = 7 ]; then
        pytorch_install_version="torch==2.0.0+cu118 torchvision==0.15.1+cu118 xformers==0.0.18"
    elif [ $pytorch_version_select_dialog = 8 ]; then
        pytorch_install_version="torch==2.0.1+cu118 torchvision==0.15.2+cu118 xformers==0.0.22"
    elif [ $pytorch_version_select_dialog = 9 ]; then
        pytorch_install_version="torch==2.1.0+cu121 torchvision==0.16.0+cu121 xformers==0.0.22"
    fi
}

#pip安装模式选择
function pip_install_methon()
{
    pip_install_methon_select=""
    final_install_check_pip_methon="常规安装(setup.py)"

    pip_install_methon_dialog=$(
        dialog --clear --title "Term-SD" --backtitle "pip安装模式选项" --ok-label "确认" --no-cancel --menu "请选择pip安装方式\n1、常规安装可能会有问题,但速度较快\n2、标准构建安装可解决一些报错问题,但速度较慢" 25 70 10 \
        "1" "常规安装(setup.py)" \
        "2" "标准构建安装(--use-pep517)" \
        3>&1 1>&2 2>&3)

    if [ $pip_install_methon_dialog = 1 ];then
        pip_install_methon_select=""
        final_install_check_pip_methon="常规安装(setup.py)"
    elif [ $pip_install_methon_dialog = 2 ];then
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
huggingface独占代理:$only_hugggingface_proxy_info\n
强制使用pip:$final_install_check_force_pip\n
pytorch:$([ ! -z "$(echo $pytorch_install_version | awk '{gsub(/[=+]/, "")}1')" ] && echo $pytorch_install_version || echo "无")\n
pip安装方式:$final_install_check_pip_methon\n
" 25 70);then
        term_sd_notice "安装参数设置完成"
        export final_install_check_exec=0 #声明是否进行安装
    else
        export final_install_check_exec=1
    fi
}