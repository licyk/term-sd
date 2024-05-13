# Tern-SD 使用教程

## Term-SD 的初始化
Term-SD 在下载好后，只会有一个基础的配置脚本`term-sd.sh`，当运行这个配置脚本时，Term-SD 会检测运行所需依赖。当检测到缺少依赖时，Term-SD 会提示用户需要去安装的依赖，并自动退出，这时候需要用户检查这些依赖是否安装，并且把缺失的依赖装上  
当检测到依赖都安装时，脚本会提示用户安装 Term-SD 的完整组件

这时候输入`y`即可进行下载  

在下载前。Term-SD 会询问选择哪个下载源  
总共有以下下载源：
- 1、Github 源
- 2、Gitee 源
- 3、Gitlab 源
- 4、Bitbucket 源

一般情况下选择任意一种都可以进行下载  
如果下载失败，Term-SD 将会自动退出，这时再次运行 Term-SD，选择其他下载源来重新下载  
当成功下载时，Term-SD 将会自动初始化模块，并启动

>[!NOTE]
>成功进入 Term-SD 的界面后，使用`方向键`、`Tab键`移动光标，`方向键`/`F`，`B`键翻页（鼠标滚轮无法翻页），`Enter键`进行选择，`Space键`勾选或取消勾选，（已勾选时显示`[*]`），`Ctrl+Shift+V`粘贴文本，`Ctrl+C`可中断指令的运行，`鼠标左键`可点击按钮（右键无效）

***

## Term-SD 的主界面介绍
Term-SD 在成功启动后，首先显示的是各个组件的版本信息，选择确定后就进入 Term-SD 的主界面  
主界面有以下选项
- 1、Term-SD 更新管理：管理，修复 Term-SD 的更新
- 2、Stable Diffusion WebUI 管理：包含各种 Stable Diffusion WebUI 的管理功能
- 3、ComfyUI 管理：包含各种 ComfyUI 的管理功能
- 4、InvokeAI 管理：包含各种 InvokeAI 的管理功能
- 5、Fooocus 管理：包含各种 Fooocus 的管理功能
- 6、lora-scripts 管理：包含各种 lora-scripts 的管理功能
- 7、kohya_ss 管理：包含各种 kohya_ss 的管理功能
- 7、Term-SD 设置：包含 Term-SD 各种设置
- 8、Term-SD 帮助：Term-SD 的各种帮助文档

***

## Term-SD 的准备功能
Term-SD 在使用安装、管理 AI 软件的功能时，会使用准备功能来对一些操作进行准备工作，共有以下功能
>[!NOTE]
>这些功能会经常出现

### 1、安装镜像选项
有以下选项：
- 1、启用 Pip 镜像源：Term-SD 调用 Pip 下载 Python 软件包时使用国内镜像源进行下载
- 2、使用全局 Pip 镜像源：使用 Term-SD 设置中配置的 Pip 镜像源，而不是安装准备界面中所选择的 Pip 镜像源
- 3、HuggingFace / Github独占代理：Term-SD 安装 AI 软件的过程仅为 HuggingFace / Github 下载源启用代理，减少代理流量的消耗
- 4、强制使用 Pip：强制使用 Pip 安装 Python 软件包，忽略系统的警告，一般只有在禁用虚拟环境后才需要启用
- 5、使用 Modelscope 模型下载源：将安装时使用的 HuggingFace 模型下载源改为 Modelscope 模型下载源（HuggingFace 在国内无法直接访问）
- 6、Github 镜像源自动选择：测试可用的 Github 镜像源并选择自动选择，选择该选项后将覆盖手动设置的 Github 镜像源
- 7、启用 Github 镜像源：Term-SD 从 Github 克隆源代码时使用 Github 镜像站进行克隆

一般这些选项保持默认即可

>[!NOTE]
>1、`强制使用pip`一般不需要启用，该选项向 Pip 传达`--break-system-packages`参数进行安装，忽略系统的警告，参考：https://stackoverflow.com/questions/75602063/pip-install-r-requirements-txt-is-failing-this-environment-is-externally-mana  
>2、在使用`虚拟网卡模式`或者`TUN模式`的代理软件时，`HuggingFace / Github 独占代理`功能无效，因为代理软件会强制让所有网络流量走代理  
>3、Github 镜像源有多个，可以根据 Term-SD 的`Term-SD 设置` -> `代理设置` -> `网络连接测试`的测试结果来选择，或者勾选`Github镜像源自动选择`让 Term-SD 自动选择  
>4、当所有 Github 镜像源都不可用时，只能把所有的`启用github镜像源`、`github镜像源自动选择`选项取消勾选

### 2、PyTorch 版本选项
有以下版本组合：
- 1、Torch + xFormers
- 2、Torch
- 3、Torch 2.0.0（Directml）
- 4、Torch 2.2.1 + CPU
- 5、Torch 2.0.1 + RoCM 5.4.2
- 6、Torch 2.1.0 + RoCM 5.6
- 7、Torch 2.2.1 + RoCM 5.7
- 8、Torch 2.3.0 + RoCM 6.0
- 9、Torch 2.0.0 + IPEX (Arc)
- 10、Torch 2.1.0 + IPEX (Arc)
- 11、Torch 2.1.0 + IPEX (Core Ultra)
- 12、Torch 1.12.1（CUDA11.3）+ xFormers 0.0.14
- 13、Torch 1.13.1（CUDA11.7）+ xFormers 0.0.16
- 14、Torch 2.0.0（CUDA11.8）+ xFormers 0.0.18
- 15、Torch 2.0.1（CUDA11.8）+ xFormers 0.0.22
- 16、Torch 2.1.1（CUDA11.8）+ xFormers 0.0.23
- 17、Torch 2.1.1（CUDA12.1）+ xFormers 0.0.23
- 18、Torch 2.1.2（CUDA11.8）+ xFormers 0.0.23.post1
- 19、Torch 2.1.2（CUDA12.1）+ xFormers 0.0.23.post1
- 20、Torch 2.2.0（CUDA11.8）+ xFormers 0.0.24
- 21、Torch 2.2.0（CUDA12.1）+ xFormers 0.0.24
- 22、Torch 2.2.1（CUDA11.8）+ xFormers 0.0.25
- 23、Torch 2.2.1（CUDA12.1）+ xFormers 0.0.25
- 24、Torch 2.2.2（CUDA11.8）+ xFormers 0.0.25.post1
- 25、Torch 2.2.2（CUDA12.1）+ xFormers 0.0.25.post1
- 26、Torch 2.3.0（CUDA11.8）+ xFormers 0.0.26.post1
- 27、Torch 2.3.0（CUDA12.1）+ xFormers 0.0.26.post1

