import os
import re
import argparse
import importlib.metadata
from pathlib import Path



# 参数输入
def get_args():
    parser = argparse.ArgumentParser()
    normalized_filepath = lambda filepath: str(Path(filepath).absolute().as_posix())

    parser.add_argument("--comfyui-path", type = normalized_filepath, default = None, help = "ComfyUI 路径")
    parser.add_argument("--conflict-depend-notice-path", type = normalized_filepath, default = None, help = "保存 ComfyUI 扩展依赖冲突信息的文件路径")
    parser.add_argument("--requirement-list-path", type = normalized_filepath, default = None, help = "保存 ComfyUI 需要安装扩展依赖的路径列表")

    return parser.parse_args()


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
    for requirement_name in requirement_list:
        requirements_path = requirement_list.get(requirement_name).get("requirements_path")
        requirements = [] # Python 包名列表
        try:
            with open(requirements_path, "r", encoding = "utf8") as f:
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
            # 去除从 Git 链接安装的软件包后面的 .git
            pkg = pkg.split(".git")[0] if pkg.endswith(".git") else pkg
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
    for requirement_name in requirement_list:
        requirements_path = requirement_list.get(requirement_name).get("requirements_path")
        requirements = requirement_list.get(requirement_name).get("requirements")

        missing_requirement = []
        for pkg in requirements:
            if not is_installed(pkg.split()[0].strip()):
                missing_requirement.append(pkg)

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
        # 除去从 Git 链接中的 .git 后缀
        pkg.split(".git")[0] if pkg.endswith(".git") else pkg
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
    nums1 = re.sub(r'[a-zA-Z]+', '', version1).replace('+', '.').split(".")  # 将版本号 1 拆分成数字列表
    nums2 = re.sub(r'[a-zA-Z]+', '', version2).replace('+', '.').split(".")  # 将版本号 2 拆分成数字列表

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

    # 进行 2 次循环, 第 2 次循环时交换版本后再进行判断
    for i in range(2):
        if i == 1:
            tmp = pkg_1
            pkg_1 = pkg_2
            pkg_2 = tmp

        # >=, <=
        if ">=" in pkg_1 and "<=" in pkg_2:
            ver_1 = get_version(pkg_1.split(">=").pop())
            ver_2 = get_version(pkg_2.split("<=").pop())
            if compare_versions(ver_1, ver_2) == 1:
            # if ver_1 > ver_2:
                return True

        # >=, <
        if ">=" in pkg_1 and "<" in pkg_2 and "=" not in pkg_2:
            ver_1 = get_version(pkg_1.split(">=").pop())
            ver_2 = get_version(pkg_2.split("<").pop())
            if compare_versions(ver_1, ver_2) == 0 or compare_versions(ver_1, ver_2) == 1:
            # if ver_1 > ver_2:
                return True

        # >, <=
        if ">" in pkg_1 and "=" not in pkg_1 and "<=" in pkg_2:
            ver_1 = get_version(pkg_1.split(">").pop())
            ver_2 = get_version(pkg_2.split("<=").pop())
            if compare_versions(ver_1, ver_2) == 0 or compare_versions(ver_1, ver_2) == 1:
            # if ver_1 > ver_2:
                return True

        # >, <
        if ">" in pkg_1 and "=" not in pkg_1 and "<" in pkg_2 and "=" not in pkg_2:
            ver_1 = get_version(pkg_1.split(">").pop())
            ver_2 = get_version(pkg_2.split("<").pop())
            if compare_versions(ver_1, ver_2) == 0 or compare_versions(ver_1, ver_2) == 1:
            # if ver_1 > ver_2:
                return True

        # >, ==
        if ">" in pkg_1 and "=" not in pkg_1 and "==" in pkg_2:
            ver_1 = get_version(pkg_1.split(">").pop())
            ver_2 = get_version(pkg_2.split("==").pop())
            if compare_versions(ver_1, ver_2) == 1 or compare_versions(ver_1, ver_2) == 0:
            # if ver_1 > ver_2:
                return True

        # >=, ==
        if ">=" in pkg_1 and "==" in pkg_2:
            ver_1 = get_version(pkg_1.split(">").pop())
            ver_2 = get_version(pkg_2.split("==").pop())
            if compare_versions(ver_1, ver_2) == 1 or compare_versions(ver_1, ver_2) == -1:
            # if ver_1 > ver_2:
                return True

        # <, ==
        if "<" in pkg_1 and "=" not in pkg_1 and "==" in pkg_2:
            ver_1 = get_version(pkg_1.split("<").pop())
            ver_2 = get_version(pkg_2.split("==").pop())
            if compare_versions(ver_1, ver_2) == -1 or compare_versions(ver_1, ver_2) == 0:
            # if ver_1 < ver_2:
                return True

        # <=, ==
        if "<=" in pkg_1 and "==" in pkg_2:
            ver_1 = get_version(pkg_1.split(">").pop())
            ver_2 = get_version(pkg_2.split("==").pop())
            if compare_versions(ver_1, ver_2) == 1 or compare_versions(ver_1, ver_2) == -1:
            # if ver_1 > ver_2:
                return True

        # ==, ==
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
        for pkg_1 in conflict_package:
            for pkg_2 in requirements:
                if pkg_1 == get_package_name(format_package_name(pkg_2)):
                    has_conflict_package = True
                    break

        requirement_list[requirement_name] = {"requirements_path": requirements_path, "requirements": requirements, "missing_requirement": missing_requirement, "has_conflict_package": has_conflict_package}

    return requirement_list


# 统计冲突依赖信息
def sum_conflict_notice(requirement_list: dict, conflict_package) -> list:
    content = []
    # 读取冲突的包名
    for conflict_pkg in conflict_package:
        content.append(f"{conflict_pkg}:")
        # 读取依赖记录表
        for requirement_name in requirement_list:

            # 查找自定义节点中的依赖是否包含冲突依赖
            for pkg in requirement_list.get(requirement_name).get("requirements"):
                if conflict_pkg == get_package_name(format_package_name(pkg)):
                    content.append(f" - {requirement_name}: {pkg}")

        content.append("")

    content = content[:-1] if len(content) > 0 and content[-1] == "" else content
    return content


# 将内容写入文件中
def write_content_to_file(content: list, path: str) -> None:
    if len(content) == 0:
        return

    with open(path, "w", encoding = "utf8") as f:
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



if __name__ == "__main__":
    args = get_args()
    comfyui_path = args.comfyui_path
    term_sd_notice_path = args.conflict_depend_notice_path
    term_sd_need_install_requirement_path = args.requirement_list_path

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
