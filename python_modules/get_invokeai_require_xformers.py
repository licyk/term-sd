from sd_webui_all_in_one.manager.invokeai import InvokeAIComponentManager


def main() -> None:
    """主函数"""
    invokeai = InvokeAIComponentManager()
    print(invokeai.get_xformers_for_invokeai())


if __name__ == "__main__":
    main()
