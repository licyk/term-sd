#/bin/bash

#这个脚本是从term-sd中独立出来的，用来安装插件

#automatic1111-webui插件选择
function a1111_sd_webui_extension_option()
{
    #清空插件选择
    extension_install_list=""
    extension_model_1="1"
    extension_model_2="1"
    extension_model_3="1"

    #插件选择,并输出插件对应的数字
    extension_list=$(
        dialog --clear --title "Term-SD" --backtitle "A1111-SD-Webui插件安装选项" --separate-output --notags --ok-label "确认" --no-cancel --checklist "请选择要安装的A1111-Stable-Diffusion-Webui插件" 20 60 10 \
        "1" "kohya-config-webui" OFF \
        "2" "sd-webui-additional-networks" OFF\
        "3" "a1111-sd-webui-tagcomplete" OFF\
        "4" "multidiffusion-upscaler-for-automatic1111" OFF\
        "5" "sd-dynamic-thresholding" OFF\
        "6" "sd-webui-cutoff" OFF\
        "7" "sd-webui-model-converter" OFF \
        "8" "sd-webui-supermerger" OFF \
        "9" "stable-diffusion-webui-localization-zh_Hans" OFF\
        "10" "stable-diffusion-webui-wd14-tagger" OFF\
        "11" "sd-webui-regional-prompter" OFF\
        "12" "sd-webui-infinite-image-browsing" OFF\
        "13" "stable-diffusion-webui-anti-burn" OFF\
        "14" "loopback_scaler" OFF \
        "15" "latentcoupleregionmapper" OFF\
        "16" "ultimate-upscale-for-automatic1111" OFF\
        "17" "deforum-for-automatic1111" OFF \
        "18" "stable-diffusion-webui-images-browser" OFF\
        "19" "stable-diffusion-webui-huggingface" OFF \
        "20" "sd-civitai-browser" OFF \
        "21" "a1111-stable-diffusion-webui-vram-estimator" OFF \
        "22" "openpose-editor" OFF\
        "23" "sd-webui-depth-lib" OFF \
        "24" "posex" OFF \
        "25" "sd-webui-tunnels" OFF \
        "26" "batchlinks-webui" OFF \
        "27" "stable-diffusion-webui-catppuccin" OFF\
        "28" "a1111-sd-webui-lycoris" OFF \
        "29" "stable-diffusion-webui-rembg" OFF\
        "30" "stable-diffusion-webui-two-shot" OFF\
        "31" "sd-webui-lora-block-weight" OFF\
        "32" "sd-face-editor" OFF \
        "33" "sd-webui-segment-anything" OFF \
        "34" "sd-webui-controlnet" OFF\
        "35" "sd-webui-prompt-all-in-one" OFF\
        "36" "sd-webui-comfyui" OFF \
        "37" "sd-webui-animatediff" OFF \
        "38" "sd-webui-photopea-embed" OFF\
        "39" "sd-webui-openpose-editor" OFF\
        "40" "sd-webui-llul" OFF\
        "41" "sd-webui-bilingual-localization" OFF \
        "42" "adetailer" OFF\
        "43" "sd-webui-mov2mov" OFF \
        "44" "sd-webui-IS-NET-pro" OFF\
        "45" "ebsynth_utility" OFF \
        "46" "sd_dreambooth_extension" OFF \
        "47" "sd-webui-memory-release" OFF\
        "48" "stable-diffusion-webui-dataset-tag-editor" OFF \
        3>&1 1>&2 2>&3)

    if [ ! -z "$extension_list" ]; then
        for extension_list_ in $extension_list; do #从extension_list读取数字,通过数字对应插件链接,传递给extension_install_list
        case "$extension_list_" in
        "1")
        extension_install_list="https://github.com/WSH032/kohya-config-webui $extension_install_list"
        ;;
        "2")
        extension_install_list="https://github.com/kohya-ss/sd-webui-additional-networks $extension_install_list"
        ;;
        "3")
        extension_install_list="https://github.com/DominikDoom/a1111-sd-webui-tagcomplete $extension_install_list"
        ;;
        "4")
        extension_install_list="https://github.com/pkuliyi2015/multidiffusion-upscaler-for-automatic1111 $extension_install_list"
        ;;
        "5")
        extension_install_list="https://github.com/mcmonkeyprojects/sd-dynamic-thresholding $extension_install_list"
        ;;
        "6")
        extension_install_list="https://github.com/hnmr293/sd-webui-cutoff $extension_install_list"
        ;;
        "7")
        extension_install_list="https://github.com/Akegarasu/sd-webui-model-converter $extension_install_list"
        ;;
        "8")
        extension_install_list="https://github.com/hako-mikan/sd-webui-supermerger $extension_install_list"
        ;;
        "9")
        extension_install_list="https://github.com/hanamizuki-ai/stable-diffusion-webui-localization-zh_Hans $extension_install_list"
        ;;
        "10")
        extension_install_list="https://github.com/picobyte/stable-diffusion-webui-wd14-tagger $extension_install_list"
        ;;
        "11")
        extension_install_list="https://github.com/hako-mikan/sd-webui-regional-prompter $extension_install_list"
        ;;
        "12")
        extension_install_list="https://github.com/zanllp/sd-webui-infinite-image-browsing $extension_install_list"
        ;;
        "13")
        extension_install_list="https://github.com/klimaleksus/stable-diffusion-webui-anti-burn $extension_install_list"
        ;;
        "14")
        extension_install_list="https://github.com/Elldreth/loopback_scaler $extension_install_list"
        ;;
        "15")
        extension_install_list="https://github.com/CodeZombie/latentcoupleregionmapper $extension_install_list"
        ;;
        "16")
        extension_install_list="https://github.com/Coyote-A/ultimate-upscale-for-automatic1111 $extension_install_list"
        ;;
        "17")
        extension_install_list="https://github.com/deforum-art/deforum-for-automatic1111-webui $extension_install_list"
        ;;
        "18")
        extension_install_list="https://github.com/AlUlkesh/stable-diffusion-webui-images-browser $extension_install_list"
        ;;
        "19")
        extension_install_list="https://github.com/camenduru/stable-diffusion-webui-huggingface $extension_install_list"
        ;;
        "20")
        extension_install_list="https://github.com/camenduru/sd-civitai-browser $extension_install_list"
        ;;
        "21")
        extension_install_list="https://github.com/space-nuko/a1111-stable-diffusion-webui-vram-estimator $extension_install_list"
        ;;
        "22")
        extension_install_list="https://github.com/fkunn1326/openpose-editor $extension_install_list"
        ;;
        "23")
        extension_install_list="https://github.com/jexom/sd-webui-depth-lib $extension_install_list"
        ;;
        "24")
        extension_install_list="https://github.com/hnmr293/posex $extension_install_list"
        ;;
        "25")
        extension_install_list="https://github.com/camenduru/sd-webui-tunnels $extension_install_list"
        ;;
        "26")
        extension_install_list="https://github.com/etherealxx/batchlinks-webui $extension_install_list"
        ;;
        "27")
        extension_install_list="https://github.com/camenduru/stable-diffusion-webui-catppuccin $extension_install_list"
        ;;
        "28")
        extension_install_list="https://github.com/KohakuBlueleaf/a1111-sd-webui-lycoris $extension_install_list"
        ;;
        "29")
        extension_install_list="https://github.com/AUTOMATIC1111/stable-diffusion-webui-rembg $extension_install_list"
        ;;
        "30")
        extension_install_list="https://github.com/ashen-sensored/stable-diffusion-webui-two-shot $extension_install_list"
        ;;
        "31")
        extension_install_list="https://github.com/hako-mikan/sd-webui-lora-block-weight $extension_install_list"
        ;;
        "32")
        extension_install_list="https://github.com/ototadana/sd-face-editor $extension_install_list"
        ;;
        "33")
        extension_install_list="https://github.com/continue-revolution/sd-webui-segment-anything $extension_install_list"
        ;;
        "34")
        extension_install_list="https://github.com/Mikubill/sd-webui-controlnet $extension_install_list"
        extension_model_1=0
        ;;
        "35")
        extension_install_list="https://github.com/Physton/sd-webui-prompt-all-in-one $extension_install_list"
        ;;
        "36")
        extension_install_list="https://github.com/ModelSurge/sd-webui-comfyui $extension_install_list"
        ;;
        "37")
        extension_install_list="https://github.com/continue-revolution/sd-webui-animatediff $extension_install_list"
        ;;
        "38")
        extension_install_list="https://github.com/yankooliveira/sd-webui-photopea-embed $extension_install_list"
        ;;
        "39")
        extension_install_list="https://github.com/huchenlei/sd-webui-openpose-editor $extension_install_list"
        ;;
        "40")
        extension_install_list="https://github.com/hnmr293/sd-webui-llul $extension_install_list"
        ;;
        "41")
        extension_install_list="https://github.com/journey-ad/sd-webui-bilingual-localization $extension_install_list"
        ;;
        "42")
        extension_install_list="https://github.com/Bing-su/adetailer $extension_install_list"
        extension_model_2=0
        ;;
        "43")
        extension_install_list="https://github.com/Scholar01/sd-webui-mov2mov $extension_install_list"
        ;;
        "44")
        extension_install_list="https://github.com/ClockZinc/sd-webui-IS-NET-pro $extension_install_list"
        extension_model_3=0
        ;;
        "45")
        extension_install_list="https://github.com/s9roll7/ebsynth_utility $extension_install_list"
        ;;
        "46")
        extension_install_list="https://github.com/d8ahazard/sd_dreambooth_extension $extension_install_list"
        ;;
        "47")
        extension_install_list="https://github.com/Haoming02/sd-webui-memory-release $extension_install_list"
        ;;
        "48")
        extension_install_list="https://github.com/toshiaki1729/stable-diffusion-webui-dataset-tag-editor $extension_install_list"
        ;;
        *)
        exit 1
        ;;
        esac
        done
    fi
    process_install_a1111_sd_webui
}

#a1111-sd-webui安装处理部分
function process_install_a1111_sd_webui()
{
    if [ ! -z "$extension_install_list" ];then
        echo "安装插件中"
        for  extension_install_list_ in $extension_install_list ;do
            git clone "$github_proxy"$extension_install_list_ ./stable-diffusion-webui/extensions/$(echo $extension_install_list_ | awk -F'/' '{print $NF}')
        done
    fi

    echo "下载模型中"
    if [ $extension_model_1 = 0 ];then #安装controlnet时再下载相关模型
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

    if [ $extension_model_2 = 0 ];then #安装adetailer插件相关模型
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

    if [ $extension_model_3 = 0 ];then #安装sd-webui-IS-NET-pro插件相关模型
        aria2c https://huggingface.co/ClockZinc/IS-NET_pth/resolve/main/isnet-general-use.pth -d ./stable-diffusion-webui/extensions/sd-webui-IS-NET-pro/saved_models/IS-Net -o isnet-general-use.pth
    fi
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
    echo "完成"
else
    echo "当前目录未检测到stable-diffusion-webui文件夹"
fi