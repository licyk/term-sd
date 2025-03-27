#!/bin/bash

# Git 版本切换
# 使用:
# git_ver_switch <仓库路径>
git_ver_switch() {
    local dialog_arg
    local origin_branch
    local ref
    local path
    local name
    local current_commit_hash

    if [[ -z "$@" ]]; then
        path=$(pwd)
    else
        path=$@
    fi

    if is_git_repo "${path}"; then # 检测目录中是否有.git文件夹
        name=$(git -C "${path}" remote get-url origin | awk -F '/' '{print $NF}')
        name=${name%.git}
        term_sd_echo "获取 ${name} 版本信息"
        current_commit_hash=$(git -C "${path}" show -s --format="%h %cd" --date=format:"%Y-%m-%d %H:%M:%S")

        # 获取当前所在分支
        ref=$(git -C "${path}" symbolic-ref --quiet HEAD 2> /dev/null)
        if [[ "$?" == 0 ]]; then # 未出现分支游离
            origin_branch="origin/${ref#refs/heads/}"
        else # 出现分支游离时查询HEAD所指的分支
            origin_branch="origin/$(git -C "${path}" branch -a | grep "/HEAD" | awk -F '/' '{print $NF}')"
        fi

        dialog_arg=$(dialog --erase-on-exit \
            --title "Term-SD" \
            --backtitle "${name} 切换版本选项" \
            --ok-label "确认" --cancel-label "取消" \
            --menu "请选择要切换的版本\n当前版本: ${current_commit_hash}" \
            $(get_dialog_size_menu) \
            "-->返回<--" "<-------------------" \
            $(git -C "${path}" log "${origin_branch}" --date=short --pretty=format:"%h %cd" --date=format:"%Y-%m-%d|%H:%M:%S") \
            3>&1 1>&2 2>&3)

        if [[ "$?" == 0 ]]; then
            if [ ! "${dialog_arg}" == "-->返回<--" ]; then
                term_sd_echo "切换 ${name} 版本中"
                git -C "${path}" reset --recurse-submodules --hard "${dialog_arg}"
                term_sd_echo "版本切换完成, ${name} 版本日期: $(git -C "${path}" show -s --format="%ai" ${dialog_arg})"
                return 0
            else
                term_sd_echo "取消 ${name} 版本切换操作"
                return 1
            fi
        else
            term_sd_echo "取消 ${name} 版本切换操作"
            return 1
        fi
    else
        term_sd_echo "$(basename "$(pwd)") 非 Git 安装, 无法切换版本"
        return 10
    fi
}

# Git 分支游离恢复
# git_fix_pointer_offset <仓库路径>
git_fix_pointer_offset() {
    local repo_main_branch
    local path

    if [[ -z "$@" ]]; then
        path=$(pwd)
    else
        path=$@
    fi

    # 当git在子文件夹中找不到.git文件夹时,将会自动在父文件夹中寻找,以此类推,直到找到.git文件夹。用户的安装方式可能是直接下载源码压缩包,导致安装后的文件夹没有.git文件夹,直接执行git会导致不良的后果
    if is_git_repo "${path}"; then # 检测目录中是否有.git文件夹
        name=$(git -C "${path}" remote get-url origin | awk -F '/' '{print $NF}')
        name=${name%.git}
        term_sd_echo "修复 ${name} 分支游离状态"
        git -C "${path}" remote prune origin # 删除无用分支
        git -C "${path}" submodule init # 初始化 Git 子模块
        repo_main_branch=$(git -C "${path}" branch -a | grep "/HEAD" | awk -F '/' '{print $NF}') # 查询 HEAD 所指分支
        git -C "${path}" checkout ${repo_main_branch} # 切换到主分支
        git -C "${path}" reset --recurse-submodules --hard origin/${repo_main_branch} # 回退到远程分支的版本
        term_sd_echo "修复 ${name} 完成"
    else
        term_sd_echo "$(basename "$(pwd)") 非 Git 安装, 无法修复分支游离"
        return 10
    fi
}

# Git 获取项目信息(用户名, 项目名称)
# 使用 GIT_REPO_USER, GIT_REPO_NAME 全局变量保存仓库的信息
git_get_repository_url_info() {
    GIT_REPO_USER=$(echo $@ | awk -F '/' '{print $(NF-1)}') # 从链接获取项目所属的用户名
    GIT_REPO_NAME=$(echo $@ | awk -F '/' '{print $NF}') # 从链接获取项目的名称
}

