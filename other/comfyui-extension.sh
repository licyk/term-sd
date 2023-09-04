#/bin/bash

#安装前代理选择
function proxy_option()
{
    python_proxy="-i https://pypi.python.org/simple"
    extra_python_proxy="-f https://download.pytorch.org/whl/torch_stable.html"
    #extra_python_proxy="--extra-index-url https://download.pytorch.org/whl"
    github_proxy=""
    force_pip=""
    final_install_check_python="禁用"
    final_install_check_github="禁用"
    final_install_check_force_pip="禁用"

    final_proxy_options=$(
        dialog --clear --title "Term-SD" --backtitle "安装代理选项" --separate-output --notags --title "代理选择" --ok-label "确认" --no-cancel --checklist "请选择代理(强制使用pip一般情况下不选)" 20 60 10 \
        "1" "启用pip镜像源" OFF \
        "2" "启用github代理" ON \
        "3" "强制使用pip" OFF 3>&1 1>&2 2>&3)

    if [ ! -z "$final_proxy_options" ]; then
        for final_proxy_option in $final_proxy_options; do
        case "$final_proxy_option" in
        "1")
        #python_proxy="-i https://mirror.sjtu.edu.cn/pypi/web/simple" #上海交大的镜像源有点问题,在安装invokeai时会报错,可能是软件包版本的问题
        python_proxy="-i https://mirrors.bfsu.edu.cn/pypi/web/simple"
        #extra_python_proxy="-f https://mirror.sjtu.edu.cn/pytorch-wheels/torch_stable.html"
        extra_python_proxy="-f https://mirrors.aliyun.com/pytorch-wheels/torch_stable.html"
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

