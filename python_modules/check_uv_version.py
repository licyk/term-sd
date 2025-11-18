import argparse
from importlib.metadata import version
from sd_webui_all_in_one.package_analyzer.py_ver_cmp import PyWhlVersionComparison


def get_args() -> argparse.Namespace:
    """获取命令行参数

    :return `argparse.Namespace`: 命令行参数命名空间
    """
    parser = argparse.ArgumentParser()

    parser.add_argument("--uv-mininum-ver", type=str, default="0.1", help="uv 最低版本")

    return parser.parse_args()


def is_uv_need_update() -> bool:
    arg = get_args()
    try:
        uv_ver = version("uv")
    except Exception as _:
        return True

    if PyWhlVersionComparison(uv_ver) < PyWhlVersionComparison(arg.uv_mininum_ver):
        return True

    return False


if __name__ == "__main__":
    print(is_uv_need_update())