选择版本时需要根据系统类型和显卡选择
- 在 Windows 系统中，Nvidia 显卡选择 Torch（CUDA）+ xFormers 的版本，AMD 显卡选择 Torch (Directml) 的版本，Intel 显卡选择 Torch + IPEX 的版本（核显选择 Core Ultra 版本，独显选择 Arc 版本）
- 在 Linux 系统中，Nvidia 显卡选择 Torch（CUDA）+ xFormers 的版本，AMD 显卡选择 Torch + RoCM 的版本，Intel 显卡选择 Torch + IPEX 版本
- 在 MacOS 系统中，选择 Torch 版本
- 如果想要使用 CPU 进行跑图，选择 Torch + CPU 的版本
- 一般来说找到对应显卡的型号后，选择最新版本的就行

### 3、Pip 安装模式选项
该功能用于选择 Pip 的安装模式，可解决某些情况下安装 Python 软件包失败的问题，如果不在意安装时间，可以选择标准构建安装（--use-pep517），保证安装成功；选择常规安装（setup.py）也可以，安装速度会比较快，但可能会出现安装失败的问题  
该界面共有2种模式可以选择
- 1、常规安装（setup.py）：使用传统方式进行安装，默认使用二进制软件包进行安装，速度较快
- 2、标准构建安装（--use-pep517）：使用标准编译安装，使用源码编译成二进制软件包再进行安装，耗时比较久，但可以解决一些 Python 软件包安装失败的问题

>[!NOTE]
>在 Linux 系统中使用常规安装（setup.py）可能会出现安装失败的问题，所以推荐使用标准构建安装（--use-pep517）

### 4、Pip 操作方式
该功能用于选择对 Python 软件包的操作方式  
该界面有以下选项
- 1、常规安装(install)：安装 Python 软件包并安装该软件包依赖的软件包
- 2、仅安装(--no-deps)：安装 Python 软件包，但不安装该软件包依赖的软件包
- 3、强制重装(--force-reinstall)：强制安装 Python 软件包，当该软件包已存在，则重新安装，且强制安装该软件包依赖的软件包
- 4、仅强制重装(--no-deps --force-reinstall)：强制安装 Python 软件包，当该软件包已存在，则重新安装，但不安装该软件包依赖的软件包
- 5、卸载(uninstall)：卸载 Python 软件包

当缺失某个软件包时，选择安装  
当某个软件包损坏时，可以选择强制重装  
如果需要卸载某个软件包，就选择卸载

>[!NOTE]
>该选项仅在`Python 软件包安装 / 重装 / 卸载`功能出现

### 5、Pip 强制重装选择
该功能用于在 Pip 发现将要安装的 Python 软件包已存在且版本相同时，是否强制重新安装  
该界面有以下选项
- 1、安装：正常安装 Python 软件包，当发现将要安装的 Python 软件包已存在且版本相同时，跳过安装
- 2、强制重装：当发现将要安装的 Python 软件包已存在且版本相同时，强制重新安装

### 6、安装确认选项
该功能用于展示部分安装信息，并确认是否安装

### 7、安装进度恢复选项
当 Term-SD 在因为某些原因中断安装进程时，再次进入管理界面即可恢复上次的安装进度（Term-SD 依然会从头遍历安装命令，但已经执行成功的命令将不会执行）  
该界面有以下选项
- 1、继续执行安装任务：继续之前中断的安装任务
- 2、重新设置安装参数并进行安装：删除之前的安装任务，并重新设置安装参数
- 3、删除安装任务并进入管理界面：删除之前的安装任务，并进入管理界面
- 4、跳过安装任务并进入管理界面：不删除之前的安装任务，并直接进入管理界面，但下一次进入管理界面时会弹出安装进度恢复选项

***

## 使用 Term-SD 安装 AI 软件前的准备
安装前，我们需要做一些准备

- 1、设置代理（可选，如果没有一个质量比较好的代理时就不要设置了）

如果用户有代理软件，并且代理的速度和稳定性较好，则先判断代理软件的代理工作模式，一般有`TUN模式`或者`虚拟网卡模式`的就不需要设置代理，因为这两种代理模式可以让终端环境走代理（其余模式不行）  
但是`TUN模式`或者`虚拟网卡模式`会让所有流量走代理，而 Term-SD 在安装 AI 软件的过程中只有部分下载源需要代理，这将会造成代理流量的浪费。所以，如果代理软件有其他代理模式，最好选这些的，并查看代理软件的代理协议、IP 和端口，然后在 Term-SD 主界面的`代理设置`里选择代理协议，填入 IP 和端口，回车保存，这样 Term-SD 就可以决定哪些流量需要走代理  
如果代理没有`TUN模式`或者`虚拟网卡模式`，则查看代理软件的代理协议、IP 和端口，然后在 Term-SD 设置的`代理设置`里选择代理协议，填入 IP 和端口，回车保存  

这里举例代理如何填写：
- (1)查找代理协议，IP，端口

查找代理软件为其他软件提供代理时使用的协议，一般来说 Http 和 Socks 比较常见（不是 Vless，SSR 这类协议，这类协议是用在代理软件和代理服务器之间传输数据的），然后查看代理的 IP 和端口，常见的 IP 和端口分别是 127.0.0.1 和 10809  
现在的得到以下信息了  
协议：`http`  
ip：`127.0.0.1`  
端口：`10809`

- (2)填入信息

打开 Term-SD`设置`，选择`代理设置`，这里询问选择协议，根据刚刚的得到的信息，选择`Http协议`，回车，在弹出的输入框中输入`127.0.0.1:10809`，回车保存

- (3)确认代理是否正常使用

在 Term-SD 的设置中，选择`网络连接测试`进行网络测试，当检测到 Google、HuggingFace 能够正常访问的时候，说明代理能够正常使用

>[!NOTE]
>在不使用代理后，需要在`代理设置`选择`删除代理参数`来清除代理，防止在代理软件关闭后出现 Term-SD 无法访问网络的问题  

- 2、设置 Pip 镜像源（推荐）

Term-SD 默认已配置该选项，可忽略

~~首先我们在 Term-SD 设置选择`Pip镜像源设置`，进入后可选择`官方源`和`国内镜像源`，这里非常推荐设置为`国内镜像源`（如果之前为 Pip 设置镜像源，包括 PyPI 源、PyTorch 源，则不需要再次设置`Pip镜像源`）~~  

- 3、设置安装重试功能（推荐）

Term-SD 默认已配置该选项，可忽略

~~在 Term-SD 设置选择`命令执行监测设置`，选择启用，输入重试次数（推荐 3），这时就设置好安装重试功能了，在安装 AI 软件时如果遇到网络不稳定导致命令执行的中断时，将会重新执行中断的命令，保证安装的顺利进行~~

- 4、设置 Github / HuggingFace 全局镜像源（可选，当没有代理时可尝试配置）

在 Term-SD 的设置中可以看到`Github 镜像源设置`和`HuggingFace 镜像源设置`，进入设置后可以看到不同的镜像源，可使用自动选择镜像源的功能来设置一个可用的镜像源。

进行上面的步骤后就可以进行 AI 软件的安装

