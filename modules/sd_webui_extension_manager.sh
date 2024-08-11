#!/bin/bash

# SD WebUI 插件管理器
sd_webui_extension_manager() {
    local dialog_arg

    if [[ ! -d "${SD_WEBUI_PATH}"/extensions ]]; then
        dialog --erase-on-exit \
            --title "Stable-Diffusion-WebUI 管理" \
            --backtitle "Stable-Diffusion-WebUI 插件管理选项" \
            --ok-label "确认" \
            --msgbox "Stable-Diffusion-WebUI 插件目录, 请检查 Stable-Diffusion-WebUI 是否安装完整" \
            $(get_dialog_size)
        return 1
    fi

    while true; do
        cd "${SD_WEBUI_PATH}"/extensions #回到最初路径

        # 功能选择界面
        dialog_arg=$(dialog --erase-on-exit --notags \
            --title "Stable-Diffusion-WebUI 管理" \
            --backtitle "Stable-Diffusion-WebUI 插件管理选项" \
            --ok-label "确认" --cancel-label "取消" \
            --menu "请选择 Stable-Diffusion-WebUI 插件管理选项的功能" \
            $(get_dialog_size_menu) \
            "0" "> 返回" \
            "1" "> 安装插件" \
            "2" "> 管理插件" \
            "3" "> 更新全部插件" \
            3>&1 1>&2 2>&3 )

        case "${dialog_arg}" in
            1)
                # 选择安装
                sd_webui_extension_install
                ;;
            2)
                # 选择管理
                sd_webui_extension_list
                ;;
            3)
                # 选择更新全部插件
                if (dialog --erase-on-exit \
                    --title "Stable-Diffusion-WebUI 管理" \
                    --backtitle "Stable-Diffusion-WebUI 插件管理" \
                    --yes-label "是" --no-label "否" \
                    --yesno "是否更新所有 Stable-Diffusion-WebUI 插件 ?" \
                    $(get_dialog_size)); then

                    update_all_extension
                fi
                ;;
            *)
                break
                ;;
        esac
    done
}

# SD WebUI 插件安装
sd_webui_extension_install() {
    local repo_url
    local name

    repo_url=$(dialog --erase-on-exit \
        --title "Stable-Diffusion-WebUI 管理" \
        --backtitle "Stable-Diffusion-WebUI 插件安装选项" \
        --ok-label "确认" --cancel-label "取消" \
        --inputbox "请输入插件的 Github 地址或其他下载地址" \
        $(get_dialog_size) \
        3>&1 1>&2 2>&3)

    if [ ! -z "${repo_url}" ]; then
        name=$(basename "${repo_url}" | awk -F '.git' '{print $1}')
        term_sd_echo "安装 ${name} 插件中"
        if ! term_sd_is_git_repository_exist "${repo_url}" ;then
            term_sd_try git clone --recurse-submodules "${repo_url}"
            if [[ "$?" == 0 ]]; then
                dialog --erase-on-exit \
                    --title "Stable-Diffusion-WebUI 管理" \
                    --backtitle "Stable-Diffusion-WebUI 插件安装结果" \
                    --ok-label "确认" \
                    --msgbox "${name} 插件安装成功" \
                    $(get_dialog_size)
            else
                dialog --erase-on-exit \
                    --title "Stable-Diffusion-WebUI 管理" \
                    --backtitle "Stable-Diffusion-WebUI 插件安装结果" \
                    --ok-label "确认" \
                    --msgbox "${name} 插件安装失败" \
                    $(get_dialog_size)
            fi
        else
            dialog --erase-on-exit \
                --title "Stable-Diffusion-WebUI 管理" \
                --backtitle "Stable-Diffusion-WebUI 插件安装结果" \
                --ok-label "确认" \
                --msgbox "${name} 插件已存在" \
                $(get_dialog_size)
        fi
    else
        term_sd_echo "输入的 Stable-Diffusion-WebUI 插件安装地址为空"
    fi
}

