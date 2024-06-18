#!/bin/bash

# huggingface全局镜像源设定
term_sd_huggingface_global_mirror_setting()
{
    local term_sd_huggingface_global_mirror_setting_dialog

    while true
    do
        term_sd_huggingface_global_mirror_setting_dialog=$(dialog --erase-on-exit --notags \
            --title "Term-SD" \
            --backtitle "HuggingFace 镜像源选项" \
            --ok-label "确认" --cancel-label "取消" \
            --menu "该功能用于设置 HuggingFace 镜像源, 加速国内下载 HuggingFace 文件的速度\n当前 HuggingFace 镜像源配置: $([ -f "term-sd/config/set-global-huggingface-mirror.conf" ] && echo "$HF_ENDPOINT" || echo "未设置")\n请选择对 HuggingFace 镜像源的操作" \
            $term_sd_dialog_height $term_sd_dialog_width $term_sd_dialog_menu_height \
            "0" "> 返回" \
            "1" "> 设置 HuggingFace 镜像源" \
            "2" "> 删除 HuggingFace 镜像源配置" \
            3>&1 1>&2 2>&3)

        case $term_sd_huggingface_global_mirror_setting_dialog in
            1)
                term_sd_set_huggingface_mirror
                if [ $? = 0 ];then
                    dialog --erase-on-exit \
                        --title "Term-SD" \
                        --backtitle "HuggingFace 镜像源选项" \
                        --ok-label "确认" \
                        --msgbox "设置 HuggingFace 镜像源代理完成\n当前使用的 HuggingFace 镜像源: $term_sd_huggingface_mirror" \
                        $term_sd_dialog_height $term_sd_dialog_width
                else
                    term_sd_echo "取消设置 HuggingFace 镜像源"
                fi
                ;;
            2)
                if (dialog --erase-on-exit \
                    --title "Term-SD" \
                    --backtitle "HuggingFace 镜像源选项" \
                    --yes-label "是" --no-label "否" \
                    --yesno "是否删除 HuggingFace 镜像源配置?" \
                    $term_sd_dialog_height $term_sd_dialog_width) then

                    term_sd_echo "删除 HuggingFace 镜像源"
                    rm -f "$start_path"/term-sd/config/set-global-huggingface-mirror.conf
                    rm -f "$start_path"/term-sd/config/set-dynamic-global-huggingface-mirror.lock
                    unset HF_ENDPOINT

                    dialog --erase-on-exit \
                        --title "Term-SD" \
                        --backtitle "HuggingFace 镜像源选项" \
                        --ok-label "确认" \
                        --msgbox "删除 HuggingFace 镜像源配置完成" \
                        $term_sd_dialog_height $term_sd_dialog_width
                fi
                ;;
            *)
                break
                ;;
        esac
    done
}

term_sd_set_huggingface_mirror()
{
    local term_sd_set_huggingface_mirror_dialog

    term_sd_set_huggingface_mirror_dialog=$(dialog --erase-on-exit --notags \
        --title "Term-SD" \
        --backtitle "HuggingFace 镜像源选项" \
        --ok-label "确认" \
        --cancel-label "取消" \
        --menu "选择要使用的 HuggingFace 镜像源, 推荐设置动态 HuggingFace 镜像源" \
        $term_sd_dialog_height $term_sd_dialog_width $term_sd_dialog_menu_height \
        "0" "> 返回" \
        "1" "> 设置动态 HuggingFace 镜像源" \
        "2" "> 自动选择 HuggingFace 镜像源" \
        "3" "> HuggingFace 镜像源1 (hf-mirror.com)" \
        "4" "> HuggingFace 镜像源2 (huggingface.sukaka.top)" \
        3>&1 1>&2 2>&3)

    case $term_sd_set_huggingface_mirror_dialog in
        1)
            term_sd_echo "启用动态 HuggingFace 镜像源中"
            touch "$start_path"/term-sd/config/set-dynamic-global-huggingface-mirror.lock
            term_sd_auto_setup_huggingface_mirror
            if [ -f "$start_path/term-sd/config/set-global-huggingface-mirror.conf" ];then
                term_sd_huggingface_mirror=$(cat "$start_path/term-sd/config/set-global-huggingface-mirror.conf")
            else
                term_sd_huggingface_mirror="无"
            fi
            term_sd_echo "启用动态 HuggingFace 镜像源完成"
            return 0
            ;;
        2)
            rm -f "$start_path"/term-sd/config/set-dynamic-global-huggingface-mirror.lock
            term_sd_echo "测试可用 HuggingFace 镜像源"
            term_sd_test_avaliable_huggingface_mirror
            echo "$term_sd_huggingface_mirror" > "$start_path"/term-sd/config/set-global-huggingface-mirror.conf
            export HF_ENDPOINT=$term_sd_huggingface_mirror
            return 0
            ;;
        3)
            rm -f "$start_path"/term-sd/config/set-dynamic-global-huggingface-mirror.lock
            term_sd_huggingface_mirror="https://hf-mirror.com"
            echo "$term_sd_huggingface_mirror" > "$start_path"/term-sd/config/set-global-huggingface-mirror.conf
            export HF_ENDPOINT=$term_sd_huggingface_mirror
            return 0
            ;;
        4)
            rm -f "$start_path"/term-sd/config/set-dynamic-global-huggingface-mirror.lock
            term_sd_huggingface_mirror="https://huggingface.sukaka.top"
            echo "$term_sd_huggingface_mirror" > "$start_path"/term-sd/config/set-global-huggingface-mirror.conf
            export HF_ENDPOINT=$term_sd_huggingface_mirror
            return 0
            ;;
        *)
            return 1
            ;;
    esac
}

# 测试可用的huggingface镜像源
term_sd_test_avaliable_huggingface_mirror()
{
    local mirror_list=$huggingface_mirror_list
    local req
    local i
    local http_proxy
    local https_proxy
    http_proxy= # 临时清除配置好的代理,防止干扰测试
    https_proxy=
    for i in $mirror_list ;do
        curl ${i}/licyk/sd-model/resolve/main/README.md -o /dev/null --connect-timeout 10 --silent
        if [ $? = 0 ];then
            term_sd_huggingface_mirror=$i
            return
        fi
    done
    term_sd_huggingface_mirror="https://hf-mirror.com"
}

