<div align="center">

# Term-SD

_✨一个小巧，多功能的AI软件管理器_

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
- 1、[AUTOMATIC1111-stable-diffusion-webui](https://github.com/AUTOMATIC1111/stable-diffusion-webui)(支持切换成[SD.Next](https://github.com/vladmandic/automatic)/[stable-diffusion-webui-directml](https://github.com/lshqqytiger/stable-diffusion-webui-directml))  
- 2、[ComfyUI](https://github.com/comfyanonymous/ComfyUI)  
- 3、[InvokeAI](https://github.com/invoke-ai/InvokeAI)  
- 4、[Fooocus](https://github.com/lllyasviel/Fooocus)  
- 5、[lora-scripts](https://github.com/Akegarasu/lora-scripts)  
- 6、[kohya_ss](https://github.com/bmaltais/kohya_ss)  

## 安装要求

Term-SD支持在Linux，Windows，MacOS上运行，在使用Term-SD前先配置好依赖环境，以下是各个平台所需的依赖  
- Windows：msys2，aria2，python，pip，git，dialog，curl  
- Linux：aria2，python，pip，git，dialog，curl  
- MacOS：homebrew，aria2，python，pip，git，dialog，rust，cmake，protobuf，wget，gawk，curl

***

## 运行环境配置

### Windows

_！Windows平台可阅读图文版[《Windows平台如何配置Term-SD运行环境》](#windows平台如何配置term-sd运行环境)_

- 1、安装MSYS2

进入[MSYS2官网](https://www.msys2.org/)  
在官网`Installation`找到`1、Download the installer:`，点击右边的按钮进行下载并安装  

- 2、安装git

进入[git官网](https://git-scm.com/download/win)  
在Download for Windows页面找到`64-bit Git for Windows Setup.`，点击下载  
打开git安装包，在安装界面自己选择要安装的位置，选择好后一直点击下一步，直至安装完成  

>这里不用MSYS2安装git，这是因为如果要在绘世启动器，powershell，cmd使用git，需要将MSYS2添加到环境变量，在这步出错容易导致系统出问题，所以改用手动下git安装包来安装  
如果你完全不担心这种问题并且有足够的能力解决电脑系统问题，可以用MSYS2安装git，并将MSYS2添加到环境变量中

- 3、安装python，pip

进入[python官网](https://www.python.org/downloads/release/python-31011/)    
在python3.10的页面找到`Windows installer (64-bit)`，点击下载  
打开python安装包，在安装界面点击`customize installation`，然后点击`next`，勾选`Add Python to environment variables`，再点击`browse`，自己选择要安装的位置，选择好后点击`install`，等待安装完成  
安装结束后先不要关闭安装界面，先点击`Disable path length limit`（没有该选项时则不用理会），再退出  
>python安装器在安装python时同时安装pip，一般不需要手动再去安装pip

- 4、配置Windows终端

>Windows10需在开始菜单中找到`Micorsoft Store`，搜索`Windows Terminal`进行安装

右键桌面或者文件管理器空的位置，点击`在终端中打开`，在标题栏点击向下的箭头，打开Windows终端设置，点击`添加新配置文件`  
在`名称`中填入`MSYS2 UCRT64`  
在`命令行`填入  
```
C:\msys64\msys2_shell.cmd -defterm -no-start -use-full-path -here -ucrt64 -shell bash
```
在`启动目录`勾选`使用父进程目录`  
在`图标`填入
```
C:\msys64\ucrt64.ico
```
>`C:\msys64`为安装目录，根据具体安装的目录修改

保存后生效，在标题栏点击向下的箭头就可以看到`MSYS2 UCRT64`，打开后就可以下载和运行Term-SD（一定要用在`Windows终端`配置好的`MSYS2 UCRT64`运行Term-SD，`powershell`和`cmd`是没法运行Term-SD的）
>Windows终端默认启动powershell，如果想要启动时直接启动`MSYS2 UCRT64`，可以在Windows终端设置，`启动`->`默认配置文件`，将`Windows Powershell`改成`MSYS2 UCRT64`，这样每次打开Windows终端时默认就会打开MSYS2 UCRT64  
如果要用MSYS2安装程序安装的`MSYS2 UCRT64`终端也可以，使用前需要手动编辑`/etc/profile`文件里的`MSYS2_PATH`变量，将aria2c，python添加进去，因为MSYS2安装的`MSYS2 UCRT64`终端并不会读取`系统属性`里设置的变量

- 5、配置MSYS2镜像源

配置好Windows终端后在Windows终端的顶栏菜单里找到`MSYS2 UCRT64`，打开  
在`MSYS2 UCRT64`终端输入以下内容并回车
```
sed -i "s#https\?://mirror.msys2.org/#https://mirrors.tuna.tsinghua.edu.cn/msys2/#g" /etc/pacman.d/mirrorlist*
pacman -Sy
```

- 6、安装dialog，curl，aria2

输入以下内容并回车
```
pacman -S dialog curl mingw-w64-ucrt-x86_64-aria2
```
输入y，回车，等待安装完成

完成上面的步骤后环境就配置好了，可以在下面的步骤下载和启动Term-SD

### Linux
在终端输入下面的命令

- Debian(Ubuntu)系：
```
sudo apt install python3 python3-pip python3-venv git aria2 dialog curl
```
- ArchLinux系：
```
sudo pacman -S python3 python3-pip python3-venv git aria2 dialog curl
```
- OpenSEUS：
```
sudo zypper install python3 python3-pip python-venvs git aria2 dialog curl
```
- NixOS：
```
nix-env -i python311Full aria git dialog curl
```
### MacOS

- 1、安装homebrew

（1）配置[homebrew镜像源](https://mirrors.tuna.tsinghua.edu.cn/help/homebrew/)的环境变量
```
export HOMEBREW_API_DOMAIN="https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles/api"
export HOMEBREW_BOTTLE_DOMAIN="https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles"
export HOMEBREW_BREW_GIT_REMOTE="https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/brew.git"
export HOMEBREW_CORE_GIT_REMOTE="https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/homebrew-core.git"
export HOMEBREW_PIP_INDEX_URL="https://pypi.tuna.tsinghua.edu.cn/simple"
```
（2）下载安装脚本并安装[Homebrew](https://brew.sh/zh-cn/)（如果下载失败可以多试几次）
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

## 帮助文档

这里是有关Term-SD的使用方法文档

### [《Windows平台如何配置Term-SD运行环境》](https://github.com/licyk/README-collection/blob/main/term-sd/README_config_env.md)
介绍Windows平台下如何配置Term-SD运行环境

### [《Term-SD界面操作方法》](https://github.com/licyk/README-collection/blob/main/term-sd/README_how_to_use_dialog.md)
介绍Term-SD界面(dialog)的操作方法

### [《如何使用Term-SD》](https://github.com/licyk/README-collection/blob/main/term-sd/README_how_to_use_term_sd.md)
介绍Term-SD的使用方法，包括安装，管理AI软件，和Term-SD一些功能的使用
