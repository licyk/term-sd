__term_sd_task_sys term_sd_echo "下载模型中"
__term_sd_task_sys term_sd_echo "使用huggingface模型下载源"
__term_sd_task_sys term_sd_tmp_enable_proxy
__term_sd_task_pre_model aria2_download https://huggingface.co/runwayml/stable-diffusion-v1-5/resolve/main/v1-5-pruned-emaonly.safetensors ./stable-diffusion-webui/models/Stable-diffusion sd-v1-5.safetensors # 大模型
__term_sd_task_pre_model aria2_download https://huggingface.co/stabilityai/sd-vae-ft-mse-original/resolve/main/vae-ft-mse-840000-ema-pruned.safetensors ./stable-diffusion-webui/models/VAE vae-ft-mse-840000-ema-pruned.safetensors # VAE模型
__term_sd_task_pre_model aria2_download https://huggingface.co/stabilityai/sd-vae-ft-ema-original/resolve/main/vae-ft-ema-560000-ema-pruned.safetensors ./stable-diffusion-webui/models/VAE vae-ft-ema-560000-ema-pruned.safetensors
__term_sd_task_pre_model aria2_download https://huggingface.co/licyk/sd-vae/resolve/main/vae-approx/model.pt ./stable-diffusion-webui/models/VAE-approx model.pt # VAE-approx模型
__term_sd_task_pre_model aria2_download https://huggingface.co/licyk/sd-vae/resolve/main/vae-approx/vaeapprox-sdxl.pt ./stable-diffusion-webui/models/VAE-approx vaeapprox-sdxl.pt
__term_sd_task_pre_model aria2_download https://huggingface.co/licyk/sd-upscaler-models/resolve/main/ESRGAN/4x-UltraSharp.pth ./stable-diffusion-webui/models/ESRGAN 4x-UltraSharp.pth # upscaler模型
__term_sd_task_pre_model aria2_download https://huggingface.co/licyk/sd-upscaler-models/resolve/main/ESRGAN/BSRGAN.pth ./stable-diffusion-webui/models/ESRGAN BSRGAN.pth
__term_sd_task_pre_model aria2_download https://huggingface.co/licyk/sd-upscaler-models/resolve/main/ESRGAN/ESRGAN_4x.pth ./stable-diffusion-webui/models/ESRGAN ESRGAN_4x.pth
__term_sd_task_pre_model aria2_download https://huggingface.co/licyk/sd-upscaler-models/resolve/main/ESRGAN/4x_NMKD-Superscale-Artisoftject_210000_G.pth ./stable-diffusion-webui/models/ESRGAN 4x_NMKD-Superscale-Artisoftject_210000_G.pth
__term_sd_task_pre_model aria2_download https://huggingface.co/licyk/sd-upscaler-models/resolve/main/ESRGAN/4x_NMKD-Superscale-SP_178000_G.pth ./stable-diffusion-webui/models/ESRGAN 4x_NMKD-Superscale-SP_178000_G.pth
__term_sd_task_pre_model aria2_download https://huggingface.co/licyk/sd-upscaler-models/resolve/main/ESRGAN/8x_NMKD-Superscale_150000_G.pth ./stable-diffusion-webui/models/ESRGAN 8x_NMKD-Superscale_150000_G.pth
__term_sd_task_pre_model aria2_download https://huggingface.co/licyk/sd-upscaler-models/resolve/main/GFPGAN/GFPGANv1.4.pth ./stable-diffusion-webui/models/GFPGAN GFPGANv1.4.pth
__term_sd_task_pre_model aria2_download https://huggingface.co/licyk/sd-upscaler-models/resolve/main/GFPGAN/detection_Resnet50_Final.pth ./stable-diffusion-webui/models/GFPGAN detection_Resnet50_Final.pth
__term_sd_task_pre_model aria2_download https://huggingface.co/licyk/sd-upscaler-models/resolve/main/GFPGAN/parsing_bisenet.pth ./stable-diffusion-webui/models/GFPGAN parsing_bisenet.pth
__term_sd_task_pre_model aria2_download https://huggingface.co/licyk/sd-upscaler-models/resolve/main/GFPGAN/parsing_parsenet.pth ./stable-diffusion-webui/models/GFPGAN parsing_parsenet.pth
__term_sd_task_pre_model aria2_download https://huggingface.co/licyk/sd-upscaler-models/resolve/main/RealESRGAN/RealESRGAN_x4plus.pth ./stable-diffusion-webui/models/RealESRGAN RealESRGAN_x4plus.pth
__term_sd_task_pre_model aria2_download https://huggingface.co/licyk/sd-upscaler-models/resolve/main/RealESRGAN/RealESRGAN_x4plus_anime_6B.pth ./stable-diffusion-webui/models/RealESRGAN RealESRGAN_x4plus_anime_6B.pth
__term_sd_task_pre_model aria2_download https://huggingface.co/licyk/sd-upscaler-models/resolve/main/BLIP/model_base_caption_capfilt_large.pth ./stable-diffusion-webui/models/BLIP model_base_caption_capfilt_large.pth # BLIP模型
__term_sd_task_pre_model aria2_download https://huggingface.co/licyk/sd-upscaler-models/resolve/main/Codeformer/codeformer-v0.1.0.pth ./stable-diffusion-webui/models/Codeformer codeformer-v0.1.0.pth # Codeformer模型
__term_sd_task_pre_model aria2_download https://huggingface.co/licyk/sd-embeddings/resolve/main/sd_1.5/EasyNegativeV2.safetensors ./stable-diffusion-webui/embeddings EasyNegativeV2.safetensors # embeddings模型
__term_sd_task_pre_model aria2_download https://huggingface.co/licyk/sd-embeddings/resolve/main/sd_1.5/bad-artist-anime.pt ./stable-diffusion-webui/embeddings bad-artist-anime.pt
__term_sd_task_pre_model aria2_download https://huggingface.co/licyk/sd-embeddings/resolve/main/sd_1.5/bad-artist.pt ./stable-diffusion-webui/embeddings bad-artist.pt
__term_sd_task_pre_model aria2_download https://huggingface.co/licyk/sd-embeddings/resolve/main/sd_1.5/bad-hands-5.pt ./stable-diffusion-webui/embeddings bad-hands-5.pt
__term_sd_task_pre_model aria2_download https://huggingface.co/licyk/sd-embeddings/resolve/main/sd_1.5/bad-image-v2-39000.pt ./stable-diffusion-webui/embeddings bad-image-v2-39000.pt
__term_sd_task_pre_model aria2_download https://huggingface.co/licyk/sd-embeddings/resolve/main/sd_1.5/bad_prompt_version2.pt ./stable-diffusion-webui/embeddings bad_prompt_version2.pt
__term_sd_task_pre_model aria2_download https://huggingface.co/licyk/sd-embeddings/resolve/main/sd_1.5/ng_deepnegative_v1_75t.pt ./stable-diffusion-webui/embeddings ng_deepnegative_v1_75t.pt
__term_sd_task_pre_model aria2_download https://huggingface.co/licyk/sd-embeddings/resolve/main/sd_1.5/verybadimagenegative_v1.3.pt ./stable-diffusion-webui/embeddings verybadimagenegative_v1.3.pt
