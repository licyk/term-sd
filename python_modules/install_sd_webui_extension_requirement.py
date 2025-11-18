"""Stable Diffusion WebUI 扩展依赖安装器"""

import os
import argparse
from pathlib import Path

from sd_webui_all_in_one.env_check.sd_webui_extension_dependency_installer import install_extension_requirements
from sd_webui_all_in_one import logger


def get_args() -> argparse.Namespace:
    """获取命令行参数

    Returns:
        argparse.Namespace: 命令行参数命名空间
    """
    parser = argparse.ArgumentParser(description="Stable Diffusion WebUI 扩展依赖安装脚本")

    def normalized_filepath(filepath):
        return Path(filepath).absolute().as_posix()

    parser.add_argument(
        "--disable-extra-extensions",
        action="store_true",
        help="禁用额外 Stable Diffusion WebUI 扩展",
    )
    parser.add_argument(
        "--disable-all-extensions",
        action="store_true",
        help="禁用所有 Stable Diffusion WebUI 扩展",
    )
    parser.add_argument(
        "--sd-webui-base-path",
        type=normalized_filepath,
        default=os.getcwd(),
        help="Stable Diffusion WebUI 根目录",
    )
    return parser.parse_args()


def main() -> None:
    """主函数"""
    args = get_args()
    base_path = args.sd_webui_base_path
    if base_path is None:
        logger.error("未通过 --sd-webui-base-path 参数指定 Stable Diffusion WebUI 路径")
        return

    install_extension_requirements(
        sd_webui_base_path=Path(base_path),
        arg_disable_extra_extensions=args.disable_extra_extensions,
        arg_disable_all_extensions=args.disable_all_extensions,
    )


if __name__ == "__main__":
    main()