***

## Term-SD 安装功能
Term-SD 支持 Stable Diffusion WebUI，ComfyUI，InvokeAI，Fooocus，lora-scripts，kohya_ss。在 Term-SD 的主界面对应下面的选项
- 1、Stable Diffusion WebUI 管理
- 2、ComfyUI 管理
- 3、InvokeAI 管理
- 4、Fooocus 管理
- 5、lora-scripts 管理
- 6、kohya_ss 管理

需要安装哪一种就选择哪一个管理选项

>[!NOTE]
>1、安装过程请保持网络通畅  
>2、当 AI 软件安装好后，能启动且无报错时，最好使用`依赖库版本管理`将依赖库的软件包版本备份下来，当AI软件因为软件包版本问题导致AI软件出现报错时就可以用这个功能恢复原来的依赖库版本
>3、Term-SD 支持自定义 AI 软件的安装目录，可以在 Term-SD 的`设置` -> `自定义安装路径`中进行设置

### Stable Diffusion WebUI 安装
>[!NOTE]
>Stable Diffusion WebUI 是一款功能丰富，社区资源丰富的 AI 绘画软件，支持扩展

选中Stable Diffusion WebUI 管理后，Term-SD 会检测该 AI 是否安装，如果没有安装，Term-SD 会提示用户是否进行安装  
选择`是`之后，Term-SD 会进入安装准备选项

#### 1、安装镜像选项
第一个是安装镜像选项，共有以下选项
- 1、启用 Pip 镜像源：Term-SD 调用 Pip 下载 Python 软件包时使用国内镜像源进行下载
- 2、使用全局 Pip 镜像源：使用 Term-SD 设置中配置的 Pip 镜像源，而不是安装准备界面中所选择的 Pip 镜像源
- 3、HuggingFace / Github独占代理：Term-SD 安装 AI 软件的过程仅为 HuggingFace / Github 下载源启用代理，减少代理流量的消耗
- 4、强制使用 Pip：强制使用 Pip 安装 Python 软件包，忽略系统的警告，一般只有在禁用虚拟环境后才需要启用
- 5、使用 Modelscope 模型下载源：将安装时使用的 HuggingFace 模型下载源改为 Modelscope 模型下载源（HuggingFace 在国内无法直接访问）
- 6、Github 镜像源自动选择：测试可用的 Github 镜像源并选择自动选择，选择该选项后将覆盖手动设置的 Github 镜像源
- 7、启用 Github 镜像源：Term-SD 从 Github 克隆源代码时使用 Github 镜像站进行克隆

一般这些选项保持默认即可

>[!NOTE]
>1、`强制使用pip`一般不需要启用，该选项向pip传达--break-system-packages参数进行安装，忽略系统的警告，参考https://stackoverflow.com/questions/75602063/pip-install-r-requirements-txt-is-failing-this-environment-is-externally-mana  
>2、在使用驱动模式或者TUN模式的代理软件时，`huggingface/github独占代理`功能无效，因为代理软件会强制让所有网络流量走代理  
>3、github镜像源有多个，可以根据Term-SD的`设置`->`网络连接测试`的测试结果来选择，或者勾选`github镜像源自动选择`让Term-SD自动选择  
>4、当所有github镜像源都不可用时，只能把所有的`启用github镜像源`、`github镜像源自动选择`选项取消勾选

#### 2、PyTorch 版本选择
第二个是PyTorch版本的选择界面，有以下版本组合
- 1、Torch + xFormers
- 2、Torch
- 3、Torch 2.0.0（Directml）
- 4、Torch 2.2.1 + CPU
- 5、Torch 2.0.1 + RoCM 5.4.2
- 6、Torch 2.1.0 + RoCM 5.6
- 7、Torch 2.2.1 + RoCM 5.7
- 8、Torch 2.3.0 + RoCM 6.0
- 9、Torch 2.0.0 + IPEX (Arc)
- 10、Torch 2.1.0 + IPEX (Arc)
- 11、Torch 2.1.0 + IPEX (Core Ultra)
- 12、Torch 1.12.1（CUDA11.3）+ xFormers 0.0.14
- 13、Torch 1.13.1（CUDA11.7）+ xFormers 0.0.16
- 14、Torch 2.0.0（CUDA11.8）+ xFormers 0.0.18
- 15、Torch 2.0.1（CUDA11.8）+ xFormers 0.0.22
- 16、Torch 2.1.1（CUDA11.8）+ xFormers 0.0.23
- 17、Torch 2.1.1（CUDA12.1）+ xFormers 0.0.23
- 18、Torch 2.1.2（CUDA11.8）+ xFormers 0.0.23.post1
- 19、Torch 2.1.2（CUDA12.1）+ xFormers 0.0.23.post1
- 20、Torch 2.2.0（CUDA11.8）+ xFormers 0.0.24
- 21、Torch 2.2.0（CUDA12.1）+ xFormers 0.0.24
- 22、Torch 2.2.1（CUDA11.8）+ xFormers 0.0.25
- 23、Torch 2.2.1（CUDA12.1）+ xFormers 0.0.25
- 24、Torch 2.2.2（CUDA11.8）+ xFormers 0.0.25.post1
- 25、Torch 2.2.2（CUDA12.1）+ xFormers 0.0.25.post1
- 26、Torch 2.3.0（CUDA11.8）+ xFormers 0.0.26.post1
- 27、Torch 2.3.0（CUDA12.1）+ xFormers 0.0.26.post1

选择版本时需要根据系统类型和显卡选择
- 在 Windows 系统中，Nvidia 显卡选择 Torch（CUDA）+ xFormers 的版本，AMD 显卡选择 Torch (Directml) 的版本，Intel 显卡选择 Torch + IPEX 的版本（核显选择 Core Ultra 版本，独显选择 Arc 版本）
- 在 Linux 系统中，Nvidia 显卡选择 Torch（CUDA）+ xFormers 的版本，AMD 显卡选择 Torch + RoCM 的版本，Intel 显卡选择 Torch + IPEX 版本
- 在 MacOS 系统中，选择 Torch 版本
- 如果想要使用 CPU 进行跑图，选择 Torch + CPU 的版本
- 一般来说找到对应显卡的型号后，选择最新版本的就行

#### 3、插件选择
第三个是插件选择，Term-SD 默认已经勾选一些比较有用的插件，可以根据个人需求进行选择  
在 Term-SD 的帮助列表中可以查看插件功能的描述，了解插件的用途

#### 4、模型选择
第四个时模型选择，这里可以选择 Term-SD 要下载的模型，Term-SD 默认帮你勾选了一些模型，可根据自己需求来选择


#### 5、Pip 安装模式选择
第四个是 Pip 包管理器的安装模式选择，共有 2 种模式
- 1、常规安装（setup.py）：使用传统方式进行安装，默认使用二进制软件包进行安装，速度较快
- 2、标准构建安装（--use-pep517）：使用标准编译安装，使用源码编译成二进制软件包再进行安装，耗时比较久，但可以解决一些 Python 软件包安装失败的问题

