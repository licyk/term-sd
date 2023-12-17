# Tern-SD使用教程

## Term-SD的初始化
Term-SD在下载好后，只会有一个基础的配置脚本`term-sd.sh`，当运行这个配置脚本时，Term-SD会检测运行所需依赖。当检测到缺少依赖时，Term-SD会提示用户需要去安装的依赖，并自动退出，这时候需要用户检查这些依赖是否安装，并且把缺失的依赖装上  
当检测到依赖都安装时，脚本会提示用户安装Term-SD的完整组件

这时候输入`y`即可进行下载  

在下载前。Term-SD会询问选择哪个下载源  
总共有以下下载源：
- 1、github源
- 2、gitee源
- 3、gitlab源
- 4、极狐源
- 5、代理源(ghproxy.com)

一般情况下选择任意一种都可以进行下载  
如果下载失败，Term-SD将会自动退出，这时再次运行Term-SD，选择其他下载源来重新下载  
当成功下载时，Term-SD将会自动初始化模块，并启动

>成功进入Term-SD的界面后，使用方向键、Tab键移动光标，方向键翻页（鼠标滚轮无法翻页），Enter进行选择，Space键勾选或取消勾选，（已勾选时显示[*]），Ctrl+Shift+V粘贴文本，Ctrl+C可中断指令的运行，鼠标左键可点击按钮（右键无效）

***

## Term-SD的主界面介绍
Term-SD在成功启动后，首先显示的是各个组件的版本信息，选择确定后就进入Term-SD的主界面  
主界面有以下选项
- 1、Term-SD更新管理：管理，修复Term-SD的更新
- 2、Stable-Diffusion-WebUI管理：包含各种Stable-Diffusion-WebUI的管理功能
- 3、ComfyUI管理：包含各种ComfyUI的管理功能
- 4、InvokeAI管理：包含各种InvokeAI的管理功能
- 5、Fooocus管理：包含各种Fooocus的管理功能
- 6、lora-scripts管理：包含各种lora-scripts的管理功能
- 7、kohya_ss管理：包含各种kohya_ss的管理功能
- 7、设置：包含Term-SD各种设置
- 8、帮助：Term-SD的各种帮助文档

***

## Term-SD的准备功能
Term-SD在使用安装、管理AI软件的功能时，会使用准备功能来对一些操作进行准备工作，共有以下功能
>这些功能会经常出现

### 1、安装镜像选项
有以下选项：
- 1、启用pip镜像源：Term-SD调用pip下载Python软件包时使用国内镜像源进行下载
- 2、huggingface/github独占代理：Term-SD安装AI软件的过程仅为huggingface/github下载源启用代理，减少代理流量的消耗
- 3、强制使用pip：强制使用pip安装Python软件包，一般只有在禁用虚拟环境后才需要启用 
- 4、使用modelscope模型下载源：将安装时使用的huggingface模型下载源改为modelscope模型下载源（因为huggingface在国内无法直接访问）
- 5、github镜像源自动选择：测试可用的github镜像源并选择自动选择，选择该选项后将覆盖手动设置的github镜像源
- 6、启用github镜像源：Term-SD从github克隆源代码时使用github镜像站进行克隆

一般这些选项保持默认即可

>1、`强制使用pip`一般不需要启用，该选项向pip传达--break-system-packages参数进行安装，忽略系统的警告，参考https://stackoverflow.com/questions/75602063/pip-install-r-requirements-txt-is-failing-this-environment-is-externally-mana  
>2、在使用驱动模式或者TUN模式的代理软件时，`huggingface/github独占代理`功能无效，因为代理软件会强制让所有网络流量走代理  
>3、github镜像源有多个，可以根据Term-SD的`设置`->`网络连接测试`的测试结果来选择，或者勾选`github镜像源自动选择`让Term-SD自动选择  
>4、当所有github镜像源都不可用时，只能把所有的`启用github镜像源`、`github镜像源自动选择`选项取消勾选

### 2、PyTorch版本选项
有以下版本组合：
- 1、Torch+xformers
- 2、Torch
- 3、Torch 2.0.0（Directml）
- 4、Torch 2.1.0+CPU
- 5、Torch 2.0.1+RoCM 5.4.2
- 6、Torch 2.1.0+RoCM 5.6
- 7、Torch 2.0.0+IPEX
- 8、Torch 2.1.0+IPEX
- 9、Torch 1.12.1（CUDA11.3）+xFormers 0.0.14
- 10、Torch 1.13.1（CUDA11.7）+xFormers 0.0.16
- 11、Torch 2.0.0（CUDA11.8）+xFormers 0.0.18
- 12、Torch 2.0.1（CUDA11.8）+xFormers 0.0.22
- 13、Torch 2.1.1（CUDA11.8）+xFormers 0.0.23
- 14、Torch 2.1.1（CUDA12.1）+xFormers 0.0.23

选择版本时需要根据系统类型和显卡选择  
- 在Windows系统中，Nvidia显卡选择Torch（CUDA）+xformers的版本，AMD显卡Torch(Directml)的版本，Intel显卡选择Torch+IPEX的版本  
- 在Linux系统中，Nvidia显卡选择Torch（CUDA）+xformers的版本，AMD显卡选择Torch+Rocm的版本，Intel显卡选择Torch+IPEX版本  
- 在MacOS系统中，选择Torch版本  
- 如果想要使用CPU进行跑图，选择Torch+CPU的版本

### 3、pip安装模式选项
该功能用于选择pip的安装模式，可解决某些情况下安装Python软件包失败的问题，如果不在意安装时间，可以选择标准构建安装（--use-pep517），保证安装成功；选择常规安装（setup.py）也可以，安装速度会比较快，但可能会出现安装失败的问题  
该界面共有2种模式可以选择
- 1、常规安装（setup.py）：使用传统方式进行安装，默认使用二进制软件包进行安装，速度较快
- 2、标准构建安装（--use-pep517）：使用标准编译安装，使用源码编译成二进制软件包再进行安装，耗时比较久，但可以解决一些Python软件包安装失败的问题

