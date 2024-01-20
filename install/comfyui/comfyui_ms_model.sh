__term_sd_task_sys term_sd_echo "下载模型中"
__term_sd_task_sys term_sd_echo "使用modelscope模型下载源"
__term_sd_task_pre_model get_modelscope_model licyks/sd-model/master/sd_1.5/v1-5-pruned-emaonly.safetensors "$comfyui_path"/models/checkpoints
__term_sd_task_pre_model get_modelscope_model licyks/sd-vae/master/sd_1.5/vae-ft-ema-560000-ema-pruned.safetensors "$comfyui_path"/models/vae
__term_sd_task_pre_model get_modelscope_model licyks/sd-vae/master/sd_1.5/vae-ft-mse-840000-ema-pruned.safetensors "$comfyui_path"/models/vae
__term_sd_task_pre_model get_modelscope_model licyks/sd-vae/master/vae-approx/model.pt "$comfyui_path"/models/VAE-approx # VAE-approx模型
__term_sd_task_pre_model get_modelscope_model licyks/sd-vae/master/vae-approx/vaeapprox-sdxl.pt "$comfyui_path"/models/VAE-approx
__term_sd_task_pre_model get_modelscope_model licyks/sd-upscaler-models/master/ESRGAN/4x-UltraSharp.pth "$comfyui_path"/models/upscale_models # upscaler模型
__term_sd_task_pre_model get_modelscope_model licyks/sd-upscaler-models/master/ESRGAN/BSRGAN.pth "$comfyui_path"/models/upscale_models
__term_sd_task_pre_model get_modelscope_model licyks/sd-upscaler-models/master/ESRGAN/ESRGAN_4x.pth "$comfyui_path"/models/upscale_models
__term_sd_task_pre_model get_modelscope_model licyks/sd-upscaler-models/master/GFPGAN/detection_Resnet50_Final.pth "$comfyui_path"/models/upscale_models
__term_sd_task_pre_model get_modelscope_model licyks/sd-upscaler-models/master/GFPGAN/GFPGANv1.4.pth "$comfyui_path"/models/upscale_models
__term_sd_task_pre_model get_modelscope_model licyks/sd-upscaler-models/master/GFPGAN/parsing_bisenet.pth "$comfyui_path"/models/upscale_models
__term_sd_task_pre_model get_modelscope_model licyks/sd-upscaler-models/master/GFPGAN/parsing_parsenet.pth "$comfyui_path"/models/upscale_models
__term_sd_task_pre_model get_modelscope_model licyks/sd-upscaler-models/master/RealESRGAN/RealESRGAN_x4plus.pth "$comfyui_path"/models/upscale_models
__term_sd_task_pre_model get_modelscope_model licyks/sd-upscaler-models/master/RealESRGAN/RealESRGAN_x4plus_anime_6B.pth "$comfyui_path"/models/upscale_models
__term_sd_task_pre_model get_modelscope_model licyks/sd-upscaler-models/master/ESRGAN/4x_NMKD-Superscale-Artisoftject_210000_G.pth "$comfyui_path"/models/upscale_models
__term_sd_task_pre_model get_modelscope_model licyks/sd-upscaler-models/master/ESRGAN/4x_NMKD-Superscale-SP_178000_G.pth "$comfyui_path"/models/upscale_models
__term_sd_task_pre_model get_modelscope_model licyks/sd-upscaler-models/master/ESRGAN/8x_NMKD-Superscale_150000_G.pth "$comfyui_path"/models/upscale_models
__term_sd_task_pre_model get_modelscope_model licyks/sd-embeddings/master/sd_1.5/EasyNegativeV2.safetensors "$comfyui_path"/models/embeddings/negative # embeddings模型
__term_sd_task_pre_model get_modelscope_model licyks/sd-embeddings/master/sd_1.5/bad-artist-anime.pt "$comfyui_path"/models/embeddings/negative
__term_sd_task_pre_model get_modelscope_model licyks/sd-embeddings/master/sd_1.5/bad-artist.pt "$comfyui_path"/models/embeddings/negative
__term_sd_task_pre_model get_modelscope_model licyks/sd-embeddings/master/sd_1.5/bad-hands-5.pt "$comfyui_path"/models/embeddings/negative
__term_sd_task_pre_model get_modelscope_model licyks/sd-embeddings/master/sd_1.5/bad-image-v2-39000.pt "$comfyui_path"/models/embeddings/negative
__term_sd_task_pre_model get_modelscope_model licyks/sd-embeddings/master/sd_1.5/bad_prompt_version2.pt "$comfyui_path"/models/embeddings/negative
__term_sd_task_pre_model get_modelscope_model licyks/sd-embeddings/master/sd_1.5/ng_deepnegative_v1_75t.pt "$comfyui_path"/models/embeddings/negative
__term_sd_task_pre_model get_modelscope_model licyks/sd-embeddings/master/sd_1.5/verybadimagenegative_v1.3.pt "$comfyui_path"/models/embeddings/negative
