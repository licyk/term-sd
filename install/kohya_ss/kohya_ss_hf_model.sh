__term_sd_task_sys term_sd_echo "下载模型中"
__term_sd_task_sys term_sd_echo "使用huggingface模型下载源"
__term_sd_task_sys term_sd_tmp_enable_proxy
__term_sd_task_pre_model aria2_download https://huggingface.co/runwayml/stable-diffusion-v1-5/resolve/main/v1-5-pruned-emaonly.safetensors ./kohya_ss/models/ v1-5-pruned-emaonly.safetensors
__term_sd_task_pre_model aria2_download https://huggingface.co/stabilityai/sd-vae-ft-mse-original/resolve/main/vae-ft-mse-840000-ema-pruned.safetensors ./kohya_ss/models/ vae-ft-mse-840000-ema-pruned.safetensors
__term_sd_task_pre_model aria2_download https://huggingface.co/stabilityai/sd-vae-ft-ema-original/resolve/main/vae-ft-ema-560000-ema-pruned.safetensors ./kohya_ss/models/ vae-ft-ema-560000-ema-pruned.safetensors
