__term_sd_task_sys term_sd_echo "下载模型中"
__term_sd_task_sys term_sd_echo "使用huggingface模型下载源"
__term_sd_task_sys term_sd_tmp_enable_proxy
__term_sd_task_pre_model aria2_download https://huggingface.co/runwayml/stable-diffusion-v1-5/resolve/main/v1-5-pruned-emaonly.safetensors -d ./stable-diffusion-webui/models/Stable-diffusion -o sd-v1-5.safetensors # 大模型
__term_sd_task_pre_model aria2_download https://huggingface.co/stabilityai/sd-vae-ft-mse-original/resolve/main/vae-ft-mse-840000-ema-pruned.safetensors -d ./stable-diffusion-webui/models/VAE -o vae-ft-mse-840000-ema-pruned.safetensors # VAE模型
__term_sd_task_pre_model aria2_download https://huggingface.co/stabilityai/sd-vae-ft-ema-original/resolve/main/vae-ft-ema-560000-ema-pruned.safetensors -d ./stable-diffusion-webui/models/VAE -o vae-ft-ema-560000-ema-pruned.safetensors
__term_sd_task_pre_model aria2_download https://huggingface.co/licyk/sd-vae/resolve/main/vae-approx/model.pt -d ./stable-diffusion-webui/models/VAE-approx -o model.pt # VAE-approx模型
__term_sd_task_pre_model aria2_download https://huggingface.co/licyk/sd-vae/resolve/main/vae-approx/vaeapprox-sdxl.pt -d ./stable-diffusion-webui/models/VAE-approx -o vaeapprox-sdxl.pt
__term_sd_task_pre_model aria2_download https://huggingface.co/licyk/sd-upscaler-models/resolve/main/ESRGAN/4x-UltraSharp.pth -d ./stable-diffusion-webui/models/ESRGAN -o 4x-UltraSharp.pth # upscaler模型
__term_sd_task_pre_model aria2_download https://huggingface.co/licyk/sd-upscaler-models/resolve/main/ESRGAN/BSRGAN.pth -d ./stable-diffusion-webui/models/ESRGAN -o BSRGAN.pth
__term_sd_task_pre_model aria2_download https://huggingface.co/licyk/sd-upscaler-models/resolve/main/ESRGAN/ESRGAN_4x.pth -d ./stable-diffusion-webui/models/ESRGAN -o ESRGAN_4x.pth
__term_sd_task_pre_model aria2_download https://huggingface.co/licyk/sd-upscaler-models/resolve/main/GFPGAN/GFPGANv1.4.pth -d ./stable-diffusion-webui/models/GFPGAN -o GFPGANv1.4.pth
__term_sd_task_pre_model aria2_download https://huggingface.co/licyk/sd-upscaler-models/resolve/main/GFPGAN/detection_Resnet50_Final.pth -d ./stable-diffusion-webui/models/GFPGAN -o detection_Resnet50_Final.pth
__term_sd_task_pre_model aria2_download https://huggingface.co/licyk/sd-upscaler-models/resolve/main/GFPGAN/parsing_bisenet.pth -d ./stable-diffusion-webui/models/GFPGAN -o parsing_bisenet.pth
__term_sd_task_pre_model aria2_download https://huggingface.co/licyk/sd-upscaler-models/resolve/main/GFPGAN/parsing_parsenet.pth -d ./stable-diffusion-webui/models/GFPGAN -o parsing_parsenet.pth
__term_sd_task_pre_model aria2_download https://huggingface.co/licyk/sd-upscaler-models/resolve/main/RealESRGAN/RealESRGAN_x4plus.pth -d ./stable-diffusion-webui/models/RealESRGAN -o RealESRGAN_x4plus.pth
__term_sd_task_pre_model aria2_download https://huggingface.co/licyk/sd-upscaler-models/resolve/main/RealESRGAN/RealESRGAN_x4plus_anime_6B.pth -d ./stable-diffusion-webui/models/RealESRGAN -o RealESRGAN_x4plus_anime_6B.pth
__term_sd_task_pre_model aria2_download https://huggingface.co/licyk/sd-upscaler-models/resolve/main/BLIP/model_base_caption_capfilt_large.pth -d ./stable-diffusion-webui/models/BLIP -o model_base_caption_capfilt_large.pth # BLIP模型
__term_sd_task_pre_model aria2_download https://huggingface.co/licyk/sd-upscaler-models/resolve/main/Codeformer/codeformer-v0.1.0.pth -d ./stable-diffusion-webui/models/Codeformer -o codeformer-v0.1.0.pth # Codeformer模型
__term_sd_task_pre_model aria2_download https://huggingface.co/licyk/sd-embeddings/resolve/main/sd_1.5/EasyNegativeV2.safetensors -d ./stable-diffusion-webui/embeddings/negative -o EasyNegativeV2.safetensors # embeddings模型
__term_sd_task_pre_model aria2_download https://huggingface.co/licyk/sd-embeddings/resolve/main/sd_1.5/bad-artist-anime.pt -d ./stable-diffusion-webui/embeddings/negative -o bad-artist-anime.pt
__term_sd_task_pre_model aria2_download https://huggingface.co/licyk/sd-embeddings/resolve/main/sd_1.5/bad-artist.pt -d ./stable-diffusion-webui/embeddings/negative -o bad-artist.pt
__term_sd_task_pre_model aria2_download https://huggingface.co/licyk/sd-embeddings/resolve/main/sd_1.5/bad-hands-5.pt -d ./stable-diffusion-webui/embeddings/negative -o bad-hands-5.pt
__term_sd_task_pre_model aria2_download https://huggingface.co/licyk/sd-embeddings/resolve/main/sd_1.5/bad-image-v2-39000.pt -d ./stable-diffusion-webui/embeddings/negative -o bad-image-v2-39000.pt
__term_sd_task_pre_model aria2_download https://huggingface.co/licyk/sd-embeddings/resolve/main/sd_1.5/bad_prompt_version2.pt -d ./stable-diffusion-webui/embeddings/negative -o bad_prompt_version2.pt
__term_sd_task_pre_model aria2_download https://huggingface.co/licyk/sd-embeddings/resolve/main/sd_1.5/ng_deepnegative_v1_75t.pt -d ./stable-diffusion-webui/embeddings/negative -o ng_deepnegative_v1_75t.pt
__term_sd_task_pre_model aria2_download https://huggingface.co/licyk/sd-embeddings/resolve/main/sd_1.5/verybadimagenegative_v1.3.pt -d ./stable-diffusion-webui/embeddings/negative -o verybadimagenegative_v1.3.pt