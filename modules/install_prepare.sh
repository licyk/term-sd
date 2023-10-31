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
    use_modelscope_model=1
    use_modelscope_model_info="禁用"
    final_install_check_force_pip="禁用"

    proxy_option_dialog=$(
        dialog --erase-on-exit --title "Term-SD" --backtitle "安装代理选项" --separate-output --notags --title "Term-SD" --ok-label "确认" --no-cancel --checklist "请选择代理\n注:\n1、当同时启用两个github代理源时,将使用第二个github代理源\n2、强制使用pip一般情况下不选" 25 80 10 \
        "1" "启用pip镜像源(使用pip国内镜像源下载python软件包)" ON \
        "2" "启用github代理源1(使用ghproxy代理站下载github上的源码)" ON \
        "3" "启用github代理源2(使用gitclone代理站下载github上的源码)" OFF \
        "4" "huggingface独占代理(仅在下载huggingface的模型的过程启用代理)" ON \
        "5" "使用modelscope模型下载源(将huggingface下载源改为modelscope下载源)" ON \
        "6" "强制使用pip(无视系统警告强制使用pip安装python软件包)" OFF \
        3>&1 1>&2 2>&3)

    if [ $? = 0 ]; then
        for i in $proxy_option_dialog; do
            case "$i" in
                1)
                    #pip_mirror="-i https://mirror.sjtu.edu.cn/pypi/web/simple" #上海交大的镜像源有点问题,在安装invokeai时会报错,可能是软件包版本的问题
                    #extra_pip_mirror="-f https://mirror.sjtu.edu.cn/pytorch-wheels/torch_stable.html"
                    pip_index_mirror="--index-url https://mirrors.bfsu.edu.cn/pypi/web/simple"
                    pip_extra_index_mirror="--extra-index-url https://mirrors.hit.edu.cn/pypi/web/simple --extra-index-url https://pypi.tuna.tsinghua.edu.cn/simple --extra-index-url https://mirror.nju.edu.cn/pypi/web/simple"
                    pip_find_mirror="--find-links https://mirrors.aliyun.com/pytorch-wheels/torch_stable.html --find-links https://mirror.sjtu.edu.cn/pytorch-wheels/torch_stable.html"
                    final_install_check_python="启用"
                    ;;
                2)
                    github_proxy="https://ghproxy.com/"
                    final_install_check_github="启用代理源1"
                    ;;
                3)
                    github_proxy="https://gitclone.com/"
                    final_install_check_github="启用代理源2"
                    ;;
                4)
                    only_hugggingface_proxy=0
                    only_hugggingface_proxy_info="启用"
                    ;;
                5)
                    use_modelscope_model=0
                    use_modelscope_model_info="启用"
                    ;;
                6)
                    force_pip="--break-system-packages"
                    final_install_check_force_pip="启用"
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
        dialog --erase-on-exit --title "Term-SD" --backtitle "pytorch安装版本选项" --ok-label "确认" --no-cancel --menu "请选择要安装的pytorch版本" 25 80 10 \
        "1" "Torch+xformers" \
        "2" "Torch" \
        "3" "Torch 2.0.0+Torch-Directml" \
        "4" "Torch 2.1.0+CPU" \
        "5" "Torch 2.1.0+RoCM 5.6" \
        "6" "Torch 1.12.1(CUDA11.3)+xFormers 0.014" \
        "7" "Torch 1.13.1(CUDA11.7)+xFormers 0.016" \
        "8" "Torch 2.0.0(CUDA11.8)+xFormers 0.018" \
        "9" "Torch 2.0.1(CUDA11.8)+xFormers 0.022" \
        "10" "Torch 2.1.0(CUDA12.1)+xFormers 0.0.22.post7" \
        "20" "跳过安装" \
        3>&1 1>&2 2>&3)

    if [ $? = 0 ];then
        case $pytorch_version_select_dialog in
            20)
                pytorch_install_version=""
                ;;
            1)
                pytorch_install_version="torch torchvision xformers"
                ;;
            2)
                pytorch_install_version="torch torchvision"
                ;;
            3)
                pytorch_install_version="torch==2.0.0 torchvision==0.15.1 torch-directml"
                ;;
            4)
                pytorch_install_version="torch==2.1.0+cpu torchvision==0.16.0+cpu"
                ;;
            5)
                pytorch_install_version="torch==2.1.0+rocm5.6 torchvision==0.16.0+rocm5.6"
                ;;
            6)
                pytorch_install_version="torch==1.12.1+cu113 torchvision==0.13.1+cu113 xformers==0.0.14"
                ;;
            7)
                pytorch_install_version="torch==1.13.1+cu117 torchvision==0.14.1+cu117 xformers==0.0.16"
                ;;
            8)
                pytorch_install_version="torch==2.0.0+cu118 torchvision==0.15.1+cu118 xformers==0.0.18"
                ;;
            9)
                pytorch_install_version="torch==2.0.1+cu118 torchvision==0.15.2+cu118 xformers==0.0.22"
                ;;
            10)
                pytorch_install_version="torch==2.1.0+cu121 torchvision==0.16.0+cu121 xformers==0.0.22.post7"
                ;;
        esac
    fi
}

#pip安装模式选择
function pip_install_methon()
{
    pip_install_methon_select=""
    final_install_check_pip_methon="常规安装(setup.py)"

    pip_install_methon_dialog=$(
        dialog --erase-on-exit --title "Term-SD" --backtitle "pip安装模式选项" --ok-label "确认" --no-cancel --menu "请选择pip安装方式\n1、常规安装可能会有问题,但速度较快\n2、标准构建安装可解决一些报错问题,但速度较慢" 25 80 10 \
        "1" "常规安装(setup.py)" \
        "2" "标准构建安装(--use-pep517)" \
        3>&1 1>&2 2>&3)

    if [ $? = 0 ];then
        case $pip_install_methon_dialog in
            1)
                pip_install_methon_select=""
                final_install_check_pip_methon="常规安装(setup.py)"
                ;;
            2)
                pip_install_methon_select="--use-pep517"
                final_install_check_pip_methon="标准构建安装(--use-pep517)"
                ;;
        esac
    fi
}

#安装前确认界面
function final_install_check()
{
    if (dialog --erase-on-exit --title "Term-SD" --backtitle "安装确认选项" --yes-label "是" --no-label "否" --yesno "是否进行安装? \n
pip镜像源:$final_install_check_python \n
github代理:$final_install_check_github\n
huggingface独占代理:$only_hugggingface_proxy_info\n
使用modelscope模型下载源:$use_modelscope_model_info\n
强制使用pip:$final_install_check_force_pip\n
pytorch:$([ ! -z "$(echo $pytorch_install_version | awk '{gsub(/[=+]/, "")}1')" ] && echo $pytorch_install_version || echo "无")\n
pip安装方式:$final_install_check_pip_methon\n
" 25 80);then
        term_sd_notice "安装参数设置完成"
        export final_install_check_exec=0 #声明是否进行安装
    else
        export final_install_check_exec=1
    fi
}