# 插件列表浏览器
sd_webui_extension_list() {
    local extension_name

    while true; do
        cd "${SD_WEBUI_PATH}"/extensions #回到最初路径
        get_dir_folder_list # 获取当前目录下的所有文件夹

        if term_sd_is_bash_ver_lower; then # Bash 版本低于 4 时使用旧版列表显示方案
            extension_name=$(dialog --erase-on-exit \
                --ok-label "确认" --cancel-label "取消" \
                --title "Stable-Diffusion-WebUI 管理" \
                --backtitle "Stable-Diffusion-WebUI 插件列表" \
                --menu "使用上下键选择要操作的插件并回车确认" \
                $(get_dialog_size_menu) \
                "-->返回<--" "<---------" \
                "${LOCAL_DIR_LIST}" \
                3>&1 1>&2 2>&3)
        else
            extension_name=$(dialog --erase-on-exit \
                --ok-label "确认" --cancel-label "取消" \
                --title "Stable-Diffusion-WebUI 管理" \
                --backtitle "Stable-Diffusion-WebUI 插件列表" \
                --menu "使用上下键选择要操作的插件并回车确认" \
                $(get_dialog_size_menu) \
                "-->返回<--" "<---------" \
                "${LOCAL_DIR_LIST[@]}" \
                3>&1 1>&2 2>&3)
        fi

        if [[ "$?" == 0 ]]; then
            if [[ "${extension_name}" == "-->返回<--" ]]; then
                break
            elif [[ -d "${extension_name}" ]]; then # 选择文件夹
                cd "${extension_name}"
                sd_webui_extension_interface "${extension_name}"
            fi
        else
            break
        fi
    done

    unset LOCAL_DIR_LIST
}

