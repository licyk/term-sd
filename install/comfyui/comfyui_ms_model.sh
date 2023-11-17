__term_sd_task_sys term_sd_echo "下载模型中"
__term_sd_task_sys term_sd_echo "使用modelscope模型下载源"
__term_sd_task_pre_model get_modelscope_model licyks/sd-model/master/sd_1.5/v1-5-pruned-emaonly.safetensors ./ComfyUI/models/checkpoints
__term_sd_task_pre_model get_modelscope_model licyks/sd-vae/master/sd_1.5/vae-ft-ema-560000-ema-pruned.safetensors ./ComfyUI/models/vae
__term_sd_task_pre_model get_modelscope_model licyks/sd-vae/master/sd_1.5/vae-ft-mse-840000-ema-pruned.safetensors ./ComfyUI/models/vae