一般使用常规安装（setup.py）就行，如果想要保证安装成功，可以选择标准构建安装（--use-pep517）

>[!NOTE]
>在Linux系统中使用常规安装（setup.py）可能会出现安装失败的问题，所以推荐使用标准构建安装（--use-pep517）

#### 6、安装确认
最后一个是安装确认，选择`是`开始安装  
安装时间根据网络速度和电脑性能决定

>[!NOTE]
>1、Stable Diffusion WebUI 安装成功后，可以前往 Stable Diffusion WebUI 设置调成中文界面（前提是`stable-diffusion-webui-localization-zh_Hans`扩展已经成功安装，在Stable Diffusion WebUI的`Extensions（扩展）`选项卡中查看）  
>2、在 Stable Diffusion WebUI 界面点击`Settings`->`User interface`->`Localization`，点击右边的刷新按钮，再选择（防止不显示出来），在列表中选择`zh-Hans（stable）`，再点击上面的`Apply settings`，最后点击`Reload UI`生效

### ComfyUI 安装
>[!NOTE]
>ComfyUI 是一款节点式操作的 AI 绘画软件，上手难度较高，但是节点赋予 ComfyUI 更高的操作上限，且支持将节点工作流保存成文件，支持扩展。同时 ComfyUI 让用户更好的理解 AI 绘画的工作原理

选中 ComfyUI 管理后，Term-SD 会检测该 AI 是否安装，如果没有安装，Term-SD 会提示用户是否进行安装  
选择`是`之后，Term-SD 会进入安装准备选项

#### 1、安装镜像选项
和 Stable Diffusion WebUI 的选择方法相同

#### 2、PyTorch 版本选择
和 Stable Diffusion WebUI 的选择方法相同

#### 3、插件安装
第三个是插件选择，这里不需要勾选任何插件，直接回车进入自定义节点的安装选项
>[!NOTE]
>在 ComfyUI 中的扩展分为自定义节点和插件，只不过自定义节点很多，而插件几乎没见有人制作（疑似被遗弃），所以有些人也把自定义节点称为插件。  
>保留这个选项的原因是因为 ComfyUI 确实存在这个东西，只不过接近废弃  
>参考：https://github.com/comfyanonymous/ComfyUI/discussions/631

#### 4、自定义节点安装
第四个是自定义节点选择，Term-SD 默认已经勾选一些比较有用的自定义节点，可以根据个人需求进行选择  
在 Term-SD 的帮助列表中可以查看自定义节点功能的描述，了解自定义节点的用途

#### 5、模型选择
和 Stable Diffusion WebUI 的选择方法相同

#### 6、Pip 安装模式选择
和 Stable Diffusion WebUI 的选择方法相同

#### 7、安装确认
最后一个是安装确认，选择`是`开始安装  
安装时间根据网络速度和电脑性能决定

>[!NOTE]
>1、在安装结束后，如果有自定义节点的，需要在`ComfyUI管理` -> `自定义节点管理`里运行`安装全部全部自定义节点依赖`，保证自定义节点的正常运行（因为 ComfyUI 并没有 Stable Diffusion WebUI 自动为扩展安装依赖的功能）  
>2、如果扩展`ComfyUI-Manager`成功安装，可以不用执行`安装全部全部自定义节点依赖`，因为`ComfyUI-Manager`能够自动为扩展安装依赖（`ComfyUI-Manager`把ComfyUI缺失的这个功能给补上了（？），不过`ComfyUI-Manager`很多情况下不会自动为其它扩展装依赖，所以需要在`ComfyUI管理`->`自定义节点管理`里运行`安装全部全部自定义节点依赖`手动装一下）。
>3、设置中文：进入 ComfyUI 界面，点击右上角的齿轮图标进入设置，找到`AGLTranslation-langualge`，选择`中文[Chinese Simplified]`，ComfyUI 将会自动切换中文

### InvokeAI 安装
>[!NOTE]
>InvokeAI 是一款操作界面简单的 AI 绘画软件，功能较少，但拥有特色功能`统一画布`，用户可以在画布上不断扩展图片的大小。  
>目前已经加入了节点功能，可玩性相对早期版本有了较大的提高

选中 InvokeAI 管理后，Term-SD 会检测该 AI 是否安装，如果没有安装，Term-SD 会提示用户是否进行安装  
选择`是`之后，Term-SD 会进入安装准备选项

#### 1、安装镜像选项
和 Stable Diffusion WebUI 的选择方法相同

#### 2、PyTorch 版本选择
和 Stable Diffusion WebUI 的选择方法相同

#### 3、Pip安 装模式选择
和 Stable Diffusion WebUI 的选择方法相同

#### 4、安装确认
最后一个是安装确认，选择`是`开始安装  
安装时间根据网络速度和电脑性能决定

>[!NOTE]
>1、安装完成后，在启动选项选择`(web)`启动 WebUI 界面
>2、设置中文：进入 InvokeAI 界面，点击右上角的三条横杠的图标，点击`Settings`，然后找到`Language`选项，点击文字下方的选项框，找到`简体中文`并选中，InvokeAI 就会把界面切换成中文

### Fooocus 安装
>[!NOTE]
>Fooocus 是一款专为 SDXL 模型优化的 AI 绘画软件，界面简单，让使用者可以专注于提示词的书写，而且有着非常强的内存优化和速度优化，强于其他同类 WebUI。目前 Fooocus 对标 Midjourney，为把复杂的生图流程进行简化

选中 Fooocus 管理后，Term-SD 会检测该 AI 是否安装，如果没有安装，Term-SD 会提示用户是否进行安装  
选择`是`之后，Term-SD 会进入安装准备选项

#### 1、安装镜像选项
和 Stable Diffusion WebUI 的选择方法相同

#### 2、PyTorch 版本选择
和 Stable Diffusion WebUI 的选择方法相同

#### 3、Pip 安装模式选择
和 Stable Diffusion WebUI 的选择方法相同

#### 4、安装确认
最后一个是安装确认，选择`是`开始安装  
安装时间根据网络速度和电脑性能决定


### lora-scripts 安装
>[!NOTE]
>lora-scripts 是一款 AI 模型训练工具，支持训练 Lora 模型、Dreambooth 模型，而且界面附带各个训练参数的解释，为使用者降低了操作难度。lora-scripts 还附加了图片批量打标签的工具和图片标签批量编辑工具，非常方便

选中 lora-scripts 管理后，Term-SD 会检测该 AI 是否安装，如果没有安装，Term-SD 会提示用户是否进行安装  
选择`是`之后，Term-SD 会进入安装准备选项

#### 1、安装镜像选项
和 Stable Diffusion WebUI 的选择方法相同

#### 2、PyTorch 版本选择
和 Stable Diffusion WebUI 的选择方法相同

