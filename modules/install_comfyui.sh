#!/bin/bash

#comfyui安装处理部分
function process_install_comfyui()
{
    #安装前的准备
    proxy_option #代理选择
    pytorch_version_select #pytorch选择
    pip_install_methon #安装方式选择
    comfyui_extension_option #comfyui插件选择
    comfyui_custom_node_option #comfyui自定义节点选择
    final_install_check #安装前确认

    if [ $final_install_check_exec = 0 ];then
        #开始安装comfyui
        print_line_to_shell "ComfyUI 安装"
        term_sd_notice "开始安装ComfyUI"
        tmp_disable_proxy #临时取消代理,避免一些不必要的网络减速
        cmd_daemon git clone ${github_proxy}github.com/comfyanonymous/ComfyUI
        [ ! -d "./$term_sd_manager_info" ] && tmp_enable_proxy && term_sd_notice "检测到"$term_sd_manager_info"框架安装失败,已终止安装进程" && sleep 3 && return 1 #防止继续进行安装导致文件散落,造成目录混乱
        cd ./ComfyUI
        create_venv
        enter_venv
        cd ..

        if [ ! -z "$(echo $pytorch_install_version | awk '{gsub(/[=+]/, "")}1')" ];then
            cmd_daemon pip_cmd install $pytorch_install_version $pip_index_mirror $pip_extra_index_mirror $pip_find_mirror $force_pip $pip_install_methon_select --prefer-binary --default-timeout=100 --retries 5
        fi
        cmd_daemon pip_cmd install -r ./ComfyUI/requirements.txt  --prefer-binary $pip_index_mirror $pip_extra_index_mirror $pip_find_mirror $force_pip $pip_install_methon_select --default-timeout=100 --retries 5

        if [ ! -z "$comfyui_extension_install_list" ];then
            term_sd_notice "安装插件中"
            for i in $comfyui_extension_install_list ;do
                cmd_daemon git clone --recurse-submodules ${github_proxy}$(echo $i | awk '{sub("https://github.com/","github.com/")}1') ./ComfyUI/web/extensions/$(echo $i | awk -F'/' '{print $NF}')
            done
        fi

        if [ ! -z "$comfyui_custom_node_install_list" ];then
            term_sd_notice "安装自定义节点中"
            for i in $comfyui_custom_node_install_list ;do
                cmd_daemon git clone --recurse-submodules ${github_proxy}$(echo $i | awk '{sub("https://github.com/","github.com/")}1') ./ComfyUI/custom_nodes/$(echo $i | awk -F'/' '{print $NF}')
            done
        fi

        term_sd_notice "下载模型中"
        if [ $use_modelscope_model = 1 ];then #使用huggingface下载模型
            term_sd_notice "使用huggingface模型下载源"
            tmp_enable_proxy #恢复原有的代理,保证能从huggingface下载模型
            cmd_daemon aria2c $aria2_multi_threaded https://huggingface.co/runwayml/stable-diffusion-v1-5/resolve/main/v1-5-pruned-emaonly.safetensors -d ./ComfyUI/models/checkpoints/ -o sd-v1-5.safetensors
            cmd_daemon aria2c $aria2_multi_threaded https://huggingface.co/stabilityai/sd-vae-ft-mse-original/resolve/main/vae-ft-mse-840000-ema-pruned.safetensors -d ./ComfyUI/models/vae -o vae-ft-mse-840000-ema-pruned.safetensors
            cmd_daemon aria2c $aria2_multi_threaded https://huggingface.co/stabilityai/sd-vae-ft-ema-original/resolve/main/vae-ft-ema-560000-ema-pruned.safetensors -d ./ComfyUI/models/vae -o vae-ft-ema-560000-ema-pruned.safetensors

            if [ $comfyui_custom_node_extension_model_1 = 0 ];then
                term_sd_notice "下载controlnet模型中"
                cmd_daemon aria2c $aria2_multi_threaded https://huggingface.co/licyk/controlnet_v1.1/resolve/main/cldm_v15.yaml -d ./ComfyUI/models/controlnet -o cldm_v15.yaml
                cmd_daemon aria2c $aria2_multi_threaded https://huggingface.co/licyk/controlnet_v1.1/resolve/main/cldm_v21.yaml -d ./ComfyUI/models/controlnet -o cldm_v21.yaml
                cmd_daemon aria2c $aria2_multi_threaded https://huggingface.co/licyk/controlnet_v1.1/resolve/main/control_sd15_canny.yaml -d ./ComfyUI/models/controlnet -o control_sd15_canny.yaml
                cmd_daemon aria2c $aria2_multi_threaded https://huggingface.co/licyk/controlnet_v1.1/resolve/main/control_sd15_depth.yaml -d ./ComfyUI/models/controlnet -o control_sd15_depth.yaml
                cmd_daemon aria2c $aria2_multi_threaded https://huggingface.co/licyk/controlnet_v1.1/resolve/main/control_sd15_hed.yaml -d ./ComfyUI/models/controlnet -o control_sd15_hed.yaml
                cmd_daemon aria2c $aria2_multi_threaded https://huggingface.co/licyk/controlnet_v1.1/resolve/main/control_sd15_mlsd.yaml -d ./ComfyUI/models/controlnet -o control_sd15_mlsd.yaml
                cmd_daemon aria2c $aria2_multi_threaded https://huggingface.co/licyk/controlnet_v1.1/resolve/main/control_sd15_normal.yaml -d ./ComfyUI/models/controlnet -o control_sd15_normal.yaml
                cmd_daemon aria2c $aria2_multi_threaded https://huggingface.co/licyk/controlnet_v1.1/resolve/main/control_sd15_openpose.yaml -d ./ComfyUI/models/controlnet -o control_sd15_openpose.yaml
                cmd_daemon aria2c $aria2_multi_threaded https://huggingface.co/licyk/controlnet_v1.1/resolve/main/control_sd15_scribble.yaml -d ./ComfyUI/models/controlnet -o control_sd15_scribble.yaml
                cmd_daemon aria2c $aria2_multi_threaded https://huggingface.co/licyk/controlnet_v1.1/resolve/main/control_sd15_seg.yaml -d ./ComfyUI/models/controlnet -o control_sd15_seg.yaml

                cmd_daemon aria2c $aria2_multi_threaded https://huggingface.co/licyk/controlnet_v1.1/resolve/main/control_v11e_sd15_ip2p_fp16.safetensors -d ./ComfyUI/models/controlnet -o control_v11e_sd15_ip2p_fp16.safetensors
                cmd_daemon aria2c $aria2_multi_threaded https://huggingface.co/licyk/controlnet_v1.1/resolve/main/control_v11e_sd15_ip2p_fp16.yaml -d ./ComfyUI/models/controlnet -o control_v11e_sd15_ip2p_fp16.yaml

                cmd_daemon aria2c $aria2_multi_threaded https://huggingface.co/licyk/controlnet_v1.1/resolve/main/control_v11e_sd15_shuffle_fp16.safetensors -d ./ComfyUI/models/controlnet -o control_v11e_sd15_shuffle_fp16.safetensors
                cmd_daemon aria2c $aria2_multi_threaded https://huggingface.co/licyk/controlnet_v1.1/resolve/main/control_v11e_sd15_shuffle_fp16.yaml -d ./ComfyUI/models/controlnet -o control_v11e_sd15_shuffle_fp16.yaml

                cmd_daemon aria2c $aria2_multi_threaded https://huggingface.co/licyk/controlnet_v1.1/resolve/main/control_v11f1e_sd15_tile_fp16.safetensors -d ./ComfyUI/models/controlnet -o control_v11f1e_sd15_tile_fp16.safetensors
                cmd_daemon aria2c $aria2_multi_threaded https://huggingface.co/licyk/controlnet_v1.1/resolve/main/control_v11f1e_sd15_tile_fp16.yaml -d ./ComfyUI/models/controlnet -o control_v11f1e_sd15_tile_fp16.yaml

                cmd_daemon aria2c $aria2_multi_threaded https://huggingface.co/licyk/controlnet_v1.1/resolve/main/control_v11f1p_sd15_depth_fp16.safetensors -d ./ComfyUI/models/controlnet -o control_v11f1p_sd15_depth_fp16.safetensors
                cmd_daemon aria2c $aria2_multi_threaded https://huggingface.co/licyk/controlnet_v1.1/resolve/main/control_v11f1p_sd15_depth_fp16.yaml -d ./ComfyUI/models/controlnet -o control_v11f1p_sd15_depth_fp16.yaml

                cmd_daemon aria2c $aria2_multi_threaded https://huggingface.co/licyk/controlnet_v1.1/resolve/main/control_v11p_sd15_canny_fp16.safetensors -d ./ComfyUI/models/controlnet -o control_v11p_sd15_canny_fp16.safetensors
                cmd_daemon aria2c $aria2_multi_threaded https://huggingface.co/licyk/controlnet_v1.1/resolve/main/control_v11p_sd15_canny_fp16.yaml -d ./ComfyUI/models/controlnet -o control_v11p_sd15_canny_fp16.yaml

                cmd_daemon aria2c $aria2_multi_threaded https://huggingface.co/licyk/controlnet_v1.1/resolve/main/control_v11p_sd15_inpaint_fp16.safetensors -d ./ComfyUI/models/controlnet -o control_v11p_sd15_inpaint_fp16.safetensors
                cmd_daemon aria2c $aria2_multi_threaded https://huggingface.co/licyk/controlnet_v1.1/resolve/main/control_v11p_sd15_inpaint_fp16.yaml -d ./ComfyUI/models/controlnet -o control_v11p_sd15_inpaint_fp16.yaml

                cmd_daemon aria2c $aria2_multi_threaded https://huggingface.co/licyk/controlnet_v1.1/resolve/main/control_v11p_sd15_lineart_fp16.safetensors -d ./ComfyUI/models/controlnet -o control_v11p_sd15_lineart_fp16.safetensors
                cmd_daemon aria2c $aria2_multi_threaded https://huggingface.co/licyk/controlnet_v1.1/resolve/main/control_v11p_sd15_lineart_fp16.yaml -d ./ComfyUI/models/controlnet -o control_v11p_sd15_lineart_fp16.yaml

                cmd_daemon aria2c $aria2_multi_threaded https://huggingface.co/licyk/controlnet_v1.1/resolve/main/control_v11p_sd15_mlsd_fp16.safetensors -d ./ComfyUI/models/controlnet -o control_v11p_sd15_mlsd_fp16.safetensors
                cmd_daemon aria2c $aria2_multi_threaded https://huggingface.co/licyk/controlnet_v1.1/resolve/main/control_v11p_sd15_mlsd_fp16.yaml -d ./ComfyUI/models/controlnet -o control_v11p_sd15_mlsd_fp16.yaml

                cmd_daemon aria2c $aria2_multi_threaded https://huggingface.co/licyk/controlnet_v1.1/resolve/main/control_v11p_sd15_normalbae_fp16.safetensors -d ./ComfyUI/models/controlnet -o control_v11p_sd15_normalbae_fp16.safetensors
                cmd_daemon aria2c $aria2_multi_threaded https://huggingface.co/licyk/controlnet_v1.1/resolve/main/control_v11p_sd15_normalbae_fp16.yaml -d ./ComfyUI/models/controlnet -o control_v11p_sd15_normalbae_fp16.yaml

                cmd_daemon aria2c $aria2_multi_threaded https://huggingface.co/licyk/controlnet_v1.1/resolve/main/control_v11p_sd15_openpose_fp16.safetensors -d ./ComfyUI/models/controlnet -o control_v11p_sd15_openpose_fp16.safetensors
                cmd_daemon aria2c $aria2_multi_threaded https://huggingface.co/licyk/controlnet_v1.1/resolve/main/control_v11p_sd15_openpose_fp16.yaml -d ./ComfyUI/models/controlnet -o control_v11p_sd15_openpose_fp16.yaml

                cmd_daemon aria2c $aria2_multi_threaded https://huggingface.co/licyk/controlnet_v1.1/resolve/main/control_v11p_sd15_scribble_fp16.safetensors -d ./ComfyUI/models/controlnet -o control_v11p_sd15_scribble_fp16.safetensors
                cmd_daemon aria2c $aria2_multi_threaded https://huggingface.co/licyk/controlnet_v1.1/resolve/main/control_v11p_sd15_scribble_fp16.yaml -d ./ComfyUI/models/controlnet -o control_v11p_sd15_scribble_fp16.yaml

                cmd_daemon aria2c $aria2_multi_threaded https://huggingface.co/licyk/controlnet_v1.1/resolve/main/control_v11p_sd15_seg_fp16.safetensors -d ./ComfyUI/models/controlnet -o control_v11p_sd15_seg_fp16.safetensors
                cmd_daemon aria2c $aria2_multi_threaded https://huggingface.co/licyk/controlnet_v1.1/resolve/main/control_v11p_sd15_seg_fp16.yaml -d ./ComfyUI/models/controlnet -o control_v11p_sd15_seg_fp16.yaml

                cmd_daemon aria2c $aria2_multi_threaded https://huggingface.co/licyk/controlnet_v1.1/resolve/main/control_v11p_sd15_softedge_fp16.safetensors -d ./ComfyUI/models/controlnet -o control_v11p_sd15_softedge_fp16.safetensors
                cmd_daemon aria2c $aria2_multi_threaded https://huggingface.co/licyk/controlnet_v1.1/resolve/main/control_v11p_sd15_softedge_fp16.yaml -d ./ComfyUI/models/controlnet -o control_v11p_sd15_softedge_fp16.yaml

                cmd_daemon aria2c $aria2_multi_threaded https://huggingface.co/licyk/controlnet_v1.1/resolve/main/control_v11p_sd15s2_lineart_anime_fp16.safetensors -d ./ComfyUI/models/controlnet -o control_v11p_sd15s2_lineart_anime_fp16.safetensors
                cmd_daemon aria2c $aria2_multi_threaded https://huggingface.co/licyk/controlnet_v1.1/resolve/main/control_v11p_sd15s2_lineart_anime_fp16.yaml -d ./ComfyUI/models/controlnet -o control_v11p_sd15s2_lineart_anime_fp16.yaml

                cmd_daemon aria2c $aria2_multi_threaded https://huggingface.co/licyk/controlnet_v1.1/resolve/main/control_v1p_sd15_brightness.safetensors -d ./ComfyUI/models/controlnet -o control_v1p_sd15_brightness.safetensors
                cmd_daemon aria2c $aria2_multi_threaded https://huggingface.co/licyk/controlnet_v1.1/resolve/main/control_v1p_sd15_illumination.safetensors -d ./ComfyUI/models/controlnet -o control_v1p_sd15_illumination.safetensors

                cmd_daemon aria2c $aria2_multi_threaded https://huggingface.co/licyk/controlnet_v1.1/resolve/main/control_v1p_sd15_qrcode_monster.safetensors -d ./ComfyUI/models/controlnet -o control_v1p_sd15_qrcode_monster.safetensors
                cmd_daemon aria2c $aria2_multi_threaded https://huggingface.co/licyk/controlnet_v1.1/resolve/main/control_v1p_sd15_qrcode_monster.yaml -d ./ComfyUI/models/controlnet -o control_v1p_sd15_qrcode_monster.yaml

                cmd_daemon aria2c $aria2_multi_threaded https://huggingface.co/licyk/controlnet_v1.1/resolve/main/t2iadapter_canny_sd15v2.pth -d ./ComfyUI/models/controlnet -o t2iadapter_canny_sd15v2.pth
                cmd_daemon aria2c $aria2_multi_threaded https://huggingface.co/licyk/controlnet_v1.1/resolve/main/t2iadapter_canny_sd15v2.yaml -d ./ComfyUI/models/controlnet -o t2iadapter_canny_sd15v2.yaml

                cmd_daemon aria2c $aria2_multi_threaded https://huggingface.co/licyk/controlnet_v1.1/resolve/main/t2iadapter_color_sd14v1.pth -d ./ComfyUI/models/controlnet -o t2iadapter_color_sd14v1.pth
                cmd_daemon aria2c $aria2_multi_threaded https://huggingface.co/licyk/controlnet_v1.1/resolve/main/t2iadapter_color_sd14v1.yaml -d ./ComfyUI/models/controlnet -o t2iadapter_color_sd14v1.yaml

                cmd_daemon aria2c $aria2_multi_threaded https://huggingface.co/licyk/controlnet_v1.1/resolve/main/t2iadapter_depth_sd15v2.pth -d ./ComfyUI/models/controlnet -o t2iadapter_depth_sd15v2.pth
                cmd_daemon aria2c $aria2_multi_threaded https://huggingface.co/licyk/controlnet_v1.1/resolve/main/t2iadapter_depth_sd15v2.yaml -d ./ComfyUI/models/controlnet -o t2iadapter_depth_sd15v2.yaml

                cmd_daemon aria2c $aria2_multi_threaded https://huggingface.co/licyk/controlnet_v1.1/resolve/main/t2iadapter_keypose_sd14v1.pth -d ./ComfyUI/models/controlnet -o t2iadapter_keypose_sd14v1.pth
                cmd_daemon aria2c $aria2_multi_threaded https://huggingface.co/licyk/controlnet_v1.1/resolve/main/t2iadapter_keypose_sd14v1.yaml -d ./ComfyUI/models/controlnet -o t2iadapter_keypose_sd14v1.yaml

                cmd_daemon aria2c $aria2_multi_threaded https://huggingface.co/licyk/controlnet_v1.1/resolve/main/t2iadapter_openpose_sd14v1.pth -d ./ComfyUI/models/controlnet -o t2iadapter_openpose_sd14v1.pth
                cmd_daemon aria2c $aria2_multi_threaded https://huggingface.co/licyk/controlnet_v1.1/resolve/main/t2iadapter_openpose_sd14v1.yaml -d ./ComfyUI/models/controlnet -o t2iadapter_openpose_sd14v1.yaml

                cmd_daemon aria2c $aria2_multi_threaded https://huggingface.co/licyk/controlnet_v1.1/resolve/main/t2iadapter_seg_sd14v1.pth -d ./ComfyUI/models/controlnet -o t2iadapter_seg_sd14v1.pth
                cmd_daemon aria2c $aria2_multi_threaded https://huggingface.co/licyk/controlnet_v1.1/resolve/main/t2iadapter_seg_sd14v1.yaml -d ./ComfyUI/models/controlnet -o t2iadapter_seg_sd14v1.yaml

                cmd_daemon aria2c $aria2_multi_threaded https://huggingface.co/licyk/controlnet_v1.1/resolve/main/t2iadapter_sketch_sd15v2.pth -d ./ComfyUI/models/controlnet -o t2iadapter_sketch_sd15v2.pth
                cmd_daemon aria2c $aria2_multi_threaded https://huggingface.co/licyk/controlnet_v1.1/resolve/main/t2iadapter_sketch_sd15v2.yaml -d ./ComfyUI/models/controlnet -o t2iadapter_sketch_sd15v2.yaml

                cmd_daemon aria2c $aria2_multi_threaded https://huggingface.co/licyk/controlnet_v1.1/resolve/main/t2iadapter_style_sd14v1.pth -d ./ComfyUI/models/controlnet -o t2iadapter_style_sd14v1.pth
                cmd_daemon aria2c $aria2_multi_threaded https://huggingface.co/licyk/controlnet_v1.1/resolve/main/t2iadapter_style_sd14v1.yaml -d ./ComfyUI/models/controlnet -o t2iadapter_style_sd14v1.yaml

                cmd_daemon aria2c $aria2_multi_threaded https://huggingface.co/licyk/controlnet_v1.1/resolve/main/t2iadapter_zoedepth_sd15v1.pth -d ./ComfyUI/models/controlnet -o t2iadapter_zoedepth_sd15v1.pth
                cmd_daemon aria2c $aria2_multi_threaded https://huggingface.co/licyk/controlnet_v1.1/resolve/main/t2iadapter_zoedepth_sd15v1.yaml -d ./ComfyUI/models/controlnet -o t2iadapter_zoedepth_sd15v1.yaml

                cmd_daemon aria2c $aria2_multi_threaded https://huggingface.co/licyk/controlnet_v1.1/resolve/main/image_adapter_v14.yaml -d ./ComfyUI/models/controlnet -o image_adapter_v14.yaml
                cmd_daemon aria2c $aria2_multi_threaded https://huggingface.co/licyk/controlnet_v1.1/resolve/main/ip-adapter-plus-face_sd15.pth -d ./ComfyUI/models/controlnet -o ip-adapter-plus-face_sd15.pth
                cmd_daemon aria2c $aria2_multi_threaded https://huggingface.co/licyk/controlnet_v1.1/resolve/main/ip-adapter_sd15.pth -d ./ComfyUI/models/controlnet -o ip-adapter_sd15.pth
                cmd_daemon aria2c $aria2_multi_threaded https://huggingface.co/licyk/controlnet_v1.1/resolve/main/ip-adapter_sd15_light.pth -d ./ComfyUI/models/controlnet -o ip-adapter_sd15_light.pth
                cmd_daemon aria2c $aria2_multi_threaded https://huggingface.co/licyk/controlnet_v1.1/resolve/main/ip-adapter_sd15_plus.pth -d ./ComfyUI/models/controlnet -o ip-adapter_sd15_plus.pth
                cmd_daemon aria2c $aria2_multi_threaded https://huggingface.co/licyk/controlnet_v1.1/resolve/main/sketch_adapter_v14.yaml -d ./ComfyUI/models/controlnet -o sketch_adapter_v14.yaml
            fi

        else #使用modelscope下载模型
            term_sd_notice "使用modelscope模型下载源"
            get_modelscope_model licyks/sd-model/master/sd_1.5/v1-5-pruned-emaonly.safetensors ./ComfyUI/models/checkpoints
            get_modelscope_model licyks/sd-vae/master/sd_1.5/vae-ft-ema-560000-ema-pruned.safetensors ./ComfyUI/models/vae
            get_modelscope_model licyks/sd-vae/master/sd_1.5/vae-ft-mse-840000-ema-pruned.safetensors ./ComfyUI/models/vae

            if [ $a1111_sd_webui_extension_model_1 = 0 ];then #安装controlnet时再下载相关模型
                term_sd_notice "下载controlnet模型中"
                get_modelscope_model licyks/controlnet_v1.1/master/cldm_v15.yaml ./ComfyUI/models/controlnet
                get_modelscope_model licyks/controlnet_v1.1/master/cldm_v21.yaml ./ComfyUI/models/controlnet
                get_modelscope_model licyks/controlnet_v1.1/master/control_sd15_canny.yaml ./ComfyUI/models/controlnet
                get_modelscope_model licyks/controlnet_v1.1/master/control_sd15_depth.yaml ./ComfyUI/models/controlnet
                get_modelscope_model licyks/controlnet_v1.1/master/control_sd15_hed.yaml ./ComfyUI/models/controlnet
                get_modelscope_model licyks/controlnet_v1.1/master/control_sd15_mlsd.yaml ./ComfyUI/models/controlnet
                get_modelscope_model licyks/controlnet_v1.1/master/control_sd15_normal.yaml ./ComfyUI/models/controlnet
                get_modelscope_model licyks/controlnet_v1.1/master/control_sd15_openpose.yaml ./ComfyUI/models/controlnet
                get_modelscope_model licyks/controlnet_v1.1/master/control_sd15_scribble.yaml ./ComfyUI/models/controlnet
                get_modelscope_model licyks/controlnet_v1.1/master/control_sd15_seg.yaml ./ComfyUI/models/controlnet

                get_modelscope_model licyks/controlnet_v1.1/master/control_v11e_sd15_ip2p_fp16.safetensors ./ComfyUI/models/controlnet
                get_modelscope_model licyks/controlnet_v1.1/master/control_v11e_sd15_ip2p_fp16.yaml ./ComfyUI/models/controlnet

                get_modelscope_model licyks/controlnet_v1.1/master/control_v11e_sd15_shuffle_fp16.safetensors ./ComfyUI/models/controlnet
                get_modelscope_model licyks/controlnet_v1.1/master/control_v11e_sd15_shuffle_fp16.yaml ./ComfyUI/models/controlnet

                get_modelscope_model licyks/controlnet_v1.1/master/control_v11f1e_sd15_tile_fp16.safetensors ./ComfyUI/models/controlnet
                get_modelscope_model licyks/controlnet_v1.1/master/control_v11f1e_sd15_tile_fp16.yaml ./ComfyUI/models/controlnet

                get_modelscope_model licyks/controlnet_v1.1/master/control_v11f1p_sd15_depth_fp16.safetensors ./ComfyUI/models/controlnet
                get_modelscope_model licyks/controlnet_v1.1/master/control_v11f1p_sd15_depth_fp16.yaml ./ComfyUI/models/controlnet

                get_modelscope_model licyks/controlnet_v1.1/master/control_v11p_sd15_canny_fp16.safetensors ./ComfyUI/models/controlnet
                get_modelscope_model licyks/controlnet_v1.1/master/control_v11p_sd15_canny_fp16.yaml ./ComfyUI/models/controlnet

                get_modelscope_model licyks/controlnet_v1.1/master/control_v11p_sd15_inpaint_fp16.safetensors ./ComfyUI/models/controlnet
                get_modelscope_model licyks/controlnet_v1.1/master/control_v11p_sd15_inpaint_fp16.yaml ./ComfyUI/models/controlnet

                get_modelscope_model licyks/controlnet_v1.1/master/control_v11p_sd15_lineart_fp16.safetensors ./ComfyUI/models/controlnet
                get_modelscope_model licyks/controlnet_v1.1/master/control_v11p_sd15_lineart_fp16.yaml ./ComfyUI/models/controlnet

                get_modelscope_model licyks/controlnet_v1.1/master/control_v11p_sd15_mlsd_fp16.safetensors ./ComfyUI/models/controlnet
                get_modelscope_model licyks/controlnet_v1.1/master/control_v11p_sd15_mlsd_fp16.yaml ./ComfyUI/models/controlnet

                get_modelscope_model licyks/controlnet_v1.1/master/control_v11p_sd15_normalbae_fp16.safetensors ./ComfyUI/models/controlnet
                get_modelscope_model licyks/controlnet_v1.1/master/control_v11p_sd15_normalbae_fp16.yaml ./ComfyUI/models/controlnet

                get_modelscope_model licyks/controlnet_v1.1/master/control_v11p_sd15_openpose_fp16.safetensors ./ComfyUI/models/controlnet
                get_modelscope_model licyks/controlnet_v1.1/master/control_v11p_sd15_openpose_fp16.yaml ./ComfyUI/models/controlnet

                get_modelscope_model licyks/controlnet_v1.1/master/control_v11p_sd15_scribble_fp16.safetensors ./ComfyUI/models/controlnet
                get_modelscope_model licyks/controlnet_v1.1/master/control_v11p_sd15_scribble_fp16.yaml ./ComfyUI/models/controlnet

                get_modelscope_model licyks/controlnet_v1.1/master/control_v11p_sd15_seg_fp16.safetensors ./ComfyUI/models/controlnet
                get_modelscope_model licyks/controlnet_v1.1/master/control_v11p_sd15_seg_fp16.yaml ./ComfyUI/models/controlnet

                get_modelscope_model licyks/controlnet_v1.1/master/control_v11p_sd15_softedge_fp16.safetensors ./ComfyUI/models/controlnet
                get_modelscope_model licyks/controlnet_v1.1/master/control_v11p_sd15_softedge_fp16.yaml ./ComfyUI/models/controlnet

                get_modelscope_model licyks/controlnet_v1.1/master/control_v11p_sd15s2_lineart_anime_fp16.safetensors ./ComfyUI/models/controlnet
                get_modelscope_model licyks/controlnet_v1.1/master/control_v11p_sd15s2_lineart_anime_fp16.yaml ./ComfyUI/models/controlnet

                get_modelscope_model licyks/controlnet_v1.1/master/control_v1p_sd15_brightness.safetensors ./ComfyUI/models/controlnet
                get_modelscope_model licyks/controlnet_v1.1/master/control_v1p_sd15_illumination.safetensors ./ComfyUI/models/controlnet

                get_modelscope_model licyks/controlnet_v1.1/master/control_v1p_sd15_qrcode_monster.safetensors ./ComfyUI/models/controlnet
                get_modelscope_model licyks/controlnet_v1.1/master/control_v1p_sd15_qrcode_monster.yaml ./ComfyUI/models/controlnet

                get_modelscope_model licyks/controlnet_v1.1/master/t2iadapter_canny_sd15v2.pth ./ComfyUI/models/controlnet
                get_modelscope_model licyks/controlnet_v1.1/master/t2iadapter_canny_sd15v2.yaml ./ComfyUI/models/controlnet

                get_modelscope_model licyks/controlnet_v1.1/master/t2iadapter_color_sd14v1.pth ./ComfyUI/models/controlnet
                get_modelscope_model licyks/controlnet_v1.1/master/t2iadapter_color_sd14v1.yaml ./ComfyUI/models/controlnet

                get_modelscope_model licyks/controlnet_v1.1/master/t2iadapter_depth_sd15v2.pth ./ComfyUI/models/controlnet
                get_modelscope_model licyks/controlnet_v1.1/master/t2iadapter_depth_sd15v2.yaml ./ComfyUI/models/controlnet

                get_modelscope_model licyks/controlnet_v1.1/master/t2iadapter_keypose_sd14v1.pth ./ComfyUI/models/controlnet
                get_modelscope_model licyks/controlnet_v1.1/master/t2iadapter_keypose_sd14v1.yaml ./ComfyUI/models/controlnet

                get_modelscope_model licyks/controlnet_v1.1/master/t2iadapter_openpose_sd14v1.pth ./ComfyUI/models/controlnet
                get_modelscope_model licyks/controlnet_v1.1/master/t2iadapter_openpose_sd14v1.yaml ./ComfyUI/models/controlnet

                get_modelscope_model licyks/controlnet_v1.1/master/t2iadapter_seg_sd14v1.pth ./ComfyUI/models/controlnet
                get_modelscope_model licyks/controlnet_v1.1/master/t2iadapter_seg_sd14v1.yaml ./ComfyUI/models/controlnet

                get_modelscope_model licyks/controlnet_v1.1/master/t2iadapter_sketch_sd15v2.pth ./ComfyUI/models/controlnet
                get_modelscope_model licyks/controlnet_v1.1/master/t2iadapter_sketch_sd15v2.yaml ./ComfyUI/models/controlnet

                get_modelscope_model licyks/controlnet_v1.1/master/t2iadapter_style_sd14v1.pth ./ComfyUI/models/controlnet
                get_modelscope_model licyks/controlnet_v1.1/master/t2iadapter_style_sd14v1.yaml ./ComfyUI/models/controlnet

                get_modelscope_model licyks/controlnet_v1.1/master/t2iadapter_zoedepth_sd15v1.pth ./ComfyUI/models/controlnet
                get_modelscope_model licyks/controlnet_v1.1/master/t2iadapter_zoedepth_sd15v1.yaml ./ComfyUI/models/controlnet

                get_modelscope_model licyks/controlnet_v1.1/master/image_adapter_v14.yaml ./ComfyUI/models/controlnet
                get_modelscope_model licyks/controlnet_v1.1/master/ip-adapter-plus-face_sd15.pth ./ComfyUI/models/controlnet
                get_modelscope_model licyks/controlnet_v1.1/master/ip-adapter_sd15.pth ./ComfyUI/models/controlnet
                get_modelscope_model licyks/controlnet_v1.1/master/ip-adapter_sd15_light.pth ./ComfyUI/models/controlnet
                get_modelscope_model licyks/controlnet_v1.1/master/ip-adapter_sd15_plus.pth ./ComfyUI/models/controlnet
                get_modelscope_model licyks/controlnet_v1.1/master/sketch_adapter_v14.yaml ./ComfyUI/models/controlnet
            fi
            tmp_enable_proxy #恢复原有的代理
        fi
        term_sd_notice "安装结束"
        exit_venv
        print_line_to_shell
        comfyui_option
    fi
}