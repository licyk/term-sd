#!/bin/bash

#处理用户输入的参数
function term_sd_process_user_input()
{
    for term_sd_launch_input in $(echo "$1 $2 $3 $4 $5 $6 $7 $8 $9") ;do
        case $term_sd_launch_input in
        "--help")
        echo
        echo "启动参数使用方法:"
        echo "  term-sd.sh [--help] [--extra] [--multi-threaded-download] [--enable-auto-update] [--disable-auto-update] [--reinstall-term-sd] [--remove-term-sd] [--test-proxy] [--quick-cmd]"
        echo "选项:"
        echo "  --help"
        echo "        显示启动参数帮助"
        echo "  --extra"
        echo "        启动扩展脚本"
        echo "  --multi-threaded-download"
        echo "        安装过程中启用多线程下载模型"
        echo "  --enable-auto-update"
        echo "        启用Term-SD自动检查更新功能"
        echo "  --disable-auto-update"
        echo "        禁用Term-SD自动检查更新功能"
        echo "  --reinstall-term-sd"
        echo "        重新安装Term-SD"
        echo "  --remove-term-sd"
        echo "        卸载Term-SD"
        echo "  --test-proxy"
        echo "        测试网络环境,用于测试代理是否可用"
        echo "  --quick-cmd"
        echo "        添加Term-SD快捷启动命令到shell"
        print_line_to_shell
        exit 1
        ;;
        "--remove-term-sd")
        remove_term_sd
        ;;
        "--quick-cmd")
        install_cmd_to_shell
        exit 1
        ;;
        "--multi-threaded-download")
        echo "安装过程中启用多线程下载模型"
        export aria2_multi_threaded="-x 8"
        ;;
        "--enable-auto-update")
        echo "启用Term-SD自动检查更新功能"
        touch ./term-sd/term-sd-auto-update.lock
        ;;
        "--disable-auto-update")
        echo "禁用Term-SD自动检查更新功能"
        rm -rf ./term-sd/term-sd-auto-update.lock
        rm -rf ./term-sd/term-sd-auto-update-time.conf
        ;;
        "--test-proxy")
        if which curl > /dev/null;then
            print_word_to_shell="测试网络环境"
            print_line_to_shell
            curl ipinfo.io ; echo
            print_line_to_shell
            sleep 1
        else
            echo "未安装curl,无法测试代理"
        fi
        ;;
        "--extra")
        term_sd_extra_scripts
        ;;
        esac
    done
    source ./term-sd/modules/init.sh
}

#扩展脚本列表
function term_sd_extra_scripts()
{
    extra_script_dir_list=$(ls -l "./term-sd/extra" --time-style=+"%Y-%m-%d" | awk -F ' ' ' { print $7 " " $6 } ')
    extra_script_dir_list_=$(dialog --clear --title "Term-SD" --backtitle "扩展脚本选项" --ok-label "确认" --cancel-label "取消" --menu "请选择要启动的脚本" 22 70 12 \
        "term-sd" "<------------" \
        $extra_script_dir_list \
        "退出" "<------------" \
        3>&1 1>&2 2>&3)

    if [ $? = 0 ];then
        if [ $extra_script_dir_list_ = "term-sd" ];then
            source ./term-sd/modules/init.sh
            exit 1
        elif [ $extra_script_dir_list_ = "退出" ];then
            exit 1
        fi
    else
        exit 1
    fi

    source ./term-sd/extra/$extra_script_dir_list_
    exit 1
}

#自动更新触发功能
function term_sd_auto_update_trigger()
{
    if [ -f "./term-sd/term-sd-auto-update.lock" ];then #找到自动更新配置
        if [ -d "./term-sd/.git" ];then #检测到有.git文件夹
            if [ -f "./term-sd/term-sd-auto-update-time.conf" ];then #有上次运行记录
                term_sd_start_time=`date +'%Y-%m-%d %H:%M:%S'` #查看当前时间
                term_sd_end_time=$(cat ./term-sd/term-sd-auto-update-time.conf) #获取上次更新时间
                term_sd_start_time_seconds=$(date --date="$term_sd_start_time" +%s) #转换时间单位
                term_sd_end_time_seconds=$(date --date="$term_sd_end_time" +%s)
                term_sd_auto_update_time_span=$(( $term_sd_start_time_seconds - $term_sd_end_time_seconds )) #计算相隔时间
                term_sd_auto_update_time_set=3600 #检查更新时间间隔
                if [ $term_sd_auto_update_time_span -ge $term_sd_auto_update_time_set ];then #判断时间间隔
                    term_sd_auto_update
                    date +'%Y-%m-%d %H:%M:%S' > term-sd-auto-update-time.conf #记录自动更新功能的启动时间
                    mv -f ./term-sd-auto-update-time.conf ./term-sd
                fi
            else #没有时直接执行
                term_sd_auto_update
                date +'%Y-%m-%d %H:%M:%S' > term-sd-auto-update-time.conf #记录自动更新功能的启动时间
                mv -f ./term-sd-auto-update-time.conf ./term-sd
            fi
        fi    
    fi
}