# 插件管理功能
# 使用:
# sd_webui_extension_interface <插件文件名> 
sd_webui_extension_interface() {
    local dialog_arg
    local extension_name=$@
    local extension_status
    local dialog_buttom
    local status_display

    while true; do

        if is_sd_webui_extension_disabled "${extension_name}"; then
            extension_status=0
            dialog_buttom="启用"
            status_display="已禁用"
        else
            extension_status=1
            dialog_buttom="禁用"
            status_display="已启用"
        fi

        dialog_arg=$(dialog --erase-on-exit --notags \
            --title "Stable-Diffusion-WebUI 管理" \
            --backtitle "Stable-Diffusion-WebUI 插件管理选项" \
            --ok-label "确认" --cancel-label "取消" \
            --menu "请选择对 ${extension_name} 插件的管理功能\n当前更新源: $(git_remote_display)\n当前分支: $(git_branch_display)\n当前状态: ${status_display}" \
            $(get_dialog_size_menu) \
            "0" "> 返回" \
            "1" "> 更新" \
            "2" "> 修复更新" \
            "3" "> 版本切换" \
            "4" "> 更新源切换" \
            "5" "> ${dialog_buttom}插件" \
            "6" "> 卸载" \
            3>&1 1>&2 2>&3)

        case "${dialog_arg}" in
            1)
                if is_git_repo; then
                    term_sd_echo "更新 $(echo ${extension_name} | awk -F "/" '{print $NF}') 插件中"
                    git_pull_repository
                    if [[ "$?" == 0 ]]; then
                        dialog --erase-on-exit \
                            --title "Stable-Diffusion-WebUI 管理" \
                            --backtitle "Stable-Diffusion-WebUI 插件更新结果" \
                            --ok-label "确认" \
                            --msgbox "${extension_name} 插件更新成功" \
                            $(get_dialog_size)
                    else
                        dialog --erase-on-exit \
                            --title "Stable-Diffusion-WebUI 管理" \
                            --backtitle "Stable-Diffusion-WebUI 插件更新结果" \
                            --ok-label "确认" \
                            --msgbox "${extension_name} 插件更新失败" \
                            $(get_dialog_size)
                    fi
                else
                    dialog --erase-on-exit \
                        --title "Stable-Diffusion-WebUI 管理" \
                        --backtitle "Stable-Diffusion-WebUI 插件更新结果" \
                        --ok-label "确认" \
                        --msgbox "${extension_name} 插件非 Git 安装, 无法更新" \
                        $(get_dialog_size)
                fi
                ;;
            2)
                if is_git_repo; then
                    if (dialog --erase-on-exit \
                        --title "Stable-Diffusion-WebUI 管理" \
                        --backtitle "Stable-Diffusion-WebUI 插件修复更新" \
                        --yes-label "是" --no-label "否" \
                        --yesno "是否修复 ${extension_name} 插件更新 ?" \
                        $(get_dialog_size)); then

                        git_fix_pointer_offset
                    fi
                else
                    dialog --erase-on-exit \
                        --title "Stable-Diffusion-WebUI 管理" \
                        --backtitle "Stable-Diffusion-WebUI 插件修复更新" \
                        --ok-label "确认" \
                        --msgbox "${extension_name} 插件非 Git 安装, 无法修复更新" \
                        $(get_dialog_size)
                fi
                ;;
            3)
                if is_git_repo; then
                    if (dialog --erase-on-exit \
                        --title "Stable-Diffusion-WebUI 管理" \
                        --backtitle "Stable-Diffusion-WebUI 插件版本切换" \
                        --yes-label "是" --no-label "否" \
                        --yesno "是否切换 ${extension_name} 插件版本 ?" \
                        $(get_dialog_size)); then

                        git_ver_switch
                        dialog --erase-on-exit \
                            --title "Stable-Diffusion-WebUI 管理" \
                            --backtitle "Stable-Diffusion-WebUI 自定义节点版本切换" \
                            --ok-label "确认" \
                            --msgbox "${extension_name} 自定义节点版本切换完成, 当前版本为: $(git_branch_display)" \
                            $(get_dialog_size)
                    fi
                else
                    dialog --erase-on-exit \
                        --title "Stable-Diffusion-WebUI 管理" \
                        --backtitle "Stable-Diffusion-WebUI 插件版本切换" \
                        --ok-label "确认" \
                        --msgbox "${extension_name} 插件非 Git 安装, 无法进行版本切换" \
                        $(get_dialog_size)
                fi
                ;;
            4)
                if is_git_repo; then
                    if (dialog --erase-on-exit \
                        --title "Stable-Diffusion-WebUI 管理" \
                        --backtitle "Stable-Diffusion-WebUI 插件更新源切换" \
                        --yes-label "是" --no-label "否" \
                        --yesno "是否切换 ${extension_name} 插件更新源 ?" \
                        $(get_dialog_size)); then

                        git_remote_url_select_single
                    fi
                else
                    dialog --erase-on-exit \
                        --title "Stable-Diffusion-WebUI 管理" \
                        --backtitle "Stable-Diffusion-WebUI 插件更新源切换" \
                        --ok-label "确认" \
                        --msgbox "${extension_name} 插件非 Git 安装, 无法进行更新源切换" \
                        $(get_dialog_size)
                fi
                ;;
            5)
                if [[ "${extension_status}" == 0 ]]; then
                    if (dialog --erase-on-exit \
                        --title "Stable-Diffusion-WebUI 管理" \
                        --backtitle "Stable-Diffusion-WebUI 插件更新源切换" \
                        --yes-label "是" --no-label "否" \
                        --yesno "是否启用 ${extension_name} 插件 ?" \
                        $(get_dialog_size)); then

                        switch_sd_webui_enable_extension_status "${extension_name}"
                    else
                        continue
                    fi
                else
                    if (dialog --erase-on-exit \
                        --title "Stable-Diffusion-WebUI 管理" \
                        --backtitle "Stable-Diffusion-WebUI 插件更新源切换" \
                        --yes-label "是" --no-label "否" \
                        --yesno "是否禁用 ${extension_name} 插件 ?" \
                        $(get_dialog_size)); then

                        switch_sd_webui_enable_extension_status "${extension_name}"
                    else
                        continue
                    fi
                fi

                if [[ "$?" == 0 ]]; then
                    dialog --erase-on-exit \
                        --title "Stable-Diffusion-WebUI 管理" \
                        --backtitle "Stable-Diffusion-WebUI 插件删除选项" \
                        --ok-label "确认" \
                        --msgbox "${dialog_buttom} ${extension_name} 插件成功" \
                        $(get_dialog_size)
                else
                    dialog --erase-on-exit \
                        --title "Stable-Diffusion-WebUI 管理" \
                        --backtitle "Stable-Diffusion-WebUI 插件删除选项" \
                        --ok-label "确认" \
                        --msgbox "${dialog_buttom} ${extension_name} 插件失败" \
                        $(get_dialog_size)
                fi
                ;;
            6)
                if (dialog --erase-on-exit \
                    --title "Stable-Diffusion-WebUI 管理" \
                    --backtitle "Stable-Diffusion-WebUI 插件删除选项" \
                    --yes-label "是" --no-label "否" \
                    --yesno "是否删除 ${extension_name} 插件 ?" \
                    $(get_dialog_size)); then

                    term_sd_echo "请再次确认是否删除 ${extension_name} (yes/no) ?"
                    term_sd_echo "警告: 该操作将永久删除 ${extension_name}"
                    term_sd_echo "提示: 输入 yes 或 no 后回车"
                    case "$(term_sd_read)" in
                        yes|y|YES|Y)
                            term_sd_echo "删除 ${extension_name} 插件中"
                            cd ..
                            rm -rf "${extension_name}"

                            dialog --erase-on-exit \
                                --title "Stable-Diffusion-WebUI 管理" \
                                --backtitle "Stable-Diffusion-WebUI 插件删除选项" \
                                --ok-label "确认" \
                                --msgbox "删除 ${extension_name} 插件完成" \
                                $(get_dialog_size)

                            break                            
                            ;;
                        *)
                            term_sd_echo "取消删除 ${extension_name} 插件操作"
                            ;;
                    esac
                fi
                ;;
            *)
                break
                ;;
        esac
    done
}

