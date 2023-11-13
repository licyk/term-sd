__term_sd_task_sys term_sd_echo "下载模型中"
__term_sd_task_sys term_sd_echo "使用huggingface模型下载源"
__term_sd_task_sys term_sd_tmp_enable_proxy
__term_sd_task_pre_model aria2_download https://huggingface.co/licyk/sd-upscaler-models/resolve/main/invokeai/RealESRGAN_x4plus.pth -d ./invokeai/models/core/upscaling/realesrgan -o RealESRGAN_x4plus.pth
__term_sd_task_pre_model aria2_download https://huggingface.co/licyk/sd-upscaler-models/resolve/main/invokeai/RealESRGAN_x4plus_anime_6B.pth -d ./invokeai/models/core/upscaling/realesrgan -o RealESRGAN_x4plus_anime_6B.pth
__term_sd_task_pre_model aria2_download https://huggingface.co/licyk/sd-upscaler-models/resolve/main/invokeai/ESRGAN_SRx4_DF2KOST_official-ff704c30.pth -d ./invokeai/models/core/upscaling/realesrgan -o ESRGAN_SRx4_DF2KOST_official-ff704c30.pth
__term_sd_task_pre_model aria2_download https://huggingface.co/licyk/sd-upscaler-models/resolve/main/invokeai/RealESRGAN_x2plus.pth -d ./invokeai/models/core/upscaling/realesrgan -o RealESRGAN_x2plus.pth