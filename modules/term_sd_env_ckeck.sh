#!/bin/bash

# 获取 ComfyUI 路径
get_comfyui_path() {
    local path
    path=$(cd "${COMFYUI_PATH}" ; term_sd_python -c "$(py_getcwd)")
    echo "${path}"
}

# 获取 Term-SD 的任务文件夹路径
get_term_sd_task_path() {
    local path
    path=$(cd "${START_PATH}/term-sd/task" ; term_sd_python -c "$(py_getcwd)")
    echo "${path}"
}

# 检查 ComfyUI 环境完整性
# 如果出现缺失依赖, 将依赖文件路径保存在 <Term-SD>/term-sd/task/comfyui_depend_path_list.sh
# 如何出现冲突依赖, 将分析出来的冲突情况保存在 <Term-SD>/term-sd/task/comfyui_has_conflict_requirement_notice.sh
check_comfyui_env() {
    local path
    local term_sd_task_path

    term_sd_echo "检测 ComfyUI 依赖完整性中"
    rm -f "${START_PATH}/term-sd/task/comfyui_has_conflict_requirement_notice.sh"
    rm -f "${START_PATH}/term-sd/task/comfyui_depend_path_list.sh"
    path=$(get_comfyui_path)
    term_sd_task_path=$(get_term_sd_task_path)
    term_sd_python -c "$(py_check_comfyui_env "${path}" "${term_sd_task_path}")"

    if [[ -f "${START_PATH}/term-sd/task/comfyui_has_conflict_requirement_notice.sh" ]]; then
        term_sd_echo "检测到当前 ComfyUI 环境中安装的插件之间存在依赖冲突情况, 该问题并非致命, 但建议只保留一个插件, 否则部分功能可能无法正常使用"
        term_sd_echo "您可以选择按顺序安装依赖, 由于这将向环境中安装不符合版本要求的组件, 您将无法完全解决此问题, 但可避免组件由于依赖缺失而无法启动的情况"
        term_sd_echo "您通常情况下可以选择忽略该警告并继续运行"
        term_sd_print_line "依赖冲突"
        term_sd_echo "检测到冲突的依赖:"
        cat "${START_PATH}/term-sd/task/comfyui_has_conflict_requirement_notice.sh"
        term_sd_print_line
        term_sd_echo "是否按顺序安装冲突依赖 (yes/no) ?"
        term_sd_echo "提示:"
        term_sd_echo "如果不选择按顺序安装冲突依赖, 则跳过安装冲突依赖直接运行 ComfyUI"
        term_sd_echo "输入 yes 或 no 后回车"

        case $(term_sd_read) in
            yes|YES|y|Y)
                term_sd_echo "选择按顺序安装依赖"
                ;;
            *)
                term_sd_echo "忽略警告并继续启动 ComfyUI"
                return 0
                ;;
        esac
    fi

    if [[ -f "${START_PATH}/term-sd/task/comfyui_depend_path_list.sh" ]]; then
        install_comfyui_requirement "${START_PATH}/term-sd/task/comfyui_depend_path_list.sh"
    else
        term_sd_echo "ComfyUI 依赖完整性检测完成"
    fi

    rm -f "${START_PATH}/term-sd/task/comfyui_has_conflict_requirement_notice.sh"
    rm -f "${START_PATH}/term-sd/task/comfyui_depend_path_list.sh"
}

