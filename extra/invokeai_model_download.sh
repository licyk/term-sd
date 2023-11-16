#!/bin/bash

# 加载模块
source ./term-sd/modules/term_sd_manager.sh

# 模型选择
invokeai_model_select()
{
    invokeai_model_select_dialog=$(
        dialog --erase-on-exit --notags --title "IovokeAI管理" --backtitle "IovokeAI模型下载" --ok-label "确认" --cancel-label "取消" --checklist "请选择需要下载的InvokeAI模型" $term_sd_dialog_height $term_sd_dialog_width $term_sd_dialog_menu_height \
        "invokeai_embed" ">-----embedding模型列表-----" ON \
        "__invokeai_model_embed_sd15_1" "EasyNegative" OFF \
        "__invokeai_model_embed_sdxl_1" "ahx-beta-453407d" OFF \
        "invokeai_model" ">-----stable-diffusion模型列表-----" ON \
        "invokeai_model_sd15" "-----SD1.5模型列表-----" ON \
        "__invokeai_model_sd15_openjourney" "openjourney" OFF \
        "__invokeai_model_sd15_official" "stable-diffusion-1.5" OFF \
        "__invokeai_model_sd15_inpaint_official" "stable-diffusion-1.5-inpaint" OFF \
        "invokeai_model_sd21" "-----SD2.1模型列表-----" ON \
        "__invokeai_model_sd21_official" "stable-diffusion-2.1" OFF \
        "__invokeai_model_sd21_inpaint_official" "stable-diffusion-2.1-inpaint" OFF \
        "invokeai_model_sdxl" "-----SDXL模型列表-----" ON \
        "__invokeai_model_sdxl_official" "stable-diffusion-xl" OFF \
        "__invokeai_model_sdxl_vae_official" "stable-diffusion-xl-vae" OFF \
        "__invokeai_model_sdxl_refind_official" "stable-diffusion-xl-refind" OFF \
        "invokeai_cn" ">-----Controlnet模型列表-----" ON \
        "__invokeai_model_cn_sd15_canny" "cn-canny" OFF \
        "__invokeai_model_cn_sd15_depth" "cn-depth" OFF \
        "__invokeai_model_cn_sd15_inpaint" "cn-inpaint" OFF \
        "__invokeai_model_cn_sd15_ip2p" "cn-ip2p" OFF \
        "__invokeai_model_cn_sd15_lineart" "cn-lineart" OFF \
        "__invokeai_model_cn_sd15_lineart_anime" "cn-lineart-anime" OFF \
        "__invokeai_model_cn_sd15_misd" "cn-misd" OFF \
        "__invokeai_model_cn_sd15_normal_bae" "cn-normal-bae" OFF \
        "__invokeai_model_cn_sd15_openpose" "cn-openpose" OFF \
        "__invokeai_model_cn_sd15_qrcode" "cn-qrcode" OFF \
        "__invokeai_model_cn_sd15_scribble" "cn-scribble" OFF \
        "__invokeai_model_cn_sd15_seg" "cn-seg" OFF \
        "__invokeai_model_cn_sd15_shuffle" "cn-shuffle" OFF \
        "__invokeai_model_cn_sd15_softedge" "cn-softedge" OFF \
        "__invokeai_model_cn_sd15_tile" "cn-tile" OFF \
        "invokeai_t2i" ">-----t2i-adapter模型列表-----" ON \
        "__invokeai_model_t2i_sd15_canny" "t2i-canny-sd1.5" OFF \
        "__invokeai_model_t2i_sd15_depth" "t2i-depth-sd1.5" OFF \
        "__invokeai_model_t2i_sd15_sketch" "t2i-sketch-sd1.5" OFF \
        "__invokeai_model_t2i_sd15_zoedepth" "t2i-zoedepth-sd1.5" OFF \
        "__invokeai_model_t2i_sdxl_canny" "t2i-canny-sdxl" OFF \
        "__invokeai_model_t2i_sdxl_lineart" "t2i-lineart-sdxl" OFF \
        "__invokeai_model_t2i_sdxl_sketch" "t2i-sketch-sdxl" OFF \
        "__invokeai_model_t2i_sdxl_zoedepth" "t2i-zoedepth-sdxl" OFF \
        "invokeai_ip_adapt" >"-----ip-adapter模型列表-----" ON \
        "__invokeai_model_ip_adapt_sd15_clip" "ip-adapt-clip-sd1.5" OFF \
        "__invokeai_model_ip_adapt_sd15_plus_face" "ip-adapt-plus-face-sd1.5" OFF \
        "__invokeai_model_ip_adapt_sd15_plus" "ip-adapt-plus-sd1.5" OFF \
        "__invokeai_model_ip_adapt_sd15_normal" "ip-adapt-normal-sd1.5" OFF \
        "__invokeai_model_ip_adapt_sdxl_clip" "ip-adapt-clip-sdxl" OFF \
        "__invokeai_model_ip_adapt_sdxl_normal" "ip-adapt-normal-sdxl" OFF \
        3>&1 1>&2 2>&3)
    return $?
}

