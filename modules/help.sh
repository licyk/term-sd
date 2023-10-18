#!/bin/bash

#term-sd帮助功能

#帮助选择
function help_option()
{
    help_option_dialog=$(dialog --clear --title "Term-SD" --backtitle "Term-SD帮助选项" --ok-label "确认" --cancel-label "取消" --menu "请选择帮助" 25 70 10 \
        "1" "关于Term-SD" \
        "2" "Term-SD使用方法" \
        "3" "Term-SD注意事项" \
        "4" "Term-SD功能说明" \
        "5" "Term-SD启动参数说明" \
        "6" "目录说明" \
        "7" "Term-SD扩展脚本说明" \
        "8" "sd-webui插件说明" \
        "9" "ComfyUI插件/自定义节点说明" \
        "10" "返回" \
        3>&1 1>&2 2>&3 )

    if [ $? = 0 ];then
        if [ $help_option_dialog = 1 ];then
            help_option_1
            help_option
        elif [ $help_option_dialog = 2 ];then
            help_option_2
            help_option
        elif [ $help_option_dialog = 3 ];then
            help_option_3
            help_option
        elif [ $help_option_dialog = 4 ];then
            help_option_4
            help_option
        elif [ $help_option_dialog = 5 ];then
            help_option_5
            help_option
        elif [ $help_option_dialog = 6 ];then
            help_option_6
            help_option
        elif [ $help_option_dialog = 7 ];then
            help_option_7
            help_option
        elif [ $help_option_dialog = 8 ];then
            help_option_8
            help_option
        elif [ $help_option_dialog = 9 ];then
            help_option_9
            help_option
        fi
    else
        mainmenu
    fi
}

#关于term-sd
function help_option_1()
{
    dialog --clear --title "Term-SD" --backtitle "Term-SD帮助选项" --ok-label "确认" --msgbox "关于Term-SD:\n
Term-SD是基于终端显示的AI管理器,可以对AI软件进行简单的管理  \n
支持的AI软件如下: \n
1、AUTOMATIC1111-stable-diffusion-webui \n
2、ComfyUI \n
3、InvokeAI \n
4、Fooocus \n
5、lora-scripts \n
(AI软件都基于stable-diffusion)\n
\n
\n
该脚本的编写参考了https://gitee.com/skymysky/linux\n
脚本支持Windows,Linux,MacOS(Windows平台需安装msys2,MacOS需要安装homebrew)\n
\n
stable-diffusion相关链接:\n
https://huggingface.co/\n
https://civitai.com/\n
https://www.bilibili.com/read/cv22159609\n
\n
学习stable-diffusion-webui的教程:\n
https://licyk.netlify.app/2023/08/01/stable-diffusion-tutorial\n
\n
\n
" 25 70
}

