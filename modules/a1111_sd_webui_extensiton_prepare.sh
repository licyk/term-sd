#!/bin/bash

#automatic1111-webui插件选择
function a1111_sd_webui_extension_option()
{
    #清空插件选择
    a1111_sd_webui_extension_install_list=""
    a1111_sd_webui_extension_model_1="1"
    a1111_sd_webui_extension_model_2="1"
    a1111_sd_webui_extension_model_3="1"
    a1111_sd_webui_extension_model_4="1"

    #插件选择,并输出插件对应的数字
    extension_list=$(
        dialog --clear --title "Term-SD" --backtitle "A1111-SD-Webui插件安装选项" --separate-output --notags --ok-label "确认" --no-cancel --checklist "请选择要安装的A1111-Stable-Diffusion-Webui插件" 23 70 12 \
        "1" "kohya-config-webui" OFF \
        "2" "sd-webui-additional-networks" ON \
        "3" "a1111-sd-webui-tagcomplete" ON \
        "4" "multidiffusion-upscaler-for-automatic1111" ON \
        "5" "sd-dynamic-thresholding" ON \
        "6" "sd-webui-cutoff" ON \
        "7" "sd-webui-model-converter" ON \
        "8" "sd-webui-supermerger" OFF \
        "9" "stable-diffusion-webui-localization-zh_Hans" ON \
        "10" "stable-diffusion-webui-wd14-tagger" ON \
        "11" "sd-webui-regional-prompter" ON \
        "12" "sd-webui-infinite-image-browsing" ON \
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
        "37" "sd-webui-animatediff" OFF \
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
        "48" "stable-diffusion-webui-dataset-tag-editor" OFF \
        "49" "sd-webui-stablesr" OFF \
        "50" "sd-webui-deoldify" OFF \
        "51" "stable-diffusion-webui-model-toolkit" ON \
        "52" "sd-webui-oldsix-prompt-dynamic" OFF \
        "53" "sd-webui-fastblend" OFF \
        "54" "StyleSelectorXL" OFF \
        "55" "sd-dynamic-prompts" OFF \
        "56" "LightDiffusionFlow" ON \
        3>&1 1>&2 2>&3)

    if [ ! -z "$extension_list" ]; then
        for extension_list_ in $extension_list; do #从extension_list读取数字,通过数字对应插件链接,传递给a1111_sd_webui_extension_install_list
        case "$extension_list_" in
        "1")
        a1111_sd_webui_extension_install_list="https://github.com/WSH032/kohya-config-webui $a1111_sd_webui_extension_install_list"
        ;;
        "2")
        a1111_sd_webui_extension_install_list="https://github.com/kohya-ss/sd-webui-additional-networks $a1111_sd_webui_extension_install_list"
        ;;
        "3")
        a1111_sd_webui_extension_install_list="https://github.com/DominikDoom/a1111-sd-webui-tagcomplete $a1111_sd_webui_extension_install_list"
        ;;
        "4")
        a1111_sd_webui_extension_install_list="https://github.com/pkuliyi2015/multidiffusion-upscaler-for-automatic1111 $a1111_sd_webui_extension_install_list"
        ;;
        "5")
        a1111_sd_webui_extension_install_list="https://github.com/mcmonkeyprojects/sd-dynamic-thresholding $a1111_sd_webui_extension_install_list"
        ;;
        "6")
        a1111_sd_webui_extension_install_list="https://github.com/hnmr293/sd-webui-cutoff $a1111_sd_webui_extension_install_list"
        ;;
        "7")
        a1111_sd_webui_extension_install_list="https://github.com/Akegarasu/sd-webui-model-converter $a1111_sd_webui_extension_install_list"
        ;;
        "8")
        a1111_sd_webui_extension_install_list="https://github.com/hako-mikan/sd-webui-supermerger $a1111_sd_webui_extension_install_list"
        ;;
        "9")
        a1111_sd_webui_extension_install_list="https://github.com/hanamizuki-ai/stable-diffusion-webui-localization-zh_Hans $a1111_sd_webui_extension_install_list"
        ;;
        "10")
        a1111_sd_webui_extension_install_list="https://github.com/picobyte/stable-diffusion-webui-wd14-tagger $a1111_sd_webui_extension_install_list"
        ;;
        "11")
        a1111_sd_webui_extension_install_list="https://github.com/hako-mikan/sd-webui-regional-prompter $a1111_sd_webui_extension_install_list"
        ;;
        "12")
        a1111_sd_webui_extension_install_list="https://github.com/zanllp/sd-webui-infinite-image-browsing $a1111_sd_webui_extension_install_list"
        ;;
        "13")
        a1111_sd_webui_extension_install_list="https://github.com/klimaleksus/stable-diffusion-webui-anti-burn $a1111_sd_webui_extension_install_list"
        ;;
        "14")
        a1111_sd_webui_extension_install_list="https://github.com/Elldreth/loopback_scaler $a1111_sd_webui_extension_install_list"
        ;;
        "15")
        a1111_sd_webui_extension_install_list="https://github.com/CodeZombie/latentcoupleregionmapper $a1111_sd_webui_extension_install_list"
        ;;
        "16")
        a1111_sd_webui_extension_install_list="https://github.com/Coyote-A/ultimate-upscale-for-automatic1111 $a1111_sd_webui_extension_install_list"
        ;;
        "17")
        a1111_sd_webui_extension_install_list="https://github.com/deforum-art/deforum-for-automatic1111-webui $a1111_sd_webui_extension_install_list"
        ;;
        "18")
        a1111_sd_webui_extension_install_list="https://github.com/AlUlkesh/stable-diffusion-webui-images-browser $a1111_sd_webui_extension_install_list"
        ;;
        "19")
        a1111_sd_webui_extension_install_list="https://github.com/camenduru/stable-diffusion-webui-huggingface $a1111_sd_webui_extension_install_list"
        ;;
        "20")
        a1111_sd_webui_extension_install_list="https://github.com/camenduru/sd-civitai-browser $a1111_sd_webui_extension_install_list"
        ;;
        "21")
        a1111_sd_webui_extension_install_list="https://github.com/space-nuko/a1111-stable-diffusion-webui-vram-estimator $a1111_sd_webui_extension_install_list"
        ;;
        "22")
        a1111_sd_webui_extension_install_list="https://github.com/fkunn1326/openpose-editor $a1111_sd_webui_extension_install_list"
        ;;
        "23")
        a1111_sd_webui_extension_install_list="https://github.com/jexom/sd-webui-depth-lib $a1111_sd_webui_extension_install_list"
        ;;
        "24")
        a1111_sd_webui_extension_install_list="https://github.com/hnmr293/posex $a1111_sd_webui_extension_install_list"
        ;;
        "25")
        a1111_sd_webui_extension_install_list="https://github.com/camenduru/sd-webui-tunnels $a1111_sd_webui_extension_install_list"
        ;;
        "26")
        a1111_sd_webui_extension_install_list="https://github.com/etherealxx/batchlinks-webui $a1111_sd_webui_extension_install_list"
        ;;
        "27")
        a1111_sd_webui_extension_install_list="https://github.com/camenduru/stable-diffusion-webui-catppuccin $a1111_sd_webui_extension_install_list"
        ;;
        "28")
        a1111_sd_webui_extension_install_list="https://github.com/KohakuBlueleaf/a1111-sd-webui-lycoris $a1111_sd_webui_extension_install_list"
        ;;
        "29")
        a1111_sd_webui_extension_install_list="https://github.com/AUTOMATIC1111/stable-diffusion-webui-rembg $a1111_sd_webui_extension_install_list"
        ;;
        "30")
        a1111_sd_webui_extension_install_list="https://github.com/ashen-sensored/stable-diffusion-webui-two-shot $a1111_sd_webui_extension_install_list"
        ;;
        "31")
        a1111_sd_webui_extension_install_list="https://github.com/hako-mikan/sd-webui-lora-block-weight $a1111_sd_webui_extension_install_list"
        ;;
        "32")
        a1111_sd_webui_extension_install_list="https://github.com/ototadana/sd-face-editor $a1111_sd_webui_extension_install_list"
        ;;
        "33")
        a1111_sd_webui_extension_install_list="https://github.com/continue-revolution/sd-webui-segment-anything $a1111_sd_webui_extension_install_list"
        ;;
        "34")
        a1111_sd_webui_extension_install_list="https://github.com/Mikubill/sd-webui-controlnet $a1111_sd_webui_extension_install_list"
        a1111_sd_webui_extension_model_1=0
        ;;
        "35")
        a1111_sd_webui_extension_install_list="https://github.com/Physton/sd-webui-prompt-all-in-one $a1111_sd_webui_extension_install_list"
        ;;
        "36")
        a1111_sd_webui_extension_install_list="https://github.com/ModelSurge/sd-webui-comfyui $a1111_sd_webui_extension_install_list"
        ;;
        "37")
        a1111_sd_webui_extension_install_list="https://github.com/continue-revolution/sd-webui-animatediff $a1111_sd_webui_extension_install_list"
        a1111_sd_webui_extension_model_4=0
        ;;
        "38")
        a1111_sd_webui_extension_install_list="https://github.com/yankooliveira/sd-webui-photopea-embed $a1111_sd_webui_extension_install_list"
        ;;
        "39")
        a1111_sd_webui_extension_install_list="https://github.com/huchenlei/sd-webui-openpose-editor $a1111_sd_webui_extension_install_list"
        ;;
        "40")
        a1111_sd_webui_extension_install_list="https://github.com/hnmr293/sd-webui-llul $a1111_sd_webui_extension_install_list"
        ;;
        "41")
        a1111_sd_webui_extension_install_list="https://github.com/journey-ad/sd-webui-bilingual-localization $a1111_sd_webui_extension_install_list"
        ;;
        "42")
        a1111_sd_webui_extension_install_list="https://github.com/Bing-su/adetailer $a1111_sd_webui_extension_install_list"
        a1111_sd_webui_extension_model_2=0
        ;;
        "43")
        a1111_sd_webui_extension_install_list="https://github.com/Scholar01/sd-webui-mov2mov $a1111_sd_webui_extension_install_list"
        ;;
        "44")
        a1111_sd_webui_extension_install_list="https://github.com/ClockZinc/sd-webui-IS-NET-pro $a1111_sd_webui_extension_install_list"
        a1111_sd_webui_extension_model_3=0
        ;;
        "45")
        a1111_sd_webui_extension_install_list="https://github.com/s9roll7/ebsynth_utility $a1111_sd_webui_extension_install_list"
        ;;
        "46")
        a1111_sd_webui_extension_install_list="https://github.com/d8ahazard/sd_dreambooth_extension $a1111_sd_webui_extension_install_list"
        ;;
        "47")
        a1111_sd_webui_extension_install_list="https://github.com/Haoming02/sd-webui-memory-release $a1111_sd_webui_extension_install_list"
        ;;
        "48")
        a1111_sd_webui_extension_install_list="https://github.com/toshiaki1729/stable-diffusion-webui-dataset-tag-editor $a1111_sd_webui_extension_install_list"
        ;;
        "49")
        a1111_sd_webui_extension_install_list="https://github.com/pkuliyi2015/sd-webui-stablesr $a1111_sd_webui_extension_install_list"
        ;;
        "50")
        a1111_sd_webui_extension_install_list="https://github.com/SpenserCai/sd-webui-deoldify $a1111_sd_webui_extension_install_list"
        ;;
        "51")
        a1111_sd_webui_extension_install_list="https://github.com/arenasys/stable-diffusion-webui-model-toolkit $a1111_sd_webui_extension_install_list"
        ;;
        "52")
        a1111_sd_webui_extension_install_list="https://github.com/Bobo-1125/sd-webui-oldsix-prompt-dynamic $a1111_sd_webui_extension_install_list"
        ;;
        "53")
        a1111_sd_webui_extension_install_list="https://github.com/Artiprocher/sd-webui-fastblend $a1111_sd_webui_extension_install_list"
        ;;
        "54")
        a1111_sd_webui_extension_install_list="https://github.com/ahgsql/StyleSelectorXL $a1111_sd_webui_extension_install_list"
        ;;
        "55")
        a1111_sd_webui_extension_install_list="https://github.com/adieyal/sd-dynamic-prompts $a1111_sd_webui_extension_install_list"
        ;;
        "56")
        a1111_sd_webui_extension_install_list="https://github.com/Tencent/LightDiffusionFlow $a1111_sd_webui_extension_install_list"
        ;;
        *)
        exit 1
        ;;
        esac
        done
    fi
}