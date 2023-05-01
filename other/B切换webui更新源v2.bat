@echo off

set orig=https://github.com/AUTOMATIC1111/stable-diffusion-webui
echo 请选择更新源：
echo 1.github源 2.镜像源
set /p choice=输入数字后按回车：

if %choice% == 2 (
	echo 即将设置源为 jihulab/hunter0725
	.\git\bin\git.exe remote set-url origin "https://jihulab.com/hunter0725/stable-diffusion-webui.git"
	.\git\bin\git.exe -C "repositories\k-diffusion" remote set-url origin "https://jihulab.com/hunter0725/k-diffusion.git"
	.\git\bin\git.exe -C "repositories\BLIP" remote set-url origin "https://jihulab.com/hunter0725/BLIP.git"
	.\git\bin\git.exe -C "repositories\CodeFormer" remote set-url origin "https://jihulab.com/hunter0725/CodeFormer.git"
	.\git\bin\git.exe -C "repositories\stable-diffusion" remote set-url origin "https://jihulab.com/hunter0725/stable-diffusion.git"
	.\git\bin\git.exe -C "repositories\taming-transformers" remote set-url origin "https://jihulab.com/hunter0725/taming-transformers.git"
) else (
	echo 即将设置源为 github源
	.\git\bin\git.exe remote set-url origin %orig%
	.\git\bin\git.exe -C "repositories\k-diffusion" remote set-url origin "https://github.com/crowsonkb/k-diffusion.git"
	.\git\bin\git.exe -C "repositories\BLIP" remote set-url origin "https://github.com/salesforce/BLIP.git"
	.\git\bin\git.exe -C "repositories\CodeFormer" remote set-url origin "https://github.com/sczhou/CodeFormer.git"
	.\git\bin\git.exe -C "repositories\stable-diffusion" remote set-url origin "https://github.com/CompVis/stable-diffusion.git"
	.\git\bin\git.exe -C "repositories\taming-transformers" remote set-url origin "https://github.com/CompVis/taming-transformers.git"
)

pause