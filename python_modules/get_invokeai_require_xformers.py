from importlib.metadata import requires


def get_package_name(package: str) -> str:
    """从 Python 包版本声明中获取包名

    :param package`(str)`: Python 包版本声明
    :return `str`: Python 包名
    """
    return (
        package.split("~=")[0]
        .split("===")[0]
        .split("!=")[0]
        .split("<=")[0]
        .split(">=")[0]
        .split("<")[0]
        .split(">")[0]
        .split("==")[0]
    )


def get_pytorch() -> str:
    """获取 InvokeAI 所依赖的 PyTorch 包版本声明

    :param `str`: PyTorch 包版本声明
    """
    pytorch_ver = []
    try:
        invokeai_requires = requires("invokeai")
    except Exception as _:
        invokeai_requires = []

    xformers_added = False

    for require in invokeai_requires:
        require = require.split(";")[0].strip()
        package_name = get_package_name(require)

        if package_name == "xformers" and not xformers_added:
            pytorch_ver.append(require)
            xformers_added = True

    return " ".join([str(x).strip() for x in pytorch_ver])


def main() -> None:
    """主函数"""
    print(get_pytorch())


if __name__ == "__main__":
    main()
