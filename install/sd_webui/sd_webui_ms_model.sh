__term_sd_task_sys term_sd_echo "下载模型中"
__term_sd_task_sys term_sd_echo "使用modelscope模型下载源"
__term_sd_task_pre_model get_modelscope_model licyks/sd-model/master/sd_1.5/v1-5-pruned-emaonly.safetensors ./"$sd_webui_folder"/models/Stable-diffusion # 大模型
__term_sd_task_pre_model get_modelscope_model licyks/sd-vae/master/sd_1.5/vae-ft-ema-560000-ema-pruned.safetensors ./"$sd_webui_folder"/models/VAE # VAE模型
__term_sd_task_pre_model get_modelscope_model licyks/sd-vae/master/sd_1.5/vae-ft-mse-840000-ema-pruned.safetensors ./"$sd_webui_folder"/models/VAE
__term_sd_task_pre_model get_modelscope_model licyks/sd-vae/master/vae-approx/model.pt ./"$sd_webui_folder"/models/VAE-approx # VAE-approx模型
__term_sd_task_pre_model get_modelscope_model licyks/sd-vae/master/vae-approx/vaeapprox-sdxl.pt ./"$sd_webui_folder"/models/VAE-approx
__term_sd_task_pre_model get_modelscope_model licyks/sd-upscaler-models/master/ESRGAN/4x-UltraSharp.pth ./"$sd_webui_folder"/models/ESRGAN # upscaler模型
__term_sd_task_pre_model get_modelscope_model licyks/sd-upscaler-models/master/ESRGAN/BSRGAN.pth ./"$sd_webui_folder"/models/ESRGAN
__term_sd_task_pre_model get_modelscope_model licyks/sd-upscaler-models/master/ESRGAN/ESRGAN_4x.pth ./"$sd_webui_folder"/models/ESRGAN
__term_sd_task_pre_model get_modelscope_model licyks/sd-upscaler-models/master/ESRGAN/4x_NMKD-Superscale-Artisoftject_210000_G.pth ./"$sd_webui_folder"/models/ESRGAN
__term_sd_task_pre_model get_modelscope_model licyks/sd-upscaler-models/master/ESRGAN/4x_NMKD-Superscale-SP_178000_G.pth ./"$sd_webui_folder"/models/ESRGAN
__term_sd_task_pre_model get_modelscope_model licyks/sd-upscaler-models/master/ESRGAN/8x_NMKD-Superscale_150000_G.pth ./"$sd_webui_folder"/models/ESRGAN
__term_sd_task_pre_model get_modelscope_model licyks/sd-upscaler-models/master/GFPGAN/detection_Resnet50_Final.pth ./"$sd_webui_folder"/models/GFPGAN
__term_sd_task_pre_model get_modelscope_model licyks/sd-upscaler-models/master/GFPGAN/GFPGANv1.4.pth ./"$sd_webui_folder"/models/GFPGAN
__term_sd_task_pre_model get_modelscope_model licyks/sd-upscaler-models/master/GFPGAN/parsing_bisenet.pth ./"$sd_webui_folder"/models/GFPGAN
__term_sd_task_pre_model get_modelscope_model licyks/sd-upscaler-models/master/GFPGAN/parsing_parsenet.pth ./"$sd_webui_folder"/models/GFPGAN
__term_sd_task_pre_model get_modelscope_model licyks/sd-upscaler-models/master/RealESRGAN/RealESRGAN_x4plus.pth ./"$sd_webui_folder"/models/RealESRGAN
__term_sd_task_pre_model get_modelscope_model licyks/sd-upscaler-models/master/RealESRGAN/RealESRGAN_x4plus_anime_6B.pth ./"$sd_webui_folder"/models/RealESRGAN
__term_sd_task_pre_model get_modelscope_model licyks/sd-upscaler-models/master/BLIP/model_base_caption_capfilt_large.pth ./"$sd_webui_folder"/models/BLIP # BLIP模型
__term_sd_task_pre_model get_modelscope_model licyks/sd-upscaler-models/master/torch_deepdanbooru/model-resnet_custom_v3.pt ./"$sd_webui_folder"/models/torch_deepdanbooru # deepdanbooru模型
__term_sd_task_pre_model get_modelscope_model licyks/sd-upscaler-models/master/Codeformer/codeformer-v0.1.0.pth ./"$sd_webui_folder"/models/Codeformer # Codeformer模型
__term_sd_task_pre_model get_modelscope_model licyks/sd-embeddings/master/sd_1.5/EasyNegativeV2.safetensors ./"$sd_webui_folder"/embeddings # embeddings模型
__term_sd_task_pre_model get_modelscope_model licyks/sd-embeddings/master/sd_1.5/bad-artist-anime.pt ./"$sd_webui_folder"/embeddings
__term_sd_task_pre_model get_modelscope_model licyks/sd-embeddings/master/sd_1.5/bad-artist.pt ./"$sd_webui_folder"/embeddings
__term_sd_task_pre_model get_modelscope_model licyks/sd-embeddings/master/sd_1.5/bad-hands-5.pt ./"$sd_webui_folder"/embeddings
__term_sd_task_pre_model get_modelscope_model licyks/sd-embeddings/master/sd_1.5/bad-image-v2-39000.pt ./"$sd_webui_folder"/embeddings
__term_sd_task_pre_model get_modelscope_model licyks/sd-embeddings/master/sd_1.5/bad_prompt_version2.pt ./"$sd_webui_folder"/embeddings
__term_sd_task_pre_model get_modelscope_model licyks/sd-embeddings/master/sd_1.5/ng_deepnegative_v1_75t.pt ./"$sd_webui_folder"/embeddings
__term_sd_task_pre_model get_modelscope_model licyks/sd-embeddings/master/sd_1.5/verybadimagenegative_v1.3.pt ./"$sd_webui_folder"/embeddings
