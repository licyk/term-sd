#!/bin/bash

# 安装前镜像选择(后面加上auto_github_mirrror参数将自动勾选"github镜像源自动选择")
download_mirror_select()
{
    local download_mirror_select_dialog
    local auto_select_github_mirror=1
    pip_index_mirror="--index-url https://pypi.python.org/simple"
    pip_extra_index_mirror=
    pip_find_mirror="--find-links https://download.pytorch.org/whl/torch_stable.html"
    pip_break_system_package=
    only_hugggingface_proxy=1
    use_modelscope_model=1
    github_mirror="https://github.com/term_sd_git_user/term_sd_git_repo"
    github_mirror_name="官方源(github.com)"

    download_mirror_select_dialog=$(
        dialog --erase-on-exit --notags --title "Term-SD" --backtitle "安装镜像选项" --title "Term-SD" --ok-label "确认" --no-cancel --checklist "请选择镜像\n注:\n1、当同时启用多个github镜像源时,优先选择最下面的github镜像源;勾选\"github镜像源自动选择\"时,将覆盖手动设置的github镜像源\n2、强制使用pip一般情况下不选" $term_sd_dialog_height $term_sd_dialog_width $term_sd_dialog_menu_height \
        "1" "启用pip镜像源(使用pip国内镜像源下载python软件包)" ON \
        "2" "强制使用pip(无视系统警告强制使用pip安装python软件包)" OFF \
        "3" "使用modelscope模型下载源(将huggingface下载源改为modelscope下载源)" ON \
        "4" "huggingface下载源独占代理(仅在下载huggingface的模型的过程启用代理)" ON \
        "5" "github镜像源自动选择(测试可用的镜像源并选择自动选择)" $([ ! -z $1 ] && [ $1 = "auto_github_mirrror" ] && echo "ON" || echo "OFF") \
        "6" "启用github镜像源1(使用ghproxy镜像站下载github上的源码)" OFF \
        "7" "启用github镜像源2(使用gitclone镜像站下载github上的源码)" $([ ! -z $1 ] && [ $1 = "auto_github_mirrror" ] && echo "OFF" || echo "ON") \
        "8" "启用github镜像源3(使用gh-proxy镜像站下载github上的源码)" OFF \
        "9" "启用github镜像源4(使用ghps镜像站下载github上的源码)" OFF \
        "10" "启用github镜像源5(使用gh.idayer镜像站下载github上的源码)" OFF \
        3>&1 1>&2 2>&3)

    for i in $download_mirror_select_dialog; do
        case $i in
            1)
                pip_index_mirror="--index-url https://mirrors.bfsu.edu.cn/pypi/web/simple"
                pip_extra_index_mirror="--extra-index-url https://mirrors.hit.edu.cn/pypi/web/simple --extra-index-url https://pypi.tuna.tsinghua.edu.cn/simple --extra-index-url https://mirror.nju.edu.cn/pypi/web/simple"
                pip_find_mirror="--find-links https://mirrors.aliyun.com/pytorch-wheels/torch_stable.html --find-links https://mirror.sjtu.edu.cn/pytorch-wheels/torch_stable.html"
                ;;
            2)
                pip_break_system_package="--break-system-packages"
                ;;
            3)
                use_modelscope_model=0
                ;;
            4)
                only_hugggingface_proxy=0
                ;;
            5)
                auto_select_github_mirror=0
                ;;
            6)
                github_mirror="https://ghproxy.com/https://github.com/term_sd_git_user/term_sd_git_repo"
                github_mirror_name="镜像源1(ghproxy.com)"
                ;;
            7)
                github_mirror="https://gitclone.com/github.com/term_sd_git_user/term_sd_git_repo"
                github_mirror_name="镜像源2(gitclone.com)"
                ;;
            8)
                github_mirror="https://gh-proxy.com/https://github.com/term_sd_git_user/term_sd_git_repo"
                github_mirror_name="镜像源3(gh-proxy.com)"
                ;;
            9)
                github_mirror="https://ghps.cc/https://github.com/term_sd_git_user/term_sd_git_repo"
                github_mirror_name="镜像源4(ghps.cc)"
                ;;
            10)
                github_mirror="https://gh.idayer.com/https://github.com/term_sd_git_user/term_sd_git_repo"
                github_mirror_name="镜像源5(gh.idayer.com)"
                ;;
        esac
    done

    if [ $auto_select_github_mirror = 0 ];then # 测试可用的镜像源
        term_sd_echo "测试可用的github镜像源中"
        github_mirror=$(github_mirror_test)
        github_mirror_name="镜像源($(echo $github_mirror | awk '{sub("https://","")}1' | awk -F '/' '{print$NR}'))"
        term_sd_echo "镜像源测试结束,镜像源选择: $github_mirror_name"
    fi
}

