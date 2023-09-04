#/bin/bash

function mainmenu()
{
    echo "请选择AUTOMATIC1111-stable-diffusion-webui更新源"
    echo "1、github源"
    echo "2、镜像源"
    echo "3、退出"
    read -p "输入数字后回车==>" update_repo

    if [ -z $update_repo ];then
        echo "输入有误,请重试"
        mainmenu
    elif [ $update_repo = 1 ];then
        echo "选择github源"
        git -C "./stable-diffusion-webui" remote set-url origin "https://github.com/AUTOMATIC1111/stable-diffusion-webui.git"
        git -C "./stable-diffusion-webui/repositories/CodeFormer" remote set-url origin "https://github.com/sczhou/CodeFormer.git"
        git -C "./stable-diffusion-webui/repositories/BLIP" remote set-url origin "https://github.com/salesforce/BLIP.git"
        git -C "./stable-diffusion-webui/repositories/stable-diffusion-stability-ai" remote set-url origin "https://github.com/Stability-AI/stablediffusion.git"
        git -C "./stable-diffusion-webui/repositories/generative-models" remote set-url origin "https://github.com/Stability-AI/generative-models.git"
        git -C "./stable-diffusion-webui/repositories/k-diffusion" remote set-url origin "https://github.com/crowsonkb/k-diffusion.git"
        echo "已切换为github源"
    elif [ $update_repo = 2 ];then
        echo "选择镜像源"
        git -C "./stable-diffusion-webui" remote set-url origin "https://ghproxy.com/https://github.com/AUTOMATIC1111/stable-diffusion-webui.git"
        git -C "./stable-diffusion-webui/repositories/CodeFormer" remote set-url origin "https://ghproxy.com/https://github.com/sczhou/CodeFormer.git"
        git -C "./stable-diffusion-webui/repositories/BLIP" remote set-url origin "https://ghproxy.com/https://github.com/salesforce/BLIP.git"
        git -C "./stable-diffusion-webui/repositories/stable-diffusion-stability-ai" remote set-url origin "https://ghproxy.com/https://github.com/Stability-AI/stablediffusion.git"
        git -C "./stable-diffusion-webui/repositories/generative-models" remote set-url origin "https://ghproxy.com/https://github.com/Stability-AI/generative-models.git"
        git -C "./stable-diffusion-webui/repositories/k-diffusion" remote set-url origin "https://ghproxy.com/https://github.com/crowsonkb/k-diffusion.git"
        echo "已切换为镜像源"
    elif [ $update_repo = 3 ];then
        echo "退出"
        exit 1
    else
        echo "输入有误,请重试"
        mainmenu
    fi
}

if [ -d "./stable-diffusion-webui" ];then
    mainmenu
else
    echo "当前目录未找到stable-diffusion-webui文件夹"
fi