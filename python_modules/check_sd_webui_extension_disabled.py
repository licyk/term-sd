import os
import pathlib
import json
import argparse
from pathlib import Path


# 参数输入
def get_args():
    parser = argparse.ArgumentParser()
    normalized_filepath = lambda filepath: str(Path(filepath).absolute().as_posix())

    parser.add_argument(
        "--config-path",
        type=normalized_filepath,
        default=None,
        help="SD WebUI 配置文件路径",
    )
    parser.add_argument("--extension", type=str, default=None, help="SD WebUI 插件名称")

    return parser.parse_args()


def get_key_map(file_path):
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


if __name__ == "__main__":
    args = get_args()
    json_path = args.config_path
    key_name = "disabled_extensions"
    extension_name = args.extension

    if search_key(get_key_map(json_path), key_name, extension_name):
        print(True)
    else:
        print(False)