# pytorch安装版本选择
pytorch_version_select()
{
    local pytorch_version_select_dialog
    pytorch_install_version=

    pytorch_version_select_dialog=$(
        dialog --erase-on-exit --notags --title "Term-SD" --backtitle "pytorch安装版本选项" --ok-label "确认" --no-cancel --menu "请选择要安装的pytorch版本" $term_sd_dialog_height $term_sd_dialog_width $term_sd_dialog_menu_height \
        "1" "> Torch+xformers" \
        "2" "> Torch" \
        "3" "> Torch 2.0.0+Torch-Directml" \
        "4" "> Torch 2.1.0+CPU" \
        "5" "> Torch 2.0.1+RoCM 5.4.2" \
        "6" "> Torch 2.1.0+RoCM 5.6" \
        "7" "> Torch 1.12.1(CUDA11.3)+xFormers 0.014" \
        "8" "> Torch 1.13.1(CUDA11.7)+xFormers 0.016" \
        "9" "> Torch 2.0.0(CUDA11.8)+xFormers 0.018" \
        "10" "> Torch 2.0.1(CUDA11.8)+xFormers 0.022" \
        "11" "> Torch 2.1.0(CUDA12.1)+xFormers 0.0.22.post7" \
        "20" "> 跳过安装Torch" \
        3>&1 1>&2 2>&3)

    case $pytorch_version_select_dialog in
        20)
            pytorch_install_version=
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
            pytorch_install_version="torch==2.0.1+rocm5.4.2 torchvision==0.15.2+rocm5.4.2"
            ;;
        6)
            pytorch_install_version="torch==2.1.0+rocm5.6 torchvision==0.16.0+rocm5.6"
            ;;
        7)
            pytorch_install_version="torch==1.12.1+cu113 torchvision==0.13.1+cu113 xformers==0.0.14"
            ;;
        8)
            pytorch_install_version="torch==1.13.1+cu117 torchvision==0.14.1+cu117 xformers==0.0.16"
            ;;
        9)
            pytorch_install_version="torch==2.0.0+cu118 torchvision==0.15.1+cu118 xformers==0.0.18"
            ;;
        10)
            pytorch_install_version="torch==2.0.1+cu118 torchvision==0.15.2+cu118 xformers==0.0.22"
            ;;
        11)
            pytorch_install_version="torch==2.1.0+cu121 torchvision==0.16.0+cu121 xformers==0.0.22.post7"
            ;;
    esac
}

# pip安装模式选择
pip_install_mode_select()
{
    local pip_install_methon_dialog
    pip_install_mode=

    pip_install_methon_dialog=$(
        dialog --erase-on-exit --notags --title "Term-SD" --backtitle "pip安装模式选项" --ok-label "确认" --no-cancel --menu "请选择pip安装方式\n1、常规安装可能会有问题,但速度较快\n2、标准构建安装可解决一些报错问题,但速度较慢(对安装时间不在意的话推荐启用)" $term_sd_dialog_height $term_sd_dialog_width $term_sd_dialog_menu_height \
        "1" "> 常规安装(setup.py)" \
        "2" "> 标准构建安装(--use-pep517)" \
        3>&1 1>&2 2>&3)

    case $pip_install_methon_dialog in
        1)
            pip_install_mode=
            ;;
        2)
            pip_install_mode="--use-pep517"
            ;;
    esac
}

# 安装前确认界面
term_sd_install_confirm()
{
    if (dialog --erase-on-exit --title "Term-SD" --backtitle "安装确认选项" --yes-label "是" --no-label "否" --yesno "是否进行安装? \n
pip镜像源:$([ -z "$pip_extra_index_mirror" ] && echo "禁用" || echo "启用")\n
github镜像:$github_mirror_name\n
huggingface下载源独占代理:$([ $only_hugggingface_proxy = 0 ] && echo "启用" || echo "禁用")\n
使用modelscope模型下载源:$([ $use_modelscope_model = 0 ] && echo "启用" || echo "禁用")\n
强制使用pip:$([ -z "$pip_break_system_package" ] && echo "禁用" || echo "启用")\n
pytorch版本:$([ ! -z "$(echo $pytorch_install_version | awk '{gsub(/[=+]/, "")}1')" ] && echo $pytorch_install_version || echo "无")\n
pip安装方式:$([ -z $pip_install_mode ] && echo "常规安装(setup.py)" || echo "标准构建安装(--use-pep517)")\n
" $term_sd_dialog_height $term_sd_dialog_width);then
        term_sd_echo "确认进行安装"
        return 0
    else
        term_sd_echo "取消安装"
        return 1
    fi
}

# github镜像源测试
github_mirror_test()
{
    # 镜像源列表
    local github_mirror_list="https://ghproxy.com/https://github.com/term_sd_git_user/term_sd_git_repo https://gh-proxy.com/https://github.com/term_sd_git_user/term_sd_git_repo https://ghps.cc/https://github.com/term_sd_git_user/term_sd_git_repo https://gh.idayer.com/https://github.com/term_sd_git_user/term_sd_git_repo https://gitclone.com/github.com/term_sd_git_user/term_sd_git_repo"
    local github_mirror_avaliable=1
    local git_req
    for i in $github_mirror_list ;do
        git clone $(git_format_repository_url $i https://github.com/licyk/empty) "$start_path/term-sd/github_mirror_test" --depth=1 > /dev/null 2>&1 # 测试镜像源是否正常连接
        git_req=$?
        rm -rf "$start_path/term-sd/github_mirror_test" > /dev/null 2>&1
        if [ $git_req = 0 ];then
            echo $i
            github_mirror_avaliable=0
            break
        fi
    done
    [ $github_mirror_avaliable = 1 ] && echo https://github.com/term_sd_git_user/term_sd_git_repo # 只有上面所有的镜像源无法使用才使用github源
}
