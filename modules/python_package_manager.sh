#!/bin/bash

# 安装 Python 软件包功能
# 使用 PIP_PACKAGE_MANAGER_METHON_NAME 全局变量获取进行操作的 Python 软件包的操作名
# 使用 PIP_PACKAGE_MANAGER_METHON 全集变量获取要进行的 Python 软件包操作
python_package_manager() {
    local dialog_arg
    local req
    local i
    # 安装前的准备
    download_mirror_select # 下载镜像源选择
    pip_install_mode_select # 安装方式选择
    pip_force_reinstall_select # 强制安装选择
    pip_manage_package_methon_select # Python 软件包操作方式选择

    dialog_arg=$(dialog --erase-on-exit \
        --title "Term-SD" \
        --backtitle "${TERM_SD_MANAGE_OBJECT} Python 软件包安装 / 重装 / 卸载选项" \
        --ok-label "确认" --cancel-label "取消" \
        --inputbox "请输入需要安装 / 重装 / 卸载的 Python 软件包名" \
        $(get_dialog_size) 3>&1 1>&2 2>&3)

    if [[ "$?" == 0 ]] && [ ! -z "$(echo ${dialog_arg} | awk '{gsub(/[=+<>]/, "")}1')" ]; then
        if term_sd_install_confirm "是否${PIP_PACKAGE_MANAGER_METHON_NAME}输入的 Python 软件包 ?"; then
            term_sd_print_line "Python 软件包${PIP_PACKAGE_MANAGER_METHON_NAME}"
            term_sd_echo "将${PIP_PACKAGE_MANAGER_METHON_NAME}以下 Python 软件包"
            for i in ${dialog_arg}; do
                echo ${i}
            done
            term_sd_print_line
            enter_venv
            term_sd_tmp_disable_proxy

            case "${PIP_PACKAGE_MANAGER_METHON}" in # 选择pip包管理器管理方法
                1)
                    # 常规安装
                    install_python_package ${dialog_arg}
                    ;;
                2)
                    # 仅安装
                    install_python_package --no-deps ${dialog_arg}
                    ;;
                3)
                    # 强制重装
                    install_python_package --force-reinstall ${dialog_arg}
                    ;;
                4)
                    # 仅强制重装
                    install_python_package --force-reinstall --no-deps ${dialog_arg}
                    ;;
                5)
                    # 卸载
                    term_sd_try term_sd_pip uninstall -y ${dialog_arg}
                    ;;
            esac
            req=$?

            term_sd_echo "${PIP_PACKAGE_MANAGER_METHON_NAME} Python 软件包结束"
            term_sd_tmp_enable_proxy
            term_sd_print_line

            if [[ "${req}" == 0 ]]; then
                dialog --erase-on-exit \
                    --title "Term-SD" \
                    --backtitle "Python 软件包${PIP_PACKAGE_MANAGER_METHON_NAME}结果" \
                    --ok-label "确认" \
                    --msgbox "以下 Python 软件包${PIP_PACKAGE_MANAGER_METHON_NAME}成功\n${TERM_SD_DELIMITER}\n${dialog_arg}\n${TERM_SD_DELIMITER}" \
                    $(get_dialog_size)
            else
                dialog --erase-on-exit \
                    --title "Term-SD" \
                    --backtitle "Python 软件包${PIP_PACKAGE_MANAGER_METHON_NAME}结果" \
                    --ok-label "确认" \
                    --msgbox "以下 Python 软件包${PIP_PACKAGE_MANAGER_METHON_NAME}失败\n${TERM_SD_DELIMITER}\n${dialog_arg}\n${TERM_SD_DELIMITER}" \
                    $(get_dialog_size)
            fi
        else
            term_sd_echo "取消${PIP_PACKAGE_MANAGER_METHON_NAME} Python 软件包操作"
        fi
    else
        dialog --erase-on-exit \
            --title "Term-SD" \
            --backtitle "${TERM_SD_MANAGE_OBJECT} Python 软件包安装 / 重装 / 卸载选项" \
            --ok-label "确认" \
            --msgbox "未输入 Python 软件包名, 不执行 Python 软件包操作" \
            $(get_dialog_size)
    fi

    unset PIP_PACKAGE_MANAGER_METHON
    unset PIP_PACKAGE_MANAGER_METHON_NAME
    clean_install_config # 清理安装参数
}