# 安装 ComfyUI 缺失的依赖
# 使用:
# install_comfyui_requirement <ComfyUI 依赖路径记录表文件路径>
install_comfyui_requirement() {
    local requirements_list_path=$@
    local requirement_path
    local cmd_point
    local cmd_sum
    local requirement_name

    cmd_sum=$(cat "${requirements_list_path}" | wc -l) # 统计内容行数
    for (( cmd_point=1; cmd_point <= cmd_sum; cmd_point++ )); do
        requirement_path=$(cat "${requirements_list_path}" | awk 'NR=='${cmd_point}' {print $0}')
        requirement_parent_path=$(dirname "${requirement_path}")
        requirement_name=$(basename "${requirement_parent_path}")

        cd "${requirement_parent_path}"
        install_python_package -r requirements.txt
        if [[ "$?" == 0 ]]; then
            term_sd_echo "[${cmd_point}/${cmd_sum}]:: 安装 ${requirement_name} 依赖成功"
        else
            term_sd_echo "[${cmd_point}/${cmd_sum}]:: 安装 ${requirement_name} 依赖失败, 这可能会影响部分功能"
        fi

        if [[ -f "${requirement_parent_path}/install.py" ]]; then
            term_sd_echo "[${cmd_point}/${cmd_sum}]:: 执行 ${requirement_name} 安装脚本中"
            term_sd_try term_sd_python install.py
            if [[ "$?" == 0 ]]; then
                term_sd_echo "[${cmd_point}/${cmd_sum}]:: 执行 ${requirement_name} 安装脚本成功"
            else
                term_sd_echo "[${cmd_point}/${cmd_sum}]:: 执行 ${requirement_name} 安装脚本失败, 这可能会影响部分功能"
            fi
        fi
    done

    term_sd_echo "安装 ComfyUI 依赖结束"
    cd "${COMFYUI_PATH}"
}

# 获取当前路径(Python)
py_getcwd(){
    cat<<EOF
import os
from pathlib import Path
print(Path(os.getcwd()).as_posix())
EOF
}

# 转换路径格式
convert_path_format() {
    local path=$@
    local dir_path
    local base_name

    dir_path=$(dirname "${path}")
    dir_path=$(cd "${dir_path}" ; term_sd_python -c "$(py_getcwd)")
    base_name=$(basename "${path}")
    path=$(term_sd_python -c "$(py_convert_path_format "${dir_path}" "${base_name}")")

    echo "${path}"
}

# 转换路径格式(Python)
# 使用:
# 
py_convert_path_format() {
    local path_1=$1
    local path_2=$2

    cat<<EOF
import os
from pathlib import Path
print(Path(os.path.join("${path_1}", "${path_2}")).as_posix())
EOF
}

