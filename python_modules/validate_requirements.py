"""运行环境检查"""

import os
import sys
import argparse
from pathlib import Path


def get_args() -> argparse.Namespace:
    """获取命令行参数输入参数输入"""
    parser = argparse.ArgumentParser(description="运行环境检查")

    def normalized_filepath(filepath):
        return str(Path(filepath).absolute().as_posix())

    parser.add_argument(
        "--requirement-path",
        type=normalized_filepath,
        default=None,
        help="依赖文件路径",
    )
    parser.add_argument("--debug-mode", action="store_true", help="显示调试信息")

    return parser.parse_args()


COMMAND_ARGS = get_args()
if COMMAND_ARGS.debug_mode:
    os.environ["SD_WEBUI_ALL_IN_ONE_LOGGER_LEVEL"] = "10"

from sd_webui_all_in_one import logger
from sd_webui_all_in_one.env_check.fix_dependencies import validate_requirements


def main() -> None:
    requirement_path = COMMAND_ARGS.requirement_path

    if not os.path.isfile(requirement_path):
        logger.error("依赖文件未找到, 无法检查运行环境")
        sys.exit(1)

    logger.debug("检测运行环境中")
    print(validate_requirements(requirement_path))
    logger.debug("环境检查完成")


if __name__ == "__main__":
    main()
