echo "stable diffusion一键部署脚本"
echo "请确保已安装python、git、aria2"
#选择CUDA,RoCM版本

choose_environment() {
    # 重新选择
    reselect=${1}
    if [ $reselect == 0 ];then
        echo '请选择要安装的CUDA或RoCM工具包版本: '
    elif [ $$reselect == 1 ];then
        echo '请重新选择要安装的版本: '
	fi
    echo '1.Torch 1.12.1(CUDA11.3)+xFormers 0.014'
    echo '2.Torch 1.13.1(CUDA11.7)+xFormers 0.016'
	echo '3.Torch 2.0.0(CUDA11.8)+xFormers 0.018'
	echo '4.Torch 2.0.1(CUDA11.8)+xFormers 0.019'
	echo '5.torch 0.15.0+RoCM 5.4.2'
	echo 'q.已安装工具包，跳过'
	# 获取用户的输入
    read -p '请输入序号进行安装: ' -n 1 environmentnum
	echo '\n'
	# 这里注意，判断空必须加双引号，双引号识别为没有内容；主要处理没有输入指令直接回车
	if [ -z "$environmentnum" ];then
		choose_environment 0
    elif [ $environmentnum == 1 ];then
        echo '开始安装Torch 1.12.1(CUDA11.3)+xFormers 0.014'
    pip install torch==1.12.1+cu113 torchvision==0.13.1+cu113 --index-url https://download.pytorch.org/whl
    pip install xformers==0.0.14
    elif [ $environmentnum == 2 ];then
        echo '开始安装Torch 1.13.1(CUDA11.7)+xFormers 0.016'
    pip install torch==1.13.1+cu117 torchvision==0.14.1+cu117 --index-url https://download.pytorch.org/whl
    pip install xformers==0.0.16
	elif [ $environmentnum == '3' ];then
		echo '开始安装Torch 2.0.0(CUDA11.8)+xFormers 0.018'
    pip install torch==2.0.0+cu118 torchvision==0.15.1+cu118 --index-url https://download.pytorch.org/whl
    pip install xformers==0.0.18
	elif [ $environmentnum == '4' ];then
		echo '开始安装Torch 2.0.1(CUDA11.8)+xFormers 0.019'
    pip install torch==2.0.1+cu118 torchvision==0.15.2+cu118 --index-url https://download.pytorch.org/whl
    pip install xformers==0.0.19 --no-deps
	elif [ $environmentnum == '5' ];then
		echo '开始安装torch 2.0.1+RoCM 5.4.2'
    pip install torch==2.0.1+rocm5.4.2 torchvision==0.15.2+rocm5.4.2 --index-url https://download.pytorch.org/whl
	elif [ $environmentnum == 'q' ];then
		echo '跳过安装'
		# 结束脚本执行
#		exit 1
    else 
        echo '不支持的序号'
		echo $environmentnum
		choose_environment 1
    fi
}

choose_environment 0

echo "结束工具包安装"
# 下载stable diffusion
echo "下载stable diffusion"
git clone https://github.com/AUTOMATIC1111/stable-diffusion-webui.git
aria2c https://raw.githubusercontent.com/licyk/sd-webui-scipt/main/update.sh -d ./stable-diffusion-webui

#下载Stable Diffusion和CodeFormer
echo "下载Stable Diffusion和CodeFormer"
mkdir ./stable-diffusion-webui/repositories
git clone https://github.com/CompVis/stable-diffusion.git ./stable-diffusion-webui/repositories/stable-diffusion
git clone https://github.com/CompVis/taming-transformers.git ./stable-diffusion-webui/repositories/taming-transformers
git clone https://github.com/sczhou/CodeFormer.git ./stable-diffusion-webui/repositories/CodeFormer
git clone https://github.com/salesforce/BLIP.git ./stable-diffusion-webui/repositories/BLIP
git clone https://github.com/Stability-AI/stablediffusion.git/ ./stable-diffusion-webui/repositories/stable-diffusion-stability-ai

# 安装stable diffusion所需环境
echo "安装stable diffusion所需环境"
pip install -r ./stable-diffusion-webui/requirements.txt  --prefer-binary

# 安装 k-diffusion
echo "安装 k-diffusion"
pip install git+https://github.com/crowsonkb/k-diffusion.git --prefer-binary

#安装 GFPGAN
echo "安装 GFPGAN"
pip install git+https://github.com/TencentARC/GFPGAN.git --prefer-binary

#安装CodeFormer依赖
echo "安装CodeFormer依赖"
pip install -r ./stable-diffusion-webui/repositories/CodeFormer/requirements.txt --prefer-binary

#安装clip
echo "安装clip"
pip install git+https://github.com/openai/CLIP.git --prefer-binary

