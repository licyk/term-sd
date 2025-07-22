def get_pytorch_version() -> str | None:
    '''获取 PyTorch 的版本号

    :return `str|None`: PyTorch 版本号
    '''
    try:
        import torch
        return torch.__version__
    except Exception as _:
        return None


def get_pytorch_type() -> str:
    '''获取 PyTorch 版本号对应的类型

    :return `str`: PyTorch 类型
    '''
    torch_ipex_legacy_ver_list = [
        '2.0.0a0+gite9ebda2',
        '2.1.0a0+git7bcf7da',
        '2.1.0a0+cxx11.abi',
        '2.0.1a0',
        '2.1.0.post0',
    ]
    torch_ver = get_pytorch_version()
    torch_type = torch_ver.split('+').pop()
    if torch_ver is None:
        return None

    if torch_ver in torch_ipex_legacy_ver_list:
        return 'ipex'

    if 'cu' in torch_type:
        return 'cuda'

    if 'rocm' in torch_type:
        return 'rocm'

    if 'xpu' in torch_type:
        return 'ipex'

    if 'cpu' in torch_type:
        return 'cpu'

    return 'cuda'


def main() -> None:
    '''主函数'''
    print(get_pytorch_type())


if __name__ == "__main__":
    main()
