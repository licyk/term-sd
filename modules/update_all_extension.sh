#!/bin/bash

#该功能在a1111-sd-webui,comfyui中共用的
#一键更新全部插件功能
function extension_all_update()
{
    echo "更新插件中"
    extension_folder="" #清除上次运行结果
    update_info=""
    for extension_folder in ./*
    do
        [ -f "$extension_folder" ] && continue #排除文件
        cd "$extension_folder"
        if [ -d "./.git" ];then #检测到目录中包含.git文件夹再执行更新操作
            echo "更新"$extension_folder"插件中"
            update_info="$update_info"$extension_folder"插件:"
            git pull
        
            if [ $? = 0 ];then
                update_info="$update_info"更新成功"\n"
            else
                update_info="$update_info"更新失败"\n"
            fi
        fi
        cd ..
    done
    dialog --clear --title "Term-SD" --backtitle "插件/自定义节点更新结果" --msgbox "当前插件/自定义节点的更新情况列表\n--------------------------------------------------------$update_info\n--------------------------------------------------------" 20 60
}