#!/bin/bash

#处理python命令
function python_cmd()
{
            python $@
}

#处理pip命令
function pip_cmd()
{
    #检测是否在虚拟环境中
    
        #调用虚拟环境的pip
        pip $@
}