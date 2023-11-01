#!/bin/bash

#项目更新失败修复功能
function term_sd_fix_pointer_offset()
{
    term_sd_notice "修复$(git remote -v | awk 'NR==1 {print $2}' | awk -F "/" '{print $NF}' | awk '{sub(".git","")}1')更新中"
    git checkout $(git branch -a | grep /HEAD | awk -F'/' '{print $NF}') #查询当前主分支并重新切换过去
    git reset --recurse-submodules --hard HEAD #回退版本,解决git pull异常
    git restore --recurse-submodules --source=HEAD :/
    term_sd_notice "修复$(git remote -v | awk 'NR==1 {print $2}' | awk -F "/" '{print $NF}' | awk '{sub(".git","")}1')完成"
}