>在Linux系统中使用常规安装（setup.py）可能会出现安装失败的问题，所以推荐使用标准构建安装（--use-pep517）

### 4、pip操作方式
该功能用于选择对Python软件包的操作方式  
该界面有以下选项
- 1、常规安装(install)：安装Python软件包并安装该软件包依赖的软件包
- 2、仅安装(--no-deps)：安装Python软件包，但不安装该软件包依赖的软件包
- 3、强制重装(--force-reinstall)：强制安装Python软件包，当该软件包已存在，则重新安装，且强制安装该软件包依赖的软件包
- 4、仅强制重装(--no-deps --force-reinstall)：强制安装Python软件包，当该软件包已存在，则重新安装，但不安装该软件包依赖的软件包
- 5、卸载(uninstall)：卸载Python软件包

当缺失某个软件包时，选择安装  
当某个软件包损坏时，可以选择强制重装  
如果需要卸载某个软件包，就选择卸载

>该选项仅在Python软件包安装/重装/卸载功能出现

### 5、pip强制重装选择
该功能用于在pip发现将要安装的Python软件包已存在且版本相同时，是否强制重新安装  
该界面有以下选项
- 1、安装：正常安装Python软件包，当发现将要安装的Python软件包已存在且版本相同时，跳过安装
- 2、强制重装：当发现将要安装的Python软件包已存在且版本相同时，强制重新安装

### 6、安装确认选项
该功能用于展示部分安装信息，并确认是否安装

### 7、安装进度恢复选项
当Term-SD在因为某些原因中断安装进程时，再次进入管理界面即可恢复上次的安装进度（Term-SD依然会从头遍历安装命令，但已经执行成功的命令将不会执行）  
该界面有以下选项
- 1、继续执行安装任务：继续之前中断的安装任务
- 2、重新设置安装参数并进行安装：删除之前的安装任务，并重新设置安装参数
- 3、删除安装任务并进入管理界面：删除之前的安装任务，并进入管理界面
- 4、跳过安装任务并进入管理界面：不删除之前的安装任务，并直接进入管理界面，但下一次进入管理界面时会弹出安装进度恢复选项

***

## 使用Term-SD安装AI软件前的准备
安装前，我们需要做一些准备

- 1、设置代理（可选，如果没有一个质量比较好的代理时就不要设置了）

如果用户有代理软件，并且代理的速度和稳定性较好，则先判断代理软件的代理工作模式，一般有TUN模式或者驱动模式的就不需要设置代理，因为这两种代理模式可以让终端环境走代理（其余模式不行）  
但是TUN模式或者驱动模式会让所有流量走代理，而Term-SD在安装AI软件的过程中只有部分下载源需要代理，这将会造成代理流量的浪费。所以，如果代理软件有其他代理模式，最好选这些的，并查看代理软件的代理协议、ip和端口，然后在Term-SD主界面的`代理设置`里选择代理协议，填入ip和端口，回车保存，这样Term-SD就可以决定哪些流量需要走代理  
如果代理没有TUN模式或者驱动模式，则查看代理软件的代理协议、ip和端口，然后在Term-SD设置的`代理设置`里选择代理协议，填入ip和端口，回车保存  

这里举例代理如何填写：
- (1)查找代理协议，ip，端口

查找代理软件为其他软件提供代理时使用的协议，一般来说http和socks比较常见（不是vless，ssr这类协议，这类协议是用在代理软件和代理服务器之间传输数据的），然后查看代理的ip和端口，常见的ip和端口分别是127.0.0.1和10809  
现在的得到以下信息了  
协议：`http`  
ip：`127.0.0.1`  
端口：`10809`

- (2)填入信息

打开Term-SD`设置`，选择`代理设置`，这里询问选择协议，根据刚刚的得到的信息，选择`http协议`，回车，在弹出的输入框中输入`127.0.0.1:10809`，回车保存

- (3)确认代理是否正常使用

在Term-SD的设置中，选择`网络连接测试`进行网络测试，当检测到google、huggingface能够正常访问的时候，说明代理能够正常使用

>在不使用代理后，需要在`代理设置`选择`删除代理参数`来清除代理，防止在代理软件关闭后出现Term-SD无法访问网络的问题  

- 2、设置pip镜像源（推荐）

Term-SD默认已配置该选项，可忽略

~~首先我们在Term-SD设置选择`pip镜像源设置`，进入后可选择`官方源`和`国内镜像源`，这里非常推荐设置为`国内镜像源`（如果之前为pip设置镜像源，包括pypi源、PyTorch源，则不需要再次设置`pip镜像源`）~~  

- 3、设置安装重试功能（推荐）

Term-SD默认已配置该选项，可忽略

~~在Term-SD设置选择`命令执行监测设置`，选择启用，输入重试次数（推荐3），这时就设置好安装重试功能了，在安装AI软件时如果遇到网络不稳定导致命令执行的中断时，将会重新执行中断的命令，保证安装的顺利进行~~

进行上面的步骤后就可以进行AI软件的安装

***

## Term-SD安装功能
Term-SD支持Stable-Diffusion-WebUI，ComfyUI，InvokeAI，Fooocus，lora-scripts，kohya_ss。在Term-SD的主界面对应下面的选项
- 1、Stable-Diffusion-WebUI管理
- 2、ComfyUI管理
- 3、InvokeAI管理
- 4、Fooocus管理
- 5、lora-scripts管理
- 6、kohya_aa管理

需要安装哪一种就选择哪一个管理选项

