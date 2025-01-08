#!/bin/bash

# 远程源的种类检测
# 如果是 Github 链接则返回 0, 不是则返回 1
git_remote_url_type_is_github() {
    local GIT_CONFIG_GLOBAL= # 临时取消 Git 配置, 防止影响远程源的判断

    if [[ ! -z "$(git remote get-url origin | grep github.com)" ]]; then # 检测远程源的原地址是否属于 Github 地址
        return 0
    else
        return 1
    fi
}

# 修改远程源(先判断远程源是否符合修改要求)
# 使用格式: git_repo_remote_revise <链接格式>
# 使用 GIT_REPO_REMOTE_REVISE_MESSAGE 全局变量保存替换更新源的结果
git_repo_remote_revise() {
    local name
    local url_format=$1

    name=$(git remote get-url origin | awk -F '/' '{print $NF}') # 获取项目名称
    name=${name%.git}
    if git_remote_url_type_is_github; then # 判断远程源种类
        git_repository_remote_revise "${url_format}" # 执行远程源替换
        if [[ "$?" == 0 ]]; then
            term_sd_echo "替换 ${name} 更新源为 $(echo ${url_format} | awk '{sub("https://","") ; gsub(/\//," ")}1' | awk '{print $1}') 源"
            GIT_REPO_REMOTE_REVISE_MESSAGE="${GIT_REPO_REMOTE_REVISE_MESSAGE} ${name} 更新源替换成功\n"
        else
            term_sd_echo "${name} 更新源无需替换"
            GIT_REPO_REMOTE_REVISE_MESSAGE="${GIT_REPO_REMOTE_REVISE_MESSAGE} ${name} 更新源无需替换\n"
        fi
    else
        term_sd_echo "${name} 更新源非 Github 地址, 不执行替换"
        GIT_REPO_REMOTE_REVISE_MESSAGE="${GIT_REPO_REMOTE_REVISE_MESSAGE} ${name} 更新源非 Github 地址, 不执行替换\n"
    fi
}

# Git 远程源选择
# 将修改远程源的命令保存在 GIT_REPO_REMOTE_REVISE_CMD 全局变量
git_remote_url_select() {
    local dialog_arg
    unset GIT_REPO_REMOTE_REVISE_CMD
    unset GIT_REPO_REMOTE_REVISE_MESSAGE # 清除运行结果

    dialog_arg=$(dialog --erase-on-exit --notags \
        --title "Term-SD" \
        --backtitle "更新源选择界面" \
        --ok-label "确认" \
        --cancel-label "取消" \
        --menu "选择要修改成的更新源\n当前将要修改更新源的 AI 软件: ${TERM_SD_MANAGE_OBJECT}" \
        $(get_dialog_size_menu) \
        "0" "> 返回" \
        "1" "> 官方源 (github.com)" \
        "2" "> 镜像源 1 (ghgo.xyz)" \
        "3" "> 镜像源 2 (mirror.ghproxy.com)" \
        "4" "> 镜像源 3 (gitclone.com)" \
        "5" "> 镜像源 4 (gh-proxy.com)" \
        "6" "> 镜像源 5 (ghps.cc)" \
        "7" "> 镜像源 6 (gh.idayer.com)" \
        "8" "> 镜像源 7 (ghproxy.net)" \
        "9" "> 镜像源 8 (gh.api.99988866.xyz)" \
        3>&1 1>&2 2>&3)

    case "${dialog_arg}" in
        1)
            term_sd_print_line "更新源一键替换"
            GIT_REPO_REMOTE_REVISE_CMD="git_repo_remote_revise https://github.com/term_sd_git_user/term_sd_git_repo"
            return 0
            ;;
        2)
            term_sd_print_line "更新源一键替换"
            GIT_REPO_REMOTE_REVISE_CMD="git_repo_remote_revise https://ghgo.xyz/https://github.com/term_sd_git_user/term_sd_git_repo"
            return 0
            ;;
        3)
            term_sd_print_line "更新源一键替换"
            GIT_REPO_REMOTE_REVISE_CMD="git_repo_remote_revise https://mirror.ghproxy.com/https://github.com/term_sd_git_user/term_sd_git_repo"
            return 0
            ;;
        4)
            term_sd_print_line "更新源一键替换"
            GIT_REPO_REMOTE_REVISE_CMD="git_repo_remote_revise https://gitclone.com/github.com/term_sd_git_user/term_sd_git_repo"
            return 0
            ;;
        5)
            term_sd_print_line "更新源一键替换"
            GIT_REPO_REMOTE_REVISE_CMD="git_repo_remote_revise https://gh-proxy.com/https://github.com/term_sd_git_user/term_sd_git_repo"
            return 0
            ;;
        6)
            term_sd_print_line "更新源一键替换"
            GIT_REPO_REMOTE_REVISE_CMD="git_repo_remote_revise https://ghps.cc/https://github.com/term_sd_git_user/term_sd_git_repo"
            return 0
            ;;
        7)
            term_sd_print_line "更新源一键替换"
            GIT_REPO_REMOTE_REVISE_CMD="git_repo_remote_revise https://gh.idayer.com/https://github.com/term_sd_git_user/term_sd_git_repo"
            return 0
            ;;
        8)
            term_sd_print_line "更新源一键替换"
            GIT_REPO_REMOTE_REVISE_CMD="git_repo_remote_revise https://ghproxy.net/https://github.com/term_sd_git_user/term_sd_git_repo"
            return 0
            ;;
        9)
            term_sd_print_line "更新源一键替换"
            GIT_REPO_REMOTE_REVISE_CMD="git_repo_remote_revise https://gh.api.99988866.xyz/https://github.com/term_sd_git_user/term_sd_git_repo"
            return 0
            ;;
        *)
            term_sd_echo "取消替换 $(basename "$(pwd)") 更新源操作"
            return 1 # 不执行替换
            ;;
    esac
}