# 检查 ComfyUI 依赖完整性(Python)
# 使用:
# py_check_comfyui_env <ComfyUI 路径> <Term-SD 任务文件夹路径>
py_check_comfyui_env() {
    local path=$1
    local term_sd_task_path=$2

    cat<<EOF
import os
import re
import importlib.metadata
from pathlib import Path



# 获取 ComfyUI / ComfyUI 自定义节点的依赖记录文件
def get_requirement_file(path: str) -> dict:
    requirement_list = {}
    requirement_list["ComfyUI"] = {}
    requirement_list["ComfyUI"] = {"requirements_path": Path(os.path.join(path, "requirements.txt")).as_posix()}
    for custom_node_name in os.listdir(os.path.join(path, "custom_nodes")):
        if custom_node_name.endswith(".disabled"):
                continue
        custom_node_requirement = Path(os.path.join(path, "custom_nodes", custom_node_name, "requirements.txt")).as_posix()
        if os.path.exists(custom_node_requirement):
            requirement_list[custom_node_name] = {"requirements_path": custom_node_requirement}

    return requirement_list


# 读取依赖文件中的包名
def get_requirement_list(requirement_list: dict) -> dict:
    for i in requirement_list:
        requirement_name = i
        requirements_path = requirement_list.get(i).get("requirements_path")
        requirements = [] # Python 包名列表
        try:
            with open(requirements_path, "r") as f:
                # 处理文件内容
                lines = [
                    line.strip()
                    for line in f.readlines()
                    if line.strip() != ''
                    and not line.startswith("#")
                    and not (line.startswith("-") 
                    and not line.startswith("--index-url "))
                    and line is not None
                    and "# skip_verify" not in line
                ]

                # 添加到 Python 包名列表
                for line in lines:
                    requirements.append(line)

                requirement_list[requirement_name] = {"requirements_path": requirements_path, "requirements": requirements}
        except:
            pass
    
    return requirement_list


# 获取包版本号
def get_pkg_ver_from_lib(pkg_name: str) -> str:
    try:
        ver = importlib.metadata.version(pkg_name)
    except:
        ver = None

    if ver is None:
        try:
            ver = importlib.metadata.version(pkg_name.lower())
        except:
            ver = None       

    if ver is None:
        try:
            ver = importlib.metadata.version(pkg_name.replace("_", "-"))
        except:
            ver = None       

    return ver


# 判断是否有软件包未安装
def is_installed(package: str) -> bool:
    # 使用正则表达式删除括号和括号内的内容
    # 如: diffusers[torch]==0.10.2 -> diffusers==0.10.2
    package = re.sub(r'\[.*?\]', '', package)

    try:
        pkgs = [
            p
            for p in package.split()
            if not p.startswith('-') and not p.startswith('=')
        ]
        pkgs = [
            p.split('/')[-1] for p in pkgs
        ]   # 如果软件包从网址获取则只截取名字

        for pkg in pkgs:
            if '>=' in pkg:
                pkg_name, pkg_version = [x.strip() for x in pkg.split('>=')]
            elif '==' in pkg:
                pkg_name, pkg_version = [x.strip() for x in pkg.split('==')]
            elif '<=' in pkg:
                pkg_name, pkg_version = [x.strip() for x in pkg.split('<=')]
            elif '<' in pkg:
                pkg_name, pkg_version = [x.strip() for x in pkg.split('<')]
            elif '>' in pkg:
                pkg_name, pkg_version = [x.strip() for x in pkg.split('>')]
            else:
                pkg_name, pkg_version = pkg.strip(), None

            # 获取本地 Python 软件包信息
            version = get_pkg_ver_from_lib(pkg_name)

            if version is not None:
                # 判断版本是否符合要求
                if pkg_version is not None:
                    if '>=' in pkg:
                        # ok = version >= pkg_version
                        if compare_versions(version, pkg_version) == 1 or compare_versions(version, pkg_version) == 0:
                            ok = True
                        else:
                            ok = False
                    elif '<=' in pkg:
                        # ok = version <= pkg_version
                        if compare_versions(version, pkg_version) == -1 or compare_versions(version, pkg_version) == 0:
                            ok = True
                        else:
                            ok = False
                    elif '>' in pkg:
                        # ok = version > pkg_version
                        if compare_versions(version, pkg_version) == 1:
                            ok = True
                        else:
                            ok = False
                    elif '<' in pkg:
                        # ok = version < pkg_version
                        if compare_versions(version, pkg_version) == -1:
                            ok = True
                        else:
                            ok = False
                    else:
                        # ok = version == pkg_version
                        if compare_versions(version, pkg_version) == 0:
                            ok = True
                        else:
                            ok = False

                    if not ok:
                        return False
            else:
                return False

        return True
    except ModuleNotFoundError:
        return False


def check_missing_requirement(requirement_list: dict) -> dict:
    for i in requirement_list:
        requirement_name = i
        requirements_path = requirement_list.get(i).get("requirements_path")
        requirements = requirement_list.get(i).get("requirements")
        
        missing_requirement = []
        for i in requirements:
            if not is_installed(i):
                missing_requirement.append(i)

        requirement_list[requirement_name] = {"requirements_path": requirements_path, "requirements": requirements, "missing_requirement": missing_requirement}

    return requirement_list


# 格式化包名
def format_package_name(package: str) -> str:
    package = re.sub(r'\[.*?\]', '', package)

    pkgs = [
        p
        for p in package.split()
        if not p.startswith('-') and not p.startswith('=')
    ]
    pkgs = [
        p.split('/')[-1] for p in pkgs
    ]   # 如果软件包从网址获取则只截取名字

    for pkg in pkgs:
        return pkg


# 去重
def remove_duplicate(lists: list) -> list:
    return list(set(lists))


# 获取包版本号
def get_version(ver: str) -> str:
    # return "".join(re.findall(r"\d+", ver))
    return ver.split(">").pop().split("<").pop().split("=").pop()


# 判断是否有版本号
def has_version(ver: str) -> bool:
    if re.sub(r"\d+", "", ver) != ver:
        return True
    else:
        return False


# 获取包名(去除版本号)
def get_package_name(pkg: str) -> str:
    return pkg.split(">")[0].split("<")[0].split("==")[0]


# 判断 2 个版本的大小, 前面大返回 1, 后面大返回 -1, 相同返回 0
def compare_versions(version1, version2):
    nums1 = version1.split(".")  # 将版本号 1 拆分成数字列表
    nums2 = version2.split(".")  # 将版本号 2 拆分成数字列表

    for i in range(max(len(nums1), len(nums2))):
        num1 = int(nums1[i]) if i < len(nums1) else 0  # 如果版本号 1 的位数不够, 则补 0
        num2 = int(nums2[i]) if i < len(nums2) else 0  # 如果版本号 2 的位数不够, 则补 0

        if num1 == num2:
            continue
        elif num1 > num2:
            return 1  # 版本号 1 更大
        else:
            return -1  # 版本号 2 更大

    return 0  # 版本号相同


# 检测是否为冲突依赖
def detect_conflict_package(pkg_1: str, pkg_2: str) -> bool:
    if not has_version(get_version(pkg_1)) or not has_version(get_version(pkg_2)):
        return False

    for i in range(2):
        if i == 1:
            tmp = pkg_1
            pkg_1 = pkg_2
            pkg_2 = tmp

        if ">=" in pkg_1 and "<=" in pkg_2:
            ver_1 = get_version(pkg_1.split(">=").pop())
            ver_2 = get_version(pkg_2.split("<=").pop())
            if compare_versions(ver_1, ver_2) == 1:
            # if ver_1 > ver_2:
                return True

        if ">=" in pkg_1 and "<" in pkg_2:
            ver_1 = get_version(pkg_1.split(">=").pop())
            ver_2 = get_version(pkg_2.split("<").pop())
            if compare_versions(ver_1, ver_2) == 1:
            # if ver_1 > ver_2:
                return True

        if ">" in pkg_1 and "<=" in pkg_2:
            ver_1 = get_version(pkg_1.split(">").pop())
            ver_2 = get_version(pkg_2.split("<=").pop())
            if compare_versions(ver_1, ver_2) == 1:
            # if ver_1 > ver_2:
                return True

        if ">" in pkg_1 and "<" in pkg_2:
            ver_1 = get_version(pkg_1.split(">").pop())
            ver_2 = get_version(pkg_2.split("<").pop())
            if compare_versions(ver_1, ver_2) == 1:
            # if ver_1 > ver_2:
                return True

        if ">" in pkg_1 and "==" in pkg_2:
            ver_1 = get_version(pkg_1.split(">").pop())
            ver_2 = get_version(pkg_2.split("==").pop())
            if compare_versions(ver_1, ver_2) == 1:
            # if ver_1 > ver_2:
                return True

        if "<" in pkg_1 and "==" in pkg_2:
            ver_1 = get_version(pkg_1.split("<").pop())
            ver_2 = get_version(pkg_2.split("==").pop())
            if compare_versions(ver_1, ver_2) == -1:
            # if ver_1 < ver_2:
                return True
        
        if "==" in pkg_1 and "==" in pkg_2:
            ver_1 = get_version(pkg_1.split("==").pop())
            ver_2 = get_version(pkg_2.split("==").pop())
            if compare_versions(ver_1, ver_2) != 0:
            # if ver_1 != ver_2:
                return True

    return False


# 标记包含冲突依赖的自定义节点
def find_conflict(requirement_list: dict, conflict_package) -> dict:
    for requirement_name in requirement_list:
        requirements_path = requirement_list.get(requirement_name).get("requirements_path")
        requirements = requirement_list.get(requirement_name).get("requirements")
        missing_requirement = requirement_list.get(requirement_name).get("missing_requirement")
        has_conflict_package = False
        for k in conflict_package:
            for i in requirements:
                if k in i:
                    has_conflict_package = True
                    break

        requirement_list[requirement_name] = {"requirements_path": requirements_path, "requirements": requirements, "missing_requirement": missing_requirement, "has_conflict_package": has_conflict_package}

    return requirement_list


# 统计冲突依赖信息
def sum_conflict_notice(requirement_list: dict, conflict_package) -> list:
    content = []
    # 读取冲突的包名
    for i in conflict_package:
        conflict_pkg = i
        content.append(f"{conflict_pkg}:")
        # 读取依赖记录表
        for j in requirement_list:
            requirement_name = j

            # 查找自定义节点中的依赖是否包含冲突依赖
            for k in requirement_list.get(requirement_name).get("requirements"):
                if conflict_pkg == get_package_name(k):
                    content.append(f"- {requirement_name}: {k}")

        content.append("")

    return content


# 将内容写入文件中
def write_content_to_file(content: list, path: str) -> None:
    if len(content) == 0:
        return

    with open(path, "w") as f:
        for item in content:
            f.write(item + "\n")


# 找出需要安装依赖的自定义节点并将依赖表的路径进行记录
def sum_need_to_install(requirement_list: dict) -> list:
    path_list = []
    for i in requirement_list:
        if len(requirement_list.get(i).get("missing_requirement")) != 0:
            path_list.append(requirement_list.get(i).get("requirements_path"))
    
    for i in requirement_list:
        if requirement_list.get(i).get("has_conflict_package") is True:
            path_list.append(requirement_list.get(i).get("requirements_path"))
    
    return path_list


def main():
    lists = get_requirement_list(get_requirement_file(comfyui_path))
    lists = check_missing_requirement(lists)
    pkg_list = [] # 依赖列表
    conflict_package = [] # 冲突的依赖列表

    # 记录依赖
    for i in lists:
        for pkg_name in lists.get(i).get("requirements"):
            pkg_list.append(format_package_name(pkg_name))


    # 判断冲突依赖
    for i in pkg_list:
        for j in pkg_list:
            if get_package_name(i) in j and detect_conflict_package(i, j):
                conflict_package.append(i)

    # conflict_package = remove_duplicate(conflict_package)
    conflict_package = remove_duplicate([get_package_name(x) for x in conflict_package]) # 去除版本号并去重
    lists = find_conflict(lists, conflict_package) # 将有冲突依赖的自定义节点进行标记
    notice = sum_conflict_notice(lists, conflict_package)
    path_list = remove_duplicate(sum_need_to_install(lists))
    write_content_to_file(notice, term_sd_notice_path)
    write_content_to_file(path_list, term_sd_need_install_requirement_path)



comfyui_path = os.path.join("${path}")
term_sd_notice_path = os.path.join("${term_sd_task_path}", "comfyui_has_conflict_requirement_notice.sh")
term_sd_need_install_requirement_path = os.path.join("${term_sd_task_path}", "comfyui_depend_path_list.sh")

main()
EOF
}