>1、安装过程请保持网络通畅  
>2、当AI软件安装好后，能启动且无报错时，最好使用`依赖库版本管理`将依赖库的软件包版本备份下来，当AI软件因为软件包版本问题导致AI软件出现报错时就可以用这个功能恢复原来的依赖库版本
>3、Term-SD支持自定义AI软件的安装目录，可以在Term-SD的`设置`->`自定义安装路径`中进行设置

### Stable-Diffusion-WebUI安装
>Stable-Diffusion-WebUI是一款功能丰富，社区资源丰富的AI绘画软件，支持扩展

选中Stable-Diffusion-WebUI管理后，Term-SD会检测该AI是否安装，如果没有安装，Term-SD会提示用户是否进行安装  
选择`是`之后，Term-SD会进入安装准备选项

#### 1、安装镜像选项
第一个是安装镜像选项，共有以下选项
- 1、启用pip镜像源：Term-SD调用pip下载Python软件包时使用国内镜像源进行下载
- 2、huggingface/github独占代理：Term-SD安装AI软件的过程仅为huggingface/github下载源启用代理，减少代理流量的消耗
- 3、强制使用pip：强制使用pip安装Python软件包，一般只有在禁用虚拟环境后才需要启用 
- 4、使用modelscope模型下载源：将安装时使用的huggingface模型下载源改为modelscope模型下载源（因为huggingface在国内无法直接访问）
- 5、github镜像源自动选择：测试可用的github镜像源并选择自动选择，选择该选项后将覆盖手动设置的github镜像源
- 6、启用github镜像源：Term-SD从github克隆源代码时使用github镜像站进行克隆

一般这些选项保持默认即可

>1、`强制使用pip`一般不需要启用，该选项向pip传达--break-system-packages参数进行安装，忽略系统的警告，参考https://stackoverflow.com/questions/75602063/pip-install-r-requirements-txt-is-failing-this-environment-is-externally-mana  
>2、在使用驱动模式或者TUN模式的代理软件时，`huggingface/github独占代理`功能无效，因为代理软件会强制让所有网络流量走代理  
>3、github镜像源有多个，可以根据Term-SD的`设置`->`网络连接测试`的测试结果来选择，或者勾选`github镜像源自动选择`让Term-SD自动选择  
>4、当所有github镜像源都不可用时，只能把所有的`启用github镜像源`、`github镜像源自动选择`选项取消勾选

#### 2、PyTorch版本选择
第二个是PyTorch版本的选择界面，有以下版本组合
- 1、Torch+xformers
- 2、Torch
- 3、Torch 2.0.0（Directml）
- 4、Torch 2.1.0+CPU
- 5、Torch 2.0.1+RoCM 5.4.2
- 6、Torch 2.1.0+RoCM 5.6
- 7、Torch 2.0.0+IPEX
- 8、Torch 2.1.0+IPEX
- 9、Torch 1.12.1（CUDA11.3）+xFormers 0.0.14
- 10、Torch 1.13.1（CUDA11.7）+xFormers 0.0.16
- 11、Torch 2.0.0（CUDA11.8）+xFormers 0.0.18
- 12、Torch 2.0.1（CUDA11.8）+xFormers 0.0.22
- 13、Torch 2.1.1（CUDA11.8）+xFormers 0.0.23
- 14、Torch 2.1.1（CUDA12.1）+xFormers 0.0.23

选择版本时需要根据系统类型和显卡选择  
在Windows系统中，Nvidia显卡选择Torch（CUDA）+xformers的版本，AMD显卡Torch(Directml)的版本，Intel显卡选择Torch 2.0.0+IPEX的版本  
在Linux系统中，Nvidia显卡选择Torch（CUDA）+xformers的版本，AMD显卡选择Torch+Rocm的版本，Intel显卡选择Torch 2.0.0+IPEX版本  
在MacOS系统中，选择Torch版本  
如果想要使用CPU进行跑图，选择Torch+CPU的版本

#### 3、插件选择
第三个是插件选择，Term-SD默认已经勾选一些比较有用的插件，可以根据个人需求进行选择  
在Term-SD的帮助列表中可以查看插件功能的描述，了解插件的用途

#### 4、pip安装模式选择
第四个是pip包管理器的安装模式选择，共有2种模式
- 1、常规安装（setup.py）：使用传统方式进行安装，默认使用二进制软件包进行安装，速度较快
- 2、标准构建安装（--use-pep517）：使用标准编译安装，使用源码编译成二进制软件包再进行安装，耗时比较久，但可以解决一些Python软件包安装失败的问题

一般使用常规安装（setup.py）就行，如果想要保证安装成功，可以选择标准构建安装（--use-pep517）

>在Linux系统中使用常规安装（setup.py）可能会出现安装失败的问题，所以推荐使用标准构建安装（--use-pep517）

#### 5、安装确认
最后一个是安装确认，选择`是`开始安装  
安装时间根据网络速度和电脑性能决定

>1、stable-duffisuon-webui安装成功后，可以前往stable-duffisuon-webui设置调成中文界面（前提是`stable-diffusion-webui-localization-zh_Hans`扩展已经成功安装，在Stable-Diffusion-WebUI的`Extensions（扩展）`选项卡中查看）  
>2、在stable-duffisuon-webui界面点击`Settings`->`User interface`->`Localization`，点击右边的刷新按钮，再选择（防止不显示出来），在列表中选择`zh-Hans（stable）`，再点击上面的`Apply settings`，最后点击`Reload UI`生效

### ComfyUI安装
>ComfyUI是一款节点式操作的AI绘画软件，上手难度较高，但是节点赋予ComfyUI更高的操作上限，且支持将节点工作流保存成文件，支持扩展。同时ComfyUI让用户更好的理解AI绘画的工作原理

选中ComfyUI管理后，Term-SD会检测该AI是否安装，如果没有安装，Term-SD会提示用户是否进行安装  
选择`是`之后，Term-SD会进入安装准备选项

