import os
import json
import argparse
from pathlib import Path



def get_args():
    parser = argparse.ArgumentParser()
    normalized_filepath = lambda filepath: str(Path(filepath).absolute().as_posix())

    parser.add_argument("--config-path", type = normalized_filepath, default = None, help = "SD WebUI 配置文件路径")
    parser.add_argument("--extension", type = str, default = None, help = "SD WebUI 插件名称")
    parser.add_argument("--status", type = str, default = None, help = "设置 SD WebUI 插件的状态")

    return parser.parse_args()


def get_key_map(file_path):

    file_name = Path(file_path)
    if os.path.exists(file_name):
        try:
            with open(file_name, "r", encoding = "utf8") as file:
                data = json.load(file)
        except Exception:
            # json 文件格式出现问题
            data = {}
    else:
        data = {}

    return data


def check_json(file_path):
    file_name = Path(file_path)
    if os.path.exists(file_name):
        try:
            with open(file_name, "r", encoding = "utf8") as file:
                _ = json.load(file)
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
    with open(filename, "w", encoding = "utf8") as file:
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



if __name__ == "__main__":
    args = get_args()
    json_path = args.config_path
    extension_name = args.extension
    status = args.status
    status = True if status == "True" else False

    set_extension_status(json_path, extension_name, status)