#### 3、Pip 安装模式选择
和 Stable Diffusion WebUI 的选择方法相同

#### 4、安装确认
最后一个是安装确认，选择`是`开始安装  
安装时间根据网络速度和电脑性能决定


### kohya_ss 安装
>[!NOTE]
>kohya_ss 是一款AI模型训练工具，支持训练 Lora、Dreambooth、Finetune、Train Network 模型

选中 kohya_ss 管理后，Term-SD 会检测该 AI 是否安装，如果没有安装，Term-SD 会提示用户是否进行安装  
选择`是`之后，Term-SD 会进入安装准备选项

#### 1、安装镜像选项
和 Stable Diffusion WebUI 的选择方法相同

#### 2、PyTorch 版本选择
和 Stable Diffusion WebUI 的选择方法相同

#### 3、Pip 安装模式选择
和 Stable Diffusion WebUI 的选择方法相同

#### 4、安装确认
最后一个是安装确认，选择`是`开始安装  
安装时间根据网络速度和电脑性能决定

***

## Term-SD 管理功能
当 AI 软件成功安装后，就可以使用 Term-SD 的管理功能来启动或者管理 AI 了  
在 6 个 AI 管理界面中，包含一些功能对 AI 进行管理

### 1、更新
更新 AI 软件。当 AI 软件出现更新失败时（出现分支游离或者源代码被手动修改，非网络的原因），可以使用`修复更新`功能来修复问题

>[!NOTE]
>1、有时候扩展和 AI 软件的版本不匹配时（AI 软件的版本很新，而扩展的版本很旧），就容易出现报错，此时就可以通过更新解决  
>2、在出现分支游离时，`修复更新`将在更新时自动运行

### 2、卸载
卸载 AI 软件，且该操作无法恢复，请谨慎选择

### 3、修复更新
该功能用于修复因为 Git 分支游离或者手动更改了源代码文件导致更新失败的问题，使用时将会把分支切换成主分支并还原被修改的源代码

### 4、插件管理
该功能用于管理插件，包含以下功能

- 1、安装：使用 Git 安装插件
- 2、管理：对插件进行管理，提供了一个插件列表浏览器来选择插件
- 3、更新全部插件：一键更新全部插件
- 4、安装全部插件依赖：一键将所有插件需要的依赖进行安装（仅限 ComfyUI）

选中一个插件后，包含以下功能用于管理插件：
- (1) 更新：更新插件
- (2) 卸载：卸载插件，且该操作无法恢复，请谨慎选择
- (3) 修复更新：修复插件无法更新的问题
- (4) 切换版本：切换插件的版本
- (5) 更新源切换：切换插件的更新源，加速下载；当某个 Github 镜像源无法使用导致无法更新插件时，也可以使用该功能将更新源切换到可用的 Github 镜像源或者切换成 Github 源
- (6) 安装依赖（仅限 ComfyUI）：安装插件运行时所需的依赖

>[!NOTE]
>1、如果安装了`ComfyUI-Manager`这个扩展，就不需要使用`安装全部插件依赖`这个功能了（`ComfyUI-Manager`把ComfyUI缺失的这个功能给补上了（？），不过`ComfyUI-Manager`有时候不会自动为其它扩展装依赖，这时就使用`安装全部插件依赖`来手动安装依赖）  
>2、有时候扩展和 AI 软件的版本不匹配时（AI 软件的版本很新，而扩展的版本很旧），就容易出现报错，此时就可以通过更新解决

### 5、自定义节点管理
用于管理自定义节点，包含以下功能
>[!NOTE]
>仅限 ComfyUI

- 1、安装：使用 Git 安装自定义节点
- 2、管理：对插件进行管理，提供了一个自定义节点列表浏览器来选择插件
- 3、更新全部自定义节点：一键更新全部自定义节点
- 4、安装全部自定义节点依赖：一键将所有自定义节点需要的依赖进行安装

选中一个自定义节点后，包含以下功能用于管理自定义节点：
- 1、更新：更新自定义节点
- 2、卸载：卸载自定义节点，且该操作无法恢复，请谨慎选择
- 3、修复更新：修复自定义节点无法更新的问题
- 4、切换版本：切换自定义节点的版本
- 5、更新源切换：切换自定义节点的更新源，加速下载；当某个 Github 镜像源无法使用导致无法更新插件时，也可以使用该功能将更新源切换到可用的 Github 镜像源或者切换成 Github 源
- 6、安装依赖：安装自定义节点运行时所需的依赖

>[!NOTE]
>1、如果安装了`ComfyUI-Manager`这个扩展，就不需要使用`安装全部自定义节点依赖`这个功能了（`ComfyUI-Manager`把ComfyUI缺失的这个功能给补上了，不过`ComfyUI-Manager`有时候不会自动为其它扩展装依赖，这时就使用`安装全部自定义节点依赖`来手动安装依赖）    
>2、有时候扩展和 AI 软件的版本不匹配时（AI 软件的版本很新，而扩展的版本很旧），就容易出现报错，此时就可以通过更新解决

### 6、切换版本
该功能将会列出所有版本的 Hash 值和对应的日期，可根据这些进行版本选择并切换过去

### 7、更新源切换
该功能用于切换更新源，加速下载；当某个 Github 镜像源无法使用导致无法更新插件时，也可以使用该功能将更新源切换到可用的 Github 镜像源或者切换成 Github 源

>[!NOTE]
>有时候某个 Github 镜像源无法使用的时候，使用更新功能时就会导致更新失败，可以通过该功能把更新源切换成其他的 Github 镜像源，如果镜像源都无法使用时，就把更新源切换成 Github 源

### 8、启动
该功能用于启动 AI 软件  

>[!NOTE]
>1、在 Stable Diffusion WebUI、ComfyUI、InvokeAI，Fooocus 中可以选择`配置预设启动参数`或者`修改自定义启动参数`，从而使用一些功能  
>2、当使用`配置预设启动参数`来配置启动参数时，将会删除之前设置的启动参数。而使用`修改自定义启动参数`可以修改上次设置的启动参数

### 9、更新依赖
该功能用于更新 AI 软件依赖的 Python 软件包，可用于解决 AI 软件的部分依赖版本太旧导致运行报错，一般用不上

>[!NOTE]
>有时通过更新 AI 软件依赖可解决报错问题

### 10、重新安装
该功能用于重新执行 AI 软件的安装过程，一般用不上

### 11、重新安装 PyTorch
该功能用于切换 PyTorch 的版本  
- 1、当 PyTorch 出现问题导致 PyTorch 无法使用 GPU 时，可以使用该功能重装 PyTorch
- 2、当 PyTorch 版本和 GPU 不匹配时，可以通过该功能切换版本
- 3、当需要更新 PyTorch 时，也可以使用这个功能来更新

>[!NOTE]
>在重新安装 PyTorch 前，Term-SD 将弹出 PyTorch 版本的选择、是否使用标准编译安装、是否使用强制安装的的选项，选择完成后会弹出确认安装的选项，选择确定进行安装