# Git 格式化链接
# 格式链接: https://github.com/term_sd_git_user/term_sd_git_repo
# 使用格式: git_format_repository_url <链接格式> <原链接>
# 使用 git_get_repository_url_info 函数返回的 GIT_REPO_USER, GIT_REPO_NAME 全局变量获取仓库的用户名和仓库名
git_format_repository_url() {
    local url_format=$1
    local url=$2
    git_get_repository_url_info "${url}" # 获取项目用户名和项目名称(得到 GIT_REPO_USER, GIT_REPO_NAME)
    url=$(echo ${url_format} | awk '{sub("term_sd_git_user","'$GIT_REPO_USER'") ; sub("term_sd_git_repo","'$GIT_REPO_NAME'")}1') # 生成格式化之后的链接
    unset GIT_REPO_USER
    unset GIT_REPO_NAME
    echo "${url}"
}

# Git 克隆项目(使用格式化链接)
# 使用格式: 
# git_clone_repository <--disable-submod> <原链接> <下载路径> <文件夹名称>
git_clone_repository() {
    local url # 链接
    local path # 下载路径
    local name # 要保存的名称
    local repo_path
    local use_submodules

    if [[ "$1" == "--disable-submod" ]]; then
        url=$2
        path=$3
        name=$4
    else
        use_submodules="--recurse-submodules"
        url=$1
        path=$2
        name=$3
    fi

    if [[ -z "${path}" ]]; then # 下载路径为空时
        path=$(pwd)
        name=$(basename "${url}")
        repo_path="${path}/${name}"
    elif [[ -z "${name}" ]]; then # 要保存的名称为空时
        # 去除下载路径中末尾的 / 字符
        path=$(awk '{ if (substr($0, length($0), 1) == "/") { print substr($0, 1, length($0) - 1) } else { print $0 } }' <<< ${path})
        name=$(basename "${url}")
        repo_path="${path}/${name}"
    else
        # 去除下载路径中末尾的 / 字符
        path=$(awk '{ if (substr($0, length($0), 1) == "/") { print substr($0, 1, length($0) - 1) } else { print $0 } }' <<< ${path})
        repo_path="${path}/${name}"
    fi

    url=$(git_format_repository_url "${GITHUB_MIRROR}" "${url}")

    if term_sd_is_debug; then
        term_sd_echo "下载信息:"
        term_sd_echo "url: ${url}"
        term_sd_echo "path: ${path}"
        term_sd_echo "name: ${name}"
        term_sd_echo "repo_path: ${repo_path}"
        term_sd_echo "GITHUB_MIRROR: ${GITHUB_MIRROR}"
        term_sd_echo "use_submodules: ${use_submodules}"
        term_sd_echo "cmd: git clone ${use_submodules} ${url} ${repo_path}"
    fi

    if [[ ! -d "${repo_path}" ]] || term_sd_is_dir_empty "${repo_path}"; then
        term_sd_echo "开始下载 ${name}, 路径: ${repo_path}"
        term_sd_try git clone ${use_submodules} "${url}" "${repo_path}"
        if [[ "$?" == 0 ]]; then
            term_sd_echo "${name} 下载成功"
        else
            term_sd_echo "${name} 下载失败"
            return 1
        fi
    else
        term_sd_echo "${name} 已存在, 路径: ${repo_path}"
    fi
}


# Git 远程源替换
# 使用格式: git_repository_remote_revise <链接格式>
git_repository_remote_revise() {
    local repo_url
    local repo_modify_url
    local url_format=$@
    local GIT_CONFIG_GLOBAL= # 临时取消 Git 配置, 防止影响远程源的判断

    repo_url=$(git remote get-url origin) # 获取远程源链接
    repo_modify_url=$(git_format_repository_url "${url_format}" "${repo_url}") # 生成格式化后的链接

    if [[ "${repo_url}" == "${repo_modify_url}" ]]; then # 当原链接和修改后的链接相同时不执行替换
        return 1
    else # 修改远程源
        if term_sd_is_debug; then
            term_sd_echo "cmd: git remote set-url origin ${repo_modify_url}"
        fi
        git remote set-url origin "${repo_modify_url}"
        return 0
    fi
}

# Git 拉取更新
# 当检测到出现分支游离时将自动修复
# 使用:
# git_pull_repository <仓库路径>
git_pull_repository() {
    local path

    if [[ -z "$@" ]]; then
        path=$(pwd)
    else
        path=$@
    fi

    if is_git_repo "${path}"; then
        git_auto_fix_pointer_offset "${path}" # 检测分支是否游离并修复
        git_get_latest_ver "${path}"
    else
        term_sd_echo "$(basename "${path}") 非 Git 安装, 无法更新"
        return 10
    fi
}