# Git 远程源选择(针对单个插件/自定义节点)
# 使用 GIT_REPO_REMOTE_REVISE_MESSAGE 全局变量显示替换更新源的结果
git_remote_url_select_single() {
    local dialog_arg
    local remote_url
    unset GIT_REPO_REMOTE_REVISE_MESSAGE # 清除运行结果

    if is_git_repo; then # 检测目录中是否有.git文件夹
        remote_url=$(git remote get-url origin)

        dialog_arg=$(dialog --erase-on-exit --notags \
            --title "Term-SD" \
            --backtitle "更新源选择界面" \
            --ok-label "确认" \
            --cancel-label "取消" \
            --menu "选择要修改成的更新源\n当前更新源: ${remote_url}" \
            $(get_dialog_size_menu) \
            "0" "> 返回" \
            "1" "> 官方源 (github.com)" \
            "2" "> 镜像源 1 (ghgo.xyz)" \
            "3" "> 镜像源 2 (mirror.ghproxy.com)" \
            "4" "> 镜像源 3 (gitclone.com)" \
            "5" "> 镜像源 4 (gh-proxy.com)" \
            "6" "> 镜像源 5 (ghps.cc)" \
            "7" "> 镜像源 6 (gh.idayer.com)" \
            "8" "> 镜像源 7 (ghproxy.net)" \
            "9" "> 镜像源 8 (gh.api.99988866.xyz)" \
            3>&1 1>&2 2>&3)

        case "${dialog_arg}" in
            1)
                git_repo_remote_revise https://github.com/term_sd_git_user/term_sd_git_repo
                ;;
            2)
                git_repo_remote_revise https://ghgo.xyz/https://github.com/term_sd_git_user/term_sd_git_repo
                ;;
            3)
                git_repo_remote_revise https://mirror.ghproxy.com/https://github.com/term_sd_git_user/term_sd_git_repo
                ;;
            4)
                git_repo_remote_revise https://gitclone.com/github.com/term_sd_git_user/term_sd_git_repo
                ;;
            5)
                git_repo_remote_revise https://gh-proxy.com/https://github.com/term_sd_git_user/term_sd_git_repo
                ;;
            6)
                git_repo_remote_revise https://ghps.cc/https://github.com/term_sd_git_user/term_sd_git_repo
                ;;
            7)
                git_repo_remote_revise https://gh.idayer.com/https://github.com/term_sd_git_user/term_sd_git_repo
                ;;
            8)
                git_repo_remote_revise https://ghproxy.net/https://github.com/term_sd_git_user/term_sd_git_repo
                ;;
            9)
                git_repo_remote_revise https://gh.api.99988866.xyz/https://github.com/term_sd_git_user/term_sd_git_repo
                ;;
            *)
                term_sd_echo "取消替换更新源操作"
                return 0
                ;;
        esac
        dialog --erase-on-exit \
            --title "Term-SD" \
            --backtitle "更新源替换结果" \
            --ok-label "确认" \
            --msgbox "当前更新源替换情况列表\n${TERM_SD_DELIMITER}\n$GIT_REPO_REMOTE_REVISE_MESSAGE${TERM_SD_DELIMITER}" \
            $(get_dialog_size)
        
        unset GIT_REPO_REMOTE_REVISE_MESSAGE
    else
        term_sd_echo "$(basename "$(pwd)") 非 Git 安装, 无法切换更新源"
        return 10
    fi
}

