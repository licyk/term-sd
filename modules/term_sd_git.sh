#!/bin/bash

# git版本切换
git_ver_switch()
{
    if is_git_repo ;then # 检测目录中是否有.git文件夹
        local git_repository_commit
        local origin_branch
        local ref
        term_sd_echo "获取 $(git remote -v | awk 'NR==1 {print $2}' | awk -F "/" '{print $NF}' | awk '{sub(".git","")}1') 版本信息"

        # 获取当前所在分支
        ref=$(git symbolic-ref --quiet HEAD 2> /dev/null)
        if [ $? = 0 ];then # 未出现分支游离
            origin_branch="origin/${ref#refs/heads/}"
        else # 出现分支游离时查询HEAD所指的分支
            origin_branch="origin/$(git branch -a | grep /HEAD | awk -F'/' '{print $NF}')"
        fi

        git_repository_commit=$(dialog --erase-on-exit \
            --title "Term-SD" \
            --backtitle "$(git remote -v | awk 'NR==1 {print $2}' | awk -F "/" '{print $NF}' | awk '{sub(".git","")}1') 切换版本选项" \
            --ok-label "确认" --cancel-label "取消" \
            --menu "请选择要切换的版本\n当前版本: $(git show -s --format="%h %cd" --date=format:"%Y-%m-%d %H:%M:%S")" \
            $term_sd_dialog_height $term_sd_dialog_width $term_sd_dialog_menu_height \
            "-->返回<--" "<-------------------" \
            $(git log $origin_branch --date=short --pretty=format:"%h %cd" --date=format:"%Y-%m-%d|%H:%M:%S" | awk -F  ' ' ' {print $1 " " $2} ') \
            3>&1 1>&2 2>&3)

        if [ $? = 0 ];then
            if [ ! $git_repository_commit = "-->返回<--" ];then
                term_sd_echo "切换 $(git remote -v | awk 'NR==1 {print $2}' | awk -F "/" '{print $NF}' | awk '{sub(".git","")}1') 版本中"
                git reset --recurse-submodules --hard $git_repository_commit
                term_sd_echo "版本切换完成,版本日期: $(git show -s --format="%ai" $git_repository_commit)"
            else
                term_sd_echo "取消版本切换操作"
            fi
        else
            term_sd_echo "取消版本切换操作"
        fi
    else
        term_sd_echo "$(basename "$(pwd)") 非 Git 安装, 无法切换版本"
        return 10
    fi
}

# git分支游离恢复
git_fix_pointer_offset()
{
    local repo_main_branch
    # 当git在子文件夹中找不到.git文件夹时,将会自动在父文件夹中寻找,以此类推,直到找到.git文件夹。用户的安装方式可能是直接下载源码压缩包,导致安装后的文件夹没有.git文件夹,直接执行git会导致不良的后果
    if is_git_repo ;then # 检测目录中是否有.git文件夹
        term_sd_echo "修复 $(git remote -v | awk 'NR==1 {print $2}' | awk -F "/" '{print $NF}' | awk '{sub(".git","")}1') 分支游离状态"
        git remote prune origin # 删除无用分支
        git submodule init # 初始化git子模块
        repo_main_branch=$(git branch -a | grep /HEAD | awk -F'/' '{print $NF}') # 查询远程HEAD所指分支
        git checkout $repo_main_branch # 切换到主分支
        git reset --recurse-submodules --hard origin/$repo_main_branch # 回退到远程分支的版本
        git reset --recurse-submodules --hard HEAD # 回退版本,解决git pull异常
        git restore --recurse-submodules --source=HEAD :/ # 重置工作区
        term_sd_echo "修复 $(git remote -v | awk 'NR==1 {print $2}' | awk -F "/" '{print $NF}' | awk '{sub(".git","")}1') 完成"
    else
        term_sd_echo "$(basename "$(pwd)") 非 Git 安装, 无法修复分支游离"
        return 10
    fi
}