#term-sd使用方法
function help_option_2()
{
    #把https://github.com/licyk/README-collection/blob/main/term-sd/README_how_to_use_term_sd.md上的使用教程放到term-sd中
    dialog --clear --title "Term-SD" --backtitle "Term-SD帮助选项" --ok-label "确认" --msgbox "# Tern-SD使用教程\n
## Term-SD的初始化\n
\n
Term-SD在下载好后，只会有一个基础的配置脚本“term-sd.sh”，当运行这个配置脚本时，Term-SD会检测运行所需依赖。当检测到缺少依赖时，Term-SD会提示用户需要去安装的依赖，并自动退出，这时候需要用户检查这些依赖是否安装，并且把缺失的依赖装上\n
当检测到依赖都安装时，脚本会提示用户安装Term-SD的完整组件\n
\n
这时候输入“y”即可进行下载\n
\n
在下载前。Term-SD会询问选择哪个下载源\n
总共有以下下载源：\n
1、github源\n
2、gitee源\n
3、gitlab源\n
4、代理源（使用代理站连接github源）\n
\n
一般情况选择任意一种都可以进行下载，但是如果用户无法在浏览器访问github官网，则不建议选第一个\n
如果下载失败，Term-SD将会自动退出，这时再次运行Term-SD重新下载，选择其他下载源\n
当成功下载时，Term-SD将会自动初始化模块，并启动\n
\n
## Term-SD的主界面介绍\n
\n
Term-SD在成功启动后，首先显示的是各个组件的版本信息，选择确定后就进入Term-SD的主界面\n
主界面有以下选项\n
1、Term-SD更新管理：管理，修复Term-SD的更新\n
2、AUTOMATIC1111-stable-diffusion-webui管理：包含各种AUTOMATIC1111-stable-diffusion-webui的管理功能\n
3、ComfyUI管理：包含各种ComfyUI的管理功能\n
4、InvokeAI管理：包含各种InvokeAI的管理功能\n
5、Fooocus管理：包含各种Fooocus的管理功能\n
6、lora-scripts管理：包含各种lora-scripts的管理功能\n
7、venv虚拟环境设置：配置Term-SD在安装。管理ai时是否使用虚拟环境，建议保持启用（默认）\n
8、pip镜像源设置：配置pip在安装python软件包时使用的镜像源，减少pip直接连接官方镜像源时出现下载慢，连接不稳定的问题\n
9、pip缓存清理：清理pip在下载python软件包后产生的缓存\n
10、代理设置：配置网络代理，解决无法连接部分下载源导致下载失败的问题。一般在代理软件无法为Term-SD进行网络代理时使用（在使用没有TUN模式或者驱动模式的代理软件中，终端环境并不会自动使用代理，使运行在终端的Term-SD和ai软件无法使用到代理环境，导致部分下载源下载失败）\n
11、空间占用分析：显示各个ai软件所占用的空间和当前目录剩余空间\n
12、帮助：Term-SD的各种帮助文档\n
\n
## Term-SD配置功能\n
\n
### Term-SD更新管理\n
\n
该功能用于对Term-SD自身的更新等进行管理，共有以下选项\n
1、更新：这个不用多说\n
2、切换更新源：Term-SD有多个下载源，用于解决某些更新源更新慢或者无法更新的问题，一般来说github源的版本变化较快，其他源的版本变化会有延后（大约延迟一天）\n
3、切换分支：Term-SD总共有两个分支，main和dev，一般不需要切换\n
4、修复更新：当用户手动修改Term-SD的文件后，在更新Term-SD时就容易出现更新失败的问题，该功能可修复该问题\n
\n
### pip镜像源设置\n
\n
该功能用于对pip的下载源进行修改，共有以下选项\n 
1、官方源：将pip的下载源切换成官方源，但可能会导致下载慢或者下载失败的问题\n
2、国内镜像源：将pip的下载源切换成国内镜像源，解决官方源下载慢或者下载失败的问题，推荐选择\n
3、删除镜像源配置：将pip的下载源设置清除\n
\n
### 代理设置\n
\n
该功能为了设置下载时使用的网络代理，解决部分下载源下载失败的问题，共有以下选项\n
1、http：设置http协议的代理\n
2、socks：设置socks协议的代理\n
3、socks5：设置socks5协议的代理\n
4、删除代理参数：将设置的代理参数删除\n
\n
设置代理时，用户需要选择代理协议，具体使用什么代理协议取决于所使用的代理软件\n
一般推荐用http协议，因为aria2兼容http代理，但socks代理的兼容有问题
\n
## Term-SD的准备功能\n
\n
Term-SD在使用安装、管理功能时，会使用准备功能来对一些操作进行准备工作，共有以下功能\n
>这些功能会经常出现\n
\n
### 1、代理选项
有以下选项：\n
1、启用pip镜像源：Term-SD调用pip下载python软件包时使用国内镜像源进行下载\n
2、启用github代理：Term-SD从github克隆源代码时使用github代理镜像站进行克隆\n
3、huggingface独占代理：Term-SD安装ai软件的过程仅为huggingface下载源启用代理，减少代理流量的消耗\n
4、强制使用pip：强制使用pip安装python软件包，一般只有在禁用venv虚拟环境后才需要启用\n 
\n
一般这些选项保持默认即可\n
\n
>强制使用pip一般不需要启用，该选项向pip传达--break-system-packages参数进行安装，忽略系统的警告，参考https://stackoverflow.com/questions/75602063/pip-install-r-requirements-txt-is-failing-this-environment-is-externally-mana
\n
### 2、pytorch版本选项\n
有以下版本组合：\n
1、Torch+xformers\n
2、Torch\n
3、Torch 2.0.0+Torch-Directml\n
4、Torch 2.0.1+CPU\n
5、Torch 2.0.1+RoCM 5.4.2\n
6、Torch 1.12.1（CUDA11.3）+xFormers 0.014\n
7、Torch 1.13.1（CUDA11.7）+xFormers 0.016\n
8、Torch 2.0.0（CUDA11.8）+xFormers 0.018\n
9、Torch 2.0.1（CUDA11.8）+xFormers 0.021\n
10、Torch 2.1.0（CUDA12.1）+xFormers 0.022\n
\n
选择版本时需要根据系统类型和显卡选择\n
在Windows系统中，Nvidia显卡选择Torch（CUDA）+xformers的版本，AMD显卡和Intel显卡选择Torch+Torch-Directml的版本\n
在Linux系统中，Nvidia显卡选择Torch（CUDA）+xformers的版本，AMD显卡选择Torch+Rocm的版本，Intel显卡选择Torch版本\n
在MacOS系统中，选择Torch版本\n
如果想要使用CPU进行跑图，选择Torch+CPU的版本\n
\n
### 3、pip安装模式选项\n
共有2种模式：\n
1、常规安装（setup.py）：使用传统方式进行安装，默认使用二进制软件包进行安装，速度较快\n
2、标准构建安装（--use-pep517）：使用标准编译安装，使用源码编译成二进制软件包再进行安装，耗时比较久，但可以解决一些python软件包安装失败的问题\n
\n
一般使用常规安装（setup.py）就行\n
\n
### 4、pip操作方式\n
>仅在python软件包安装/重装/卸载功能出现\n
\n
选择如何处理python软件包，有以下选项：\n
1、安装：用于安装缺失的软件包\n
2、强制重装：用于安装缺失或者损坏的软件包，可解决软件包损坏问题，但同时重新安装软件包所需的依赖，速度较慢\n
3、卸载：卸载软件包\n
\n
### 5、安装确认选项\n
用于确认是否安装\n
\n
## 使用Term-SD安装ai软件前的准备\n
\n
安装前，我们需要做一些准备\n
1、设置pip镜像源\n
2、设置代理（没有一个质量比较好的代理时就不要设置了）\n
\n
首先我们在Term-SD主界面选择“pip镜像源设置”，进入后可选择“官方源”和“国内镜像源”，这里非常推荐设置为“国内镜像源”（如果之前为pip设置镜像源，包括pypi源、pytorch源，则不需要再次设置“pip镜像源”）\n
如果用户有代理软件，并且代理的速度和稳定性较好，则先判断代理软件的代理工作模式，一般有TUN模式或者驱动模式的就不需要设置代理，因为这两种代理模式可以让终端环境走代理（其余模式不行）\n
但是TUN模式或者驱动模式会让所有流量走代理，而Term-SD在安装ai软件的过程中只有部分下载源需要代理，这将会造成代理流量的浪费。所以，如果代理软件有其他代理模式，最好选这些的，并查看代理软件的代理协议、ip和端口，然后在Term-SD主界面的“代理设置”里选择代理协议，填入ip和端口，回车保存，这样Term-SD就可以决定哪些流量需要走代理\n
如果代理没有TUN模式或者驱动模式，则查看代理软件的代理协议、ip和端口，然后在Term-SD主界面的“代理设置”里选择代理协议，填入ip和端口，回车保存\n
\n
>在不使用代理后，需要在“代理设置”里删除代理参数，防止在代理软件关闭后出现Term-SD无法访问网络的问题\n
\n
进行上面的步骤后就可以进行ai软件的安装\n
\n
## Term-SD安装功能\n
\n
Term-SD支持AUTOMATIC1111-stable-diffusion-webui，ComfyUI，InvokeAI，lora-scripts，在Term-SD的主界面对应下面的选项\n
1、AUTOMATIC1111-stable-diffusion-webui管理\n
2、ComfyUI管理\n
3、InvokeAI管理\n
4、Fooocus管理\n
5、lora-scripts管理\n
\n
需要安装哪一种就选择哪一个管理选项\n
\n
>安装过程请保持网络通畅\n
\n
### AUTOMATIC1111-stable-diffusion-webui安装\n
\n
>AUTOMATIC1111-stable-diffusion-webui是一款功能丰富，社区资源丰富的ai绘画软件，支持扩展\n
\n
选中AUTOMATIC1111-stable-diffusion-webui管理后，Term-SD会检测该ai是否安装，如果没有安装，Term-SD会提示用户是否进行安装\n
选择“是”之后，Term-SD会进入安装准备选项\n
\n
#### 1、代理选项\n
第一个是代理选项，共有以下选项\n
1、启用pip镜像源：Term-SD调用pip下载python软件包时使用国内镜像源进行下载\n
2、启用github代理：Term-SD从github克隆源代码时使用github代理镜像站进行克隆\n
3、huggingface独占代理：Term-SD安装ai软件的过程仅为huggingface下载源启用代理，减少代理流量的消耗\n
4、强制使用pip：强制使用pip安装python软件包，一般只有在禁用venv虚拟环境后才需要启用\n
\n
一般这些选项保持默认即可\n
\n
>强制使用pip一般不需要启用，该选项向pip传达--break-system-packages参数进行安装，忽略系统的警告，参考https://stackoverflow.com/questions/75602063/pip-install-r-requirements-txt-is-failing-this-environment-is-externally-mana\n
\n
#### 2、pytorch版本选择\n
第二个是pytorch版本的选择界面，有以下版本组合\n
1、Torch+xformers\n
2、Torch\n
3、Torch 2.0.0+Torch-Directml\n
4、Torch 2.0.1+CPU\n
5、Torch 2.0.1+RoCM 5.4.2\n
6、Torch 1.12.1（CUDA11.3）+xFormers 0.014\n
7、Torch 1.13.1（CUDA11.7）+xFormers 0.016\n
8、Torch 2.0.0（CUDA11.8）+xFormers 0.018\n
9、Torch 2.0.1（CUDA11.8）+xFormers 0.022\n
10、Torch 2.1.0（CUDA12.1）+xFormers 0.022\n
\n
选择版本时需要根据系统类型和显卡选择\n
在Windows系统中，Nvidia显卡选择Torch（CUDA）+xformers的版本，AMD显卡和Intel显卡选择Torch+Torch-Directml的版本\n
在Linux系统中，Nvidia显卡选择Torch（CUDA）+xformers的版本，AMD显卡选择Torch+Rocm的版本，Intel显卡选择Torch版本\n
在MacOS系统中，选择Torch版本\n
如果想要使用CPU进行跑图，选择Torch+CPU的版本\n
\n
#### 3、pip安装模式选择\n
第三个是pip包管理器的安装模式选择，共有2种模式\n
1、常规安装（setup.py）：使用传统方式进行安装，默认使用二进制软件包进行安装，速度较快\n
2、标准构建安装（--use-pep517）：使用标准编译安装，使用源码编译成二进制软件包再进行安装，耗时比较久，但可以解决一些python软件包安装失败的问题\n
\n
一般使用常规安装（setup.py）就行\n
\n
#### 4、插件选择\n
第四个是插件选择，Term-SD默认已经勾选一些比较有用的插件，可以根据个人需求进行选择\n
\n
#### 5、安装确认\n
最后一个是安装确认，选择“是”开始安装\n
安装时间根据网络速度和电脑性能决定\n
\n
### ComfyUI安装\n
\n
>ComfyUI是一款节点式操作的ai绘画软件，上手难度较高，但是节点赋予ComfyUI更高的操作上限，且支持将节点工作流保存成文件，支持扩展。同时ComfyUI让用户更好的理解ai绘画的工作原理\n
\n
选中ComfyUI管理后，Term-SD会检测该ai是否安装，如果没有安装，Term-SD会提示用户是否进行安装\n
选择“是”之后，Term-SD会进入安装准备选项\n
\n
#### 1、代理选项\n
和AUTOMATIC1111-stable-diffusion-webui的选择方法相同\n
\n
#### 2、pytorch版本选择\n
和AUTOMATIC1111-stable-diffusion-webui的选择方法相同\n
\n
#### 3、pip安装模式选择\n
和AUTOMATIC1111-stable-diffusion-webui的选择方法相同\n
\n
#### 4、插件安装\n
第四个是插件选择，Term-SD默认已经勾选一些比较有用的插件，可以根据个人需求进行选择\n
\n
#### 5、自定义节点安装\n
第五个是自定义节点选择，Term-SD默认已经勾选一些比较有用的插件，可以根据个人需求进行选择\n
\n
#### 6、安装确认\n
最后一个是安装确认，选择“是”开始安装\n
安装时间根据网络速度和电脑性能决定\n
\n
>在安装结束后，如果有安装插件/自定义节点的，需要在插件管理/自定义节点管理里运行安装全部插件依赖/安装全部自定义节点依赖，保证插件/自定义节点的正常运行（因为ComfyUI并没有AUTOMATIC1111-stable-diffusion-webui自动为插件安装依赖的功能）\n
\n
### InvokeAI安装\n
\n
>InvokeAI是一款操作界面简单的ai绘画软件，功能较少，但拥有特色功能“统一画布”，用户可以在画布上不断扩展图片的大小\n
\n
选中InvokeAI管理后，Term-SD会检测该ai是否安装，如果没有安装，Term-SD会提示用户是否进行安装\n
选择“是”之后，Term-SD会进入安装准备选项\n
\n
#### 1、代理选项\n
和AUTOMATIC1111-stable-diffusion-webui的选择方法相同\n
\n
#### 2、pytorch版本选择
和AUTOMATIC1111-stable-diffusion-webui的选择方法相同\n
\n
#### 3、pip安装模式选择\n
和AUTOMATIC1111-stable-diffusion-webui的选择方法相同\n
\n
#### 4、安装确认\n
最后一个是安装确认，选择“是”开始安装\n
安装时间根据网络速度和电脑性能决定\n
\n
>安装完成后，在启动选项需要选择invokeai-configure进行配置，配置完成后再选择invokeai --web启动webui界面\n
\n
### Fooocus安装\n
\n
>Fooocus是一款专为SDXL模型优化的ai绘画软件，界面简单，让使用者可以专注于提示词的书写，而且有着非常强的内存优化和速度优化，强于其他同类webui。\n
\n
选中Fooocus管理后，Term-SD会检测该ai是否安装，如果没有安装，Term-SD会提示用户是否进行安装\n
选择“是”之后，Term-SD会进入安装准备选项\n
\n
#### 1、代理选项\n
和AUTOMATIC1111-stable-diffusion-webui的选择方法相同\n
\n
#### 2、pytorch版本选择\n
和AUTOMATIC1111-stable-diffusion-webui的选择方法相同\n
\n
#### 3、pip安装模式选择\n
和AUTOMATIC1111-stable-diffusion-webui的选择方法相同\n
\n
#### 4、安装确认\n
最后一个是安装确认，选择“是”开始安装\n
安装时间根据网络速度和电脑性能决定\n
\n
### lora-scripts安装\n
\n
>lora-scripts是一款ai模型训练工具，支持训练lora模型、dreambooth模型\n
\n
选中lora-scripts管理后，Term-SD会检测该ai是否安装，如果没有安装，Term-SD会提示用户是否进行安装\n
选择“是”之后，Term-SD会进入安装准备选项\n
\n
#### 1、代理选项\n
和AUTOMATIC1111-stable-diffusion-webui的选择方法相同\n
\n
#### 2、pytorch版本选择\n
和AUTOMATIC1111-stable-diffusion-webui的选择方法相同\n
\n
#### 3、pip安装模式选择\n
和AUTOMATIC1111-stable-diffusion-webui的选择方法相同\n
\n
#### 4、安装确认\n
最后一个是安装确认，选择“是”开始安装\n
安装时间根据网络速度和电脑性能决定\n
\n
## Term-SD管理功能\n
\n
在5个ai管理界面中，包含一些功能对ai进行管理\n
\n
### 1、更新\n
这个不用解释了吧\n
\n
### 2、卸载\n
字面意思\n
\n
### 3、修复更新\n
修复一些版本问题导致更新失败的问题\n
\n
### 4、插件管理\n
管理插件，包含以下功能\n
\n
1、安装：使用git安装插件\n
2、管理：对插件进行管理，提供了一个插件列表浏览器来选择插件\n
3、更新全部插件：一键更新全部插件\n
4、安装全部插件依赖：一键将所有插件需要的依赖进行安装（仅限ComfyUI）\n
\n
选中一个插件后，包含以下管理功能：\n
1、更新：更新插件\n
2、卸载：卸载插件\n
3、修复更新：修复插件无法更新的问题\n
4、切换版本：切换插件的版本\n
5、更新源切换：切换插件的更新源，加速下载（github源有时无法连接上，或者连接速度慢，该功能可以将github下载源切换成github镜像站源，或者还原成原来的github下载源）\n
6、安装依赖（仅限ComfyUI）：安装插件运行时所需的依赖
\n
### 5、自定义节点管理\n
用于管理自定义节点，包含以下功能\n
>仅限ComfyUI\n
\n
1、安装：使用git安装自定义节点\n
2、管理：对插件进行管理，提供了一个自定义节点列表浏览器来选择插件\n
3、更新全部自定义节点：一键更新全部自定义节点\n\n
4、安装全部插件依赖：一键将所有自定义节点需要的依赖进行安装
\n
选中一个自定义节点后，包含以下管理功能：\n
1、更新：更新自定义节点\n
2、卸载：卸载自定义节点\n
3、修复更新：修复自定义节点无法更新的问题\n
4、切换版本：切换自定义节点的版本\n
5、更新源切换：切换自定义节点的更新源，加速下载（github源有时无法连接上，或者连接速度慢，该功能可以将github下载源切换成github镜像站源，或者还原成原来的github下载源）\n
6、安装依赖：安装自定义节点运行时所需的依赖\n
\n
### 6、切换版本\n
根据版本hash值进行版本切换\n
\n
### 7、更新源切换\n
使用github更新源的可以切换为github代理源加速下载，或者恢复github更新源\n
\n
### 8、启动\n
启动ai软件\n
在AUTOMATIC1111-stable-diffusion-webui、ComfyUI、InvokeAI，Fooocus中可以选择预设启动参数或者自定义启动参数\n
\n
### 9、更新依赖\n
更新ai软件的依赖，可用于解决ai软件的部分依赖版本太旧导致运行报错，一般用不上\n
\n
### 10、重新安装\n
重新执行ai软件的安装过程\n
\n
### 11、重新安装pytorch\n
这个功能用于切换pytorch的版本\n
\n
### 12、修复venv虚拟环境\n
修复生成ai软件使用的venv虚拟环境，一般在移动ai软件的位置，ai软件运行出现问题后才用\n
\n
### 13、重新构建venv虚拟环境\n
重新构建ai软件使用的venv虚拟环境，一般用在移动ai软件的位置后、ai软件运行出现报错（有一些时候是python依赖库出现了版本错误或者损坏，或者装了一些插件后出现问题，删除插件后问题依然没有解决）、安装ai软件前禁用了venv虚拟环境，安装后启用了venv虚拟环境，需要修复虚拟环境\n
这个功能一般不需要用，除非解决不了一些python库报错问题（因为该功能需要消耗比较长的时间）\n
\n
### 14、分支切换\n
>仅限stable-diffusion-webui\n
\n
将AUTOMATIC1111-stable-diffusion-webui的分支切换成vladmandic/SD.NEXT或者lshqqytiger/stable-diffusion-webui-directml（或者切换回来），或者切换成主分支或者测试分支\n
\n
### 15、pip软件包重装\n
安装或者重新安装python软件包，用于解决某个python软件包缺失或者损坏\n
\n
### 15、python软件包安装/重装/卸载\n
安装/重装/卸载python软件包，有以下选项：\n
1、常规安装（install）\n
2、仅安装（--no-deps）\n
3、强制重装（--force-reinstall）\n
4、仅强制重装（--no-deps --force-reinstall）\n
5、卸载（uninstall）\n
\n
>带有\"仅\"的功能是在安装时只安装用户输入的软件包，而不安装这些软件包的依赖\n
安装/重装软件包时可以只写包名，也可以指定包名版本，例:xformers，xformers==0.0.21\n
\n
16、\n
依赖库版本管理：记录python依赖库的版本，在ai软件运行正常时，可以用该功能记录python依赖库的各个软件包版本，当因为装插件等导致依赖库的软件包版本出现错误而导致报错时，可用该功能恢复原来依赖库的各个软件包版本，从而解决报错\n
\n
## Term-SD额外功能\n
\n
### 扩展脚本\n
Term-SD包含了一些扩展脚本，扩充Term-SD的功能\n
sd-webui-extension：安装AUTOMATIC1111-stable-diffusion-webui的插件\n
comfyui-extension：安装ComfyUI的插件\n
\n
### 启动参数\n
在使用命令Term-SD时，可以添加启动参数来使用Term-SD额外的功能\n
\n
#### 启动参数的使用方法\n
\n
./term-sd.sh [--help] [--extra] [--multi-threaded-download] [--enable-auto-update] [--disable-auto-update] [--reinstall-term-sd] [--remove-term-sd] [--test-network] [--quick-cmd] [--set-python-path] [--set-pip-path] [--unset-python-path] [--unset-pip-path] \n
\n
\n
>中括号“[]”仅用来展示，在使用的时候不要输入进去\n
当使用--quick-cmd安装了快捷命令，可将“./term-sd.sh”替换成“termsd”或者“tsd”\n
\n
#### 启动参数的功能解析\n
1、help\n
显示启动参数帮助\n
\n
2、extra\n
启动扩展脚本显示界面，选中其中一个启动脚本后即可启动\n
\n
3、multi-threaded-download\n
安装过程中启用多线程下载模型，在调用aria2下载模型时设置下载线程为8\n
\n
4、enable-auto-update\n
启动Term-SD自动检查更新功能。启用后在启动Term-SD时将会检查一次更新，如果有更新则会提醒用户是否进行更新（该功能的触发时间间隔为一个小时）
\n
5、disable-auto-update\n
禁用Term-SD自动检查更新功能\n
\n
6、reinstall-term-sd\n
重新安装Term-SD。Term-SD会提示用户如何重新安装，根据提示操作即可\n
\n
7、remove-term-sd\n
卸载Term-SD，该功能将会删除Term-SD自身的所有组件和快捷启动命令，只保留已经安装的ai软件\n
\n
8、test-network\n
测试网络环境，用于测试代理是否可用。该功能将会测试网络连接是否正常，并测试google，huggingface，github，ghproxy能否访问，该功能需安装curl\n
\n
9、quick-cmd\n
将Term-SD快捷启动指令安装到shell中，在shell中直接输入“termsd”或者“tsd”即可启动Term-SD，且不需要在Term-SD所在目录就能启动Term-SD（用“./term-sd.sh”命令启动还是需要在Term-SD所在目录里才能用）。该功能会提示用户选择安装快捷启动命令还是删除快捷启动命令，根据提示进行操作\n
\n
10、set-python-path\n
手动指定python解释器路径（一定是绝对路径）\n
路径的参考格式如下：\n
\n
/usr/bin/python\n
/c/Python/python.exe\n
/c/Program Files/Python310/python\n
/d/Program Files/Python310/python.exe\n
/data/data/com.termux/files/usr/bin/python3\n
\n
>根据自己安装的路径来填，每个文件夹的分隔符不要使用反斜杠，Windows系统中的盘符，如“C:”，“D:”，要改成“/c”，“/d”，因为MingW64不认识这些路径符号\n
\n
11、set-pip-path\n
手动指定pip路径（一定是绝对路径）\n
路径的参考格式如下：\n
\n
/usr/bin/pip\n
/c/Python/Scripts/pip.exe\n
/d/Program Files/Python310/Scripts/pip.exe\n
/d/Program Files/Python310/Scripts/pip\n
/data/data/com.termux/files/usr/bin/pip\n
\n
>根据自己安装的路径来填，每个文件夹的分隔符不要使用反斜杠，Windows系统中的盘符，如“C:”，“D:”，要改成“/c”，“/d”，因为MingW64不认识这些路径符号\n
\n
12、unset-python-path\n
删除自定义python解释器路径配置\n
\n
13、unset-pip-path\n
删除自定义pip解释器路径配置\n
\n
## 绘世启动器的使用\n
目前绘世启动器支持启动AUTOMATIC1111-stable-diffusion-webui、ComfyUI。使用Term-SD部署AUTOMATIC1111-stable-diffusion-webui或者ComfyUI后，将绘世启动器放入stable-diffusion-webui文件夹或者ComfyUI文件夹后就可以使用绘世启动器启动对应的ai软件了\n
" 25 70
}

