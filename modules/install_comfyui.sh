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
        git clone "$github_proxy"https://github.com/comfyanonymous/ComfyUI
        [ ! -d "./$term_sd_manager_info" ] && tmp_enable_proxy && term_sd_notice "检测到"$term_sd_manager_info"框架安装失败,已终止安装进程" && sleep 3 && return 1 #防止继续进行安装导致文件散落,造成目录混乱
        cd ./ComfyUI
        create_venv
        enter_venv
        cd ..

        if [ ! -z "$(echo $pytorch_install_version | awk '{gsub(/[=+]/, "")}1')" ];then
            pip_cmd install $pytorch_install_version $pip_index_mirror $pip_extra_index_mirror $pip_find_mirror $force_pip $pip_install_methon_select --default-timeout=100 --retries 5
        fi
        pip_cmd install -r ./ComfyUI/requirements.txt  --prefer-binary $pip_index_mirror $pip_extra_index_mirror $pip_find_mirror $force_pip $pip_install_methon_select --default-timeout=100 --retries 5

        if [ ! -z "$comfyui_extension_install_list" ];then
            term_sd_notice "安装插件中"
            for comfyui_extension_install_list_ in $comfyui_extension_install_list ;do
                git clone --recurse-submodules "$github_proxy"$comfyui_extension_install_list_ ./ComfyUI/web/extensions/$(echo $comfyui_extension_install_list_ | awk -F'/' '{print $NF}')
            done
        fi

        if [ ! -z "$comfyui_custom_node_install_list" ];then
            term_sd_notice "安装自定义节点中"
            for comfyui_custom_node_install_list_ in $comfyui_custom_node_install_list ;do
                git clone --recurse-submodules "$github_proxy"$comfyui_custom_node_install_list_ ./ComfyUI/custom_nodes/$(echo $comfyui_custom_node_install_list_ | awk -F'/' '{print $NF}')
            done
        fi

        term_sd_notice "下载模型中"
        tmp_enable_proxy #恢复原有的代理,保证能从huggingface下载模型
        aria2c $aria2_multi_threaded https://huggingface.co/runwayml/stable-diffusion-v1-5/resolve/main/v1-5-pruned-emaonly.ckpt -d ./ComfyUI/models/checkpoints/ -o sd-v1-5.ckpt

        if [ $comfyui_custom_node_extension_model_1 = 0 ];then
            term_sd_notice "下载controlnet模型中"
            aria2c $aria2_multi_threaded https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/control_v11e_sd15_ip2p_fp16.safetensors -d ./ComfyUI/models/controlnet -o control_v11e_sd15_ip2p_fp16.safetensors
            aria2c $aria2_multi_threaded https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/control_v11e_sd15_shuffle_fp16.safetensors -d ./ComfyUI/models/controlnet -o control_v11e_sd15_shuffle_fp16.safetensors
            aria2c $aria2_multi_threaded https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/control_v11p_sd15_canny_fp16.safetensors -d ./ComfyUI/models/controlnet -o control_v11p_sd15_canny_fp16.safetensors
            aria2c $aria2_multi_threaded https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/control_v11f1p_sd15_depth_fp16.safetensors -d ./ComfyUI/models/controlnet -o control_v11f1p_sd15_depth_fp16.safetensors
            aria2c $aria2_multi_threaded https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/control_v11p_sd15_inpaint_fp16.safetensors -d ./ComfyUI/models/controlnet -o control_v11p_sd15_inpaint_fp16.safetensors
            aria2c $aria2_multi_threaded https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/control_v11p_sd15_lineart_fp16.safetensors -d ./ComfyUI/models/controlnet -o control_v11p_sd15_lineart_fp16.safetensors
            aria2c $aria2_multi_threaded https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/control_v11p_sd15_mlsd_fp16.safetensors -d ./ComfyUI/models/controlnet -o control_v11p_sd15_mlsd_fp16.safetensors
            aria2c $aria2_multi_threaded https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/control_v11p_sd15_normalbae_fp16.safetensors -d ./ComfyUI/models/controlnet -o control_v11p_sd15_normalbae_fp16.safetensors
            aria2c $aria2_multi_threaded https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/control_v11p_sd15_openpose_fp16.safetensors -d ./ComfyUI/models/controlnet -o control_v11p_sd15_openpose_fp16.safetensors
            aria2c $aria2_multi_threaded https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/control_v11p_sd15_scribble_fp16.safetensors -d ./ComfyUI/models/controlnet -o control_v11p_sd15_scribble_fp16.safetensors
            aria2c $aria2_multi_threaded https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/control_v11p_sd15_seg_fp16.safetensors -d ./ComfyUI/models/controlnet -o control_v11p_sd15_seg_fp16.safetensors
            aria2c $aria2_multi_threaded https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/control_v11p_sd15_softedge_fp16.safetensors -d ./ComfyUI/models/controlnet -o control_v11p_sd15_softedge_fp16.safetensors
            aria2c $aria2_multi_threaded https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/control_v11p_sd15s2_lineart_anime_fp16.safetensors -d ./ComfyUI/models/controlnet -o control_v11p_sd15s2_lineart_anime_fp16.safetensors
            aria2c $aria2_multi_threaded https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/control_v11f1e_sd15_tile_fp16.safetensors -d ./ComfyUI/models/controlnet -o control_v11f1e_sd15_tile_fp16.safetensors
            aria2c $aria2_multi_threaded https://huggingface.co/ckpt/ControlNet-v1-1/raw/main/control_v11e_sd15_ip2p_fp16.yaml -d ./ComfyUI/models/controlnet -o control_v11e_sd15_ip2p_fp16.yaml
            aria2c $aria2_multi_threaded https://huggingface.co/ckpt/ControlNet-v1-1/raw/main/control_v11e_sd15_shuffle_fp16.yaml -d ./ComfyUI/models/controlnet -o control_v11e_sd15_shuffle_fp16.yaml
            aria2c $aria2_multi_threaded https://huggingface.co/ckpt/ControlNet-v1-1/raw/main/control_v11p_sd15_canny_fp16.yaml -d ./ComfyUI/models/controlnet -o control_v11p_sd15_canny_fp16.yaml
            aria2c $aria2_multi_threaded https://huggingface.co/ckpt/ControlNet-v1-1/raw/main/control_v11f1p_sd15_depth_fp16.yaml -d ./ComfyUI/models/controlnet -o control_v11f1p_sd15_depth_fp16.yaml
            aria2c $aria2_multi_threaded https://huggingface.co/ckpt/ControlNet-v1-1/raw/main/control_v11p_sd15_inpaint_fp16.yaml -d ./ComfyUI/models/controlnet -o control_v11p_sd15_inpaint_fp16.yaml
            aria2c $aria2_multi_threaded https://huggingface.co/ckpt/ControlNet-v1-1/raw/main/control_v11p_sd15_lineart_fp16.yaml -d ./ComfyUI/models/controlnet -o control_v11p_sd15_lineart_fp16.yaml
            aria2c $aria2_multi_threaded https://huggingface.co/ckpt/ControlNet-v1-1/raw/main/control_v11p_sd15_mlsd_fp16.yaml -d ./ComfyUI/models/controlnet -o control_v11p_sd15_mlsd_fp16.yaml
            aria2c $aria2_multi_threaded https://huggingface.co/ckpt/ControlNet-v1-1/raw/main/control_v11p_sd15_normalbae_fp16.yaml -d ./ComfyUI/models/controlnet -o control_v11p_sd15_normalbae_fp16.yaml
            aria2c $aria2_multi_threaded https://huggingface.co/ckpt/ControlNet-v1-1/raw/main/control_v11p_sd15_openpose_fp16.yaml -d ./ComfyUI/models/controlnet -o control_v11p_sd15_openpose_fp16.yaml
            aria2c $aria2_multi_threaded https://huggingface.co/ckpt/ControlNet-v1-1/raw/main/control_v11p_sd15_scribble_fp16.yaml -d ./ComfyUI/models/controlnet -o control_v11p_sd15_scribble_fp16.yaml
            aria2c $aria2_multi_threaded https://huggingface.co/ckpt/ControlNet-v1-1/raw/main/control_v11p_sd15_seg_fp16.yaml -d ./ComfyUI/models/controlnet -o control_v11p_sd15_seg_fp16.yaml
            aria2c $aria2_multi_threaded https://huggingface.co/ckpt/ControlNet-v1-1/raw/main/control_v11p_sd15_softedge_fp16.yaml -d ./ComfyUI/models/controlnet -o control_v11p_sd15_softedge_fp16.yaml
            aria2c $aria2_multi_threaded https://huggingface.co/ckpt/ControlNet-v1-1/raw/main/control_v11p_sd15s2_lineart_anime_fp16.yaml -d ./ComfyUI/models/controlnet -o control_v11p_sd15s2_lineart_anime_fp16.yaml
            aria2c $aria2_multi_threaded https://huggingface.co/ckpt/ControlNet-v1-1/raw/main/control_v11f1e_sd15_tile_fp16.yaml -d ./ComfyUI/models/controlnet -o control_v11f1e_sd15_tile_fp16.yaml
            aria2c $aria2_multi_threaded https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/t2iadapter_style_sd14v1.pth -d ./ComfyUI/models/controlnet -o t2iadapter_style_sd14v1.pth
            aria2c $aria2_multi_threaded https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/t2iadapter_sketch_sd14v1.pth -d ./ComfyUI/models/controlnet -o t2iadapter_sketch_sd14v1.pth
            aria2c $aria2_multi_threaded https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/t2iadapter_seg_sd14v1.pth -d ./ComfyUI/models/controlnet -o t2iadapter_seg_sd14v1.pth
            aria2c $aria2_multi_threaded https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/t2iadapter_openpose_sd14v1.pth -d ./ComfyUI/models/controlnet -o t2iadapter_openpose_sd14v1.pth
            aria2c $aria2_multi_threaded https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/t2iadapter_keypose_sd14v1.pth -d ./ComfyUI/models/controlnet -o t2iadapter_keypose_sd14v1.pth
            aria2c $aria2_multi_threaded https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/t2iadapter_depth_sd14v1.pth -d ./ComfyUI/models/controlnet -o t2iadapter_depth_sd14v1.pth
            aria2c $aria2_multi_threaded https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/t2iadapter_color_sd14v1.pth -d ./ComfyUI/models/controlnet -o t2iadapter_color_sd14v1.pth
            aria2c $aria2_multi_threaded https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/t2iadapter_canny_sd14v1.pth -d ./ComfyUI/models/controlnet -o t2iadapter_canny_sd14v1.pth
            aria2c $aria2_multi_threaded https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/t2iadapter_canny_sd15v2.pth -d ./ComfyUI/models/controlnet -o t2iadapter_canny_sd15v2.pth
            aria2c $aria2_multi_threaded https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/t2iadapter_depth_sd15v2.pth -d ./ComfyUI/models/controlnet -o t2iadapter_depth_sd15v2.pth
            aria2c $aria2_multi_threaded https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/t2iadapter_sketch_sd15v2.pth -d ./ComfyUI/models/controlnet -o t2iadapter_sketch_sd15v2.pth
            aria2c $aria2_multi_threaded https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/t2iadapter_zoedepth_sd15v1.pth -d ./ComfyUI/models/controlnet -o t2iadapter_zoedepth_sd15v1.pth
            aria2c $aria2_multi_threaded https://huggingface.co/ioclab/ioc-controlnet/resolve/main/models/control_v1p_sd15_brightness.safetensors -d ./ComfyUI/models/controlnet -o control_v1p_sd15_brightness.safetensors
            aria2c $aria2_multi_threaded https://huggingface.co/ioclab/ioc-controlnet/resolve/main/models/control_v1p_sd15_illumination.safetensors -d ./ComfyUI/models/controlnet -o control_v1p_sd15_illumination.safetensors
            aria2c $aria2_multi_threaded https://huggingface.co/monster-labs/control_v1p_sd15_qrcode_monster/resolve/main/control_v1p_sd15_qrcode_monster.safetensors -d ./ComfyUI/models/controlnet -o control_v1p_sd15_qrcode_monster.safetensors
            aria2c $aria2_multi_threaded https://huggingface.co/monster-labs/control_v1p_sd15_qrcode_monster/resolve/main/control_v1p_sd15_qrcode_monster.yaml -d ./ComfyUI/models/controlnet -o control_v1p_sd15_qrcode_monster.yaml
            aria2c $aria2_multi_threaded https://huggingface.co/h94/IP-Adapter/resolve/main/models/ip-adapter-plus-face_sd15.bin -d ./ComfyUI/models/controlnet -o ip-adapter-plus-face_sd15.pth
            aria2c $aria2_multi_threaded https://huggingface.co/h94/IP-Adapter/resolve/main/models/ip-adapter-plus_sd15.bin -d ./ComfyUI/models/controlnet -o ip-adapter-plus_sd15.pth
            aria2c $aria2_multi_threaded https://huggingface.co/h94/IP-Adapter/resolve/main/models/ip-adapter_sd15.bin -d ./ComfyUI/models/controlnet -o ip-adapter_sd15.pth
            aria2c $aria2_multi_threaded https://huggingface.co/h94/IP-Adapter/resolve/main/models/ip-adapter_sd15_light.bin -d ./ComfyUI/models/controlnet -o ip-adapter_sd15_light.pth
        fi
        term_sd_notice "安装结束"
        exit_venv
        print_line_to_shell
        comfyui_option
    else
        mainmenu
    fi
}