# 回滚 Numpy 版本
fallback_numpy_version() {
    local np_major_ver

    term_sd_echo "检测 Numpy 版本中"
    np_major_ver=$(term_sd_python -c "$(py_get_numpy_ver)")

    if (( np_major_ver > 1 )); then
        term_sd_echo "检测到 Numpy 版本过高, 尝试回退版本中"
        install_python_package numpy==1.26.4
        if [[ "$?" == 0 ]]; then
            term_sd_echo "Numpy 版本回退成功"
        else
            term_sd_echo "Numpy 版本回退失败"
        fi
    else
        term_sd_echo "Numpy 无版本问题"
    fi
}

# 获取 Numpy 大版本(Python)
py_get_numpy_ver() {
    cat<<EOF
import importlib.metadata
from importlib.metadata import version
try:
    print(version("numpy").split(".")[0])
except importlib.metadata.PackageNotFoundError:
    print("-1")
EOF
}

# 修复 PyTorch 的 libomp 问题
fix_pytorch() {
    if is_windows_platform; then
        term_sd_echo "检测 PyTorch 的 libomp 问题"
        python -c "$(py_fix_pytorch)"
    fi
}

# 修复 PyTorch 的 libomp 问题(Python)
py_fix_pytorch() {
    cat<<EOF
import importlib.util
import shutil
import os
import ctypes
import logging


torch_spec = importlib.util.find_spec("torch")
for folder in torch_spec.submodule_search_locations:
    lib_folder = os.path.join(folder, "lib")
    test_file = os.path.join(lib_folder, "fbgemm.dll")
    dest = os.path.join(lib_folder, "libomp140.x86_64.dll")
    if os.path.exists(dest):
        break

    with open(test_file, 'rb') as f:
        contents = f.read()
        if b"libomp140.x86_64.dll" not in contents:
            break
    try:
        mydll = ctypes.cdll.LoadLibrary(test_file)
    except FileNotFoundError as e:
        logging.warning("检测到 PyTorch 版本存在 libomp 问题, 进行修复")
        shutil.copyfile(os.path.join(lib_folder, "libiomp5md.dll"), dest)
EOF
}

