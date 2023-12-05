# Tern-SD使用教程

## Term-SD的初始化
Term-SD在下载好后，只会有一个基础的配置脚本“term-sd.sh”，当运行这个配置脚本时，Term-SD会检测运行所需依赖。当检测到缺少依赖时，Term-SD会提示用户需要去安装的依赖，并自动退出，这时候需要用户检查这些依赖是否安装，并且把缺失的依赖装上  
当检测到依赖都安装时，脚本会提示用户安装Term-SD的完整组件

这时候输入“y”即可进行下载  

在下载前。Term-SD会询问选择哪个下载源  
总共有以下下载源：
- 1、github源
- 2、gitee源
- 3、gitlab源
- 4、jihulab源
- 5、代理源(ghproxy.com)

一般情况下选择任意一种都可以进行下载  
如果下载失败，Term-SD将会自动退出，这时再次运行Term-SD，选择其他下载源来重新下载  
当成功下载时，Term-SD将会自动初始化模块，并启动

***

## Term-SD的主界面介绍
Term-SD在成功启动后，首先显示的是各个组件的版本信息，选择确定后就进入Term-SD的主界面  
主界面有以下选项
- 1、Term-SD更新管理：管理，修复Term-SD的更新
- 2、AUTOMATIC1111-stable-diffusion-webui管理：包含各种AUTOMATIC1111-stable-diffusion-webui的管理功能
- 3、ComfyUI管理：包含各种ComfyUI的管理功能
- 4、InvokeAI管理：包含各种InvokeAI的管理功能
- 5、Fooocus管理：包含各种Fooocus的管理功能
- 6、lora-scripts管理：包含各种lora-scripts的管理功能
- 7、kohya_ss管理：包含各种kohya_ss的管理功能
- 7、设置：包含Term-SD各种设置
- 8、帮助：Term-SD的各种帮助文档

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
该界面提供以下设置：

### 虚拟环境设置
配置Term-SD在安装。管理ai时是否使用虚拟环境，建议保持启用（默认）。虚拟环境创建了一个隔离环境，保证不同的AI软件的python依赖库不会互相干扰，也防止系统中的python依赖库不会互相干扰，因为AI软件对同一个python软件包的要求版本不一致

### pip镜像源设置(配置文件)
该功能通过修改pip配置文件来修改pip的下载源，而Term-SD也包含另一个修改pip镜像源的功能“pip镜像源设置(环境变量)”（环境变量的优先级比配置文件高，所以pip优先使用环境变量的配置），也是类似的功能，只不过不需要修改pip配置文件，个人建议这个设置不用调（因为Term-SD默认通过pip镜像源设置(环境变量)来设置pip镜像源）  
设置中有以下选项
- 1、设置官方源：将pip的下载源切换成官方源，但可能会导致下载慢或者下载失败的问题
- 2、设置国内镜像源：将pip的下载源切换成国内镜像源，解决官方源下载慢或者下载失败的问题，推荐选择
- 3、删除镜像源配置：将pip的下载源设置清除

### pip镜像源设置(环境变量)
该功能通过设置环境变量来设置pip镜像源（环境变量设置的优先级比配置文件的设置高），而该设置默认选择国内的镜像源，所以一般来说不用修改
设置中有以下选项
- 1、设置官方源：将pip的下载源切换成官方源，但可能会导致下载慢或者下载失败的问题
- 2、设置国内镜像源：将pip的下载源切换成国内镜像源，解决官方源下载慢或者下载失败的问题，推荐选择

### pip缓存清理
显示pip下载软件包产生的缓存路径和大小，也可以清理pip下载python软件包产生的缓存