#### 1、安装镜像选项
和Stable-Diffusion-WebUI的选择方法相同

#### 2、PyTorch版本选择
和Stable-Diffusion-WebUI的选择方法相同

#### 3、插件安装
第三个是插件选择，这里不需要勾选任何插件，直接回车进入自定义节点的安装选项
>在ComfyUI中的扩展分为自定义节点和插件，只不过自定义节点很多，而插件几乎没见有人制作（可能没啥用），所以有些人也把自定义节点称为插件。  
>保留这个选项的原因是因为ComfyUI确实存在这个东西，只不过接近废弃  
>参考：https://github.com/comfyanonymous/ComfyUI/discussions/631

#### 4、自定义节点安装
第四个是自定义节点选择，Term-SD默认已经勾选一些比较有用的自定义节点，可以根据个人需求进行选择  
在Term-SD的帮助列表中可以查看自定义节点功能的描述，了解自定义节点的用途

#### 5、pip安装模式选择
和Stable-Diffusion-WebUI的选择方法相同

#### 6、安装确认
最后一个是安装确认，选择`是`开始安装  
安装时间根据网络速度和电脑性能决定

>1、在安装结束后，如果有自定义节点的，需要在`ComfyUI管理`->`自定义节点管理`里运行`安装全部全部自定义节点依赖`，保证自定义节点的正常运行（因为ComfyUI并没有Stable-Diffusion-WebUI自动为扩展安装依赖的功能）  
>2、如果扩展`ComfyUI-Manager`成功安装，可以不用执行`安装全部全部自定义节点依赖`，因为`ComfyUI-Manager`能够自动为扩展安装依赖（`ComfyUI-Manager`把ComfyUI缺失的这个功能给补上了）。
>3、设置中文：进入ComfyUI界面，点击右上角的齿轮图标进入设置，找到`AGLTranslation-langualge`，选择`中文[Chinese Simplified]`，ComfyUi将会自动切换中文

### InvokeAI安装
>InvokeAI是一款操作界面简单的AI绘画软件，功能较少，但拥有特色功能`统一画布`，用户可以在画布上不断扩展图片的大小。  
>目前已经加入了节点功能，可玩性相对早期版本有了较大的提高

选中InvokeAI管理后，Term-SD会检测该AI是否安装，如果没有安装，Term-SD会提示用户是否进行安装  
选择`是`之后，Term-SD会进入安装准备选项

#### 1、安装镜像选项
和Stable-Diffusion-WebUI的选择方法相同

#### 2、PyTorch版本选择
和Stable-Diffusion-WebUI的选择方法相同

#### 3、pip安装模式选择
和Stable-Diffusion-WebUI的选择方法相同

#### 4、安装确认
最后一个是安装确认，选择`是`开始安装  
安装时间根据网络速度和电脑性能决定

>1、安装完成后，在启动选项需要选择`(configure --skip-sd-weights)`进行配置，配置完成后再选择`(web)`启动webui界面
>2、设置中文：进入InvokeAI界面，点击右上角的三条横杠的图标，点击`Settings`，然后找到`Language`选项，点击文字下方的选项框，找到`简体中文`并选中，InvokeAI就会把界面切换成中文

### Fooocus安装
>Fooocus是一款专为SDXL模型优化的AI绘画软件，界面简单，让使用者可以专注于提示词的书写，而且有着非常强的内存优化和速度优化，强于其他同类webui。目前Fooocus对标Midjourney，为把复杂的生图流程进行简化

选中Fooocus管理后，Term-SD会检测该AI是否安装，如果没有安装，Term-SD会提示用户是否进行安装  
选择`是`之后，Term-SD会进入安装准备选项

#### 1、安装镜像选项
和Stable-Diffusion-WebUI的选择方法相同

#### 2、PyTorch版本选择
和Stable-Diffusion-WebUI的选择方法相同

#### 3、pip安装模式选择
和Stable-Diffusion-WebUI的选择方法相同

#### 4、安装确认
最后一个是安装确认，选择`是`开始安装  
安装时间根据网络速度和电脑性能决定


### lora-scripts安装
>lora-scripts是一款AI模型训练工具，支持训练lora模型、dreambooth模型，而且界面附带各个训练参数的解释，为使用者降低了操作难度。lora-scripts还附加了图片批量打标签的工具和图片标签批量编辑工具，非常方便

选中lora-scripts管理后，Term-SD会检测该AI是否安装，如果没有安装，Term-SD会提示用户是否进行安装  
选择`是`之后，Term-SD会进入安装准备选项

#### 1、安装镜像选项
和Stable-Diffusion-WebUI的选择方法相同

#### 2、PyTorch版本选择
和Stable-Diffusion-WebUI的选择方法相同

#### 3、pip安装模式选择
和Stable-Diffusion-WebUI的选择方法相同

#### 4、安装确认
最后一个是安装确认，选择`是`开始安装  
安装时间根据网络速度和电脑性能决定


### kohya_ss安装
>kohya_ss是一款AI模型训练工具，支持训练lora、dreambooth、Finetune、Train Network模型

选中kohya_ss管理后，Term-SD会检测该AI是否安装，如果没有安装，Term-SD会提示用户是否进行安装  
选择`是`之后，Term-SD会进入安装准备选项

#### 1、安装镜像选项
和Stable-Diffusion-WebUI的选择方法相同

#### 2、PyTorch版本选择
和Stable-Diffusion-WebUI的选择方法相同

#### 3、pip安装模式选择
和Stable-Diffusion-WebUI的选择方法相同

#### 4、安装确认
最后一个是安装确认，选择`是`开始安装  
安装时间根据网络速度和电脑性能决定

***

## Term-SD管理功能
当AI软件成功安装后，就可以使用Term-SD的管理功能来启动或者管理AI了  
在6个AI管理界面中，包含一些功能对AI进行管理