# 验证内核依赖完整新
validate_requirements() {
    local path=$@
    local status
    local current_path=$(pwd)
    local dir_path

    term_sd_echo "检测 ${TERM_SD_MANAGE_OBJECT} 内核依赖完整性中"
    dir_path=$(dirname "${path}")
    path=$(convert_path_format "${path}")
    status=$(term_sd_python -c "$(py_validate_requirements "${path}")")

    if [[ "${status}" == "False" ]]; then
        term_sd_echo "检测到 ${TERM_SD_MANAGE_OBJECT} 依赖有缺失, 将安装依赖"
        cd "${dir_path}"
        install_python_package -r "${path}"
        if [[ "$?" == 0 ]]; then
            term_sd_echo "${TERM_SD_MANAGE_OBJECT} 依赖安装成功"
        else
            term_sd_echo "${TERM_SD_MANAGE_OBJECT} 依赖安装失败"
        fi
    else
        term_sd_echo "${TERM_SD_MANAGE_OBJECT} 无缺失依赖"
    fi

    cd "${current_path}"
    term_sd_echo "检测 ${TERM_SD_MANAGE_OBJECT} 内核依赖完整性检测结束"
}


# 验证是否存在未安装的依赖(Python)
py_validate_requirements() {
    local path=$@

    cat<<EOF
import os
import re
import importlib.metadata



# 判断 2 个版本的大小, 前面大返回 1, 后面大返回 -1, 相同返回 0
def compare_versions(version1, version2):
    nums1 = version1.split(".")  # 将版本号 1 拆分成数字列表
    nums2 = version2.split(".")  # 将版本号 2 拆分成数字列表

    for i in range(max(len(nums1), len(nums2))):
        num1 = int(nums1[i]) if i < len(nums1) else 0  # 如果版本号 1 的位数不够, 则补 0
        num2 = int(nums2[i]) if i < len(nums2) else 0  # 如果版本号 2 的位数不够, 则补 0

        if num1 == num2:
            continue
        elif num1 > num2:
            return 1  # 版本号 1 更大
        else:
            return -1  # 版本号 2 更大

    return 0  # 版本号相同


# 获取包版本号
def get_pkg_ver_from_lib(pkg_name: str) -> str:
    try:
        ver = importlib.metadata.version(pkg_name)
    except:
        ver = None

    if ver is None:
        try:
            ver = importlib.metadata.version(pkg_name.lower())
        except:
            ver = None       

    if ver is None:
        try:
            ver = importlib.metadata.version(pkg_name.replace("_", "-"))
        except:
            ver = None       

    return ver


# 确认是否安装某个软件包
def is_installed(package: str) -> bool:
    #
    # This function was adapted from code written by vladimandic: https://github.com/vladmandic/automatic/commits/master
    #

    # Remove brackets and their contents from the line using regular expressions
    # e.g., diffusers[torch]==0.10.2 becomes diffusers==0.10.2
    package = re.sub(r'\[.*?\]', '', package)

    try:
        pkgs = [
            p
            for p in package.split()
            if not p.startswith('-') and not p.startswith('=')
        ]
        pkgs = [
            p.split('/')[-1] for p in pkgs
        ]   # get only package name if installing from URL

        for pkg in pkgs:
            if '>=' in pkg:
                pkg_name, pkg_version = [x.strip() for x in pkg.split('>=')]
            elif '==' in pkg:
                pkg_name, pkg_version = [x.strip() for x in pkg.split('==')]
            else:
                pkg_name, pkg_version = pkg.strip(), None

            # 获取本地 Python 软件包信息
            version = get_pkg_ver_from_lib(pkg_name)

            if version is not None:
                # 判断版本是否符合要求
                if pkg_version is not None:
                    if '>=' in pkg:
                        # ok = version >= pkg_version
                        if compare_versions(version, pkg_version) == 1 or compare_versions(version, pkg_version) == 0:
                            ok = True
                        else:
                            ok = False
                    elif '<=' in pkg:
                        # ok = version <= pkg_version
                        if compare_versions(version, pkg_version) == -1 or compare_versions(version, pkg_version) == 0:
                            ok = True
                        else:
                            ok = False
                    elif '>' in pkg:
                        # ok = version > pkg_version
                        if compare_versions(version, pkg_version) == 1:
                            ok = True
                        else:
                            ok = False
                    elif '<' in pkg:
                        # ok = version < pkg_version
                        if compare_versions(version, pkg_version) == -1:
                            ok = True
                        else:
                            ok = False
                    else:
                        # ok = version == pkg_version
                        if compare_versions(version, pkg_version) == 0:
                            ok = True
                        else:
                            ok = False

                    if not ok:
                        return False
            else:
                return False

        return True
    except ModuleNotFoundError:
        return False


# 验证是否存在未安装的依赖
def validate_requirements(requirements_file: str):
    with open(requirements_file, 'r', encoding='utf8') as f:
        lines = [
            line.strip()
            for line in f.readlines()
            if line.strip() != ''
            and not line.startswith("#")
            and not (line.startswith("-") and not line.startswith("--index-url "))
            and line is not None
            and "# skip_verify" not in line
        ]

        for line in lines:
            if line.startswith("--index-url "):
                continue

            if not is_installed(line):
                return False

    return True



print(validate_requirements("${path}"))
EOF
}