### 代理设置
该功能为了设置下载时使用的网络代理，解决部分下载源下载失败的问题，因为一些代理软件的代理模式并不能让终端环境使用代理，除了TUN模式或者驱动模式（使用虚拟网卡）可以让终端环境使用代理。一般代理软件都会开放一个ip和端口用于代理，Term-SD可以通过手动设置ip和端口使终端环境使用代理，解决AI软件因无法连接到部分地址（如huggingface）而导致报错。对于有TUN模式或者驱动模式的代理软件，个人建议不使用这类模式，因为这会让Term-SD的所有流量走代理，增大代理流量的消耗，所以建议使用该功能设置代理  
设置有以下选项
- 1、http：设置http协议的代理
- 2、socks：设置socks协议的代理
- 3、socks5：设置socks5协议的代理
- 4、删除代理参数：将设置的代理参数删除

设置代理时，用户需要选择代理协议，具体使用什么代理协议取决于所使用的代理软件开放的ip是用什么代理协议

>在不使用代理后，需要在“代理设置”里删除代理参数，防止在代理软件关闭后出现Term-SD无法访问网络的问题

### 命令执行监测设置
该功能用于监测命令的运行情况,若设置了重试次数,Term-SD将重试执行失败的命令(有些命令需要联网,在网络不稳定的时候容易导致命令执行失败),保证命令执行成功，Term-SD在安装成功后默认启用并设置为3

### Term-SD安装模式
该功能用于设置Term-SD安装AI软件的工作模式。当启用“严格模式”后,Term-SD在安转AI软件时出现执行失败的命令时将停止安装进程(Term-SD支持断点恢复,可恢复上次安装进程中断的位置),而“宽容模式”在安转AI软件时出现执行失败的命令时忽略执行失败的命令继续执行完成安装任务。默认设置为“严格模式”  
设置有以下选项
- 1、严格模式：将Term-SD安装AI软件的工作模式设置为严格模式，当出现执行失败的命令时将停止安装进程
- 2、宽容模式：将Term-SD安装AI软件的工作模式设置为严格模式，当出现执行失败的命令时将跳过执行失败的命令，而不终止安装进程

>Term-SD在恢复原来的安装进度时，依然会遍历所有安装需要的命令，但是已经执行成功后的命令并不会执行

### aria2线程设置
该功能用于增加Term-SD在使用aria2下载模型时的线程数,在一定程度上提高下载速度

### 缓存重定向设置
该功能将会把AI软件产生的缓存重定向至Term-SD目录中，位于cache文件夹，不过有些AI软件会把模型下载到缓存目录中，存在于“unet”文件夹和“huggingface”文件夹中，在清理缓存中需要注意。该设置默认启用

### CUDA内存分配设置
该功能用于设置CUDA分配显存使用的分配器，当CUDA版本大于11.4+且pytorch版本大于2.0.0时，可以设置为“CUDA(11.4+)内置异步分配器”，加速AI软件的运行，否则设置为“PyTorch原生分配器”或者不设置  
设置有以下选项
- 1、PyTorch原生分配器：将CUDA内存分配器设置为PyTorch原生分配器
- 2、CUDA(11.4+)内置异步分配器：将CUDA内存分配器设置为CUDA内置异步分配器，加速AI软件的运行
- 3、清除设置：清除CUDA内存分配设置

>该功能仅限nvidia显卡上使用

### 空间占用分析
该功能用于统计各个AI软件的空间占用和Term-SD重定向的缓存占用情况

### 网络连接测试
测试网络环境，用于测试代理是否可用。该功能将会测试网络连接是否正常，并测试google，huggingface，github，ghproxy等能否访问。在安装时出现的“代理设置”中，有的github镜像源可能无法访问，可以通过该功能查看哪些镜像源可用

### 卸载Term-SD
卸载Term-SD本体程序，保留已下载的AI软件

***

## Term-SD的准备功能
Term-SD在使用安装、管理功能时，会使用准备功能来对一些操作进行准备工作，共有以下功能
>这些功能会经常出现

