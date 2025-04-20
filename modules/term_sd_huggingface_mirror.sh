#!/bin/bash

# HuggingFace 全局镜像源设定
# 使用 HF_ENDPOINT 环境变量设置 HuggingFace Api 使用的镜像源
# 使用 TERM_SD_HUGGINGFACE_MIRROR 全局变量获取使用的 HuggingFace 镜像源
term_sd_huggingface_global_mirror_setting() {
    local dialog_arg
    local huggingface_mirror_status
    local dynamic_huggingface_mirror_status

    while true; do
        if [[ -f "${START_PATH}/term-sd/config/set-global-huggingface-mirror.conf" ]]; then
            huggingface_mirror_status=$HF_ENDPOINT
        else
            huggingface_mirror_status="未设置"
        fi

        if [[ -f "${START_PATH}/term-sd/config/set-dynamic-global-huggingface-mirror.lock" ]]; then
            dynamic_huggingface_mirror_status="启用"
        else
            dynamic_huggingface_mirror_status="禁用"
        fi

        dialog_arg=$(dialog --erase-on-exit --notags \
            --title "Term-SD" \
            --backtitle "HuggingFace 镜像源选项" \
            --ok-label "确认" --cancel-label "取消" \
            --menu "该功能用于设置 HuggingFace 镜像源, 加速国内下载 HuggingFace 文件的速度\n当前 HuggingFace 镜像源配置: ${huggingface_mirror_status}\n动态 HuggingFace 镜像源: ${dynamic_huggingface_mirror_status}\n请选择对 HuggingFace 镜像源的操作" \
            $(get_dialog_size_menu) \
            "0" "> 返回" \
            "1" "> 设置 HuggingFace 镜像源" \
            "2" "> 删除 HuggingFace 镜像源配置" \
            3>&1 1>&2 2>&3)

        case "${dialog_arg}" in
            1)
                term_sd_set_huggingface_mirror
                if [[ "$?" == 0 ]]; then
                    dialog --erase-on-exit \
                        --title "Term-SD" \
                        --backtitle "HuggingFace 镜像源选项" \
                        --ok-label "确认" \
                        --msgbox "设置 HuggingFace 镜像源代理完成\n当前使用的 HuggingFace 镜像源: ${TERM_SD_HUGGINGFACE_MIRROR}" \
                        $(get_dialog_size)
                else
                    term_sd_echo "取消设置 HuggingFace 镜像源"
                fi
                ;;
            2)
                if (dialog --erase-on-exit \
                    --title "Term-SD" \
                    --backtitle "HuggingFace 镜像源选项" \
                    --yes-label "是" --no-label "否" \
                    --yesno "是否删除 HuggingFace 镜像源配置 ?" \
                    $(get_dialog_size)); then

                    term_sd_echo "删除 HuggingFace 镜像源"
                    rm -f "${START_PATH}"/term-sd/config/set-global-huggingface-mirror.conf
                    rm -f "${START_PATH}"/term-sd/config/set-dynamic-global-huggingface-mirror.lock
                    unset HF_ENDPOINT

                    dialog --erase-on-exit \
                        --title "Term-SD" \
                        --backtitle "HuggingFace 镜像源选项" \
                        --ok-label "确认" \
                        --msgbox "删除 HuggingFace 镜像源配置完成" \
                        $(get_dialog_size)
                fi
                ;;
            *)
                break
                ;;
        esac
    done

    unset TERM_SD_HUGGINGFACE_MIRROR
}

# HuggingFace 镜像源选择
# 使用 TERM_SD_HUGGINGFACE_MIRROR 全局变量保存选择的 HuggingFace 镜像源
term_sd_set_huggingface_mirror() {
    local dialog_arg

    dialog_arg=$(dialog --erase-on-exit --notags \
        --title "Term-SD" \
        --backtitle "HuggingFace 镜像源选项" \
        --ok-label "确认" \
        --cancel-label "取消" \
        --menu "选择要使用的 HuggingFace 镜像源, 推荐设置动态 HuggingFace 镜像源" \
        $(get_dialog_size_menu) \
        "0" "> 返回" \
        "1" "> 设置动态 HuggingFace 镜像源" \
        "2" "> 自动选择 HuggingFace 镜像源" \
        "3" "> HuggingFace 镜像源1 (hf-mirror.com)" \
        "4" "> HuggingFace 镜像源2 (huggingface.sukaka.top)" \
        3>&1 1>&2 2>&3)

    case "${dialog_arg}" in
        1)
            term_sd_echo "启用动态 HuggingFace 镜像源中"
            touch "${START_PATH}"/term-sd/config/set-dynamic-global-huggingface-mirror.lock
            term_sd_auto_setup_huggingface_mirror
            if [ -f "${START_PATH}/term-sd/config/set-global-huggingface-mirror.conf" ]; then
                TERM_SD_HUGGINGFACE_MIRROR=$(cat "${START_PATH}/term-sd/config/set-global-huggingface-mirror.conf")
            else
                TERM_SD_HUGGINGFACE_MIRROR="无"
            fi
            term_sd_echo "启用动态 HuggingFace 镜像源完成"
            return 0
            ;;
        2)
            rm -f "${START_PATH}"/term-sd/config/set-dynamic-global-huggingface-mirror.lock
            term_sd_echo "测试可用 HuggingFace 镜像源"
            term_sd_test_avaliable_huggingface_mirror
            echo "$TERM_SD_HUGGINGFACE_MIRROR" > "${START_PATH}"/term-sd/config/set-global-huggingface-mirror.conf
            export HF_ENDPOINT=$TERM_SD_HUGGINGFACE_MIRROR
            return 0
            ;;
        3)
            rm -f "${START_PATH}"/term-sd/config/set-dynamic-global-huggingface-mirror.lock
            TERM_SD_HUGGINGFACE_MIRROR="https://hf-mirror.com"
            echo "$TERM_SD_HUGGINGFACE_MIRROR" > "${START_PATH}"/term-sd/config/set-global-huggingface-mirror.conf
            export HF_ENDPOINT=$TERM_SD_HUGGINGFACE_MIRROR
            return 0
            ;;
        4)
            rm -f "${START_PATH}"/term-sd/config/set-dynamic-global-huggingface-mirror.lock
            TERM_SD_HUGGINGFACE_MIRROR="https://huggingface.sukaka.top"
            echo "$TERM_SD_HUGGINGFACE_MIRROR" > "${START_PATH}"/term-sd/config/set-global-huggingface-mirror.conf
            export HF_ENDPOINT=$TERM_SD_HUGGINGFACE_MIRROR
            return 0
            ;;
        *)
            return 1
            ;;
    esac
}

# 测试可用的 HuggingFace 镜像源
# 使用 TERM_SD_HUGGINGFACE_MIRROR 全局变量保存测试出来的 HuggingFace 镜像源
term_sd_test_avaliable_huggingface_mirror() {
    local mirror_list=$HUGGINGFACE_MIRROR_LIST
    local req
    local i
    local HTTP_PROXY
    local HTTPS_PROXY
    HTTP_PROXY= # 临时清除配置好的代理,防止干扰测试
    HTTPS_PROXY=
    for i in ${mirror_list} ;do
        curl ${i}/licyk/sd-model/resolve/main/README.md -o /dev/null --connect-timeout 10 --silent
        if [[ "$?" == 0 ]]; then
            TERM_SD_HUGGINGFACE_MIRROR=$i
            return
        fi
    done
    TERM_SD_HUGGINGFACE_MIRROR="https://hf-mirror.com"
}

