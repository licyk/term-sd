#!/bin/bash

# git版本切换(加上--submod将同时切换子模块版本)
git_ver_switch()
{
    if [ -d "./.git" ];then # 检测目录中是否有.git文件夹
        local git_repository_commit
        term_sd_echo "获取$(git remote -v | awk 'NR==1 {print $2}' | awk -F "/" '{print $NF}' | awk '{sub(".git","")}1')版本信息"
        git_repository_commit=$(
            dialog --erase-on-exit --title "Term-SD" --backtitle "项目切换版本选项" --ok-label "确认" --cancel-label "取消" --menu "请选择要切换的版本\n当前版本:\n$(git show -s --format="%H %cd" --date=format:"%Y-%m-%d %H:%M:%S")" $term_sd_dialog_height $term_sd_dialog_width $term_sd_dialog_menu_height \
            "-->返回<--" "<-------------------" \
            $(git log --all --date=short --pretty=format:"%H %cd" --date=format:"%Y-%m-%d|%H:%M:%S" | awk -F  ' ' ' {print $1 " " $2} ') \
            3>&1 1>&2 2>&3)

        if [ $? = 0 ];then
            if [ ! $git_repository_commit = "-->返回<--" ];then
                term_sd_echo "切换$(git remote -v | awk 'NR==1 {print $2}' | awk -F "/" '{print $NF}' | awk '{sub(".git","")}1')版本中"
                case $1 in
                    --submod)
                        git reset --hard $git_repository_commit
                        git submodule init # 同时切换子模块的版本
                        git submodule update
                        ;;
                    *)
                        # 这里切换版本不使用git checkout,因为这样会导致分支签出,在git pull时会出现"当前不在一个分支上",需要重新git checkout回去
                        git reset --hard $git_repository_commit # 将整个工作区回退到指定commit
                        ;;
                esac
                term_sd_echo "版本切换完成,版本日期: $(git show -s --format="%ai" $git_repository_commit)"
            else
                term_sd_echo "取消版本切换操作"
            fi
        else
            term_sd_echo "取消版本切换操作"
        fi
    else
        term_sd_echo "$(git remote -v | awk 'NR==1 {print $2}' | awk -F "/" '{print $NF}' | awk '{sub(".git","")}1')非git安装,无法切换版本"
        return 10
    fi
}

# git分支签出恢复
git_fix_pointer_offset()
{
    # 当git在子文件夹中找不到.git文件夹时,将会自动在父文件夹中寻找,以此类推,直到找到.git文件夹。用户的安装方式可能是直接下载源码压缩包,导致安装后的文件夹没有.git文件夹,直接执行git会导致不良的后果
    if [ -d "./.git" ];then # 检测目录中是否有.git文件夹
        term_sd_echo "修复$(git remote -v | awk 'NR==1 {print $2}' | awk -F "/" '{print $NF}' | awk '{sub(".git","")}1')分支签出状态"
        git submodule init # 初始化git子模块
        git checkout $(git branch -a | grep /HEAD | awk -F'/' '{print $NF}') # 查询远程HEAD所指分支并切换过去
        git reset --recurse-submodules --hard HEAD # 回退版本,解决git pull异常
        git restore --recurse-submodules --source=HEAD :/ # 重置工作区
        term_sd_echo "修复$(git remote -v | awk 'NR==1 {print $2}' | awk -F "/" '{print $NF}' | awk '{sub(".git","")}1')完成"
    else
        term_sd_echo "$(git remote -v | awk 'NR==1 {print $2}' | awk -F "/" '{print $NF}' | awk '{sub(".git","")}1')非git安装,无法修复更新"
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
# 注: 路径的左右不能有"/"
git_clone_repository()
{
    local git_clone_repository_path
    local git_clone_repository_url

    case $1 in
        --submod)
            git_clone_repository_url=$(git_format_repository_url $2 $3) # 生成格式化后的链接
            if [ ! -z $4 ];then # 下载路径不为空
                if [ ! -z $5 ];then # 文件夹名称不为空
                    git_clone_repository_path="./${4}/${5}"
                else # 以项目的名称作为文件夹名称
                    git_clone_repository_path="./${4}/$(echo $git_clone_repository_url | awk -F'/' '{print $NF}')"
                fi
            else
                git_clone_repository_path="./$(echo $git_clone_repository_url | awk -F'/' '{print $NF}')"
            fi

            if [ ! -d "$git_clone_repository_path" ];then # 出现同名文件夹时终止执行
                term_sd_watch git clone --recurse-submodules $git_clone_repository_url $git_clone_repository_path
            fi
            ;;
        *)
            git_clone_repository_url=$(git_format_repository_url $1 $2) # 生成格式化后的链接
            if [ ! -z $3 ];then # 下载路径不为空
                if [ ! -z $4 ];then # 文件夹名称不为空
                    git_clone_repository_path="./${3}/${4}"
                else # 以项目的名称作为文件夹名称
                    git_clone_repository_path="./${3}/$(echo $git_clone_repository_url | awk -F'/' '{print $NF}')"
                fi
            else
                git_clone_repository_path="./$(echo $git_clone_repository_url | awk -F'/' '{print $NF}')"
            fi

            if [ ! -d "$git_clone_repository_path" ];then # 出现同名文件夹时终止执行
                term_sd_watch git clone --recurse-submodules $git_clone_repository_url $git_clone_repository_path
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

# git拉取更新(加上--submod将同时更新模块)
git_pull_repository()
{
    if [ -d "./.git" ];then # 检测目录中是否有.git文件夹
        case $1 in
            --submod)
                git submodule init # 初始化git子模块
                term_sd_watch git pull --recurse-submodules
                ;;
            *)
                term_sd_watch git pull
                ;;
        esac
    else
        term_sd_echo "$(git remote -v | awk 'NR==1 {print $2}' | awk -F "/" '{print $NF}' | awk '{sub(".git","")}1')非git安装,无法更新"
        return 10
    fi
}