# git获取项目信息(用户名,项目名称)
git_get_repository_url_info()
{
    git_repository_user=$(echo $@ | awk -F '/' '{print $(NF-1)}') # 从链接获取项目所属的用户名
    git_repository_name=$(echo $@ | awk -F '/' '{print $NF}') # 从链接获取项目的名称
}

# git格式化链接
# 格式链接: https://github.com/term_sd_git_user/term_sd_git_repo
# 使用格式: git_format_repository_url <链接格式> <原链接>
git_format_repository_url()
{
    local git_repository_url
    git_get_repository_url_info $2 # 获取项目用户名和项目名称(得到git_repository_user,git_repository_name)
    git_repository_url=$(echo $1 | awk '{sub("term_sd_git_user","'$git_repository_user'")}1' | awk '{sub("term_sd_git_repo","'$git_repository_name'")}1') # 生成格式化之后的链接
    echo $git_repository_url
}

# git克隆项目(使用格式化链接)
# 使用格式: 
# 仅克隆项目: git_clone_repository <链接格式> <原链接> <下载路径> <文件夹名称>
# 克隆项目和子模块: git_clone_repository --submod <链接格式> <原链接> <下载路径> <文件夹名称>
# 注: 路径的右边不能有"/"
git_clone_repository()
{
    local git_clone_repository_path
    local git_clone_repository_url

    case $1 in
        --submod)
            git_clone_repository_url=$(git_format_repository_url $2 $3) # 生成格式化后的链接
            if [ ! -z "$4" ];then # 下载路径不为空
                if [ ! -z "$5" ];then # 文件夹名称不为空
                    git_clone_repository_path="${4}/${5}"
                else # 以项目的名称作为文件夹名称
                    git_clone_repository_path="${4}/$(basename "$git_clone_repository_url")"
                fi
            else
                git_clone_repository_path="$(basename "$git_clone_repository_url")"
            fi

            if [ ! -d "$git_clone_repository_path" ];then
                term_sd_try git clone --recurse-submodules "$git_clone_repository_url" "$git_clone_repository_path"
            else # 出现同名文件夹时检测是否执行
                if term_sd_test_empty_dir "$git_clone_repository_path" ;then
                    term_sd_try git clone --recurse-submodules "$git_clone_repository_url" "$git_clone_repository_path"
                else
                    term_sd_echo "$(basename "$git_clone_repository_url") 已存在"
                fi
            fi
            ;;
        *)
            git_clone_repository_url=$(git_format_repository_url $1 $2) # 生成格式化后的链接
            if [ ! -z "$3" ];then # 下载路径不为空
                if [ ! -z "$4" ];then # 文件夹名称不为空
                    git_clone_repository_path="${3}/${4}"
                else # 以项目的名称作为文件夹名称
                    git_clone_repository_path="${3}/$(basename "$git_clone_repository_url")"
                fi
            else
                git_clone_repository_path="$(basename "$git_clone_repository_url")"
            fi

            if [ ! -d "$git_clone_repository_path" ];then
                term_sd_try git clone "$git_clone_repository_url" "$git_clone_repository_path"
            else # 出现同名文件夹时检测是否执行
                if term_sd_test_empty_dir "$git_clone_repository_path" ;then
                    term_sd_try git clone "$git_clone_repository_url" "$git_clone_repository_path"
                else
                    term_sd_echo "$(basename "$git_clone_repository_url") 已存在"
                fi
            fi
            ;;
    esac
}

# git远程源替换
# 使用格式: git_repository_remote_revise <链接格式>
git_repository_remote_revise()
{
    local git_repository_remote_url
    local git_repository_remote_modified_url

    git_repository_remote_url=$(git remote -v | awk 'NR==1 {print $2}') # 获取远程源链接
    git_repository_remote_modified_url=$(git_format_repository_url $1 $git_repository_remote_url) # 生成格式化后的链接

    if [ "$git_repository_remote_url" = "$git_repository_remote_modified_url" ];then # 当原链接和修改后的链接相同时不执行替换
        return 1
    else # 修改远程源
        git remote set-url origin $git_repository_remote_modified_url
        return 0
    fi
}

