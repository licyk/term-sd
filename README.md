# term-sd
基于whiptail实现界面显示的管理器，支持安装，管理A1111-SD-Webui,ComfyUI.InvokeAI(未完全支持),lora-scripts

需安装aria2,python,pip,git,whiptail

使用方法：

aria2c https://ghproxy.com/https://raw.githubusercontent.com/licyk/sd-webui-scipt/main/term-sd.sh

chmod +x term-sd.sh

./term-sd.sh

# sd-webui-for-colab

脚本修改自https://github.com/camenduru/stable-diffusion-webui-colab

加入一些模型和插件，更换了xformers、cuda、torch版本

[![Open In Colab](https://colab.research.google.com/assets/colab-badge.svg)](https://colab.research.google.com/github/licyk/sd-webui-scipt/blob/main/stable_diffusion_webui_colab.ipynb)(stable)

[![Open In Colab](https://colab.research.google.com/assets/colab-badge.svg)](https://colab.research.google.com/github/licyk/sd-webui-scipt/blob/main/fast_stable_diffusion.ipynb)(for  colab free user)

# stable-diffusion-webui-install

stable diffusion本地部署脚本

使用前请确保已安装python、git、aria2

stable-diffusion-webui-install.sh为无github代理的版本

stable-diffusion-webui-install-proxy.sh添加了github代理，在国内环境下载更快

update.sh为一键更新sd-webui脚本，用于更新stable diffusion本体和插件，请将该脚本放入stable-diffusion-webui目录下再运行
