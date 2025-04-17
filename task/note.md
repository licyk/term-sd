## Term-SD 定义的命令队列标识
```
__term_sd_task_ # 可识别的关键字
```
## Term-SD 队列命令格式
```
<标识关键字> <命令>
```
在执行的过程，Term-SD将会把标识去除，得到命令

## Term-SD 执行安装任务时的标识
```
__term_sd_task_sys # Term-SD 一定执行命令的标识
__term_sd_task_pre # Term-SD 待执行命令的标识
__term_sd_task_done # Term-SD 执行命令完成后修改成的标识
```

## Term-SD对模型，插件的标识
```
__term_sd_task_pre_model # 表示模型
__term_sd_task_pre_ext_1 # 表示插件 (也可以标识插件所属的模型)
```

执行完成后将变成如下的标识
```
__term_sd_task_done_model
__term_sd_task_done_ext
```


## Term-SD队列命令格式例子
- 模型
```
__term_sd_task_pre_model aria https://huggingface.co/xxxxxxx -d ./ssss/sss -o file.pt
__term_sd_task_pre_model get_modelscope_model 123/345/456 ./qwer
```

- 插件
```
__term_sd_task_pre_ext_1 git_clone_repository <链接格式> <原链接> <下载路径>
```

## Term-SD 的安装选择列表
使用`./build.sh --build`可生成 Dialog 可使用的列表，在安装界面中提供选择  
这里列举`build.sh`处理不同类型的例子

- 插件

这是原始文件
```
__term_sd_task_pre_ext_1 git_clone_repository https://github.com/WSH032/kohya-config-webui "$SD_WEBUI_ROOT_PATH"/extensions OFF # 一个用于生成kohya-ss训练脚本使用的toml配置文件的WebUI
__term_sd_task_pre_ext_2 git_clone_repository https://github.com/kohya-ss/sd-webui-additional-networks "$SD_WEBUI_ROOT_PATH"/extensions OFF # 将LoRA等模型添加到stablediffusion以生成图像的扩展
__term_sd_task_pre_ext_58 git_clone_repository https://github.com/zero01101/openOutpaint-webUI-extension "$SD_WEBUI_ROOT_PATH"/extensions OFF # 提供类似InvokeAI的统一画布的功能
```

处理后会生成两个列表

>插件描述
```
1、kohya-config-webui：
描述：一个用于生成kohya-ss训练脚本使用的toml配置文件的WebUI
链接：https://github.com/WSH032/kohya-config-webui

2、sd-webui-additional-networks：
描述：将LoRA等模型添加到stablediffusion以生成图像的扩展
链接：https://github.com/kohya-ss/sd-webui-additional-networks

58、openOutpaint-webUI-extension：
描述：提供类似InvokeAI的统一画布的功能
链接：https://github.com/zero01101/openOutpaint-webUI-extension
```
>Dialog 可用的列表
```
__term_sd_task_pre_ext_1 kohya-config-webui OFF
__term_sd_task_pre_ext_2 sd-webui-additional-networks OFF
__term_sd_task_pre_ext_58 openOutpaint-webUI-extension OFF
```

- 插件的模型

这是原始文件
```
__term_sd_task_pre_ext_37 term_sd_echo "下载 AnimateDiff 模型" # AnimateDiff OFF
__term_sd_task_pre_ext_37 get_modelscope_model licyks/sd-extensions-model/master/sd-webui-animatediff/mm_sd_v15_v2.ckpt "$SD_WEBUI_ROOT_PATH"/extensions/sd-webui-animatediff/model

__term_sd_task_pre_ext_34 term_sd_echo "下载 ControlNet 模型中" # ControlNet ON
__term_sd_task_pre_ext_34 get_modelscope_model licyks/controlnet_v1.1/master/control_v11e_sd15_ip2p_fp16.safetensors "$SD_WEBUI_ROOT_PATH"/models/ControlNet
__term_sd_task_pre_ext_34 get_modelscope_model licyks/controlnet_v1.1/master/control_v11e_sd15_shuffle_fp16.safetensors "$SD_WEBUI_ROOT_PATH"/models/ControlNet
```

处理后得到 Dialog 可用的列表
>该列表由 Term-SD 实时生成，存储在变量中，非`build.sh`脚本生成
```
__term_sd_task_pre_ext_37 AnimateDiff OFF
__term_sd_task_pre_ext_34 ControlNet ON
```

- 模型

这是原始文件
```
__term_sd_task_pre_model_1 get_modelscope_model licyks/sd-model/master/sd_1.5/v1-5-pruned-emaonly.safetensors "$SD_WEBUI_ROOT_PATH"/models/Stable-diffusion # 大模型 v1-5-pruned-emaonly OFF
__term_sd_task_pre_model_2 get_modelscope_model licyks/sd-model/master/sd_1.5/animefull-final-pruned.safetensors "$SD_WEBUI_ROOT_PATH"/models/Stable-diffusion # animefull-final-pruned ON
__term_sd_task_pre_model_3 get_modelscope_model licyks/sd-model/master/sdxl_1.0/sd_xl_base_1.0_0.9vae.safetensors "$SD_WEBUI_ROOT_PATH"/models/Stable-diffusion # sd_xl_base_1.0_0.9vae OFF
```
处理后得到 Dialog 可用的列表
```
__term_sd_task_pre_model_1 v1-5-pruned-emaonly OFF
__term_sd_task_pre_model_2 animefull-final-pruned ON
__term_sd_task_pre_model_3 sd_xl_base_1.0_0.9vae OFF
```
### _原始文件需严格按照格式进行编写_