### 12、修复虚拟环境
该功能用于修复生成 AI 软件使用的虚拟环境，一般在移动 AI 软件的位置，AI 软件运行出现问题后才用

>[!NOTE]
>1、虚拟环境在移动位置后就出现问题，这是一个特性。当然这个功能可以解决这个问题  
>2、该功能已改成自动执行，当检测到虚拟环境出现问题时将自动执行修复

### 13、重新构建虚拟环境
该功能用于重新构建 AI 软件使用的虚拟环境，一般用在移动AI软件的位置后、AI 软件运行出现报错（有一些时候是 Python 依赖库出现了版本错误或者损坏，或者装了一些插件后出现问题，删除插件后问题依然没有解决）、安装 AI 软件前禁用了虚拟环境，安装后启用了虚拟环境，需要修复虚拟环境  
这个功能一般不需要用，除非解决不了一些 Python 库报错问题（因为该功能将会重新构建虚拟环境，需要消耗比较长的时间）

>[!NOTE]
>这个功能可以解决环境出现严重问题、环境因为安装一些东西而炸掉。如果这个功能还不能解决报错，有可能是因为 AI 本体和插件的版本冲突， Python 版本过新或者过旧等问题。在这种情况下只能自行查找原因

### 14、分支切换
>[!NOTE]
>仅限Stable Diffusion WebUI

该功能用于把`AUTOMATIC1111/Stable Diffusion WebUI`的分支切换成`vladmandic/SD.NEXT`或者`lshqqytiger/Stable Diffusion WebUI-DirectML`（或者切换回来），或者切换成主分支或者测试分支

### 15、Python 软件包安装 / 重装 / 卸载
该功能用于安装/重装/卸载 Python 软件包，处理 Python 软件包的问题  
界面有以下选项：
- 1、常规安装(install)：安装 Python 软件包并安装该软件包依赖的软件包
- 2、仅安装(--no-deps)：安装 Python 软件包，但不安装该软件包依赖的软件包
- 3、强制重装(--force-reinstall)：强制安装 Python 软件包，当该软件包已存在，则重新安装，且强制安装该软件包依赖的软件包
- 4、仅强制重装(--no-deps --force-reinstall)：强制安装 Python 软件包，当该软件包已存在，则重新安装，但不安装该软件包依赖的软件包
- 5、卸载(uninstall)：卸载 Python 软件包

如何选择：
- (1) 当缺失某个软件包时，选择安装
- (2) 当某个软件包损坏时，可以选择强制重装
- (3) 如果需要卸载某个软件包，就选择卸载
- (4) 带有`仅`的功能是在安装时只安装用户输入的软件包，而不安装这些软件包的依赖

安装/重装软件包时可以只写包名，也可以指定包名版本；可以输入多个软件包的包名，并使用空格隔开；如果想要更新某个软件包的版本，可以加上`-U`参数。例：
```
xformers
xformers==0.0.21
xformers==0.0.21 numpy
numpy -U
```

### 16、依赖库版本管理
该功能用于记录 Python 依赖库的版本，在 AI 软件运行正常时，可以用该功能记录 Python 依赖库的各个软件包版本，当因为装插件等导致依赖库的软件包版本出现错误而导致报错时，可用该功能恢复原来依赖库的各个软件包版本，从而解决报错

>[!NOTE]
>比如安装 TensorRT 前，先使用这个功能备份依赖库的版本，然后再安装 TensorRT。当 TensorRT 把依赖库环境搞炸的时候（有概率），把 TernsorRT 卸载，并使用该功能恢复依赖库。如果还没恢复，只能使用`重新构建虚拟环境`来修复

### 17、重新安装后端组件
>[!NOTE]
>仅限Stable Diffusion WebUI，lora-scripts、kohya_ss

该功能用于重新下载后端需要的组件，组件存在以下文件夹中  
- Stable Diffusion WebUI：`repositories`
- lora-scripts：`frontend`、`sd-scripts`、`mikazuki/dataset-tag-editor`
- kohya_ss：`sd-scripts`

***

## Term-SD 更新管理
该功能用于对 Term-SD 自身的更新等进行管理，共有以下选项
- 1、更新：更新 Term-SD
- 2、切换更新源：Term-SD 有多个下载源，用于解决某些更新源更新慢或者无法更新的问题，一般来说 Github 源的版本变化较快，其他源的版本变化会有延后（大约延迟一天，因为其他源每隔一天同步一次 Github 仓库）
- 3、切换分支：Term-SD 总共有两个分支，主分支和测试分支，一般不需要切换
- 4、修复更新：当用户手动修改 Term-SD 的文件后，在更新 Term-SD 时就容易出现更新失败的问题，该功能可修复该问题（会把用户自行修改的部分还原）
- 5、设置自动更新：启用后 Term-SD 在启动时会检测是否有更新，当有新版本时会提示用户进行更新

***

## Term-SD 设置
该界面提供了各种配置运行环境的设置，设置如下：

### 虚拟环境设置
配置 Term-SD 在安装，管理 AI 时是否使用虚拟环境，建议保持启用（默认）。虚拟环境创建了一个隔离环境，保证不同的 AI 软件的 Python 依赖库不会互相干扰，也防止系统中的 Python 依赖库不会互相干扰，因为 AI 软件对同一个 Python 软件包的要求版本不一致

### Pip 镜像源设置 (配置文件)
该功能通过修改 Pip 配置文件来修改pip的下载源，而 Term-SD 也包含另一个修改 Pip 镜像源的功能`Pip 镜像源设置 (环境变量)`（环境变量的优先级比配置文件高，所以 Pip 优先使用环境变量的配置），也是类似的功能，只不过不需要修改 Pip 配置文件，个人建议这个设置不用调（因为 Term-SD 默认通过 Pip 镜像源设置(环境变量)来设置 Pip 镜像源）  
设置中有以下选项：
- 1、设置官方源：将 Pip 的下载源切换成官方源，但可能会导致下载慢或者下载失败的问题
- 2、设置国内镜像源：将 Pip 的下载源切换成国内镜像源，解决官方源下载慢或者下载失败的问题，推荐选择
- 3、删除镜像源配置：将 Pip 的下载源配置清除

### Pip 镜像源设置 (环境变量)
该功能通过设置环境变量来设置 Pip 镜像源（环境变量设置的优先级比配置文件的设置高），而该设置默认选择国内的镜像源，所以一般来说不用修改
设置中有以下选项
- 1、设置官方源：将 Pip 的下载源切换成官方源，但可能会导致下载慢或者下载失败的问题
- 2、设置国内镜像源：将 Pip 的下载源切换成国内镜像源，解决官方源下载慢或者下载失败的问题，推荐选择

### Pip 缓存清理
显示 Pip 下载软件包产生的缓存路径和大小，也可以清理 Pip 下载 Python 软件包产生的缓存

