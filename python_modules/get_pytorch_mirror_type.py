import re
import argparse
import subprocess
from importlib.metadata import requires
from typing import Literal


DeviceType = Literal["cuda", "rocm", "xpu", "cpu"]


def get_args() -> argparse.Namespace:
    """获取命令行参数

    :return `argparse.Namespace`: 命令行参数命名空间
    """
    parser = argparse.ArgumentParser()

    parser.add_argument("--device-type", type=str,
                        default="cuda", help="显卡类型")

    return parser.parse_args()


def version_increment(version: str) -> str:
    '''增加版本号大小

    :param version`(str)`: 初始版本号
    :return `str`: 增加后的版本号
    '''
    version = ''.join(re.findall(r'\d|\.', version))
    ver_parts = list(map(int, version.split('.')))
    ver_parts[-1] += 1

    for i in range(len(ver_parts) - 1, 0, -1):
        if ver_parts[i] == 10:
            ver_parts[i] = 0
            ver_parts[i - 1] += 1

    return '.'.join(map(str, ver_parts))


def version_decrement(version: str) -> str:
    '''减小版本号大小

    :param version`(str)`: 初始版本号
    :return `str`: 减小后的版本号
    '''
    version = ''.join(re.findall(r'\d|\.', version))
    ver_parts = list(map(int, version.split('.')))
    ver_parts[-1] -= 1

    for i in range(len(ver_parts) - 1, 0, -1):
        if ver_parts[i] == -1:
            ver_parts[i] = 9
            ver_parts[i - 1] -= 1

    while len(ver_parts) > 1 and ver_parts[0] == 0:
        ver_parts.pop(0)

    return '.'.join(map(str, ver_parts))


def has_version(version: str) -> bool:
    '''判断包名是否包含版本号

    :param version`(str)`: Python 包名
    :return `bool`: 包名包含版本号时返回`True`
    '''
    return version != (
        version
        .replace('~=', '')
        .replace('===', '')
        .replace('!=', '')
        .replace('<=', '')
        .replace('>=', '')
        .replace('<', '')
        .replace('>', '')
        .replace('==', '')
    )


def get_package_name(package: str) -> str:
    '''从 Python 包版本声明中获取包名

    :param package`(str)`: Python 包版本声明
    :return `str`: Python 包名
    '''
    return (
        package
        .split('~=')[0]
        .split('===')[0]
        .split('!=')[0]
        .split('<=')[0]
        .split('>=')[0]
        .split('<')[0]
        .split('>')[0]
        .split('==')[0]
    )


def get_package_version(package: str) -> str:
    '''从 Python 包版本声明中获取版本号

    :param package`(str)`: Python 包版本声明
    :return `str`: Python 包版本号
    '''
    return (
        package
        .split('~=').pop()
        .split('===').pop()
        .split('!=').pop()
        .split('<=').pop()
        .split('>=').pop()
        .split('<').pop()
        .split('>').pop()
        .split('==').pop()
    )


def get_invokeai_require_torch_version() -> str:
    '''获取 InvokeAI 依赖的 PyTorch 版本

    :return `str`: PyTorch 版本
    '''
    try:
        invokeai_requires = requires('invokeai')
    except Exception as _:
        return '2.2.2'

    torch_version = 'torch==2.2.2'

    for require in invokeai_requires:
        if get_package_name(require) == 'torch' and has_version(require):
            torch_version = require.split(';')[0]
            break

    if torch_version.startswith('torch>') and not torch_version.startswith('torch>='):
        return version_increment(get_package_version(torch_version))
    elif torch_version.startswith('torch<') and not torch_version.startswith('torch<='):
        return version_decrement(get_package_version(torch_version))
    elif torch_version.startswith('torch!='):
        return version_increment(get_package_version(torch_version))
    else:
        return get_package_version(torch_version)