# Git 拉取更新内容并应用
# 使用:
# git_get_latest_ver <仓库路径>
git_get_latest_ver() {
    local commit_hash
    local origin_branch
    local ref
    local use_submodules
    local local_commit_hash
    local req
    local path
    local name
    local author="origin"

    if [[ -z "$@" ]]; then
        path=$(pwd)
    else
        path=$@
    fi

    name=$(git -C "${path}" remote get-url origin | awk -F '/' '{print $NF}')

    if is_git_repo "${path}"; then
        if [[ ! -z "$(git -C "${path}" submodule status)" ]]; then # 检测是否有子模块
            term_sd_echo "初始化 Git 子模块"
            use_submodules="--recurse-submodules"
            git -C "${path}" submodule init # 初始化 Git 子模块
        fi

        term_sd_echo "拉取 ${name} 远端更新内容"
        term_sd_try git -C "${path}" fetch ${use_submodules} --all
        if [[ "$?" == 0 ]]; then
            term_sd_echo "应用 ${name} 远端更新内容"
            ref=$(git -C "${path}" symbolic-ref --quiet HEAD 2> /dev/null)
            if git_is_repo_on_origin_branch "${path}"; then
                origin_branch="${author}/${ref#refs/heads/}"
            else
                origin_branch="${ref#refs/heads/}"
                # 获取分支对应的远程源名称
                author=$(git -C "${path}" config --get "branch.${origin_branch}.remote" 2> /dev/null)
                if [[ -z "${author}" ]]; then
                    author="null"
                else
                    origin_branch="${author}/${origin_branch}"
                fi
            fi
            commit_hash=$(git -C "${path}" log "${origin_branch}" --max-count 1 --format="%h")
            local_commit_hash=$(git -C "${path}" show -s --format="%h")
            if term_sd_is_debug; then
                term_sd_echo "ref: ${ref}"
                term_sd_echo "author: ${author}"
                term_sd_echo "commit_hash: ${commit_hash}"
                term_sd_echo "local_commit_hash: ${local_commit_hash}"
                term_sd_echo "origin_branch: ${origin_branch}"
            fi
            git -C "${path}" reset ${use_submodules} --hard "${origin_branch}"
            req=$?
            if [[ "${commit_hash}" == "${local_commit_hash}" ]]; then
                term_sd_echo "${name} 已是最新"
            else
                term_sd_echo "${name} 版本变动: ${local_commit_hash} -> ${commit_hash}"
            fi
            return ${req}
        else
            term_sd_echo "拉取 ${name} 远端更新内容失败"
            return 1
        fi
    fi
}