### 代理设置
该功能为了设置下载时使用的网络代理，解决部分下载源下载失败的问题，因为一些代理软件的代理模式并不能让终端环境使用代理，除了`TUN模式`或者`虚拟网卡模式`可以让终端环境使用代理。一般代理软件都会开放一个 IP 和端口用于代理，Term-SD 可以通过手动设置 IP 和端口使终端环境使用代理，解决 AI 软件因无法连接到部分地址（如HuggingFace）而导致报错。对于有`TUN模式`或者`虚拟网卡模式`的代理软件，个人建议不使用这类模式，因为这会让 Term-SD 的所有流量走代理，增大代理流量的消耗（代理流量多的可以不用在意），所以建议使用该功能设置代理  
设置有以下选项：
- 1、Http：设置 Http 协议的代理
- 2、Socks：设置 Socks 协议的代理
- 3、Socks5：设置 Socks5 协议的代理
- 4、自定义协议：可以选择预设代理协议之外的协议
- 5、删除代理参数：将设置的代理参数删除

设置代理时，用户需要选择代理协议，具体使用什么代理协议取决于所使用的代理软件开放的ip是用什么代理协议  
这里举例代理如何填写：
- (1)查找代理协议，IP，端口

查找代理软件为其他软件提供代理时使用的协议，一般来说 Http 和 Socks 比较常见（不是 Vless，SSR 这类协议，这类协议是用在代理软件和代理服务器之间传输数据的），然后查看代理的 IP 和端口，常见的 IP 和端口分别是 127.0.0.1 和 10809  
现在的得到以下信息了  
协议：`http`  
ip：`127.0.0.1`  
端口：`10809`

- (2)填入信息

打开 Term-SD`设置`，选择`代理设置`，这里询问选择协议，根据刚刚的得到的信息，选择`Http协议`，回车，在弹出的输入框中输入`127.0.0.1:10809`，回车保存

- (3)确认代理是否正常使用

在 Term-SD 的设置中，选择`网络连接测试`进行网络测试，当检测到 Google、HuggingFace 能够正常访问的时候，说明代理能够正常使用

>[!NOTE]
>1、在不使用代理后，需要在`代理设置`里删除代理参数，防止在代理软件关闭后出现 Term-SD 无法访问网络的问题  
>2、Term-SD 和 AI 软件的运行环境为终端，而终端并不会直接使用代理，所以需要手动设置。这是因为当系统配置了代理后，是否使用系统的代理由软件自己决定，比如浏览器就使用系统的代理，而终端不使用系统的代理，它使用代理是通过设置环境变量。  
>有关终端设置代理的方法可参考https://blog.csdn.net/Dancen/article/details/128045261

### Github 镜像源设置
该功能用于设置全局的 Github 的镜像源，解决 Github 无法访问导致插件下载失败或者是插件更新失败的问题

### HuggingFace 镜像源设置
该功能用于设置全局的 HuggingFace 的镜像源，解决无代理时 HuggingFace 无法访问导致某些报错问题，如 Tagger 插件无法下载反推模型且没有代理来解决这个问题时，就可以通过设置全局的 HuggingFace 的镜像源来解决

### 命令执行监测设置
该功能用于监测命令的运行情况，若设置了重试次数，Term-SD 将重试执行失败的命令(有些命令需要联网，在网络不稳定的时候容易导致命令执行失败)，保证命令执行成功

>[!NOTE]
>Term-SD 在安装成功后默认启用并设置为 3

### Term-SD 安装模式
该功能用于设置 Term-SD 安装 AI 软件的工作模式。当启用`严格模式`后，Term-SD 在安转 AI 软件时出现执行失败的命令时将停止安装进程(Term-SD 支持断点恢复，可恢复上次安装进程中断的位置)，而`宽容模式`在安转 AI 软件时出现执行失败的命令时忽略执行失败的命令继续执行完成安装任务。默认设置为`严格模式`  
设置有以下选项
- 1、严格模式：将 Term-SD 安装 AI 软件的工作模式设置为严格模式，当出现执行失败的命令时将停止安装进程
- 2、宽容模式：将 Term-SD 安装 AI 软件的工作模式设置为严格模式，当出现执行失败的命令时将跳过执行失败的命令，而不终止安装进程

>[!NOTE]
>1、Term-SD在恢复原来的安装进度时，依然会遍历所有安装需要的命令，但是已经执行成功后的命令并不会执行  
>2、`严格模式`这个模式主要用于防止意外结果发生的，比如框架没有能够成功下载下来，之后 Term-SD 执行其他的命令时，就有可能导致其他文件散落在安装目录中（不会清理电脑垃圾的遇到这种问题还是很头疼的）  
>3、`严格模式`搭配上 Term-SD 的伪断点恢复功能（只为 AI 软件的安装设计了这个功能），可以在安装中断后重新恢复安装进度

### Aria2 线程设置
该功能用于增加 Term-SD 在使用 Aria2 下载模型时的线程数，在一定程度上提高下载速度

### 缓存重定向设置
该功能将会把 AI 软件产生的缓存重定向至 Term-SD 目录中，位于 cache 文件夹，不过有些 AI 软件会把模型下载到缓存目录中，存在于`unet`文件夹和`huggingface`文件夹中，在清理缓存中需要注意

>[!NOTE]
>该设置默认启用，为了方便清理 AI 软件产生的缓存

### CUDA 内存分配设置
该功能用于设置 CUDA 分配显存使用的分配器，当 CUDA 版本大于 11.4+ 且 PyTorch 版本大于 2.0.0 时，可以设置为`CUDA(11.4+) 内置异步分配器`，加速 AI 软件的运行，否则设置为`PyTorch 原生分配器`或者不设置  
设置有以下选项
- 1、PyTorch 原生分配器：将 CUDA 内存分配器设置为 PyTorch 原生分配器
- 2、CUDA (11.4+) 内置异步分配器：将 CUDA 内存分配器设置为 CUDA 内置异步分配器，加速 AI 软件的运行
- 3、清除设置：清除 CUDA 内存分配设置

>[!NOTE]
>该功能仅限在 Nvidia 显卡上使用

### 自定义安装路径
该功能用于自定义 AI 软件的安装路径，当保持默认时， AI 软件的安装路径与 Term-SD 所在路径同级  
- 1、Stable Diffusion WebUI 安装路径设置：修改 Stable Diffusion WebUI 的安装路径
- 2、ComfyUI 安装路径设置：修改 ComfyUI 的安装路径
- 3、InvokeAI 安装路径设置：修改 InvokeAI 的安装路径
- 4、Fooocus 安装路径设置：修改 Fooocus 的安装路径
- 5、lora-scripts 安装路径设置：修改 lora-scripts 的安装路径
- 6、kohya_ss 安装路径设置：修改 kohya_ss 的安装路径