# 检查 onnxruntime-gpu 版本
check_onnxruntime_gpu_ver() {
    local status

    term_sd_echo "检测 onnxruntime-gpu 所支持的 CUDA 版本是否匹配 PyTorch 所支持的 CUDA 版本"
    status=$(term_sd_python -c "$(py_detect_onnxruntime_gpu_ver)")

    if [[ "${status}" == "cu118" ]]; then
        term_sd_echo "检测到 onnxruntime-gpu 所支持的 CUDA 版本 和 PyTorch 所支持的 CUDA 版本不匹配, 将执行重装操作"
        if term_sd_pip freeze | grep -q "onnxruntime-gpu"; then
            term_sd_echo "卸载原有 onnxruntime-gpu"
            term_sd_try term_sd_pip uninstall onnxruntime-gpu -y
        fi
        term_sd_echo "重新安装 onnxruntime-gpu"
        term_sd_try term_sd_pip install onnxruntime-gpu --no-cache-dir
        if [[ "$?" == 0 ]]; then
            term_sd_echo "重新安装 onnxruntime-gpu 成功"
        else
            term_sd_echo "重新安装 onnxruntime-gpu 失败, 这可能导致部分功能无法正常使用, 如使用反推模型无法正常调用 GPU 导致推理降速"
        fi
    elif [[ "${status}" == "cu121" ]]; then
        term_sd_echo "检测到 onnxruntime-gpu 所支持的 CUDA 版本 和 PyTorch 所支持的 CUDA 版本不匹配, 将执行重装操作"
        if term_sd_pip freeze | grep -q "onnxruntime-gpu"; then
            term_sd_echo "卸载原有 onnxruntime-gpu"
            term_sd_try term_sd_pip uninstall onnxruntime-gpu -y
        fi
        term_sd_echo "重新安装 onnxruntime-gpu"
        PIP_INDEX_URL="https://aiinfra.pkgs.visualstudio.com/PublicPackages/_packaging/onnxruntime-cuda-12/pypi/simple/" \
        PIP_EXTRA_INDEX_URL="https://aiinfra.pkgs.visualstudio.com/PublicPackages/_packaging/onnxruntime-cuda-12/pypi/simple" \
        term_sd_try term_sd_pip install onnxruntime-gpu --no-cache-dir
        if [[ "$?" == 0 ]]; then
            term_sd_echo "重新安装 onnxruntime-gpu 成功"
        else
            term_sd_echo "重新安装 onnxruntime-gpu 失败, 这可能导致部分功能无法正常使用, 如使用反推模型无法正常调用 GPU 导致推理降速"
        fi
    else
        term_sd_echo "onnxruntime-gpu 无版本问题"
    fi
}

