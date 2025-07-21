import re
import argparse
from importlib.metadata import version


def get_args() -> argparse.Namespace:
    """获取命令行参数

    :return `argparse.Namespace`: 命令行参数命名空间
    """
    parser = argparse.ArgumentParser()

    parser.add_argument("--uv-mininum-ver", type=str,
                        default="0.1", help="uv 最低版本")

    return parser.parse_args()


def compare_versions(version1: str, version2: str) -> int:
    '''对比两个版本号大小

    :param version1(str): 第一个版本号
    :param version2(str): 第二个版本号
    :return int: 版本对比结果, 1 为第一个版本号大, -1 为第二个版本号大, 0 为两个版本号一样
    '''
    # 将版本号拆分成数字列表
    try:
        nums1 = (
            re.sub(r'[a-zA-Z]+', '', version1)
            .replace('-', '.')
            .replace('_', '.')
            .replace('+', '.')
            .split('.')
        )
        nums2 = (
            re.sub(r'[a-zA-Z]+', '', version2)
            .replace('-', '.')
            .replace('_', '.')
            .replace('+', '.')
            .split('.')
        )
    except Exception as _:
        return 0

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


def is_uv_need_update() -> bool:
    arg = get_args()
    try:
        uv_ver = version("uv")
    except Exception as _:
        return True

    if compare_versions(uv_ver, arg.uv_mininum_ver) < 0:
        return True

    return False


if __name__ == "__main__":
    print(is_uv_need_update())
