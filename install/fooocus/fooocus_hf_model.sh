__term_sd_task_sys term_sd_echo "下载模型中"
__term_sd_task_sys term_sd_echo "使用huggingface模型下载源"
__term_sd_task_sys term_sd_tmp_enable_proxy
__term_sd_task_pre_model aria2_download https://huggingface.co/stabilityai/stable-diffusion-xl-base-1.0/resolve/main/sd_xl_base_1.0_0.9vae.safetensors ./Fooocus/models/checkpoints/ sd_xl_base_1.0_0.9vae.safetensors
__term_sd_task_pre_model aria2_download https://huggingface.co/stabilityai/stable-diffusion-xl-refiner-1.0/resolve/main/sd_xl_refiner_1.0_0.9vae.safetensors ./Fooocus/models/checkpoints/ sd_xl_refiner_1.0_0.9vae.safetensor
__term_sd_task_pre_model aria2_download https://huggingface.co/stabilityai/stable-diffusion-xl-base-1.0/resolve/main/sd_xl_offset_example-lora_1.0.safetensors ./Fooocus/models/loras/ sd_xl_offset_example-lora_1.0.safetensors
__term_sd_task_pre_model aria2_download https://huggingface.co/licyk/fooocus-model/resolve/main/inpaint/inpaint.fooocus.patch ./Fooocus/models/inpaint/ inpaint.fooocus.patch
__term_sd_task_pre_model aria2_download https://huggingface.co/licyk/fooocus-model/resolve/main/inpaint/fooocus_inpaint_head.pth ./Fooocus/models/inpaint/ fooocus_inpaint_head.pth
__term_sd_task_pre_model aria2_download https://huggingface.co/licyk/fooocus-model/resolve/main/prompt_expansion/fooocus_expansion/pytorch_model.bin ./Fooocus/models/prompt_expansion/fooocus_expansion/ pytorch_model.bin
__term_sd_task_pre_model aria2_download https://huggingface.co/licyk/fooocus-model/resolve/main/prompt_expansion/fooocus_expansion/config.json ./Fooocus/models/prompt_expansion/fooocus_expansion/ config.json
__term_sd_task_pre_model aria2_download https://huggingface.co/licyk/fooocus-model/resolve/main/prompt_expansion/fooocus_expansion/merges.txt ./Fooocus/models/prompt_expansion/fooocus_expansion/ merges.txt
__term_sd_task_pre_model aria2_download https://huggingface.co/licyk/fooocus-model/resolve/main/prompt_expansion/fooocus_expansion/special_tokens_map.json ./Fooocus/models/prompt_expansion/fooocus_expansion/ special_tokens_map.json
__term_sd_task_pre_model aria2_download https://huggingface.co/licyk/fooocus-model/resolve/main/prompt_expansion/fooocus_expansion/tokenizer.json ./Fooocus/models/prompt_expansion/fooocus_expansion/ tokenizer.json
__term_sd_task_pre_model aria2_download https://huggingface.co/licyk/fooocus-model/resolve/main/prompt_expansion/fooocus_expansion/tokenizer_config.json ./Fooocus/models/prompt_expansion/fooocus_expansion/ tokenizer_config.json
__term_sd_task_pre_model aria2_download https://huggingface.co/licyk/fooocus-model/resolve/main/prompt_expansion/fooocus_expansion/vocab.json ./Fooocus/models/prompt_expansion/fooocus_expansion/ vocab.json
__term_sd_task_pre_model aria2_download https://huggingface.co/licyk/fooocus-model/resolve/main/upscale_models/fooocus_upscaler_s409985e5.bin ./Fooocus/models/upscale_models/ fooocus_upscaler_s409985e5.bin
__term_sd_task_pre_model aria2_download https://huggingface.co/licyk/fooocus-model/resolve/main/vae_approx/vaeapp_sd15.pth ./Fooocus/models/vae_approx vaeapp_sd15.pth
__term_sd_task_pre_model aria2_download https://huggingface.co/licyk/fooocus-model/resolve/main/vae_approx/xl-to-v1_interposer-v3.1.safetensors ./Fooocus/models/vae_approx xl-to-v1_interposer-v3.1.safetensors
__term_sd_task_pre_model aria2_download https://huggingface.co/licyk/fooocus-model/resolve/main/vae_approx/xlvaeapp.pth ./Fooocus/models/vae_approx xlvaeapp.pth
__term_sd_task_pre_model aria2_download https://huggingface.co/licyk/fooocus-model/resolve/main/loras/sdxl_lcm_lora.safetensors ./Fooocus/models/loras/ sdxl_lcm_lora.safetensors
__term_sd_task_pre_model aria2_download https://huggingface.co/licyk/fooocus-model/resolve/main/controlnet/control-lora-canny-rank128.safetensors ./Fooocus/models/controlnet control-lora-canny-rank128.safetensors
__term_sd_task_pre_model aria2_download https://huggingface.co/licyk/fooocus-model/resolve/main/controlnet/fooocus_ip_negative.safetensors ./Fooocus/models/controlnet fooocus_ip_negative.safetensors
__term_sd_task_pre_model aria2_download https://huggingface.co/licyk/fooocus-model/resolve/main/controlnet/fooocus_xl_cpds_128.safetensors ./Fooocus/models/controlnet fooocus_xl_cpds_128.safetensors
__term_sd_task_pre_model aria2_download https://huggingface.co/licyk/fooocus-model/resolve/main/controlnet/ip-adapter-plus_sdxl_vit-h.bin ./Fooocus/models/controlnet ip-adapter-plus_sdxl_vit-h.bin
__term_sd_task_pre_model aria2_download https://huggingface.co/licyk/fooocus-model/resolve/main/controlnet/detection_Resnet50_Final.pth ./Fooocus/models/controlnet detection_Resnet50_Final.pth
__term_sd_task_pre_model aria2_download https://huggingface.co/licyk/fooocus-model/resolve/main/controlnet/ip-adapter-plus-face_sdxl_vit-h.bin ./Fooocus/models/controlnet ip-adapter-plus-face_sdxl_vit-h.bin
__term_sd_task_pre_model aria2_download https://huggingface.co/licyk/fooocus-model/resolve/main/controlnet/parsing_parsenet.pth ./Fooocus/models/controlnet parsing_parsenet.pth
