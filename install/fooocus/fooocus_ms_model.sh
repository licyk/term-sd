__term_sd_task_sys term_sd_echo "下载模型中"
__term_sd_task_sys term_sd_echo "使用modelscope模型下载源"
__term_sd_task_pre_model get_modelscope_model licyks/sd-model/master/sdxl_1.0/sd_xl_base_1.0_0.9vae.safetensors ./Fooocus/models/checkpoints
__term_sd_task_pre_model get_modelscope_model licyks/sd-model/master/sdxl_refiner_1.0/sd_xl_refiner_1.0_0.9vae.safetensors ./Fooocus/models/checkpoints
__term_sd_task_pre_model get_modelscope_model licyks/fooocus-model/master/loras/sd_xl_offset_example-lora_1.0.safetensors ./Fooocus/models/loras
__term_sd_task_pre_model get_modelscope_model licyks/fooocus-model/master/inpaint/fooocus_inpaint_head.pth ./Fooocus/models/inpaint
__term_sd_task_pre_model get_modelscope_model licyks/fooocus-model/master/inpaint/fooocus_inpaint_head.pth ./Fooocus/models/inpaint
__term_sd_task_pre_model get_modelscope_model licyks/fooocus-model/master/prompt_expansion/fooocus_expansion/pytorch_model.bin ./Fooocus/models/prompt_expansion/fooocus_expansion
__term_sd_task_pre_model get_modelscope_model licyks/fooocus-model/master/prompt_expansion/fooocus_expansion/config.json ./Fooocus/models/prompt_expansion/fooocus_expansion
__term_sd_task_pre_model get_modelscope_model licyks/fooocus-model/master/prompt_expansion/fooocus_expansion/merges.txt ./Fooocus/models/prompt_expansion/fooocus_expansion
__term_sd_task_pre_model get_modelscope_model licyks/fooocus-model/master/prompt_expansion/fooocus_expansion/special_tokens_map.json ./Fooocus/models/prompt_expansion/fooocus_expansion
__term_sd_task_pre_model get_modelscope_model licyks/fooocus-model/master/prompt_expansion/fooocus_expansion/tokenizer.json ./Fooocus/models/prompt_expansion/fooocus_expansion
__term_sd_task_pre_model get_modelscope_model licyks/fooocus-model/master/prompt_expansion/fooocus_expansion/tokenizer_config.json ./Fooocus/models/prompt_expansion/fooocus_expansion
__term_sd_task_pre_model get_modelscope_model licyks/fooocus-model/master/prompt_expansion/fooocus_expansion/vocab.json ./Fooocus/models/prompt_expansion/fooocus_expansion
__term_sd_task_pre_model get_modelscope_model licyks/fooocus-model/master/upscale_models/fooocus_upscaler_s409985e5.bin ./Fooocus/models/upscale_models
__term_sd_task_pre_model get_modelscope_model licyks/fooocus-model/master/vae_approx/vaeapp_sd15.pth ./Fooocus/models/vae_approx
__term_sd_task_pre_model get_modelscope_model licyks/fooocus-model/master/vae_approx/xl-to-v1_interposer-v3.1.safetensors ./Fooocus/models/vae_approx
__term_sd_task_pre_model get_modelscope_model licyks/fooocus-model/master/vae_approx/xlvaeapp.pth ./Fooocus/models/vae_approx
__term_sd_task_pre_model get_modelscope_model licyks/fooocus-model/master/loras/sdxl_lcm_lora.safetensors ./Fooocus/models/loras
__term_sd_task_pre_model get_modelscope_model licyks/fooocus-model/master/controlnet/control-lora-canny-rank128.safetensors ./Fooocus/models/controlnet
__term_sd_task_pre_model get_modelscope_model licyks/fooocus-model/master/controlnet/fooocus_ip_negative.safetensors ./Fooocus/models/controlnet
__term_sd_task_pre_model get_modelscope_model licyks/fooocus-model/master/controlnet/fooocus_xl_cpds_128.safetensors ./Fooocus/models/controlnet
__term_sd_task_pre_model get_modelscope_model licyks/fooocus-model/master/controlnet/ip-adapter-plus_sdxl_vit-h.bin ./Fooocus/models/controlnet
__term_sd_task_pre_model get_modelscope_model licyks/fooocus-model/master/controlnet/detection_Resnet50_Final.pth ./Fooocus/models/controlnet
__term_sd_task_pre_model get_modelscope_model licyks/fooocus-model/master/controlnet/ip-adapter-plus-face_sdxl_vit-h.bin ./Fooocus/models/controlnet
__term_sd_task_pre_model get_modelscope_model licyks/fooocus-model/master/controlnet/parsing_parsenet.pth ./Fooocus/models/controlnet