当选择其中一项子设置时，即可修改该设置对应的 AI 软件的安装路径  
子设置中有以下选项
- (1) 设置安装路径：自定义 AI 软件的安装路径
- (2) 恢复默认安装路径设置：恢复 AI 软件默认的安装路径，默认安装路径和 Term-SD 所在路径同级

>[!NOTE]
>路径最好使用绝对路径（目前没有见过哪个软件使用相对路径来安装软件的）  

### 空间占用分析
该功能用于统计各个 AI 软件的空间占用和 Term-SD 重定向的缓存占用情况

>[!NOTE]
>统计占用的时间可能会很长

### 网络连接测试
测试网络环境，用于测试代理是否可用。该功能将会测试网络连接是否正常，并测试 Google，HuggingFace，Github，Ghproxy 等能否访问。在安装时出现的`代理设置`中，有的 Github 镜像源可能无法访问，可以通过该功能查看哪些镜像源可用

### 卸载 Term-SD
卸载 Term-SD 本体程序，保留已下载的 AI 软件

>[!NOTE]
>Term-SD 的扩展脚本`file-backup`备份的文件保存在 Term-SD 目录中的`backup`文件夹中。如需要保留，请在卸载 Term-SD 前将其移至其它路径中

***

## Term-SD 额外功能

### 扩展脚本
Term-SD 包含了一些扩展脚本，扩充 Term-SD 的功能
- 1、download-hanamizuki：下载绘世启动器，并自动放入绘世启动器支持的 AI 软件的目录中
- 2、list：列出可用的扩展脚本
- 3、download-model：使用 Term-SD 的模型库下载模型
- 4、download-sd-webui-extension：下载 Stable Diffusion WebUI 插件（脚本包含的插件列表在 Term-SD 的帮助中有说明）
- 5、download-comfyui-extension：下载 ComfyUI 插件（脚本包含的插件列表在 Term-SD 的帮助中有说明）
- 6、file-backup：备份 / 恢复 AI 软件的数据，备份文件储存在 Term-SD 的`backup`文件夹中
- 7、fix-onnxruntime-gpu：当 PyTorch 所带的 CUDA 版本为 12.1 时，但本地安装的 onnxruntime-gpu 为适用于 CUDA 11.8 的版本时，将导致 onnxruntime 的运行无法使用 GPU 进行加速，该脚本可将 onnxruntime-gpu 重装至支持 CUDA 12.1 的版本

>[!NOTE]
>如果需要使用扩展脚本，则在启动 Term-SD 前加入`--extra`启动参数即可使用扩展脚本

### 启动参数
在使用命令 Term-SD 时，可以添加启动参数来使用 Term-SD 额外的功能

#### 启动参数的使用方法
```
./term-sd.sh [--help] [--extra script_name] [--reinstall-term-sd] [--remove-term-sd] [--quick-cmd] [--set-python-path python_path] [--unset-python-path] [--update-pip] [--bar display_mode] [--debug]
```

>[!NOTE]
>中括号`[]`仅用来展示，在使用的时候不要输入进去  
当使用`--quick-cmd`安装了快捷命令，可将`./term-sd.sh`替换成`term_sd`或者`tsd`

#### 启动参数的功能解析
- 1、help

显示启动参数帮助


- 2、extra

启动扩展脚本显示界面，选中其中一个启动脚本后即可启动，如果参数后面输入扩展脚本的名字，则直接启动指定的扩展脚本


- 3、reinstall-term-sd

重新安装 Term-SD。Term-SD 会提示用户如何重新安装，根据提示操作即可


- 4、remove-term-sd

卸载 Term-SD，该功能将会删除 Term-SD 自身的所有组件和快捷启动命令，只保留已经安装的AI软件


- 5、quick-cmd

将 Term-SD 快捷启动指令安装到 Shell中，在 Shell 中直接输入`term_sd`或者`tsd`即可启动 Term-SD，且不需要在 Term-SD 所在目录就能启动 Term-SD（用`./term-sd.sh`命令启动还是需要在 Term-SD 所在目录里才能用）。该功能会提示用户选择安装快捷启动命令还是删除快捷启动命令，根据提示进行操作


- 6、set-python-path

手动指定 Python 解释器路径（一定是绝对路径），当选项后面输入了路径，则直接使用输入的路径来设置 Python 路径（建议用`" "`把路径括起来），否则启动设置界面  
路径的参考格式如下：
```
/usr/bin/python
/c/Python/python
C:\Program Files\Python310\python.exe
/d/Program Files/Python310/python.exe
/usr/bin/python3
```

>[!NOTE]
>根据自己安装的路径来填。


- 7、unset-python-path

删除自定义 Python 解释器路径配置


- 8、bar

设置 Term-SD 初始化进度条显示模式，有以下几种：  
（1）none：禁用进度条显示  
（2）normal：使用默认的显示模式  
（3）new：使用新的进度条显示


- 12、update-pip

进入虚拟环境时更新 Pip 软件包管理


- 13、debug

显示调试信息


- 14、unset-tcmalloc

禁用加载内存优化

***

## 安装 GPerfTools 工具进行内存优化
在 Linux 系统中可以安装 GPerfTools 来优化内存的占用，不同 Linux 发行版的安装方式如下。

- Debain（Ubuntu系）系：
```bash
sudo apt install google-perftools
```
- ArchLinux 系：
```bash
sudo pacman -S gperftools
```
- OpenSEUS：
```bash
sudo zypper install gperftools
```
- NixOS：
```bash
nix-env -i gperftools
```

***

## 绘世启动器的使用
目前绘世启动器支持启动 Stable Diffusion WebUI（A1111-SD-WebUI / vlad-SD.NEXT / SD-WebUI-DirectML）、ComfyUI、Fooocus。使用Term-SD 部署 Stable Diffusion WebUI、ComfyUI、或者 Fooocus 后，将绘世启动器放入 Stable Diffusion WebUI 文件夹、ComfyUI 文件夹或者 Fooocus 文件夹后就可以使用绘世启动器启动对应的 AI 软件了（可以使用 Term-SD 扩展脚本中的 download-hanamizuki 脚本来下载绘世启动器，并且脚本会自动将绘世启动器放入上述文件夹中）

||绘世启动器依赖|
|---|---
|↓|[Microsoft Visual C++](https://aka.ms/vs/17/release/vc_redist.x64.exe)|
|↓|[.NET 6.0](https://dotnet.microsoft.com/zh-cn/download/dotnet/thank-you/sdk-6.0.420-windows-x64-installer)|
|↓|[.NET 8.0](https://dotnet.microsoft.com/zh-cn/download/dotnet/thank-you/sdk-8.0.203-windows-x64-installer)|

>[!NOTE]
>使用绘世启动器前需要安装依赖

||绘世启动器|
|---|---|
|↓|[下载地址1](https://github.com/licyk/term-sd/releases/download/archive/hanamizuki.exe)|
|↓|[下载地址2](https://gitee.com/licyk/term-sd/releases/download/archive/hanamizuki.exe)|
