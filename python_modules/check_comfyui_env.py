"""ComfyUI 运行环境检查"""

import os
import sys
import argparse
from pathlib import Path


def get_args() -> argparse.Namespace:
    """获取命令行参数输入参数输入"""
    parser = argparse.ArgumentParser(description="ComfyUI 运行环境检查")

    def normalized_filepath(filepath):
        return Path(filepath).absolute()

    parser.add_argument("--comfyui-path", type=normalized_filepath, default=None, help="ComfyUI 路径")
    parser.add_argument(
        "--conflict-depend-notice-path",
        type=normalized_filepath,
        default=None,
        help="保存 ComfyUI 扩展依赖冲突信息的文件路径",
    )
    parser.add_argument(
        "--requirement-list-path",
        type=normalized_filepath,
        default=None,
        help="保存 ComfyUI 需要安装扩展依赖的路径列表",
    )
    parser.add_argument("--debug-mode", action="store_true", help="显示调试信息")

    return parser.parse_args()


COMMAND_ARGS = get_args()
if COMMAND_ARGS.debug_mode:
    os.environ["MANAGER_LOGGER_LEVEL"] = "10"

os.environ["MANAGER_LOGGER_NAME"] = "Term-SD"
os.environ["MANAGER_LOGGER_COLOR"] = "1"

from sd_webui_all_in_one.env_check.comfyui_env_analyze import process_comfyui_env_analysis, display_comfyui_environment_dict, display_check_result, logger


def write_content_to_file(content: list[str] | str, path: str | Path) -> None:
    """将内容列表写入到文件中

    参数:
        content (`list`):
            内容列表

        path (`str`, `Path`):
            保存内容的路径
    """
    if len(content) == 0:
        return

    dir_path = os.path.dirname(path)
    if not os.path.exists(dir_path):
        os.makedirs(dir_path, exist_ok=True)

    try:
        logger.debug("写入文件到 %s", path)
        with open(path, "w", encoding="utf-8") as f:
            if isinstance(content, list):
                for item in content:
                    f.write(item + "\n")
            else:
                f.write(content)
    except Exception as e:
        logger.error("写入文件到 %s 时出现了错误: %s", path, e)


def main() -> None:
    """主函数"""
    comfyui_root_path = COMMAND_ARGS.comfyui_path
    comfyui_conflict_notice = COMMAND_ARGS.conflict_depend_notice_path
    comfyui_requirement_path = COMMAND_ARGS.requirement_list_path

    if not os.path.exists(os.path.join(comfyui_root_path, "requirements.txt")):
        logger.error("ComfyUI 依赖文件缺失, 请检查 ComfyUI 是否安装完整")
        sys.exit(1)

    if not os.path.exists(os.path.join(comfyui_root_path, "custom_nodes")):
        logger.error("ComfyUI 自定义节点文件夹未找到, 请检查 ComfyUI 是否安装完整")
        sys.exit(1)

    if not comfyui_conflict_notice or not comfyui_requirement_path:
        logger.error("未配置 --conflict-depend-notice-path / --requirement-list-path, 无法进行环境检测")
        sys.exit(1)

    env_data, req_list, conflict_info = process_comfyui_env_analysis(comfyui_root_path)
    write_content_to_file(conflict_info, comfyui_conflict_notice)
    write_content_to_file(req_list, comfyui_requirement_path)
    if COMMAND_ARGS.debug_mode:
        display_comfyui_environment_dict(env_data)
        display_check_result(req_list, conflict_info)
    logger.debug("ComfyUI 环境检查完成")


if __name__ == "__main__":
    main()