#注意事项
function help_option_3()
{
    dialog --clear --title "Term-SD" --backtitle "Term-SD帮助选项" --ok-label "确认" --msgbox "Term-SD使用注意:\n
1、使用方向键、Tab键移动光标,方向键翻页(鼠标滚轮无法翻页),Enter进行选择,Space键勾选或取消勾选,(已勾选时显示[*]),Ctrl+Shift+V粘贴文本,Ctrl+C可中断指令的运行,鼠标左键可点击按钮(右键无效)\n
2、安装AI软件的路径和Term-SD脚本所在路径相同,方便管理\n
3、若AI软件使用了venv虚拟环境,移动AI软件到新的路径后需要使用Term-SD的“重新生成venv虚拟环境”功能,才能使venv虚拟环境正常工作\n
4、在更新或者切换版本失败时可以使用“更新修复”解决,然后再点一次“更新”\n
5、Term-SD只有简单的安装,管理功能,若要导入模型等操作需手动在文件管理器上操作\n
6、建议保持启用虚拟环境,因为不同AI软件对软件包的版本要求不同,关闭后易导致不同的AI软件出现依赖问题\n
7、AUTOMATIC1111-stable-diffusion-webui安装好后,可以使用秋叶aaaki制作的启动器来启动sd-webui。将秋叶的启动器放入stable-diffusion-webui文件夹中,双击启动(仅限windows,因为秋叶的启动器只有windows的版本)\n
8、ComfyUI目前并没有自动为插件或者自定义节点安装依赖的功能,所以安装插件或者自定义节点后后,推荐运行一次\"安装依赖\"功能,有些依赖下载源是在github上的,无法下载时请使用代理工具(已知问题:因为一些插件/自定义节点的安装依赖方式并不统一,term-sd的依赖安装功能可能没有用,需要手动进行安装依赖)\n
9、启动ComfyUI时,在\"Import times for custom nodes:\"过程如果出现\"IMPORT FAILED\",则找到对应自定义节点,运行一次\"安装依赖\"功能,或者使用\"安装全部自定义节点依赖\"功能进行依赖安装\n
10、InvokeAI在安装好后,要运行一次invokeai-configure,到\"install stable diffusion models\"界面时,可以把所有的模型取消勾选,因为有的模型是从civitai下载的,如果没有开启代理会导致下载失败\n
11、在插件/自定义节点的管理功能中没有"更新","切换版本","修复更新"这些按钮,是因为这些插件/自定义节点的文件夹内没有".git"文件夹,如果是从github上直接下载压缩包再解压安装的就会有这种情况\n
12、A1111-SD-Webui设置界面语言:点击\"Settings\"-->\"User interface\"-->\"Localization\",点击右边的刷新按钮,再选择(防止不显示出来),在列表中选择zh-Hans(stable)(Term-SD在安装时默认下载了中文插件),再点击上面的\"Apply settings\",最后点击\"Reload UI\"生效\n
13、ComfyUI设置界面语言:点击右上角的齿轮图标,找到\"AGLTranslation-langualge\",选择\"中文\",ComfyUi将会自动切换中文\n
14、InvokeAI设置界面语言:点击右上角的三条横杠的图标,然后点击Settings,然后找到Language选项,点击文字下方的选项框,找到简体中文并选中即可\n
15、如遇到网络问题,比如下载模型失败等,且在开启代理后依然无法解决问题时,可设置代理。代理参数的格式为\"ip:port\",参数例子:\"127.0.0.1:10808\",ip、port、代理协议需查看用户使用的代理软件配置(在终端环境中,除了有驱动模式或者TUN模式的代理软件,一般没办法为终端设置代理,所以可以使用该功能为终端环境设置代理)\n
16、在代理选项中\"huggingface独占代理\"可在安装过程中单独为从huggingface中下载模型时单独启用代理,保证安装速度,因为除了从huggingface下载模型的过程之外,其他下载过程可以不走代理进行下载(注:在使用驱动模式或者TUN模式的代理软件时,该功能无效,因为代理软件会强制让所有网络流量走代理)\n
\n
" 25 70
}

