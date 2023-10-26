#!/bin/bash

#该功能在a1111-sd-webui,comfyui中共用的
#一键更新全部插件功能
function extension_all_update()
{
    print_line_to_shell "$term_sd_manager_info 插件一键更新"
    term_sd_notice "更新插件中"
    #清除上次运行结果
    update_info=""
    extension_to_update="0"
    extension_to_update_="0"

    #统计需要更新的数量
    for i in ./* ;do
        [ -f "$i" ] && continue #排除文件
        [ ! -d "./$i/.git" ] && continue #排除没有.git文件夹的目录
        extension_to_update=$(( $extension_to_update + 1 ))
    done

    #更新插件
    for i in ./* ;do
        [ -f "$i" ] && continue #排除文件
        if [ -d "./$i/.git" ];then #检测到目录中包含.git文件夹再执行更新操作
            cd "$i"
            extension_to_update_=$(( $extension_to_update_ + 1 ))
            term_sd_notice "[$extension_to_update_/$extension_to_update] 更新$(echo $i | awk -F "/" '{print $NF}')插件中"
            update_info="$update_info$(echo $i | awk -F "/" '{print $NF}')插件:"
            git pull --recurse-submodules
        
            if [ $? = 0 ];then
                update_info="$update_info"更新成功"\n"
            else
                update_info="$update_info"更新失败"\n"
            fi
            cd ..
        fi
    done
    print_line_to_shell
    dialog --clear --title "Term-SD" --backtitle "插件/自定义节点更新结果" --ok-label "确认" --msgbox "当前插件/自定义节点的更新情况列表\n------------------------------------------------------------------\n$update_info------------------------------------------------------------------" 25 80
}