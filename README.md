# term-sd

基于dialog实现界面显示的管理器，支持安装，管理A1111-SD-Webui,ComfyUI.InvokeAI,lora-scripts  
理论上可实现全平台(Windows平台需安装msys2,Android平台需要安装Termux)  
需安装aria2,python,pip,git,dialog，python推荐使用3.10的版本  
使用term-sd前先配置好环境  


windows系统安装配置环境的方法：  

1、进入[msys2官网](https://www.msys2.org/)  
在官网“Installation”找到”1、Download the installer:“，点击右边的按钮进行下载并安装  
安装好后在windows的开始菜单里找到MSYS2 MSYS，打开  

2、在msys终端输入  

    sed -i "s#https\?://mirror.msys2.org/#https://mirrors.tuna.tsinghua.edu.cn/msys2/#g" /etc/pacman.d/mirrorlist*  

然后输入  

    pacman -Syu dialog  

输入y，回车，等待安装完成  
此时完成msys2，和dialog的安装  

3、进入python官网下载python，[python3.10下载](https://www.python.org/downloads/release/python-31011/)  
在python3.10的页面找到Windows installer (64-bit)，点击下载  
打开python安装包，在安装界面的下方勾选“Add python.exe to PATH“，  
然后点击”customize installation“，然后点击next,再点击browse,自己选择要安装的位置，选择好后点击install，等待安装完成  
安装结束前先不要关闭安装界面，先点击”Disable path length limit“，再退出  
此时完成python,pip安装  

4、前往[aira2官网下载](http://aria2.github.io/)，点击“Download version ”进入下载页面，找到“aria2-xx版本-win-64bit-build1.zip ”点击下载，解压得到aria2c.exe  
在系统的某个位置创建一个文件夹，得到一个路径，比如D:\Program Files\aria2，记下来，将aria2c.exe放入文件夹  
按下“win+R”快捷键，打开运行对话框，输入指令：  
    sysdm.cpl  
打开【系统属性】窗体后，依次点击选项卡【高级】、【环境变量】按钮  
在“系统变量”部分点双击“Path”，点击新建，把刚刚记下来的路径粘贴上去，然后一直点确定直至完成  
此时aira2安装完成

 Linux配置环境方法：

Debian系：  

    sudo apt install python3 python3-pip python3-venv git aira2  

ArchLinux系：  

    sudo pacman -S python3 python3-pip python3-venv git aria2  


 配置完环境后使用term-sd的方法：

    aria2c https://raw.githubusercontent.com/licyk/sd-webui-script/main/term-sd.sh  
    chmod +x term-sd.sh  
    ./term-sd.sh  



# sd-webui-for-colab

脚本修改自https://github.com/camenduru/stable-diffusion-webui-colab  
加入一些模型和插件，更换了xformers、cuda、torch版本  
[![Open In Colab](https://colab.research.google.com/assets/colab-badge.svg)](https://colab.research.google.com/github/licyk/sd-webui-scipt/blob/main/stable_diffusion_webui_colab.ipynb)(stable)  
[![Open In Colab](https://colab.research.google.com/assets/colab-badge.svg)](https://colab.research.google.com/github/licyk/sd-webui-scipt/blob/main/fast_stable_diffusion.ipynb)(for  colab free user)  

# stable-diffusion-webui-install

stable diffusion本地部署脚本  
使用前请确保已安装python、git、aria2  
stable-diffusion-webui-install.sh为无github代理的版本  
stable-diffusion-webui-install-proxy.sh添加了github代理，在国内环境下载更快  
update.sh为一键更新sd-webui脚本，用于更新stable diffusion本体和插件，请将该脚本放入stable-diffusion-webui目录下再运行
