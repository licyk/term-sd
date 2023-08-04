#/bin/bash

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
        "1" "启用python镜像源" ON \
        "2" "启用github代理" ON \
        "3" "强制使用pip" OFF 3>&1 1>&2 2>&3)

    if [ ! -z "$final_proxy_options" ]; then
        for final_proxy_option in $final_proxy_options; do
        case "$final_proxy_option" in
        "1")
        #python_proxy="-i https://mirror.sjtu.edu.cn/pypi/web/simple" #上海交大的镜像源有点问题，在安装invokeai时会报错，可能是软件包版本的问题
        python_proxy="-i https://mirrors.bfsu.edu.cn/pypi/web/simple"
        extra_python_proxy="-f https://mirror.sjtu.edu.cn/pytorch-wheels"
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
    #清除插件选择
    comfyui_extension_1=""
    comfyui_extension_2=""

    final_comfyui_extension_option=$(
        dialog --separate-output --notags --yes-label "确认" --no-cancel --checklist "ComfyUI插件选择" 20 60 10 \
        "1" "ComfyUI-extensions" OFF \
        "2" "graphNavigator" OFF \
        3>&1 1>&2 2>&3)

    if [ -z "$final_comfyui_extension_option" ]; then
        echo
    else
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

        if [ -z "$final_comfyui_custom_node_option" ]; then
        echo
    else
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

#comfyui安装处理部分
function process_install_comfyui()
{
    #安装前的准备
    proxy_option #代理选择
    comfyui_extension_option #comfyui插件选择
    comfyui_custom_node_option #comfyui自定义节点选择

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
    #aria2c https://huggingface.co/CompVis/stable-diffusion-v-1-4-original/resolve/main/sd-v1-4.ckpt -d ./ComfyUI/models/checkpoints/ -o sd-v1-4.ckpt
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
    fi
}

if [ -f "./ComfyUI" ];then
    process_install_comfyui
else
    echo "未找到ComfyUI文件夹"
fi