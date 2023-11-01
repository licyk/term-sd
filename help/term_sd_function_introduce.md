Term-SD功能说明：
参数使用方法（设置快捷启动命令后可将“./term-sd.sh”替换成“termsd”或者“tsd”）：

  ./term-sd.sh [--help] [--extra script_name] [--enable-auto-update] [--disable-auto-update] [--reinstall-term-sd] [--remove-term-sd] [--test-network] [--quick-cmd] [--set-python-path python_path] [--set-pip-path pip_path] [--unset-python-path] [--unset-pip-path] [--update-pip] [--enable-new-bar] [--disable-new-bar] [--enable-bar] [--disable-bar] [--set-aria2-multi-threaded thread_value] [--set-cmd-daemon-retry retry_value] [--enable-cache-path-redirect] [--disable-cache-path-redirect]
  
参数功能：
help：显示启动参数帮助
extra：启动扩展脚本选择列表，当选项后面输入了脚本名，则直接启动指定的脚本，否则启动扩展脚本选择界面
multi-threaded-download：安装过程中启用多线程下载模型
enable-auto-update：启动Term-SD自动检查更新功能
disable-auto-update：禁用Term-SD自动检查更新功能
reinstall-term-sd：重新安装Term-SD
remove-term-sd：卸载Term-SD
test-network：测试网络环境，用于测试代理是否可用，需安装curl
quick-cmd：将Term-SD快捷启动指令安装到shell中，在shell中直接输入“termsd”即可启动Term-SD
set-python-path：手动指定python解释器路径，当选项后面输入了路径，则直接使用输入的路径来设置python解释器路径（建议用""把路径括起来），否则启动设置界面
set-pip-path：手动指定pip路径，当选项后面输入了路径，则直接使用输入的路径来设置pip路径（建议用""把路径括起来），否则启动设置界面
unset-python-path：删除自定义python解释器路径配置
unset-pip-path：删除自定义pip解释器路径配置
update-pip：进入虚拟环境时更新pip软件包管理器
enable-new-bar：启用新的Term-SD初始化进度条
disable-new-bar：禁用新的Term-SD初始化进度条
enable-bar：启用Term-SD初始化进度显示（默认）
disable-bar：禁用Term-SD初始化进度显示（加了进度显示只会降低Term-SD初始化速度）
set-aria2-multi-threaded：设置安装ai软件时下载模型的线程数。设置为0时将删除配置
set-cmd-daemon-retry：设置安装ai软件的命令重试次数。在网络不稳定时可能出现命令执行中断，设置该值可让命令执行中断后再重新执行。设置为0时将删除配置
enable-cache-path-redirect：启用ai软件缓存路径重定向功能（默认）
disable-cache-path-redirect：禁用ai软件缓存路径重定向功能

Term-SD的功能（除了安装，更新，启动，卸载）：
主界面：
Term-SD更新管理：对本脚本进行更新，更换更新源，切换版本分支
venv虚拟环境设置：启用/禁用venv环境，默认保持启用，防止不同AI软件因软件包版本不同造成互相干扰
pip镜像源设置：设置pip的下载源，解决国内网络环境访问pip软件源速度慢的问题
pip缓存清理：清理pip在安装软件包后产生的缓存
代理设置：为Term-SD访问网络设置代理，一般用在代理软件开启后，Term-SD安装AI软件时依然出现无法访问huggingface等资源的问题（如果代理软件有驱动模式或者TUN模式时则不会有这种问题，就不需要使用“代理设置”进行配置代理）。该功能也包含网络测试，用来测试网络的访问情况
空间占用分析：显示Term-SD管理的AI软件的所占空间
管理功能：
修复更新：在更新AI软件时出现更新失败时，可使用该功能进行修复
切换版本：对AI软件的版本进行切换
分支切换：切换ai软件的版本分支
更新源切换：切换AI软件的更新源，解决国内网络下载慢的问题
管理插件/自定义节点：对AI软件的插件/自定义节点进行管理
更新依赖：更新ai的python包依赖，一般情况下不需要用到
重新安装：重新执行一次AI软件的安装
重新安装pytorch：用于切换pytorch版本（pytorch为ai的框架，为ai提供大量功能）
修复venv虚拟环境：在移动AI软件的文件夹后，venv会出现路径问题而导致运行异常，该功能可修复该问题
重新构建venv虚拟环境：venv出现比较严重的软件包版本问题，导致AI软件运行异常，此时可使用该功能进行修复（该功能同时会运行“修复venv虚拟环境”功能）;或者在安装ai软件前禁用了虚拟环境，安装后重新启用了虚拟环境，这时也需要运行该功能
pip软件包安装/重装/卸载：安装/重装/卸载python软件包，解决某个软件包缺少或者损坏的问题
依赖库版本管理：记录python依赖库的版本，在ai软件运行正常时，可以用该功能记录python依赖库的各个软件包版本，当因为装插件等导致依赖库的软件包版本出现错误而导致报错时，可用该功能恢复原来依赖库的各个软件包版本，从而解决报错
安装准备功能：
启用pip镜像源：使用国内镜像源下载python软件包
启用github代理：使用github代理站下载github上的软件
huggingface独占代理：仅在下载huggingface上的模型时使用代理，且只在配置代理设置后才会生效（注：在使用驱动模式或者TUN模式的代理软件时，该功能无效，因为代理软件会强制让所有网络流量走代理）
强制使用pip：忽略系统警告强制使用pip包管理器下载软件包，一般用不到，只有在Linux系统中，禁用虚拟环境后才需要使用（不推荐禁用虚拟环境）
常规安装（setup.py）：使用常规安装方式
标准构建安装（--use-pep517）：使用编译安装方式（有时可以解决python软件包安装失败的问题。在InvokeAI官方文档中，安装时推荐使用该模式，实际上用常规安装也可以）

