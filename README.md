<div align="center">

# Term-SD

_✨ 功能丰富的AI软件管理器_

</div>

- [Term-SD](#term-sd)
  - [简介](#简介)
  - [安装要求](#安装要求)
  - [运行环境配置](#运行环境配置)
    - [Windows](#windows)
    - [Linux](#linux)
    - [MacOS](#macos)
  - [安装Term-SD](#安装term-sd)
  - [帮助文档](#帮助文档)
    - [《Windows平台如何配置Term-SD运行环境》](#windows平台如何配置term-sd运行环境)
    - [《Term-SD界面操作方法》](#term-sd界面操作方法)
    - [《如何使用Term-SD》](#如何使用term-sd)


## 简介
Term-SD是一款基于dialog实现前端界面显示的AI管理器，支持安装，管理以下软件  
- 1、
[AUTOMATIC1111-stable-diffusion-webui](https://github.com/AUTOMATIC1111/stable-diffusion-webui)(支持切换成[SD.Next](https://github.com/vladmandic/automatic)/[stable-diffusion-webui-directml](https://github.com/lshqqytiger/stable-diffusion-webui-directml))  
- 2、[ComfyUI](https://github.com/comfyanonymous/ComfyUI)  
- 3、[InvokeAI](https://github.com/invoke-ai/InvokeAI)  
- 4、[Fooocus](https://github.com/lllyasviel/Fooocus)  
- 5、[lora-scripts](https://github.com/Akegarasu/lora-scripts)  

## 安装要求

Term-SD支持在Linux，Windows，MacOS上运行，在使用Term-SD前先配置好依赖环境，以下是各个平台所需的依赖  
- Windows：msys2，aria2，python，pip，git，dialog，curl  
- Linux：aria2，python，pip，git，dialog，curl  
- MacOS：homebrew，aria2，python，pip，git，dialog，rust，cmake，protobuf，wget，gawk，curl

***

## 运行环境配置

### Windows

_！Windows平台可阅读图文版[《Windows平台如何配置Term-SD运行环境》](#windows平台如何配置term-sd运行环境)_

- 1、安装msys2  
进入[msys2官网](https://www.msys2.org/)  
在官网`Installation`找到`1、Download the installer:`，点击右边的按钮进行下载并安装  

- 2、安装git  
进入[git官网](https://git-scm.com/download/win)  
在Download for Windows页面找到`64-bit Git for Windows Setup.`，点击下载  
打开git安装包，在安装界面自己选择要安装的位置，选择好后一直点击下一步，直至安装完成  

- 3、安装python，pip  
进入[python官网](https://www.python.org/downloads/release/python-31011/)    
在python3.10的页面找到`Windows installer (64-bit)`，点击下载  
打开python安装包，在安装界面点击`customize installation`，然后点击`next`，勾选`Add Python to environment variables`，再点击`browse`，自己选择要安装的位置，选择好后点击`install`，等待安装完成  
安装结束前先不要关闭安装界面，先点击`Disable path length limit`，再退出  
>python安装器在安装python时同时安装pip，一般不需要手动再去安装pip

- 4、安装aria2  
前往[aria2官网](http://aria2.github.io/)  
点击`Download version`进入下载页面，找到`aria2-xx版本-win-64bit-build1.zip`  
点击下载，解压得到一个`aria2c.exe`（Windows系统需要启用`显示文件扩展名`，才能看见文件的扩展名）  
然后打开MSYS2的安装路径（刚刚安装的路径是`C:\msys64`），然后进入`usr`文件夹，再进入`bin`文件夹，将aria2c.exe放入文件夹中  

- 5、配置Windows终端  
>Windows10需在开始菜单中找到`micorsoft store`，搜索`Windows Terminal`进行安装

右键桌面或者文件管理器空的位置，点击`在终端中打开`，在标题栏点击向下的箭头，打开Windows终端设置，点击`添加新配置文件`  
在`名称`中填入`MinGW64`  
在`命令行`填入  
```
C:\msys64\msys2_shell.cmd -defterm -no-start -use-full-path -here -mingw64
```
（`C:\msys64`为安装目录，根据具体安装的目录修改）  
在`启动目录`勾选`使用父进程目录`  
在`图标`填入`C:\msys64\mingw64.ico`  
（`C:\msys64`为安装目录，根据具体安装的目录修改）  
保存后生效，在标题栏点击向下的箭头就可以看到`MinGW64`，打开后就可以下载和运行Term-SD(一定要用在`Windows终端`配置好的`MinGW64`运行Term-SD，`powershell`和`cmd`是没法运行Term-SD的)
>Windows终端默认启动powershell，如果想要启动时直接启动MinGW64，可以在Windows终端设置，`启动`->`默认配置文件`，将`Windows Powershell`改成`MinGW64`，这样每次打开Windows终端时默认就会打开MinGW64  
如果要用msys2安装程序安装的`MSYS2 MINGW64`终端也可以，使用前需要手动编辑`/etc/profile`文件里的`MSYS2_PATH`变量，将aria2c，python添加进去，因为`MSYS2 MINGW64`终端并不会读取`系统属性`里设置的变量

- 6、配置MINGW64镜像源

安装好后在windows的开始菜单里找到`MSYS2 MINGW64`，打开  
在msys终端输入  
```
sed -i "s#https\?://mirror.msys2.org/#https://mirrors.tuna.tsinghua.edu.cn/msys2/#g" /etc/pacman.d/mirrorlist*
pacman -Sy
```
- 7、安装dialog，curl
```
pacman -S dialog curl
```
输入y，回车，等待安装完成  

完成上面的步骤后环境就配置好了，可以在下面的步骤下载和启动Term-SD  

### Linux
在终端输入下面的命令  

Debian(Ubuntu)系：  
```
sudo apt install python3 python3-pip python3-venv git aria2 dialog curl
```
ArchLinux系：  
```
sudo pacman -S python3 python3-pip python3-venv git aria2 dialog curl
```
OpenSEUS：
```
sudo zypper install python3 python3-pip python-venvs git aria2 dialog curl
```
NixOS：
```
nix-env -i python311Full aria git dialog curl
```
### MacOS

- 1、安装homebrew  
打开MacOS终端，输入以下指令，根据提示安装[homebrew](https://brew.sh/zh-cn/)  
（1）配置homebrew镜像源的环境变量
```
export HOMEBREW_API_DOMAIN="https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles/api"
export HOMEBREW_BOTTLE_DOMAIN="https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles"
export HOMEBREW_BREW_GIT_REMOTE="https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/brew.git"
export HOMEBREW_CORE_GIT_REMOTE="https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/homebrew-core.git"
export HOMEBREW_PIP_INDEX_URL="https://pypi.tuna.tsinghua.edu.cn/simple"
```
（2）下载安装脚本并安装 Homebrew(如果下载失败可以多试几次)
```
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```
下载成功后会自动进入安装程序，根据提示来安装

（3）检测homebrew是否安装成功
```
brew -v
```
能够正常输出homebrew版本就说明安装成功  

（4）更新并应用镜像源
```
brew update
```
>参考：  
[《清华大学开源软件镜像站 Homebrew/Linuxbrew镜像使用帮助》](https://mirrors.tuna.tsinghua.edu.cn/help/homebrew/)  
[《Homebrew Documentation》](https://docs.brew.sh/Installation)

- 2、安装git，aria2，dialog，python，rust，cmake，protobuf，wget，gawk，curl
```
brew install git aria2 dialog python@3.10 rust cmake protobuf wget gawk curl
```

>MacOS系统中自带的awk功能较少，可能会影响Term-SD运行，所以需要安装功能更强大的gawk

***

## 安装Term-SD
- 1、下载Term-SD  
打开终端，输入以下命令下载Term-SD
```
aria2c https://github.com/licyk/term-sd/raw/main/term-sd.sh && chmod +x term-sd.sh
```
如果下载失败可以打开科学上网，再输入刚才的指令，或者使用gitlab仓库地址下载  
```
aria2c https://gitlab.com/licyk/term-sd/-/raw/main/term-sd.sh && chmod +x term-sd.sh
```
>term-sd.sh文件所在位置决定了Term-SD安装路径和Term-SD安装ai软件的路径，所以要选好一个自己想要安装的路径再下载

- 2、启动Term-SD  
在终端输入以下命令启动Term-SD
```
./term-sd.sh
```
启动后按照提示安装Term-SD组件后即可正常使用，如果下载失败就更换其他下载源  
每次启动一定要在Term-SD所在目录才能启动，除非使用“term_sd”命令或者“tsd”命令启动（需要通过--quick-cmd启动参数进行安装）  


>huggingface目前在大陆网络环境无法访问😭，需要使用带有TUN模式或者驱动模式的代理软件(如果代理软件没有TUN模式或者驱动模式，需在Term-SD中配置好代理参数)，保证能够正常下载模型。Term-SD能否访问huggingface可使用Term-SD设置中的`网络测试`来测试  
Term-SD在安装ai软件的过程提供modelscope模型下载源，避免huggingface在国内无法访问而导致下载模型失败，但在ai软件运行过程中，ai软件本体或者插件可能会使用huggingface下载模型，这时还是需要使用代理的。可以搭配绘世启动器解决问题（绘世启动器可将huggingface下载链接重定向至国内下载源，解决huggingface无法访问导致下载不了模型的问题）

## 帮助文档

这里是有关Term-SD的使用方法文档

### [《Windows平台如何配置Term-SD运行环境》](https://github.com/licyk/README-collection/blob/main/term-sd/README_config_env.md)
介绍Windows平台下如何配置Term-SD运行环境

### [《Term-SD界面操作方法》](https://github.com/licyk/README-collection/blob/main/term-sd/README_how_to_use_dialog.md)  
介绍Term-SD界面(dialog)的操作方法

### [《如何使用Term-SD》](https://github.com/licyk/README-collection/blob/main/term-sd/README_how_to_use_term_sd.md)  
介绍Term-SD的使用方法，包括安装，管理AI软件，和Term-SD一些功能的使用