### 1、更新
更新AI软件。当AI软件出现更新失败时（非网络的原因），可以使用`修复更新`功能来修复问题

>有时候扩展和AI软件的版本不匹配时（AI软件的版本很新，而扩展的版本很旧），就容易出现报错，此时就可以通过更新解决

### 2、卸载
卸载AI软件，且该操作无法恢复，请谨慎选择

### 3、修复更新
该功能用于修复因为git分支签出或者手动更改了源代码文件导致更新失败的问题，使用时将会把分支切换成主分支并还原被修改的源代码

### 4、插件管理
该功能用于管理插件，包含以下功能

- 1、安装：使用git安装插件
- 2、管理：对插件进行管理，提供了一个插件列表浏览器来选择插件
- 3、更新全部插件：一键更新全部插件
- 4、安装全部插件依赖：一键将所有插件需要的依赖进行安装（仅限ComfyUI）

选中一个插件后，包含以下功能用于管理插件：
- (1) 更新：更新插件
- (2) 卸载：卸载插件，且该操作无法恢复，请谨慎选择
- (3) 修复更新：修复插件无法更新的问题
- (4) 切换版本：切换插件的版本
- (5) 更新源切换：切换插件的更新源，加速下载；当某个github镜像源无法使用导致无法更新插件时，也可以使用该功能将更新源切换到可用的github镜像源或者切换成github源
- (6) 安装依赖（仅限ComfyUI）：安装插件运行时所需的依赖

>1、如果安装了`ComfyUI-Manager`这个扩展，就不需要使用`安装全部插件依赖`这个功能了  
>2、有时候扩展和AI软件的版本不匹配时（AI软件的版本很新，而扩展的版本很旧），就容易出现报错，此时就可以通过更新解决

### 5、自定义节点管理
用于管理自定义节点，包含以下功能
>仅限ComfyUI

- 1、安装：使用git安装自定义节点
- 2、管理：对插件进行管理，提供了一个自定义节点列表浏览器来选择插件
- 3、更新全部自定义节点：一键更新全部自定义节点
- 4、安装全部自定义节点依赖：一键将所有自定义节点需要的依赖进行安装

选中一个自定义节点后，包含以下功能用于管理自定义节点：
- 1、更新：更新自定义节点
- 2、卸载：卸载自定义节点，且该操作无法恢复，请谨慎选择
- 3、修复更新：修复自定义节点无法更新的问题
- 4、切换版本：切换自定义节点的版本
- 5、更新源切换：切换自定义节点的更新源，加速下载；当某个github镜像源无法使用导致无法更新插件时，也可以使用该功能将更新源切换到可用的github镜像源或者切换成github源
- 6、安装依赖：安装自定义节点运行时所需的依赖

>1、如果安装了`ComfyUI-Manager`这个扩展，就不需要使用`安装全部自定义节点依赖`这个功能了  
>2、有时候扩展和AI软件的版本不匹配时（AI软件的版本很新，而扩展的版本很旧），就容易出现报错，此时就可以通过更新解决

### 6、切换版本
该功能将会列出所有版本的hash值和对应的日期，可根据这些进行版本选择并切换过去

### 7、更新源切换
该功能用于切换更新源，加速下载；当某个github镜像源无法使用导致无法更新插件时，也可以使用该功能将更新源切换到可用的github镜像源或者切换成github源
>有时候某个github镜像源无法使用的时候，使用更新功能时就会导致更新失败，可以通过该功能把更新源切换成其他的github镜像源，如果镜像源都无法使用时，就把更新源切换成github源

### 8、启动
该功能用于启动AI软件  

>1、在Stable-Diffusion-WebUI、ComfyUI、InvokeAI，Fooocus中可以选择`配置预设启动参数`或者`修改自定义启动参数`，从而使用一些功能  
>2、当使用`配置预设启动参数`来配置启动参数时，将会删除之前设置的启动参数。而使用`修改自定义启动参数`可以修改上次设置的启动参数

### 9、更新依赖
该功能用于更新AI软件依赖的Python软件包，可用于解决AI软件的部分依赖版本太旧导致运行报错，一般用不上

>有时通过更新AI软件依赖可解决报错问题

### 10、重新安装
该功能用于重新执行AI软件的安装过程，一般用不上

### 11、重新安装PyTorch
该功能用于切换PyTorch的版本  
- 1、当PyTorch出现问题导致PyTorch无法使用GPU时，可以使用该功能重装PyTorch
- 2、当PyTorch版本和GPU不匹配时，可以通过该功能切换版本
- 3、当需要更新PyTorch时，也可以使用这个功能来更新

>在重新安装PyTorch前，Term-SD将弹出PyTorch版本的选择、是否使用标准编译安装、是否使用强制安装的的选项，选择完成后会弹出确认安装的选项，选择确定进行安装

### 12、修复虚拟环境
该功能用于修复生成AI软件使用的虚拟环境，一般在移动AI软件的位置，AI软件运行出现问题后才用

>虚拟环境在移动位置后就出现问题，这是一个特性。当然这个功能可以解决这个问题

### 13、重新构建虚拟环境
该功能用于重新构建AI软件使用的虚拟环境，一般用在移动AI软件的位置后、AI软件运行出现报错（有一些时候是Python依赖库出现了版本错误或者损坏，或者装了一些插件后出现问题，删除插件后问题依然没有解决）、安装AI软件前禁用了虚拟环境，安装后启用了虚拟环境，需要修复虚拟环境  
这个功能一般不需要用，除非解决不了一些Python库报错问题（因为该功能将会重新构建虚拟环境，需要消耗比较长的时间）

>这个功能可以解决环境出现严重问题、环境因为安装一些东西而炸掉。如果这个功能还不能解决报错，有可能是因为AI本体和插件的版本冲突，Python版本过新或者过旧等问题。在这种情况下只能自行查找原因