# 切换插件的启用状态
# 使用:
# switch_sd_webui_enable_extension_status <插件名称>
# 通过修改 <SD WebUI Path>/config.json 文件调整插件的启用状态
# 当插件启用时, 执行该函数将禁用插件, 反过来同理
switch_sd_webui_enable_extension_status() {
    local extension_name=$@
    local status

    if is_sd_webui_extension_disabled "${extension_name}"; then
        # 插件被禁用时
        term_sd_echo "尝试启用 ${extension_name} 插件"
        status="True"
    else
        # 插件启用时
        term_sd_echo "尝试禁用 ${extension_name} 插件"
        status="False"
    fi

    if set_sd_webui_extension_status "${extension_name}" "${status}"; then
        term_sd_echo "操作 ${extension_name} 插件成功"
        return 0
    else
        term_sd_echo "操作 ${extension_name} 插件失败"
        return 1
    fi
}

# 查询插件是否被禁用
# 使用:
# is_sd_webui_extension_disabled <插件名>
is_sd_webui_extension_disabled() {
    local config_path
    local extension_name=$@

    config_path=$(get_sd_webui_config_path)

    # 没有配置文件时返回 1 说明插件未被禁用
    if [[ ! -f "${config_path}" ]]; then
        return 1
    fi

    result=$(term_sd_python -c "$(py_is_sd_webui_extension_disabled "${config_path}" "${extension_name}")")

    if [[ "${result}" == "True" ]]; then
        return 0
    else
        return 1
    fi
}