def compare_versions(version1: str, version2: str) -> int:
    '''对比两个版本号大小

    :param version1(str): 第一个版本号
    :param version2(str): 第二个版本号
    :return int: 版本对比结果, 1 为第一个版本号大, -1 为第二个版本号大, 0 为两个版本号一样
    '''
    # 将版本号拆分成数字列表
    try:
        nums1 = (
            re.sub(r'[a-zA-Z]+', '', version1)
            .replace('-', '.')
            .replace('_', '.')
            .replace('+', '.')
            .split('.')
        )
        nums2 = (
            re.sub(r'[a-zA-Z]+', '', version2)
            .replace('-', '.')
            .replace('_', '.')
            .replace('+', '.')
            .split('.')
        )
    except Exception as _:
        return 0

    for i in range(max(len(nums1), len(nums2))):
        num1 = int(nums1[i]) if i < len(nums1) else 0  # 如果版本号 1 的位数不够, 则补 0
        num2 = int(nums2[i]) if i < len(nums2) else 0  # 如果版本号 2 的位数不够, 则补 0

        if num1 == num2:
            continue
        elif num1 > num2:
            return 1  # 版本号 1 更大
        else:
            return -1  # 版本号 2 更大

    return 0  # 版本号相同


def get_cuda_comp_cap() -> float:
    '''
    Returns float of CUDA Compute Capability using nvidia-smi  
    Returns 0.0 on error  
    CUDA Compute Capability  
    ref https://developer.nvidia.com/cuda-gpus  
    ref https://en.wikipedia.org/wiki/CUDA  
    Blackwell consumer GPUs should return 12.0 data-center GPUs should return 10.0

    :return `float`: Comp Cap 版本
    '''
    try:
        return max(map(float, subprocess.check_output(['nvidia-smi', '--query-gpu=compute_cap', '--format=noheader,csv'], text=True).splitlines()))
    except Exception as _:
        return 0.0


def get_cuda_version() -> float:
    '''获取驱动支持的 CUDA 版本

    :return `float`: CUDA 支持的版本
    '''
    try:
        # 获取 nvidia-smi 输出
        output = subprocess.check_output(['nvidia-smi', '-q'], text=True)
        match = re.search(r'CUDA Version\s+:\s+(\d+\.\d+)', output)
        if match:
            return float(match.group(1))
        return 0.0
    except Exception as _:
        return 0.0


def get_pytorch_mirror_type_cuda(torch_ver: str) -> str:
    '''获取 CUDA 类型的 PyTorch 镜像源类型

    :param torch_ver`(str)`: PyTorch 版本
    :return `str`: CUDA 类型的 PyTorch 镜像源类型
    '''
    # cu118: 2.0.0 ~ 2.4.0
    # cu121: 2.1.1 ~ 2.4.0
    # cu124: 2.4.0 ~ 2.6.0
    # cu126: 2.6.0 ~ 2.7.1
    # cu128: 2.7.0 ~ 2.7.1
    # cu129: 2.8.0 ~
    cuda_comp_cap = get_cuda_comp_cap()
    cuda_support_ver = get_cuda_version()

    if compare_versions(torch_ver, '2.0.0') == -1:
        # torch < 2.0.0: default cu11x
        return 'other'
    if compare_versions(torch_ver, '2.0.0') >= 0 and compare_versions(torch_ver, '2.3.1') == -1:
        # 2.0.0 <= torch < 2.3.1: default cu118
        return 'cu118'
    if compare_versions(torch_ver, '2.3.0') >= 0 and compare_versions(torch_ver, '2.4.1') == -1:
        # 2.3.0 <= torch < 2.4.1: default cu121
        if compare_versions(str(int(cuda_support_ver * 10)), 'cu121') < 0:
            if compare_versions(str(int(cuda_support_ver * 10)), 'cu118') >= 0:
                return 'cu118'
        return 'cu121'
    if compare_versions(torch_ver, '2.4.0') >= 0 and compare_versions(torch_ver, '2.6.0') == -1:
        # 2.4.0 <= torch < 2.6.0: default cu124
        if compare_versions(str(int(cuda_support_ver * 10)), 'cu124') < 0:
            if compare_versions(str(int(cuda_support_ver * 10)), 'cu121') >= 0:
                return 'cu121'
            if compare_versions(str(int(cuda_support_ver * 10)), 'cu118') >= 0:
                return 'cu118'
        return 'cu124'
    if compare_versions(torch_ver, '2.6.0') >= 0 and compare_versions(torch_ver, '2.7.0') == -1:
        # 2.6.0 <= torch < 2.7.0: default cu126
        if compare_versions(str(int(cuda_support_ver * 10)), 'cu126') < 0:
            if compare_versions(str(int(cuda_support_ver * 10)), 'cu124') >= 0:
                return 'cu124'
        if compare_versions(cuda_comp_cap, '10.0') > 0:
            if compare_versions(str(int(cuda_support_ver * 10)), 'cu128') >= 0:
                return 'cu128'
        return 'cu126'
    if compare_versions(torch_ver, '2.7.0') >= 0 and compare_versions(torch_ver, '2.8.0') == -1:
        # 2.7.0 <= torch < 2.8.0: default cu128
        if compare_versions(str(int(cuda_support_ver * 10)), 'cu128') < 0:
            if compare_versions(str(int(cuda_support_ver * 10)), 'cu126') >= 0:
                return 'cu126'
        return 'cu128'
    if compare_versions(torch_ver, '2.8.0') >= 0:
        # torch >= 2.8.0: default cu129
        return 'cu129'

    return 'cu129'


