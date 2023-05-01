@echo off

echo 修复脚本 v3
echo 更新：repositories也会切换为镜像源
echo 本脚本会设置pip源为清华镜像源，更改部分git设置并且切换更新源为国内镜像，然后更新webui避免报错。

.\git\bin\git.exe config --global --add safe.directory "*"
.\py310\python.exe -m pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple
.\git\bin\git.exe remote set-url origin "https://jihulab.com/hunter0725/stable-diffusion-webui.git"
.\git\bin\git.exe -C "repositories\k-diffusion" remote set-url origin "https://jihulab.com/hunter0725/k-diffusion.git"
.\git\bin\git.exe -C "repositories\BLIP" remote set-url origin "https://jihulab.com/hunter0725/BLIP.git"
.\git\bin\git.exe -C "repositories\CodeFormer" remote set-url origin "https://jihulab.com/hunter0725/CodeFormer.git"
.\git\bin\git.exe -C "repositories\stable-diffusion" remote set-url origin "https://jihulab.com/hunter0725/stable-diffusion.git"
.\git\bin\git.exe -C "repositories\taming-transformers" remote set-url origin "https://jihulab.com/hunter0725/taming-transformers.git"
.\git\bin\git.exe reset --hard
.\git\bin\git.exe pull

pause