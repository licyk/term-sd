#!/bin/bash

# sd-web启动分支判断
sd_webui_launch()
{
    if [ ! -f "$start_path/term-sd/config/sd-webui-launch.conf" ]; then # 找不到启动配置时默认生成一个
        term_sd_echo "未找到启动配置文件,创建中"
        echo "launch.py --theme dark --autolaunch --xformers --skip-load-model-at-start" > "$start_path"/term-sd/config/sd-webui-launch.conf
    fi

    term_sd_echo "检测Stable-Diffusion-WebUI分支中"
    case $(git remote -v | awk 'NR==1 {print $2}' | awk -F'/' '{print $NF}') in # 分支判断
        stable-diffusion-webui|stable-diffusion-webui.git)
            a1111_sd_webui_launch
            ;;
        automatic|automatic.git)
            vlad_sd_webui_launch
            ;;
        stable-diffusion-webui-directml|stable-diffusion-webui-directml.git)
            sd_webui_directml_launch
            ;;
        *)
            a1111_sd_webui_launch
    esac
}
