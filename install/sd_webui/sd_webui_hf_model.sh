__term_sd_task_sys term_sd_echo "下载模型中"
__term_sd_task_sys term_sd_echo "使用huggingface模型下载源"
__term_sd_task_sys term_sd_tmp_enable_proxy
__term_sd_task_pre_model aria2_download https://huggingface.co/runwayml/stable-diffusion-v1-5/resolve/main/v1-5-pruned-emaonly.safetensors "$sd_webui_folder"/models/Stable-diffusion v1-5-pruned-emaonly.safetensors # 大模型
__term_sd_task_pre_model aria2_download https://huggingface.co/stabilityai/sd-vae-ft-mse-original/resolve/main/vae-ft-mse-840000-ema-pruned.safetensors "$sd_webui_folder"/models/VAE vae-ft-mse-840000-ema-pruned.safetensors # VAE模型
__term_sd_task_pre_model aria2_download https://huggingface.co/stabilityai/sd-vae-ft-ema-original/resolve/main/vae-ft-ema-560000-ema-pruned.safetensors "$sd_webui_folder"/models/VAE vae-ft-ema-560000-ema-pruned.safetensors
__term_sd_task_pre_model aria2_download https://huggingface.co/licyk/sd-vae/resolve/main/vae-approx/model.pt "$sd_webui_folder"/models/VAE-approx model.pt # VAE-approx模型
__term_sd_task_pre_model aria2_download https://huggingface.co/licyk/sd-vae/resolve/main/vae-approx/vaeapprox-sdxl.pt "$sd_webui_folder"/models/VAE-approx vaeapprox-sdxl.pt
__term_sd_task_pre_model aria2_download https://huggingface.co/licyk/sd-upscaler-models/resolve/main/ESRGAN/4x-UltraSharp.pth "$sd_webui_folder"/models/ESRGAN 4x-UltraSharp.pth # upscaler模型
__term_sd_task_pre_model aria2_download https://huggingface.co/licyk/sd-upscaler-models/resolve/main/ESRGAN/BSRGAN.pth "$sd_webui_folder"/models/ESRGAN BSRGAN.pth
__term_sd_task_pre_model aria2_download https://huggingface.co/licyk/sd-upscaler-models/resolve/main/ESRGAN/ESRGAN_4x.pth "$sd_webui_folder"/models/ESRGAN ESRGAN_4x.pth
__term_sd_task_pre_model aria2_download https://huggingface.co/licyk/sd-upscaler-models/resolve/main/ESRGAN/4x_NMKD-Superscale-Artisoftject_210000_G.pth "$sd_webui_folder"/models/ESRGAN 4x_NMKD-Superscale-Artisoftject_210000_G.pth
__term_sd_task_pre_model aria2_download https://huggingface.co/licyk/sd-upscaler-models/resolve/main/ESRGAN/4x_NMKD-Superscale-SP_178000_G.pth "$sd_webui_folder"/models/ESRGAN 4x_NMKD-Superscale-SP_178000_G.pth
__term_sd_task_pre_model aria2_download https://huggingface.co/licyk/sd-upscaler-models/resolve/main/ESRGAN/8x_NMKD-Superscale_150000_G.pth "$sd_webui_folder"/models/ESRGAN 8x_NMKD-Superscale_150000_G.pth
__term_sd_task_pre_model aria2_download https://huggingface.co/licyk/sd-upscaler-models/resolve/main/GFPGAN/GFPGANv1.4.pth "$sd_webui_folder"/models/GFPGAN GFPGANv1.4.pth
__term_sd_task_pre_model aria2_download https://huggingface.co/licyk/sd-upscaler-models/resolve/main/GFPGAN/detection_Resnet50_Final.pth "$sd_webui_folder"/models/GFPGAN detection_Resnet50_Final.pth
__term_sd_task_pre_model aria2_download https://huggingface.co/licyk/sd-upscaler-models/resolve/main/GFPGAN/parsing_bisenet.pth "$sd_webui_folder"/models/GFPGAN parsing_bisenet.pth
__term_sd_task_pre_model aria2_download https://huggingface.co/licyk/sd-upscaler-models/resolve/main/GFPGAN/parsing_parsenet.pth "$sd_webui_folder"/models/GFPGAN parsing_parsenet.pth
__term_sd_task_pre_model aria2_download https://huggingface.co/licyk/sd-upscaler-models/resolve/main/RealESRGAN/RealESRGAN_x4plus.pth "$sd_webui_folder"/models/RealESRGAN RealESRGAN_x4plus.pth
__term_sd_task_pre_model aria2_download https://huggingface.co/licyk/sd-upscaler-models/resolve/main/RealESRGAN/RealESRGAN_x4plus_anime_6B.pth "$sd_webui_folder"/models/RealESRGAN RealESRGAN_x4plus_anime_6B.pth
__term_sd_task_pre_model aria2_download https://huggingface.co/licyk/sd-upscaler-models/resolve/main/BLIP/model_base_caption_capfilt_large.pth "$sd_webui_folder"/models/BLIP model_base_caption_capfilt_large.pth # BLIP模型
__term_sd_task_pre_model aria2_download https://huggingface.co/licyk/sd-upscaler-models/resolve/main/torch_deepdanbooru/model-resnet_custom_v3.pt  "$sd_webui_folder"/models/torch_deepdanbooru model-resnet_custom_v3.pt # deepdanbooru模型
__term_sd_task_pre_model aria2_download https://huggingface.co/licyk/sd-upscaler-models/resolve/main/Codeformer/codeformer-v0.1.0.pth "$sd_webui_folder"/models/Codeformer codeformer-v0.1.0.pth # Codeformer模型
__term_sd_task_pre_model aria2_download https://huggingface.co/licyk/sd-embeddings/resolve/main/sd_1.5/EasyNegativeV2.safetensors "$sd_webui_folder"/embeddings EasyNegativeV2.safetensors # embeddings模型
__term_sd_task_pre_model aria2_download https://huggingface.co/licyk/sd-embeddings/resolve/main/sd_1.5/bad-artist-anime.pt "$sd_webui_folder"/embeddings bad-artist-anime.pt
__term_sd_task_pre_model aria2_download https://huggingface.co/licyk/sd-embeddings/resolve/main/sd_1.5/bad-artist.pt "$sd_webui_folder"/embeddings bad-artist.pt
__term_sd_task_pre_model aria2_download https://huggingface.co/licyk/sd-embeddings/resolve/main/sd_1.5/bad-hands-5.pt "$sd_webui_folder"/embeddings bad-hands-5.pt
__term_sd_task_pre_model aria2_download https://huggingface.co/licyk/sd-embeddings/resolve/main/sd_1.5/bad-image-v2-39000.pt "$sd_webui_folder"/embeddings bad-image-v2-39000.pt
__term_sd_task_pre_model aria2_download https://huggingface.co/licyk/sd-embeddings/resolve/main/sd_1.5/bad_prompt_version2.pt "$sd_webui_folder"/embeddings bad_prompt_version2.pt
__term_sd_task_pre_model aria2_download https://huggingface.co/licyk/sd-embeddings/resolve/main/sd_1.5/ng_deepnegative_v1_75t.pt "$sd_webui_folder"/embeddings ng_deepnegative_v1_75t.pt
__term_sd_task_pre_model aria2_download https://huggingface.co/licyk/sd-embeddings/resolve/main/sd_1.5/verybadimagenegative_v1.3.pt "$sd_webui_folder"/embeddings verybadimagenegative_v1.3.pt
