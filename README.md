# Term-SD

基于dialog实现界面显示的AI管理器，支持安装，管理[AUTOMATIC1111-stable-diffusion-webui](https://github.com/AUTOMATIC1111/stable-diffusion-webui)(支持切换成[SD.Next](https://github.com/vladmandic/automatic)/[stable-diffusion-webui-directml](https://github.com/lshqqytiger/stable-diffusion-webui-directml))，[ComfyUI](https://github.com/comfyanonymous/ComfyUI)，[InvokeAI](https://github.com/invoke-ai/InvokeAI)，[Fooocus](https://github.com/lllyasviel/Fooocus)，[lora-scripts](https://github.com/Akegarasu/lora-scripts)  
Term-SD支持在Linux，Windows，MacOS上运行(Windows平台还需要安装msys2，MacOS还需要安装homebrew，rust，cmake，protobuf，wget)  
使用Term-SD前需要安装aria2，python(3.9~3.11的版本)，pip，git，dialog  
在使用Term-SD前先配置好环境  

***

## Windows系统配置Term-SD运行环境的方法：  

### ！Windows平台可阅读图文版 [《Windows平台如何配置Term-SD运行环境》](https://github.com/licyk/README-collection/blob/main/term-sd/README_config_env.md)

### 1、安装msys2  
进入[msys2官网](https://www.msys2.org/)  
在官网`Installation`找到`1、Download the installer:`，点击右边的按钮进行下载并安装  

### 2、安装git  
进入[git官网](https://git-scm.com/download/win)  
在Download for Windows页面找到`64-bit Git for Windows Setup.`，点击下载  
打开git安装包，在安装界面自己选择要安装的位置，选择好后一直点击下一步，直至安装完成  

### 3、安装python，pip  
进入[python官网](https://www.python.org/downloads/release/python-31011/)    
在python3.10的页面找到`Windows installer (64-bit)`，点击下载  
打开python安装包，在安装界面点击`customize installation`，然后点击`next`，勾选`Add Python to environment variables`，再点击`browse`，自己选择要安装的位置，选择好后点击`install`，等待安装完成  
安装结束前先不要关闭安装界面，先点击`Disable path length limit`，再退出  
>python安装器在安装python时同时安装pip，一般不需要手动再去安装pip

### 4、安装aria2  
前往[aira2官网](http://aria2.github.io/)  
点击`Download version`进入下载页面，找到`aria2-xx版本-win-64bit-build1.zip`点击下载，解压得到`aria2c.exe`
在系统的某个位置创建一个文件夹，得到一个路径，比如D:\Program Files\aria2，记下来，将aria2c.exe放入文件夹  
按下“win+R”快捷键，打开运行对话框，输入指令：  
```
sysdm.cpl
```
打开`系统属性`窗体后，依次点击选项卡`高级`->`环境变量`  
在`系统变量`部分点双击`Path`，点击`新建`，把刚刚记下来的路径粘贴上去，然后一直点确定直至完成  

### 5、配置Windows终端  
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

### 6、配置MINGW64镜像源

安装好后在windows的开始菜单里找到`MSYS2 MINGW64`，打开  
在msys终端输入  
```
sed -i "s#https\?://mirror.msys2.org/#https://mirrors.tuna.tsinghua.edu.cn/msys2/#g" /etc/pacman.d/mirrorlist*
pacman -Sy
```
### 7、安装dialog
```
pacman -S dialog
```
输入y，回车，等待安装完成  

完成上面的步骤后环境就配置好了，可以在下面的步骤下载和启动Term-SD  

## Linux系统配置Term-SD运行环境的方法：  
在终端输入下面的命令  

Debian(Ubuntu)系：  
```
sudo apt install python3 python3-pip python3-venv git aira2 dialog
```
ArchLinux系：  
```
sudo pacman -S python3 python3-pip python3-venv git aria2 dialog
```
OpenSEUS：
```
sudo zypper install python3 python3-pip python-venvs git aria2 dialog
```
NixOS：
```
nix-env -i python311Full aria git dialog
```
## MacOS系统配置Term-SD运行环境的方法：

### 1、安装homebrew  
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

### 2、安装git，aria2，dialog，python，rust，cmake，protobuf，wget
```
brew install git aria2 dialog python@3.10 rust cmake protobuf wget
```

***

## 配置完环境后使用Term-SD的方法：  
### 1、下载Term-SD  
打开终端，输入以下命令下载Term-SD
```
aria2c https://raw.githubusercontent.com/licyk/sd-webui-script/main/term-sd.sh && chmod +x term-sd.sh
```
如果下载失败可以打开科学上网，再输入刚才的指令，或者使用github镜像站下载  
```
aria2c https://ghproxy.com/https://raw.githubusercontent.com/licyk/sd-webui-script/main/term-sd.sh && chmod +x term-sd.sh
```
>term-sd.sh文件所在位置决定了Term-SD安装路径和Term-SD安装ai软件的路径，所以要选好一个自己想要安装的路径再下载

### 2、启动Term-SD  
在终端输入以下命令启动Term-SD
```
./term-sd.sh
```
启动后按照提示安装Term-SD组件后即可正常使用，如果下载失败就更换其他下载源  
每次启动一定要在Term-SD所在目录才能启动，除非使用“termsd”命令或者“tsd”命令启动（需要通过--quick-cmd启动参数进行安装）  
### ！操作Term-SD界面前请阅读[《Term-SD界面操作方法》](https://github.com/licyk/README-collection/blob/main/term-sd/README_how_to_use_dialog.md)  
### ！Term-SD的使用方法请阅读[《如何使用Term-SD》](https://github.com/licyk/README-collection/blob/main/term-sd/README_how_to_use_term_sd.md)  

>huggingface目前在大陆网络环境无法访问😭，需要使用带有TUN模式或者驱动模式的代理软件(如果开启代理软件后还会出现下载失败的问题，需在Term-SD中配置好代理参数)，保证能够正常下载模型

***

# sd-webui-for-colab(停更)
### 推荐使用 https://github.com/Van-wise/sd-colab

脚本修改自https://github.com/camenduru/stable-diffusion-webui-colab  
[![Open In Colab](https://colab.research.google.com/assets/colab-badge.svg)](https://colab.research.google.com/github/licyk/sd-webui-scipt/blob/main/other/stable_diffusion_webui_colab.ipynb)(stable)  
[![Open In Colab](https://colab.research.google.com/assets/colab-badge.svg)](https://colab.research.google.com/github/licyk/sd-webui-scipt/blob/main/other/fast_stable_diffusion.ipynb)(for  colab free user)  

# stable-diffusion-webui-install(停更)

stable diffusion本地部署脚本  
使用前请确保已安装python、git、aria2  
stable-diffusion-webui-install.sh为无github代理的版本  
stable-diffusion-webui-install-proxy.sh添加了github代理，在国内环境下载更快  
update.sh为一键更新sd-webui脚本，用于更新stable diffusion本体和插件，请将该脚本放入stable-diffusion-webui目录下再运行