#term-sd自动更新功能
function term_sd_auto_update()
{
    echo "检查更新中"
    term_sd_local_branch=$(git --git-dir="./term-sd/.git" branch | grep \* | awk -F "* " '{print $NF}') #term-sd分支
    term_sd_local_hash=$(git --git-dir="./term-sd/.git" rev-parse HEAD) #term-sd本地hash
    term_sd_remote_hash=$(git --git-dir="./term-sd/.git" ls-remote origin refs/remotes/origin/$term_sd_local_branch $term_sd_local_branch | awk '{print $1}') #term-sd远程hash
    if git --git-dir="./term-sd/.git" ls-remote origin refs/remotes/origin/$term_sd_local_branch $term_sd_local_branch 2> /dev/null 1> /dev/null ;then #网络连接正常时再进行更新
        if [ ! $term_sd_local_hash = $term_sd_remote_hash ];then
            term_sd_auto_update_option=""
            echo "检测到term-sd有新版本"
            echo "是否选择更新(yes/no)?"
            echo "提示:输入yes或no后回车"
            read -p "==>" term_sd_auto_update_option
            if [ ! -z $term_sd_auto_update_option ];then
                if [ $term_sd_auto_update_option = yes ] || [ $term_sd_auto_update_option = y ] || [ $term_sd_auto_update_option = YES ] || [ $term_sd_auto_update_option = Y ];then
                    cd ./term-sd
                    git_pull_info=""
                    git pull
                    git_pull_info=$?
                    cd ..
                    if [ $git_pull_info = 0 ];then
                        cp -f ./term-sd/term-sd.sh .
                        chmod +x ./term-sd.sh
                        echo "更新成功"
                    else
                        term_sd_update_fix
                    fi
                fi
            fi
        else
            echo "已经是最新版本"
        fi
    else
        echo "连接更新源失败,跳过更新"
        echo "提示:请检查网络连接是否正常,若网络正常,可尝试更换更新源或使用科学上网解决"
    fi
}

#修复更新功能
#修复后term-sd会切换到主分支
function term_sd_update_fix()
{
    term_sd_auto_update_option=""
    echo "是否修复更新(yes/no)?"
    echo "提示:输入yes或no后回车"
    read -p "==>" term_sd_auto_update_option
    if [ ! -z $term_sd_auto_update_option ];then
        if [ $term_sd_auto_update_option = yes ] || [ $term_sd_auto_update_option = y ] || [ $term_sd_auto_update_option = YES ] || [ $term_sd_auto_update_option = Y ];then
            cd ./term-sd
            term_sd_local_main_branch=$(git branch -a | grep HEAD | awk -F'/' '{print $NF}') #term-sd主分支
            git checkout $term_sd_local_main_branch
            git reset --hard HEAD
            git_pull_info=""
            git pull
            git_pull_info=$?
            cd ..
            if [ $git_pull_info = 0 ];then
                cp -f ./term-sd/term-sd.sh .
                chmod +x ./term-sd.sh
                echo "更新成功"
            else
                echo "如果出错的可能是网络原因导致无法连接到更新源,可通过更换更新源或使用科学上网解决"
            fi
        fi
    fi
}

#term-sd安装功能
function term_sd_install()
{
    term_sd_install_option=""
    if [ ! -d "./term-sd" ];then
        echo "检测到term-sd未安装,是否进行安装(yes/no)?"
        echo "提示:输入yes或no后回车"
        read -p "==>" term_sd_install_option
        if [ ! -z $term_sd_install_option ];then
            if [ $term_sd_install_option = yes ] || [ $term_sd_install_option = y ] || [ $term_sd_install_option = YES ] || [ $term_sd_install_option = Y ];then
                term_sd_install_mirror_select
                git clone $term_sd_install_mirror
                if [ $? = 0 ];then
                    cp -f ./term-sd/term-sd.sh .
                    chmod +x ./term-sd.sh
                    echo "安装成功"
                else
                    echo "安装失败"
                    exit 1
                fi
            else
                exit 1
            fi
        else
            exit 1
        fi
    elif [ ! -d "./term-sd/.git" ];then
        echo "检测到term-sd的.git目录不存在,将会导致Term-SD无法更新,是否重新安装(yes/no)?"
        echo "提示:输入yes或no后回车"
        read -p "==>" term_sd_install_option
        if [ ! -z $term_sd_install_option ];then
            if [ $term_sd_install_option = yes ] || [ $term_sd_install_option = y ] || [ $term_sd_install_option = YES ] || [ $term_sd_install_option = Y ];then
                term_sd_install_mirror_select
                echo "清除term-sd文件"
                rm -rf ./term-sd
                echo "清除完成,开始安装"
                git clone $term_sd_install_mirror
                if [ $? = 0 ];then
                    cp -f ./term-sd/term-sd.sh .
                    chmod +x ./term-sd.sh
                    echo "安装成功"
                else
                    echo "安装失败"
                    exit 1
                fi
            fi
        fi
    fi
}

