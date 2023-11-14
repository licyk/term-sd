__term_sd_task_sys term_sd_echo "下载模型中"
__term_sd_task_sys term_sd_echo "使用huggingface模型下载源"
__term_sd_task_sys term_sd_tmp_enable_proxy
__term_sd_task_pre_model aria2_download https://huggingface.co/stabilityai/stable-diffusion-xl-base-1.0/resolve/main/sd_xl_base_1.0_0.9vae.safetensors -d ./Fooocus/models/checkpoints/ -o sd_xl_base_1.0_0.9vae.safetensors
__term_sd_task_pre_model aria2_download https://huggingface.co/stabilityai/stable-diffusion-xl-refiner-1.0/resolve/main/sd_xl_refiner_1.0_0.9vae.safetensors -d ./Fooocus/models/checkpoints/ -o sd_xl_refiner_1.0_0.9vae.safetensor
__term_sd_task_pre_model aria2_download https://huggingface.co/stabilityai/stable-diffusion-xl-base-1.0/resolve/main/sd_xl_offset_example-lora_1.0.safetensors -d ./Fooocus/models/loras/ -o sd_xl_offset_example-lora_1.0.safetensors
__term_sd_task_pre_model aria2_download https://huggingface.co/licyk/fooocus-model/resolve/main/inpaint/inpaint.fooocus.patch -d ./Fooocus/models/inpaint/ -o inpaint.fooocus.patch
__term_sd_task_pre_model aria2_download https://huggingface.co/licyk/fooocus-model/resolve/main/inpaint/fooocus_inpaint_head.pth -d ./Fooocus/models/inpaint/ -o fooocus_inpaint_head.pth
__term_sd_task_pre_model aria2_download https://huggingface.co/licyk/fooocus-model/resolve/main/prompt_expansion/fooocus_expansion/pytorch_model.bin -d ./Fooocus/models/prompt_expansion/fooocus_expansion/ -o pytorch_model.bin
__term_sd_task_pre_model aria2_download https://huggingface.co/licyk/fooocus-model/resolve/main/prompt_expansion/fooocus_expansion/config.json -d ./Fooocus/models/prompt_expansion/fooocus_expansion/ -o config.json
__term_sd_task_pre_model aria2_download https://huggingface.co/licyk/fooocus-model/resolve/main/prompt_expansion/fooocus_expansion/merges.txt -d ./Fooocus/models/prompt_expansion/fooocus_expansion/ -o merges.txt
__term_sd_task_pre_model aria2_download https://huggingface.co/licyk/fooocus-model/resolve/main/prompt_expansion/fooocus_expansion/special_tokens_map.json -d ./Fooocus/models/prompt_expansion/fooocus_expansion/ -o special_tokens_map.json
__term_sd_task_pre_model aria2_download https://huggingface.co/licyk/fooocus-model/resolve/main/prompt_expansion/fooocus_expansion/tokenizer.json -d ./Fooocus/models/prompt_expansion/fooocus_expansion/ -o tokenizer.json
__term_sd_task_pre_model aria2_download https://huggingface.co/licyk/fooocus-model/resolve/main/prompt_expansion/fooocus_expansion/tokenizer_config.json -d ./Fooocus/models/prompt_expansion/fooocus_expansion/ -o tokenizer_config.json
__term_sd_task_pre_model aria2_download https://huggingface.co/licyk/fooocus-model/resolve/main/prompt_expansion/fooocus_expansion/vocab.json -d ./Fooocus/models/prompt_expansion/fooocus_expansion/ -o vocab.json
__term_sd_task_pre_model aria2_download https://huggingface.co/licyk/fooocus-model/resolve/main/upscale_models/fooocus_upscaler_s409985e5.bin -d ./Fooocus/models/upscale_models/ -o fooocus_upscaler_s409985e5.bin
__term_sd_task_pre_model aria2_download https://huggingface.co/licyk/fooocus-model/resolve/main/vae_approx/vaeapp_sd15.pth -d ./Fooocus/models/vae_approx -o vaeapp_sd15.pth
__term_sd_task_pre_model aria2_download https://huggingface.co/licyk/fooocus-model/resolve/main/vae_approx/xl-to-v1_interposer-v3.1.safetensors -d ./Fooocus/models/vae_approx -o xl-to-v1_interposer-v3.1.safetensors
__term_sd_task_pre_model aria2_download https://huggingface.co/licyk/fooocus-model/resolve/main/vae_approx/xlvaeapp.pth -d ./Fooocus/models/vae_approx -o xlvaeapp.pth