#安装open_clip
echo "安装open_clip"
pip install git+https://github.com/mlfoundations/open_clip.git --prefer-binary

# 升级numpy版本至最新版本
echo "升级numpy版本至最新版本"
pip install -U numpy  --prefer-binary

#安装其他依赖环境
echo "安装其他依赖环境"
pip install -r ./stable-diffusion-webui/requirements.txt  --prefer-binary

#设置环境变量
echo "设置环境变量"
sed -i -e 's/\"sd_model_checkpoint\"\,/\"sd_model_checkpoint\,sd_vae\,CLIP_stop_at_last_layers\,cross_attention_optimization\,token_merging_ratio\,token_merging_ratio_img2img\,token_merging_ratio_hr\,show_progress_type\"\,/g' ./stable-diffusion-webui/modules/shared.py

# 安装插件
echo "安装插件"
# sd-webui-additional-networks
git clone https://github.com/kohya-ss/sd-webui-additional-networks ./stable-diffusion-webui/extensions/sd-webui-additional-networks
# a1111-sd-webui-tagcomplete
git clone https://github.com/DominikDoom/a1111-sd-webui-tagcomplete ./stable-diffusion-webui/extensions/a1111-sd-webui-tagcomplete
# multidiffusion-upscaler-for-automatic1111
git clone https://github.com/pkuliyi2015/multidiffusion-upscaler-for-automatic1111 ./stable-diffusion-webui/extensions/multidiffusion-upscaler-for-automatic1111
# sd-dynamic-thresholding
git clone https://github.com/mcmonkeyprojects/sd-dynamic-thresholding ./stable-diffusion-webui/extensions/sd-dynamic-thresholding
# sd-webui-cutoff
git clone https://github.com/hnmr293/sd-webui-cutoff ./stable-diffusion-webui/extensions/sd-webui-cutoff
# sd-webui-model-converter
git clone https://github.com/Akegarasu/sd-webui-model-converter ./stable-diffusion-webui/extensions/sd-webui-model-converter
# sd-webui-supermerger
git clone https://github.com/hako-mikan/sd-webui-supermerger ./stable-diffusion-webui/extensions/sd-webui-supermerger
# stable-diffusion-webui-localization-zh_CN
git clone https://github.com/dtlnor/stable-diffusion-webui-localization-zh_CN ./stable-diffusion-webui/extensions/stable-diffusion-webui-localization-zh_CN
# stable-diffusion-webui-wd14-tagger
git clone https://github.com/tsukimiya/stable-diffusion-webui-wd14-tagger ./stable-diffusion-webui/extensions/stable-diffusion-webui-wd14-tagger
# sd-webui-regional-prompter
git clone https://github.com/hako-mikan/sd-webui-regional-prompter ./stable-diffusion-webui/extensions/sd-webui-regional-prompter
# stable-diffusion-webui-baidu-netdisk
git clone https://github.com/zanllp/stable-diffusion-webui-baidu-netdisk ./stable-diffusion-webui/extensions/stable-diffusion-webui-baidu-netdisk
# stable-diffusion-webui-anti-burn
git clone https://github.com/klimaleksus/stable-diffusion-webui-anti-burn ./stable-diffusion-webui/extensions/stable-diffusion-webui-anti-burn
# loopback_scaler
git clone https://github.com/Elldreth/loopback_scaler.git ./stable-diffusion-webui/extensions/loopback_scaler
# latentcoupleregionmapper
git clone https://github.com/CodeZombie/latentcoupleregionmapper.git ./stable-diffusion-webui/extensions/latentcoupleregionmapper
# ultimate-upscale-for-automatic1111
git clone https://github.com/Coyote-A/ultimate-upscale-for-automatic1111.git ./stable-diffusion-webui/extensions/ultimate-upscale-for-automatic1111
# deforum-for-automatic1111-webui
git clone https://github.com/deforum-art/deforum-for-automatic1111-webui ./stable-diffusion-webui/extensions/deforum-for-automatic1111-webui
mkdir ./stable-diffusion-webui/extensions/deforum-for-automatic1111-webui/models
# stable-diffusion-webui-images-browser
git clone https://github.com/AlUlkesh/stable-diffusion-webui-images-browser ./stable-diffusion-webui/extensions/stable-diffusion-webui-images-browser
# stable-diffusion-webui-huggingface
git clone https://github.com/camenduru/stable-diffusion-webui-huggingface ./stable-diffusion-webui/extensions/stable-diffusion-webui-huggingface
# sd-civitai-browser
git clone -b v2.0 https://github.com/camenduru/sd-civitai-browser ./stable-diffusion-webui/extensions/sd-civitai-browser
# sd-webui-additional-networks
git clone https://github.com/kohya-ss/sd-webui-additional-networks ./stable-diffusion-webui/extensions/sd-webui-additional-networks
# openpose-editor
git clone https://github.com/camenduru/openpose-editor ./stable-diffusion-webui/extensions/openpose-editor
# sd-webui-depth-lib
git clone https://github.com/jexom/sd-webui-depth-lib ./stable-diffusion-webui/extensions/sd-webui-depth-lib
# posex
git clone https://github.com/hnmr293/posex ./stable-diffusion-webui/extensions/posex
# sd-webui-tunnels
git clone https://github.com/camenduru/sd-webui-tunnels ./stable-diffusion-webui/extensions/sd-webui-tunnels
# batchlinks-webui
git clone https://github.com/etherealxx/batchlinks-webui ./stable-diffusion-webui/extensions/batchlinks-webui
# stable-diffusion-webui-catppuccin
git clone https://github.com/camenduru/stable-diffusion-webui-catppuccin ./stable-diffusion-webui/extensions/stable-diffusion-webui-catppuccin
# a1111-sd-webui-locon
git clone https://github.com/KohakuBlueleaf/a1111-sd-webui-locon ./stable-diffusion-webui/extensions/a1111-sd-webui-locon
# stable-diffusion-webui-rembg
git clone https://github.com/AUTOMATIC1111/stable-diffusion-webui-rembg ./stable-diffusion-webui/extensions/stable-diffusion-webui-rembg
# stable-diffusion-webui-two-shot
git clone https://github.com/ashen-sensored/stable-diffusion-webui-two-shot ./stable-diffusion-webui/extensions/stable-diffusion-webui-two-shot
# sd-webui-lora-block-weight
git clone https://github.com/hako-mikan/sd-webui-lora-block-weight ./stable-diffusion-webui/extensions/sd-webui-lora-block-weight
# sd-face-editor
git clone https://github.com/ototadana/sd-face-editor ./stable-diffusion-webui/extensions/sd-face-editor
# sd-webui-segment-anything
git clone https://github.com/continue-revolution/sd-webui-segment-anything.git
# controlnet
git clone https://github.com/Mikubill/sd-webui-controlnet ./stable-diffusion-webui/extensions/sd-webui-controlnet
##controlnet插件的相关模型
aria2c https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/control_v11e_sd15_ip2p_fp16.safetensors -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o control_v11e_sd15_ip2p_fp16.safetensors
aria2c https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/control_v11e_sd15_shuffle_fp16.safetensors -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o control_v11e_sd15_shuffle_fp16.safetensors
aria2c https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/control_v11p_sd15_canny_fp16.safetensors -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o control_v11p_sd15_canny_fp16.safetensors
aria2c https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/control_v11f1p_sd15_depth_fp16.safetensors -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o control_v11f1p_sd15_depth_fp16.safetensors
aria2c https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/control_v11p_sd15_inpaint_fp16.safetensors -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o control_v11p_sd15_inpaint_fp16.safetensors
aria2c https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/control_v11p_sd15_lineart_fp16.safetensors -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o control_v11p_sd15_lineart_fp16.safetensors
aria2c https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/control_v11p_sd15_mlsd_fp16.safetensors -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o control_v11p_sd15_mlsd_fp16.safetensors
aria2c https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/control_v11p_sd15_normalbae_fp16.safetensors -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o control_v11p_sd15_normalbae_fp16.safetensors
aria2c https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/control_v11p_sd15_openpose_fp16.safetensors -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o control_v11p_sd15_openpose_fp16.safetensors
aria2c https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/control_v11p_sd15_scribble_fp16.safetensors -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o control_v11p_sd15_scribble_fp16.safetensors
aria2c https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/control_v11p_sd15_seg_fp16.safetensors -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o control_v11p_sd15_seg_fp16.safetensors
aria2c https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/control_v11p_sd15_softedge_fp16.safetensors -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o control_v11p_sd15_softedge_fp16.safetensors
aria2c https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/control_v11p_sd15s2_lineart_anime_fp16.safetensors -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o control_v11p_sd15s2_lineart_anime_fp16.safetensors
aria2c https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/control_v11f1e_sd15_tile_fp16.safetensors -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o control_v11f1e_sd15_tile_fp16.safetensors
aria2c https://huggingface.co/ckpt/ControlNet-v1-1/raw/main/control_v11e_sd15_ip2p_fp16.yaml -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o control_v11e_sd15_ip2p_fp16.yaml
aria2c https://huggingface.co/ckpt/ControlNet-v1-1/raw/main/control_v11e_sd15_shuffle_fp16.yaml -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o control_v11e_sd15_shuffle_fp16.yaml
aria2c https://huggingface.co/ckpt/ControlNet-v1-1/raw/main/control_v11p_sd15_canny_fp16.yaml -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o control_v11p_sd15_canny_fp16.yaml
aria2c https://huggingface.co/ckpt/ControlNet-v1-1/raw/main/control_v11f1p_sd15_depth_fp16.yaml -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o control_v11f1p_sd15_depth_fp16.yaml
aria2c https://huggingface.co/ckpt/ControlNet-v1-1/raw/main/control_v11p_sd15_inpaint_fp16.yaml -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o control_v11p_sd15_inpaint_fp16.yaml
aria2c https://huggingface.co/ckpt/ControlNet-v1-1/raw/main/control_v11p_sd15_lineart_fp16.yaml -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o control_v11p_sd15_lineart_fp16.yaml
aria2c https://huggingface.co/ckpt/ControlNet-v1-1/raw/main/control_v11p_sd15_mlsd_fp16.yaml -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o control_v11p_sd15_mlsd_fp16.yaml
aria2c https://huggingface.co/ckpt/ControlNet-v1-1/raw/main/control_v11p_sd15_normalbae_fp16.yaml -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o control_v11p_sd15_normalbae_fp16.yaml
aria2c https://huggingface.co/ckpt/ControlNet-v1-1/raw/main/control_v11p_sd15_openpose_fp16.yaml -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o control_v11p_sd15_openpose_fp16.yaml
aria2c https://huggingface.co/ckpt/ControlNet-v1-1/raw/main/control_v11p_sd15_scribble_fp16.yaml -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o control_v11p_sd15_scribble_fp16.yaml
aria2c https://huggingface.co/ckpt/ControlNet-v1-1/raw/main/control_v11p_sd15_seg_fp16.yaml -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o control_v11p_sd15_seg_fp16.yaml
aria2c https://huggingface.co/ckpt/ControlNet-v1-1/raw/main/control_v11p_sd15_softedge_fp16.yaml -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o control_v11p_sd15_softedge_fp16.yaml
aria2c https://huggingface.co/ckpt/ControlNet-v1-1/raw/main/control_v11p_sd15s2_lineart_anime_fp16.yaml -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o control_v11p_sd15s2_lineart_anime_fp16.yaml
aria2c https://huggingface.co/ckpt/ControlNet-v1-1/raw/main/control_v11f1e_sd15_tile_fp16.yaml -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o control_v11f1e_sd15_tile_fp16.yaml
aria2c https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/t2iadapter_style_sd14v1.pth -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o t2iadapter_style_sd14v1.pth
aria2c https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/t2iadapter_sketch_sd14v1.pth -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o t2iadapter_sketch_sd14v1.pth
aria2c https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/t2iadapter_seg_sd14v1.pth -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o t2iadapter_seg_sd14v1.pth
aria2c https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/t2iadapter_openpose_sd14v1.pth -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o t2iadapter_openpose_sd14v1.pth
aria2c https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/t2iadapter_keypose_sd14v1.pth -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o t2iadapter_keypose_sd14v1.pth
aria2c https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/t2iadapter_depth_sd14v1.pth -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o t2iadapter_depth_sd14v1.pth
aria2c https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/t2iadapter_color_sd14v1.pth -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o t2iadapter_color_sd14v1.pth
aria2c https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/t2iadapter_canny_sd14v1.pth -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o t2iadapter_canny_sd14v1.pth
aria2c https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/t2iadapter_canny_sd15v2.pth -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o t2iadapter_canny_sd15v2.pth
aria2c https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/t2iadapter_depth_sd15v2.pth -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o t2iadapter_depth_sd15v2.pth
aria2c https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/t2iadapter_sketch_sd15v2.pth -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o t2iadapter_sketch_sd15v2.pth
aria2c https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/t2iadapter_zoedepth_sd15v1.pth -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o t2iadapter_zoedepth_sd15v1.pth

#下载模型
echo "下载模型"
aria2c https://huggingface.co/andite/anything-v4.0/resolve/main/anything-v4.0-pruned-fp16.safetensors -d ./stable-diffusion-webui/models/Stable-diffusion -o anything-v4.0-pruned-fp16.safetensors
aria2c https://huggingface.co/andite/anything-v4.0/resolve/main/anything-v4.0.vae.pt -d ./stable-diffusion-webui/models/VAE -o anything-v4.0.vae.pt
aria2c https://huggingface.co/embed/upscale/resolve/main/4x-UltraSharp.pth -d ./stable-diffusion-webui/models/ESRGAN -o 4x-UltraSharp.pth
git clone https://huggingface.co/embed/negative ./stable-diffusion-webui/embeddings/negative
git clone https://huggingface.co/embed/lora ./stable-diffusion-webui/models/Lora/positive

echo "安装结束"