### 1、安装镜像选项
有以下选项：
- 1、启用pip镜像源：Term-SD调用pip下载python软件包时使用国内镜像源进行下载
- 2、huggingface/github独占代理：Term-SD安装AI软件的过程仅为huggingface/github下载源启用代理，减少代理流量的消耗
- 3、强制使用pip：强制使用pip安装python软件包，一般只有在禁用虚拟环境后才需要启用 
- 4、使用modelscope模型下载源：将安装时使用的huggingface模型下载源改为modelscope模型下载源（因为huggingface在国内无法直接访问）
- 5、github镜像源自动选择：测试可用的github镜像源并选择自动选择，选择该选项后将覆盖手动设置的github镜像源
- 6、启用github代理：Term-SD从github克隆源代码时使用github代理镜像站进行克隆

一般这些选项保持默认即可

>强制使用pip一般不需要启用，该选项向pip传达--break-system-packages参数进行安装，忽略系统的警告，参考https://stackoverflow.com/questions/75602063/pip-install-r-requirements-txt-is-failing-this-environment-is-externally-mana

### 2、pytorch版本选项
有以下版本组合：
- 1、Torch+xformers
- 2、Torch
- 3、Torch 2.0.0+Torch-Directml
- 4、Torch 2.1.0+CPU
- 5、Torch 2.0.1+RoCM 5.4.2
- 6、Torch 2.1.0+RoCM 5.6
- 7、Torch 1.12.1（CUDA11.3）+xFormers 0.014
- 8、Torch 1.13.1（CUDA11.7）+xFormers 0.016
- 9、Torch 2.0.0（CUDA11.8）+xFormers 0.018
- 10、Torch 2.0.1（CUDA11.8）+xFormers 0.022
- 11、Torch 2.1.0（CUDA12.1）+xFormers 0.022post7

选择版本时需要根据系统类型和显卡选择  
- 在Windows系统中，Nvidia显卡选择Torch（CUDA）+xformers的版本，AMD显卡和Intel显卡选择Torch+Torch-Directml的版本  
- 在Linux系统中，Nvidia显卡选择Torch（CUDA）+xformers的版本，AMD显卡选择Torch+Rocm的版本，Intel显卡选择Torch版本  
- 在MacOS系统中，选择Torch版本  
- 如果想要使用CPU进行跑图，选择Torch+CPU的版本

### 3、pip安装模式选项
该功能用于选择pip的安装模式，可解决某些情况下安装python软件包失败的问题，如果不在意安装时间，可以选择标准构建安装（--use-pep517），保证安装成功；选择常规安装（setup.py）也可以，安装速度会比较快，但可能会出现安装失败的问题  
该界面共有2种模式可以选择
- 1、常规安装（setup.py）：使用传统方式进行安装，默认使用二进制软件包进行安装，速度较快
- 2、标准构建安装（--use-pep517）：使用标准编译安装，使用源码编译成二进制软件包再进行安装，耗时比较久，但可以解决一些python软件包安装失败的问题

>在Linux系统中使用常规安装（setup.py）可能会出现安装失败的问题，所以推荐使用标准构建安装（--use-pep517）

### 4、pip操作方式
该功能用于选择对python软件包的操作方式  
该界面有以下选项
- 1、常规安装(install)：安装python软件包并安装该软件包依赖的软件包
- 2、仅安装(--no-deps)：安装python软件包，但不安装该软件包依赖的软件包
- 3、强制重装(--force-reinstall)：强制安装python软件包，当该软件包已存在，则重新安装，且强制安装该软件包依赖的软件包
- 4、仅强制重装(--no-deps --force-reinstall)：强制安装python软件包，当该软件包已存在，则重新安装，但不安装该软件包依赖的软件包
- 5、卸载(uninstall)：卸载python软件包

当缺失某个软件包时，选择安装  
当某个软件包损坏时，可以选择强制重装  
如果需要卸载某个软件包，就选择卸载

>该选项仅在python软件包安装/重装/卸载功能出现

### 5、安装确认选项
该功能用于展示部分安装信息，并确认是否安装

