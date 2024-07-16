#!/bin/bash

# SD WebUI 启动分支判断
sd_webui_launch() {
    term_sd_echo "检测 Stable-Diffusion-WebUI 分支中"
    case "$(git remote get-url origin | awk -F '/' '{print $NF}')" in # 分支判断
        stable-diffusion-webui|stable-diffusion-webui.git)
            a1111_sd_webui_launch
            ;;
        automatic|automatic.git)
            vlad_sd_webui_launch
            ;;
        stable-diffusion-webui-directml|stable-diffusion-webui-directml.git)
            sd_webui_directml_launch
            ;;
        stable-diffusion-webui-forge|stable-diffusion-webui-forge.git)
            sd_webui_forge_launch
            ;;
        *)
            a1111_sd_webui_launch
            ;;
    esac
}
