#/bin/bash

#这个脚本是从term-sd中独立出来的，用来安装插件

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
        extension_10="https://github.com/tsukimiya/stable-diffusion-webui-wd14-tagger"
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
    process_install_a1111_sd_webui
else
    exit
fi
    
}

#a1111-sd-webui安装处理部分
function process_install_a1111_sd_webui()
{


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

    if [ "$extension_34" = "https://github.com/Mikubill/sd-webui-controlnet" ]; then #安装controlnet时再下载相关模型
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
    fi

    if [ "$extension_42" = "https://github.com/Bing-su/adetailer" ];then #安装adetailer插件相关模型
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

    if [ "$extension_44" = "https://github.com/ClockZinc/sd-webui-IS-NET-pro" ];then #安装sd-webui-IS-NET-pro插件相关模型
        aria2c https://huggingface.co/ClockZinc/IS-NET_pth/resolve/main/isnet-general-use.pth -d ./stable-diffusion-webui/extensions/sd-webui-IS-NET-pro/saved_models/IS-Net -o isnet-general-use.pth
    fi

a1111_sd_webui_extension_option

}

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
        "1" "启用python镜像源" OFF \
        "2" "启用github代理" ON \
        "3" "强制使用pip" OFF 3>&1 1>&2 2>&3)

    if [ -z "$final_proxy_options" ]; then
        echo
    else
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
    a1111_sd_webui_extension_option
}

if [ -d "./stable-diffusion-webui" ];then
    proxy_option
else
    echo "当前目录未检测到stable-diffusion-webui文件夹"
fi