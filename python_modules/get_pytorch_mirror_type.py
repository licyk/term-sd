"""获取 InvokeAI 需要的 PyTorch 镜像源类型"""

import argparse
from sd_webui_all_in_one.manager.invokeai import InvokeAIComponentManager


def get_args() -> argparse.Namespace:
    """获取命令行参数

    :return `argparse.Namespace`: 命令行参数命名空间
    """
    parser = argparse.ArgumentParser()

    parser.add_argument("--device-type", type=str, default="cuda", help="显卡类型")

    return parser.parse_args()


def main() -> None:
    """主函数"""
    arg = get_args()
    invokeai = InvokeAIComponentManager()
    print(invokeai.get_pytorch_mirror_type_for_ivnokeai(arg.device_type))


if __name__ == "__main__":
    main()
