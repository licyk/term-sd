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
        cmd_daemon git clone "$github_proxy"https://github.com/AUTOMATIC1111/stable-diffusion-webui
        [ ! -d "./$term_sd_manager_info" ] && tmp_enable_proxy && term_sd_notice "检测到"$term_sd_manager_info"框架安装失败,已终止安装进程" && sleep 3 && return 1 #防止继续进行安装导致文件散落,造成目录混乱
        cd ./stable-diffusion-webui
        create_venv
        enter_venv
        cd ..

        #安装的依赖参考"stable-diffusion-webui/modules/launch_utils.py"
        [ ! -d "./stable-diffusion-webui/repositories" ] && mkdir ./stable-diffusion-webui/repositories

        cmd_daemon git clone "$github_proxy"https://github.com/sczhou/CodeFormer ./stable-diffusion-webui/repositories/CodeFormer
        cmd_daemon git clone "$github_proxy"https://github.com/salesforce/BLIP ./stable-diffusion-webui/repositories/BLIP
        cmd_daemon git clone "$github_proxy"https://github.com/Stability-AI/stablediffusion ./stable-diffusion-webui/repositories/stable-diffusion-stability-ai
        cmd_daemon git clone "$github_proxy"https://github.com/Stability-AI/generative-models ./stable-diffusion-webui/repositories/generative-models
        cmd_daemon git clone "$github_proxy"https://github.com/crowsonkb/k-diffusion ./stable-diffusion-webui/repositories/k-diffusion

        if [ ! -z "$(echo $pytorch_install_version | awk '{gsub(/[=+]/, "")}1')" ];then
            cmd_daemon pip_cmd install $pytorch_install_version $pip_index_mirror $pip_extra_index_mirror $pip_find_mirror $force_pip $pip_install_methon_select --prefer-binary --default-timeout=100 --retries 5 #"--default-timeout=100 --retries 5"在网络差导致下载中断时重试下载
        fi
        cmd_daemon pip_cmd install git+"$github_proxy"https://github.com/openai/CLIP --prefer-binary $pip_index_mirror $pip_extra_index_mirror $pip_find_mirror $force_pip $pip_install_methon_select --default-timeout=100 --retries 5

        cmd_daemon pip_cmd install -r ./stable-diffusion-webui/repositories/CodeFormer/requirements.txt --prefer-binary $pip_index_mirror $pip_extra_index_mirror $pip_find_mirror $force_pip $pip_install_methon_select --default-timeout=100 --retries 5
        cmd_daemon pip_cmd install -r ./stable-diffusion-webui/requirements.txt --prefer-binary $pip_index_mirror $pip_extra_index_mirror $pip_find_mirror $force_pip $pip_install_methon_select --default-timeout=100 --retries 5 #安装stable-diffusion-webui的依赖

        term_sd_notice "生成配置中"
        echo "{" > ./stable-diffusion-webui/config.json
        echo "    \"quicksettings_list\": [" >> ./stable-diffusion-webui/config.json
        echo "        \"sd_model_checkpoint\"," >> ./stable-diffusion-webui/config.json
        echo "        \"sd_vae\"," >> ./stable-diffusion-webui/config.json
        echo "        \"CLIP_stop_at_last_layers\"" >> ./stable-diffusion-webui/config.json   
        echo "    ]," >> ./stable-diffusion-webui/config.json
        echo "    \"save_to_dirs\": false," >> ./stable-diffusion-webui/config.json
        echo "    \"grid_save_to_dirs\": false," >> ./stable-diffusion-webui/config.json
        echo "    \"hires_fix_show_sampler\": true," >> ./stable-diffusion-webui/config.json
        echo "    \"CLIP_stop_at_last_layers\": 2" >> ./stable-diffusion-webui/config.json
        echo "}" >> ./stable-diffusion-webui/config.json

        if [ ! -z "$a1111_sd_webui_extension_install_list" ];then
            term_sd_notice "安装插件中"
            for i in $a1111_sd_webui_extension_install_list ;do
                cmd_daemon git clone --recurse-submodules "$github_proxy"$i ./stable-diffusion-webui/extensions/$(echo $i | awk -F'/' '{print $NF}')
            done
        fi

        term_sd_notice "下载模型中"
        if [ $use_modelscope_model = 1 ];then #使用huggingface下载模型
            tmp_enable_proxy #恢复原有的代理,保证能从huggingface下载模型
            #大模型
            cmd_daemon aria2c $aria2_multi_threaded https://huggingface.co/runwayml/stable-diffusion-v1-5/resolve/main/v1-5-pruned-emaonly.safetensors -d ./stable-diffusion-webui/models/Stable-diffusion -o sd-v1-5.safetensors
            #VAE模型
            cmd_daemon aria2c $aria2_multi_threaded https://huggingface.co/stabilityai/sd-vae-ft-mse-original/resolve/main/vae-ft-mse-840000-ema-pruned.safetensors -d ./stable-diffusion-webui/models/VAE -o vae-ft-mse-840000-ema-pruned.safetensors
            cmd_daemon aria2c $aria2_multi_threaded https://huggingface.co/stabilityai/sd-vae-ft-ema-original/resolve/main/vae-ft-ema-560000-ema-pruned.safetensors -d ./stable-diffusion-webui/models/VAE -o vae-ft-ema-560000-ema-pruned.safetensors
            #VAE-approx模型
            cmd_daemon aria2c $aria2_multi_threaded https://huggingface.co/licyk/sd-vae/resolve/main/vae-approx/model.pt -d ./stable-diffusion-webui/models/VAE-approx -o model.pt
            cmd_daemon aria2c $aria2_multi_threaded https://huggingface.co/licyk/sd-vae/resolve/main/vae-approx/vaeapprox-sdxl.pt -d ./stable-diffusion-webui/models/VAE-approx -o vaeapprox-sdxl.pt
            #upscaler模型
            cmd_daemon aria2c $aria2_multi_threaded https://huggingface.co/licyk/sd-upscaler-models/resolve/main/ESRGAN/4x-UltraSharp.pth -d ./stable-diffusion-webui/models/ESRGAN -o 4x-UltraSharp.pth
            cmd_daemon aria2c $aria2_multi_threaded https://huggingface.co/licyk/sd-upscaler-models/resolve/main/ESRGAN/BSRGAN.pth -d ./stable-diffusion-webui/models/ESRGAN -o BSRGAN.pth
            cmd_daemon aria2c $aria2_multi_threaded https://huggingface.co/licyk/sd-upscaler-models/resolve/main/ESRGAN/ESRGAN_4x.pth -d ./stable-diffusion-webui/models/ESRGAN -o ESRGAN_4x.pth
            cmd_daemon aria2c $aria2_multi_threaded https://huggingface.co/licyk/sd-upscaler-models/resolve/main/GFPGAN/GFPGANv1.4.pth -d ./stable-diffusion-webui/models/GFPGAN -o GFPGANv1.4.pth
            cmd_daemon aria2c $aria2_multi_threaded https://huggingface.co/licyk/sd-upscaler-models/resolve/main/GFPGAN/detection_Resnet50_Final.pth -d ./stable-diffusion-webui/models/GFPGAN -o detection_Resnet50_Final.pth
            cmd_daemon aria2c $aria2_multi_threaded https://huggingface.co/licyk/sd-upscaler-models/resolve/main/GFPGAN/parsing_bisenet.pth -d ./stable-diffusion-webui/models/GFPGAN -o parsing_bisenet.pth
            cmd_daemon aria2c $aria2_multi_threaded https://huggingface.co/licyk/sd-upscaler-models/resolve/main/GFPGAN/parsing_parsenet.pth -d ./stable-diffusion-webui/models/GFPGAN -o parsing_parsenet.pth
            cmd_daemon aria2c $aria2_multi_threaded https://huggingface.co/licyk/sd-upscaler-models/resolve/main/RealESRGAN/RealESRGAN_x4plus.pth -d ./stable-diffusion-webui/models/RealESRGAN -o RealESRGAN_x4plus.pth
            cmd_daemon aria2c $aria2_multi_threaded https://huggingface.co/licyk/sd-upscaler-models/resolve/main/RealESRGAN/RealESRGAN_x4plus_anime_6B.pth -d ./stable-diffusion-webui/models/RealESRGAN -o RealESRGAN_x4plus_anime_6B.pth
            #BLIP模型
            cmd_daemon aria2c $aria2_multi_threaded https://huggingface.co/licyk/sd-upscaler-models/resolve/main/BLIP/model_base_caption_capfilt_large.pth -d ./stable-diffusion-webui/models/BLIP -o model_base_caption_capfilt_large.pth
            #Codeformer模型
            cmd_daemon aria2c $aria2_multi_threaded https://huggingface.co/licyk/sd-upscaler-models/resolve/main/Codeformer/codeformer-v0.1.0.pth -d ./stable-diffusion-webui/models/Codeformer -o codeformer-v0.1.0.pth
            #embeddings模型
            cmd_daemon aria2c $aria2_multi_threaded https://huggingface.co/licyk/sd-embeddings/resolve/main/sd_1.5/EasyNegativeV2.safetensors -d ./stable-diffusion-webui/embeddings/negative -o EasyNegativeV2.safetensors
            cmd_daemon aria2c $aria2_multi_threaded https://huggingface.co/licyk/sd-embeddings/resolve/main/sd_1.5/bad-artist-anime.pt -d ./stable-diffusion-webui/embeddings/negative -o bad-artist-anime.pt
            cmd_daemon aria2c $aria2_multi_threaded https://huggingface.co/licyk/sd-embeddings/resolve/main/sd_1.5/bad-artist.pt -d ./stable-diffusion-webui/embeddings/negative -o bad-artist.pt
            cmd_daemon aria2c $aria2_multi_threaded https://huggingface.co/licyk/sd-embeddings/resolve/main/sd_1.5/bad-hands-5.pt -d ./stable-diffusion-webui/embeddings/negative -o bad-hands-5.pt
            cmd_daemon aria2c $aria2_multi_threaded https://huggingface.co/licyk/sd-embeddings/resolve/main/sd_1.5/bad-image-v2-39000.pt -d ./stable-diffusion-webui/embeddings/negative -o bad-image-v2-39000.pt
            cmd_daemon aria2c $aria2_multi_threaded https://huggingface.co/licyk/sd-embeddings/resolve/main/sd_1.5/bad_prompt_version2.pt -d ./stable-diffusion-webui/embeddings/negative -o bad_prompt_version2.pt
            cmd_daemon aria2c $aria2_multi_threaded https://huggingface.co/licyk/sd-embeddings/resolve/main/sd_1.5/ng_deepnegative_v1_75t.pt -d ./stable-diffusion-webui/embeddings/negative -o ng_deepnegative_v1_75t.pt
            cmd_daemon aria2c $aria2_multi_threaded https://huggingface.co/licyk/sd-embeddings/resolve/main/sd_1.5/verybadimagenegative_v1.3.pt -d ./stable-diffusion-webui/embeddings/negative -o verybadimagenegative_v1.3.pt
            

            if [ $a1111_sd_webui_extension_model_1 = 0 ];then #安装controlnet时再下载相关模型
                term_sd_notice "下载controlnet模型中"
                #controlnet模型
                cmd_daemon aria2c $aria2_multi_threaded https://huggingface.co/licyk/controlnet_v1.1/resolve/main/cldm_v15.yaml -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o cldm_v15.yaml
                cmd_daemon aria2c $aria2_multi_threaded https://huggingface.co/licyk/controlnet_v1.1/resolve/main/cldm_v21.yaml -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o cldm_v21.yaml
                cmd_daemon aria2c $aria2_multi_threaded https://huggingface.co/licyk/controlnet_v1.1/resolve/main/control_sd15_canny.yaml -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o control_sd15_canny.yaml
                cmd_daemon aria2c $aria2_multi_threaded https://huggingface.co/licyk/controlnet_v1.1/resolve/main/control_sd15_depth.yaml -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o control_sd15_depth.yaml
                cmd_daemon aria2c $aria2_multi_threaded https://huggingface.co/licyk/controlnet_v1.1/resolve/main/control_sd15_hed.yaml -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o control_sd15_hed.yaml
                cmd_daemon aria2c $aria2_multi_threaded https://huggingface.co/licyk/controlnet_v1.1/resolve/main/control_sd15_mlsd.yaml -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o control_sd15_mlsd.yaml
                cmd_daemon aria2c $aria2_multi_threaded https://huggingface.co/licyk/controlnet_v1.1/resolve/main/control_sd15_normal.yaml -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o control_sd15_normal.yaml
                cmd_daemon aria2c $aria2_multi_threaded https://huggingface.co/licyk/controlnet_v1.1/resolve/main/control_sd15_openpose.yaml -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o control_sd15_openpose.yaml
                cmd_daemon aria2c $aria2_multi_threaded https://huggingface.co/licyk/controlnet_v1.1/resolve/main/control_sd15_scribble.yaml -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o control_sd15_scribble.yaml
                cmd_daemon aria2c $aria2_multi_threaded https://huggingface.co/licyk/controlnet_v1.1/resolve/main/control_sd15_seg.yaml -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o control_sd15_seg.yaml

                cmd_daemon aria2c $aria2_multi_threaded https://huggingface.co/licyk/controlnet_v1.1/resolve/main/control_v11e_sd15_ip2p_fp16.safetensors -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o control_v11e_sd15_ip2p_fp16.safetensors
                cmd_daemon aria2c $aria2_multi_threaded https://huggingface.co/licyk/controlnet_v1.1/resolve/main/control_v11e_sd15_ip2p_fp16.yaml -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o control_v11e_sd15_ip2p_fp16.yaml

                cmd_daemon aria2c $aria2_multi_threaded https://huggingface.co/licyk/controlnet_v1.1/resolve/main/control_v11e_sd15_shuffle_fp16.safetensors -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o control_v11e_sd15_shuffle_fp16.safetensors
                cmd_daemon aria2c $aria2_multi_threaded https://huggingface.co/licyk/controlnet_v1.1/resolve/main/control_v11e_sd15_shuffle_fp16.yaml -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o control_v11e_sd15_shuffle_fp16.yaml

                cmd_daemon aria2c $aria2_multi_threaded https://huggingface.co/licyk/controlnet_v1.1/resolve/main/control_v11f1e_sd15_tile_fp16.safetensors -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o control_v11f1e_sd15_tile_fp16.safetensors
                cmd_daemon aria2c $aria2_multi_threaded https://huggingface.co/licyk/controlnet_v1.1/resolve/main/control_v11f1e_sd15_tile_fp16.yaml -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o control_v11f1e_sd15_tile_fp16.yaml

                cmd_daemon aria2c $aria2_multi_threaded https://huggingface.co/licyk/controlnet_v1.1/resolve/main/control_v11f1p_sd15_depth_fp16.safetensors -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o control_v11f1p_sd15_depth_fp16.safetensors
                cmd_daemon aria2c $aria2_multi_threaded https://huggingface.co/licyk/controlnet_v1.1/resolve/main/control_v11f1p_sd15_depth_fp16.yaml -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o control_v11f1p_sd15_depth_fp16.yaml

                cmd_daemon aria2c $aria2_multi_threaded https://huggingface.co/licyk/controlnet_v1.1/resolve/main/control_v11p_sd15_canny_fp16.safetensors -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o control_v11p_sd15_canny_fp16.safetensors
                cmd_daemon aria2c $aria2_multi_threaded https://huggingface.co/licyk/controlnet_v1.1/resolve/main/control_v11p_sd15_canny_fp16.yaml -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o control_v11p_sd15_canny_fp16.yaml

                cmd_daemon aria2c $aria2_multi_threaded https://huggingface.co/licyk/controlnet_v1.1/resolve/main/control_v11p_sd15_inpaint_fp16.safetensors -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o control_v11p_sd15_inpaint_fp16.safetensors
                cmd_daemon aria2c $aria2_multi_threaded https://huggingface.co/licyk/controlnet_v1.1/resolve/main/control_v11p_sd15_inpaint_fp16.yaml -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o control_v11p_sd15_inpaint_fp16.yaml

                cmd_daemon aria2c $aria2_multi_threaded https://huggingface.co/licyk/controlnet_v1.1/resolve/main/control_v11p_sd15_lineart_fp16.safetensors -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o control_v11p_sd15_lineart_fp16.safetensors
                cmd_daemon aria2c $aria2_multi_threaded https://huggingface.co/licyk/controlnet_v1.1/resolve/main/control_v11p_sd15_lineart_fp16.yaml -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o control_v11p_sd15_lineart_fp16.yaml

                cmd_daemon aria2c $aria2_multi_threaded https://huggingface.co/licyk/controlnet_v1.1/resolve/main/control_v11p_sd15_mlsd_fp16.safetensors -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o control_v11p_sd15_mlsd_fp16.safetensors
                cmd_daemon aria2c $aria2_multi_threaded https://huggingface.co/licyk/controlnet_v1.1/resolve/main/control_v11p_sd15_mlsd_fp16.yaml -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o control_v11p_sd15_mlsd_fp16.yaml

                cmd_daemon aria2c $aria2_multi_threaded https://huggingface.co/licyk/controlnet_v1.1/resolve/main/control_v11p_sd15_normalbae_fp16.safetensors -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o control_v11p_sd15_normalbae_fp16.safetensors
                cmd_daemon aria2c $aria2_multi_threaded https://huggingface.co/licyk/controlnet_v1.1/resolve/main/control_v11p_sd15_normalbae_fp16.yaml -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o control_v11p_sd15_normalbae_fp16.yaml

                cmd_daemon aria2c $aria2_multi_threaded https://huggingface.co/licyk/controlnet_v1.1/resolve/main/control_v11p_sd15_openpose_fp16.safetensors -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o control_v11p_sd15_openpose_fp16.safetensors
                cmd_daemon aria2c $aria2_multi_threaded https://huggingface.co/licyk/controlnet_v1.1/resolve/main/control_v11p_sd15_openpose_fp16.yaml -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o control_v11p_sd15_openpose_fp16.yaml

                cmd_daemon aria2c $aria2_multi_threaded https://huggingface.co/licyk/controlnet_v1.1/resolve/main/control_v11p_sd15_scribble_fp16.safetensors -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o control_v11p_sd15_scribble_fp16.safetensors
                cmd_daemon aria2c $aria2_multi_threaded https://huggingface.co/licyk/controlnet_v1.1/resolve/main/control_v11p_sd15_scribble_fp16.yaml -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o control_v11p_sd15_scribble_fp16.yaml

                cmd_daemon aria2c $aria2_multi_threaded https://huggingface.co/licyk/controlnet_v1.1/resolve/main/control_v11p_sd15_seg_fp16.safetensors -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o control_v11p_sd15_seg_fp16.safetensors
                cmd_daemon aria2c $aria2_multi_threaded https://huggingface.co/licyk/controlnet_v1.1/resolve/main/control_v11p_sd15_seg_fp16.yaml -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o control_v11p_sd15_seg_fp16.yaml

                cmd_daemon aria2c $aria2_multi_threaded https://huggingface.co/licyk/controlnet_v1.1/resolve/main/control_v11p_sd15_softedge_fp16.safetensors -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o control_v11p_sd15_softedge_fp16.safetensors
                cmd_daemon aria2c $aria2_multi_threaded https://huggingface.co/licyk/controlnet_v1.1/resolve/main/control_v11p_sd15_softedge_fp16.yaml -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o control_v11p_sd15_softedge_fp16.yaml

                cmd_daemon aria2c $aria2_multi_threaded https://huggingface.co/licyk/controlnet_v1.1/resolve/main/control_v11p_sd15s2_lineart_anime_fp16.safetensors -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o control_v11p_sd15s2_lineart_anime_fp16.safetensors
                cmd_daemon aria2c $aria2_multi_threaded https://huggingface.co/licyk/controlnet_v1.1/resolve/main/control_v11p_sd15s2_lineart_anime_fp16.yaml -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o control_v11p_sd15s2_lineart_anime_fp16.yaml

                cmd_daemon aria2c $aria2_multi_threaded https://huggingface.co/licyk/controlnet_v1.1/resolve/main/control_v1p_sd15_brightness.safetensors -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o control_v1p_sd15_brightness.safetensors
                cmd_daemon aria2c $aria2_multi_threaded https://huggingface.co/licyk/controlnet_v1.1/resolve/main/control_v1p_sd15_illumination.safetensors -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o control_v1p_sd15_illumination.safetensors

                cmd_daemon aria2c $aria2_multi_threaded https://huggingface.co/licyk/controlnet_v1.1/resolve/main/control_v1p_sd15_qrcode_monster.safetensors -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o control_v1p_sd15_qrcode_monster.safetensors
                cmd_daemon aria2c $aria2_multi_threaded https://huggingface.co/licyk/controlnet_v1.1/resolve/main/control_v1p_sd15_qrcode_monster.yaml -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o control_v1p_sd15_qrcode_monster.yaml

                cmd_daemon aria2c $aria2_multi_threaded https://huggingface.co/licyk/controlnet_v1.1/resolve/main/t2iadapter_canny_sd15v2.pth -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o t2iadapter_canny_sd15v2.pth
                cmd_daemon aria2c $aria2_multi_threaded https://huggingface.co/licyk/controlnet_v1.1/resolve/main/t2iadapter_canny_sd15v2.yaml -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o t2iadapter_canny_sd15v2.yaml

                cmd_daemon aria2c $aria2_multi_threaded https://huggingface.co/licyk/controlnet_v1.1/resolve/main/t2iadapter_color_sd14v1.pth -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o t2iadapter_color_sd14v1.pth
                cmd_daemon aria2c $aria2_multi_threaded https://huggingface.co/licyk/controlnet_v1.1/resolve/main/t2iadapter_color_sd14v1.yaml -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o t2iadapter_color_sd14v1.yaml

                cmd_daemon aria2c $aria2_multi_threaded https://huggingface.co/licyk/controlnet_v1.1/resolve/main/t2iadapter_depth_sd15v2.pth -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o t2iadapter_depth_sd15v2.pth
                cmd_daemon aria2c $aria2_multi_threaded https://huggingface.co/licyk/controlnet_v1.1/resolve/main/t2iadapter_depth_sd15v2.yaml -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o t2iadapter_depth_sd15v2.yaml

                cmd_daemon aria2c $aria2_multi_threaded https://huggingface.co/licyk/controlnet_v1.1/resolve/main/t2iadapter_keypose_sd14v1.pth -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o t2iadapter_keypose_sd14v1.pth
                cmd_daemon aria2c $aria2_multi_threaded https://huggingface.co/licyk/controlnet_v1.1/resolve/main/t2iadapter_keypose_sd14v1.yaml -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o t2iadapter_keypose_sd14v1.yaml

                cmd_daemon aria2c $aria2_multi_threaded https://huggingface.co/licyk/controlnet_v1.1/resolve/main/t2iadapter_openpose_sd14v1.pth -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o t2iadapter_openpose_sd14v1.pth
                cmd_daemon aria2c $aria2_multi_threaded https://huggingface.co/licyk/controlnet_v1.1/resolve/main/t2iadapter_openpose_sd14v1.yaml -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o t2iadapter_openpose_sd14v1.yaml

                cmd_daemon aria2c $aria2_multi_threaded https://huggingface.co/licyk/controlnet_v1.1/resolve/main/t2iadapter_seg_sd14v1.pth -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o t2iadapter_seg_sd14v1.pth
                cmd_daemon aria2c $aria2_multi_threaded https://huggingface.co/licyk/controlnet_v1.1/resolve/main/t2iadapter_seg_sd14v1.yaml -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o t2iadapter_seg_sd14v1.yaml

                cmd_daemon aria2c $aria2_multi_threaded https://huggingface.co/licyk/controlnet_v1.1/resolve/main/t2iadapter_sketch_sd15v2.pth -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o t2iadapter_sketch_sd15v2.pth
                cmd_daemon aria2c $aria2_multi_threaded https://huggingface.co/licyk/controlnet_v1.1/resolve/main/t2iadapter_sketch_sd15v2.yaml -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o t2iadapter_sketch_sd15v2.yaml

                cmd_daemon aria2c $aria2_multi_threaded https://huggingface.co/licyk/controlnet_v1.1/resolve/main/t2iadapter_style_sd14v1.pth -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o t2iadapter_style_sd14v1.pth
                cmd_daemon aria2c $aria2_multi_threaded https://huggingface.co/licyk/controlnet_v1.1/resolve/main/t2iadapter_style_sd14v1.yaml -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o t2iadapter_style_sd14v1.yaml

                cmd_daemon aria2c $aria2_multi_threaded https://huggingface.co/licyk/controlnet_v1.1/resolve/main/t2iadapter_zoedepth_sd15v1.pth -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o t2iadapter_zoedepth_sd15v1.pth
                cmd_daemon aria2c $aria2_multi_threaded https://huggingface.co/licyk/controlnet_v1.1/resolve/main/t2iadapter_zoedepth_sd15v1.yaml -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o t2iadapter_zoedepth_sd15v1.yaml

                cmd_daemon aria2c $aria2_multi_threaded https://huggingface.co/licyk/controlnet_v1.1/resolve/main/image_adapter_v14.yaml -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o image_adapter_v14.yaml
                cmd_daemon aria2c $aria2_multi_threaded https://huggingface.co/licyk/controlnet_v1.1/resolve/main/ip-adapter-plus-face_sd15.pth -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o ip-adapter-plus-face_sd15.pth
                cmd_daemon aria2c $aria2_multi_threaded https://huggingface.co/licyk/controlnet_v1.1/resolve/main/ip-adapter_sd15.pth -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o ip-adapter_sd15.pth
                cmd_daemon aria2c $aria2_multi_threaded https://huggingface.co/licyk/controlnet_v1.1/resolve/main/ip-adapter_sd15_light.pth -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o ip-adapter_sd15_light.pth
                cmd_daemon aria2c $aria2_multi_threaded https://huggingface.co/licyk/controlnet_v1.1/resolve/main/ip-adapter_sd15_plus.pth -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o ip-adapter_sd15_plus.pth
                cmd_daemon aria2c $aria2_multi_threaded https://huggingface.co/licyk/controlnet_v1.1/resolve/main/sketch_adapter_v14.yaml -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o sketch_adapter_v14.yaml
                #controlnet预处理器
                cmd_daemon aria2c $aria2_multi_threaded https://huggingface.co/licyk/controlnet_v1.1_annotator/resolve/main/clip_vision/clip_g.pth -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/annotator/downloads/clip_vision -o clip_g.pth
                cmd_daemon aria2c $aria2_multi_threaded https://huggingface.co/licyk/controlnet_v1.1_annotator/resolve/main/clip_vision/clip_h.pth -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/annotator/downloads/clip_vision -o clip_h.pth
                cmd_daemon aria2c $aria2_multi_threaded https://huggingface.co/licyk/controlnet_v1.1_annotator/resolve/main/clip_vision/clip_vitl.pth -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/annotator/downloads/clip_vision -o clip_vitl.pth

                cmd_daemon aria2c $aria2_multi_threaded https://huggingface.co/licyk/controlnet_v1.1_annotator/resolve/main/hed/ControlNetHED.pth -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/annotator/downloads/hed -o ControlNetHED.pth

                cmd_daemon aria2c $aria2_multi_threaded https://huggingface.co/licyk/controlnet_v1.1_annotator/resolve/main/lama/ControlNetLama.pth -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/annotator/downloads/lama -o ControlNetLama.pth

                cmd_daemon aria2c $aria2_multi_threaded https://huggingface.co/licyk/controlnet_v1.1_annotator/resolve/main/leres/latest_net_G.pth -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/annotator/downloads/leres -o latest_net_G.pth
                cmd_daemon aria2c $aria2_multi_threaded https://huggingface.co/licyk/controlnet_v1.1_annotator/resolve/main/leres/res101.pth -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/annotator/downloads/leres -o res101.pth

                cmd_daemon aria2c $aria2_multi_threaded https://huggingface.co/licyk/controlnet_v1.1_annotator/resolve/main/lineart/sk_model.pth -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/annotator/downloads/lineart -o sk_model.pth
                cmd_daemon aria2c $aria2_multi_threaded https://huggingface.co/licyk/controlnet_v1.1_annotator/resolve/main/lineart/sk_model2.pth -d -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/annotator/downloads/lineart -o sk_model2.pth

                cmd_daemon aria2c $aria2_multi_threaded https://huggingface.co/licyk/controlnet_v1.1_annotator/resolve/main/lineart_anime/netG.pth -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/annotator/downloads/lineart_anime -o netG.pth

                cmd_daemon aria2c $aria2_multi_threaded https://huggingface.co/licyk/controlnet_v1.1_annotator/resolve/main/manga_line/erika.pth -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/annotator/downloads/manga_line -o erika.pth

                cmd_daemon aria2c $aria2_multi_threaded https://huggingface.co/licyk/controlnet_v1.1_annotator/resolve/main/midas/dpt_hybrid-midas-501f0c75.pt -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/annotator/downloads/midas -o dpt_hybrid-midas-501f0c75.pt

                cmd_daemon aria2c $aria2_multi_threaded https://huggingface.co/licyk/controlnet_v1.1_annotator/resolve/main/mlsd/mlsd_large_512_fp32.pth -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/annotator/downloads/mlsd -o mlsd_large_512_fp32.pth

                cmd_daemon aria2c $aria2_multi_threaded https://huggingface.co/licyk/controlnet_v1.1_annotator/resolve/main/normal_bae/scannet.pt -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/annotator/downloads/normal_bae -o scannet.pt

                cmd_daemon aria2c $aria2_multi_threaded https://huggingface.co/licyk/controlnet_v1.1_annotator/resolve/main/oneformer/150_16_swin_l_oneformer_coco_100ep.pth -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/annotator/downloads/oneformer -o 150_16_swin_l_oneformer_coco_100ep.pth
                cmd_daemon aria2c $aria2_multi_threaded https://huggingface.co/licyk/controlnet_v1.1_annotator/resolve/main/oneformer/250_16_swin_l_oneformer_ade20k_160k.pth -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/annotator/downloads/oneformer -o 250_16_swin_l_oneformer_ade20k_160k.pth

                cmd_daemon aria2c $aria2_multi_threaded https://huggingface.co/licyk/controlnet_v1.1_annotator/resolve/main/openpose/body_pose_model.pth -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/annotator/downloads/openpose -o body_pose_model.pth
                cmd_daemon aria2c $aria2_multi_threaded https://huggingface.co/licyk/controlnet_v1.1_annotator/resolve/main/openpose/dw-ll_ucoco_384.onnx -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/annotator/downloads/openpose -o dw-ll_ucoco_384.onnx
                cmd_daemon aria2c $aria2_multi_threaded https://huggingface.co/licyk/controlnet_v1.1_annotator/resolve/main/openpose/facenet.pth -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/annotator/downloads/openpose -o facenet.pth
                cmd_daemon aria2c $aria2_multi_threaded https://huggingface.co/licyk/controlnet_v1.1_annotator/resolve/main/openpose/hand_pose_model.pth -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/annotator/downloads/openpose -o hand_pose_model.pth
                cmd_daemon aria2c $aria2_multi_threaded https://huggingface.co/licyk/controlnet_v1.1_annotator/resolve/main/openpose/yolox_l.onnx -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/annotator/downloads/openpose -o yolox_l.onnx

                cmd_daemon aria2c $aria2_multi_threaded https://huggingface.co/licyk/controlnet_v1.1_annotator/resolve/main/pidinet/table5_pidinet.pth -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/annotator/downloads/pidinet -o table5_pidinet.pth

                cmd_daemon aria2c $aria2_multi_threaded https://huggingface.co/licyk/controlnet_v1.1_annotator/resolve/main/uniformer/upernet_global_small.pth -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/annotator/downloads/uniformer -o upernet_global_small.pth

                cmd_daemon aria2c $aria2_multi_threaded https://huggingface.co/licyk/controlnet_v1.1_annotator/resolve/main/zoedepth/ZoeD_M12_N.pt -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/annotator/downloads/zoedepth -o ZoeD_M12_N.pt
            fi

            if [ $a1111_sd_webui_extension_model_2 = 0 ];then #安装adetailer插件相关模型
                term_sd_notice "下载adetailer模型中"
                cmd_daemon aria2c $aria2_multi_threaded https://huggingface.co/Bingsu/adetailer/resolve/main/deepfashion2_yolov8s-seg.pt -d ./stable-diffusion-webui/models/adetailer -o deepfashion2_yolov8s-seg.pt
                cmd_daemon aria2c $aria2_multi_threaded https://huggingface.co/Bingsu/adetailer/resolve/main/face_yolov8m.pt -d ./stable-diffusion-webui/models/adetailer -o face_yolov8m.pt
                cmd_daemon aria2c $aria2_multi_threaded https://huggingface.co/Bingsu/adetailer/resolve/main/face_yolov8n.pt -d ./stable-diffusion-webui/models/adetailer -o face_yolov8n.pt
                cmd_daemon aria2c $aria2_multi_threaded https://huggingface.co/Bingsu/adetailer/resolve/main/face_yolov8n_v2.pt -d ./stable-diffusion-webui/models/adetailer -o face_yolov8n_v2.pt
                cmd_daemon aria2c $aria2_multi_threaded https://huggingface.co/Bingsu/adetailer/resolve/main/face_yolov8s.pt -d ./stable-diffusion-webui/models/adetailer -o face_yolov8s.pt
                cmd_daemon aria2c $aria2_multi_threaded https://huggingface.co/Bingsu/adetailer/resolve/main/hand_yolov8n.pt -d ./stable-diffusion-webui/models/adetailer -o hand_yolov8n.pt
                cmd_daemon aria2c $aria2_multi_threaded https://huggingface.co/Bingsu/adetailer/resolve/main/hand_yolov8s.pt -d ./stable-diffusion-webui/models/adetailer -o hand_yolov8s.pt
                cmd_daemon aria2c $aria2_multi_threaded https://huggingface.co/Bingsu/adetailer/resolve/main/person_yolov8m-seg.pt -d ./stable-diffusion-webui/models/adetailer -o person_yolov8m-seg.pt
                cmd_daemon aria2c $aria2_multi_threaded https://huggingface.co/Bingsu/adetailer/resolve/main/person_yolov8n-seg.pt -d ./stable-diffusion-webui/models/adetailer -o person_yolov8n-seg.pt
                cmd_daemon aria2c $aria2_multi_threaded https://huggingface.co/Bingsu/adetailer/resolve/main/person_yolov8s-seg.pt -d ./stable-diffusion-webui/models/adetailer -o person_yolov8s-seg.pt
            fi

            if [ $a1111_sd_webui_extension_model_3 = 0 ];then #安装sd-webui-IS-NET-pro插件相关模型
                term_sd_notice "下载sd-webui-IS-NET-pro模型中"
                cmd_daemon aria2c $aria2_multi_threaded https://huggingface.co/ClockZinc/IS-NET_pth/resolve/main/isnet-general-use.pth -d ./stable-diffusion-webui/extensions/sd-webui-IS-NET-pro/saved_models/IS-Net -o isnet-general-use.pth
            fi

            if [ $a1111_sd_webui_extension_model_4 = 0 ];then #安装sd-webui-animatediff插件相关模型
                term_sd_notice "下载sd-webui-animatediff模型中"
                cmd_daemon aria2c $aria2_multi_threaded https://huggingface.co/guoyww/animatediff/resolve/main/mm_sd_v15_v2.ckpt -d ./stable-diffusion-webui/extensions/sd-webui-animatediff/model -o mm_sd_v15_v2.ckpt
            fi

        else #使用modelscope下载模型
            #大模型
            get_modelscope_model licyks/sd-model/master/sd_1.5/v1-5-pruned-emaonly.safetensors ./stable-diffusion-webui/models/Stable-diffusion
            #VAE模型
            get_modelscope_model licyks/sd-vae/master/sd_1.5/vae-ft-ema-560000-ema-pruned.safetensors ./stable-diffusion-webui/models/VAE
            get_modelscope_model licyks/sd-vae/master/sd_1.5/vae-ft-mse-840000-ema-pruned.safetensors ./stable-diffusion-webui/models/VAE
            #VAE-approx模型
            get_modelscope_model licyks/sd-vae/master/vae-approx/model.pt ./stable-diffusion-webui/models/VAE-approx
            get_modelscope_model licyks/sd-vae/master/vae-approx/vaeapprox-sdxl.pt ./stable-diffusion-webui/models/VAE-approx
            #upscaler模型
            get_modelscope_model licyks/sd-upscaler-models/master/ESRGAN/4x-UltraSharp.pth ./stable-diffusion-webui/models/ESRGAN
            get_modelscope_model licyks/sd-upscaler-models/master/ESRGAN/BSRGAN.pth ./stable-diffusion-webui/models/ESRGAN
            get_modelscope_model licyks/sd-upscaler-models/master/ESRGAN/ESRGAN_4x.pth ./stable-diffusion-webui/models/ESRGAN
            get_modelscope_model licyks/sd-upscaler-models/master/GFPGAN/detection_Resnet50_Final.pth ./stable-diffusion-webui/models/GFPGAN
            get_modelscope_model licyks/sd-upscaler-models/master/GFPGAN/GFPGANv1.4.pth ./stable-diffusion-webui/models/GFPGAN
            get_modelscope_model licyks/sd-upscaler-models/master/GFPGAN/parsing_bisenet.pth ./stable-diffusion-webui/models/GFPGAN
            get_modelscope_model licyks/sd-upscaler-models/master/GFPGAN/parsing_parsenet.pth ./stable-diffusion-webui/models/GFPGAN
            get_modelscope_model licyks/sd-upscaler-models/master/RealESRGAN/RealESRGAN_x4plus.pth ./stable-diffusion-webui/models/RealESRGAN
            get_modelscope_model licyks/sd-upscaler-models/master/RealESRGAN/RealESRGAN_x4plus_anime_6B.pth ./stable-diffusion-webui/models/RealESRGAN
            #BLIP模型
            get_modelscope_model licyks/sd-upscaler-models/master/BLIP/model_base_caption_capfilt_large.pth ./stable-diffusion-webui/models/BLIP
            #Codeformer模型
            get_modelscope_model licyks/sd-upscaler-models/master/Codeformer/codeformer-v0.1.0.pth ./stable-diffusion-webui/models/Codeformer
            #embeddings模型
            get_modelscope_model licyks/sd-embeddings/master/sd_1.5/EasyNegativeV2.safetensors ./stable-diffusion-webui/embeddings/negative
            get_modelscope_model licyks/sd-embeddings/master/sd_1.5/bad-artist-anime.pt ./stable-diffusion-webui/embeddings/negative
            get_modelscope_model licyks/sd-embeddings/master/sd_1.5/bad-artist.pt ./stable-diffusion-webui/embeddings/negative
            get_modelscope_model licyks/sd-embeddings/master/sd_1.5/bad-hands-5.pt ./stable-diffusion-webui/embeddings/negative
            get_modelscope_model licyks/sd-embeddings/master/sd_1.5/bad-image-v2-39000.pt ./stable-diffusion-webui/embeddings/negative
            get_modelscope_model licyks/sd-embeddings/master/sd_1.5/bad_prompt_version2.pt ./stable-diffusion-webui/embeddings/negative
            get_modelscope_model licyks/sd-embeddings/master/sd_1.5/ng_deepnegative_v1_75t.pt ./stable-diffusion-webui/embeddings/negative
            get_modelscope_model licyks/sd-embeddings/master/sd_1.5/verybadimagenegative_v1.3.pt ./stable-diffusion-webui/embeddings/negative

            if [ $a1111_sd_webui_extension_model_1 = 0 ];then #安装controlnet时再下载相关模型
                term_sd_notice "下载controlnet模型中"
                get_modelscope_model licyks/controlnet_v1.1/master/cldm_v15.yaml ./stable-diffusion-webui/extensions/sd-webui-controlnet/models
                get_modelscope_model licyks/controlnet_v1.1/master/cldm_v21.yaml ./stable-diffusion-webui/extensions/sd-webui-controlnet/models
                get_modelscope_model licyks/controlnet_v1.1/master/control_sd15_canny.yaml ./stable-diffusion-webui/extensions/sd-webui-controlnet/models
                get_modelscope_model licyks/controlnet_v1.1/master/control_sd15_depth.yaml ./stable-diffusion-webui/extensions/sd-webui-controlnet/models
                get_modelscope_model licyks/controlnet_v1.1/master/control_sd15_hed.yaml ./stable-diffusion-webui/extensions/sd-webui-controlnet/models
                get_modelscope_model licyks/controlnet_v1.1/master/control_sd15_mlsd.yaml ./stable-diffusion-webui/extensions/sd-webui-controlnet/models
                get_modelscope_model licyks/controlnet_v1.1/master/control_sd15_normal.yaml ./stable-diffusion-webui/extensions/sd-webui-controlnet/models
                get_modelscope_model licyks/controlnet_v1.1/master/control_sd15_openpose.yaml ./stable-diffusion-webui/extensions/sd-webui-controlnet/models
                get_modelscope_model licyks/controlnet_v1.1/master/control_sd15_scribble.yaml ./stable-diffusion-webui/extensions/sd-webui-controlnet/models
                get_modelscope_model licyks/controlnet_v1.1/master/control_sd15_seg.yaml ./stable-diffusion-webui/extensions/sd-webui-controlnet/models

                get_modelscope_model licyks/controlnet_v1.1/master/control_v11e_sd15_ip2p_fp16.safetensors ./stable-diffusion-webui/extensions/sd-webui-controlnet/models
                get_modelscope_model licyks/controlnet_v1.1/master/control_v11e_sd15_ip2p_fp16.yaml ./stable-diffusion-webui/extensions/sd-webui-controlnet/models

                get_modelscope_model licyks/controlnet_v1.1/master/control_v11e_sd15_shuffle_fp16.safetensors ./stable-diffusion-webui/extensions/sd-webui-controlnet/models
                get_modelscope_model licyks/controlnet_v1.1/master/control_v11e_sd15_shuffle_fp16.yaml ./stable-diffusion-webui/extensions/sd-webui-controlnet/models

                get_modelscope_model licyks/controlnet_v1.1/master/control_v11f1e_sd15_tile_fp16.safetensors ./stable-diffusion-webui/extensions/sd-webui-controlnet/models
                get_modelscope_model licyks/controlnet_v1.1/master/control_v11f1e_sd15_tile_fp16.yaml ./stable-diffusion-webui/extensions/sd-webui-controlnet/models

                get_modelscope_model licyks/controlnet_v1.1/master/control_v11f1p_sd15_depth_fp16.safetensors ./stable-diffusion-webui/extensions/sd-webui-controlnet/models
                get_modelscope_model licyks/controlnet_v1.1/master/control_v11f1p_sd15_depth_fp16.yaml ./stable-diffusion-webui/extensions/sd-webui-controlnet/models

                get_modelscope_model licyks/controlnet_v1.1/master/control_v11p_sd15_canny_fp16.safetensors ./stable-diffusion-webui/extensions/sd-webui-controlnet/models
                get_modelscope_model licyks/controlnet_v1.1/master/control_v11p_sd15_canny_fp16.yaml ./stable-diffusion-webui/extensions/sd-webui-controlnet/models

                get_modelscope_model licyks/controlnet_v1.1/master/control_v11p_sd15_inpaint_fp16.safetensors ./stable-diffusion-webui/extensions/sd-webui-controlnet/models
                get_modelscope_model licyks/controlnet_v1.1/master/control_v11p_sd15_inpaint_fp16.yaml ./stable-diffusion-webui/extensions/sd-webui-controlnet/models

                get_modelscope_model licyks/controlnet_v1.1/master/control_v11p_sd15_lineart_fp16.safetensors ./stable-diffusion-webui/extensions/sd-webui-controlnet/models
                get_modelscope_model licyks/controlnet_v1.1/master/control_v11p_sd15_lineart_fp16.yaml ./stable-diffusion-webui/extensions/sd-webui-controlnet/models

                get_modelscope_model licyks/controlnet_v1.1/master/control_v11p_sd15_mlsd_fp16.safetensors ./stable-diffusion-webui/extensions/sd-webui-controlnet/models
                get_modelscope_model licyks/controlnet_v1.1/master/control_v11p_sd15_mlsd_fp16.yaml ./stable-diffusion-webui/extensions/sd-webui-controlnet/models

                get_modelscope_model licyks/controlnet_v1.1/master/control_v11p_sd15_normalbae_fp16.safetensors ./stable-diffusion-webui/extensions/sd-webui-controlnet/models
                get_modelscope_model licyks/controlnet_v1.1/master/control_v11p_sd15_normalbae_fp16.yaml ./stable-diffusion-webui/extensions/sd-webui-controlnet/models

                get_modelscope_model licyks/controlnet_v1.1/master/control_v11p_sd15_openpose_fp16.safetensors ./stable-diffusion-webui/extensions/sd-webui-controlnet/models
                get_modelscope_model licyks/controlnet_v1.1/master/control_v11p_sd15_openpose_fp16.yaml ./stable-diffusion-webui/extensions/sd-webui-controlnet/models

                get_modelscope_model licyks/controlnet_v1.1/master/control_v11p_sd15_scribble_fp16.safetensors ./stable-diffusion-webui/extensions/sd-webui-controlnet/models
                get_modelscope_model licyks/controlnet_v1.1/master/control_v11p_sd15_scribble_fp16.yaml ./stable-diffusion-webui/extensions/sd-webui-controlnet/models

                get_modelscope_model licyks/controlnet_v1.1/master/control_v11p_sd15_seg_fp16.safetensors ./stable-diffusion-webui/extensions/sd-webui-controlnet/models
                get_modelscope_model licyks/controlnet_v1.1/master/control_v11p_sd15_seg_fp16.yaml ./stable-diffusion-webui/extensions/sd-webui-controlnet/models

                get_modelscope_model licyks/controlnet_v1.1/master/control_v11p_sd15_softedge_fp16.safetensors ./stable-diffusion-webui/extensions/sd-webui-controlnet/models
                get_modelscope_model licyks/controlnet_v1.1/master/control_v11p_sd15_softedge_fp16.yaml ./stable-diffusion-webui/extensions/sd-webui-controlnet/models

                get_modelscope_model licyks/controlnet_v1.1/master/control_v11p_sd15s2_lineart_anime_fp16.safetensors ./stable-diffusion-webui/extensions/sd-webui-controlnet/models
                get_modelscope_model licyks/controlnet_v1.1/master/control_v11p_sd15s2_lineart_anime_fp16.yaml ./stable-diffusion-webui/extensions/sd-webui-controlnet/models

                get_modelscope_model licyks/controlnet_v1.1/master/control_v1p_sd15_brightness.safetensors ./stable-diffusion-webui/extensions/sd-webui-controlnet/models
                get_modelscope_model licyks/controlnet_v1.1/master/control_v1p_sd15_illumination.safetensors ./stable-diffusion-webui/extensions/sd-webui-controlnet/models

                get_modelscope_model licyks/controlnet_v1.1/master/control_v1p_sd15_qrcode_monster.safetensors ./stable-diffusion-webui/extensions/sd-webui-controlnet/models
                get_modelscope_model licyks/controlnet_v1.1/master/control_v1p_sd15_qrcode_monster.yaml ./stable-diffusion-webui/extensions/sd-webui-controlnet/models

                get_modelscope_model licyks/controlnet_v1.1/master/t2iadapter_canny_sd15v2.pth ./stable-diffusion-webui/extensions/sd-webui-controlnet/models
                get_modelscope_model licyks/controlnet_v1.1/master/t2iadapter_canny_sd15v2.yaml ./stable-diffusion-webui/extensions/sd-webui-controlnet/models

                get_modelscope_model licyks/controlnet_v1.1/master/t2iadapter_color_sd14v1.pth ./stable-diffusion-webui/extensions/sd-webui-controlnet/models
                get_modelscope_model licyks/controlnet_v1.1/master/t2iadapter_color_sd14v1.yaml ./stable-diffusion-webui/extensions/sd-webui-controlnet/models

                get_modelscope_model licyks/controlnet_v1.1/master/t2iadapter_depth_sd15v2.pth ./stable-diffusion-webui/extensions/sd-webui-controlnet/models
                get_modelscope_model licyks/controlnet_v1.1/master/t2iadapter_depth_sd15v2.yaml ./stable-diffusion-webui/extensions/sd-webui-controlnet/models

                get_modelscope_model licyks/controlnet_v1.1/master/t2iadapter_keypose_sd14v1.pth ./stable-diffusion-webui/extensions/sd-webui-controlnet/models
                get_modelscope_model licyks/controlnet_v1.1/master/t2iadapter_keypose_sd14v1.yaml ./stable-diffusion-webui/extensions/sd-webui-controlnet/models

                get_modelscope_model licyks/controlnet_v1.1/master/t2iadapter_openpose_sd14v1.pth ./stable-diffusion-webui/extensions/sd-webui-controlnet/models
                get_modelscope_model licyks/controlnet_v1.1/master/t2iadapter_openpose_sd14v1.yaml ./stable-diffusion-webui/extensions/sd-webui-controlnet/models

                get_modelscope_model licyks/controlnet_v1.1/master/t2iadapter_seg_sd14v1.pth ./stable-diffusion-webui/extensions/sd-webui-controlnet/models
                get_modelscope_model licyks/controlnet_v1.1/master/t2iadapter_seg_sd14v1.yaml ./stable-diffusion-webui/extensions/sd-webui-controlnet/models

                get_modelscope_model licyks/controlnet_v1.1/master/t2iadapter_sketch_sd15v2.pth ./stable-diffusion-webui/extensions/sd-webui-controlnet/models
                get_modelscope_model licyks/controlnet_v1.1/master/t2iadapter_sketch_sd15v2.yaml ./stable-diffusion-webui/extensions/sd-webui-controlnet/models

                get_modelscope_model licyks/controlnet_v1.1/master/t2iadapter_style_sd14v1.pth ./stable-diffusion-webui/extensions/sd-webui-controlnet/models
                get_modelscope_model licyks/controlnet_v1.1/master/t2iadapter_style_sd14v1.yaml ./stable-diffusion-webui/extensions/sd-webui-controlnet/models

                get_modelscope_model licyks/controlnet_v1.1/master/t2iadapter_zoedepth_sd15v1.pth ./stable-diffusion-webui/extensions/sd-webui-controlnet/models
                get_modelscope_model licyks/controlnet_v1.1/master/t2iadapter_zoedepth_sd15v1.yaml ./stable-diffusion-webui/extensions/sd-webui-controlnet/models

                get_modelscope_model licyks/controlnet_v1.1/master/image_adapter_v14.yaml ./stable-diffusion-webui/extensions/sd-webui-controlnet/models
                get_modelscope_model licyks/controlnet_v1.1/master/ip-adapter-plus-face_sd15.pth ./stable-diffusion-webui/extensions/sd-webui-controlnet/models
                get_modelscope_model licyks/controlnet_v1.1/master/ip-adapter_sd15.pth ./stable-diffusion-webui/extensions/sd-webui-controlnet/models
                get_modelscope_model licyks/controlnet_v1.1/master/ip-adapter_sd15_light.pth ./stable-diffusion-webui/extensions/sd-webui-controlnet/models
                get_modelscope_model licyks/controlnet_v1.1/master/ip-adapter_sd15_plus.pth ./stable-diffusion-webui/extensions/sd-webui-controlnet/models
                get_modelscope_model licyks/controlnet_v1.1/master/sketch_adapter_v14.yaml ./stable-diffusion-webui/extensions/sd-webui-controlnet/models
                #controlnet预处理器
                get_modelscope_model licyks/controlnet_v1.1_annotator/master/clip_vision/clip_g.pth ./stable-diffusion-webui/extensions/sd-webui-controlnet/annotator/downloads/clip_vision
                get_modelscope_model licyks/controlnet_v1.1_annotator/master/clip_vision/clip_h.pth ./stable-diffusion-webui/extensions/sd-webui-controlnet/annotator/downloads/clip_vision
                get_modelscope_model licyks/controlnet_v1.1_annotator/master/clip_vision/clip_vitl.pth ./stable-diffusion-webui/extensions/sd-webui-controlnet/annotator/downloads/clip_vision

                get_modelscope_model licyks/controlnet_v1.1_annotator/master/hed/ControlNetHED.pth ./stable-diffusion-webui/extensions/sd-webui-controlnet/annotator/downloads/hed

                get_modelscope_model licyks/controlnet_v1.1_annotator/master/lama/ControlNetLama.pth ./stable-diffusion-webui/extensions/sd-webui-controlnet/annotator/downloads/lama

                get_modelscope_model licyks/controlnet_v1.1_annotator/master/leres/latest_net_G.pth ./stable-diffusion-webui/extensions/sd-webui-controlnet/annotator/downloads/leres
                get_modelscope_model licyks/controlnet_v1.1_annotator/master/leres/res101.pth ./stable-diffusion-webui/extensions/sd-webui-controlnet/annotator/downloads/leres

                get_modelscope_model licyks/controlnet_v1.1_annotator/master/lineart/sk_model.pth ./stable-diffusion-webui/extensions/sd-webui-controlnet/annotator/downloads/lineart
                get_modelscope_model licyks/controlnet_v1.1_annotator/master/lineart/sk_model2.pth ./stable-diffusion-webui/extensions/sd-webui-controlnet/annotator/downloads/lineart

                get_modelscope_model licyks/controlnet_v1.1_annotator/master/lineart_anime/netG.pth ./stable-diffusion-webui/extensions/sd-webui-controlnet/annotator/downloads/lineart_anime

                get_modelscope_model licyks/controlnet_v1.1_annotator/master/manga_line/erika.pth ./stable-diffusion-webui/extensions/sd-webui-controlnet/annotator/downloads/manga_line

                get_modelscope_model licyks/controlnet_v1.1_annotator/master/midas/dpt_hybrid-midas-501f0c75.pt ./stable-diffusion-webui/extensions/sd-webui-controlnet/annotator/downloads/midas

                get_modelscope_model licyks/controlnet_v1.1_annotator/master/mlsd/mlsd_large_512_fp32.pth ./stable-diffusion-webui/extensions/sd-webui-controlnet/annotator/downloads/mlsd

                get_modelscope_model licyks/controlnet_v1.1_annotator/master/normal_bae/scannet.pt ./stable-diffusion-webui/extensions/sd-webui-controlnet/annotator/downloads/normal_bae

                get_modelscope_model licyks/controlnet_v1.1_annotator/master/oneformer/150_16_swin_l_oneformer_coco_100ep.pth ./stable-diffusion-webui/extensions/sd-webui-controlnet/annotator/downloads/oneformer
                get_modelscope_model licyks/controlnet_v1.1_annotator/master/oneformer/250_16_swin_l_oneformer_ade20k_160k.pth ./stable-diffusion-webui/extensions/sd-webui-controlnet/annotator/downloads/oneformer

                get_modelscope_model licyks/controlnet_v1.1_annotator/master/openpose/body_pose_model.pth ./stable-diffusion-webui/extensions/sd-webui-controlnet/annotator/downloads/openpose
                get_modelscope_model licyks/controlnet_v1.1_annotator/master/openpose/dw-ll_ucoco_384.onnx ./stable-diffusion-webui/extensions/sd-webui-controlnet/annotator/downloads/openpose
                get_modelscope_model licyks/controlnet_v1.1_annotator/master/openpose/facenet.pth ./stable-diffusion-webui/extensions/sd-webui-controlnet/annotator/downloads/openpose
                get_modelscope_model licyks/controlnet_v1.1_annotator/master/openpose/hand_pose_model.pth ./stable-diffusion-webui/extensions/sd-webui-controlnet/annotator/downloads/openpose
                get_modelscope_model licyks/controlnet_v1.1_annotator/master/openpose/yolox_l.onnx ./stable-diffusion-webui/extensions/sd-webui-controlnet/annotator/downloads/openpose

                get_modelscope_model licyks/controlnet_v1.1_annotator/master/pidinet/table5_pidinet.pth ./stable-diffusion-webui/extensions/sd-webui-controlnet/annotator/downloads/pidinet

                get_modelscope_model licyks/controlnet_v1.1_annotator/master/uniformer/upernet_global_small.pth ./stable-diffusion-webui/extensions/sd-webui-controlnet/annotator/downloads/uniformer

                get_modelscope_model licyks/controlnet_v1.1_annotator/master/zoedepth/ZoeD_M12_N.pt ./stable-diffusion-webui/extensions/sd-webui-controlnet/annotator/downloads/zoedepth
            fi

            if [ $a1111_sd_webui_extension_model_2 = 0 ];then #安装adetailer插件相关模型
                term_sd_notice "下载adetailer模型中"
                get_modelscope_model licyks/sd-extensions-model/master/adetailer/deepfashion2_yolov8s-seg.pt ./stable-diffusion-webui/models/adetailer
                get_modelscope_model licyks/sd-extensions-model/master/adetailer/face_yolov8m.pt ./stable-diffusion-webui/models/adetailer
                get_modelscope_model licyks/sd-extensions-model/master/adetailer/face_yolov8n.pt ./stable-diffusion-webui/models/adetailer
                get_modelscope_model licyks/sd-extensions-model/master/adetailer/face_yolov8n_v2.pt ./stable-diffusion-webui/models/adetailer
                get_modelscope_model licyks/sd-extensions-model/master/adetailer/face_yolov8s.pt ./stable-diffusion-webui/models/adetailer
                get_modelscope_model licyks/sd-extensions-model/master/adetailer/hand_yolov8n.pt ./stable-diffusion-webui/models/adetailer
                get_modelscope_model licyks/sd-extensions-model/master/adetailer/hand_yolov8s.pt ./stable-diffusion-webui/models/adetailer
                get_modelscope_model licyks/sd-extensions-model/master/adetailer/person_yolov8m-seg.pt ./stable-diffusion-webui/models/adetailer
                get_modelscope_model licyks/sd-extensions-model/master/adetailer/person_yolov8n-seg.pt ./stable-diffusion-webui/models/adetailer
                get_modelscope_model licyks/sd-extensions-model/master/adetailer/person_yolov8s-seg.pt ./stable-diffusion-webui/models/adetailer
            fi

            if [ $a1111_sd_webui_extension_model_3 = 0 ];then #安装sd-webui-IS-NET-pro插件相关模型
                term_sd_notice "下载sd-webui-IS-NET-pro模型中"
                get_modelscope_model licyks/sd-extensions-model/master/sd-webui-IS-NET-pro/isnet-general-use.pth ./stable-diffusion-webui/extensions/sd-webui-IS-NET-pro/saved_models/IS-Net
            fi

            if [ $a1111_sd_webui_extension_model_4 = 0 ];then #安装sd-webui-animatediff插件相关模型
                term_sd_notice "下载sd-webui-animatediff模型中"
                get_modelscope_model licyks/sd-extensions-model/master/sd-webui-animatediff/mm_sd_v15_v2.ckpt ./stable-diffusion-webui/extensions/sd-webui-animatediff/model
            fi

            tmp_enable_proxy #恢复原有的代理
        fi
        term_sd_notice "安装结束"
        exit_venv
        print_line_to_shell
        a1111_sd_webui_option
    fi
}