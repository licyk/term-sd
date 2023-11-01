AI软件的目录说明：
在启用venv虚拟环境后，在安装时AI软件的目录下会产生venv文件夹，这个是python软件包安装的目录
ai软件自动下载部分模型（如clip，u2net模型）将储存在Term-SD目录中，可在<Term-SD所在目录>/term-sd/cache中查看


stable diffusion webui目录的说明（只列举比较重要的）：
stable-diffusion-webui
├── embeddings   embeddings模型存放位置
├── extensions   插件存放位置
├── launch.py    term-sd启动sd-webui的方法
├── config.json  stable-diffusion-webui的配置文件，需要重置设置时删除该文件即可
├── outputs   生成图片的保存位置
└── models    模型存放目录
    ├── ESRGAN    放大模型存放位置
    ├── GFPGAN    放大模型存放位置
    ├── hypernetworks    hypernetworks模型存放位置
    ├── Lora    Lora模型存放位置
    ├── RealESRGAN    放大模型存放位置
    ├── Stable-diffusion    大模型存放位置
    └── VAE    VAE模型存放位置


ComfyUI目录的部分说明（只列举比较重要的）：
ComfyUI
├── custom_nodes   自定义节点存放位置
├── main.py        term-sd启动ComfyUI的方法
├── models         模型存放位置
│   ├── checkpoints    大模型存放位置
│   ├── controlnet   controlnet模型存放位置
│   ├── embeddings   embeddings模型存放位置
│   ├── hypernetworks   hypernetworks模型存放位置
│   ├── loras   Lora模型存放位置
│   ├── upscale_models   放大模型存放位置
│   └── vae   VAE模型存放位置
├── output   生成图片的保存位置
└── web
    └── extensions   插件存放位置


InvokeAI目录的部分说明（只列举比较重要的）：
├── configs   配置文件存放目录
├── invokeai.yaml   主要配置文件，需要重置设置时删除该文件即可
├── models   模型存放位置
│   ├── core
│   │   └── upscaling
│   │       └── realesrgan   放大模型存放位置
│   ├── sd-1   sd1.5模型的存放位置
│   │   ├── controlnet   controlnet模型存放位置
│   │   ├── embedding   embeddings模型存放位置
│   │   ├── lora   Lora模型存放位置
│   │   ├── main
│   │   ├── onnx
│   │   └── vae   VAE模型存放位置
│   ├── sd-2
│   │   ├── controlnet
│   │   ├── embedding
│   │   ├── lora
│   │   ├── main
│   │   ├── onnx
│   │   └── vae
│   ├── sdxl
│   │   ├── controlnet
│   │   ├── embedding
│   │   ├── lora
│   │   ├── main
│   │   ├── onnx
│   │   └── vae
│   └── sdxl-refiner
│       ├── controlnet
│       ├── embedding
│       ├── lora
│       ├── main
│       ├── onnx
│       └── vae
└── outputs   生成图片的存放位置


Fooocus目录的部分说明（只列举比较重要的）：
Fooocus
├── launch.py        term-sd启动Fooocus的方法
├── models         模型存放位置
│   ├── checkpoints    大模型存放位置
│   ├── controlnet   controlnet模型存放位置
│   ├── embeddings   embeddings模型存放位置
│   ├── hypernetworks   hypernetworks模型存放位置
│   ├── loras   Lora模型存放位置
│   ├── upscale_models   放大模型存放位置
│   └── vae   VAE模型存放位置
├── output   生成图片的保存位置


lora-scripts目录的部分说明（只列举比较重要的）：
lora-scripts
├── gui.py   term-sd启动lora-scripts的方法
├── logs   日志存放位置
├── output   训练得到的模型存放位置
├── sd-models   训练所用的底模存放位置
└── toml   保存的训练参数存放位置

