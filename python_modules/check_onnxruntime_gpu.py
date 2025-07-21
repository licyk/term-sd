import re
import argparse
import importlib.metadata
from pathlib import Path
from enum import Enum


def get_args() -> argparse.Namespace:
    '''获取命令行参数

    :return `argparse.Namespace`: 命令行参数命名空间
    '''
    parser = argparse.ArgumentParser()

    parser.add_argument('--ignore-ort-install', action='store_true', help='忽略 onnxruntime-gpu 未安装的状态, 强制进行检查')

    return parser.parse_args()


def get_onnxruntime_version_file() -> Path | None:
    '''获取记录 onnxruntime 版本的文件路径

    :return Path | None: 记录 onnxruntime 版本的文件路径
    '''
    package = 'onnxruntime-gpu'
    version_file = 'onnxruntime/capi/version_info.py'
    try:
        util = [
            p for p in importlib.metadata.files(package)
            if version_file in str(p)
        ][0]
        info_path = Path(util.locate())
    except Exception as _:
        info_path = None

    return info_path


def get_onnxruntime_support_cuda_version() -> tuple[str | None, str | None]:
    '''获取 onnxruntime 支持的 CUDA, cuDNN 版本

    :return tuple[str | None, str | None]: onnxruntime 支持的 CUDA, cuDNN 版本
    '''
    ver_path = get_onnxruntime_version_file()
    cuda_ver = None
    cudnn_ver = None
    try:
        with open(ver_path, 'r', encoding='utf8') as f:
            for line in f:
                if 'cuda_version' in line:
                    cuda_ver = get_value_from_variable(line, 'cuda_version')
                if 'cudnn_version' in line:
                    cudnn_ver = get_value_from_variable(line, 'cudnn_version')
    except Exception as _:
        pass

    return cuda_ver, cudnn_ver


def get_value_from_variable(content: str, var_name: str) -> str | None:
    '''从字符串 (Python 代码片段) 中找出指定字符串变量的值

    :param content(str): 待查找的内容
    :param var_name(str): 待查找的字符串变量
    :return str | None: 返回字符串变量的值
    '''
    pattern = fr'{var_name}\s*=\s*"([^"]+)"'
    match = re.search(pattern, content)
    return match.group(1) if match else None


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


def get_torch_cuda_ver() -> tuple[str | None, str | None, str | None]:
    '''获取 Torch 的本体, CUDA, cuDNN 版本

    :return tuple[str | None, str | None, str | None]: Torch, CUDA, cuDNN 版本
    '''
    try:
        import torch
        torch_ver = torch.__version__
        cuda_ver = torch.version.cuda
        cudnn_ver = torch.backends.cudnn.version()
        return str(torch_ver), str(cuda_ver), str(cudnn_ver)
    except Exception as _:
        return None, None, None


class OrtType(str, Enum):
    '''onnxruntime-gpu 的类型

    版本说明: 
    - CU121CUDNN8: CUDA 12.1 + cuDNN8
    - CU121CUDNN9: CUDA 12.1 + cuDNN9
    - CU118: CUDA 11.8
    '''
    CU121CUDNN8 = 'cu121cudnn8'
    CU121CUDNN9 = 'cu121cudnn9'
    CU118 = 'cu118'

    def __str__(self):
        return self.value


def need_install_ort_ver(ignore_ort_install: bool = True) -> OrtType | None:
    '''判断需要安装的 onnxruntime 版本

    :param ignore_ort_install(bool): 当 onnxruntime 未安装时跳过检查
    :return OrtType: 需要安装的 onnxruntime-gpu 类型
    '''
    # 检测是否安装了 Torch
    torch_ver, cuda_ver, cuddn_ver = get_torch_cuda_ver()
    # 缺少 Torch / CUDA / cuDNN 版本时取消判断
    if (
        torch_ver is None
        or cuda_ver is None
        or cuddn_ver is None
    ):
        return None

    # onnxruntime 记录的 cuDNN 支持版本只有一位数, 所以 Torch 的 cuDNN 版本只能截取一位
    cuddn_ver = cuddn_ver[0]

    # 检测是否安装了 onnxruntime-gpu
    ort_support_cuda_ver, ort_support_cudnn_ver = get_onnxruntime_support_cuda_version()
    # 通常 onnxruntime 的 CUDA 版本和 cuDNN 版本会同时存在, 所以只需要判断 CUDA 版本是否存在即可
    if ort_support_cuda_ver is not None:
        # 当 onnxruntime 已安装

        # 判断 Torch 中的 CUDA 版本
        if compare_versions(cuda_ver, '12.0') >= 0:
            # CUDA >= 12.0

            # 比较 onnxtuntime 支持的 CUDA 版本是否和 Torch 中所带的 CUDA 版本匹配
            if compare_versions(ort_support_cuda_ver, '12.0') >= 0:
                # CUDA 版本为 12.x, torch 和 ort 的 CUDA 版本匹配

                # 判断 Torch 和 onnxruntime 的 cuDNN 是否匹配
                if compare_versions(ort_support_cudnn_ver, cuddn_ver) > 0:
                    # ort cuDNN 版本 > torch cuDNN 版本
                    return OrtType.CU121CUDNN8
                elif compare_versions(ort_support_cudnn_ver, cuddn_ver) < 0:
                    # ort cuDNN 版本 < torch cuDNN 版本
                    return OrtType.CU121CUDNN9
                else:
                    # 版本相等, 无需重装
                    return None
            else:
                # CUDA 版本非 12.x, 不匹配
                if compare_versions(cuddn_ver, '8') > 0:
                    return OrtType.CU121CUDNN9
                else:
                    return OrtType.CU121CUDNN8
        else:
            # CUDA <= 11.8
            if compare_versions(ort_support_cuda_ver, '12.0') < 0:
                return None
            else:
                return OrtType.CU118
    else:
        if ignore_ort_install:
            return None

        if compare_versions(cuda_ver, '12.0') >= 0:
            if compare_versions(cuddn_ver, '8') > 0:
                return OrtType.CU121CUDNN9
            else:
                return OrtType.CU121CUDNN8
        else:
            return OrtType.CU118


if __name__ == '__main__':
    arg = get_args()
    print(need_install_ort_ver(arg.ignore_ort_install))