# 修改插件的启用状态
# 使用:
# set_sd_webui_extension_status <插件名> <True / False>
set_sd_webui_extension_status() {
    local extension_name=$1
    local status=$2
    local config_path
    local result

    config_path=$(get_sd_webui_config_path)

    if [[ ! -f "${config_path}" ]]; then
        echo "{}" > "${config_path}"
    fi
    
    result=$(term_sd_python -c "$(py_set_sd_webui_extension_status "${config_path}" "${extension_name}" "${status}")")

    if [[ "${result}" == "True" ]]; then
        return 0
    else
        return 1
    fi
}

# 获取 SD WebUI 配置文件路径
get_sd_webui_config_path() {
    local result

    result=$(cd "${SD_WEBUI_PATH}" ; term_sd_python -c "$(py_get_sd_webui_config_path)")

    echo "${result}"
}

# 查询插件是否被禁用
# 使用:
# py_is_sd_webui_extension_disabled <配置文件路径> <插件名>
# 运行后返回完整的 python 代码
py_is_sd_webui_extension_disabled() {
    local config_path=$1
    local extension_name=$2

    cat<<EOF
def get_key_map(file_path):
    import os
    import pathlib
    import json
    file_name = pathlib.Path(file_path)
    if os.path.exists(file_name):
        try:
            with open(file_name, "r", encoding="utf8") as file:
                data = json.load(file)
        except Exception:
            # json 文件格式出现问题
            data = {}
    else:
        data = {}

    return data


def search_key(data, key, value):
    key_map = data.get(key)
    if key_map is not None:
        for i in key_map:
            if value in i:
                return True
        return False
    else:
        return False


json_path = "${config_path}"
key_name = "disabled_extensions"
extension_name = "${extension_name}"

if search_key(get_key_map(json_path), key_name, extension_name):
    print(True)
else:
    print(False)
EOF
}

# 修改插件的启用状态
# 使用:
# py_set_sd_webui_extension_status <配置文件路径> <插件名> <True / False>
# 运行后返回完整的 python 代码
py_set_sd_webui_extension_status() {
    local config_path=$1
    local extension_name=$2
    local status=$3

    cat<<EOF
def get_key_map(file_path):
    import os
    import pathlib
    import json
    file_name = pathlib.Path(file_path)
    if os.path.exists(file_name):
        try:
            with open(file_name, "r", encoding="utf8") as file:
                data = json.load(file)
        except Exception:
            # json 文件格式出现问题
            data = {}
    else:
        data = {}

    return data


def check_json(file_path):
    import os
    import pathlib
    import json
    file_name = pathlib.Path(file_path)
    if os.path.exists(file_name):
        try:
            with open(file_name, "r", encoding="utf8") as file:
                data = json.load(file)
            return True
        except Exception:
            # json 文件格式出现问题
            return False
    else:
        return False


def search_key(data, key, value):
    key_map = data.get(key)
    if key_map is not None:
        if value in key_map:
            return True
        else:
            return False
    else:
        return False


def save(data, filename):
    import json
    with open(filename, "w", encoding="utf8") as file:
        json.dump(data, file, indent = 4, ensure_ascii = False)


def set_extension_status(json_path, extension_name, status):
    key_name = "disabled_extensions"
    # 检查 json 格式是否正确
    if check_json(json_path):
        data = get_key_map(json_path)
        # 缺少 disabled_extensions 这个值时自动补上
        if data.get(key_name) is None:
            data[key_name] = []

        if status:
            if search_key(data, key_name, extension_name):
                data[key_name].remove(extension_name)
                save(data, json_path)
        else:
            if search_key(data, key_name, extension_name) is False:
                data[key_name].append(extension_name)
                save(data, json_path)
        print(True)
    else:
        print(False)



json_path = "${config_path}"
extension_name = "${extension_name}"
status = ${status}

set_extension_status(json_path, extension_name, status)
EOF
}

# 获取 SD WebUI 配置文件路径
# 运行后返回完整的 Python 代码
py_get_sd_webui_config_path() {
    cat<<EOF
import os
print(os.path.abspath("config.json"))
EOF
}