# SD WebUI 远程源替换
# 使用 GIT_REPO_REMOTE_REVISE_MESSAGE 全局变量显示替换更新源的结果
sd_webui_remote_revise() {
    local i
    if git_remote_url_select; then # 选择更新源
        term_sd_echo "开始替换 Stable-Diffusion-WebUI 更新源"
        # 执行替换功能
        # 主体部分
        ${GIT_REPO_REMOTE_REVISE_CMD}

        # 组件部分
        for i in "${SD_WEBUI_PATH}"/repositories/*; do
            if is_git_repo "${i}"; then
                cd "${i}"
                ${GIT_REPO_REMOTE_REVISE_CMD}
                cd - &> /dev/null
            fi
        done

        # 插件部分
        for i in "${SD_WEBUI_PATH}"/extensions/*; do
            if is_git_repo "${i}"; then
                cd "${i}"
                ${GIT_REPO_REMOTE_REVISE_CMD}
                cd - &> /dev/null
            fi
        done

        term_sd_echo "Stable-Duffusion-WebUI 更新源替换结束"
        term_sd_print_line

        dialog --erase-on-exit \
            --title "Term-SD" \
            --backtitle "Stable-Duffusion-WebUI 更新源替换结果" \
            --ok-label "确认" \
            --msgbox "当前更新源替换情况列表\n${TERM_SD_DELIMITER}\n$GIT_REPO_REMOTE_REVISE_MESSAGE${TERM_SD_DELIMITER}" \
            $(get_dialog_size)

        unset GIT_REPO_REMOTE_REVISE_MESSAGE
        unset GIT_REPO_REMOTE_REVISE_CMD
    fi
}

# ComfyUI 远程源替换功能
# 使用 GIT_REPO_REMOTE_REVISE_MESSAGE 全局变量显示替换更新源的结果
comfyui_remote_revise() {
    local i
    if git_remote_url_select; then # 选择更新源
        term_sd_echo "开始替换 ComfyUI 更新源"
        # 执行替换功能
        # 主体部分
        ${GIT_REPO_REMOTE_REVISE_CMD}

        # 插件
        for i in "$COMFYUI_PATH"/web/extensions/*; do
            if is_git_repo "${i}"; then
                cd "${i}"
                ${GIT_REPO_REMOTE_REVISE_CMD}
                cd - &> /dev/null
            fi
        done

        # 自定义节点
        for i in "$COMFYUI_PATH"/custom_nodes/*; do
            if is_git_repo "${i}"; then
                cd "${i}"
                ${GIT_REPO_REMOTE_REVISE_CMD}
                cd - &> /dev/null
            fi
        done

        term_sd_echo "ComfyUI 更新源替换结束"
        term_sd_print_line

        dialog --erase-on-exit \
            --title "Term-SD" \
            --backtitle "ComfyUI 更新源替换结果" \
            --ok-label "确认" \
            --msgbox "当前更新源替换情况列表\n${TERM_SD_DELIMITER}\n$GIT_REPO_REMOTE_REVISE_MESSAGE${TERM_SD_DELIMITER}" \
            $(get_dialog_size)

        unset GIT_REPO_REMOTE_REVISE_MESSAGE
        unset GIT_REPO_REMOTE_REVISE_CMD
    fi
}

# lora-scripts 远程源替换功能
# 使用 GIT_REPO_REMOTE_REVISE_MESSAGE 全局变量显示替换更新源的结果
lora_scripts_remote_revise() {
    if git_remote_url_select; then # 选择更新源
        term_sd_echo "开始替换 lora-scripts 更新源"
        ${GIT_REPO_REMOTE_REVISE_CMD}
        cd "$LORA_SCRIPTS_PATH"/frontend
        ${GIT_REPO_REMOTE_REVISE_CMD}
        cd "$LORA_SCRIPTS_PATH"/mikazuki/dataset-tag-editor
        ${GIT_REPO_REMOTE_REVISE_CMD}
        term_sd_echo "lora-scripts 更新源替换结束"
        term_sd_print_line

        dialog --erase-on-exit \
            --title "Term-SD" \
            --backtitle "lora-scripts 更新源替换结果" \
            --ok-label "确认" \
            --msgbox "当前更新源替换情况列表\n${TERM_SD_DELIMITER}\n$GIT_REPO_REMOTE_REVISE_MESSAGE${TERM_SD_DELIMITER}" \
            $(get_dialog_size)

        unset GIT_REPO_REMOTE_REVISE_MESSAGE
        unset GIT_REPO_REMOTE_REVISE_CMD
    fi
}

# Fooocus 切换更新源功能
# 使用 GIT_REPO_REMOTE_REVISE_MESSAGE 全局变量显示替换更新源的结果
fooocus_remote_revise() {
    if git_remote_url_select; then # 选择更新源
        term_sd_echo "开始替换 Fooocus 更新源"
        ${GIT_REPO_REMOTE_REVISE_CMD}
        term_sd_echo "Fooocus 更新源替换结束"
        term_sd_print_line

        dialog --erase-on-exit \
            --title "Term-SD" \
            --backtitle "Fooocus 更新源替换结果" \
            --ok-label "确认" \
            --msgbox "当前更新源替换情况列表\n${TERM_SD_DELIMITER}\n$GIT_REPO_REMOTE_REVISE_MESSAGE${TERM_SD_DELIMITER}" \
            $(get_dialog_size)

        unset GIT_REPO_REMOTE_REVISE_MESSAGE
        unset GIT_REPO_REMOTE_REVISE_CMD
    fi
}

# kohya_ss 切换更新源功能
# 使用 GIT_REPO_REMOTE_REVISE_MESSAGE 全局变量显示替换更新源的结果
kohya_ss_remote_revise() {
    if git_remote_url_select; then # 选择更新源
        term_sd_echo "开始替换 kohya_ss 更新源"
        ${GIT_REPO_REMOTE_REVISE_CMD}
        term_sd_echo "kohya_ss 更新源替换结束"
        term_sd_print_line

        dialog --erase-on-exit \
            --title "Term-SD" \
            --backtitle "kohya_ss 更新源替换结果" \
            --ok-label "确认" \
            --msgbox "当前更新源替换情况列表\n${TERM_SD_DELIMITER}\n$GIT_REPO_REMOTE_REVISE_MESSAGE${TERM_SD_DELIMITER}" \
            $(get_dialog_size)

        unset GIT_REPO_REMOTE_REVISE_MESSAGE
        unset GIT_REPO_REMOTE_REVISE_CMD
    fi
}
