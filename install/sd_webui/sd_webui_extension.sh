__term_sd_task_pre_ext_1 git_clone_repository ${github_mirror} https://github.com/WSH032/kohya-config-webui stable-diffusion-webui/extensions OFF # 一个用于生成kohya-ss训练脚本使用的toml配置文件的WebUI
__term_sd_task_pre_ext_2 git_clone_repository ${github_mirror} https://github.com/kohya-ss/sd-webui-additional-networks stable-diffusion-webui/extensions OFF # 将LoRA等模型添加到stablediffusion以生成图像的扩展
__term_sd_task_pre_ext_3 git_clone_repository ${github_mirror} https://github.com/DominikDoom/a1111-sd-webui-tagcomplete stable-diffusion-webui/extensions ON # 输入Tag时提供booru风格（如Danbooru）的TAG自动补全
__term_sd_task_pre_ext_4 git_clone_repository ${github_mirror} https://github.com/pkuliyi2015/multidiffusion-upscaler-for-automatic1111 stable-diffusion-webui/extensions ON # 在有限的显存中进行大型图像绘制，提供图片区域控制
__term_sd_task_pre_ext_5 git_clone_repository ${github_mirror} https://github.com/mcmonkeyprojects/sd-dynamic-thresholding stable-diffusion-webui/extensions ON # 解决使用更高的CFGScale而出现颜色问题
__term_sd_task_pre_ext_6 git_clone_repository ${github_mirror} https://github.com/hnmr293/sd-webui-cutoff stable-diffusion-webui/extensions ON # 解决tag污染
__term_sd_task_pre_ext_7 git_clone_repository ${github_mirror} https://github.com/Akegarasu/sd-webui-model-converter stable-diffusion-webui/extensions ON # 模型转换扩展
__term_sd_task_pre_ext_8 git_clone_repository ${github_mirror} https://github.com/hako-mikan/sd-webui-supermerger stable-diffusion-webui/extensions ON # 模型转换扩展
__term_sd_task_pre_ext_9 git_clone_repository ${github_mirror} https://github.com/hanamizuki-ai/stable-diffusion-webui-localization-zh_Hans stable-diffusion-webui/extensions ON # WEBUI中文扩展
__term_sd_task_pre_ext_10 git_clone_repository ${github_mirror} https://github.com/picobyte/stable-diffusion-webui-wd14-tagger stable-diffusion-webui/extensions ON # 图片tag反推
__term_sd_task_pre_ext_11 git_clone_repository ${github_mirror} https://github.com/hako-mikan/sd-webui-regional-prompter stable-diffusion-webui/extensions ON # 图片区域分割
__term_sd_task_pre_ext_12 git_clone_repository ${github_mirror} https://github.com/zanllp/sd-webui-infinite-image-browsing stable-diffusion-webui/extensions ON # 强大的图像管理器
__term_sd_task_pre_ext_13 git_clone_repository ${github_mirror} https://github.com/klimaleksus/stable-diffusion-webui-anti-burn stable-diffusion-webui/extensions ON # 通过跳过最后几个步骤并将它们之前的一些图像平均在一起来平滑生成的图像，加快点击停止生成图像后WEBUI的响应速度
__term_sd_task_pre_ext_14 git_clone_repository ${github_mirror} https://github.com/Elldreth/loopback_scaler stable-diffusion-webui/extensions OFF # 使用迭代过程增强图像分辨率和质量
__term_sd_task_pre_ext_15 git_clone_repository ${github_mirror} https://github.com/CodeZombie/latentcoupleregionmapper stable-diffusion-webui/extensions ON # 控制绘制和定义区域
__term_sd_task_pre_ext_16 git_clone_repository ${github_mirror} https://github.com/Coyote-A/ultimate-upscale-for-automatic1111 stable-diffusion-webui/extensions ON # 图片放大工具
__term_sd_task_pre_ext_17 git_clone_repository ${github_mirror} https://github.com/deforum-art/deforum-for-automatic1111-webui stable-diffusion-webui/extensions OFF # 视频生成插件
__term_sd_task_pre_ext_18 git_clone_repository ${github_mirror} https://github.com/AlUlkesh/stable-diffusion-webui-images-browser stable-diffusion-webui/extensions ON # 图像管理器
__term_sd_task_pre_ext_19 git_clone_repository ${github_mirror} https://github.com/camenduru/stable-diffusion-webui-huggingface stable-diffusion-webui/extensions OFF # huggingface模型下载扩展
__term_sd_task_pre_ext_20 git_clone_repository ${github_mirror} https://github.com/camenduru/sd-civitai-browser stable-diffusion-webui/extensions OFF # civitai模型下载扩展
__term_sd_task_pre_ext_21 git_clone_repository ${github_mirror} https://github.com/space-nuko/a1111-stable-diffusion-webui-vram-estimator stable-diffusion-webui/extensions OFF # 显存占用评估
__term_sd_task_pre_ext_22 git_clone_repository ${github_mirror} https://github.com/fkunn1326/openpose-editor stable-diffusion-webui/extensions ON # openpose姿势编辑
__term_sd_task_pre_ext_23 git_clone_repository ${github_mirror} https://github.com/jexom/sd-webui-depth-lib stable-diffusion-webui/extensions OFF # 深度图库，用于Automatic1111/stable-diffusion-webui的controlnet扩展
__term_sd_task_pre_ext_24 git_clone_repository ${github_mirror} https://github.com/hnmr293/posex stable-diffusion-webui/extensions OFF # openpose姿势编辑
__term_sd_task_pre_ext_25 git_clone_repository ${github_mirror} https://github.com/camenduru/sd-webui-tunnels stable-diffusion-webui/extensions OFF # WEBUI端口映射扩展
__term_sd_task_pre_ext_26 git_clone_repository ${github_mirror} https://github.com/etherealxx/batchlinks-webui stable-diffusion-webui/extensions OFF # 批处理链接下载器
__term_sd_task_pre_ext_27 git_clone_repository ${github_mirror} https://github.com/camenduru/stable-diffusion-webui-catppuccin stable-diffusion-webui/extensions ON # WEBUI主题
__term_sd_task_pre_ext_28 git_clone_repository ${github_mirror} https://github.com/KohakuBlueleaf/a1111-sd-webui-lycoris stable-diffusion-webui/extensions OFF # 添加lycoris模型支持
__term_sd_task_pre_ext_29 git_clone_repository ${github_mirror} https://github.com/AUTOMATIC1111/stable-diffusion-webui-rembg stable-diffusion-webui/extensions ON # 人物背景去除
__term_sd_task_pre_ext_30 git_clone_repository ${github_mirror} https://github.com/ashen-sensored/stable-diffusion-webui-two-shot stable-diffusion-webui/extensions ON # 图片区域分割和控制
__term_sd_task_pre_ext_31 git_clone_repository ${github_mirror} https://github.com/hako-mikan/sd-webui-lora-block-weight stable-diffusion-webui/extensions ON # lora分层扩展
__term_sd_task_pre_ext_32 git_clone_repository ${github_mirror} https://github.com/ototadana/sd-face-editor stable-diffusion-webui/extensions OFF # 面部编辑器
__term_sd_task_pre_ext_33 git_clone_repository ${github_mirror} https://github.com/continue-revolution/sd-webui-segment-anything stable-diffusion-webui/extensions OFF # 图片语义分割
__term_sd_task_pre_ext_34 git_clone_repository ${github_mirror} https://github.com/Mikubill/sd-webui-controlnet stable-diffusion-webui/extensions ON # 图片生成控制
__term_sd_task_pre_ext_35 git_clone_repository ${github_mirror} https://github.com/Physton/sd-webui-prompt-all-in-one stable-diffusion-webui/extensions ON # tag翻译和管理插件
__term_sd_task_pre_ext_36 git_clone_repository ${github_mirror} https://github.com/ModelSurge/sd-webui-comfyui stable-diffusion-webui/extensions OFF # 在WEBUI添加ComfyUI界面
__term_sd_task_pre_ext_37 git_clone_repository ${github_mirror} https://github.com/continue-revolution/sd-webui-animatediff stable-diffusion-webui/extensions OFF # GIF生成扩展
__term_sd_task_pre_ext_38 git_clone_repository ${github_mirror} https://github.com/yankooliveira/sd-webui-photopea-embed stable-diffusion-webui/extensions ON # 在WEBUI界面添加ps功能
__term_sd_task_pre_ext_39 git_clone_repository ${github_mirror} https://github.com/huchenlei/sd-webui-openpose-editor stable-diffusion-webui/extensions ON # ControlNet的pose编辑器
__term_sd_task_pre_ext_40 git_clone_repository ${github_mirror} https://github.com/hnmr293/sd-webui-llul stable-diffusion-webui/extensions ON # 给图片的选定区域增加细节
__term_sd_task_pre_ext_41 git_clone_repository ${github_mirror} https://github.com/journey-ad/sd-webui-bilingual-localization stable-diffusion-webui/extensions OFF # WEBUI双语对照翻译插件
__term_sd_task_pre_ext_42 git_clone_repository ${github_mirror} https://github.com/Bing-su/adetailer stable-diffusion-webui/extensions ON # 图片细节修复扩展
__term_sd_task_pre_ext_43 git_clone_repository ${github_mirror} https://github.com/Scholar01/sd-webui-mov2mov stable-diffusion-webui/extensions OFF # 视频逐帧处理插件
__term_sd_task_pre_ext_44 git_clone_repository ${github_mirror} https://github.com/ClockZinc/sd-webui-IS-NET-pro stable-diffusion-webui/extensions OFF # 人物抠图
__term_sd_task_pre_ext_45 git_clone_repository ${github_mirror} https://github.com/s9roll7/ebsynth_utility stable-diffusion-webui/extensions OFF # 视频处理扩展
__term_sd_task_pre_ext_46 git_clone_repository ${github_mirror} https://github.com/d8ahazard/sd_dreambooth_extension stable-diffusion-webui/extensions OFF # dreambooth模型训练
__term_sd_task_pre_ext_47 git_clone_repository ${github_mirror} https://github.com/Haoming02/sd-webui-memory-release stable-diffusion-webui/extensions ON # 显存释放扩展
__term_sd_task_pre_ext_48 git_clone_repository ${github_mirror} https://github.com/toshiaki1729/stable-diffusion-webui-dataset-tag-editor stable-diffusion-webui/extensions OFF # 训练集打标和处理扩展
__term_sd_task_pre_ext_49 git_clone_repository ${github_mirror} https://github.com/pkuliyi2015/sd-webui-stablesr stable-diffusion-webui/extensions OFF # 图片放大
__term_sd_task_pre_ext_50 git_clone_repository ${github_mirror} https://github.com/SpenserCai/sd-webui-deoldify stable-diffusion-webui/extensions OFF # 黑白图片上色
__term_sd_task_pre_ext_51 git_clone_repository ${github_mirror} https://github.com/arenasys/stable-diffusion-webui-model-toolkit stable-diffusion-webui/extensions ON # 大模型数据查看
__term_sd_task_pre_ext_52 git_clone_repository ${github_mirror} https://github.com/Bobo-1125/sd-webui-oldsix-prompt-dynamic stable-diffusion-webui/extensions OFF # 动态提示词
__term_sd_task_pre_ext_53 git_clone_repository ${github_mirror} https://github.com/Artiprocher/sd-webui-fastblend stable-diffusion-webui/extensions OFF # ai视频平滑
__term_sd_task_pre_ext_54 git_clone_repository ${github_mirror} https://github.com/ahgsql/StyleSelectorXL stable-diffusion-webui/extensions OFF # SDXL模型画风选择
__term_sd_task_pre_ext_55 git_clone_repository ${github_mirror} https://github.com/adieyal/sd-dynamic-prompts stable-diffusion-webui/extensions OFF # 动态提示词
__term_sd_task_pre_ext_56 git_clone_repository ${github_mirror} https://github.com/Tencent/LightDiffusionFlow stable-diffusion-webui/extensions ON # 保存工作流
__term_sd_task_pre_ext_57 git_clone_repository ${github_mirror} https://github.com/Scholar01/sd-webui-workspace stable-diffusion-webui/extensions ON # 保存webui生图的参数
__term_sd_task_pre_ext_58 git_clone_repository --submod ${github_mirror} https://github.com/zero01101/openOutpaint-webUI-extension stable-diffusion-webui/extensions OFF # 提供类似InvokeAI的统一画布的功能
__term_sd_task_pre_ext_59 git_clone_repository ${github_mirror} https://github.com/aigc-apps/sd-webui-EasyPhoto stable-diffusion-webui/extensions OFF # 以简单的操作生成自己的ai人像
__term_sd_task_pre_ext_60 git_clone_repository ${github_mirror} https://github.com/Haoming02/sd-webui-boomer stable-diffusion-webui/extensions ON # 恢复新版webui已经移除的按钮
__term_sd_task_pre_ext_61 git_clone_repository ${github_mirror} https://github.com/mix1009/model-keyword stable-diffusion-webui/extensions ON # 用于补全模型对应的提示词，比如使用lora模型的提示词
__term_sd_task_pre_ext_62 git_clone_repository ${github_mirror} https://github.com/NVIDIA/Stable-Diffusion-WebUI-TensorRT stable-diffusion-webui/extensions OFF # nvidia官方加速工具，加速图片生成
__term_sd_task_pre_ext_63 git_clone_repository ${github_mirror} https://github.com/lobehub/sd-webui-lobe-theme stable-diffusion-webui/extensions OFF # webui主题

