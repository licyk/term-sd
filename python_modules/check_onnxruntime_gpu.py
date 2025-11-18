import argparse
from sd_webui_all_in_one.env_check.onnxruntime_gpu_check import need_install_ort_ver


def get_args() -> argparse.Namespace:
    """获取命令行参数

    :return `argparse.Namespace`: 命令行参数命名空间
    """
    parser = argparse.ArgumentParser()

    parser.add_argument(
        "--ignore-ort-install",
        action="store_true",
        help="忽略 onnxruntime-gpu 未安装的状态, 强制进行检查",
    )

    return parser.parse_args()


if __name__ == "__main__":
    arg = get_args()
    print(need_install_ort_ver(not arg.ignore_ort_install))
