echo "请确保已安装python、git、aria2"
# 下载stable diffusion
git clone https://ghproxy.com/https://github.com/AUTOMATIC1111/stable-diffusion-webui.git

# clone repositories for Stable Diffusion and (optionally) CodeFormer
mkdir .//stable-diffusion-webui/repositories
git clone https://ghproxy.com/https://github.com/CompVis/stable-diffusion.git ./stable-diffusion-webui/repositories/stable-diffusion
git clone https://ghproxy.com/https://github.com/CompVis/taming-transformers.git ./stable-diffusion-webui/repositories/taming-transformers
git clone https://ghproxy.com/https://github.com/sczhou/CodeFormer.git ./stable-diffusion-webui/repositories/CodeFormer
git clone https://ghproxy.com/https://github.com/salesforce/BLIP.git ./stable-diffusion-webui/repositories/BLIP

# 安装stable diffusion所需环境
pip install torch==1.13.1+cu117 torchvision==0.14.1+cu117 torchaudio==0.13.1 torchtext==0.14.1 torchdata==0.5.1 -i https://mirrors.bfsu.edu.cn/pypi/web/simple -f https://mirror.sjtu.edu.cn/pytorch-wheels/torch_stable.html

pip install xformers==0.0.16 -i https://mirrors.bfsu.edu.cn/pypi/web/simple -f https://mirror.sjtu.edu.cn/pytorch-wheels/torch_stable.html

pip install -r ./stable-diffusion-webui/requirements.txt  --prefer-binary -i https://mirrors.bfsu.edu.cn/pypi/web/simple

# 安装 k-diffusion
pip install git+https://ghproxy.com/https://github.com/crowsonkb/k-diffusion.git --prefer-binary -i https://mirrors.bfsu.edu.cn/pypi/web/simple

# (可选) 安装 GFPGAN (face restoration)
pip install git+https://ghproxy.com/https://github.com/TencentARC/GFPGAN.git --prefer-binary -i https://mirrors.bfsu.edu.cn/pypi/web/simple

# (可选) 安装 requirements for CodeFormer (face restoration)
pip install -r ./repositories/CodeFormer/requirements.txt --prefer-binary -i https://mirrors.bfsu.edu.cn/pypi/web/simple

# 升级numpy版本至最新版本
pip install -U numpy  --prefer-binary -i https://mirrors.bfsu.edu.cn/pypi/web/simple

