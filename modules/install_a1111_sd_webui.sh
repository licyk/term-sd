#!/bin/bash

#a1111-sd-webui安装处理部分
function process_install_a1111_sd_webui()
{
    #安装前的准备
    proxy_option #代理选择
    pytorch_version_select #pytorch选择
    pip_install_methon #安装方式选择
    a1111_sd_webui_extension_option #插件选择
    final_install_check #安装前确认

    if [ $final_install_check_exec = 0 ];then
        #开始安装
        print_line_to_shell "stable-diffusion-webui 安装"
        term_sd_notice "开始安装stable-diffusion-webui"
        tmp_disable_proxy #临时取消代理,避免一些不必要的网络减速
        git clone "$github_proxy"https://github.com/AUTOMATIC1111/stable-diffusion-webui
        [ ! -d "./$term_sd_manager_info" ] && tmp_enable_proxy && term_sd_notice "检测到"$term_sd_manager_info"框架安装失败,已终止安装进程" && sleep 3 && return 1 #防止继续进行安装导致文件散落,造成目录混乱
        cd ./stable-diffusion-webui
        create_venv
        enter_venv
        cd ..

        #安装的依赖参考"stable-diffusion-webui/modules/launch_utils.py"
        if [ ! -d "./stable-diffusion-webui/repositories" ];then
            mkdir ./stable-diffusion-webui/repositories
        fi
        git clone "$github_proxy"https://github.com/sczhou/CodeFormer ./stable-diffusion-webui/repositories/CodeFormer
        git clone "$github_proxy"https://github.com/salesforce/BLIP ./stable-diffusion-webui/repositories/BLIP
        git clone "$github_proxy"https://github.com/Stability-AI/stablediffusion ./stable-diffusion-webui/repositories/stable-diffusion-stability-ai
        git clone "$github_proxy"https://github.com/Stability-AI/generative-models ./stable-diffusion-webui/repositories/generative-models
        git clone "$github_proxy"https://github.com/crowsonkb/k-diffusion ./stable-diffusion-webui/repositories/k-diffusion

        if [ ! -z "$(echo $pytorch_install_version | awk '{gsub(/[=+]/, "")}1')" ];then
            pip_cmd install $pytorch_install_version $pip_index_mirror $pip_extra_index_mirror $pip_find_mirror $force_pip $pip_install_methon_select --prefer-binary --default-timeout=100 --retries 5 #"--default-timeout=100 --retries 5"在网络差导致下载中断时重试下载
        fi
        pip_cmd install git+"$github_proxy"https://github.com/openai/CLIP --prefer-binary $pip_index_mirror $pip_extra_index_mirror $pip_find_mirror $force_pip $pip_install_methon_select --default-timeout=100 --retries 5

        pip_cmd install -r ./stable-diffusion-webui/repositories/CodeFormer/requirements.txt --prefer-binary $pip_index_mirror $pip_extra_index_mirror $pip_find_mirror $force_pip $pip_install_methon_select --default-timeout=100 --retries 5
        pip_cmd install -r ./stable-diffusion-webui/requirements.txt --prefer-binary $pip_index_mirror $pip_extra_index_mirror $pip_find_mirror $force_pip $pip_install_methon_select --default-timeout=100 --retries 5 #安装stable-diffusion-webui的依赖

        term_sd_notice "生成配置中"
        echo "{" > config-for-sd-webui.json
        echo "    \"quicksettings_list\": [" >> config-for-sd-webui.json
        echo "        \"sd_model_checkpoint\"," >> config-for-sd-webui.json
        echo "        \"sd_vae\"," >> config-for-sd-webui.json
        echo "        \"CLIP_stop_at_last_layers\"" >> config-for-sd-webui.json   
        echo "    ]," >> config-for-sd-webui.json
        echo "    \"save_to_dirs\": false," >> config-for-sd-webui.json
        echo "    \"grid_save_to_dirs\": false," >> config-for-sd-webui.json
        echo "    \"hires_fix_show_sampler\": true," >> config-for-sd-webui.json
        echo "    \"CLIP_stop_at_last_layers\": 2" >> config-for-sd-webui.json
        echo "}" >> config-for-sd-webui.json
        mv -f config-for-sd-webui.json ./stable-diffusion-webui
        mv -f ./stable-diffusion-webui/config-for-sd-webui.json ./stable-diffusion-webui/config.json

        if [ ! -z "$a1111_sd_webui_extension_install_list" ];then
            term_sd_notice "安装插件中"
            for  a1111_sd_webui_extension_install_list_ in $a1111_sd_webui_extension_install_list ;do
                git clone --recurse-submodules "$github_proxy"$a1111_sd_webui_extension_install_list_ ./stable-diffusion-webui/extensions/$(echo $a1111_sd_webui_extension_install_list_ | awk -F'/' '{print $NF}')
            done
        fi

        term_sd_notice "下载模型中"
        tmp_enable_proxy #恢复原有的代理,保证能从huggingface下载模型
        aria2c $aria2_multi_threaded https://huggingface.co/runwayml/stable-diffusion-v1-5/resolve/main/v1-5-pruned-emaonly.ckpt -d ./stable-diffusion-webui/models/Stable-diffusion -o sd-v1-5.ckpt
        aria2c $aria2_multi_threaded https://huggingface.co/licyk/sd-upscaler-models/resolve/main/ESRGAN/4x-UltraSharp.pth -d ./stable-diffusion-webui/models/ESRGAN -o 4x-UltraSharp.pth
        aria2c $aria2_multi_threaded https://huggingface.co/licyk/sd-upscaler-models/resolve/main/ESRGAN/BSRGAN.pth -d ./stable-diffusion-webui/models/ESRGAN -o BSRGAN.pth
        aria2c $aria2_multi_threaded https://huggingface.co/licyk/sd-upscaler-models/resolve/main/ESRGAN/ESRGAN_4x.pth -d ./stable-diffusion-webui/models/ESRGAN -o ESRGAN_4x.pth
        aria2c $aria2_multi_threaded https://huggingface.co/licyk/sd-upscaler-models/resolve/main/GFPGAN/GFPGANv1.4.pth -d ./stable-diffusion-webui/models/ESRGAN -o GFPGANv1.4.pth
        aria2c $aria2_multi_threaded https://huggingface.co/licyk/sd-upscaler-models/resolve/main/GFPGAN/detection_Resnet50_Final.pth -d ./stable-diffusion-webui/models/ESRGAN -o detection_Resnet50_Final.pth
        aria2c $aria2_multi_threaded https://huggingface.co/licyk/sd-upscaler-models/resolve/main/GFPGAN/parsing_bisenet.pth -d ./stable-diffusion-webui/models/ESRGAN -o parsing_bisenet.pth
        aria2c $aria2_multi_threaded https://huggingface.co/licyk/sd-upscaler-models/resolve/main/GFPGAN/parsing_parsenet.pth -d ./stable-diffusion-webui/models/ESRGAN -o parsing_parsenet.pth
        aria2c $aria2_multi_threaded https://huggingface.co/licyk/sd-upscaler-models/resolve/main/RealESRGAN/RealESRGAN_x4plus.pth -d ./stable-diffusion-webui/models/ESRGAN -o RealESRGAN_x4plus.pth
        aria2c $aria2_multi_threaded https://huggingface.co/licyk/sd-upscaler-models/resolve/main/RealESRGAN/RealESRGAN_x4plus_anime_6B.pth -d ./stable-diffusion-webui/models/ESRGAN -o RealESRGAN_x4plus_anime_6B.pth
        aria2c $aria2_multi_threaded https://huggingface.co/licyk/sd-vae/resolve/main/vae-approx/model.pt -d ./stable-diffusion-webui/models/VAE-approx -o model.pt
        aria2c $aria2_multi_threaded https://huggingface.co/licyk/sd-vae/resolve/main/vae-approx/vaeapprox-sdxl.pt -d ./stable-diffusion-webui/models/VAE-approx -o vaeapprox-sdxl.pt
        aria2c $aria2_multi_threaded https://huggingface.co/licyk/sd-embeddings/resolve/main/sd_1.5/EasyNegativeV2.safetensors -d ./stable-diffusion-webui/embeddings/negative -o EasyNegativeV2.safetensors
        aria2c $aria2_multi_threaded https://huggingface.co/licyk/sd-embeddings/resolve/main/sd_1.5/bad-artist-anime.pt -d ./stable-diffusion-webui/embeddings/negative -o bad-artist-anime.pt
        aria2c $aria2_multi_threaded https://huggingface.co/licyk/sd-embeddings/resolve/main/sd_1.5/bad-artist.pt -d ./stable-diffusion-webui/embeddings/negative -o bad-artist.pt
        aria2c $aria2_multi_threaded https://huggingface.co/licyk/sd-embeddings/resolve/main/sd_1.5/bad-hands-5.pt -d ./stable-diffusion-webui/embeddings/negative -o bad-hands-5.pt
        aria2c $aria2_multi_threaded https://huggingface.co/licyk/sd-embeddings/resolve/main/sd_1.5/bad-image-v2-39000.pt -d ./stable-diffusion-webui/embeddings/negative -o bad-image-v2-39000.pt
        aria2c $aria2_multi_threaded https://huggingface.co/licyk/sd-embeddings/resolve/main/sd_1.5/bad_prompt_version2.pt -d ./stable-diffusion-webui/embeddings/negative -o bad_prompt_version2.pt
        aria2c $aria2_multi_threaded https://huggingface.co/licyk/sd-embeddings/resolve/main/sd_1.5/ng_deepnegative_v1_75t.pt -d ./stable-diffusion-webui/embeddings/negative -o ng_deepnegative_v1_75t.pt
        aria2c $aria2_multi_threaded https://huggingface.co/licyk/sd-embeddings/resolve/main/sd_1.5/verybadimagenegative_v1.3.pt -d ./stable-diffusion-webui/embeddings/negative -o verybadimagenegative_v1.3.pt
        aria2c $aria2_multi_threaded https://huggingface.co/licyk/sd-embeddings/resolve/main/sd_1.5/yaguru%20magiku.pt -d ./stable-diffusion-webui/embeddings -o yaguru_magiku.pt

        if [ $a1111_sd_webui_extension_model_1 = 0 ];then #安装controlnet时再下载相关模型
            term_sd_notice "下载controlnet模型中"
            aria2c $aria2_multi_threaded https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/control_v11e_sd15_ip2p_fp16.safetensors -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o control_v11e_sd15_ip2p_fp16.safetensors
            aria2c $aria2_multi_threaded https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/control_v11e_sd15_shuffle_fp16.safetensors -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o control_v11e_sd15_shuffle_fp16.safetensors
            aria2c $aria2_multi_threaded https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/control_v11p_sd15_canny_fp16.safetensors -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o control_v11p_sd15_canny_fp16.safetensors
            aria2c $aria2_multi_threaded https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/control_v11f1p_sd15_depth_fp16.safetensors -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o control_v11f1p_sd15_depth_fp16.safetensors
            aria2c $aria2_multi_threaded https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/control_v11p_sd15_inpaint_fp16.safetensors -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o control_v11p_sd15_inpaint_fp16.safetensors
            aria2c $aria2_multi_threaded https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/control_v11p_sd15_lineart_fp16.safetensors -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o control_v11p_sd15_lineart_fp16.safetensors
            aria2c $aria2_multi_threaded https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/control_v11p_sd15_mlsd_fp16.safetensors -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o control_v11p_sd15_mlsd_fp16.safetensors
            aria2c $aria2_multi_threaded https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/control_v11p_sd15_normalbae_fp16.safetensors -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o control_v11p_sd15_normalbae_fp16.safetensors
            aria2c $aria2_multi_threaded https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/control_v11p_sd15_openpose_fp16.safetensors -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o control_v11p_sd15_openpose_fp16.safetensors
            aria2c $aria2_multi_threaded https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/control_v11p_sd15_scribble_fp16.safetensors -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o control_v11p_sd15_scribble_fp16.safetensors
            aria2c $aria2_multi_threaded https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/control_v11p_sd15_seg_fp16.safetensors -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o control_v11p_sd15_seg_fp16.safetensors
            aria2c $aria2_multi_threaded https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/control_v11p_sd15_softedge_fp16.safetensors -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o control_v11p_sd15_softedge_fp16.safetensors
            aria2c $aria2_multi_threaded https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/control_v11p_sd15s2_lineart_anime_fp16.safetensors -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o control_v11p_sd15s2_lineart_anime_fp16.safetensors
            aria2c $aria2_multi_threaded https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/control_v11f1e_sd15_tile_fp16.safetensors -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o control_v11f1e_sd15_tile_fp16.safetensors
            aria2c $aria2_multi_threaded https://huggingface.co/ckpt/ControlNet-v1-1/raw/main/control_v11e_sd15_ip2p_fp16.yaml -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o control_v11e_sd15_ip2p_fp16.yaml
            aria2c $aria2_multi_threaded https://huggingface.co/ckpt/ControlNet-v1-1/raw/main/control_v11e_sd15_shuffle_fp16.yaml -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o control_v11e_sd15_shuffle_fp16.yaml
            aria2c $aria2_multi_threaded https://huggingface.co/ckpt/ControlNet-v1-1/raw/main/control_v11p_sd15_canny_fp16.yaml -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o control_v11p_sd15_canny_fp16.yaml
            aria2c $aria2_multi_threaded https://huggingface.co/ckpt/ControlNet-v1-1/raw/main/control_v11f1p_sd15_depth_fp16.yaml -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o control_v11f1p_sd15_depth_fp16.yaml
            aria2c $aria2_multi_threaded https://huggingface.co/ckpt/ControlNet-v1-1/raw/main/control_v11p_sd15_inpaint_fp16.yaml -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o control_v11p_sd15_inpaint_fp16.yaml
            aria2c $aria2_multi_threaded https://huggingface.co/ckpt/ControlNet-v1-1/raw/main/control_v11p_sd15_lineart_fp16.yaml -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o control_v11p_sd15_lineart_fp16.yaml
            aria2c $aria2_multi_threaded https://huggingface.co/ckpt/ControlNet-v1-1/raw/main/control_v11p_sd15_mlsd_fp16.yaml -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o control_v11p_sd15_mlsd_fp16.yaml
            aria2c $aria2_multi_threaded https://huggingface.co/ckpt/ControlNet-v1-1/raw/main/control_v11p_sd15_normalbae_fp16.yaml -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o control_v11p_sd15_normalbae_fp16.yaml
            aria2c $aria2_multi_threaded https://huggingface.co/ckpt/ControlNet-v1-1/raw/main/control_v11p_sd15_openpose_fp16.yaml -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o control_v11p_sd15_openpose_fp16.yaml
            aria2c $aria2_multi_threaded https://huggingface.co/ckpt/ControlNet-v1-1/raw/main/control_v11p_sd15_scribble_fp16.yaml -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o control_v11p_sd15_scribble_fp16.yaml
            aria2c $aria2_multi_threaded https://huggingface.co/ckpt/ControlNet-v1-1/raw/main/control_v11p_sd15_seg_fp16.yaml -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o control_v11p_sd15_seg_fp16.yaml
            aria2c $aria2_multi_threaded https://huggingface.co/ckpt/ControlNet-v1-1/raw/main/control_v11p_sd15_softedge_fp16.yaml -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o control_v11p_sd15_softedge_fp16.yaml
            aria2c $aria2_multi_threaded https://huggingface.co/ckpt/ControlNet-v1-1/raw/main/control_v11p_sd15s2_lineart_anime_fp16.yaml -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o control_v11p_sd15s2_lineart_anime_fp16.yaml
            aria2c $aria2_multi_threaded https://huggingface.co/ckpt/ControlNet-v1-1/raw/main/control_v11f1e_sd15_tile_fp16.yaml -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o control_v11f1e_sd15_tile_fp16.yaml
            aria2c $aria2_multi_threaded https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/t2iadapter_style_sd14v1.pth -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o t2iadapter_style_sd14v1.pth
            aria2c $aria2_multi_threaded https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/t2iadapter_sketch_sd14v1.pth -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o t2iadapter_sketch_sd14v1.pth
            aria2c $aria2_multi_threaded https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/t2iadapter_seg_sd14v1.pth -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o t2iadapter_seg_sd14v1.pth
            aria2c $aria2_multi_threaded https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/t2iadapter_openpose_sd14v1.pth -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o t2iadapter_openpose_sd14v1.pth
            aria2c $aria2_multi_threaded https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/t2iadapter_keypose_sd14v1.pth -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o t2iadapter_keypose_sd14v1.pth
            aria2c $aria2_multi_threaded https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/t2iadapter_depth_sd14v1.pth -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o t2iadapter_depth_sd14v1.pth
            aria2c $aria2_multi_threaded https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/t2iadapter_color_sd14v1.pth -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o t2iadapter_color_sd14v1.pth
            aria2c $aria2_multi_threaded https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/t2iadapter_canny_sd14v1.pth -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o t2iadapter_canny_sd14v1.pth
            aria2c $aria2_multi_threaded https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/t2iadapter_canny_sd15v2.pth -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o t2iadapter_canny_sd15v2.pth
            aria2c $aria2_multi_threaded https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/t2iadapter_depth_sd15v2.pth -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o t2iadapter_depth_sd15v2.pth
            aria2c $aria2_multi_threaded https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/t2iadapter_sketch_sd15v2.pth -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o t2iadapter_sketch_sd15v2.pth
            aria2c $aria2_multi_threaded https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/t2iadapter_zoedepth_sd15v1.pth -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o t2iadapter_zoedepth_sd15v1.pth
            aria2c $aria2_multi_threaded https://huggingface.co/ioclab/ioc-controlnet/resolve/main/models/control_v1p_sd15_brightness.safetensors -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o control_v1p_sd15_brightness.safetensors
            aria2c $aria2_multi_threaded https://huggingface.co/ioclab/ioc-controlnet/resolve/main/models/control_v1p_sd15_illumination.safetensors -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o control_v1p_sd15_illumination.safetensors
            aria2c $aria2_multi_threaded https://huggingface.co/monster-labs/control_v1p_sd15_qrcode_monster/resolve/main/control_v1p_sd15_qrcode_monster.safetensors -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o control_v1p_sd15_qrcode_monster.safetensors
            aria2c $aria2_multi_threaded https://huggingface.co/monster-labs/control_v1p_sd15_qrcode_monster/resolve/main/control_v1p_sd15_qrcode_monster.yaml -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o control_v1p_sd15_qrcode_monster.yaml
            aria2c $aria2_multi_threaded https://huggingface.co/h94/IP-Adapter/resolve/main/models/ip-adapter-plus-face_sd15.bin -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o ip-adapter-plus-face_sd15.pth
            aria2c $aria2_multi_threaded https://huggingface.co/h94/IP-Adapter/resolve/main/models/ip-adapter-plus_sd15.bin -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o ip-adapter-plus_sd15.pth
            aria2c $aria2_multi_threaded https://huggingface.co/h94/IP-Adapter/resolve/main/models/ip-adapter_sd15.bin -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o ip-adapter_sd15.pth
            aria2c $aria2_multi_threaded https://huggingface.co/h94/IP-Adapter/resolve/main/models/ip-adapter_sd15_light.bin -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o ip-adapter_sd15_light.pth
        fi

        if [ $a1111_sd_webui_extension_model_2 = 0 ];then #安装adetailer插件相关模型
            term_sd_notice "下载adetailer模型中"
            aria2c $aria2_multi_threaded https://huggingface.co/Bingsu/adetailer/resolve/main/deepfashion2_yolov8s-seg.pt -d ./stable-diffusion-webui/models/adetailer -o deepfashion2_yolov8s-seg.pt
            aria2c $aria2_multi_threaded https://huggingface.co/Bingsu/adetailer/resolve/main/face_yolov8m.pt -d ./stable-diffusion-webui/models/adetailer -o face_yolov8m.pt
            aria2c $aria2_multi_threaded https://huggingface.co/Bingsu/adetailer/resolve/main/face_yolov8n.pt -d ./stable-diffusion-webui/models/adetailer -o face_yolov8n.pt
            aria2c $aria2_multi_threaded https://huggingface.co/Bingsu/adetailer/resolve/main/face_yolov8n_v2.pt -d ./stable-diffusion-webui/models/adetailer -o face_yolov8n_v2.pt
            aria2c $aria2_multi_threaded https://huggingface.co/Bingsu/adetailer/resolve/main/face_yolov8s.pt -d ./stable-diffusion-webui/models/adetailer -o face_yolov8s.pt
            aria2c $aria2_multi_threaded https://huggingface.co/Bingsu/adetailer/resolve/main/hand_yolov8n.pt -d ./stable-diffusion-webui/models/adetailer -o hand_yolov8n.pt
            aria2c $aria2_multi_threaded https://huggingface.co/Bingsu/adetailer/resolve/main/hand_yolov8s.pt -d ./stable-diffusion-webui/models/adetailer -o hand_yolov8s.pt
            aria2c $aria2_multi_threaded https://huggingface.co/Bingsu/adetailer/resolve/main/person_yolov8m-seg.pt -d ./stable-diffusion-webui/models/adetailer -o person_yolov8m-seg.pt
            aria2c $aria2_multi_threaded https://huggingface.co/Bingsu/adetailer/resolve/main/person_yolov8n-seg.pt -d ./stable-diffusion-webui/models/adetailer -o person_yolov8n-seg.pt
            aria2c $aria2_multi_threaded https://huggingface.co/Bingsu/adetailer/resolve/main/person_yolov8s-seg.pt -d ./stable-diffusion-webui/models/adetailer -o person_yolov8s-seg.pt
        fi

        if [ $a1111_sd_webui_extension_model_3 = 0 ];then #安装sd-webui-IS-NET-pro插件相关模型
            term_sd_notice "下载sd-webui-IS-NET-pro模型中"
            aria2c $aria2_multi_threaded https://huggingface.co/ClockZinc/IS-NET_pth/resolve/main/isnet-general-use.pth -d ./stable-diffusion-webui/extensions/sd-webui-IS-NET-pro/saved_models/IS-Net -o isnet-general-use.pth
        fi

        if [ $a1111_sd_webui_extension_model_4 = 0 ];then #安装sd-webui-animatediff插件相关模型
            term_sd_notice "下载sd-webui-animatediff模型中"
            aria2c $aria2_multi_threaded https://huggingface.co/guoyww/animatediff/resolve/main/mm_sd_v15_v2.ckpt -d ./stable-diffusion-webui/extensions/sd-webui-animatediff/model -o mm_sd_v15_v2.ckpt
        fi

        term_sd_notice "安装结束"
        exit_venv
        print_line_to_shell
        a1111_sd_webui_option
    else
        mainmenu
    fi
}