#comfyui插件选择
function comfyui_extension_option()
{
    #清空插件选择
    extension_install_list=""

    extension_list=$(
        dialog --clear --title "Term-SD" --backtitle "ComfyUI插件安装选项" --separate-output --notags --ok-label "确认" --no-cancel --checklist "请选择要安装的ComfyUI插件" 20 60 10 \
        "1" "ComfyUI-extensions" OFF \
        "2" "graphNavigator" OFF \
        3>&1 1>&2 2>&3)

    if [ ! -z "$extension_list" ]; then
        for extension_list_ in $extension_list; do
        case "$extension_list_" in
        "1")
        extension_install_list="https://github.com/diffus3/ComfyUI-extensions $extension_install_list"
        ;;
        "2")
        extension_install_list="https://github.com/rock-land/graphNavigator $extension_install_list"
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
    #清空插件选择
    custom_node_install_list=""
    extension_model_1="1"

    extension_list=$(
        dialog --clear --title "Term-SD" --backtitle "ComfyUI自定义节点安装选项" --separate-output --notags --ok-label "确认" --no-cancel --checklist "请选择要安装的ComfyUI自定义节点" 20 60 10 \
        "1" "was-node-suite-comfyui" OFF \
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
        "23" "rembg-comfyui-node" OFF \
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
        "38" "comfyui_controlnet_aux" OFF \
        "39" "AIGODLIKE-COMFYUI-TRANSLATION" OFF \
        3>&1 1>&2 2>&3)

    if [ ! -z "$extension_list" ]; then
        for extension_list_ in $extension_list; do
        case "$extension_list_" in
        "1")
        custom_node_install_list="https://github.com/WASasquatch/was-node-suite-comfyui $custom_node_install_list"
        ;;
        "2")
        custom_node_install_list="https://github.com/BlenderNeko/ComfyUI_Cutoff $custom_node_install_list"
        ;;
        "3")
        custom_node_install_list="https://github.com/BlenderNeko/ComfyUI_TiledKSampler $custom_node_install_list"
        ;;
        "4")
        custom_node_install_list="https://github.com/BlenderNeko/ComfyUI_ADV_CLIP_emb $custom_node_install_list"
        ;;
        "5")
        custom_node_install_list="https://github.com/BlenderNeko/ComfyUI_Noise $custom_node_install_list"
        ;;
        "6")
        custom_node_install_list="https://github.com/Davemane42/ComfyUI_Dave_CustomNode $custom_node_install_list"
        ;;
        "7")
        custom_node_install_list="https://github.com/ltdrdata/ComfyUI-Impact-Pack $custom_node_install_list"
        ;;
        "8")
        custom_node_install_list="https://github.com/ltdrdata/ComfyUI-Manager $custom_node_install_list"
        ;;
        "9")
        custom_node_install_list="https://github.com/Zuellni/ComfyUI-Custom-Nodes $custom_node_install_list"
        ;;
        "10")
        custom_node_install_list="https://github.com/pythongosssss/ComfyUI-Custom-Scripts $custom_node_install_list"
        ;;
        "11")
        custom_node_install_list="https://github.com/xXAdonesXx/NodeGPT $custom_node_install_list"
        ;;
        "12")
        custom_node_install_list="https://github.com/Derfuu/Derfuu_ComfyUI_ModdedNodes $custom_node_install_list"
        ;;
        "13")
        custom_node_install_list="https://github.com/LucianoCirino/efficiency-nodes-comfyui $custom_node_install_list"
        ;;
        "14")
        custom_node_install_list="https://github.com/lilly1987/ComfyUI_node_Lilly $custom_node_install_list"
        ;;
        "15")
        custom_node_install_list="https://github.com/hnmr293/ComfyUI-nodes-hnmr $custom_node_install_list"
        ;;
        "16")
        custom_node_install_list="https://github.com/diontimmer/ComfyUI-Vextra-Nodes $custom_node_install_list"
        ;;
        "17")
        custom_node_install_list="https://github.com/omar92/ComfyUI-QualityOfLifeSuit_Omar92 $custom_node_install_list"
        ;;
        "18")
        custom_node_install_list="https://github.com/Fannovel16/FN16-ComfyUI-nodes $custom_node_install_list"
        ;;
        "19")
        custom_node_install_list="https://github.com/BadCafeCode/masquerade-nodes-comfyui $custom_node_install_list"
        ;;
        "20")
        custom_node_install_list="https://github.com/EllangoK/ComfyUI-post-processing-nodes $custom_node_install_list"
        ;;
        "21")
        custom_node_install_list="https://github.com/LEv145/images-grid-comfy-plugin $custom_node_install_list"
        ;;
        "22")
        custom_node_install_list="https://github.com/biegert/ComfyUI-CLIPSeg $custom_node_install_list"
        ;;
        "23")
        custom_node_install_list="https://github.com/Jcd1230/rembg-comfyui-node $custom_node_install_list"
        ;;
        "24")
        custom_node_install_list="https://github.com/TinyTerra/ComfyUI_tinyterraNodes $custom_node_install_list"
        ;;
        "25")
        custom_node_install_list="https://github.com/guoyk93/yk-node-suite-comfyui $custom_node_install_list"
        ;;
        "26")
        custom_node_install_list="https://github.com/comfyanonymous/ComfyUI_experiments $custom_node_install_list"
        ;;
        "27")
        custom_node_install_list="https://github.com/gamert/ComfyUI_tagger $custom_node_install_list"
        ;;
        "28")
        custom_node_install_list="https://github.com/YinBailiang/MergeBlockWeighted_fo_ComfyUI $custom_node_install_list"
        ;;
        "29")
        custom_node_install_list="https://github.com/Kaharos94/ComfyUI-Saveaswebp $custom_node_install_list"
        ;;
        "30")
        custom_node_install_list="https://github.com/trojblue/trNodes $custom_node_install_list"
        ;;
        "31")
        custom_node_install_list="https://github.com/city96/ComfyUI_NetDist $custom_node_install_list"
        ;;
        "32")
        custom_node_install_list="https://github.com/SLAPaper/ComfyUI-Image-Selector $custom_node_install_list"
        ;;
        "33")
        custom_node_install_list="https://github.com/strimmlarn/ComfyUI-Strimmlarns-Aesthetic-Score $custom_node_install_list"
        ;;
        "34")
        custom_node_install_list="https://github.com/ssitu/ComfyUI_UltimateSDUpscale $custom_node_install_list"
        ;;
        "35")
        custom_node_install_list="https://github.com/space-nuko/ComfyUI-Disco-Diffusion $custom_node_install_list"
        ;;
        "36")
        custom_node_install_list="https://github.com/Bikecicle/ComfyUI-Waveform-Extensions $custom_node_install_list"
        ;;
        "37")
        custom_node_install_list="https://github.com/AlekPet/ComfyUI_Custom_Nodes_AlekPet $custom_node_install_list"
        ;;
        "38")
        custom_node_install_list="https://github.com/Fannovel16/comfyui_controlnet_aux $custom_node_install_list"
        extension_model_1=0
        ;;
        "39")
        custom_node_install_list="https://github.com/AIGODLIKE/AIGODLIKE-COMFYUI-TRANSLATION $custom_node_install_list"
        ;;
        *)
        exit 1
        ;;
        esac
        done
    fi
}

#comfyui安装处理部分
function process_install_comfyui()
{
    if [ ! -z "$extension_install_list" ];then
        echo "安装插件中"
        for extension_install_list_ in $extension_install_list ;do
            git clone "$github_proxy"$extension_install_list_ ./ComfyUI/web/extensions/$(echo $extension_install_list_ | awk -F'/' '{print $NF}')
        done
    fi

    if [ ! -z "$custom_node_install_list" ];then
        echo "安装自定义节点中"
        for custom_node_install_list_ in $custom_node_install_list ;do
            git clone "$github_proxy"$custom_node_install_list_ ./ComfyUI/custom_nodes/$(echo $custom_node_install_list_ | awk -F'/' '{print $NF}')
        done
    fi

    if [ $extension_model_1 = 0 ];then
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
    fi
}

if [ -d "./ComfyUI" ];then
    proxy_option #代理选择
    comfyui_extension_option #comfyui插件选择
    comfyui_custom_node_option #comfyui自定义节点选择
    process_install_comfyui #进行安装
    echo "完成"
else
    echo "当前目录未找到ComfyUI文件夹"
fi