### 6、安装进度恢复选项
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
但是TUN模式或者驱动模式会让所有流量走代理，而Term-SD在安装AI软件的过程中只有部分下载源需要代理，这将会造成代理流量的浪费。所以，如果代理软件有其他代理模式，最好选这些的，并查看代理软件的代理协议、ip和端口，然后在Term-SD主界面的“代理设置”里选择代理协议，填入ip和端口，回车保存，这样Term-SD就可以决定哪些流量需要走代理  
如果代理没有TUN模式或者驱动模式，则查看代理软件的代理协议、ip和端口，然后在Term-SD设置的“代理设置”里选择代理协议，填入ip和端口，回车保存  

>在不使用代理后，需要在“代理设置”里删除代理参数，防止在代理软件关闭后出现Term-SD无法访问网络的问题  

- 2、设置pip镜像源（推荐）

Term-SD默认已配置该选项，可忽略

~~首先我们在Term-SD设置选择“pip镜像源设置”，进入后可选择“官方源”和“国内镜像源”，这里非常推荐设置为“国内镜像源”（如果之前为pip设置镜像源，包括pypi源、pytorch源，则不需要再次设置“pip镜像源”）~~  

- 3、设置安装重试功能（推荐）

Term-SD默认已配置该选项，可忽略

~~在Term-SD设置选择“命令执行监测设置”，选择启用，输入重试次数（推荐3），这时就设置好安装重试功能了，在安装AI软件时如果遇到网络不稳定导致命令执行的中断时，将会重新执行中断的命令，保证安装的顺利进行~~

进行上面的步骤后就可以进行AI软件的安装

***

## Term-SD安装功能
Term-SD支持AUTOMATIC1111-stable-diffusion-webui，ComfyUI，InvokeAI，lora-scripts，在Term-SD的主界面对应下面的选项
- 1、AUTOMATIC1111-stable-diffusion-webui管理
- 2、ComfyUI管理
- 3、InvokeAI管理
- 4、Fooocus管理
- 5、lora-scripts管理

需要安装哪一种就选择哪一个管理选项

>1、安装过程请保持网络通畅  
>2、当AI软件安装好后，能启动且无报错时，最好使用“依赖库版本管理”将依赖库的软件包版本备份下来，当AI软件因为软件包版本问题导致AI软件出现报错时就可以用这个功能恢复原来的依赖库版本

### AUTOMATIC1111-stable-diffusion-webui安装
>AUTOMATIC1111-stable-diffusion-webui是一款功能丰富，社区资源丰富的ai绘画软件，支持扩展

选中AUTOMATIC1111-stable-diffusion-webui管理后，Term-SD会检测该ai是否安装，如果没有安装，Term-SD会提示用户是否进行安装  
选择“是”之后，Term-SD会进入安装准备选项

#### 1、安装镜像选项
第一个是安装镜像选项，共有以下选项
- 1、启用pip镜像源：Term-SD调用pip下载python软件包时使用国内镜像源进行下载
- 2、huggingface/github独占代理：Term-SD安装AI软件的过程仅为huggingface/github下载源启用代理，减少代理流量的消耗
- 3、强制使用pip：强制使用pip安装python软件包，一般只有在禁用虚拟环境后才需要启用 
- 4、使用modelscope模型下载源：将安装时使用的huggingface模型下载源改为modelscope模型下载源（因为huggingface在国内无法直接访问）
- 5、github镜像源自动选择：测试可用的github镜像源并选择自动选择，选择该选项后将覆盖手动设置的github镜像源
- 6、启用github代理：Term-SD从github克隆源代码时使用github代理镜像站进行克隆

一般这些选项保持默认即可

>强制使用pip一般不需要启用，该选项向pip传达--break-system-packages参数进行安装，忽略系统的警告，参考https://stackoverflow.com/questions/75602063/pip-install-r-requirements-txt-is-failing-this-environment-is-externally-mana

#### 2、pytorch版本选择
第二个是pytorch版本的选择界面，有以下版本组合
- 1、Torch+xformers
- 2、Torch
- 3、Torch 2.0.0+Torch-Directml
- 4、Torch 2.1.0+CPU
- 5、Torch 2.0.1+RoCM 5.4.2
- 6、Torch 2.1.0+RoCM 5.6
- 7、Torch 1.12.1（CUDA11.3）+xFormers 0.014
- 8、Torch 1.13.1（CUDA11.7）+xFormers 0.016
- 9、Torch 2.0.0（CUDA11.8）+xFormers 0.018
- 10、Torch 2.0.1（CUDA11.8）+xFormers 0.022
- 11、Torch 2.1.0（CUDA12.1）+xFormers 0.022post7