#term-sd重新安装功能
function term_sd_reinstall()
{
    term_sd_install_option=""
    for term_sd_launch_input in $(echo "$1 $2 $3 $4 $5 $6 $7 $8 $9") ;do
        case $term_sd_launch_input in
        "--reinstall-term-sd")
        echo "是否重新安装Term-SD(yes/no)?"
        echo "提示:输入yes或no后回车"
        read -p "==>" term_sd_install_option
        if [ ! -z $term_sd_install_option ];then
            if [ $term_sd_install_option = yes ] || [ $term_sd_install_option = y ] || [ $term_sd_install_option = YES ] || [ $term_sd_install_option = Y ];then
                term_sd_install_mirror_select
                echo "清除term-sd文件"
                rm -rf ./term-sd
                echo "清除完成,开始安装"
                git clone $term_sd_install_mirror
                if [ $? = 0 ];then
                    cp -f ./term-sd/term-sd.sh .
                    chmod +x ./term-sd.sh
                    echo "安装成功"
                else
                    echo "安装失败"
                    exit 1
                fi
            else
                exit 1
            fi
        else
            exit 1
        fi
        ;;
        esac
    done
}

#term-sd下载源选择
function term_sd_install_mirror_select()
{
    term_sd_install_option=""
    echo "请选择下载源"
    echo "1、github源"
    echo "2、gitlab源"
    echo "3、gitee源"
    echo "4、代理源(ghproxy.com)"
    echo "输入数字后回车"
    read -p "==>" term_sd_install_option
    if [ ! -z $term_sd_install_option ];then
        if [ $term_sd_install_option = 1 ];then
            echo "选择github源"
            term_sd_install_mirror="https://github.com/licyk/term-sd.git"
        elif [ $term_sd_install_option = 2 ];then
            echo "选择gitlab源"
            term_sd_install_mirror="https://gitlab.com/licyk/term-sd.git"
        elif [ $term_sd_install_option = 3 ];then
            echo "选择gitee源"
            term_sd_install_mirror="https://gitee.com/four-dishes/term-sd.git"
        elif [ $term_sd_install_option = 4 ];then
            echo "选择代理源(ghproxy.com)"
            term_sd_install_mirror="https://ghproxy.com/https://github.com/licyk/term-sd.git"
        else
            echo "输入有误,请重试"
            term_sd_install_mirror_select
        fi
    else
        echo "未输入,请重试"
        term_sd_install_mirror_select
    fi
}

#term-sd卸载功能
function remove_term_sd()
{
    remove_term_sd_option=""
    echo "是否卸载Term-SD"
    echo "提示:输入yes或no后回车"
    read -p "==>" remove_term_sd_option
    if [ ! -z  $remove_term_sd_option ];then
        if [ $remove_term_sd_option = yes ] || [ $remove_term_sd_option = y ] || [ $remove_term_sd_option = YES ] || [ $remove_term_sd_option = Y ];then
            echo "开始卸载Term-SD"
            rm -rf ./term-sd
            rm -rf ./term-sd.sh
            user_shell=$(echo $SHELL | awk -F "/" '{print $NF}') #读取用户所使用的shell
            if [ $user_shell = bash ] || [ $user_shell = zsh ];then
                cd ~
                sed -i '/termsd(){/d' ."$user_shell"rc
                sed -i '/alias tsd/d' ."$user_shell"rc
                cd - > /dev/null
            fi
            echo "Term-SD卸载完成"
        fi
    fi
    exit 1
}

