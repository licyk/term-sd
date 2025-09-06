import argparse
import json
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

    return parser.parse_args()


def is_sd_webui_disable_all_extension(path: str) -> bool:
    settings = {}

    try:
        with open(path, "r", encoding="utf8") as file:
            settings = json.load(file)
    except:
        pass

    disable_all_extensions = settings.get("disable_all_extensions", "none")
    if disable_all_extensions != "none":
        return True
    else:
        return False


if __name__ == "__main__":
    args = get_args()
    path = args.config_path
    print(is_sd_webui_disable_all_extension(path))