选择版本时需要根据系统类型和显卡选择  
在Windows系统中，Nvidia显卡选择Torch（CUDA）+xformers的版本，AMD显卡和Intel显卡选择Torch+Torch-Directml的版本  
在Linux系统中，Nvidia显卡选择Torch（CUDA）+xformers的版本，AMD显卡选择Torch+Rocm的版本，Intel显卡选择Torch版本  
在MacOS系统中，选择Torch版本  
如果想要使用CPU进行跑图，选择Torch+CPU的版本

#### 3、插件选择
第三个是插件选择，Term-SD默认已经勾选一些比较有用的插件，可以根据个人需求进行选择

#### 4、pip安装模式选择
第四个是pip包管理器的安装模式选择，共有2种模式
- 1、常规安装（setup.py）：使用传统方式进行安装，默认使用二进制软件包进行安装，速度较快
- 2、标准构建安装（--use-pep517）：使用标准编译安装，使用源码编译成二进制软件包再进行安装，耗时比较久，但可以解决一些python软件包安装失败的问题

一般使用常规安装（setup.py）就行，如果想要保证安装成功，可以选择标准构建安装（--use-pep517）

>在Linux系统中使用常规安装（setup.py）可能会出现安装失败的问题，所以推荐使用标准构建安装（--use-pep517）

#### 5、安装确认
最后一个是安装确认，选择“是”开始安装  
安装时间根据网络速度和电脑性能决定


### ComfyUI安装
>ComfyUI是一款节点式操作的ai绘画软件，上手难度较高，但是节点赋予ComfyUI更高的操作上限，且支持将节点工作流保存成文件，支持扩展。同时ComfyUI让用户更好的理解ai绘画的工作原理

选中ComfyUI管理后，Term-SD会检测该ai是否安装，如果没有安装，Term-SD会提示用户是否进行安装  
选择“是”之后，Term-SD会进入安装准备选项

#### 1、安装镜像选项
和AUTOMATIC1111-stable-diffusion-webui的选择方法相同

#### 2、pytorch版本选择
和AUTOMATIC1111-stable-diffusion-webui的选择方法相同

#### 3、插件安装
第四个是插件选择，Term-SD默认已经勾选一些比较有用的插件，可以根据个人需求进行选择

#### 4、自定义节点安装
第五个是自定义节点选择，Term-SD默认已经勾选一些比较有用的插件，可以根据个人需求进行选择

#### 5、pip安装模式选择
和AUTOMATIC1111-stable-diffusion-webui的选择方法相同

#### 6、安装确认
最后一个是安装确认，选择“是”开始安装  
安装时间根据网络速度和电脑性能决定

>在安装结束后，如果有安装插件/自定义节点的，需要在插件管理/自定义节点管理里运行安装全部插件依赖/安装全部自定义节点依赖，保证插件/自定义节点的正常运行（因为ComfyUI并没有AUTOMATIC1111-stable-diffusion-webui自动为插件安装依赖的功能）


### InvokeAI安装
>InvokeAI是一款操作界面简单的ai绘画软件，功能较少，但拥有特色功能“统一画布”，用户可以在画布上不断扩展图片的大小

选中InvokeAI管理后，Term-SD会检测该ai是否安装，如果没有安装，Term-SD会提示用户是否进行安装  
选择“是”之后，Term-SD会进入安装准备选项

#### 1、安装镜像选项
和AUTOMATIC1111-stable-diffusion-webui的选择方法相同

#### 2、pytorch版本选择
和AUTOMATIC1111-stable-diffusion-webui的选择方法相同

#### 3、pip安装模式选择
和AUTOMATIC1111-stable-diffusion-webui的选择方法相同