### 14、分支切换
>仅限Stable-Diffusion-WebUI  

该功能用于把`AUTOMATIC1111/Stable-Diffusion-WebUI`的分支切换成`vladmandic/SD.NEXT`或者`lshqqytiger/Stable-Diffusion-WebUI-DirectML`（或者切换回来），或者切换成主分支或者测试分支

### 15、Python软件包安装/重装/卸载
该功能用于安装/重装/卸载Python软件包，处理Python软件包的问题  
界面有以下选项：
- 1、常规安装(install)：安装Python软件包并安装该软件包依赖的软件包
- 2、仅安装(--no-deps)：安装Python软件包，但不安装该软件包依赖的软件包
- 3、强制重装(--force-reinstall)：强制安装Python软件包，当该软件包已存在，则重新安装，且强制安装该软件包依赖的软件包
- 4、仅强制重装(--no-deps --force-reinstall)：强制安装Python软件包，当该软件包已存在，则重新安装，但不安装该软件包依赖的软件包
- 5、卸载(uninstall)：卸载Python软件包

如何选择：
- (1) 当缺失某个软件包时，选择安装
- (2) 当某个软件包损坏时，可以选择强制重装
- (3) 如果需要卸载某个软件包，就选择卸载
- (4) 带有`仅`的功能是在安装时只安装用户输入的软件包，而不安装这些软件包的依赖

安装/重装软件包时可以只写包名，也可以指定包名版本；可以输入多个软件包的包名,并使用空格隔开。例：
```
xformers
xformers==0.0.21
xformers==0.0.21 numpy
```

### 16、依赖库版本管理
该功能用于记录Python依赖库的版本，在AI软件运行正常时，可以用该功能记录Python依赖库的各个软件包版本，当因为装插件等导致依赖库的软件包版本出现错误而导致报错时，可用该功能恢复原来依赖库的各个软件包版本，从而解决报错

>比如安装TensorRT前，先使用这个功能备份依赖库的版本，然后再安装TensorRT。当TensorRT把依赖库环境搞炸的时候（有概率），把TernsorRT卸载，并使用该功能恢复依赖库。如果还没恢复，只能使用`重新构建虚拟环境`来修复

### 17、重新安装后端组件
>仅限Stable-Diffusion-WebUI，Fooocus

该功能用于重新下载后端需要的组件，组件可在`AI软件文件夹/repositories`文件夹中查看

***

## Term-SD更新管理
该功能用于对Term-SD自身的更新等进行管理，共有以下选项
- 1、更新：更新Term-SD
- 2、切换更新源：Term-SD有多个下载源，用于解决某些更新源更新慢或者无法更新的问题，一般来说github源的版本变化较快，其他源的版本变化会有延后（大约延迟一天，因为其他源每隔一天同步一次github仓库）
- 3、切换分支：Term-SD总共有两个分支，main和dev，一般不需要切换
- 4、修复更新：当用户手动修改Term-SD的文件后，在更新Term-SD时就容易出现更新失败的问题，该功能可修复该问题（会把用户自行修改的部分还原）
- 5、设置自动更新：启用后Term-SD在启动时会检测是否有更新，当有新版本时会提示用户进行更新

***

## Term-SD设置
该界面提供了各种配置运行环境的设置，设置如下：

### 虚拟环境设置
配置Term-SD在安装，管理AI时是否使用虚拟环境，建议保持启用（默认）。虚拟环境创建了一个隔离环境，保证不同的AI软件的Python依赖库不会互相干扰，也防止系统中的Python依赖库不会互相干扰，因为AI软件对同一个Python软件包的要求版本不一致

### pip镜像源设置(配置文件)
该功能通过修改pip配置文件来修改pip的下载源，而Term-SD也包含另一个修改pip镜像源的功能`pip镜像源设置(环境变量)`（环境变量的优先级比配置文件高，所以pip优先使用环境变量的配置），也是类似的功能，只不过不需要修改pip配置文件，个人建议这个设置不用调（因为Term-SD默认通过pip镜像源设置(环境变量)来设置pip镜像源）  
设置中有以下选项：
- 1、设置官方源：将pip的下载源切换成官方源，但可能会导致下载慢或者下载失败的问题
- 2、设置国内镜像源：将pip的下载源切换成国内镜像源，解决官方源下载慢或者下载失败的问题，推荐选择
- 3、删除镜像源配置：将pip的下载源配置清除

### pip镜像源设置(环境变量)
该功能通过设置环境变量来设置pip镜像源（环境变量设置的优先级比配置文件的设置高），而该设置默认选择国内的镜像源，所以一般来说不用修改
设置中有以下选项
- 1、设置官方源：将pip的下载源切换成官方源，但可能会导致下载慢或者下载失败的问题
- 2、设置国内镜像源：将pip的下载源切换成国内镜像源，解决官方源下载慢或者下载失败的问题，推荐选择

### pip缓存清理
显示pip下载软件包产生的缓存路径和大小，也可以清理pip下载Python软件包产生的缓存

### 代理设置
该功能为了设置下载时使用的网络代理，解决部分下载源下载失败的问题，因为一些代理软件的代理模式并不能让终端环境使用代理，除了TUN模式或者驱动模式（使用虚拟网卡）可以让终端环境使用代理。一般代理软件都会开放一个ip和端口用于代理，Term-SD可以通过手动设置ip和端口使终端环境使用代理，解决AI软件因无法连接到部分地址（如huggingface）而导致报错。对于有TUN模式或者驱动模式的代理软件，个人建议不使用这类模式，因为这会让Term-SD的所有流量走代理，增大代理流量的消耗，所以建议使用该功能设置代理  
设置有以下选项：
- 1、http：设置http协议的代理
- 2、socks：设置socks协议的代理
- 3、socks5：设置socks5协议的代理
- 4、删除代理参数：将设置的代理参数删除

