"""获取 PyTorch 类型"""

from sd_webui_all_in_one.pytorch_mirror import get_env_pytorch_type

def main() -> None:
    """主函数"""
    print(get_env_pytorch_type())


if __name__ == "__main__":
    main()
