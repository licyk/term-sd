#!/bin/bash

# 该功能在a1111-sd-webui,comfyui中共用的
# 一键更新全部插件功能
update_all_extension()
{
    local extension_update_req
    local extension_update_sum=0
    local extension_update_count=0

    term_sd_print_line "${term_sd_manager_info}插件一键更新"
    # 统计需要更新的数量
    for i in * ;do
        [ -f "$i" ] && continue # 排除文件
        [ ! -d "$i/.git" ] && continue # 排除没有.git文件夹的目录
        extension_update_sum=$(( $extension_update_sum + 1 ))
    done

    # 更新插件
    for i in * ;do
        [ -f "$i" ] && continue # 排除文件
        if [ -d "$i/.git" ];then # 检测到目录中包含.git文件夹再执行更新操作
            cd "$i"
            extension_update_count=$(( $extension_update_count + 1 ))
            term_sd_echo "[$extension_update_count/$extension_update_sum] 更新$(echo $i | awk -F "/" '{print $NF}')插件中"
            extension_update_req="$extension_update_req$(echo $i | awk -F "/" '{print $NF}')插件:"
            git_pull_repository # 更新插件
        
            if [ $? = 0 ];then
                extension_update_req="${extension_update_req}更新成功\n"
            else
                extension_update_req="${extension_update_req}更新失败\n"
            fi
            cd ..
        fi
    done
    term_sd_print_line
    dialog --erase-on-exit --title "Term-SD" --backtitle "插件/自定义节点更新结果" --ok-label "确认" --msgbox "当前插件/自定义节点的更新情况列表\n${term_sd_delimiter}\n$extension_update_req${term_sd_delimiter}" $term_sd_dialog_height $term_sd_dialog_width
}