设置代理时，用户需要选择代理协议，具体使用什么代理协议取决于所使用的代理软件开放的ip是用什么代理协议  
这里举例代理如何填写：
- (1)查找代理协议，ip，端口

查找代理软件为其他软件提供代理时使用的协议，一般来说http和socks比较常见（不是vless，ssr这类协议，这类协议是用在代理软件和代理服务器之间传输数据的），然后查看代理的ip和端口，常见的ip和端口分别是127.0.0.1和10809  
现在的得到以下信息了  
协议：`http`  
ip：`127.0.0.1`  
端口：`10809`

- (2)填入信息

打开Term-SD`设置`，选择`代理设置`，这里询问选择协议，根据刚刚的得到的信息，选择`http协议`，回车，在弹出的输入框中输入`127.0.0.1:10809`，回车保存

- (3)确认代理是否正常使用

在Term-SD的设置中，选择`网络连接测试`进行网络测试，当检测到google、huggingface能够正常访问的时候，说明代理能够正常使用

>1、在不使用代理后，需要在`代理设置`里删除代理参数，防止在代理软件关闭后出现Term-SD无法访问网络的问题  
>2、Term-SD和AI软件的运行环境为终端，而终端并不会直接使用代理，所以需要手动设置。这是因为当系统配置了代理后，是否使用系统的代理由软件自己决定，比如浏览器就使用系统的代理，而终端不使用系统的代理，它使用代理是通过设置环境变量。  
>有关终端设置代理的方法可参考https://blog.csdn.net/Dancen/article/details/128045261

### 命令执行监测设置
该功能用于监测命令的运行情况,若设置了重试次数,Term-SD将重试执行失败的命令(有些命令需要联网,在网络不稳定的时候容易导致命令执行失败),保证命令执行成功

>Term-SD在安装成功后默认启用并设置为3

### Term-SD安装模式
该功能用于设置Term-SD安装AI软件的工作模式。当启用`严格模式`后,Term-SD在安转AI软件时出现执行失败的命令时将停止安装进程(Term-SD支持断点恢复,可恢复上次安装进程中断的位置),而`宽容模式`在安转AI软件时出现执行失败的命令时忽略执行失败的命令继续执行完成安装任务。默认设置为`严格模式`  
设置有以下选项
- 1、严格模式：将Term-SD安装AI软件的工作模式设置为严格模式，当出现执行失败的命令时将停止安装进程
- 2、宽容模式：将Term-SD安装AI软件的工作模式设置为严格模式，当出现执行失败的命令时将跳过执行失败的命令，而不终止安装进程

>1、Term-SD在恢复原来的安装进度时，依然会遍历所有安装需要的命令，但是已经执行成功后的命令并不会执行  
>2、`严格模式`这个模式主要用于防止意外结果发生的，比如框架没有能够成功下载下来，之后Term-SD执行其他的命令时，就有可能导致其他文件散落在安装目录中（不会清理电脑垃圾的遇到这种问题还是很头疼的）  
>3、`严格模式`搭配上Term-SD的伪断点恢复功能（只为AI软件的安装设计了这个功能），可以在安装中断后重新恢复安装进度

### Aria2线程设置
该功能用于增加Term-SD在使用Aria2下载模型时的线程数,在一定程度上提高下载速度

### 缓存重定向设置
该功能将会把AI软件产生的缓存重定向至Term-SD目录中，位于cache文件夹，不过有些AI软件会把模型下载到缓存目录中，存在于`unet`文件夹和`huggingface`文件夹中，在清理缓存中需要注意

>该设置默认启用，为了方便清理AI软件产生的缓存

### CUDA内存分配设置
该功能用于设置CUDA分配显存使用的分配器，当CUDA版本大于11.4+且PyTorch版本大于2.0.0时，可以设置为`CUDA(11.4+)内置异步分配器`，加速AI软件的运行，否则设置为`PyTorch原生分配器`或者不设置  
设置有以下选项
- 1、PyTorch原生分配器：将CUDA内存分配器设置为PyTorch原生分配器
- 2、CUDA(11.4+)内置异步分配器：将CUDA内存分配器设置为CUDA内置异步分配器，加速AI软件的运行
- 3、清除设置：清除CUDA内存分配设置

>该功能仅限在nvidia显卡上使用

### 自定义安装路径
该功能用于自定义AI软件的安装路径,当保持默认时,AI软件的安装路径与Term-SD所在路径同级  
- 1、Stable-Diffusion-WebUI安装路径设置：修改Stable-Diffusion-WebUI的安装路径
- 2、ComfyUI安装路径设置：修改ComfyUI的安装路径
- 3、InvokeAI安装路径设置：修改InvokeAI的安装路径
- 4、Fooocus安装路径设置：修改Fooocus的安装路径
- 5、lora-scripts安装路径设置：修改lora-scripts的安装路径
- 6、kohya_ss安装路径设置：修改kohya_ss的安装路径

当选择其中一项子设置时，即可修改该设置对应的AI软件的安装路径  
子设置中有以下选项
- (1) 设置安装路径：自定义AI软件的安装路径
- (2) 恢复默认安装路径设置：恢复AI软件默认的安装路径，默认安装路径和Term-SD所在路径同级

>- 1、路径最好使用绝对路径（目前没有见过哪个软件使用相对路径来安装软件的）  
>- 2、如果是Windows系统,请使用MSYS2可识别的路径格式,如:`D:\\Downloads\\webui`要写成`/d/Downloads/webui`

### 空间占用分析
该功能用于统计各个AI软件的空间占用和Term-SD重定向的缓存占用情况
>统计占用的时间可能会很长

### 网络连接测试
测试网络环境，用于测试代理是否可用。该功能将会测试网络连接是否正常，并测试google，huggingface，github，ghproxy等能否访问。在安装时出现的`代理设置`中，有的github镜像源可能无法访问，可以通过该功能查看哪些镜像源可用