#添加快捷命令功能
function install_cmd_to_shell()
{
    if [ $user_shell = bash ] || [ $user_shell = zsh ];then
        echo "是否将快捷指令添加到shell环境中?"
        echo "添加后可使用\"termsd\"指令启动Term-SD"
        echo "1、添加"
        echo "2、删除"
        echo "3、退出"
        echo "提示:输入数字后回车"
        read -p "==>" install_to_shell_option

        if [ ! -z $install_to_shell_option ];then
            if [ $install_to_shell_option = 1 ];then
                install_config_to_shell
            elif [ $install_to_shell_option = 2 ];then
                remove_config_from_shell
            elif [ $install_to_shell_option = 3 ];then
                exit 1
            else
                echo "输入有误,请重试"
                install_cmd_to_shell
            fi
        else
            echo "未输入,请重试"
            install_cmd_to_shell
        fi
    else
        echo "不支持该shell"
    fi
}

#快捷命令安装功能
function install_config_to_shell()
{
    cd ~
    if [ $user_shell = bash ];then
        if cat ./.bashrc | grep termsd > /dev/null ;then
            echo "配置已存在,添加前请删除原有配置"
        else
            echo $term_sd_shell_config >> .bashrc
            echo "alias tsd='termsd'" >> .bashrc
            echo "配置添加完成,重启shell以生效"
        fi
    elif [ $user_shell = zsh ];then
        if cat ./.zshrc | grep termsd > /dev/null ;then
            echo "配置已存在,添加前请删除原有配置"
        else
            echo $term_sd_shell_config >> .zshrc
            echo "alias tsd='termsd'" >> .zshrc
            echo "配置添加完成,重启shell以生效"
        fi
    fi
    cd - > /dev/null
}

#快捷命卸载功能
function remove_config_from_shell()
{
    cd ~
    sed -i '/termsd(){/d' ."$user_shell"rc
    sed -i '/alias tsd/d' ."$user_shell"rc
    echo "配置已删除,重启shell以生效"
    cd - > /dev/null
}

#终端横线显示功能
function print_line_to_shell()
{
    if [ -z "$print_word_to_shell" ];then
        print_line_methon=1
        print_line_to_shell_methon
    else
        shellwidth=$(stty size | awk '{print $2}') #获取终端宽度
        print_word_to_shell=$(echo "$print_word_to_shell" | awk '{gsub(/ /,"-")}1') #将空格转换为"-"
        shell_word_width=$(( $(echo "$print_word_to_shell" | wc -c) - 1 )) #总共的字符长度
        shell_word_width_zh_cn=$(( $(echo "$print_word_to_shell" | awk '{gsub(/[a-zA-Z]/, "")}1' | awk '{gsub(/[0-9]/, "")}1' | awk '{gsub(/-/,"")}1' | wc -c) - 1 )) #计算中文字符的长度
        shell_word_width=$(( $shell_word_width - $shell_word_width_zh_cn )) #除去中文之后的长度
        #中文的字符长度为3,但终端中只占2个字符位
        shell_word_width_zh_cn=$(( $shell_word_width_zh_cn / 3 * 2 )) #转换中文在终端占用的实际字符长度
        shell_word_width=$(( $shell_word_width + $shell_word_width_zh_cn )) #最终显示文字的长度

        #横线输出长度的计算
        shellwidth=$(( $shellwidth - $shell_word_width )) #除去输出字符后的横线宽度
        shellwidth=$(( $shellwidth / 2 )) #半边的宽度

        #判断终端宽度大小是否是单双数
        origin_num=$shellwidth
        singular_and_plural_calculate
        print_line_info=$calculate_num_result
        #判断字符宽度大小是否是单双数
        origin_num=$shell_word_width
        singular_and_plural_calculate
        print_word_info=$calculate_num_result
        
        if [ $print_line_info = 1 ];then #如果终端宽度大小是双数
            if [ $print_word_info = 1 ];then #如果字符宽度大小是双数
                print_line_methon=2
            elif [ $print_word_info = 2 ];then #如果字符宽度大小是单数
                print_line_methon=3
            fi
        elif [ $print_line_info = 2 ];then #如果终端宽度大小是单数数
            if [ $print_word_info = 1 ];then
                print_line_methon=2
            elif [ $print_word_info = 2 ];then
                print_line_methon=3
            fi
        fi

        print_line_to_shell_methon
    fi
}

#判断数字是否单双数的功能
function singular_and_plural_calculate()
{
    if [ ! -z "$origin_num" ];then
        calculate_num_1=$(( $origin_num / 2 )) # 5/2 -> 2 | 4/2 -> 2
        calculate_num_2=$(( $origin_num + 3 )) # 5+3 -> 8 | 4+3 -> 7
        calculate_num_3=$(( $calculate_num_2 / 2 )) # 8/2 -> 4 | 7/2 -> 3
        calculate_num_result=$(( $calculate_num_3 - $calculate_num_1 )) # 4-2 -> 2 | 3-2 -> 1 按上述算法得到的结果,如果是1,则为双数;如果是2,则为单数
        origin_num=""
        calculate_num_1=""
        calculate_num_2=""
        calculate_num_3=""
    fi
}

