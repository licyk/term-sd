__term_sd_task_sys term_sd_echo "下载模型中"
__term_sd_task_sys term_sd_echo "使用modelscope模型下载源"
__term_sd_task_pre_model get_modelscope_model licyks/sd-upscaler-models/master/invokeai/ESRGAN_SRx4_DF2KOST_official-ff704c30.pth ./invokeai/models/core/upscaling/realesrgan
__term_sd_task_pre_model get_modelscope_model licyks/sd-upscaler-models/master/invokeai/RealESRGAN_x2plus.pth ./invokeai/models/core/upscaling/realesrgan
__term_sd_task_pre_model get_modelscope_model licyks/sd-upscaler-models/master/invokeai/RealESRGAN_x4plus.pth ./invokeai/models/core/upscaling/realesrgan
__term_sd_task_pre_model get_modelscope_model licyks/sd-upscaler-models/master/invokeai/RealESRGAN_x4plus_anime_6B.pth ./invokeai/models/core/upscaling/realesrgan