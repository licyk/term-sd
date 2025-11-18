import argparse
from importlib.metadata import version
from sd_webui_all_in_one.package_analyzer.py_ver_cmp import PyWhlVersionComparison


def get_args() -> argparse.Namespace:
    """获取命令行参数

    :return `argparse.Namespace`: 命令行参数命名空间
    """
    parser = argparse.ArgumentParser()

    parser.add_argument("--pip-mininum-ver", type=str, default="25.0", help="Pip 最低版本")

    return parser.parse_args()


def need_upgrade_pip_ver() -> bool:
    arg = get_args()
    try:
        pip_ver = version("pip")
    except Exception as _:
        return False

    if PyWhlVersionComparison(pip_ver) < PyWhlVersionComparison(arg.pip_mininum_ver):
        return True

    return False


if __name__ == "__main__":
    print(need_upgrade_pip_ver())