#输出终端横线方法
function print_line_to_shell_methon()
{
    if [ $print_line_methon = 1 ];then
        shellwidth=$(stty size | awk '{print $2}') #获取终端宽度
        yes "-" | sed $shellwidth'q' | tr -d '\n' #输出横杠
    elif [ $print_line_methon = 2 ];then #解决显示字符为单数时少显示一个字符导致不对成的问题
        echo "$(yes "-" | sed $shellwidth'q' | tr -d '\n')$print_word_to_shell$(yes "-" | sed $shellwidth'q' | tr -d '\n')"
    elif [ $print_line_methon = 3 ];then
        echo "$(yes "-" | sed $shellwidth'q' | tr -d '\n')$print_word_to_shell$(yes "-" | sed $(( $shellwidth + 1 ))'q' | tr -d '\n')"
    fi
    print_word_to_shell="" #清除已输出的内容
}

#################################################

print_word_to_shell="Term-SD"
print_line_to_shell

echo "Term-SD初始化中......"
echo "检测依赖软件是否安装"
missing_dep=""
test_num=0
temr_sd_depend="git aria2c dialog pip" #term-sd依赖软件包
term_sd_install_path=$(pwd) #读取term-sd安装位置

#将要向.bashrc写入的配置
term_sd_shell_config="termsd(){ user_input_for_term_sd=$(echo \"\$1 \$2 \$3 \$4 \$5 \$6 \$7 \$8 \$9\") ; term_sd_start_path=\$(pwd) ; cd \"$term_sd_install_path\" ; ./term-sd.sh \$user_input_for_term_sd ; cd \"\$term_sd_start_path\" > /dev/null ; }"

user_shell=$(echo $SHELL | awk -F "/" '{print $NF}') #读取用户所使用的shell

#检测可用的python命令
if python3 --version > /dev/null 2> /dev/null || python --version > /dev/null 2> /dev/null ;then #判断是否有可用的python
    test_num=$(( $test_num + 1 ))
    python_cmd_test_1=$(python3 --version)
    python_cmd_test_2=$(python --version)

    if [ ! -z "$python_cmd_test_1" ];then
        export python_cmd="python3"
    elif [ ! -z "$python_cmd_test_2" ];then
        export python_cmd="python"
    fi
else
    missing_dep="$missing_dep python,"
fi

#判断系统是否安装必须使用的软件
for term_sd_depend_ in $temr_sd_depend ; do
    if which $term_sd_depend_ > /dev/null ;then
        test_num=$(( $test_num + 1 ))
    else
        missing_dep="$missing_dep $term_sd_depend_,"
    fi
done

#在使用http_proxy变量后,会出现ValueError: When localhost is not accessible, a shareable link must be created. Please set share=True
#导致启动异常
#需要设置no_proxy让localhost,127.0.0.1,::1避开http_proxy
#详见https://github.com/microsoft/TaskMatrix/issues/250
export no_proxy="localhost,127.0.0.1,::1" #除了避免http_proxy变量的影响,也避免了代理软件的影响(在a1111-sd-webui中,开启代理软件可能会导致webui无法生图,并报错,设置该变量后完美解决该问题)

if [ -f "./term-sd/proxy.conf" ];then #读取代理设置并设置代理
    export http_proxy=$(cat ./term-sd/proxy.conf)
    export https_proxy=$(cat ./term-sd/proxy.conf)
    #export all_proxy=$(cat ./term-sd/proxy.conf)
    #代理变量的说明:https://blog.csdn.net/Dancen/article/details/128045261
fi

#启动terrm-sd
if [ $test_num -ge 5 ];then
    echo "检测完成"
    term_sd_reinstall $(echo "$1 $2 $3 $4 $5 $6 $7 $8 $9")
    term_sd_install
    if [ -d "./term-sd/modules" ];then #找到目录后才启动
        term_sd_auto_update_trigger
        term_sd_process_user_input $(echo "$1 $2 $3 $4 $5 $6 $7 $8 $9")
    else
        echo "term-sd模块丢失,\"输入./term-sd.sh --reinstall-term-sd\"重新安装Term-SD"
    fi
else
    print_word_to_shell="缺少以下依赖"
    print_line_to_shell
    echo $missing_dep
    print_line_to_shell
    echo "请安装缺少的依赖后重试"
    exit 1
fi