#term-sd功能介绍
function help_option_4()
{
    dialog --clear --title "Term-SD" --backtitle "Term-SD帮助选项" --ok-label "确认" --msgbox "Term-SD功能说明:\n
参数使用方法(设置快捷启动命令后可将\"./term-sd.sh\"替换成\"termsd\"或者\"tsd\"):\n
  ./term-sd.sh [--help] [--extra] [--multi-threaded-download] [--enable-auto-update] [--disable-auto-update] [--reinstall-term-sd] [--remove-term-sd] [--test-network] [--quick-cmd] [--set-python-path] [--set-pip-path] [--unset-python-path] [--unset-pip-path]\n
参数功能:\n
help:显示启动参数帮助\n
extra:启动扩展脚本\n
multi-threaded-download:安装过程中启用多线程下载模型\n
enable-auto-update:启动Term-SD自动检查更新功能\n
disable-auto-update:禁用Term-SD自动检查更新功能\n
reinstall-term-sd:重新安装Term-SD\n
remove-term-sd:卸载Term-SD\n
test-network:测试网络环境,用于测试代理是否可用,需安装curl\n
quick-cmd:将Term-SD快捷启动指令安装到shell中,在shell中直接输入\"termsd\"即可启动Term-SD\n
set-python-path:手动指定python解释器路径\n
set-pip-path:手动指定pip路径\n
unset-python-path:删除自定义python解释器路径配置\n
unset-pip-path:删除自定义pip解释器路径配置\n
update-pip:进入虚拟环境时更新pip软件包管理器\n
\n
Term-SD的功能(除了安装,更新,启动,卸载):\n
主界面:\n
Term-SD更新管理:对本脚本进行更新,更换更新源,切换版本分支\n
venv虚拟环境设置:启用/禁用venv环境,默认保持启用,防止不同AI软件因软件包版本不同造成互相干扰\n
pip镜像源设置:设置pip的下载源,解决国内网络环境访问pip软件源速度慢的问题\n
pip缓存清理:清理pip在安装软件包后产生的缓存\n
代理设置:为Term-SD访问网络设置代理,一般用在代理软件开启后,Term-SD安装AI软件时依然出现无法访问huggingface等资源的问题(如果代理软件有驱动模式或者TUN模式时则不会有这种问题,就不需要使用\"代理设置\"进行配置代理)\n
空间占用分析:显示Term-SD管理的AI软件的所占空间\n
管理功能:\n
修复更新:在更新AI软件时出现更新失败时,可使用该功能进行修复\n
切换版本:对AI软件的版本进行切换\n
分支切换:切换ai软件的版本分支\n
更新源切换:切换AI软件的更新源,解决国内网络下载慢的问题\n
管理插件/自定义节点:对AI软件的插件/自定义节点进行管理\n
更新依赖:更新ai的python包依赖,一般情况下不需要用到\n
重新安装:重新执行一次AI软件的安装\n
重新安装pytorch:用于切换pytorch版本(pytorch为ai的框架,为ai提供大量功能)\n
修复venv虚拟环境:在移动AI软件的文件夹后,venv会出现路径问题而导致运行异常,该功能可修复该问题\n
重新构建venv虚拟环境:venv出现比较严重的软件包版本问题,导致AI软件运行异常,此时可使用该功能进行修复(该功能同时会运行\"修复venv虚拟环境\"功能);或者在安装ai软件前禁用了虚拟环境,安装后重新启用了虚拟环境,这时也需要运行该功能\n
pip软件包安装/重装/卸载:安装/重装/卸载python软件包,解决某个软件包缺少或者损坏的问题\n
依赖库版本管理:记录python依赖库的版本,在ai软件运行正常时,可以用该功能记录python依赖库的各个软件包版本,当因为装插件等导致依赖库的软件包版本出现错误而导致报错时,可用该功能恢复原来依赖库的各个软件包版本,从而解决报错\n
安装准备功能:\n
启用pip镜像源:使用国内镜像源下载python软件包\n
启用github代理:使用github代理站下载github上的软件\n
huggingface独占代理:仅在下载huggingface上的模型时使用代理,且只在配置代理设置后才会生效(注:在使用驱动模式或者TUN模式的代理软件时,该功能无效,因为代理软件会强制让所有网络流量走代理)\n
强制使用pip:忽略系统警告强制使用pip包管理器下载软件包,一般用不到,只有在Linux系统中,禁用虚拟环境后才需要使用(不推荐禁用虚拟环境)\n
常规安装(setup.py):使用常规安装方式\n
标准构建安装(--use-pep517):使用编译安装方式(有时可以解决python软件包安装失败的问题。在InvokeAI官方文档中,安装时推荐使用该模式,实际上用常规安装也可以)\n
\n
\n
" 25 70
}

#启动参数说明
function help_option_5()
{
    dialog --clear --title "Term-SD" --backtitle "Term-SD帮助选项" --ok-label "确认" --msgbox "A1111-SD-Webui启动参数说明:\n
stable diffusion webui的启动参数:\n
skip-torch-cuda-test:不检查CUDA是否正常工作\n
no-half:不将模型切换为16位浮点数\n
no-half-vae:不将VAE模型切换为16位浮点数\n
medvram:启用稳定扩散模型优化(6g显存时使用),以牺牲速度换取低VRAM使用\n
lowvram:启用稳定扩散模型优化(4g显存时使用),大幅牺牲速度换取极低VRAM使用\n
lowram:将稳定扩散检查点权重加载到VRAM而不是RAM中\n
enable-insecure-extension-access:启用不安全的扩展访问\n
theme dark:启用黑色主题\n
autolaunch:自动启动浏览器打开webui界面\n
xformers:使用的xFormers加速\n
listen:允许局域网的设备访问\n
precision-full:全精度\n
force-enable-xformers:强制启用xformers加速\n
xformers-flash-attention:启用具有Flash Attention的xformer以提高再现性\n
api:启动API服务器\n
ui-debug-mode:不加载模型而快速启动ui界面\n
share:为gradio使用share=True,并通过其网站使UI可访问\n
opt-split-attention-invokeai:在自动选择优化时优先使用InvokeAI的交叉注意力层优化\n
opt-split-attention-v1:在自动选择优化时优先使用较旧版本的分裂注意力优化\n
opt-sdp-attention:在自动选择优化时优先使用缩放点积交叉注意力层优化;需要PyTorch 2\n
opt-sdp-no-mem-attention:在自动选择优化时优先使用不带内存高效注意力的缩放点积交叉注意力层优化,使图像生成确定性;需要PyTorch 2\n
disable-opt-split-attention:在自动选择优化时优先不使用交叉注意力层优化\n
use-cpu-all:使用cpu进行图像生成\n
opt-channelslast:将稳定扩散的内存类型更改为channels last\n
no-gradio-queue:禁用gradio队列;导致网页使用http请求而不是websocket\n
no-hashing:禁用检查点的sha256哈希运算,以帮助提高加载性能\n
backend directml:使用directml运行torch,解决amd显卡和intel显卡无法使用ai画图的问题\n
opt-sub-quad-attention:优先考虑内存高效的次二次复杂度交叉注意力层优化,用于自动选择\n
medvram-sdxl:仅在SDXL模型上启用稳定扩散模型优化(8g显存时使用),以牺牲速度换取低VRAM使用\n
\n
ComfyUI启动参数:\n
listen:允许局域网的设备访问\n
auto-launch:自动在默认浏览器中启动 ComfyUI\n
dont-upcast-attention:禁用对注意力机制的提升转换。可提升速度,但增加图片变黑的概率\n
force-fp32:强制使用 fp32\n
use-split-cross-attention:使用分割交叉注意力优化。使用 xformers 时忽略此选项\n
use-pytorch-cross-attention:使用新的 pytorch 2.0 交叉注意力功能\n
disable-xformers:禁用 xformers加速\n
gpu-only:将所有内容(文本编码器/CLIP 模型等)存储和运行在 GPU 上\n
highvram:默认情况下,模型使用后会被卸载到 CPU内存。此选项使它们保留在 GPU 内存中\n
normalvram:当 lowvram 被自动启用时,强制使用普通vram用法\n
lowvram:拆分unet以使用更少的显存\n
novram:当 lowvram 不足时使用\n
cpu:对所有内容使用 CPU(缓慢)\n
quick-test-for-ci:为 CI 快速测试\n
directml:使用directml运行torch,解决amd显卡和intel显卡无法使用ai画图的问题\n
\n
InvokeAI启动参数:\n
invokeai-configure:参数配置\n
invokeai:无参数启动\n
invokeai --web:启用webui界面\n
invokeai-ti --gui:使用终端界面\n
invokeai-merge --gui:启动模型合并\n
其他的自定义参数:\n
web:启用webui界面\n
free_gpu_mem:每次操作后积极释放 GPU 内存;这将允许您在低VRAM环境中运行,但会降低一些性能\n
precision auto:自动选择浮点精度\n
precision fp32:使用fp32浮点精度\n
precision fp16:使用fp16浮点精度\n
no-xformers_enabled:禁用xformers加速\n
xformers_enabled:启用xformers加速\n
no-patchmatch:禁用“补丁匹配”算法\n
always_use_cpu:使用cpu进行图片生成\n
no-esrgan:不使用esrgan进行图片高清修复\n
no-internet_available:禁用联网下载资源\n
host:允许局域网的设备访问\n
\n
\n
Foooxus启动参数:\n
listen:允许局域网的设备访问\n
directml:使用directml运行torch,解决amd显卡和intel显卡无法使用ai画图的问题\n
\n
\n
" 25 70
}

#目录说明
function help_option_6()
{
    dialog --clear --title "Term-SD" --backtitle "Term-SD帮助选项" --ok-label "确认" --msgbox "AI软件的目录说明:\n
在启用venv虚拟环境后,在安装时AI软件的目录下会产生venv文件夹,这个是python软件包安装的目录,更换cudnn可在该文件夹中操作\n
\n
\n
stable diffusion webui目录的说明(只列举比较重要的):\n
stable-diffusion-webui\n
├── embeddings   embeddings模型存放位置\n
├── extensions   插件存放位置\n
├── launch.py    term-sd启动sd-webui的方法\n
├── config.json  stable-diffusion-webui的配置文件,需要重置设置时删除该文件即可\n
├── outputs   生成图片的保存位置\n
└── models    模型存放目录\n
    ├── ESRGAN    放大模型存放位置\n
    ├── GFPGAN    放大模型存放位置\n
    ├── hypernetworks    hypernetworks模型存放位置\n
    ├── Lora    Lora模型存放位置\n
    ├── RealESRGAN    放大模型存放位置\n
    ├── Stable-diffusion    大模型存放位置\n
    └── VAE    VAE模型存放位置\n
\n
\n
ComfyUI目录的部分说明(只列举比较重要的):\n
ComfyUI\n
├── custom_nodes   自定义节点存放位置\n
├── main.py        term-sd启动ComfyUI的方法\n
├── models         模型存放位置\n
│   ├── checkpoints    大模型存放位置\n
│   ├── controlnet   controlnet模型存放位置\n
│   ├── embeddings   embeddings模型存放位置\n
│   ├── hypernetworks   hypernetworks模型存放位置\n
│   ├── loras   Lora模型存放位置\n
│   ├── upscale_models   放大模型存放位置\n
│   └── vae   VAE模型存放位置\n
├── output   生成图片的保存位置\n
└── web\n
    └── extensions   插件存放位置\n
\n
\n
InvokeAI目录的部分说明(只列举比较重要的):\n
├── configs   配置文件存放目录\n
├── invokeai.yaml   主要配置文件,需要重置设置时删除该文件即可\n
├── models   模型存放位置\n
│   ├── core\n
│   │   └── upscaling\n
│   │       └── realesrgan   放大模型存放位置\n
│   ├── sd-1   sd1.5模型的存放位置\n
│   │   ├── controlnet   controlnet模型存放位置\n
│   │   ├── embedding   embeddings模型存放位置\n
│   │   ├── lora   Lora模型存放位置\n
│   │   ├── main\n
│   │   ├── onnx\n
│   │   └── vae   VAE模型存放位置\n
│   ├── sd-2\n
│   │   ├── controlnet\n
│   │   ├── embedding\n
│   │   ├── lora\n
│   │   ├── main\n
│   │   ├── onnx\n
│   │   └── vae\n
│   ├── sdxl\n
│   │   ├── controlnet\n
│   │   ├── embedding\n
│   │   ├── lora\n
│   │   ├── main\n
│   │   ├── onnx\n
│   │   └── vae\n
│   └── sdxl-refiner\n
│       ├── controlnet\n
│       ├── embedding\n
│       ├── lora\n
│       ├── main\n
│       ├── onnx\n
│       └── vae\n
└── outputs   生成图片的存放位置\n
\n
\n
Fooocus目录的部分说明(只列举比较重要的):\n
Fooocus\n
├── launch.py        term-sd启动Fooocus的方法\n
├── models         模型存放位置\n
│   ├── checkpoints    大模型存放位置\n
│   ├── controlnet   controlnet模型存放位置\n
│   ├── embeddings   embeddings模型存放位置\n
│   ├── hypernetworks   hypernetworks模型存放位置\n
│   ├── loras   Lora模型存放位置\n
│   ├── upscale_models   放大模型存放位置\n
│   └── vae   VAE模型存放位置\n
├── output   生成图片的保存位置\n
\n
\n
lora-scripts目录的部分说明(只列举比较重要的):\n
lora-scripts\n
├── gui.py   term-sd启动lora-scripts的方法\n
├── logs   日志存放位置\n
├── output   训练得到的模型存放位置\n
├── sd-models   训练所用的底模存放位置\n
└── toml   保存的训练参数存放位置\n
\n
\n
" 25 70
}

#扩展脚本说明
function help_option_7()
{
    dialog --clear --title "Term-SD" --backtitle "Term-SD帮助选项" --ok-label "确认" --msgbox "Term-SD扩展脚本说明:\n
扩展脚本列表(启动Term-SD时加入\"--extra\"启动参数即可使用扩展脚本):\n
sd-webui-extension:安装sd-webui的插件\n
comfyui-extension:安装ComfyUI的插件\n
\n
\n
" 25 70
}

#AUTOMATIC1111-stable-diffusion-webui插件说明
function help_option_8()
{
    dialog --clear --title "Term-SD" --backtitle "Term-SD帮助选项" --ok-label "确认" --msgbox "AUTOMATIC1111-stable-diffusion-webui插件说明:\n
注:有些插件因为年久失修,可能会出现兼容性问题。具体介绍请在github上搜索项目\n
\n
kohya-config-webui: 一个用于生成kohya-ss训练脚本使用的toml配置文件的WebUI\n
sd-webui-additional-networks:将 LoRA 等模型添加到stable diffusion以生成图像的扩展\n
a1111-sd-webui-tagcomplete:输入Tag时提供booru风格(如Danbooru)的TAG自动补全\n
multidiffusion-upscaler-for-automatic1111:在有限的显存中进行大型图像绘制,提供图片区域控制\n
sd-dynamic-thresholding:解决使用更高的 CFG Scale 而出现颜色问题\n
sd-webui-cutoff:解决tag污染\n
sd-webui-model-converter:模型转换扩展\n
sd-webui-supermerger:模型合并扩展\n
stable-diffusion-webui-localization-zh_Hans:WEBUI中文扩展\n
stable-diffusion-webui-wd14-tagger:图片tag反推\n
sd-webui-regional-prompter:图片区域分割\n
stable-diffusion-webui-baidu-netdisk:强大的图像管理器\n
stable-diffusion-webui-anti-burn:通过跳过最后几个步骤并将它们之前的一些图像平均在一起来平滑生成的图像,加快点击停止生成图像后WEBUI的响应速度\n
loopback_scaler:使用迭代过程增强图像分辨率和质量\n
latentcoupleregionmapper:控制绘制和定义区域\n
ultimate-upscale-for-automatic1111:图片放大工具\n
deforum-for-automatic1111:视频生成插件\n
stable-diffusion-webui-images-browser:图像管理器\n
stable-diffusion-webui-huggingface:huggingface模型下载扩展\n
sd-civitai-browser:civitai模型下载扩展\n
a1111-stable-diffusion-webui-vram-estimator:显存占用评估\n
openpose-editor:openpose姿势编辑\n
sd-webui-depth-lib:深度图库,用于Automatic1111/stable-diffusion-webui的controlnet扩展\n
posex:openpose姿势编辑\n
sd-webui-tunnels:WEBUI端口映射扩展\n
batchlinks-webui:批处理链接下载器\n
stable-diffusion-webui-catppuccin:WEBUI主题\n
a1111-sd-webui-lycoris:添加lycoris模型支持\n
stable-diffusion-webui-rembg:人物背景去除\n
stable-diffusion-webui-two-shot:图片区域分割和控制\n
sd-webui-lora-block-weight:lora分层扩展\n
sd-face-editor:面部编辑器\n
sd-webui-segment-anything:图片语义分割\n
sd-webui-controlnet:图片生成控制\n
sd-webui-prompt-all-in-one:tag翻译和管理插件\n
sd-webui-comfyui:在WEBUI添加ComfyUI界面\n
sd-webui-animatediff:GIF生成扩展\n
sd-webui-photopea-embed:在WEBUI界面添加ps功能\n
sd-webui-openpose-editor:ControlNet的pose编辑器\n
sd-webui-llul:给图片的选定区域增加细节\n
sd-webui-bilingual-localization:WEBUI双语对照翻译插件\n
adetailer:图片细节修复扩展\n
sd-webui-mov2mov:视频逐帧处理插件\n
sd-webui-IS-NET-pro:人物抠图\n
ebsynth_utility:视频处理扩展\n
sd_dreambooth_extension:dreambooth模型训练\n
sd-webui-memory-release:显存释放扩展\n
stable-diffusion-webui-dataset-tag-editor:训练集打标和处理扩展\n
sd-webui-stablesr:图片放大\n
sd-webui-deoldify:黑白图片上色\n
stable-diffusion-webui-model-toolkit:大模型数据查看\n
sd-webui-oldsix-prompt-dynamic:动态提示词\n
sd-webui-fastblend:ai视频平滑\n
StyleSelectorXL:选择SDXL模型画风\n
sd-dynamic-prompts:动态提示词\n
LightDiffusionFlow:保存工作流\n
sd-webui-workspace:保存webui生图的参数\n
openOutpaint-webUI-extension:提供类似InvokeAI的统一画布的功能\n
sd-webui-EasyPhoto:以简单的操作生成自己的ai人像\n
\n
\n
" 25 70
}

#ComfyUI插件/自定义节点说明
function help_option_9()
{
    dialog --clear --title "Term-SD" --backtitle "Term-SD帮助选项" --ok-label "确认" --msgbox "ComfyUI插件/自定义节点说明:\n
注:具体介绍请在github上搜索项目\n
\n
插件:\n
ComfyUI-extensions:ComfyUI插件扩展\n
graphNavigator:节点辅助插件\n
\n
节点:\n
was-node-suite-comfyui:适用于 ComfyUI 的广泛节点套件，包含 190 多个新节点\n
ComfyUI_Cutoff:解决tag污染\n
ComfyUI_TiledKSampler:ComfyUI 的平铺采样器\n
ComfyUI_ADV_CLIP_emb:高级剪辑文本编码,可让您选择解释提示权重的方式\n
ComfyUI_Noise:噪声控制\n
ComfyUI_Dave_CustomNode:图片区域控制\n
ComfyUI-Impact-Pack:通过检测器、细节器、升频器、管道等方便地增强图像\n
ComfyUI-Manager:自定义节点/插件管理器\n
ComfyUI-Custom-Nodes:ComfyUI的自定义节点\n
ComfyUI-Custom-Scripts:ComfyUI的增强功能\n
NodeGPT:使用GPT辅助生图\n
Derfuu_ComfyUI_ModdedNodes:方程式节点\n
efficiency-nodes-comfyui:ComfyUI 的效率节点\n
ComfyUI_node_Lilly:通配符文本工具\n
ComfyUI-nodes-hnmr:包含X/Y/Z-plot X/Y/Z,合并,潜在可视化,采样等节点\n
ComfyUI-Vextra-Nodes:包含像素排序,交换颜色模式,拼合颜色等节点\n
ComfyUI-QualityOfLifeSuit_Omar92:包含GPT辅助标签生成,字符串操作,latentTools等节点\n
FN16-ComfyUI-nodes:ComfyUI自定义节点集合\n
masquerade-nodes-comfyui:ComfyUI 掩码相关节点\n
ComfyUI-post-processing-nodes:ComfyUI的后处理节点集合,可实现各种酷炫的图像效果\n
images-grid-comfy-plugin:XYZPlot图生成\n
ComfyUI-CLIPSeg:利用 CLIPSeg 模型根据文本提示为图像修复任务生成蒙版\n
rembg-comfyui-node:背景去除\n
ComfyUI_tinyterraNodes:ComfyUI的自定义节点\n
yk-node-suite-comfyui:ComfyUI的自定义节点\n
ComfyUI_experiments:ComfyUI 的一些实验性自定义节点\n
ComfyUI_tagger:图片tag反推\n
MergeBlockWeighted_fo_ComfyUI:权重合并\n
ComfyUI-Saveaswebp:将生成的图片保存为webp格式\n
trNodes:通过蒙版混合两个图像\n
ComfyUI_NetDist:在多个本地 GPU/联网机器上运行 ComfyUI 工作流程\n
ComfyUI-Image-Selector:从批处理中选择一个或多个图像\n
ComfyUI-Strimmlarns-Aesthetic-Score:图片美学评分\n
ComfyUI_UltimateSDUpscale:图片放大\n
ComfyUI-Disco-Diffusion:Disco Diffusion模块\n
ComfyUI-Waveform-Extensions:一些额外的音频工具,用于示例扩散ComfyUI扩展\n
ComfyUI_Custom_Nodes_AlekPet:包括姿势,翻译等节点\n
comfy_controlnet_preprocessors:ComfyUI的ControlNet辅助预处理器\n
AIGODLIKE-COMFYUI-TRANSLATION:ComfyUI的翻译扩展\n
stability-ComfyUI-nodes:Stability-AI自定义节点支持\n
ComfyUI_Fooocus_KSampler:添加fooocus噪声生成器支持\n
\n
\n
" 25 70
}