# 检查 onnxruntime-gpu 版本(Python)
py_detect_onnxruntime_gpu_ver() {
    cat<<EOF
import re
import importlib.metadata
from pathlib import Path



# 获取记录 onnxruntime 版本的文件路径
def get_onnxruntime_version_file() -> str:
    package = "onnxruntime-gpu"
    try:
        util = [p for p in importlib.metadata.files(package) if "onnxruntime/capi/version_info.py" in str(p)][0]
        info_path = Path(util.locate()).as_posix()
    except importlib.metadata.PackageNotFoundError:
        info_path = None
    
    return info_path


# 获取 onnxruntime 支持的 CUDA 版本
def get_onnxruntime_support_cuda_version() -> str:
    ver_path = get_onnxruntime_version_file()
    try:
        with open(ver_path, "r") as f:
            for line in f:
                if "cuda_version" in line:
                    return line.strip()
            return None
    except:
        return None


# 截取版本号
def get_version(ver: str) -> str:
    return re.sub(r'[\'"]', '', ver).split("=").pop().strip()


# 判断版本
def compare_versions(version1: str, version2: str) -> str:
    nums1 = version1.split(".")  # 将版本号 1 拆分成数字列表
    nums2 = version2.split(".")  # 将版本号 2 拆分成数字列表

    for i in range(max(len(nums1), len(nums2))):
        num1 = int(nums1[i]) if i < len(nums1) else 0  # 如果版本号 1 的位数不够, 则补 0
        num2 = int(nums2[i]) if i < len(nums2) else 0  # 如果版本号 2 的位数不够, 则补 0

        if num1 == num2:
            continue
        elif num1 > num2:
            return 1  # 版本号 1 更大
        else:
            return -1  # 版本号 2 更大

    return 0  # 版本号相同


# 获取 Torch 的 CUDA 版本
def get_torch_cuda_ver() -> str:
    try:
        import torch
        torch_version = torch.__version__
        return torch_version
    except:
        return None


# 检测 Torch 中的 CUDA 版本是否大于 12.1
def torch_is_cuda12() -> bool:
    if "cu12" in get_torch_cuda_ver():
        return True
    else:
        return False


# 判断需要安装的 onnxruntime 版本
def need_install_ort_ver():
    # 检测是否安装了 Torch
    torch_ver = get_torch_cuda_ver()
    if torch_ver is None:
        return None

    # 检测是否安装了 onnxruntime-gpu
    onnxruntime_support_cuda_ver = get_onnxruntime_support_cuda_version()
    if onnxruntime_support_cuda_ver is None:
        return None
    
    onnxruntime_support_cuda_ver = get_version(onnxruntime_support_cuda_ver)

    # 判断 Torch 中的 CUDA 版本是否为 CUDA 12.1
    if "cu12" in torch_ver: # CUDA 12.1
        # 比较 onnxtuntime 支持的 CUDA 版本是否和 Torch 中所带的 CUDA 版本匹配
        if compare_versions(onnxruntime_support_cuda_ver, "12.0") == 1:
            return None
        else:
            return "cu121"
    else: # CUDA <= 11.8
        if compare_versions(onnxruntime_support_cuda_ver, "12.0") == -1:
            return None
        else:
            return "cu118"



print(need_install_ort_ver())
EOF
}