def get_pytorch_mirror_type_rocm(torch_ver: str) -> str:
    '''获取 ROCm 类型的 PyTorch 镜像源类型

    :param torch_ver`(str)`: PyTorch 版本
    :return `str`: ROCm 类型的 PyTorch 镜像源类型
    '''
    if compare_versions(torch_ver, '2.4.0') < 0:
        # torch < 2.4.0
        return 'other'
    if compare_versions(torch_ver, '2.4.0') >= 0 and compare_versions(torch_ver, '2.5.0') < 0:
        # 2.4.0 <= torch < 2.5.0
        return 'rocm61'
    if compare_versions(torch_ver, '2.5.0') >= 0 and compare_versions(torch_ver, '2.6.0') < 0:
        # 2.5.0 <= torch < 2.6.0
        return 'rocm62'
    if compare_versions(torch_ver, '2.6.0') >= 0 and compare_versions(torch_ver, '2.7.0') < 0:
        # 2.6.0 < torch < 2.7.0
        return 'rocm624'
    if compare_versions(torch_ver, '2.7.0') >= 0:
        # torch >= 2.7.0
        return 'rocm63'

    return 'rocm63'


def get_pytorch_mirror_type_ipex(torch_ver: str) -> str:
    '''获取 IPEX 类型的 PyTorch 镜像源类型

    :param torch_ver`(str)`: PyTorch 版本
    :return `str`: IPEX 类型的 PyTorch 镜像源类型
    '''
    if compare_versions(torch_ver, '2.0.0') < 0:
        # torch < 2.0.0
        return 'other'
    if compare_versions(torch_ver, '2.0.0') == 0:
        # torch == 2.0.0
        return 'ipex_legacy_arc'
    if compare_versions(torch_ver, '2.0.0') > 0 and compare_versions(torch_ver, '2.1.0') < 0:
        # 2.0.0 < torch < 2.1.0
        return 'other'
    if compare_versions(torch_ver, '2.1.0') == 0:
        # torch == 2.1.0
        return 'ipex_legacy_arc'
    if compare_versions(torch_ver, '2.6.0') >= 0:
        # torch >= 2.6.0
        return 'xpu'

    return 'xpu'


def get_pytorch_mirror_type_cpu(torch_ver: str) -> str:
    '''获取 CPU 类型的 PyTorch 镜像源类型

    :param torch_ver`(str)`: PyTorch 版本
    :return `str`: CPU 类型的 PyTorch 镜像源类型
    '''
    _ = torch_ver
    return 'cpu'


def get_pytorch_mirror_type(device_type: DeviceType) -> str:
    '''获取 PyTorch 镜像源类型

    :param device_type`(DeviceType)`: 显卡类型
    :return `str`: PyTorch 镜像源类型
    '''
    torch_ver = get_invokeai_require_torch_version()

    if device_type == 'cuda':
        return get_pytorch_mirror_type_cuda(torch_ver)

    if device_type == 'rocm':
        return get_pytorch_mirror_type_rocm(torch_ver)

    if device_type == 'xpu':
        return get_pytorch_mirror_type_ipex(torch_ver)

    if device_type == 'cpu':
        return get_pytorch_mirror_type_cpu(torch_ver)

    return 'other'


def main() -> None:
    '''主函数'''
    arg = get_args()
    print(get_pytorch_mirror_type(arg.device_type))


if __name__ == '__main__':
    main()