# invokeai模型列表
invokeai_model_list()
{
    cat<<EOF
# controlnet 1.1 sd1.5
# canny
__invokeai_model_cn_sd15_canny get_invokeai_model licyks/invokeai-model/master/sd-1/controlnet/canny/config.json ./invokeai/models/sd-1/controlnet/canny
__invokeai_model_cn_sd15_canny get_invokeai_model licyks/invokeai-model/master/sd-1/controlnet/canny/diffusion_pytorch_model.safetensors ./invokeai/models/sd-1/controlnet/canny

# depth
__invokeai_model_cn_sd15_depth get_invokeai_model licyks/invokeai-model/master/sd-1/controlnet/depth/config.json ./invokeai/models/sd-1/controlnet/depth
__invokeai_model_cn_sd15_depth get_invokeai_model licyks/invokeai-model/master/sd-1/controlnet/depth/diffusion_pytorch_model.safetensors ./invokeai/models/sd-1/controlnet/depth

# inpaint
__invokeai_model_cn_sd15_inpaint get_invokeai_model licyks/invokeai-model/master/sd-1/controlnet/inpaint/config.json ./invokeai/models/sd-1/controlnet/inpaint
__invokeai_model_cn_sd15_inpaint get_invokeai_model licyks/invokeai-model/master/sd-1/controlnet/inpaint/diffusion_pytorch_model.safetensors ./invokeai/models/sd-1/controlnet/inpaint

# ip2p
__invokeai_model_cn_sd15_ip2p get_invokeai_model licyks/invokeai-model/master/sd-1/controlnet/ip2p/config.json ./invokeai/models/sd-1/controlnet/ip2p
__invokeai_model_cn_sd15_ip2p get_invokeai_model licyks/invokeai-model/master/sd-1/controlnet/ip2p/diffusion_pytorch_model.safetensors ./invokeai/models/sd-1/controlnet/ip2p

# lineart
__invokeai_model_cn_sd15_lineart get_invokeai_model licyks/invokeai-model/master/sd-1/controlnet/lineart/config.json ./invokeai/models/sd-1/controlnet/lineart
__invokeai_model_cn_sd15_lineart get_invokeai_model licyks/invokeai-model/master/sd-1/controlnet/lineart/diffusion_pytorch_model.safetensors ./invokeai/models/sd-1/controlnet/lineart

# lineart-anime
__invokeai_model_cn_sd15_lineart_anime get_invokeai_model licyks/invokeai-model/master/sd-1/controlnet/lineart_anime/config.json ./invokeai/models/sd-1/controlnet/lineart_anime
__invokeai_model_cn_sd15_lineart_anime get_invokeai_model licyks/invokeai-model/master/sd-1/controlnet/lineart_anime/diffusion_pytorch_model.safetensors ./invokeai/models/sd-1/controlnet/lineart_anime

# mlsd
__invokeai_model_cn_sd15_misd get_invokeai_model licyks/invokeai-model/master/sd-1/controlnet/mlsd/config.json ./invokeai/models/sd-1/controlnet/mlsd
__invokeai_model_cn_sd15_misd get_invokeai_model licyks/invokeai-model/master/sd-1/controlnet/mlsd/diffusion_pytorch_model.safetensors ./invokeai/models/sd-1/controlnet/mlsd

# normal-bae
__invokeai_model_cn_sd15_normal_bae get_invokeai_model licyks/invokeai-model/master/sd-1/controlnet/normal_bae/config.json ./invokeai/models/sd-1/controlnet/normal_bae
__invokeai_model_cn_sd15_normal_bae get_invokeai_model licyks/invokeai-model/master/sd-1/controlnet/normal_bae/diffusion_pytorch_model.safetensors ./invokeai/models/sd-1/controlnet/normal_bae

# openpose
__invokeai_model_cn_sd15_openpose get_invokeai_model licyks/invokeai-model/master/sd-1/controlnet/openpose/config.json ./invokeai/models/sd-1/controlnet/openpose
__invokeai_model_cn_sd15_openpose get_invokeai_model licyks/invokeai-model/master/sd-1/controlnet/openpose/diffusion_pytorch_model.safetensors ./invokeai/models/sd-1/controlnet/openpose

# qrcode
__invokeai_model_cn_sd15_qrcode get_invokeai_model licyks/invokeai-model/master/sd-1/controlnet/qrcode_monster/config.json ./invokeai/models/sd-1/controlnet/qrcode_monster
__invokeai_model_cn_sd15_qrcode get_invokeai_model licyks/invokeai-model/master/sd-1/controlnet/qrcode_monster/diffusion_pytorch_model.safetensors ./invokeai/models/sd-1/controlnet/qrcode_monster

# scribble
__invokeai_model_cn_sd15_scribble get_invokeai_model licyks/invokeai-model/master/sd-1/controlnet/scribble/config.json ./invokeai/models/sd-1/controlnet/scribble
__invokeai_model_cn_sd15_scribble get_invokeai_model licyks/invokeai-model/master/sd-1/controlnet/scribble/diffusion_pytorch_model.safetensors ./invokeai/models/sd-1/controlnet/scribble

# seg
__invokeai_model_cn_sd15_seg get_invokeai_model licyks/invokeai-model/master/sd-1/controlnet/seg/config.json ./invokeai/models/sd-1/controlnet/seg
__invokeai_model_cn_sd15_seg get_invokeai_model licyks/invokeai-model/master/sd-1/controlnet/seg/diffusion_pytorch_model.safetensors ./invokeai/models/sd-1/controlnet/seg

# shuffle
__invokeai_model_cn_sd15_shuffle get_invokeai_model licyks/invokeai-model/master/sd-1/controlnet/shuffle/config.json ./invokeai/models/sd-1/controlnet/shuffle
__invokeai_model_cn_sd15_shuffle get_invokeai_model licyks/invokeai-model/master/sd-1/controlnet/shuffle/diffusion_pytorch_model.safetensors ./invokeai/models/sd-1/controlnet/shuffle

# softedge
__invokeai_model_cn_sd15_softedge get_invokeai_model licyks/invokeai-model/master/sd-1/controlnet/softedge/config.json ./invokeai/models/sd-1/controlnet/softedge
__invokeai_model_cn_sd15_softedge get_invokeai_model licyks/invokeai-model/master/sd-1/controlnet/softedge/diffusion_pytorch_model.safetensors ./invokeai/models/sd-1/controlnet/softedge

# tile
__invokeai_model_cn_sd15_tile get_invokeai_model licyks/invokeai-model/master/sd-1/controlnet/tile/config.json ./invokeai/models/sd-1/controlnet/tile
__invokeai_model_cn_sd15_tile get_invokeai_model licyks/invokeai-model/master/sd-1/controlnet/tile/diffusion_pytorch_model.bin ./invokeai/models/sd-1/controlnet/tile


# t2i sd1.5
# canny
__invokeai_model_t2i_sd15_canny get_invokeai_model licyks/invokeai-model/master/sd-1/t2i_adapter/canny-sd15/config.json ./invokeai/models/sd-1/t2i_adapter/canny-sd15
__invokeai_model_t2i_sd15_canny get_invokeai_model licyks/invokeai-model/master/sd-1/t2i_adapter/canny-sd15/diffusion_pytorch_model.bin ./invokeai/models/sd-1/t2i_adapter/canny-sd15

# depth
__invokeai_model_t2i_sd15_depth get_invokeai_model licyks/invokeai-model/master/sd-1/t2i_adapter/depth-sd15/config.json ./invokeai/models/sd-1/t2i_adapter/depth-sd15
__invokeai_model_t2i_sd15_depth get_invokeai_model licyks/invokeai-model/master/sd-1/t2i_adapter/depth-sd15/diffusion_pytorch_model.bin ./invokeai/models/sd-1/t2i_adapter/depth-sd15

# sketch
__invokeai_model_t2i_sd15_sketch get_invokeai_model licyks/invokeai-model/master/sd-1/t2i_adapter/sketch-sd15/config.json ./invokeai/models/sd-1/t2i_adapter/sketch-sd15
__invokeai_model_t2i_sd15_sketch get_invokeai_model licyks/invokeai-model/master/sd-1/t2i_adapter/sketch-sd15/diffusion_pytorch_model.bin ./invokeai/models/sd-1/t2i_adapter/sketch-sd15

# zoedepth
__invokeai_model_t2i_sd15_zoedepth get_invokeai_model licyks/invokeai-model/master/sd-1/t2i_adapter/zoedepth-sd15/config.json ./invokeai/models/sd-1/t2i_adapter/zoedepth-sd15
__invokeai_model_t2i_sd15_zoedepth get_invokeai_model licyks/invokeai-model/master/sd-1/t2i_adapter/zoedepth-sd15/diffusion_pytorch_model.bin ./invokeai/models/sd-1/t2i_adapter/zoedepth-sd15

# t2i sdxl
# canny
__invokeai_model_t2i_sdxl_canny get_invokeai_model licyks/invokeai-model/master/sdxl/t2i_adapter/canny-sdxl/config.json ./invokeai/models/sdxl/t2i_adapter/canny-sdxl
__invokeai_model_t2i_sdxl_canny get_invokeai_model licyks/invokeai-model/master/sdxl/t2i_adapter/canny-sdxl/diffusion_pytorch_model.safetensors ./invokeai/models/sdxl/t2i_adapter/canny-sdxl

# lineart
__invokeai_model_t2i_sdxl_lineart get_invokeai_model licyks/invokeai-model/master/sdxl/t2i_adapter/lineart-sdxl/config.json ./invokeai/models/sdxl/t2i_adapter/lineart-sdxl
__invokeai_model_t2i_sdxl_lineart get_invokeai_model licyks/invokeai-model/master/sdxl/t2i_adapter/lineart-sdxl/diffusion_pytorch_model.safetensors ./invokeai/models/sdxl/t2i_adapter/lineart-sdxl

# sketch
__invokeai_model_t2i_sdxl_sketch get_invokeai_model licyks/invokeai-model/master/sdxl/t2i_adapter/sketch-sdxl/config.json ./invokeai/models/sdxl/t2i_adapter/sketch-sdxl
__invokeai_model_t2i_sdxl_sketch get_invokeai_model licyks/invokeai-model/master/sdxl/t2i_adapter/sketch-sdxl/diffusion_pytorch_model.safetensors ./invokeai/models/sdxl/t2i_adapter/sketch-sdxl

# zoedepth
__invokeai_model_t2i_sdxl_zoedepth get_invokeai_model licyks/invokeai-model/master/sdxl/t2i_adapter/zoedepth-sdxl/config.json ./invokeai/models/sdxl/t2i_adapter/zoedepth-sdxl
__invokeai_model_t2i_sdxl_zoedepth get_invokeai_model licyks/invokeai-model/master/sdxl/t2i_adapter/zoedepth-sdxl/diffusion_pytorch_model.safetensors ./invokeai/models/sdxl/t2i_adapter/zoedepth-sdxl


# ip-adapt sd1.5
# clip
__invokeai_model_ip_adapt_sd15_clip get_invokeai_model licyks/invokeai-model/master/any/clip_vision/ip_adapter_sd_image_encoder/config.json ./invokeai/models/any/clip_vision/ip_adapter_sd_image_encoder
__invokeai_model_ip_adapt_sd15_clip get_invokeai_model licyks/invokeai-model/master/any/clip_vision/ip_adapter_sd_image_encoder/model.safetensors ./invokeai/models/any/clip_vision/ip_adapter_sd_image_encoder

# plus-face
__invokeai_model_ip_adapt_sd15_plus_face get_invokeai_model licyks/invokeai-model/master/sd-1/ip_adapter/ip_adapter_plus_face_sd15/image_encoder.txt ./invokeai/models/sd-1/ip_adapter/ip_adapter_plus_face_sd15
__invokeai_model_ip_adapt_sd15_plus_face get_invokeai_model licyks/invokeai-model/master/sd-1/ip_adapter/ip_adapter_plus_face_sd15/ip_adapter.bin ./invokeai/models/sd-1/ip_adapter/ip_adapter_plus_face_sd15

# plus
__invokeai_model_ip_adapt_sd15_plus get_invokeai_model licyks/invokeai-model/master/sd-1/ip_adapter/ip_adapter_plus_sd15/image_encoder.txt ./invokeai/models/sd-1/ip_adapter/ip_adapter_plus_sd15
__invokeai_model_ip_adapt_sd15_plus get_invokeai_model licyks/invokeai-model/master/sd-1/ip_adapter/ip_adapter_plus_sd15/ip_adapter.bin ./invokeai/models/sd-1/ip_adapter/ip_adapter_plus_sd15

# normal
__invokeai_model_ip_adapt_sd15_normal get_invokeai_model licyks/invokeai-model/master/sd-1/ip_adapter/ip_adapter_sd15/image_encoder.txt ./invokeai/models/sd-1/ip_adapter/ip_adapter_sd15
__invokeai_model_ip_adapt_sd15_normal get_invokeai_model licyks/invokeai-model/master/sd-1/ip_adapter/ip_adapter_sd15/ip_adapter.bin ./invokeai/models/sd-1/ip_adapter/ip_adapter_sd15

# ip-adapt sdxl
# clip
__invokeai_model_ip_adapt_sdxl_clip get_invokeai_model licyks/invokeai-model/master/any/clip_vision/ip_adapter_sdxl_image_encoder/config.json ./invokeai/models/any/clip_vision/ip_adapter_sdxl_image_encoder
__invokeai_model_ip_adapt_sdxl_clip get_invokeai_model licyks/invokeai-model/master/any/clip_vision/ip_adapter_sdxl_image_encoder/model.safetensors ./invokeai/models/any/clip_vision/ip_adapter_sdxl_image_encoder

# normal
__invokeai_model_ip_adapt_sdxl_normal get_invokeai_model licyks/invokeai-model/master/sdxl/ip_adapter/ip_adapter_sdxl/image_encoder.txt ./invokeai/models/sdxl/ip_adapter/ip_adapter_sdxl
__invokeai_model_ip_adapt_sdxl_normal get_invokeai_model licyks/invokeai-model/master/sdxl/ip_adapter/ip_adapter_sdxl/ip_adapter.bin ./invokeai/models/sdxl/ip_adapter/ip_adapter_sdxl


# embedding
# sd1.5
__invokeai_model_embed_sd15_1 get_invokeai_model licyks/invokeai-model/master/sd-1/embedding/EasyNegative.safetensors ./invokeai/models/sd-1/embedding

# sdxl
__invokeai_model_embed_sdxl_1 get_invokeai_model licyks/invokeai-model/master/sd-2/embedding/ahx-beta-453407d/learned_embeds.bin ./invokeai/models/sd-2/embedding


# sd1.5
# openjourney
__invokeai_model_sd15_openjourney get_invokeai_model licyks/invokeai-model/master/sd-1/main/openjourney/feature_extractor/preprocessor_config.json ./invokeai/models/sd-1/main/openjourney/feature_extractor
__invokeai_model_sd15_openjourney get_invokeai_model licyks/invokeai-model/master/sd-1/main/openjourney/model_index.json ./invokeai/models/sd-1/main/openjourney
__invokeai_model_sd15_openjourney get_invokeai_model licyks/invokeai-model/master/sd-1/main/openjourney/scheduler/scheduler_config.json ./invokeai/models/sd-1/main/openjourney/scheduler
__invokeai_model_sd15_openjourney get_invokeai_model licyks/invokeai-model/master/sd-1/main/openjourney/text_encoder/config.json ./invokeai/models/sd-1/main/openjourney/text_encoder
__invokeai_model_sd15_openjourney get_invokeai_model licyks/invokeai-model/master/sd-1/main/openjourney/text_encoder/model.safetensors ./invokeai/models/sd-1/main/openjourney/text_encoder
__invokeai_model_sd15_openjourney get_invokeai_model licyks/invokeai-model/master/sd-1/main/openjourney/tokenizer/merges.txt ./invokeai/models/sd-1/main/openjourney/tokenizer
__invokeai_model_sd15_openjourney get_invokeai_model licyks/invokeai-model/master/sd-1/main/openjourney/tokenizer/special_tokens_map.json ./invokeai/models/sd-1/main/openjourney/tokenizer
__invokeai_model_sd15_openjourney get_invokeai_model licyks/invokeai-model/master/sd-1/main/openjourney/tokenizer/tokenizer_config.json ./invokeai/models/sd-1/main/openjourney/tokenizer
__invokeai_model_sd15_openjourney get_invokeai_model licyks/invokeai-model/master/sd-1/main/openjourney/tokenizer/vocab.json ./invokeai/models/sd-1/main/openjourney/tokenizer
__invokeai_model_sd15_openjourney get_invokeai_model licyks/invokeai-model/master/sd-1/main/openjourney/unet/config.json ./invokeai/models/sd-1/main/openjourney/unet
__invokeai_model_sd15_openjourney get_invokeai_model licyks/invokeai-model/master/sd-1/main/openjourney/unet/diffusion_pytorch_model.safetensors ./invokeai/models/sd-1/main/openjourney/unet
__invokeai_model_sd15_openjourney get_invokeai_model licyks/invokeai-model/master/sd-1/main/openjourney/vae/config.json ./invokeai/models/sd-1/main/openjourney/vae
__invokeai_model_sd15_openjourney get_invokeai_model licyks/invokeai-model/master/sd-1/main/openjourney/vae/diffusion_pytorch_model.safetensors ./invokeai/models/sd-1/main/openjourney/vae

# sd1.5-official
__invokeai_model_sd15_official get_invokeai_model licyks/invokeai-model/master/sd-1/main/stable-diffusion-v1-5/feature_extractor/preprocessor_config.json ./invokeai/models/sd-1/main/stable-diffusion-v1-5/feature_extractor
__invokeai_model_sd15_official get_invokeai_model licyks/invokeai-model/master/sd-1/main/stable-diffusion-v1-5/model_index.json ./invokeai/models/sd-1/main/stable-diffusion-v1-5
__invokeai_model_sd15_official get_invokeai_model licyks/invokeai-model/master/sd-1/main/stable-diffusion-v1-5/scheduler/scheduler_config.json ./invokeai/models/sd-1/main/stable-diffusion-v1-5/scheduler
__invokeai_model_sd15_official get_invokeai_model licyks/invokeai-model/master/sd-1/main/stable-diffusion-v1-5/text_encoder/config.json ./invokeai/models/sd-1/main/stable-diffusion-v1-5/text_encoder
__invokeai_model_sd15_official get_invokeai_model licyks/invokeai-model/master/sd-1/main/stable-diffusion-v1-5/text_encoder/model.safetensors ./invokeai/models/sd-1/main/stable-diffusion-v1-5/text_encoder
__invokeai_model_sd15_official get_invokeai_model licyks/invokeai-model/master/sd-1/main/stable-diffusion-v1-5/tokenizer/merges.txt ./invokeai/models/sd-1/main/stable-diffusion-v1-5/tokenizer
__invokeai_model_sd15_official get_invokeai_model licyks/invokeai-model/master/sd-1/main/stable-diffusion-v1-5/tokenizer/special_tokens_map.json ./invokeai/models/sd-1/main/stable-diffusion-v1-5/tokenizer
__invokeai_model_sd15_official get_invokeai_model licyks/invokeai-model/master/sd-1/main/stable-diffusion-v1-5/tokenizer/tokenizer_config.json ./invokeai/models/sd-1/main/stable-diffusion-v1-5/tokenizer
__invokeai_model_sd15_official get_invokeai_model licyks/invokeai-model/master/sd-1/main/stable-diffusion-v1-5/tokenizer/vocab.json ./invokeai/models/sd-1/main/stable-diffusion-v1-5/tokenizer
__invokeai_model_sd15_official get_invokeai_model licyks/invokeai-model/master/sd-1/main/stable-diffusion-v1-5/unet/config.json ./invokeai/models/sd-1/main/stable-diffusion-v1-5/unet
__invokeai_model_sd15_official get_invokeai_model licyks/invokeai-model/master/sd-1/main/stable-diffusion-v1-5/unet/diffusion_pytorch_model.safetensors ./invokeai/models/sd-1/main/stable-diffusion-v1-5/unet
__invokeai_model_sd15_official get_invokeai_model licyks/invokeai-model/master/sd-1/main/stable-diffusion-v1-5/vae/config.json ./invokeai/models/sd-1/main/stable-diffusion-v1-5/vae
__invokeai_model_sd15_official get_invokeai_model licyks/invokeai-model/master/sd-1/main/stable-diffusion-v1-5/vae/diffusion_pytorch_model.safetensors ./invokeai/models/sd-1/main/stable-diffusion-v1-5/vae

# sd1.5-inpaint-official
__invokeai_model_sd15_inpaint_official get_invokeai_model licyks/invokeai-model/master/sd-1/main/stable-diffusion-v1-5-inpainting/feature_extractor/preprocessor_config.json ./invokeai/models/sd-1/main/stable-diffusion-v1-5-inpainting/feature_extractor
__invokeai_model_sd15_inpaint_official get_invokeai_model licyks/invokeai-model/master/sd-1/main/stable-diffusion-v1-5-inpainting/model_index.json ./invokeai/models/sd-1/main/stable-diffusion-v1-5-inpainting
__invokeai_model_sd15_inpaint_official get_invokeai_model licyks/invokeai-model/master/sd-1/main/stable-diffusion-v1-5-inpainting/scheduler/scheduler_config.json ./invokeai/models/sd-1/main/stable-diffusion-v1-5-inpainting/scheduler
__invokeai_model_sd15_inpaint_official get_invokeai_model licyks/invokeai-model/master/sd-1/main/stable-diffusion-v1-5-inpainting/text_encoder/config.json ./invokeai/models/sd-1/main/stable-diffusion-v1-5-inpainting/text_encoder
__invokeai_model_sd15_inpaint_official get_invokeai_model licyks/invokeai-model/master/sd-1/main/stable-diffusion-v1-5-inpainting/text_encoder/model.safetensors ./invokeai/models/sd-1/main/stable-diffusion-v1-5-inpainting/text_encoder
__invokeai_model_sd15_inpaint_official get_invokeai_model licyks/invokeai-model/master/sd-1/main/stable-diffusion-v1-5-inpainting/tokenizer/merges.txt ./invokeai/models/sd-1/main/stable-diffusion-v1-5-inpainting/tokenizer
__invokeai_model_sd15_inpaint_official get_invokeai_model licyks/invokeai-model/master/sd-1/main/stable-diffusion-v1-5-inpainting/tokenizer/special_tokens_map.json ./invokeai/models/sd-1/main/stable-diffusion-v1-5-inpainting/tokenizer
__invokeai_model_sd15_inpaint_official get_invokeai_model licyks/invokeai-model/master/sd-1/main/stable-diffusion-v1-5-inpainting/tokenizer/tokenizer_config.json ./invokeai/models/sd-1/main/stable-diffusion-v1-5-inpainting/tokenizer
__invokeai_model_sd15_inpaint_official get_invokeai_model licyks/invokeai-model/master/sd-1/main/stable-diffusion-v1-5-inpainting/tokenizer/vocab.json ./invokeai/models/sd-1/main/stable-diffusion-v1-5-inpainting/tokenizer
__invokeai_model_sd15_inpaint_official get_invokeai_model licyks/invokeai-model/master/sd-1/main/stable-diffusion-v1-5-inpainting/unet/config.json ./invokeai/models/sd-1/main/stable-diffusion-v1-5-inpainting/unet
__invokeai_model_sd15_inpaint_official get_invokeai_model licyks/invokeai-model/master/sd-1/main/stable-diffusion-v1-5-inpainting/unet/diffusion_pytorch_model.safetensors ./invokeai/models/sd-1/main/stable-diffusion-v1-5-inpainting/unet
__invokeai_model_sd15_inpaint_official get_invokeai_model licyks/invokeai-model/master/sd-1/main/stable-diffusion-v1-5-inpainting/vae/config.json ./invokeai/models/sd-1/main/stable-diffusion-v1-5-inpainting/vae
__invokeai_model_sd15_inpaint_official get_invokeai_model licyks/invokeai-model/master/sd-1/main/stable-diffusion-v1-5-inpainting/vae/diffusion_pytorch_model.safetensors ./invokeai/models/sd-1/main/stable-diffusion-v1-5-inpainting/vae


# sd2.1
__invokeai_model_sd21_official get_invokeai_model licyks/invokeai-model/master/sd-2/main/stable-diffusion-2-1/feature_extractor/preprocessor_config.json ./invokeai/models/sd-2/main/stable-diffusion-2-1/feature_extractor
__invokeai_model_sd21_official get_invokeai_model licyks/invokeai-model/master/sd-2/main/stable-diffusion-2-1/model_index.json ./invokeai/models/sd-2/main/stable-diffusion-2-1
__invokeai_model_sd21_official get_invokeai_model licyks/invokeai-model/master/sd-2/main/stable-diffusion-2-1/scheduler/scheduler_config.json ./invokeai/models/sd-2/main/stable-diffusion-2-1/scheduler
__invokeai_model_sd21_official get_invokeai_model licyks/invokeai-model/master/sd-2/main/stable-diffusion-2-1/text_encoder/config.json ./invokeai/models/sd-2/main/stable-diffusion-2-1/text_encoder
__invokeai_model_sd21_official get_invokeai_model licyks/invokeai-model/master/sd-2/main/stable-diffusion-2-1/text_encoder/model.safetensors ./invokeai/models/sd-2/main/stable-diffusion-2-1/text_encoder
__invokeai_model_sd21_official get_invokeai_model licyks/invokeai-model/master/sd-2/main/stable-diffusion-2-1/tokenizer/merges.txt ./invokeai/models/sd-2/main/stable-diffusion-2-1/tokenizer
__invokeai_model_sd21_official get_invokeai_model licyks/invokeai-model/master/sd-2/main/stable-diffusion-2-1/tokenizer/special_tokens_map.json ./invokeai/models/sd-2/main/stable-diffusion-2-1/tokenizer
__invokeai_model_sd21_official get_invokeai_model licyks/invokeai-model/master/sd-2/main/stable-diffusion-2-1/tokenizer/tokenizer_config.json ./invokeai/models/sd-2/main/stable-diffusion-2-1/tokenizer
__invokeai_model_sd21_official get_invokeai_model licyks/invokeai-model/master/sd-2/main/stable-diffusion-2-1/tokenizer/vocab.json ./invokeai/models/sd-2/main/stable-diffusion-2-1/tokenizer
__invokeai_model_sd21_official get_invokeai_model licyks/invokeai-model/master/sd-2/main/stable-diffusion-2-1/unet/config.json ./invokeai/models/sd-2/main/stable-diffusion-2-1/unet
__invokeai_model_sd21_official get_invokeai_model licyks/invokeai-model/master/sd-2/main/stable-diffusion-2-1/unet/diffusion_pytorch_model.safetensors ./invokeai/models/sd-2/main/stable-diffusion-2-1/unet
__invokeai_model_sd21_official get_invokeai_model licyks/invokeai-model/master/sd-2/main/stable-diffusion-2-1/vae/config.json ./invokeai/models/sd-2/main/stable-diffusion-2-1/vae
__invokeai_model_sd21_official get_invokeai_model licyks/invokeai-model/master/sd-2/main/stable-diffusion-2-1/vae/diffusion_pytorch_model.safetensors ./invokeai/models/sd-2/main/stable-diffusion-2-1/vae

# sd2.1-inpaint
__invokeai_model_sd21_inpaint_official get_invokeai_model licyks/invokeai-model/master/sd-2/main/stable-diffusion-2-inpainting/feature_extractor/preprocessor_config.json ./invokeai/models/sd-2/main/stable-diffusion-2-inpainting/feature_extractor
__invokeai_model_sd21_inpaint_official get_invokeai_model licyks/invokeai-model/master/sd-2/main/stable-diffusion-2-inpainting/model_index.json ./invokeai/models/sd-2/main/stable-diffusion-2-inpainting
__invokeai_model_sd21_inpaint_official get_invokeai_model licyks/invokeai-model/master/sd-2/main/stable-diffusion-2-inpainting/scheduler/scheduler_config.json ./invokeai/models/sd-2/main/stable-diffusion-2-inpainting/scheduler
__invokeai_model_sd21_inpaint_official get_invokeai_model licyks/invokeai-model/master/sd-2/main/stable-diffusion-2-inpainting/text_encoder/config.json ./invokeai/models/sd-2/main/stable-diffusion-2-inpainting/text_encoder
__invokeai_model_sd21_inpaint_official get_invokeai_model licyks/invokeai-model/master/sd-2/main/stable-diffusion-2-inpainting/text_encoder/model.safetensors ./invokeai/models/sd-2/main/stable-diffusion-2-inpainting/text_encoder
__invokeai_model_sd21_inpaint_official get_invokeai_model licyks/invokeai-model/master/sd-2/main/stable-diffusion-2-inpainting/tokenizer/merges.txt ./invokeai/models/sd-2/main/stable-diffusion-2-inpainting/tokenizer
__invokeai_model_sd21_inpaint_official get_invokeai_model licyks/invokeai-model/master/sd-2/main/stable-diffusion-2-inpainting/tokenizer/special_tokens_map.json ./invokeai/models/sd-2/main/stable-diffusion-2-inpainting/tokenizer
__invokeai_model_sd21_inpaint_official get_invokeai_model licyks/invokeai-model/master/sd-2/main/stable-diffusion-2-inpainting/tokenizer/tokenizer_config.json ./invokeai/models/sd-2/main/stable-diffusion-2-inpainting/tokenizer
__invokeai_model_sd21_inpaint_official get_invokeai_model licyks/invokeai-model/master/sd-2/main/stable-diffusion-2-inpainting/tokenizer/vocab.json ./invokeai/models/sd-2/main/stable-diffusion-2-inpainting/tokenizer
__invokeai_model_sd21_inpaint_official get_invokeai_model licyks/invokeai-model/master/sd-2/main/stable-diffusion-2-inpainting/unet/config.json ./invokeai/models/sd-2/main/stable-diffusion-2-inpainting/unet
__invokeai_model_sd21_inpaint_official get_invokeai_model licyks/invokeai-model/master/sd-2/main/stable-diffusion-2-inpainting/unet/diffusion_pytorch_model.safetensors ./invokeai/models/sd-2/main/stable-diffusion-2-inpainting/unet
__invokeai_model_sd21_inpaint_official get_invokeai_model licyks/invokeai-model/master/sd-2/main/stable-diffusion-2-inpainting/vae/config.json ./invokeai/models/sd-2/main/stable-diffusion-2-inpainting/vae
__invokeai_model_sd21_inpaint_official get_invokeai_model licyks/invokeai-model/master/sd-2/main/stable-diffusion-2-inpainting/vae/diffusion_pytorch_model.safetensors ./invokeai/models/sd-2/main/stable-diffusion-2-inpainting/vae

# sdxl
__invokeai_model_sdxl_official get_invokeai_model licyks/invokeai-model/master/sdxl/main/stable-diffusion-xl-base-1-0/model_index.json ./invokeai/models/sdxl/main/stable-diffusion-xl-base-1-0
__invokeai_model_sdxl_official get_invokeai_model licyks/invokeai-model/master/sdxl/main/stable-diffusion-xl-base-1-0/scheduler/scheduler_config.json ./invokeai/models/sdxl/main/stable-diffusion-xl-base-1-0/scheduler
__invokeai_model_sdxl_official get_invokeai_model licyks/invokeai-model/master/sdxl/main/stable-diffusion-xl-base-1-0/text_encoder/config.json ./invokeai/models/sdxl/main/stable-diffusion-xl-base-1-0/text_encoder
__invokeai_model_sdxl_official get_invokeai_model licyks/invokeai-model/master/sdxl/main/stable-diffusion-xl-base-1-0/text_encoder/model.safetensors ./invokeai/models/sdxl/main/stable-diffusion-xl-base-1-0/text_encoder
__invokeai_model_sdxl_official get_invokeai_model licyks/invokeai-model/master/sdxl/main/stable-diffusion-xl-base-1-0/text_encoder_2/config.json ./invokeai/models/sdxl/main/stable-diffusion-xl-base-1-0/text_encoder_2
__invokeai_model_sdxl_official get_invokeai_model licyks/invokeai-model/master/sdxl/main/stable-diffusion-xl-base-1-0/text_encoder_2/model.safetensors ./invokeai/models/sdxl/main/stable-diffusion-xl-base-1-0/text_encoder_2
__invokeai_model_sdxl_official get_invokeai_model licyks/invokeai-model/master/sdxl/main/stable-diffusion-xl-base-1-0/tokenizer/merges.txt ./invokeai/models/sdxl/main/stable-diffusion-xl-base-1-0/tokenizer
__invokeai_model_sdxl_official get_invokeai_model licyks/invokeai-model/master/sdxl/main/stable-diffusion-xl-base-1-0/tokenizer/special_tokens_map.json ./invokeai/models/sdxl/main/stable-diffusion-xl-base-1-0/tokenizer
__invokeai_model_sdxl_official get_invokeai_model licyks/invokeai-model/master/sdxl/main/stable-diffusion-xl-base-1-0/tokenizer/tokenizer_config.json ./invokeai/models/sdxl/main/stable-diffusion-xl-base-1-0/tokenizer
__invokeai_model_sdxl_official get_invokeai_model licyks/invokeai-model/master/sdxl/main/stable-diffusion-xl-base-1-0/tokenizer/vocab.json ./invokeai/models/sdxl/main/stable-diffusion-xl-base-1-0/tokenizer
__invokeai_model_sdxl_official get_invokeai_model licyks/invokeai-model/master/sdxl/main/stable-diffusion-xl-base-1-0/tokenizer_2/merges.txt ./invokeai/models/sdxl/main/stable-diffusion-xl-base-1-0/tokenizer_2
__invokeai_model_sdxl_official get_invokeai_model licyks/invokeai-model/master/sdxl/main/stable-diffusion-xl-base-1-0/tokenizer_2/special_tokens_map.json ./invokeai/models/sdxl/main/stable-diffusion-xl-base-1-0/tokenizer_2
__invokeai_model_sdxl_official get_invokeai_model licyks/invokeai-model/master/sdxl/main/stable-diffusion-xl-base-1-0/tokenizer_2/tokenizer_config.json ./invokeai/models/sdxl/main/stable-diffusion-xl-base-1-0/tokenizer_2
__invokeai_model_sdxl_official get_invokeai_model licyks/invokeai-model/master/sdxl/main/stable-diffusion-xl-base-1-0/tokenizer_2/vocab.json ./invokeai/models/sdxl/main/stable-diffusion-xl-base-1-0/tokenizer_2
__invokeai_model_sdxl_official get_invokeai_model licyks/invokeai-model/master/sdxl/main/stable-diffusion-xl-base-1-0/unet/config.json ./invokeai/models/sdxl/main/stable-diffusion-xl-base-1-0/unet
__invokeai_model_sdxl_official get_invokeai_model licyks/invokeai-model/master/sdxl/main/stable-diffusion-xl-base-1-0/unet/diffusion_pytorch_model.safetensors ./invokeai/models/sdxl/main/stable-diffusion-xl-base-1-0/unet
__invokeai_model_sdxl_official get_invokeai_model licyks/invokeai-model/master/sdxl/main/stable-diffusion-xl-base-1-0/vae/config.json ./invokeai/models/sdxl/main/stable-diffusion-xl-base-1-0/vae
__invokeai_model_sdxl_official get_invokeai_model licyks/invokeai-model/master/sdxl/main/stable-diffusion-xl-base-1-0/vae/diffusion_pytorch_model.safetensors ./invokeai/models/sdxl/main/stable-diffusion-xl-base-1-0/vae
# sdxl-vae
__invokeai_model_sdxl_vae_official get_invokeai_model licyks/invokeai-model/master/sdxl/vae/sdxl-1-0-vae-fix/config.json ./invokeai/models/sdxl/vae/sdxl-1-0-vae-fix
__invokeai_model_sdxl_vae_official get_invokeai_model licyks/invokeai-model/master/sdxl/vae/sdxl-1-0-vae-fix/diffusion_pytorch_model.safetensors ./invokeai/models/sdxl/vae/sdxl-1-0-vae-fix
# sdxl-refind
__invokeai_model_sdxl_refind_official get_invokeai_model licyks/invokeai-model/master/sdxl-refiner/main/stable-diffusion-xl-refiner-1-0/model_index.json ./invokeai/models/sdxl-refiner/main/stable-diffusion-xl-refiner-1-0
__invokeai_model_sdxl_refind_official get_invokeai_model licyks/invokeai-model/master/sdxl-refiner/main/stable-diffusion-xl-refiner-1-0/scheduler/scheduler_config.json ./invokeai/models/sdxl-refiner/main/stable-diffusion-xl-refiner-1-0/scheduler
__invokeai_model_sdxl_refind_official get_invokeai_model licyks/invokeai-model/master/sdxl-refiner/main/stable-diffusion-xl-refiner-1-0/text_encoder_2/config.json ./invokeai/models/sdxl-refiner/main/stable-diffusion-xl-refiner-1-0/text_encoder_2
__invokeai_model_sdxl_refind_official get_invokeai_model licyks/invokeai-model/master/sdxl-refiner/main/stable-diffusion-xl-refiner-1-0/text_encoder_2/model.safetensors ./invokeai/models/sdxl-refiner/main/stable-diffusion-xl-refiner-1-0/text_encoder_2
__invokeai_model_sdxl_refind_official get_invokeai_model licyks/invokeai-model/master/sdxl-refiner/main/stable-diffusion-xl-refiner-1-0/tokenizer_2/merges.txt ./invokeai/models/sdxl-refiner/main/stable-diffusion-xl-refiner-1-0/tokenizer_2
__invokeai_model_sdxl_refind_official get_invokeai_model licyks/invokeai-model/master/sdxl-refiner/main/stable-diffusion-xl-refiner-1-0/tokenizer_2/special_tokens_map.json ./invokeai/models/sdxl-refiner/main/stable-diffusion-xl-refiner-1-0/tokenizer_2
__invokeai_model_sdxl_refind_official get_invokeai_model licyks/invokeai-model/master/sdxl-refiner/main/stable-diffusion-xl-refiner-1-0/tokenizer_2/tokenizer_config.json ./invokeai/models/sdxl-refiner/main/stable-diffusion-xl-refiner-1-0/tokenizer_2
__invokeai_model_sdxl_refind_official get_invokeai_model licyks/invokeai-model/master/sdxl-refiner/main/stable-diffusion-xl-refiner-1-0/tokenizer_2/vocab.json ./invokeai/models/sdxl-refiner/main/stable-diffusion-xl-refiner-1-0/tokenizer_2
__invokeai_model_sdxl_refind_official get_invokeai_model licyks/invokeai-model/master/sdxl-refiner/main/stable-diffusion-xl-refiner-1-0/unet/config.json ./invokeai/models/sdxl-refiner/main/stable-diffusion-xl-refiner-1-0/unet
__invokeai_model_sdxl_refind_official get_invokeai_model licyks/invokeai-model/master/sdxl-refiner/main/stable-diffusion-xl-refiner-1-0/unet/diffusion_pytorch_model.safetensors ./invokeai/models/sdxl-refiner/main/stable-diffusion-xl-refiner-1-0/unet
__invokeai_model_sdxl_refind_official get_invokeai_model licyks/invokeai-model/master/sdxl-refiner/main/stable-diffusion-xl-refiner-1-0/vae/config.json ./invokeai/models/sdxl-refiner/main/stable-diffusion-xl-refiner-1-0/vae
__invokeai_model_sdxl_refind_official get_invokeai_model licyks/invokeai-model/master/sdxl-refiner/main/stable-diffusion-xl-refiner-1-0/vae/diffusion_pytorch_model.safetensors ./invokeai/models/sdxl-refiner/main/stable-diffusion-xl-refiner-1-0/vae
EOF
}