#### 4、安装确认
最后一个是安装确认，选择“是”开始安装  
安装时间根据网络速度和电脑性能决定

>安装完成后，在启动选项需要选择`(configure --skip-sd-weights)`进行配置，配置完成后再选择`(web)`启动webui界面


### Fooocus安装
>Fooocus是一款专为SDXL模型优化的ai绘画软件，界面简单，让使用者可以专注于提示词的书写，而且有着非常强的内存优化和速度优化，强于其他同类webui。

选中Fooocus管理后，Term-SD会检测该ai是否安装，如果没有安装，Term-SD会提示用户是否进行安装  
选择“是”之后，Term-SD会进入安装准备选项

#### 1、安装镜像选项
和AUTOMATIC1111-stable-diffusion-webui的选择方法相同

#### 2、pytorch版本选择
和AUTOMATIC1111-stable-diffusion-webui的选择方法相同

#### 3、pip安装模式选择
和AUTOMATIC1111-stable-diffusion-webui的选择方法相同

#### 4、安装确认
最后一个是安装确认，选择“是”开始安装  
安装时间根据网络速度和电脑性能决定


### lora-scripts安装
>lora-scripts是一款ai模型训练工具，支持训练lora模型、dreambooth模型

选中lora-scripts管理后，Term-SD会检测该ai是否安装，如果没有安装，Term-SD会提示用户是否进行安装  
选择“是”之后，Term-SD会进入安装准备选项

#### 1、安装镜像选项
和AUTOMATIC1111-stable-diffusion-webui的选择方法相同

#### 2、pytorch版本选择
和AUTOMATIC1111-stable-diffusion-webui的选择方法相同

#### 3、pip安装模式选择
和AUTOMATIC1111-stable-diffusion-webui的选择方法相同

#### 4、安装确认
最后一个是安装确认，选择“是”开始安装  
安装时间根据网络速度和电脑性能决定


### kohya_ss安装
>kohya_ss是一款ai模型训练工具，支持训练lora、dreambooth、Finetune、Train Network模型

选中kohya_ss管理后，Term-SD会检测该ai是否安装，如果没有安装，Term-SD会提示用户是否进行安装  
选择“是”之后，Term-SD会进入安装准备选项

#### 1、安装镜像选项
和AUTOMATIC1111-stable-diffusion-webui的选择方法相同

#### 2、pytorch版本选择
和AUTOMATIC1111-stable-diffusion-webui的选择方法相同

#### 3、pip安装模式选择
和AUTOMATIC1111-stable-diffusion-webui的选择方法相同

#### 4、安装确认
最后一个是安装确认，选择“是”开始安装  
安装时间根据网络速度和电脑性能决定

***

## Term-SD管理功能
当AI软件成功安装后，就可以使用Term-SD的管理功能来启动或者管理ai了  
在5个ai管理界面中，包含一些功能对ai进行管理

### 1、更新
更新AI软件

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

选中一个插件后，包含以下管理功能：
- 1、更新：更新插件
- 2、卸载：卸载插件，且该操作无法恢复，请谨慎选择
- 3、修复更新：修复插件无法更新的问题
- 4、切换版本：切换插件的版本
- 5、更新源切换：切换插件的更新源，加速下载；当某个github镜像源无法使用导致无法更新插件时，也可以使用该功能将更新源切换到可用的github镜像源或者切换成github源
- 6、安装依赖（仅限ComfyUI）：安装插件运行时所需的依赖

### 5、自定义节点管理
用于管理自定义节点，包含以下功能
>仅限ComfyUI

- 1、安装：使用git安装自定义节点
- 2、管理：对插件进行管理，提供了一个自定义节点列表浏览器来选择插件
- 3、更新全部自定义节点：一键更新全部自定义节点
- 4、安装全部插件依赖：一键将所有自定义节点需要的依赖进行安装