# 展示 Git 分支
# 使用:
# git_branch_display <仓库路径>
# 执行后返回仓库所在分支, Hash 值, 分支游离状态
git_branch_display() {
    local ref
    local git_commit_hash
    local git_pointer_status
    local path

    if [[ -z "$@" ]]; then
        path=$(pwd)
    else
        path=$@
    fi

    if is_git_repo "${path}"; then
        ref=$(git -C "${path}" symbolic-ref --quiet HEAD 2> /dev/null)
        if [[ "$?" == 0 ]]; then
            git_commit_hash=$(git -C "${path}" show -s --format="%h %cd" --date=format:"%Y-%m-%d %H:%M:%S")
        else
            ref=$(git -C "${path}" rev-parse --short HEAD 2> /dev/null)
            git_commit_hash=$(git -C "${path}" show -s --format="%cd" --date=format:"%Y-%m-%d %H:%M:%S")
            git_pointer_status="(分支游离)"
        fi
        echo ${ref#refs/heads/} ${git_pointer_status} ${git_commit_hash}
    else
        echo "非 Git 安装, 无分支"
    fi
}

# Git 远程源地址展示
# 使用:
# git_remote_display <仓库路径>
git_remote_display() {
    local path

    if [[ -z "$@" ]]; then
        path=$(pwd)
    else
        path=$@
    fi

    if is_git_repo "${path}"; then
        echo "$(git -C "${path}" remote get-url origin)"
    else
        echo "非 Git 安装, 无更新源"
    fi
}

# 检测需要克隆的仓库是否已存在本地, 已存在返回 0, 否则返回 1
term_sd_is_git_repository_exist() {
    local i
    local folder_name=$(basename "$@")
    folder_name=${folder_name%.git}

    if term_sd_is_debug; then
        term_sd_echo "待检测是否存在的仓库: ${folder_name}"
        for i in ./*; do
            term_sd_echo "当前路径存在仓库: ${i}"
        done
    fi

    for i in ./*; do # 检测本地同名的文件夹
        if [[ "$(basename "${i}")" == "${folder_name}" ]] && ! term_sd_is_dir_empty "${folder_name}"; then
            return 0
        fi
    done
    return 1
}

# Git 分支游离自动修复
git_auto_fix_pointer_offset() {
    local path
    local name

    if [[ -z "$@" ]]; then
        path=$(pwd)
    else
        path=$@
    fi

    name=$(git -C "${path}" remote get-url origin | awk -F '/' '{print $NF}')

    if ! git -C "${path}" symbolic-ref HEAD &> /dev/null; then
        term_sd_echo "检测到 ${name} 出现分支游离, 尝试修复中"
        git_fix_pointer_offset "${path}"
    fi
}

# 检测是否为 Git 仓库
is_git_repo() {
    if [[ -z "$@" ]]; then
        if [[ -d ".git" ]] && git rev-parse &> /dev/null; then
            return 0
        else
            return 1
        fi
    else
        if [[ -d "$@/.git" ]] && git -C "$@" rev-parse &> /dev/null; then
            return 0
        else
            return 1
        fi
    fi
}

# Git 切换仓库分支
# 使用:
# git_switch_branch <切换成的的远程源> <要切换的分支> <--submod>
git_switch_branch() {
    local name
    local preview_url
    local remote_url=$1
    local branch=$2
    local use_submodules=$3

    preview_url=$(GIT_CONFIG_GLOBAL="" git remote get-url origin)
    name=$(awk -F '/' '{print $NF}' <<< ${preview_url})

    if [[ "$3" == "--submod" ]]; then
        use_submod=1
        use_submodules="--recurse-submodules"
    else
        use_submod=0
        unset use_submodules
    fi

    if term_sd_is_debug; then
        term_sd_echo "branch: ${branch}"
        term_sd_echo "remote_url: ${remote_url}"
        term_sd_echo "use_submodules: ${use_submodules}"
    fi

    term_sd_echo "${name} 远程源替换: ${preview_url} -> ${remote_url}"
    git remote set-url origin "${remote_url}" # 替换远程源

    # 处理 Git 子模块
    if [[ "${use_submod}" == 1 ]]; then
        term_sd_echo "更新 ${name} 的 Git 子模块信息"
        git submodule update --init --recursive
    else
        term_sd_echo "禁用 ${name} 的 Git 子模块"
        git submodule deinit --all -f
    fi

    term_sd_echo "拉取远程源更新"
    term_sd_try git fetch # 拉取远程源内容
    if [[ "$?" == 0 ]]; then
        if [[ "${use_submod}" == 1 ]]; then
            git submodule deinit --all -f
        fi
        term_sd_echo "切换分支至 ${branch}"
        git checkout "${branch}" --force # 切换分支
        term_sd_echo "应用远程源的更新"
        if [[ "${use_submod}" == 1 ]]; then
            term_sd_echo "更新 ${name} 的 Git 子模块信息"
            git reset --hard "origin/${branch}"
            git submodule deinit --all -f
            term_sd_try git submodule update --init --recursive
        fi
        git reset ${use_submodules} --hard "origin/${branch}" # 切换到最新的提交内容上
        if term_sd_is_debug; then
            term_sd_echo "cmd: git fetch ${use_submodules}"
            term_sd_echo "cmd: git checkout ${branch} --force"
            term_sd_echo "cmd: git reset ${use_submodules} --hard origin/${branch}"
        fi
    else
        term_sd_echo "拉取 ${name} 远程源更新失败, 取消分支切换"
        term_sd_echo "尝试回退 ${name} 的更改"
        git remote set-url origin "${preview_url}"
        if [[ "${use_submod}" == 1 ]]; then
            git submodule deinit --all -f
        else
            git submodule update --init --recursive
        fi
        term_sd_echo "回退更改完成"
        return 1
    fi
}

# 移动 Git 子模块的配置文件到主仓库
git_init_submodule() {
    local path
    local name

    if [[ -z "$@" ]]; then
        path=$(pwd)
    else
        path=$@
    fi

    name=$(git -C "${path}" remote get-url origin | awk -F '/' '{print $NF}')

    term_sd_echo "初始化 ${name} 的 Git 子模块"
    git -C "${path}" submodule init
    term_sd_try git -C "${path}" submodule update
    term_sd_try git -C "${path}" reset --hard --recurse-submodules
}

# 检查分支是否在 origin 上
git_is_repo_on_origin_branch() {
    git -C "$@" show-ref --verify --quiet "refs/remotes/origin/$(git -C "$@" branch --show-current)"
}
