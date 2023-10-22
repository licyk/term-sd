#!/bin/bash

#依赖更新功能(解决更新的同时更新pytorch)
function requirements_python_package_update()
{
    cat "$@" > tmp-python-package-update-list.txt #生成要更新的软件包名单
    ignore_update_python_package_list="torch torchvision torchaudio xformers InvokeAI" #忽略更新的软件包名单
    for i in $ignore_update_python_package_list; do
        sed -i '/'$i'/d' ./tmp-python-package-update-list.txt 2> /dev/null  #将忽略的软件包从名单删除
    done
    #更新依赖
    pip_cmd install -r ./tmp-python-package-update-list.txt --prefer-binary --upgrade $pip_index_mirror $pip_extra_index_mirror $pip_find_mirror $force_pip $pip_install_methon_select --default-timeout=100 --retries 5
    rm -rf ./tmp-python-package-update-list.txt #删除列表缓存
}