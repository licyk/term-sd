__term_sd_task_sys term_sd_echo "下载模型中"
__term_sd_task_sys term_sd_echo "使用huggingface模型下载源"
__term_sd_task_sys term_sd_tmp_enable_proxy
__term_sd_task_pre_model aria2_download https://huggingface.co/runwayml/stable-diffusion-v1-5/resolve/main/v1-5-pruned-emaonly.safetensors ./ComfyUI/models/checkpoints/ sd-v1-5.safetensors
__term_sd_task_pre_model aria2_download https://huggingface.co/stabilityai/sd-vae-ft-mse-original/resolve/main/vae-ft-mse-840000-ema-pruned.safetensors ./ComfyUI/models/vae vae-ft-mse-840000-ema-pruned.safetensors
__term_sd_task_pre_model aria2_download https://huggingface.co/stabilityai/sd-vae-ft-ema-original/resolve/main/vae-ft-ema-560000-ema-pruned.safetensors ./ComfyUI/models/vae vae-ft-ema-560000-ema-pruned.safetensors
__term_sd_task_pre_model aria2_download https://huggingface.co/licyk/sd-vae/resolve/main/vae-approx/model.pt ./ComfyUI/models/vae_approx model.pt # VAE-approx模型
__term_sd_task_pre_model aria2_download https://huggingface.co/licyk/sd-vae/resolve/main/vae-approx/vaeapprox-sdxl.pt ./ComfyUI/models/vae_approx vaeapprox-sdxl.pt
__term_sd_task_pre_model aria2_download https://huggingface.co/licyk/sd-upscaler-models/resolve/main/ESRGAN/4x-UltraSharp.pth ./ComfyUI/models/upscale_models 4x-UltraSharp.pth # upscaler模型
__term_sd_task_pre_model aria2_download https://huggingface.co/licyk/sd-upscaler-models/resolve/main/ESRGAN/BSRGAN.pth ./ComfyUI/models/upscale_models BSRGAN.pth
__term_sd_task_pre_model aria2_download https://huggingface.co/licyk/sd-upscaler-models/resolve/main/ESRGAN/ESRGAN_4x.pth ./ComfyUI/models/upscale_models ESRGAN_4x.pth
__term_sd_task_pre_model aria2_download https://huggingface.co/licyk/sd-upscaler-models/resolve/main/GFPGAN/GFPGANv1.4.pth ./ComfyUI/models/upscale_models GFPGANv1.4.pth
__term_sd_task_pre_model aria2_download https://huggingface.co/licyk/sd-upscaler-models/resolve/main/GFPGAN/detection_Resnet50_Final.pth ./ComfyUI/models/upscale_models detection_Resnet50_Final.pth
__term_sd_task_pre_model aria2_download https://huggingface.co/licyk/sd-upscaler-models/resolve/main/GFPGAN/parsing_bisenet.pth ./ComfyUI/models/upscale_models parsing_bisenet.pth
__term_sd_task_pre_model aria2_download https://huggingface.co/licyk/sd-upscaler-models/resolve/main/GFPGAN/parsing_parsenet.pth ./ComfyUI/models/upscale_models parsing_parsenet.pth
__term_sd_task_pre_model aria2_download https://huggingface.co/licyk/sd-upscaler-models/resolve/main/RealESRGAN/RealESRGAN_x4plus.pth ./ComfyUI/models/upscale_models RealESRGAN_x4plus.pth
__term_sd_task_pre_model aria2_download https://huggingface.co/licyk/sd-upscaler-models/resolve/main/RealESRGAN/RealESRGAN_x4plus_anime_6B.pth ./ComfyUI/models/upscale_models RealESRGAN_x4plus_anime_6B.pth
__term_sd_task_pre_model aria2_download https://huggingface.co/licyk/sd-embeddings/resolve/main/sd_1.5/EasyNegativeV2.safetensors ./ComfyUI/models/embeddings/negative EasyNegativeV2.safetensors # embeddings模型
__term_sd_task_pre_model aria2_download https://huggingface.co/licyk/sd-embeddings/resolve/main/sd_1.5/bad-artist-anime.pt ./ComfyUI/models/embeddings/negative bad-artist-anime.pt
__term_sd_task_pre_model aria2_download https://huggingface.co/licyk/sd-embeddings/resolve/main/sd_1.5/bad-artist.pt ./ComfyUI/models/embeddings/negative bad-artist.pt
__term_sd_task_pre_model aria2_download https://huggingface.co/licyk/sd-embeddings/resolve/main/sd_1.5/bad-hands-5.pt ./ComfyUI/models/embeddings/negative bad-hands-5.pt
__term_sd_task_pre_model aria2_download https://huggingface.co/licyk/sd-embeddings/resolve/main/sd_1.5/bad-image-v2-39000.pt ./ComfyUI/models/embeddings/negative bad-image-v2-39000.pt
__term_sd_task_pre_model aria2_download https://huggingface.co/licyk/sd-embeddings/resolve/main/sd_1.5/bad_prompt_version2.pt ./ComfyUI/models/embeddings/negative bad_prompt_version2.pt
__term_sd_task_pre_model aria2_download https://huggingface.co/licyk/sd-embeddings/resolve/main/sd_1.5/ng_deepnegative_v1_75t.pt ./ComfyUI/models/embeddings/negative ng_deepnegative_v1_75t.pt
__term_sd_task_pre_model aria2_download https://huggingface.co/licyk/sd-embeddings/resolve/main/sd_1.5/verybadimagenegative_v1.3.pt ./ComfyUI/models/embeddings/negative verybadimagenegative_v1.3.pt
