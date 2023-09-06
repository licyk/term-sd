#/bin/bash

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
        dialog --clear --title "Term-SD" --backtitle "安装代理选项" --separate-output --notags --title "代理选择" --ok-label "确认" --no-cancel --checklist "请选择代理(强制使用pip一般情况下不选)" 20 60 10 \
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
        dialog --clear --title "Term-SD" --backtitle "pytorch安装版本选项" --ok-label "确认" --no-cancel --menu "请选择要安装的pytorch版本" 20 60 10 \
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
        dialog --clear --title "Term-SD" --backtitle "pip安装模式选项" --ok-label "确认" --no-cancel --menu "请选择pip安装方式\n1、常规安装可能会有问题,但速度较快\n2、标准构建安装可解决一些报错问题,但速度较慢" 20 60 10 \
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
" 20 60);then
        echo "安装参数设置完成"
    else
        mainmenu
    fi
}