# 模型下载
get_invokeai_model()
{
    local modelscope_user=$(echo $@ | awk '{gsub(/[/]/, " ")}1' | awk '{print$1}')
    local modelscope_name=$(echo $@ | awk '{gsub(/[/]/, " ")}1' | awk '{print$2}')
    local modelscope_branch=$(echo $@ | awk '{gsub(/[/]/, " ")}1' | awk '{print$3}')
    local modelscope_model_path=$(echo $1 | awk '{sub("'${modelscope_user}/${modelscope_name}/${modelscope_branch}/'","")}1')
    local invokeai_model_url="https://modelscope.cn/api/v1/models/${modelscope_user}/${modelscope_name}/repo?Revision=${modelscope_branch}&FilePath=${modelscope_model_path}"
    local local_file_path="${2}/$(echo $1 | awk -F'/' '{print$NF}')"
    local local_aria_cache_path="${2}/$(echo $1 | awk -F'/' '{print$NF}').aria"
    if [ ! -f "$local_file_path" ];then
        term_sd_echo "下载$(echo $modelscope_model_path | awk -F '/' '{print$NF}')中"
        term_sd_watch aria2c $aria2_multi_threaded $invokeai_model_url -d ${2} -o $(echo $1 | awk -F'/' '{print$NF}')
    else
        if [ -f "$local_aria_cache_path" ];then
            term_sd_echo "下载$(echo $modelscope_model_path | awk -F '/' '{print$NF}')中"
            term_sd_watch aria2c $aria2_multi_threaded $invokeai_model_url -d ${2} -o $(echo $1 | awk -F'/' '{print$NF}')
        else
            term_sd_echo "$(echo $modelscope_model_path | awk -F '/' '{print$NF}')文件已存在,跳过下载该文件"
        fi
    fi
}

invokeai_model_download()
{
    invokeai_model_select
    if [ $? = 0 ];then
        term_sd_echo "生成任务队列"
        for i in $invokeai_model_select_dialog ; do
            invokeai_model_list | grep -w $i >> "$start_path/term-sd/task/invokeai_model_download.sh"
        done
        term_sd_echo "任务队列生成完成"
        term_sd_echo "开始下载InvokeAI模型"
        for ((cmd_point=1;cmd_point<=cmd_sum;cmd_point++))
        do
            install_cmd=$(term_sd_get_task_cmd $(cat "$start_path/term-sd/task/invokeai_model_download.sh" | awk 'NR=='${cmd_point}'{print$0}'))
            echo "$install_cmd" > "$start_path/term-sd/task/cache.sh" # 取出命令并放入缓存文件中
            source "$start_path/term-sd/task/cache.sh" # 执行命令
        done

        rm -f "$start_path/term-sd/task/invokeai_model_download.sh" # 删除任务文件
        rm -f "$start_path/term-sd/task/cache.sh"
        term_sd_echo "模型下载结束"
    fi
}

invokeai_model_download