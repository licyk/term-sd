import os
import re
import argparse
import importlib.metadata
from pathlib import Path


# 参数输入
def get_args():
    parser = argparse.ArgumentParser()
    normalized_filepath = lambda filepath: str(Path(filepath).absolute().as_posix())

    parser.add_argument("--requirement-path", type = normalized_filepath, default = None, help = "ComfyUI 路径")

    return parser.parse_args()


# 判断 2 个版本的大小, 前面大返回 1, 后面大返回 -1, 相同返回 0
def compare_versions(version1, version2):
    nums1 = re.sub(r'[a-zA-Z]+', '', version1).split(".")  # 将版本号 1 拆分成数字列表
    nums2 = re.sub(r'[a-zA-Z]+', '', version2).split(".")  # 将版本号 2 拆分成数字列表

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
            # 去除从 Git 链接安装的软件包后面的 .git
            pkg = pkg.split(".git")[0] if pkg.endswith(".git") else pkg
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
    with open(requirements_file, "r", encoding = "utf8") as f:
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

            if not is_installed(line.split()[0].strip()):
                return False

    return True



if __name__ == "__main__":
    args = get_args()
    path = args.requirement_path
    print(validate_requirements(path))