# Pip 管理软件包方法选择
# 将操作方法的名称保存至 PIP_PACKAGE_MANAGER_METHON_NAME 全局变量
# 将操作方法保存在 PIP_PACKAGE_MANAGER_METHON 全局变量中
pip_manage_package_methon_select() {
    local dialog_arg

    dialog_arg=$(dialog --erase-on-exit --notags \
        --title "Term-SD" \
        --backtitle "Pip 操作方式选项" \
        --ok-label "确认" --no-cancel \
        --menu "请选择 Pip 操作方式\n1、常规安装用于安装缺失的软件包\n2、强制重装可解决软件包损坏问题, 但同时重新安装软件包所需的依赖, 速度较慢\n3、卸载软件包\n注: 带有 \"仅\" 的功能是在安装时只安装用户输入的软件包, 而不安装这些软件包的依赖\n安装 / 重装软件包时可以只写包名, 也可以指定包名版本\n可以输入多个软件包的包名, 并使用空格隔开\n如果想要更新某个软件包的版本, 可以加上 -U 参数\n例:\nxformers\nxformers==0.0.21\nxformers==0.0.21 numpy\nnumpy -U" \
        $(get_dialog_size_menu) \
        "1" "> 常规安装 (install)" \
        "2" "> 仅安装 (--no-deps)" \
        "3" "> 强制重装 (--force-reinstall)" \
        "4" "> 仅强制重装 (--no-deps --force-reinstall)" \
        "5" "> 卸载 (uninstall)" \
        3>&1 1>&2 2>&3)

    if [[ "$?" == 0 ]]; then
        case "${dialog_arg}" in
            1)
                PIP_PACKAGE_MANAGER_METHON_NAME="安装"
                PIP_PACKAGE_MANAGER_METHON=1
                ;;
            2)
                PIP_PACKAGE_MANAGER_METHON_NAME="安装 (--no-deps)"
                PIP_PACKAGE_MANAGER_METHON=2
                ;;
            3)
                PIP_PACKAGE_MANAGER_METHON_NAME="强制重装 (--force-reinstall)"
                PIP_PACKAGE_MANAGER_METHON=3
                ;;
            4)
                PIP_PACKAGE_MANAGER_METHON_NAME="强制重装 (--no-deps --force-reinstall)"
                PIP_PACKAGE_MANAGER_METHON=4
                ;;
            5)
                PIP_PACKAGE_MANAGER_METHON_NAME="卸载"
                PIP_PACKAGE_MANAGER_METHON=5
                ;;
        esac
    fi
}

# Python 软件包更新
# 使用:
# python_package_update <requirements.txt>
# 进行更新依赖操作时将忽略部分软件包
# 忽略的软件包名单:
# torch torchvision torchaudio xformers InvokeAI bitsandbytes
python_package_update() {
    cat "$@" > tmp-python-package-update-list.txt # 生成要更新的软件包名单
    local ignore_update_python_package_list="torch torchvision torchaudio xformers InvokeAI bitsandbytes" # 忽略更新的软件包名单
    for i in ${ignore_update_python_package_list}; do
        sed -i '/'$i'/d' tmp-python-package-update-list.txt 2> /dev/null  # 将忽略的软件包从名单删除
    done
    if term_sd_is_debug; then
        term_sd_print_line "Python 软件包更新列表"
        term_sd_echo "要进行更新的软件包名单:"
        cat tmp-python-package-update-list.txt
        term_sd_print_line
        term_sd_echo "cmd: install_python_package -r tmp-python-package-update-list.txt --upgrade"
    fi
    # 更新 Python 软件包
    install_python_package -r tmp-python-package-update-list.txt --upgrade
    rm -f tmp-python-package-update-list.txt # 删除列表缓存
}

# Python 软件包安装
# 使用:
# install_python_package <软件包> <其他参数>
# 使用以下全局变量作为参数使用
# PIP_INDEX_MIRROR, PIP_EXTRA_INDEX_MIRROR, PIP_FIND_LINKS_MIRROR
# PIP_BREAK_SYSTEM_PACKAGE_ARG, PIP_USE_PEP517_ARG, PIP_FORCE_REINSTALL_ARG
install_python_package() {
    if term_sd_is_debug; then
        term_sd_echo "PIP_INDEX_MIRROR: ${PIP_INDEX_MIRROR}"
        term_sd_echo "PIP_EXTRA_INDEX_MIRROR: ${PIP_EXTRA_INDEX_MIRROR}"
        term_sd_echo "PIP_FIND_LINKS_MIRROR: ${PIP_FIND_LINKS_MIRROR}"
        term_sd_echo "PIP_BREAK_SYSTEM_PACKAGE_ARG: ${PIP_BREAK_SYSTEM_PACKAGE_ARG}"
        term_sd_echo "PIP_USE_PEP517_ARG: ${PIP_USE_PEP517_ARG}"
        term_sd_echo "PIP_FORCE_REINSTALL_ARG: ${PIP_FORCE_REINSTALL_ARG}"
        term_sd_echo "cmd: term_sd_pip install $@ --prefer-binary ${PIP_INDEX_MIRROR} ${PIP_EXTRA_INDEX_MIRROR} ${PIP_FIND_LINKS_MIRROR} ${PIP_BREAK_SYSTEM_PACKAGE_ARG} ${PIP_USE_PEP517_ARG} ${PIP_FORCE_REINSTALL_ARG}"
    fi
    term_sd_try term_sd_pip install "$@" --prefer-binary ${PIP_INDEX_MIRROR} ${PIP_EXTRA_INDEX_MIRROR} ${PIP_FIND_LINKS_MIRROR} ${PIP_BREAK_SYSTEM_PACKAGE_ARG} ${PIP_USE_PEP517_ARG} ${PIP_FORCE_REINSTALL_ARG}
}