<div align="center">

# Term-SD

_✨一个小巧，多功能的 AI 软件管理器_

</div>

- [Term-SD](#term-sd)
  - [概述](#概述)
  - [安装要求](#安装要求)
  - [配置运行环境](#配置运行环境)
    - [Windows](#windows)
    - [Linux](#linux)
    - [MacOS](#macos)
  - [安装 Term-SD](#安装-term-sd)
  - [帮助文档](#帮助文档)
    - [《Windows 平台如何配置 Term-SD 运行环境》](#windows-平台如何配置-term-sd-运行环境)
    - [《在 Linux 上使用 Python 版本管理器安装 Python》](#在-linux-上使用-python-版本管理器安装-python)
    - [《Term-SD 界面操作方法》](#term-sd-界面操作方法)
    - [《如何使用 Term-SD》](#如何使用-term-sd)

***

## 概述
Term-SD 是一款基于 Dialog 实现前端界面显示的 AI 管理器，支持安装，管理以下软件  
- 1、[Stable-Diffusion-WebUI](https://github.com/AUTOMATIC1111/stable-diffusion-webui) / [Stable-Diffusion-WebUI-Forge](https://github.com/lllyasviel/stable-diffusion-webui-forge) / [stable-diffusion-webui-reForge](https://github.com/Panchovix/stable-diffusion-webui-reForge) / [Stable-Diffusion-WebUI-AMDGPU](https://github.com/lshqqytiger/stable-diffusion-webui-amdgpu) / [SD.Next](https://github.com/vladmandic/automatic)
- 2、[ComfyUI](https://github.com/comfyanonymous/ComfyUI)
- 3、[InvokeAI](https://github.com/invoke-ai/InvokeAI)
- 4、[Fooocus](https://github.com/lllyasviel/Fooocus)
- 5、[lora-scripts](https://github.com/Akegarasu/lora-scripts)
- 6、[kohya_ss](https://github.com/bmaltais/kohya_ss)

***

## 安装要求

Term-SD 支持在 Linux，Windows，MacOS 上运行，在使用 Term-SD 前先配置好依赖环境，以下是各个平台所需的依赖：
- Windows：MSYS2，Aria2，Python，Pip，Git，Dialog，Curl，Visual C++ Runtime
- Linux：Aria2，Python，Pip，Git，Dialog，Curl
- MacOS：Homebrew，Aria2，Python，Pip，Git，Dialog，Rust，Cmake，Protobuf，Wget，Curl

>[!NOTE]  
>Python 的版本建议使用 3.9 ~ 3.11，推荐使用 3.10。这里推荐一些 Python 版本管理器。  
>1. [Pyenv](https://github.com/pyenv/pyenv)（Windows 系统上使用 [Pyenv-Win](https://github.com/pyenv-win/pyenv-win)）
>2. [MicroMamba](https://mamba.readthedocs.io/en/latest/installation/micromamba-installation.html)
>3. [MiniConda](https://docs.anaconda.com/free/miniconda/index.html)
>
>在 Linux 上安装指定版本的 Python 并不方便，所以可以用上面的 Python 版本管理器安装 Python，并在启动 Term-SD 时加上`--set-python-path`启动参数来指定 Python 的路径。  
>具体方法可参考该文档：[《在 Linux 上使用 Python 版本管理器安装 Python》](#在-linux-上使用-python-版本管理器安装-python)

***

## 配置运行环境

### Windows

_！Windows 平台可阅读图文版[《Windows 平台如何配置 Term-SD 运行环境》](#windows-平台如何配置-term-sd-运行环境)_

1. 安装 MSYS2

下载 [MSYS2](https://github.com/msys2/msys2-installer/releases/download/2024-05-07/msys2-x86_64-20240507.exe) 安装包。  
下载好后打开 MSYS2 安装包，打开后点击`Next`进入安装路径选择，点击`Browse`选择安装路交警，选择好后点击`Next`进行安装。


2. 安装 Python，Pip

下载 [Python](https://www.python.org/ftp/python/3.10.11/python-3.10.11-amd64.exe) 安装包。  
下载好后打开 Python 安装包，在安装界面点击`Customize installation`，然后点击`Next`，勾选`Add Python to environment variables`，再点击`Browse`，自己选择要安装的路径，选择好后点击`install`，等待安装完成。  
安装结束后先不要关闭安装界面，先点击`Disable path length limit`（没有该选项时则不用理会），再退出。

>[!NOTE]  
>1. Python 安装器在安装 Python 时同时安装 Pip（安装选项中已默认勾选安装 Pip），所以不需要手动再去安装 Pip。  
>2. `Disable path length limit`为启用 Windows 系统的长路径支持，具体查看微软官方文档[《最大路径长度限制》](https://learn.microsoft.com/zh-cn/windows/win32/fileio/maximum-file-path-limitation)，之前已经在 Windows 系统中启用该功能之后，选项`Disable path length limit`将不会显示。


3. 安装 Microsoft Visual C++ Redistributable

下载 [Microsoft Visual C++ Redistributable](https://aka.ms/vs/17/release/vc_redist.x64.exe) 并安装。

>[!NOTE]  
>缺失 Microsoft Visual C++ Redistributable 可能会导致 PyTorch 无法正常调用 GPU，参考：[[Bug]: Missing requirement for VC_redist.x64.exe causes "RuntimeError: Torch is not able to use GPU" · Issue #16032 · AUTOMATIC1111/stable-diffusion-webui](https://github.com/AUTOMATIC1111/stable-diffusion-webui/issues/16032)


4. 配置 Windows 终端

>[!NOTE]  
>Windows10 需在开始菜单中找到 Micorsoft Store 并进入，搜索 [Windows Terminal](https://www.microsoft.com/store/productId/9N0DX20HK701?ocid=pdpshare) 进行安装。

右键桌面或者文件管理器空的位置，点击`在终端中打开`，在标题栏点击向下的箭头，打开 Windows 终端设置，点击`添加新配置文件`。  
在`名称`中填入`MSYS2 UCRT64`。  
在`命令行`填入以下内容：

```
C:\msys64\msys2_shell.cmd -defterm -no-start -use-full-path -here -ucrt64 -shell bash
```

在`启动目录`勾选`使用父进程目录`。  
在`图标`填入以下内容

```
C:\msys64\ucrt64.ico
```

>[!NOTE]  
>`C:\msys64`为 MSYS2 的安装目录，根据具体安装的目录修改。

保存后生效，在标题栏点击向下的箭头就可以看到`MSYS2 UCRT64`，打开后就可以下载和运行 Term-SD（一定要用在 Windows 终端 配置好的 MSYS2 UCRT64 运行 Term-SD，PowerShell 和 CMD 是没法运行 Term-SD 的）。

>[!NOTE]  
>Windows 终端默认启动 PowerShell，如果想要启动时直接启动 MSYS2 UCRT64，可以在Windows 终端设置，`启动` -> `默认配置文件`，将`Windows Powershell`改成`MSYS2 UCRT64`，这样每次打开 Windows 终端时默认就会打开 MSYS2 UCRT64，不过 MSYS2 UCRT64 并不兼容 PowerShell 或者 CMD 的命令。  
>不推荐使用 MSYS2 安装程序安装的 MSYS2 UCRT64 终端。


5. 配置 MSYS2 镜像源

配置好 Windows 终端后在 Windows 终端的顶栏菜单里找到`MSYS2 UCRT64`，打开  
在 MSYS2 UCRT64 终端输入以下内容并回车。

```
sed -i "s#https\?://mirror.msys2.org/#https://mirrors.tuna.tsinghua.edu.cn/msys2/#g" /etc/pacman.d/mirrorlist*
pacman -Sy
```


6. 安装 Git，Dialog，Curl，Aria2

输入以下内容并回车。

```
pacman -S git mingw-w64-ucrt-x86_64-git-lfs dialog curl mingw-w64-ucrt-x86_64-aria2 mingw-w64-ucrt-x86_64-ca-certificates
```

输入`y`，回车，等待安装完成。


完成上面的步骤后 Term-SD 的运行环境就配置好了，可以在下面的步骤[安装 Term-SD](#安装-term-sd)。


### Linux
在终端输入下面的命令：

- Debian (Ubuntu) 系：
```
sudo apt install python3 python3-pip python3-venv python3-tk git aria2 dialog curl
```

- ArchLinux 系：
```
sudo pacman -S python3 python3-pip python3-venv tk git aria2 dialog curl
```

- OpenSEUS：
```
sudo zypper install python3 python3-pip python-venvs python-tk git aria2 dialog curl
```

- NixOS：
```
nix-env -i python311Full aria git dialog curl
```

>[!NOTE]  
>一些 Linux 发行版没法安装指定版本的 Python，导致 Python 版本不合适，造成 AI 软件运行出错，所以可以用[安装要求](#安装要求)部分推荐的 Python 版本管理器安装 Python，并在启动 Term-SD 时加上`--set-python-path`启动参数来指定 Python 的路径。  
>参考该教程：[《在 Linux 上使用 Python 版本管理器安装 Python》](#在-linux-上使用-python-版本管理器安装-python)

完成上面的步骤后 Term-SD 的运行环境就配置好了，可以在下面的步骤[安装 Term-SD](#安装-term-sd)。


### MacOS

1. 配置 [Homebrew 镜像源](https://mirrors.tuna.tsinghua.edu.cn/help/homebrew/) 的环境变量。

```
export HOMEBREW_API_DOMAIN="https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles/api"
export HOMEBREW_BOTTLE_DOMAIN="https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles"
export HOMEBREW_BREW_GIT_REMOTE="https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/brew.git"
export HOMEBREW_CORE_GIT_REMOTE="https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/homebrew-core.git"
export HOMEBREW_PIP_INDEX_URL="https://pypi.tuna.tsinghua.edu.cn/simple"
```


2. 下载安装脚本并安装 [Homebrew](https://brew.sh/zh-cn/)（如果下载失败可以多试几次）。

```
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```
下载成功后会自动进入安装程序，根据提示来安装。


3. 检测 Homebrew 是否安装成功

```
brew -v
```

能够正常输出 Homebrew 版本就说明安装成功。


4. 更新并应用镜像源

```
brew update
```

>[!NOTE]  
>参考：  
[《清华大学开源软件镜像站 Homebrew / Linuxbrew 镜像使用帮助》](https://mirrors.tuna.tsinghua.edu.cn/help/homebrew/)  
[《Homebrew Documentation》](https://docs.brew.sh/Installation)


5. 安装 Git，Aria2，Dialog，Python，Rust，Cmake，Protobuf，Wget，Curl

```
brew install git aria2 dialog python@3.10 rust cmake protobuf wget curl
```

完成上面的步骤后 Term-SD 的运行环境就配置好了，可以在下面的步骤[安装 Term-SD](#安装-term-sd)。

***

## 安装 Term-SD
1. 下载 Term-SD

打开终端，输入以下命令下载 Term-SD。

```
aria2c https://github.com/licyk/term-sd/raw/main/term-sd.sh && chmod +x term-sd.sh
```

如果下载失败可以打开科学上网，再输入刚才的指令，或者使用 Gitee 仓库地址下载。

```
aria2c https://gitee.com/licyk/term-sd/raw/main/term-sd.sh && chmod +x term-sd.sh
```

>[!NOTE]  
>1. term-sd.sh 文件所在路径决定了 Term-SD 安装路径和 Term-SD 安装 AI 软件的路径，所以要选好一个自己想要安装的路径再下载，当然也可以把 term-sd.sh 文件移到其他路径。  
>2. Term-SD 已支持修改 AI 软件的安装路径，可以在 Term-SD 的`Term-SD 设置` -> `自定义安装路径`中设置，该功能的说明在[《如何使用Term-SD》](https://github.com/licyk/README-collection/blob/main/term-sd/README_how_to_use_term_sd.md)。


2. 启动 Term-SD

在终端输入以下命令启动 Term-SD。

```
./term-sd.sh
```

启动后等待安装 Term-SD 组件后即可正常使用。  
可在启动 Term-SD 时加上`--quick-cmd`启动参数安装`term_sd`命令和`tsd`命令，使启动 Term-SD 更快捷。  
更多信息请阅读[帮助文档](#帮助文档)。

***

## 帮助文档

<h3>这里是有关 Term-SD 的使用方法文档。</h3>

### [《Windows 平台如何配置 Term-SD 运行环境》](https://github.com/licyk/README-collection/blob/main/term-sd/README_config_env.md)
介绍 Windows 平台下如何配置 Term-SD 运行环境。

### [《在 Linux 上使用 Python 版本管理器安装 Python》](https://github.com/licyk/README-collection/blob/main/term-sd/README_install_python_on_linux.md)
介绍使用 Python 版本管理器安装指定版本的 Python。

### [《Term-SD 界面操作方法》](https://github.com/licyk/README-collection/blob/main/term-sd/README_how_to_use_dialog.md)
介绍 Term-SD 界面 (Dialog) 的操作方法。

### [《如何使用 Term-SD》](https://github.com/licyk/README-collection/blob/main/term-sd/README_how_to_use_term_sd.md)
介绍 Term-SD 的使用方法，包括安装，管理 AI 软件，和 Term-SD 一些功能的使用。