# git拉取更新
git_pull_repository()
{
    if is_git_repo ;then # 检测目录中是否有.git文件夹
        git_auto_fix_pointer_offset # 检测分支是否游离并修复
        git_get_latest_ver
    else
        term_sd_echo "$(basename "$(pwd)") 非 Git 安装, 无法更新"
        return 10
    fi
}

# git拉取更新内容并更新
git_get_latest_ver()
{
    local commit_hash
    local origin_branch
    local ref
    local use_submodules
    local local_commit_hash
    local req

    if is_git_repo ;then
        if [ ! -z "$(git submodule status)" ];then # 检测是否有子模块
            term_sd_echo "初始化 Git 子模块"
            use_submodules="--recurse-submodules"
            git submodule init # 初始化git子模块
        fi

        term_sd_echo "拉取 $(basename "$(pwd)") 远端更新内容"
        term_sd_try git fetch $use_submodules
        if [ $? = 0 ];then
            term_sd_echo "应用 $(basename "$(pwd)") 远端更新内容"
            ref=$(git symbolic-ref --quiet HEAD 2> /dev/null)
            origin_branch="origin/${ref#refs/heads/}"
            commit_hash=$(git log $origin_branch --max-count 1 --format="%h")
            local_commit_hash=$(git show -s --format="%h")
            git reset --hard $commit_hash $use_submodules
            req=$?
            if [ $commit_hash = $local_commit_hash ];then
                term_sd_echo "$(basename "$(pwd)") 已是最新"
            else
                term_sd_echo "$(basename "$(pwd)") 版本变动: $local_commit_hash -> $commit_hash"
            fi
            return $req
        else
            term_sd_echo "拉取 $(basename "$(pwd)") 远端更新内容失败"
            return 1
        fi
    fi
}

# 展示git分支
git_branch_display()
{
    local ref
    local req
    local git_commit_hash
    local git_pointer_status

    if is_git_repo ;then
        ref=$(git symbolic-ref --quiet HEAD 2> /dev/null)
        req=$?
        if [ $req = 0 ]; then
            git_commit_hash=$(git show -s --format="%h %cd" --date=format:"%Y-%m-%d %H:%M:%S")
        else
            ref=$(git rev-parse --short HEAD 2> /dev/null)
            git_commit_hash=$(git show -s --format="%cd" --date=format:"%Y-%m-%d %H:%M:%S")
            git_pointer_status="(分支游离)"
        fi
        echo ${ref#refs/heads/} ${git_pointer_status} ${git_commit_hash}
    else
        echo "非 Git 安装, 无分支"
    fi
}

# git远程源地址展示
git_remote_display()
{
    if is_git_repo ;then
        echo $(git remote -v 2> /dev/null | awk 'NR==1 {print $2}')
    else
        echo "非 Git 安装, 无更新源"
    fi
}

# 检测需要克隆的git仓库是否已存在本地,已存在返回0,否则返回1
term_sd_is_git_repository_exist()
{
    local i
    local folder_name=$(basename "$@" | awk -F '.git' '{print$1}')
    for i in ./* ;do # 检测本地同名的文件夹
        if [ "$(basename "$i")" = "$folder_name" ] && ! term_sd_test_empty_dir "$folder_name" ;then
            return 0
        fi
    done
    return 1
}

# git分支游离自动修复
git_auto_fix_pointer_offset()
{
    git symbolic-ref HEAD &> /dev/null
    if [ ! $? = 0 ];then
        term_sd_echo "检测到 $(basename "$(pwd)") 出现分支游离, 尝试修复中"
        git_fix_pointer_offset
    fi
}

# 检测是否为git仓库
is_git_repo()
{
    if [ -z "$*" ];then
        if [ -d ".git" ] && git rev-parse &> /dev/null ;then
            return 0
        else
            return 1
        fi
    else
        if [ -d "$@/.git" ] && git -C "$@" rev-parse &> /dev/null ;then
            return 0
        else
            return 1
        fi
    fi
}