# 安装插件
# sd-webui-additional-networks
git clone https://ghproxy.com/https://github.com/kohya-ss/sd-webui-additional-networks ./stable-diffusion-webui/extensions/sd-webui-additional-networks
# a1111-sd-webui-tagcomplete
git clone https://ghproxy.com/https://github.com/DominikDoom/a1111-sd-webui-tagcomplete ./stable-diffusion-webui/extensions/a1111-sd-webui-tagcomplete
# multidiffusion-upscaler-for-automatic1111
git clone https://ghproxy.com/https://github.com/pkuliyi2015/multidiffusion-upscaler-for-automatic1111 ./stable-diffusion-webui/extensions/multidiffusion-upscaler-for-automatic1111
# sd-dynamic-thresholding
git clone https://ghproxy.com/https://github.com/mcmonkeyprojects/sd-dynamic-thresholding ./stable-diffusion-webui/extensions/sd-dynamic-thresholding
# sd-webui-cutoff
git clone https://ghproxy.com/https://github.com/hnmr293/sd-webui-cutoff ./stable-diffusion-webui/extensions/sd-webui-cutoff
# sd-webui-model-converter
git clone https://ghproxy.com/https://github.com/Akegarasu/sd-webui-model-converter ./stable-diffusion-webui/extensions/sd-webui-model-converter
# sd-webui-supermerger
git clone https://ghproxy.com/https://github.com/hako-mikan/sd-webui-supermerger ./stable-diffusion-webui/extensions/sd-webui-supermerger
# stable-diffusion-webui-localization-zh_CN
git clone https://ghproxy.com/https://github.com/dtlnor/stable-diffusion-webui-localization-zh_CN ./stable-diffusion-webui/extensions/stable-diffusion-webui-localization-zh_CN
# stable-diffusion-webui-wd14-tagger
git clone https://ghproxy.com/https://github.com/tsukimiya/stable-diffusion-webui-wd14-tagger ./stable-diffusion-webui/extensions/stable-diffusion-webui-wd14-tagger
# sd-webui-regional-prompter
git clone https://ghproxy.com/https://github.com/hako-mikan/sd-webui-regional-prompter ./stable-diffusion-webui/extensions/sd-webui-regional-prompter
# stable-diffusion-webui-baidu-netdisk
git clone https://ghproxy.com/https://github.com/zanllp/stable-diffusion-webui-baidu-netdisk ./stable-diffusion-webui/extensions/stable-diffusion-webui-baidu-netdisk
# stable-diffusion-webui-anti-burn
git clone https://ghproxy.com/https://github.com/klimaleksus/stable-diffusion-webui-anti-burn ./stable-diffusion-webui/extensions/stable-diffusion-webui-anti-burn
# loopback_scaler
git clone https://ghproxy.com/https://github.com/Elldreth/loopback_scaler.git ./stable-diffusion-webui/extensions/loopback_scaler
# latentcoupleregionmapper
git clone https://ghproxy.com/https://github.com/CodeZombie/latentcoupleregionmapper.git ./stable-diffusion-webui/extensions/latentcoupleregionmapper
# ultimate-upscale-for-automatic1111
git clone https://ghproxy.com/https://github.com/Coyote-A/ultimate-upscale-for-automatic1111.git ./stable-diffusion-webui/extensions/ultimate-upscale-for-automatic1111
# deforum-for-automatic1111-webui
git clone https://ghproxy.com/https://github.com/deforum-art/deforum-for-automatic1111-webui ./stable-diffusion-webui/extensions/deforum-for-automatic1111-webui
mkdir ./stable-diffusion-webui/extensions/deforum-for-automatic1111-webui/models
# stable-diffusion-webui-images-browser
git clone https://ghproxy.com/https://github.com/AlUlkesh/stable-diffusion-webui-images-browser ./stable-diffusion-webui/extensions/stable-diffusion-webui-images-browser
# stable-diffusion-webui-huggingface
git clone https://ghproxy.com/https://github.com/camenduru/stable-diffusion-webui-huggingface ./stable-diffusion-webui/extensions/stable-diffusion-webui-huggingface
# sd-civitai-browser
git clone -b v2.0 https://ghproxy.com/https://github.com/camenduru/sd-civitai-browser ./stable-diffusion-webui/extensions/sd-civitai-browser
# sd-webui-additional-networks
git clone https://ghproxy.com/https://github.com/kohya-ss/sd-webui-additional-networks ./stable-diffusion-webui/extensions/sd-webui-additional-networks
# openpose-editor
git clone https://ghproxy.com/https://github.com/camenduru/openpose-editor ./stable-diffusion-webui/extensions/openpose-editor
# sd-webui-depth-lib
git clone https://ghproxy.com/https://github.com/jexom/sd-webui-depth-lib ./stable-diffusion-webui/extensions/sd-webui-depth-lib
# posex
git clone https://ghproxy.com/https://github.com/hnmr293/posex ./stable-diffusion-webui/extensions/posex
# sd-webui-tunnels
git clone https://ghproxy.com/https://github.com/camenduru/sd-webui-tunnels ./stable-diffusion-webui/extensions/sd-webui-tunnels
# batchlinks-webui
git clone https://ghproxy.com/https://github.com/etherealxx/batchlinks-webui ./stable-diffusion-webui/extensions/batchlinks-webui
# stable-diffusion-webui-catppuccin
git clone https://ghproxy.com/https://github.com/camenduru/stable-diffusion-webui-catppuccin ./stable-diffusion-webui/extensions/stable-diffusion-webui-catppuccin
# a1111-sd-webui-locon
git clone https://ghproxy.com/https://github.com/KohakuBlueleaf/a1111-sd-webui-locon ./stable-diffusion-webui/extensions/a1111-sd-webui-locon
# stable-diffusion-webui-rembg
git clone https://ghproxy.com/https://github.com/AUTOMATIC1111/stable-diffusion-webui-rembg ./stable-diffusion-webui/extensions/stable-diffusion-webui-rembg
# stable-diffusion-webui-two-shot
git clone https://ghproxy.com/https://github.com/ashen-sensored/stable-diffusion-webui-two-shot ./stable-diffusion-webui/extensions/stable-diffusion-webui-two-shot
# sd-webui-lora-block-weight
git clone https://ghproxy.com/https://github.com/hako-mikan/sd-webui-lora-block-weight ./stable-diffusion-webui/extensions/sd-webui-lora-block-weight
# sd-face-editor
git clone https://ghproxy.com/https://github.com/ototadana/sd-face-editor ./stable-diffusion-webui/extensions/sd-face-editor
# controlnet
git clone https://ghproxy.com/https://github.com/Mikubill/sd-webui-controlnet ./stable-diffusion-webui/extensions/sd-webui-controlnet
##controlnet插件的相关模型
aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/ckpt/ControlNet/resolve/main/control_canny-fp16.safetensors -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o control_canny-fp16.safetensors
aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/ckpt/ControlNet/resolve/main/control_depth-fp16.safetensors -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o control_depth-fp16.safetensors
aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/ckpt/ControlNet/resolve/main/control_hed-fp16.safetensors -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o control_hed-fp16.safetensors
aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/ckpt/ControlNet/resolve/main/control_mlsd-fp16.safetensors -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o control_mlsd-fp16.safetensors
aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/ckpt/ControlNet/resolve/main/control_normal-fp16.safetensors -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o control_normal-fp16.safetensors
aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/ckpt/ControlNet/resolve/main/control_openpose-fp16.safetensors -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o control_openpose-fp16.safetensors
aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/ckpt/ControlNet/resolve/main/control_scribble-fp16.safetensors -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o control_scribble-fp16.safetensors
aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/ckpt/ControlNet/resolve/main/control_seg-fp16.safetensors -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o control_seg-fp16.safetensors
aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/ckpt/ControlNet/resolve/main/hand_pose_model.pth -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/annotator/openpose -o hand_pose_model.pth
aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/ckpt/ControlNet/resolve/main/body_pose_model.pth -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/annotator/openpose -o body_pose_model.pth
aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/ckpt/ControlNet/resolve/main/dpt_hybrid-midas-501f0c75.pt -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/annotator/midas -o dpt_hybrid-midas-501f0c75.pt
aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/ckpt/ControlNet/resolve/main/mlsd_large_512_fp32.pth -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/annotator/mlsd -o mlsd_large_512_fp32.pth
aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/ckpt/ControlNet/resolve/main/mlsd_tiny_512_fp32.pth -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/annotator/mlsd -o mlsd_tiny_512_fp32.pth
aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/ckpt/ControlNet/resolve/main/network-bsds500.pth -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/annotator/hed -o network-bsds500.pth
aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/ckpt/ControlNet/resolve/main/upernet_global_small.pth -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/annotator/uniformer -o upernet_global_small.pth
aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/ckpt/ControlNet/resolve/main/t2iadapter_style_sd14v1.pth -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o t2iadapter_style_sd14v1.pth
aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/ckpt/ControlNet/resolve/main/t2iadapter_sketch_sd14v1.pth -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o t2iadapter_sketch_sd14v1.pth
aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/ckpt/ControlNet/resolve/main/t2iadapter_seg_sd14v1.pth -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o t2iadapter_seg_sd14v1.pth
aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/ckpt/ControlNet/resolve/main/t2iadapter_openpose_sd14v1.pth -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o t2iadapter_openpose_sd14v1.pth
aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/ckpt/ControlNet/resolve/main/t2iadapter_keypose_sd14v1.pth -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o t2iadapter_keypose_sd14v1.pth
aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/ckpt/ControlNet/resolve/main/t2iadapter_depth_sd14v1.pth -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o t2iadapter_depth_sd14v1.pth
aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/ckpt/ControlNet/resolve/main/t2iadapter_color_sd14v1.pth -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o t2iadapter_color_sd14v1.pth
aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/ckpt/ControlNet/resolve/main/t2iadapter_canny_sd14v1.pth -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o t2iadapter_canny_sd14v1.pth

#下载模型
aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/andite/anything-v4.0/resolve/main/anything-v4.0-pruned-fp16.safetensors -d ./stable-diffusion-webui/models/Stable-diffusion -o anything-v4.0-pruned-fp16.safetensors
aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/andite/anything-v4.0/resolve/main/anything-v4.0.vae.pt -d ./stable-diffusion-webui/models/VAE -o anything-v4.0.vae.pt

echo "安装结束"
