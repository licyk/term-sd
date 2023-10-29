#!/bin/bash

#fooocus安装功能
function process_install_fooocus()
{
    #安装前的准备
    proxy_option #代理选择
    pytorch_version_select #pytorch选择
    pip_install_methon #安装方式选择
    final_install_check #安装前确认

    if [ $final_install_check_exec = 0 ];then
        #开始安装Fooocus
        print_line_to_shell "Fooocus 安装"
        term_sd_notice "开始安装Fooocus"
        tmp_disable_proxy #临时取消代理,避免一些不必要的网络减速
        cmd_daemon git clone "$github_proxy"https://github.com/lllyasviel/Fooocus
        [ ! -d "./$term_sd_manager_info" ] && tmp_enable_proxy && term_sd_notice "检测到"$term_sd_manager_info"框架安装失败,已终止安装进程" && sleep 3 && return 1 #防止继续进行安装导致文件散落,造成目录混乱
        [ ! -d "./Fooocus/repositories" ] && mkdir ./Fooocus/repositories
        cmd_daemon git clone "$github_proxy"https://github.com/comfyanonymous/ComfyUI ./Fooocus/repositories/ComfyUI-from-StabilityAI-Official
        cd ./Fooocus
        create_venv
        enter_venv
        cd ..

        if [ ! -z "$(echo $pytorch_install_version | awk '{gsub(/[=+]/, "")}1')" ];then
            cmd_daemon pip_cmd install $pytorch_install_version $pip_index_mirror $pip_extra_index_mirror $pip_find_mirror $force_pip $pip_install_methon_select --prefer-binary --default-timeout=100 --retries 5
        fi
        cmd_daemon pip_cmd install -r ./Fooocus/requirements_versions.txt --prefer-binary $pip_index_mirror $pip_extra_index_mirror $pip_find_mirror $force_pip $pip_install_methon_select --default-timeout=100 --retries 5

        term_sd_notice "下载模型中"
        if [ $use_modelscope_model = 1 ];then #使用huggingface下载模型
            tmp_enable_proxy #恢复原有的代理,保证能从huggingface下载模型
            cmd_daemon aria2c $aria2_multi_threaded https://huggingface.co/stabilityai/stable-diffusion-xl-base-1.0/resolve/main/sd_xl_base_1.0_0.9vae.safetensors -d ./Fooocus/models/checkpoints/ -o sd_xl_base_1.0_0.9vae.safetensors
            cmd_daemon aria2c $aria2_multi_threaded https://huggingface.co/stabilityai/stable-diffusion-xl-refiner-1.0/resolve/main/sd_xl_refiner_1.0_0.9vae.safetensors -d ./Fooocus/models/checkpoints/ -o sd_xl_refiner_1.0_0.9vae.safetensor
            cmd_daemon aria2c $aria2_multi_threaded https://huggingface.co/stabilityai/stable-diffusion-xl-base-1.0/resolve/main/sd_xl_offset_example-lora_1.0.safetensors -d ./Fooocus/models/loras/ -o sd_xl_offset_example-lora_1.0.safetensors

            cmd_daemon aria2c $aria2_multi_threaded https://huggingface.co/licyk/fooocus-model/resolve/main/inpaint/inpaint.fooocus.patch -d ./Fooocus/models/inpaint/ -o inpaint.fooocus.patch
            cmd_daemon aria2c $aria2_multi_threaded https://huggingface.co/licyk/fooocus-model/resolve/main/inpaint/fooocus_inpaint_head.pth -d ./Fooocus/models/inpaint/ -o fooocus_inpaint_head.pth

            cmd_daemon aria2c $aria2_multi_threaded https://huggingface.co/licyk/fooocus-model/resolve/main/prompt_expansion/fooocus_expansion/pytorch_model.bin -d ./Fooocus/models/prompt_expansion/fooocus_expansion/ -o pytorch_model.bin
            cmd_daemon aria2c $aria2_multi_threaded https://huggingface.co/licyk/fooocus-model/resolve/main/prompt_expansion/fooocus_expansion/config.json -d ./Fooocus/models/prompt_expansion/fooocus_expansion/ -o config.json
            cmd_daemon aria2c $aria2_multi_threaded https://huggingface.co/licyk/fooocus-model/resolve/main/prompt_expansion/fooocus_expansion/merges.txt -d ./Fooocus/models/prompt_expansion/fooocus_expansion/ -o merges.txt
            cmd_daemon aria2c $aria2_multi_threaded https://huggingface.co/licyk/fooocus-model/resolve/main/prompt_expansion/fooocus_expansion/special_tokens_map.json -d ./Fooocus/models/prompt_expansion/fooocus_expansion/ -o special_tokens_map.json
            cmd_daemon aria2c $aria2_multi_threaded https://huggingface.co/licyk/fooocus-model/resolve/main/prompt_expansion/fooocus_expansion/tokenizer.json -d ./Fooocus/models/prompt_expansion/fooocus_expansion/ -o tokenizer.json
            cmd_daemon aria2c $aria2_multi_threaded https://huggingface.co/licyk/fooocus-model/resolve/main/prompt_expansion/fooocus_expansion/tokenizer_config.json -d ./Fooocus/models/prompt_expansion/fooocus_expansion/ -o tokenizer_config.json
            cmd_daemon aria2c $aria2_multi_threaded https://huggingface.co/licyk/fooocus-model/resolve/main/prompt_expansion/fooocus_expansion/vocab.json -d ./Fooocus/models/prompt_expansion/fooocus_expansion/ -o vocab.json

            cmd_daemon aria2c $aria2_multi_threaded https://huggingface.co/licyk/fooocus-model/resolve/main/upscale_models/fooocus_upscaler_s409985e5.bin -d ./Fooocus/models/upscale_models/ -o fooocus_upscaler_s409985e5.bin
            cmd_daemon aria2c $aria2_multi_threaded https://huggingface.co/licyk/fooocus-model/resolve/main/vae_approx/vaeapp_sd15.pth -d ./Fooocus/models/vae_approx -o vaeapp_sd15.pth
            cmd_daemon aria2c $aria2_multi_threaded https://huggingface.co/licyk/fooocus-model/resolve/main/vae_approx/xl-to-v1_interposer-v3.1.safetensors -d ./Fooocus/models/vae_approx -o xl-to-v1_interposer-v3.1.safetensors
            cmd_daemon aria2c $aria2_multi_threaded https://huggingface.co/licyk/fooocus-model/resolve/main/vae_approx/xlvaeapp.pth -d ./Fooocus/models/vae_approx -o xlvaeapp.pth
        else #使用modelscope下载模型
            get_modelscope_model licyks/sd-model/master/sdxl_1.0/sd_xl_base_1.0_0.9vae.safetensors ./Fooocus/models/checkpoints
            get_modelscope_model licyks/sd-model/master/sdxl_refiner_1.0/sd_xl_refiner_1.0_0.9vae.safetensors ./Fooocus/models/checkpoints
            get_modelscope_model licyks/fooocus-model/master/loras/sd_xl_offset_example-lora_1.0.safetensors ./Fooocus/models/loras

            get_modelscope_model licyks/fooocus-model/master/inpaint/fooocus_inpaint_head.pth ./Fooocus/models/inpaint
            get_modelscope_model licyks/fooocus-model/master/inpaint/fooocus_inpaint_head.pth ./Fooocus/models/inpaint

            get_modelscope_model licyks/fooocus-model/master/prompt_expansion/fooocus_expansion/pytorch_model.bin ./Fooocus/models/prompt_expansion/fooocus_expansion
            get_modelscope_model licyks/fooocus-model/master/prompt_expansion/fooocus_expansion/config.json ./Fooocus/models/prompt_expansion/fooocus_expansion
            get_modelscope_model licyks/fooocus-model/master/prompt_expansion/fooocus_expansion/merges.txt ./Fooocus/models/prompt_expansion/fooocus_expansion
            get_modelscope_model licyks/fooocus-model/master/prompt_expansion/fooocus_expansion/special_tokens_map.json ./Fooocus/models/prompt_expansion/fooocus_expansion
            get_modelscope_model licyks/fooocus-model/master/prompt_expansion/fooocus_expansion/tokenizer.json ./Fooocus/models/prompt_expansion/fooocus_expansion
            get_modelscope_model licyks/fooocus-model/master/prompt_expansion/fooocus_expansion/tokenizer_config.json ./Fooocus/models/prompt_expansion/fooocus_expansion
            get_modelscope_model licyks/fooocus-model/master/prompt_expansion/fooocus_expansion/vocab.json ./Fooocus/models/prompt_expansion/fooocus_expansion

            get_modelscope_model licyks/fooocus-model/master/upscale_models/fooocus_upscaler_s409985e5.bin ./Fooocus/models/upscale_models
            get_modelscope_model licyks/fooocus-model/master/vae_approx/vaeapp_sd15.pth ./Fooocus/models/vae_approx
            get_modelscope_model licyks/fooocus-model/master/vae_approx/xl-to-v1_interposer-v3.1.safetensors ./Fooocus/models/vae_approx
            get_modelscope_model licyks/fooocus-model/master/vae_approx/xlvaeapp.pth./Fooocus/models/vae_approx
            tmp_enable_proxy #恢复原有的代理
        fi

        term_sd_notice "安装结束"
        exit_venv
        print_line_to_shell
        fooocus_option
    fi
}