### 卸载Term-SD
卸载Term-SD本体程序，保留已下载的AI软件

>Term-SD的扩展脚本`file-backup`备份的文件保存在Term-SD目录中的`backup`文件夹中。如需要保留，请在卸载Term-SD前将其移至其它路径中

***

## Term-SD额外功能

### 扩展脚本
Term-SD包含了一些扩展脚本，扩充Term-SD的功能
- 1、download-hanamizuki：下载绘世启动器，并自动放入绘世启动器支持的AI软件的目录中
- 2、list：列出可用的扩展脚本
- 3、invokeai-model-download：下载InvokeAI模型，包含controlnet模型和部分大模型模型，解决使用官方配置程序因无法访问huggingface而下载失败的问题
- 4、download-sd-webui-extension：下载Stable-Diffusion-WebUI插件（脚本包含的插件列表在Term-SD的帮助中有说明）
- 5、download-comfyui-extension：下载ComfyUI插件（脚本包含的插件列表在Term-SD的帮助中有说明）
- 6、fix-bitsandbytes-for-kohya-ss-on-windows：修复原版bitsandbytes在Windows端无法运行导致kohya_ss报错无法进行训练的问题
- 7、fix-bitsandbytes-for-sd-webui-on-windows：修复原版bitsandbytes在Windows端无法运行导致Stable-Diffusion-WebUI中的模型训练插件报错无法进行训练的问题（训练模型不建议在Stable-Diffusion-WebUI中进行，请使用lora-scripts或者kohya_ss进行模型训练）
- 8、file-backup：备份/恢复AI软件的数据，备份文件储存在Term-SD的`backup`文件夹中

>如果需要使用扩展脚本，则在启动Term-SD前加入`--extra`启动参数即可使用扩展脚本

### 启动参数
在使用命令Term-SD时，可以添加启动参数来使用Term-SD额外的功能

#### 启动参数的使用方法
```
./term-sd.sh [--help] [--extra script_name] [--reinstall-term-sd] [--remove-term-sd] [--quick-cmd] [--set-python-path python_path] [--unset-python-path] [--update-pip] [--bar display_mode] [--debug]
```

>中括号`[]`仅用来展示，在使用的时候不要输入进去  
当使用--quick-cmd安装了快捷命令，可将`./term-sd.sh`替换成`term_sd`或者`tsd`

#### 启动参数的功能解析
- 1、help

显示启动参数帮助


- 2、extra

启动扩展脚本显示界面，选中其中一个启动脚本后即可启动，如果参数后面输入扩展脚本的名字，则直接启动指定的扩展脚本


- 3、reinstall-term-sd

重新安装Term-SD。Term-SD会提示用户如何重新安装，根据提示操作即可


- 4、remove-term-sd

卸载Term-SD，该功能将会删除Term-SD自身的所有组件和快捷启动命令，只保留已经安装的AI软件


- 5、quick-cmd

将Term-SD快捷启动指令安装到shell中，在shell中直接输入`term_sd`或者`tsd`即可启动Term-SD，且不需要在Term-SD所在目录就能启动Term-SD（用`./term-sd.sh`命令启动还是需要在Term-SD所在目录里才能用）。该功能会提示用户选择安装快捷启动命令还是删除快捷启动命令，根据提示进行操作


- 6、set-python-path

手动指定Python解释器路径（一定是绝对路径），当选项后面输入了路径，则直接使用输入的路径来设置Python路径（建议用`" "`把路径括起来），否则启动设置界面  
路径的参考格式如下：
```
/usr/bin/python
/c/Python/python.exe
/c/Program Files/Python310/python
/d/Program Files/Python310/python.exe
/usr/bin/python3
```
>根据自己安装的路径来填。在Windows系统中，每个文件夹的分隔符不要使用反斜杠，Windows系统中的盘符，如`C:`，`D:`，要改成`/c`，`/d`，因为MSYS2不认识这些路径符号


- 7、unset-python-path

删除自定义Python解释器路径配置


- 8、bar

设置Term-SD初始化进度条显示模式，有以下几种：  
（1）none：禁用进度条显示  
（2）normal：使用默认的显示模式  
（3）new：使用新的进度条显示


- 12、update-pip

进入虚拟环境时更新pip软件包管理


- 13、debug

显示调试信息

***

## 绘世启动器的使用
目前绘世启动器支持启动Stable-Diffusion-WebUI（A1111-sd-webui/vlad-SD.NEXT/sd-webui-directml）、ComfyUI、Fooocus。使用Term-SD部署Stable-Diffusion-WebUI、ComfyUI、或者Fooocus后，将绘世启动器放入Stable-Diffusion-WebUI文件夹、ComfyUI文件夹或者Fooocus文件夹后就可以使用绘世启动器启动对应的AI软件了（可以使用Term-SD扩展脚本中的download-hanamizuki脚本来下载绘世启动器，并且脚本会自动将绘世启动器放入上述文件夹中）

||绘世启动器依赖|
|---|---
|↓|[Microsoft Visual C++](https://aka.ms/vs/17/release/vc_redist.x64.exe)|
|↓|[.NET 6.0](https://dotnet.microsoft.com/zh-cn/download/dotnet/thank-you/sdk-6.0.417-windows-x64-installer)|
|↓|[.NET 8.0](https://dotnet.microsoft.com/zh-cn/download/dotnet/thank-you/sdk-8.0.100-windows-x64-installer)|
>使用绘世前需要安装依赖

||绘世启动器|
|---|---|
|↓|[下载地址1](https://github.com/licyk/term-sd/releases/download/archive/hanamizuki.exe)|
|↓|[下载地址2](https://gitee.com/licyk/term-sd/releases/download/archive/hanamizuki.exe)|
