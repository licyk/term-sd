#!/bin/bash

# 一键更新全部插件功能
# 该功能在 SD WebUI, ComfyUI 中共用的
# 使用 TERM_SD_MANAGE_OBJECT 全局变量显示要更新插件的 AI 软件
update_all_extension() {
    local extension_update_req
    local sum=0
    local count=0
    local success_count=0
    local fail_count=0
    local i

    term_sd_print_line "${TERM_SD_MANAGE_OBJECT} 插件一键更新"
    # 统计需要更新的数量
    for i in ./*; do
        if is_git_repo "${i}"; then
            sum=$(( sum + 1 ))
        fi
    done

    # 更新插件
    for i in ./*; do
        if is_git_repo "${i}"; then # 检测到目录中包含.git文件夹再执行更新操作
            count=$(( count + 1 ))
            term_sd_echo "[${count}/${sum}] 更新 $(basename "${i}") 插件中"
            extension_update_req="${extension_update_req}$(basename "${i}") 插件:"
            git_pull_repository "${i}" # 更新插件
        
            if [[ "$?" == 0 ]]; then
                extension_update_req="${extension_update_req} 更新成功 ✓\n"
                success_count=$(( success_count + 1 ))
            else
                extension_update_req="${extension_update_req} 更新失败 ×\n"
                fail_count=$(( fail_count + 1 ))
            fi
        fi
    done
    term_sd_print_line
    dialog --erase-on-exit \
        --title "Term-SD" \
        --backtitle "插件 / 自定义节点更新结果" \
        --ok-label "确认" \
        --msgbox "当前插件 / 自定义节点的更新情况列表\n[●: ${sum} | ✓: ${success_count} | ×: ${fail_count}]\n${TERM_SD_DELIMITER}\n${extension_update_req}${TERM_SD_DELIMITER}" \
        $(get_dialog_size)
}