选中一个自定义节点后，包含以下管理功能：
- 1、更新：更新自定义节点
- 2、卸载：卸载自定义节点，且该操作无法恢复，请谨慎选择
- 3、修复更新：修复自定义节点无法更新的问题
- 4、切换版本：切换自定义节点的版本
- 5、更新源切换：切换自定义节点的更新源，加速下载；当某个github镜像源无法使用导致无法更新插件时，也可以使用该功能将更新源切换到可用的github镜像源或者切换成github源
- 6、安装依赖：安装自定义节点运行时所需的依赖

### 6、切换版本
该功能将会列出所有版本的hash值和对应的日期，可根据这些进行版本选择并切换过去

### 7、更新源切换
该功能用于切换更新源，加速下载；当某个github镜像源无法使用导致无法更新插件时，也可以使用该功能将更新源切换到可用的github镜像源或者切换成github源

### 8、启动
该功能用于启动AI软件  
在stable-diffusion-webui、ComfyUI、InvokeAI，Fooocus中可以选择预设启动参数或者自定义启动参数，从而使用一些功能  
当设置预设参数时，将会删除之前设置的启动参数；而自定义启动参数可以修改上次设置的启动参数

### 9、更新依赖
该功能用于更新AI软件依赖的python软件包，可用于解决AI软件的部分依赖版本太旧导致运行报错，一般用不上

### 10、重新安装
该功能用于重新执行AI软件的安装过程，一般用不上

### 11、重新安装pytorch
该功能用于切换pytorch的版本

### 12、修复虚拟环境
该功能用于修复生成AI软件使用的虚拟环境，一般在移动AI软件的位置，AI软件运行出现问题后才用

### 13、重新构建虚拟环境
该功能用于重新构建AI软件使用的虚拟环境，一般用在移动AI软件的位置后、AI软件运行出现报错（有一些时候是python依赖库出现了版本错误或者损坏，或者装了一些插件后出现问题，删除插件后问题依然没有解决）、安装AI软件前禁用了虚拟环境，安装后启用了虚拟环境，需要修复虚拟环境  
这个功能一般不需要用，除非解决不了一些python库报错问题（因为该功能将会重新构建虚拟环境，需要消耗比较长的时间）

### 14、分支切换
>仅限stable-diffusion-webui  

该功能用于把AUTOMATIC1111-stable-diffusion-webui的分支切换成vladmandic/SD.NEXT或者lshqqytiger/stable-diffusion-webui-directml（或者切换回来），或者切换成主分支或者测试分支

### 15、python软件包安装/重装/卸载
该功能用于安装/重装/卸载python软件包，处理python软件包的问题  
界面有以下选项：
- 1、常规安装(install)：安装python软件包并安装该软件包依赖的软件包
- 2、仅安装(--no-deps)：安装python软件包，但不安装该软件包依赖的软件包
- 3、强制重装(--force-reinstall)：强制安装python软件包，当该软件包已存在，则重新安装，且强制安装该软件包依赖的软件包
- 4、仅强制重装(--no-deps --force-reinstall)：强制安装python软件包，当该软件包已存在，则重新安装，但不安装该软件包依赖的软件包
- 5、卸载(uninstall)：卸载python软件包

当缺失某个软件包时，选择安装  
当某个软件包损坏时，可以选择强制重装  
如果需要卸载某个软件包，就选择卸载  
带有“仅”的功能是在安装时只安装用户输入的软件包，而不安装这些软件包的依赖  
安装/重装软件包时可以只写包名，也可以指定包名版本；可以输入多个软件包的包名,并使用空格隔开。例：
```
xformers
xformers==0.0.21
xformers==0.0.21 numpy
```

### 16、依赖库版本管理
该功能用于记录python依赖库的版本，在AI软件运行正常时，可以用该功能记录python依赖库的各个软件包版本，当因为装插件等导致依赖库的软件包版本出现错误而导致报错时，可用该功能恢复原来依赖库的各个软件包版本，从而解决报错

### 17、重新安装后端组件
>仅限stable-diffusion-webui，Fooocus

该功能用于重新下载后端需要的组件，组件可在`AI软件文件夹/repositories`文件夹中查看

***

## Term-SD额外功能

