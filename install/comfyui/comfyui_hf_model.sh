__term_sd_task_sys term_sd_echo "下载模型中"
__term_sd_task_sys term_sd_echo "使用huggingface模型下载源"
__term_sd_task_sys term_sd_tmp_enable_proxy
__term_sd_task_pre_model aria2_download https://huggingface.co/runwayml/stable-diffusion-v1-5/resolve/main/v1-5-pruned-emaonly.safetensors "$comfyui_folder"/models/checkpoints v1-5-pruned-emaonly.safetensors
__term_sd_task_pre_model aria2_download https://huggingface.co/stabilityai/sd-vae-ft-mse-original/resolve/main/vae-ft-mse-840000-ema-pruned.safetensors "$comfyui_folder"/models/vae vae-ft-mse-840000-ema-pruned.safetensors
__term_sd_task_pre_model aria2_download https://huggingface.co/stabilityai/sd-vae-ft-ema-original/resolve/main/vae-ft-ema-560000-ema-pruned.safetensors "$comfyui_folder"/models/vae vae-ft-ema-560000-ema-pruned.safetensors
__term_sd_task_pre_model aria2_download https://huggingface.co/licyk/sd-vae/resolve/main/vae-approx/model.pt "$comfyui_folder"/models/vae_approx model.pt # VAE-approx模型
__term_sd_task_pre_model aria2_download https://huggingface.co/licyk/sd-vae/resolve/main/vae-approx/vaeapprox-sdxl.pt "$comfyui_folder"/models/vae_approx vaeapprox-sdxl.pt
__term_sd_task_pre_model aria2_download https://huggingface.co/licyk/sd-upscaler-models/resolve/main/ESRGAN/4x-UltraSharp.pth "$comfyui_folder"/models/upscale_models 4x-UltraSharp.pth # upscaler模型
__term_sd_task_pre_model aria2_download https://huggingface.co/licyk/sd-upscaler-models/resolve/main/ESRGAN/BSRGAN.pth "$comfyui_folder"/models/upscale_models BSRGAN.pth
__term_sd_task_pre_model aria2_download https://huggingface.co/licyk/sd-upscaler-models/resolve/main/ESRGAN/ESRGAN_4x.pth "$comfyui_folder"/models/upscale_models ESRGAN_4x.pth
__term_sd_task_pre_model aria2_download https://huggingface.co/licyk/sd-upscaler-models/resolve/main/GFPGAN/GFPGANv1.4.pth "$comfyui_folder"/models/upscale_models GFPGANv1.4.pth
__term_sd_task_pre_model aria2_download https://huggingface.co/licyk/sd-upscaler-models/resolve/main/GFPGAN/detection_Resnet50_Final.pth "$comfyui_folder"/models/upscale_models detection_Resnet50_Final.pth
__term_sd_task_pre_model aria2_download https://huggingface.co/licyk/sd-upscaler-models/resolve/main/GFPGAN/parsing_bisenet.pth "$comfyui_folder"/models/upscale_models parsing_bisenet.pth
__term_sd_task_pre_model aria2_download https://huggingface.co/licyk/sd-upscaler-models/resolve/main/GFPGAN/parsing_parsenet.pth "$comfyui_folder"/models/upscale_models parsing_parsenet.pth
__term_sd_task_pre_model aria2_download https://huggingface.co/licyk/sd-upscaler-models/resolve/main/RealESRGAN/RealESRGAN_x4plus.pth "$comfyui_folder"/models/upscale_models RealESRGAN_x4plus.pth
__term_sd_task_pre_model aria2_download https://huggingface.co/licyk/sd-upscaler-models/resolve/main/RealESRGAN/RealESRGAN_x4plus_anime_6B.pth "$comfyui_folder"/models/upscale_models RealESRGAN_x4plus_anime_6B.pth
__term_sd_task_pre_model aria2_download https://huggingface.co/licyk/sd-upscaler-models/resolve/main/ESRGAN/4x_NMKD-Superscale-Artisoftject_210000_G.pth "$comfyui_folder"/models/upscale_models 4x_NMKD-Superscale-Artisoftject_210000_G.pth
__term_sd_task_pre_model aria2_download https://huggingface.co/licyk/sd-upscaler-models/resolve/main/ESRGAN/4x_NMKD-Superscale-SP_178000_G.pth "$comfyui_folder"/models/upscale_models 4x_NMKD-Superscale-SP_178000_G.pth
__term_sd_task_pre_model aria2_download https://huggingface.co/licyk/sd-upscaler-models/resolve/main/ESRGAN/8x_NMKD-Superscale_150000_G.pth "$comfyui_folder"/models/upscale_models 8x_NMKD-Superscale_150000_G.pth
__term_sd_task_pre_model aria2_download https://huggingface.co/licyk/sd-embeddings/resolve/main/sd_1.5/EasyNegativeV2.safetensors "$comfyui_folder"/models/embeddings/negative EasyNegativeV2.safetensors # embeddings模型
__term_sd_task_pre_model aria2_download https://huggingface.co/licyk/sd-embeddings/resolve/main/sd_1.5/bad-artist-anime.pt "$comfyui_folder"/models/embeddings/negative bad-artist-anime.pt
__term_sd_task_pre_model aria2_download https://huggingface.co/licyk/sd-embeddings/resolve/main/sd_1.5/bad-artist.pt "$comfyui_folder"/models/embeddings/negative bad-artist.pt
__term_sd_task_pre_model aria2_download https://huggingface.co/licyk/sd-embeddings/resolve/main/sd_1.5/bad-hands-5.pt "$comfyui_folder"/models/embeddings/negative bad-hands-5.pt
__term_sd_task_pre_model aria2_download https://huggingface.co/licyk/sd-embeddings/resolve/main/sd_1.5/bad-image-v2-39000.pt "$comfyui_folder"/models/embeddings/negative bad-image-v2-39000.pt
__term_sd_task_pre_model aria2_download https://huggingface.co/licyk/sd-embeddings/resolve/main/sd_1.5/bad_prompt_version2.pt "$comfyui_folder"/models/embeddings/negative bad_prompt_version2.pt
__term_sd_task_pre_model aria2_download https://huggingface.co/licyk/sd-embeddings/resolve/main/sd_1.5/ng_deepnegative_v1_75t.pt "$comfyui_folder"/models/embeddings/negative ng_deepnegative_v1_75t.pt
__term_sd_task_pre_model aria2_download https://huggingface.co/licyk/sd-embeddings/resolve/main/sd_1.5/verybadimagenegative_v1.3.pt "$comfyui_folder"/models/embeddings/negative verybadimagenegative_v1.3.pt
