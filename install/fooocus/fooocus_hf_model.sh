__term_sd_task_sys term_sd_echo "下载模型中"
__term_sd_task_sys term_sd_echo "使用huggingface模型下载源"
__term_sd_task_sys term_sd_tmp_enable_proxy
__term_sd_task_pre_model aria2_download https://huggingface.co/stabilityai/stable-diffusion-xl-base-1.0/resolve/main/sd_xl_base_1.0_0.9vae.safetensors "$fooocus_path"/models/checkpoints
__term_sd_task_pre_model aria2_download https://huggingface.co/stabilityai/stable-diffusion-xl-refiner-1.0/resolve/main/sd_xl_refiner_1.0_0.9vae.safetensors "$fooocus_path"/models/checkpoints
__term_sd_task_pre_model aria2_download https://huggingface.co/stabilityai/stable-diffusion-xl-base-1.0/resolve/main/sd_xl_offset_example-lora_1.0.safetensors "$fooocus_path"/models/loras
__term_sd_task_pre_model aria2_download https://huggingface.co/licyk/fooocus-model/resolve/main/inpaint/inpaint.fooocus.patch "$fooocus_path"/models/inpaint
__term_sd_task_pre_model aria2_download https://huggingface.co/licyk/fooocus-model/resolve/main/inpaint/fooocus_inpaint_head.pth "$fooocus_path"/models/inpaint
__term_sd_task_pre_model aria2_download https://huggingface.co/licyk/fooocus-model/resolve/main/prompt_expansion/fooocus_expansion/pytorch_model.bin "$fooocus_path"/models/prompt_expansion/fooocus_expansion
__term_sd_task_pre_model aria2_download https://huggingface.co/licyk/fooocus-model/resolve/main/prompt_expansion/fooocus_expansion/config.json "$fooocus_path"/models/prompt_expansion/fooocus_expansion
__term_sd_task_pre_model aria2_download https://huggingface.co/licyk/fooocus-model/resolve/main/prompt_expansion/fooocus_expansion/merges.txt "$fooocus_path"/models/prompt_expansion/fooocus_expansion
__term_sd_task_pre_model aria2_download https://huggingface.co/licyk/fooocus-model/resolve/main/prompt_expansion/fooocus_expansion/special_tokens_map.json "$fooocus_path"/models/prompt_expansion/fooocus_expansion
__term_sd_task_pre_model aria2_download https://huggingface.co/licyk/fooocus-model/resolve/main/prompt_expansion/fooocus_expansion/tokenizer.json "$fooocus_path"/models/prompt_expansion/fooocus_expansion
__term_sd_task_pre_model aria2_download https://huggingface.co/licyk/fooocus-model/resolve/main/prompt_expansion/fooocus_expansion/tokenizer_config.json "$fooocus_path"/models/prompt_expansion/fooocus_expansion
__term_sd_task_pre_model aria2_download https://huggingface.co/licyk/fooocus-model/resolve/main/prompt_expansion/fooocus_expansion/vocab.json "$fooocus_path"/models/prompt_expansion/fooocus_expansion
__term_sd_task_pre_model aria2_download https://huggingface.co/licyk/fooocus-model/resolve/main/upscale_models/fooocus_upscaler_s409985e5.bin "$fooocus_path"/models/upscale_models
__term_sd_task_pre_model aria2_download https://huggingface.co/licyk/fooocus-model/resolve/main/vae_approx/vaeapp_sd15.pth "$fooocus_path"/models/vae_approx
__term_sd_task_pre_model aria2_download https://huggingface.co/licyk/fooocus-model/resolve/main/vae_approx/xl-to-v1_interposer-v3.1.safetensors "$fooocus_path"/models/vae_approx
__term_sd_task_pre_model aria2_download https://huggingface.co/licyk/fooocus-model/resolve/main/vae_approx/xlvaeapp.pth "$fooocus_path"/models/vae_approx
__term_sd_task_pre_model aria2_download https://huggingface.co/licyk/fooocus-model/resolve/main/loras/sdxl_lcm_lora.safetensors "$fooocus_path"/models/loras
__term_sd_task_pre_model aria2_download https://huggingface.co/licyk/fooocus-model/resolve/main/controlnet/control-lora-canny-rank128.safetensors "$fooocus_path"/models/controlnet
__term_sd_task_pre_model aria2_download https://huggingface.co/licyk/fooocus-model/resolve/main/controlnet/fooocus_ip_negative.safetensors "$fooocus_path"/models/controlnet
__term_sd_task_pre_model aria2_download https://huggingface.co/licyk/fooocus-model/resolve/main/controlnet/fooocus_xl_cpds_128.safetensors "$fooocus_path"/models/controlnet
__term_sd_task_pre_model aria2_download https://huggingface.co/licyk/fooocus-model/resolve/main/controlnet/ip-adapter-plus_sdxl_vit-h.bin "$fooocus_path"/models/controlnet
__term_sd_task_pre_model aria2_download https://huggingface.co/licyk/fooocus-model/resolve/main/controlnet/detection_Resnet50_Final.pth "$fooocus_path"/models/controlnet
__term_sd_task_pre_model aria2_download https://huggingface.co/licyk/fooocus-model/resolve/main/controlnet/ip-adapter-plus-face_sdxl_vit-h.bin "$fooocus_path"/models/controlnet
__term_sd_task_pre_model aria2_download https://huggingface.co/licyk/fooocus-model/resolve/main/controlnet/parsing_parsenet.pth "$fooocus_path"/models/controlnet