### 扩展脚本
Term-SD包含了一些扩展脚本，扩充Term-SD的功能
- 1、download-hanamizuki：下载绘世启动器
- 2、list：列出可用的扩展脚本
- 3、invokeai-model-download：下载InvokeAI模型，包含controlnet模型和部分大模型模型，解决使用官方配置程序因无法访问huggingface而下载失败的问题
- 4、install-pytorch-ipex：安装Pytorch IPEX到AI软件的依赖库中，使AI软件能够调用显卡来运行
- 5、download-sd-webui-extension：下载stable-diffusion-webui插件
- 6、download-comfyui-extension：下载ComfyUI插件
- 7、fix-bitsandbytes-for-kohya-ss-on-windows：修复原版bitsandbytes在Windows端无法运行导致kohya_ss报错无法进行训练的问题
- 8、fix-bitsandbytes-for-sd-webui-on-windows：修复原版bitsandbytes在Windows端无法运行导致stable-diffusion-webui中的模型训练插件报错无法进行训练的问题（训练模型不建议在stable-diffusion-webui中进行，请使用lora-scripts或者kohya_ss进行模型训练）

>如果需要使用扩展脚本，则在启动Term-SD前加入“--extra”启动参数即可使用扩展脚本

### 启动参数
在使用命令Term-SD时，可以添加启动参数来使用Term-SD额外的功能

#### 启动参数的使用方法
```
./term-sd.sh [--help] [--extra script_name] [--reinstall-term-sd] [--remove-term-sd] [--quick-cmd] [--set-python-path python_path] [--unset-python-path] [--update-pip] [--enable-new-bar] [--disable-new-bar] [--enable-bar] [--disable-bar] [--debug]
```

>中括号“[]”仅用来展示，在使用的时候不要输入进去  
当使用--quick-cmd安装了快捷命令，可将“./term-sd.sh”替换成“term_sd”或者“tsd”

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

将Term-SD快捷启动指令安装到shell中，在shell中直接输入“term_sd”或者“tsd”即可启动Term-SD，且不需要在Term-SD所在目录就能启动Term-SD（用“./term-sd.sh”命令启动还是需要在Term-SD所在目录里才能用）。该功能会提示用户选择安装快捷启动命令还是删除快捷启动命令，根据提示进行操作


- 6、set-python-path

手动指定python解释器路径（一定是绝对路径），当选项后面输入了路径，则直接使用输入的路径来设置pip路径（建议用“ ”把路径括起来），否则启动设置界面  
路径的参考格式如下：
```
/usr/bin/python
/c/Python/python.exe
/c/Program Files/Python310/python
/d/Program Files/Python310/python.exe
/usr/bin/python3
```
>根据自己安装的路径来填。在Windows系统中，每个文件夹的分隔符不要使用反斜杠，Windows系统中的盘符，如“C:”，“D:”，要改成“/c”，“/d”，因为MingW64不认识这些路径符号


- 7、unset-python-path

删除自定义python解释器路径配置


- 8、enable-new-bar

启用新的Term-SD初始化进度条


- 9、disable-new-bar

禁用新的Term-SD初始化进度条


- 10、enable-bar

启用Term-SD初始化进度显示（默认）


- 11、disable-bar

禁用Term-SD初始化进度显示（加了进度显示只会降低Term-SD初始化速度）


- 12、update-pip

进入虚拟环境时更新pip软件包管理


- 13、debug

显示调试信息

***

## 绘世启动器的使用
目前绘世启动器支持启动AUTOMATIC1111-stable-diffusion-webui、ComfyUI、Fooocus。使用Term-SD部署AUTOMATIC1111-stable-diffusion-webui、ComfyUI、或者Fooocus后，将绘世启动器放入stable-diffusion-webui文件夹、ComfyUI文件夹或者Fooocus文件夹后就可以使用绘世启动器启动对应的AI软件了（可以使用Term-SD扩展脚本中的download-hanamizuki脚本来下载绘世启动器，并且脚本会自动将绘世启动器放入上述文件夹中）

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
