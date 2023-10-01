# term-sd

基于dialog实现界面显示的AI管理器，支持安装，管理A1111-SD-Webui，ComfyUI.InvokeAI，lora-scripts  
term-sd支持在Linux，Windows，MacOS上运行(Windows平台需安装msys2，MacOS需要安装homebrew)  
使用前需安装aria2，python(3.9~3.11的版本)，pip，git，dialog  
在使用term-sd前先配置好环境  

***

windows系统安装配置环境的方法：  

1、安装msys2  
进入[msys2官网](https://www.msys2.org/)  
在官网`Installation`找到`1、Download the installer:`，点击右边的按钮进行下载并安装  
记下刚刚安装的路径，比如`C:\msys64`
按下`win+R`快捷键，打开运行对话框，输入指令：  

    sysdm.cpl

打开【系统属性】窗口后，依次点击选项卡【高级】、【环境变量】按钮  
在“系统变量”部分点双击“Path”，点击新建，输入以下路径，分别创建两条环境变量  

    C:\msys64\mingw64\bin
    C:\msys64\usr\bin

>`C:\msys64`指msys2安装路径，要根据msys2实际的安装路径进行修改  
如果把msys2安装在`D:\Program Files\MSYS2`路径中，上面的路径就改为  
`D:\Program Files\MSYS2\mingw64\bin`  
`D:\Program Files\MSYS2\usr\bin`  
下面配置Windows终端时同理

2、安装git，dialog  
安装好后在windows的开始菜单里找到`MSYS2 MINGW64`，打开  
在msys终端输入  

    sed -i "s#https\?://mirror.msys2.org/#https://mirrors.tuna.tsinghua.edu.cn/msys2/#g" /etc/pacman.d/mirrorlist*
    pacman -Sy

然后输入  

    pacman -S dialog git

输入y，回车，等待安装完成  

3、安装python，pip  
进入python官网下载python，[python3.10下载](https://www.python.org/downloads/release/python-31011/)  
在python3.10的页面找到`Windows installer (64-bit)`，点击下载  
打开python安装包，在安装界面点击`customize installation`，然后点击`next`，勾选`Add Python to environment variables`，再点击`browse`，自己选择要安装的位置，选择好后点击`install`，等待安装完成  
安装结束前先不要关闭安装界面，先点击`Disable path length limit`，再退出  
>python安装器在安装python时同时安装pip，一般不需要手动再去安装pip

4、安装aria2  
前往[aira2官网下载](http://aria2.github.io/)，点击`Download version`进入下载页面，找到`aria2-xx版本-win-64bit-build1.zip`点击下载，解压得到`aria2c.exe`
在系统的某个位置创建一个文件夹，得到一个路径，比如D:\Program Files\aria2，记下来，将aria2c.exe放入文件夹  
按下“win+R”快捷键，打开运行对话框，输入指令：  

    sysdm.cpl

打开`系统属性`窗体后，依次点击选项卡`高级`->`环境变量`  
在`系统变量`部分点双击`Path`，点击`新建`，把刚刚记下来的路径粘贴上去，然后一直点确定直至完成  

5、配置Windows终端  
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
保存后生效，在标题栏点击向下的箭头就可以看到`MinGW64`，打开后就可以下载和运行term-sd
>Windows终端默认启动powershell，如果想要启动时直接启动MinGW64，可以在Windows终端设置，`启动`->`默认配置文件`，将`Windows Powershell`改成`MinGW64`

Linux配置环境方法：

Debian系：  

    sudo apt install python3 python3-pip python3-venv git aira2

ArchLinux系：  

    sudo pacman -S python3 python3-pip python3-venv git aria2

MacOS配置环境方法：

1、安装homebrew  
打开MacOS终端，输入以下指令，根据提示安装homebrew
```
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

2、安装git，aria2，dialog，python
```
brew install git aria2 dialog python
```

***

 配置完环境后使用term-sd的方法：  
 1、下载term-sd

    aria2c https://raw.githubusercontent.com/licyk/sd-webui-script/main/term-sd.sh && chmod +x term-sd.sh

如果下载失败可以打开科学上网，再输入刚才的指令，或者使用github代理下载  

    aria2c https://ghproxy.com/https://raw.githubusercontent.com/licyk/sd-webui-script/main/term-sd.sh && chmod +x term-sd.sh

2、启动term-sd

    ./term-sd.sh

启动后按照提示安装term-sd组件后即可正常使用，在term-sd的帮助功能中可以查看详细的使用方法  
>huggingface目前在大陆网络环境无法访问，需要使用带有TUN模式或者驱动模式的代理软件(如果开启代理软件后还会出现下载失败的问题，需在term-sd中配置好代理参数)，保证能够正常下载模型

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
