AI 软件的目录说明：
在启用虚拟环境后，在安装时 AI 软件的目录下会产生 venv 文件夹，这个是 Python 软件包安装的目录
AI 软件自动下载部分模型（如 Clip，U2Net 模型）将储存在 Term-SD 目录中，可在 <Term-SD所在目录>/term-sd/cache 中查看


Stable Diffusion WebUI 目录的说明（只列举比较重要的）：
stable-diffusion-webui
├── embeddings              Embeddings 模型存放位置
├── extensions              插件存放位置
├── launch.py               Term-SD 启动 Stable Diffusion WebUI 的方法
├── config.json             Stable Diffusion WebUI的配置文件，需要重置设置时删除该文件即可
├── params.txt              上次生图参数
├── ui-config.json          界面设置
├── styles.csv              提示词预设
├── cache.json              模型 Hash 缓存
├── outputs                 生成图片的保存位置
└── models                  模型存放目录
    ├── ESRGAN              放大模型存放位置
    ├── GFPGAN              放大模型存放位置
    ├── hypernetworks       Hypernetworks 模型存放位置
    ├── Lora                Lora 模型存放位置
    ├── RealESRGAN          放大模型存放位置
    ├── Stable-diffusion    大模型存放位置
    └── VAE                 VAE 模型存放位置


ComfyUI目录的部分说明（只列举比较重要的）：
ComfyUI
├── custom_nodes            自定义节点存放位置
├── main.py                 Term-SD 启动 ComfyUI 的方法
├── models                  模型存放位置
│   ├── checkpoints         大模型存放位置
│   ├── controlnet          ControlNet 模型存放位置
│   ├── embeddings          Embeddings 模型存放位置
│   ├── hypernetworks       Hypernetworks模型存放位置
│   ├── loras               Lora 模型存放位置
│   ├── upscale_models      放大模型存放位置
│   └── vae                 VAE 模型存放位置
├── output                  生成图片的保存位置
└── web
    └── extensions          插件存放位置


InvokeAI目录的部分说明（只列举比较重要的）：
├── configs                 配置文件存放目录
├── invokeai.yaml           主要配置文件，需要重置设置时删除该文件即可
├── models                  模型存放位置
│   ├── core
│   │   └── upscaling
│   │       └── realesrgan  放大模型存放位置
│   ├── sd-1                SD 1.5 模型的存放位置
│   │   ├── controlnet      ControlNet 模型存放位置
│   │   ├── embedding       Embeddings 模型存放位置
│   │   ├── lora            Lora 模型存放位置
│   │   ├── main
│   │   ├── onnx
│   │   └── vae             VAE 模型存放位置
│   ├── sd-2                SD 2.x 模型的存放位置
│   │   ├── controlnet
│   │   ├── embedding
│   │   ├── lora
│   │   ├── main
│   │   ├── onnx
│   │   └── vae
│   ├── sdxl                SDXL 模型的存放位置
│   │   ├── controlnet
│   │   ├── embedding
│   │   ├── lora
│   │   ├── main
│   │   ├── onnx
│   │   └── vae
│   └── sdxl-refiner        SDXL Refind 模型的存放位置
│       ├── controlnet
│       ├── embedding
│       ├── lora
│       ├── main
│       ├── onnx
│       └── vae
└── outputs                 生成图片的存放位置


Fooocus目录的部分说明（只列举比较重要的）：
Fooocus
├── launch.py               Term-SD 启动 Fooocus 的方法
├── models                  模型存放位置
│   ├── checkpoints         大模型存放位置
│   ├── controlnet          ControlNet 模型存放位置
│   ├── embeddings          Embeddings 模型存放位置
│   ├── hypernetworks       Hypernetworks 模型存放位置
│   ├── loras               Lora 模型存放位置
│   ├── upscale_models      放大模型存放位置
│   └── vae                 VAE 模型存放位置
├── output                  生成图片的保存位置
└── config.txt              配置文件保存路径


lora-scripts目录的部分说明（只列举比较重要的）：
lora-scripts
├── config
│   └── autosave            训练参数保存路径
├── gui.py                  Term-SD 启动 lora-scripts 的方法
├── logs                    日志存放位置
├── output                  训练得到的模型存放位置
└── sd-models               训练所用的底模存放位置


kohya_ss目录的部分说明（只列举比较重要的）：
kohya_ss
├── output                  模型保存路径
├── sd-models               训练底模路径
└── train                   训练集路径