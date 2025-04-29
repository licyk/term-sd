'''ComfyUI 运行环境检查'''
import re
import os
import sys
import copy
import logging
import argparse
import importlib.metadata
from collections import namedtuple
from pathlib import Path
from typing import Optional, TypedDict, Union


def get_args() -> argparse.Namespace:
    '''获取命令行参数输入参数输入'''
    parser = argparse.ArgumentParser(description='ComfyUI 运行环境检查')
    def normalized_filepath(filepath): return str(
        Path(filepath).absolute().as_posix())

    parser.add_argument(
        '--comfyui-path', type=normalized_filepath, default=None, help='ComfyUI 路径')
    parser.add_argument('--conflict-depend-notice-path', type=normalized_filepath,
                        default=None, help='保存 ComfyUI 扩展依赖冲突信息的文件路径')
    parser.add_argument('--requirement-list-path', type=normalized_filepath,
                        default=None, help='保存 ComfyUI 需要安装扩展依赖的路径列表')
    parser.add_argument('--debug-mode', action='store_true', help='显示调试信息')

    return parser.parse_args()


COMMAND_ARGS = get_args()


class ColoredFormatter(logging.Formatter):
    '''Logging 格式化'''
    COLORS = {
        'DEBUG': '\033[0;36m',          # CYAN
        'INFO': '\033[0;32m',           # GREEN
        'WARNING': '\033[0;33m',        # YELLOW
        'ERROR': '\033[0;31m',          # RED
        'CRITICAL': '\033[0;37;41m',    # WHITE ON RED
        'RESET': '\033[0m',             # RESET COLOR
    }

    def format(self, record):
        colored_record = copy.copy(record)
        levelname = colored_record.levelname
        seq = self.COLORS.get(levelname, self.COLORS['RESET'])
        colored_record.levelname = '{}{}{}'.format(
            seq, levelname, self.COLORS['RESET'])
        return super().format(colored_record)


def get_logger(
    name: str,
    level: int = logging.INFO,
) -> logging.Logger:
    '''获取 Loging 对象

    参数:
        name (`str`):
            Logging 名称


    '''
    logger = logging.getLogger(name)
    logger.propagate = False

    if not logger.handlers:
        handler = logging.StreamHandler(sys.stdout)
        handler.setFormatter(
            ColoredFormatter(
                '[%(name)s]-|%(asctime)s|-%(levelname)s: %(message)s', '%H:%M:%S'
            )
        )
        logger.addHandler(handler)

    logger.setLevel(level)
    logger.debug('Logger initialized.')

    return logger


logger = get_logger(
    'ComfyUI Env Checker',
    logging.DEBUG if COMMAND_ARGS.debug_mode else logging.INFO
)


# 提取版本标识符组件的正则表达式
# ref:
# https://peps.python.org/pep-0440
# https://packaging.python.org/en/latest/specifications/version-specifiers
VERSION_PATTERN = r'''
    v?
    (?:
        (?:(?P<epoch>[0-9]+)!)?                           # epoch
        (?P<release>[0-9]+(?:\.[0-9]+)*)                  # release segment
        (?P<pre>                                          # pre-release
            [-_\.]?
            (?P<pre_l>(a|b|c|rc|alpha|beta|pre|preview))
            [-_\.]?
            (?P<pre_n>[0-9]+)?
        )?
        (?P<post>                                         # post release
            (?:-(?P<post_n1>[0-9]+))
            |
            (?:
                [-_\.]?
                (?P<post_l>post|rev|r)
                [-_\.]?
                (?P<post_n2>[0-9]+)?
            )
        )?
        (?P<dev>                                          # dev release
            [-_\.]?
            (?P<dev_l>dev)
            [-_\.]?
            (?P<dev_n>[0-9]+)?
        )?
    )
    (?:\+(?P<local>[a-z0-9]+(?:[-_\.][a-z0-9]+)*))?       # local version
'''


# 编译正则表达式
package_version_parse_regex = re.compile(
    r'^\s*' + VERSION_PATTERN + r'\s*$',
    re.VERBOSE | re.IGNORECASE,
)


# 定义版本组件的命名元组
VersionComponent = namedtuple(
    'VersionComponent', [
        'epoch',
        'release',
        'pre_l',
        'pre_n',
        'post_n1',
        'post_l',
        'post_n2',
        'dev_l',
        'dev_n',
        'local',
        'is_wildcard'
    ]
)


def parse_version(version_str: str) -> VersionComponent:
    '''解释 Python 软件包版本号

    参数:
        version_str (`str`):
            Python 软件包版本号

    返回值:
        `VersionComponent`: 版本组件的命名元组

    异常:
        `ValueError`: 如果 Python 版本号不符合 PEP440 规范
    '''
    # 检测并剥离通配符
    wildcard = version_str.endswith('.*') or version_str.endswith('*')
    clean_str = version_str.rstrip(
        '*').rstrip('.') if wildcard else version_str

    match = package_version_parse_regex.match(clean_str)
    if not match:
        logger.error(f'未知的版本号字符串: {version_str}')
        raise ValueError(f'Invalid version string: {version_str}')

    components = match.groupdict()

    # 处理 release 段 (允许空字符串)
    release_str = components['release'] or '0'
    release_segments = [int(seg) for seg in release_str.split('.')]

    # 构建命名元组
    return VersionComponent(
        epoch=int(components['epoch'] or 0),
        release=release_segments,
        pre_l=components['pre_l'],
        pre_n=int(components['pre_n']) if components['pre_n'] else None,
        post_n1=int(components['post_n1']) if components['post_n1'] else None,
        post_l=components['post_l'],
        post_n2=int(components['post_n2']) if components['post_n2'] else None,
        dev_l=components['dev_l'],
        dev_n=int(components['dev_n']) if components['dev_n'] else None,
        local=components['local'],
        is_wildcard=wildcard
    )


def compare_version_objects(v1: VersionComponent, v2: VersionComponent) -> int:
    '''比较两个版本字符串 Python 软件包版本号

    参数:
        v1 (`VersionComponent`):
            第 1 个 Python 版本号标识符组件
        v2 (`VersionComponent`):
            第 2 个 Python 版本号标识符组件

    返回值:
        `int`: 如果版本号 1 大于 版本号 2, 则返回`1`, 小于则返回`-1`, 如果相等则返回`0`
    '''

    # 比较 epoch
    if v1.epoch != v2.epoch:
        return v1.epoch - v2.epoch

    # 比较 release
    for n1, n2 in zip(v1.release, v2.release):
        if n1 != n2:
            return n1 - n2
    # 如果 release 长度不同，较短的版本号视为较小
    if len(v1.release) != len(v2.release):
        return len(v1.release) - len(v2.release)

    # 比较 pre-release
    if v1.pre_l and not v2.pre_l:
        return -1  # pre-release 小于正常版本
    elif not v1.pre_l and v2.pre_l:
        return 1
    elif v1.pre_l and v2.pre_l:
        pre_order = {
            'a': 0,
            'b': 1,
            'c': 2,
            'rc': 3,
            'alpha': 0,
            'beta': 1,
            'pre': 0,
            'preview': 0
        }
        if pre_order[v1.pre_l] != pre_order[v2.pre_l]:
            return pre_order[v1.pre_l] - pre_order[v2.pre_l]
        elif v1.pre_n is not None and v2.pre_n is not None:
            return v1.pre_n - v2.pre_n
        elif v1.pre_n is None and v2.pre_n is not None:
            return -1
        elif v1.pre_n is not None and v2.pre_n is None:
            return 1

    # 比较 post-release
    if v1.post_n1 is not None:
        post_n1 = v1.post_n1
    elif v1.post_l:
        post_n1 = int(v1.post_n2) if v1.post_n2 else 0
    else:
        post_n1 = 0

    if v2.post_n1 is not None:
        post_n2 = v2.post_n1
    elif v2.post_l:
        post_n2 = int(v2.post_n2) if v2.post_n2 else 0
    else:
        post_n2 = 0

    if post_n1 != post_n2:
        return post_n1 - post_n2

    # 比较 dev-release
    if v1.dev_l and not v2.dev_l:
        return -1  # dev-release 小于 post-release 或正常版本
    elif not v1.dev_l and v2.dev_l:
        return 1
    elif v1.dev_l and v2.dev_l:
        if v1.dev_n is not None and v2.dev_n is not None:
            return v1.dev_n - v2.dev_n
        elif v1.dev_n is None and v2.dev_n is not None:
            return -1
        elif v1.dev_n is not None and v2.dev_n is None:
            return 1

    # 比较 local version
    if v1.local and not v2.local:
        return -1  # local version 小于 dev-release 或正常版本
    elif not v1.local and v2.local:
        return 1
    elif v1.local and v2.local:
        local1 = v1.local.split('.')
        local2 = v2.local.split('.')
        for l1, l2 in zip(local1, local2):
            if l1.isdigit() and l2.isdigit():
                l1, l2 = int(l1), int(l2)
            if l1 != l2:
                return (l1 > l2) - (l1 < l2)
        return len(local1) - len(local2)

    return 0  # 版本相同


def compare_versions(version1: str, version2: str) -> int:
    '''比较两个版本字符串 Python 软件包版本号

    参数:
        version1 (`str`):
            版本号 1
        version2 (`str`):
            版本号 2

    返回值:
        `int`: 如果版本号 1 大于 版本号 2, 则返回`1`, 小于则返回`-1`, 如果相等则返回`0`
    '''
    v1 = parse_version(version1)
    v2 = parse_version(version2)
    return compare_version_objects(v1, v2)


def compatible_version_matcher(spec_version: str):
    '''PEP 440 兼容性版本匹配 (~= 操作符)

    返回值:
        `_is_compatible(version_str: str) -> bool`: 一个接受 version_str (`str`) 参数的判断函数
    '''
    # 解析规范版本
    spec = parse_version(spec_version)

    # 获取有效release段 (去除末尾的零)
    clean_release = []
    for num in spec.release:
        if num != 0 or (clean_release and clean_release[-1] != 0):
            clean_release.append(num)

    # 确定最低版本和前缀匹配规则
    if len(clean_release) == 0:
        logger.error('解析到错误的兼容性发行版本号')
        raise ValueError('Invalid version for compatible release clause')

    # 生成前缀匹配模板 (忽略后缀)
    prefix_length = len(clean_release) - 1
    if prefix_length == 0:
        # 处理类似 ~= 2 的情况 (实际 PEP 禁止，但这里做容错)
        prefix_pattern = [spec.release[0]]
        min_version = parse_version(f'{spec.release[0]}')
    else:
        prefix_pattern = list(spec.release[:prefix_length])
        min_version = spec

    def _is_compatible(version_str: str) -> bool:
        target = parse_version(version_str)

        # 主版本前缀检查
        target_prefix = target.release[:len(prefix_pattern)]
        if target_prefix != prefix_pattern:
            return False

        # 最低版本检查 (自动忽略 pre/post/dev 后缀)
        return compare_version_objects(target, min_version) >= 0

    return _is_compatible


def version_match(spec: str, version: str) -> bool:
    '''PEP 440 版本前缀匹配

    参数:
        spec (`str`): 版本匹配表达式 (e.g. '1.1.*')
        version (`str`): 需要检测的实际版本号 (e.g. '1.1a1')

    返回值:
        `bool`: 是否匹配
    '''
    # 分离通配符和本地版本
    spec_parts = spec.split('+', 1)
    spec_main = spec_parts[0].rstrip('.*')  # 移除通配符
    has_wildcard = spec.endswith('.*') and '+' not in spec

    # 解析规范版本 (不带通配符)
    try:
        spec_ver = parse_version(spec_main)
    except ValueError:
        return False

    # 解析目标版本 (忽略本地版本)
    target_ver = parse_version(version.split('+', 1)[0])

    # 前缀匹配规则
    if has_wildcard:
        # 生成补零后的 release 段
        spec_release = spec_ver.release.copy()
        while len(spec_release) < len(target_ver.release):
            spec_release.append(0)

        # 比较前 N 个 release 段 (N 为规范版本长度)
        return (
            target_ver.release[:len(spec_ver.release)] == spec_ver.release
            and target_ver.epoch == spec_ver.epoch
        )
    else:
        # 严格匹配时使用原比较函数
        return compare_versions(spec_main, version) == 0


def is_v1_ge_v2(v1: str, v2: str) -> bool:
    '''查看 Python 版本号 v1 是否大于或等于 v2

    参数:
        v1 (`str`):
            第 1 个 Python 软件包版本号

        v2 (`str`):
            第 2 个 Python 软件包版本号

    返回值:
        `bool`: 如果 v1 版本号大于或等于 v2 版本号则返回`True`
        e.g.:
            1.1, 1.0 -> True
            1.0, 1.0 -> True
            0.9, 1.0 -> False
    '''
    return compare_versions(v1, v2) >= 0


def is_v1_gt_v2(v1: str, v2: str) -> bool:
    '''查看 Python 版本号 v1 是否大于 v2

    参数:
        v1 (`str`):
            第 1 个 Python 软件包版本号

        v2 (`str`):
            第 2 个 Python 软件包版本号

    返回值:
        `bool`: 如果 v1 版本号大于 v2 版本号则返回`True`
        e.g.:
            1.1, 1.0 -> True
            1.0, 1.0 -> False
    '''
    return compare_versions(v1, v2) > 0


def is_v1_eq_v2(v1: str, v2: str) -> bool:
    '''查看 Python 版本号 v1 是否等于 v2

    参数:
        v1 (`str`):
            第 1 个 Python 软件包版本号

        v2 (`str`):
            第 2 个 Python 软件包版本号

    返回值:
        `bool`: 如果 v1 版本号等于 v2 版本号则返回`True`
        e.g.:
            1.0, 1.0 -> True
            0.9, 1.0 -> False
            1.1, 1.0 -> False
    '''
    return compare_versions(v1, v2) == 0


def is_v1_lt_v2(v1: str, v2: str) -> bool:
    '''查看 Python 版本号 v1 是否小于 v2

    参数:
        v1 (`str`):
            第 1 个 Python 软件包版本号

        v2 (`str`):
            第 2 个 Python 软件包版本号

    返回值:
        `bool`: 如果 v1 版本号小于 v2 版本号则返回`True`
        e.g.:
            0.9, 1.0 -> True
            1.0, 1.0 -> False
    '''
    return compare_versions(v1, v2) < 0


def is_v1_le_v2(v1: str, v2: str) -> bool:
    '''查看 Python 版本号 v1 是否小于或等于 v2

    参数:
        v1 (`str`):
            第 1 个 Python 软件包版本号

        v2 (`str`):
            第 2 个 Python 软件包版本号

    返回值:
        `bool`: 如果 v1 版本号小于或等于 v2 版本号则返回`True`
        e.g.:
            0.9, 1.0 -> True
            1.0, 1.0 -> True
            1.1, 1.0 -> False
    '''
    return compare_versions(v1, v2) <= 0


def is_v1_c_eq_v2(v1: str, v2: str) -> bool:
    '''查看 Python 版本号 v1 是否大于等于 v2, (兼容性版本匹配)

    参数:
        v1 (`str`):
            第 1 个 Python 软件包版本号, 该版本由 ~= 符号指定

        v2 (`str`):
            第 2 个 Python 软件包版本号

    返回值:
        `bool`: 如果 v1 版本号等于 v2 版本号则返回`True`
        e.g.:
            1.0*, 1.0a1 -> True
            0.9*, 1.0 -> False
    '''
    func = compatible_version_matcher(v1)
    return func(v2)


def version_string_is_canonical(version: str) -> bool:
    '''判断版本号标识符是否符合标准

    参数:
        version (`str`):
            版本号字符串

    返回值:
        `bool`: 如果版本号标识符符合 PEP 440 标准, 则返回`True`

    '''
    return re.match(
        r'^([1-9][0-9]*!)?(0|[1-9][0-9]*)(\.(0|[1-9][0-9]*))*((a|b|rc)(0|[1-9][0-9]*))?(\.post(0|[1-9][0-9]*))?(\.dev(0|[1-9][0-9]*))?$',
        version,
    ) is not None


def is_package_has_version(package: str) -> bool:
    '''检查 Python 软件包是否指定版本号

    参数:
        package (`str`):
            Python 软件包名

    返回值:
        `bool`: 如果 Python 软件包存在版本声明, 如`torch==2.3.0`, 则返回`True`
    '''
    return package != (
        package.replace('===', '')
        .replace('~=', '')
        .replace('!=', '')
        .replace('<=', '')
        .replace('>=', '')
        .replace('<', '')
        .replace('>', '')
        .replace('==', '')
    )


def get_package_name(package: str) -> str:
    '''获取 Python 软件包的包名, 去除末尾的版本声明

    参数:
        package (`str`):
            Python 软件包名

    返回值:
        `str`: 返回去除版本声明后的 Python 软件包名
    '''
    return (
        package.split('===')[0]
        .split('~=')[0]
        .split('!=')[0]
        .split('<=')[0]
        .split('>=')[0]
        .split('<')[0]
        .split('>')[0]
        .split('==')[0]
        .strip()
    )


def get_package_version(package: str) -> str:
    '''获取 Python 软件包的包版本号

    参数:
        package (`str`):
            Python 软件包名

    返回值:
        `str`: 返回 Python 软件包的包版本号
    '''
    return (
        package.split('===').pop()
        .split('~=').pop()
        .split('!=').pop()
        .split('<=').pop()
        .split('>=').pop()
        .split('<').pop()
        .split('>').pop()
        .split('==').pop()
        .strip()
    )


WHEEL_PATTERN = r'''
    ^                           # 字符串开始
    (?P<distribution>[^-]+)     # 包名 (匹配第一个非连字符段)
    -                           # 分隔符
    (?:                         # 版本号和可选构建号组合
        (?P<version>[^-]+)      # 版本号 (至少一个非连字符段)
        (?:-(?P<build>\d\w*))?  # 可选构建号 (以数字开头)
    )
    -                           # 分隔符
    (?P<python>[^-]+)           # Python 版本标签
    -                           # 分隔符
    (?P<abi>[^-]+)              # ABI 标签
    -                           # 分隔符
    (?P<platform>[^-]+)         # 平台标签
    \.whl$                      # 固定后缀
'''


def parse_wheel_filename(filename: str) -> str:
    '''解析 Python wheel 文件名并返回 distribution 名称

    参数:
        filename (`str`):
            wheel 文件名, 例如 pydantic-1.10.15-py3-none-any.whl

    返回值:
        `str`: distribution 名称, 例如 pydantic

    异常:
        `ValueError`: 如果文件名不符合 PEP491 规范
    '''
    match = re.fullmatch(WHEEL_PATTERN, filename, re.VERBOSE)
    if not match:
        logger.error('未知的 Wheel 文件名: %s', filename)
        raise ValueError(f'Invalid wheel filename: {filename}')
    return match.group('distribution')


def parse_wheel_version(filename: str) -> str:
    '''解析 Python wheel 文件名并返回 version 名称

    参数:
        filename (`str`):
            wheel 文件名, 例如 pydantic-1.10.15-py3-none-any.whl

    返回值:
        `str`: version 名称, 例如 1.10.15

    异常:
        `ValueError`: 如果文件名不符合 PEP491 规范
    '''
    match = re.fullmatch(WHEEL_PATTERN, filename, re.VERBOSE)
    if not match:
        logger.error('未知的 Wheel 文件名: %s', filename)
        raise ValueError(f'Invalid wheel filename: {filename}')
    return match.group('version')


def parse_wheel_to_package_name(filename: str) -> str:
    '''解析 Python wheel 文件名并返回 <distribution>==<version>

    参数:
        filename (`str`):
            wheel 文件名, 例如 pydantic-1.10.15-py3-none-any.whl

    返回值:
        `str`: <distribution>==<version> 名称, 例如 pydantic==1.10.15
    '''
    distribution = parse_wheel_filename(filename)
    version = parse_wheel_version(filename)
    return f'{distribution}=={version}'


def remove_optional_dependence_from_package(filename: str) -> str:
    '''移除 Python 软件包声明中可选依赖

    参数:
        filename (`str`):
            Python 软件包名

    返回值:
        `str`: 移除可选依赖后的软件包名, e.g. diffusers[torch]==0.10.2 -> diffusers==0.10.2
    '''
    return re.sub(r'\[.*?\]', '', filename)


def parse_requirement_list(requirements: list) -> list:
    '''将 Python 软件包声明列表解析成标准 Python 软件包名列表

    参数:
        requirements (`list`):
            Python 软件包名声明列表
            e.g:
            ```python
            requirements = [
                'torch==2.3.0',
                'diffusers[torch]==0.10.2',
                'numpy',
                '-e .',
                '--index-url https://pypi.python.org/simple',
                '--extra-index-url https://download.pytorch.org/whl/cu124',
                '--find-links https://download.pytorch.org/whl/torch_stable.html',
                '-e git+https://github.com/Nerogar/mgds.git@2c67a5a#egg=mgds',
                'git+https://github.com/WASasquatch/img2texture.git',
                'https://github.com/Panchovix/pydantic-fixreforge/releases/download/main_v1/pydantic-1.10.15-py3-none-any.whl',
                'prodigy-plus-schedule-free==1.9.1 # prodigy+schedulefree optimizer',
                'protobuf<5,>=4.25.3',
            ]
            ```

    返回值:
        `list`: 将 Python 软件包名声明列表解析成标准声明列表
        e.g. 上述例子中的软件包名声明列表将解析成:
        ```python
            requirements = [
                'torch==2.3.0',
                'diffusers==0.10.2',
                'numpy',
                'mgds',
                'img2texture',
                'pydantic==1.10.15',
                'prodigy-plus-schedule-free==1.9.1',
                'protobuf<5',
                'protobuf>=4.25.3',
            ]
            ```
    '''
    package_list = []
    canonical_package_list = []
    requirement: str
    for requirement in requirements:
        requirement = requirement.strip()
        logger.debug('原始 Python 软件包名: %s', requirement)

        if (
            requirement is None
            or requirement == ''
            or requirement.startswith('#')
            or '# skip_verify' in requirement
            or requirement.startswith('--index-url')
            or requirement.startswith('--extra-index-url')
            or requirement.startswith('--find-links')
            or requirement.startswith('-e .')
        ):
            continue

        # -e git+https://github.com/Nerogar/mgds.git@2c67a5a#egg=mgds -> mgds
        # git+https://github.com/WASasquatch/img2texture.git -> img2texture
        # git+https://github.com/deepghs/waifuc -> waifuc
        if requirement.startswith('-e git+http') or requirement.startswith('git+http'):
            egg_match = re.search(r'egg=([^#&]+)', requirement)
            if egg_match:
                package_list.append(egg_match.group(1).split('-')[0])
                continue

            package_name = os.path.basename(requirement)
            package_name = package_name.split(
                '.git')[0] if package_name.endswith('.git') else package_name
            package_list.append(package_name)
            continue

        # https://github.com/Panchovix/pydantic-fixreforge/releases/download/main_v1/pydantic-1.10.15-py3-none-any.whl -> pydantic==1.10.15
        if requirement.startswith('https://') or requirement.startswith('http://'):
            package_name = parse_wheel_to_package_name(
                os.path.basename(requirement))
            package_list.append(package_name)
            continue

        # 常规 Python 软件包声明
        # prodigy-plus-schedule-free==1.9.1 # prodigy+schedulefree optimizer -> prodigy-plus-schedule-free==1.9.1
        cleaned_requirements = re.sub(
            r'\s*#.*$', '', requirement).strip().split(',')
        if len(cleaned_requirements) > 1:
            package_name = get_package_name(cleaned_requirements[0].strip())
            for package_name_with_version_marked in cleaned_requirements:
                version_symbol = str.replace(
                    package_name_with_version_marked, package_name, '', 1)
                format_package_name = remove_optional_dependence_from_package(
                    f'{package_name}{version_symbol}'.strip())
                package_list.append(format_package_name)
        else:
            format_package_name = remove_optional_dependence_from_package(
                cleaned_requirements[0].strip())
            package_list.append(format_package_name)

    for p in package_list:
        if not is_package_has_version(p):
            canonical_package_list.append(p)
            continue

        if version_string_is_canonical(get_package_version(p)):
            canonical_package_list.append(p)
        else:
            logger.debug('%s 软件包名的版本不符合标准', p)

    return canonical_package_list


def remove_duplicate_object_from_list(origin: list) -> list:
    '''对`list`进行去重

    参数:
        origin (`list`):
            原始的`list`

    返回值:
        `list`: 去重后的`list`, e.g. [1, 2, 3, 2] -> [1, 2, 3]
    '''
    return list(set(origin))


def read_packages_from_requirements_file(file_path: Union[str, Path]) -> list:
    '''从 requirements.txt 文件中读取 Python 软件包版本声明列表

    参数:
        file_path (`str`, `Path`):
            requirements.txt 文件路径

    返回值:
        `list`: 从 requirements.txt 文件中读取的 Python 软件包声明列表
    '''
    try:
        with open(file_path, 'r', encoding='utf-8') as f:
            return f.readlines()
    except Exception as e:
        logger.error('打开 %s 时出现错误: %s\n请检查文件是否出现损坏', file_path, e)
        return []


def get_package_version_from_library(package_name: str) -> Union[str, None]:
    '''获取已安装的 Python 软件包版本号

    参数:
        package_name (`str`):

    返回值:
        (`str` | `None`): 如果获取到 Python 软件包版本号则返回版本号字符串, 否则返回`None`
    '''
    try:
        ver = importlib.metadata.version(package_name)
    except:
        ver = None

    if ver is None:
        try:
            ver = importlib.metadata.version(package_name.lower())
        except:
            ver = None

    if ver is None:
        try:
            ver = importlib.metadata.version(package_name.replace('_', '-'))
        except:
            ver = None

    return ver


class ComponentEnvironmentDetails(TypedDict):
    '''ComfyUI 组件的环境信息结构'''
    requirement_path: str           # 依赖文件路径
    is_disabled: bool               # 组件是否禁用
    requires: list[str]             # 需要的依赖列表
    has_missing_requires: bool      # 是否存在缺失依赖
    missing_requires: list[str]     # 具体缺失的依赖项
    has_conflict_requires: bool     # 是否存在冲突依赖
    conflict_requires: list[str]    # 具体冲突的依赖项


ComfyUIEnvironmentComponent = dict[
    str, ComponentEnvironmentDetails
]  # ComfyUI 环境组件表字典


def create_comfyui_environment_dict(
    comfyui_path: Union[str, Path],
) -> ComfyUIEnvironmentComponent:
    '''创建 ComfyUI 环境组件表字典

    参数:
        comfyui_path (`str`, `Path`):
            ComfyUI 根路径

    返回值:
        `ComfyUIEnvironmentComponent`: ComfyUI 环境组件表字典
    '''
    comfyui_env_data: ComfyUIEnvironmentComponent = {
        'ComfyUI': {
            'requirement_path': os.path.join(comfyui_path, 'requirements.txt'),
            'is_disabled': False,
            'requires': [],
            'has_missing_requires': False,
            'missing_requires': [],
            'has_conflict_requires': False,
            'conflict_requires': [],
        },
    }
    custom_nodes_path = os.path.join(comfyui_path, 'custom_nodes')
    for custom_node in os.listdir(custom_nodes_path):
        if os.path.isfile(os.path.join(custom_nodes_path, custom_node)):
            continue

        custom_node_requirement_path = os.path.join(
            custom_nodes_path, custom_node, 'requirements.txt')
        custom_node_is_disabled = True if custom_node.endswith(
            '.disabled') else False

        comfyui_env_data[custom_node] = {
            'requirement_path': (
                custom_node_requirement_path
                if os.path.exists(custom_node_requirement_path)
                else None
            ),
            'is_disabled': custom_node_is_disabled,
            'requires': [],
            'has_missing_requires': False,
            'missing_requires': [],
            'has_conflict_requires': False,
            'conflict_requires': [],
        }

    return comfyui_env_data


def update_comfyui_environment_dict(
    env_data: ComfyUIEnvironmentComponent,
    component_name: str,
    requirement_path: Optional[str] = None,
    is_disabled: Optional[bool] = None,
    requires: Optional[list[str]] = None,
    has_missing_requires: Optional[bool] = None,
    missing_requires: Optional[list[str]] = None,
    has_conflict_requires: Optional[bool] = None,
    conflict_requires: Optional[list[str]] = None,
) -> None:
    '''更新 ComfyUI 环境组件表字典

    参数:
        env_data (`ComfyUIEnvironmentComponent`):
            ComfyUI 环境组件表字典

        component_name (`str`):
            ComfyUI 组件名称

        requirement_path (`str`, `None`):
            ComfyUI 组件依赖文件路径

        is_disabled (`bool`, `None`):
            ComfyUI 组件是否被禁用

        requires (`list[str]`, `None`):
            ComfyUI 组件需要的依赖列表

        has_missing_requires (`bool`, `None`):
            ComfyUI 组件是否存在缺失依赖

        missing_requires (`list[str]`, `None`):
            ComfyUI 组件缺失依赖列表

        has_conflict_requires (`bool`, `None`):
            ComfyUI 组件是否存在冲突依赖

        conflict_requires (`list[str]`, `None`):
            ComfyUI 组件冲突依赖列表
    '''
    env_data[component_name] = {
        'requirement_path': (
            requirement_path
            if requirement_path
            else env_data.get(component_name).get('requirement_path')
        ),
        'is_disabled': (
            is_disabled
            if is_disabled
            else env_data.get(component_name).get('is_disabled')
        ),
        'requires': (
            requires
            if requires
            else env_data.get(component_name).get('requires')
        ),
        'has_missing_requires': (
            has_missing_requires
            if has_missing_requires
            else env_data.get(component_name).get('has_missing_requires')
        ),
        'missing_requires': (
            missing_requires
            if missing_requires
            else env_data.get(component_name).get('missing_requires')
        ),
        'has_conflict_requires': (
            has_conflict_requires
            if has_conflict_requires
            else env_data.get(component_name).get('has_conflict_requires')
        ),
        'conflict_requires': (
            conflict_requires
            if conflict_requires
            else env_data.get(component_name).get('conflict_requires')
        ),
    }


def update_comfyui_component_requires_list(
    env_data: ComfyUIEnvironmentComponent,
) -> None:
    '''更新 ComfyUI 环境组件表字典, 根据字典中的 requirement_path 确定 Python 软件包版本声明文件, 并解析后写入 requires 字段

    参数:
        env_data (`ComfyUIEnvironmentComponent`):
            ComfyUI 环境组件表字典
    '''
    for component_name, details in env_data.items():
        if details.get('is_disabled'):
            continue

        requirement_path = details.get('requirement_path')
        if requirement_path is None:
            continue

        origin_requires = read_packages_from_requirements_file(
            requirement_path
        )
        requires = parse_requirement_list(origin_requires)
        update_comfyui_environment_dict(
            env_data=env_data,
            component_name=component_name,
            requires=requires,
        )


def update_comfyui_component_missing_requires_list(
    env_data: ComfyUIEnvironmentComponent,
) -> None:
    '''更新 ComfyUI 环境组件表字典, 根据字典中的 requires 检查缺失的 Python 软件包, 并保存到 missing_requires 字段和设置 has_missing_requires 状态

    参数:
        env_data (`ComfyUIEnvironmentComponent`):
            ComfyUI 环境组件表字典
    '''
    for component_name, details in env_data.items():
        if details.get('is_disabled'):
            continue

        requires = details.get('requires')
        has_missing_requires = False
        missing_requires = []

        for package in requires:
            if not is_package_installed(package):
                has_missing_requires = True
                missing_requires.append(package)

        update_comfyui_environment_dict(
            env_data=env_data,
            component_name=component_name,
            has_missing_requires=has_missing_requires,
            missing_requires=missing_requires,
        )


def update_comfyui_component_conflict_requires_list(
    env_data: ComfyUIEnvironmentComponent,
    conflict_package_list: list
) -> None:
    '''更新 ComfyUI 环境组件表字典, 根据 conflicconflict_package_listt_package 检查 ComfyUI 组件冲突的 Python 软件包, 并保存到 conflict_requires 字段和设置 has_conflict_requires 状态

    参数:
        env_data (`ComfyUIEnvironmentComponent`):
            ComfyUI 环境组件表字典

        conflict_package_list (`list`):
            冲突的 Python 软件包列表
    '''
    for component_name, details in env_data.items():
        if details.get('is_disabled'):
            continue

        requires = details.get('requires')
        has_conflict_requires = False
        conflict_requires = []

        for conflict_package in conflict_package_list:
            for package in requires:
                if (
                    is_package_has_version(package)
                    and
                    get_package_name(
                        conflict_package.lower()
                    ) == get_package_name(package.lower())
                ):
                    has_conflict_requires = True
                    conflict_requires.append(package)

        update_comfyui_environment_dict(
            env_data=env_data,
            component_name=component_name,
            has_conflict_requires=has_conflict_requires,
            conflict_requires=conflict_requires,
        )


def get_comfyui_component_requires_list(
    env_data: ComfyUIEnvironmentComponent,
) -> list:
    '''从 ComfyUI 环境组件表字典读取所有组件的 requires

    参数:
        env_data (`ComfyUIEnvironmentComponent`):
            ComfyUI 环境组件表字典

    返回值:
        `list`: ComfyUI 环境组件的 Python 软件包列表
    '''
    package_list = []
    for _, details in env_data.items():
        if details.get('is_disabled'):
            continue

        package_list += details.get('requires')

    return remove_duplicate_object_from_list(package_list)


def statistical_need_install_require_component(
    env_data: ComfyUIEnvironmentComponent,
) -> list:
    '''根据 ComfyUI 环境组件表字典中的 has_missing_requires 和 has_conflict_requires 字段确认需要安装依赖的列表

    参数:
        env_data (`ComfyUIEnvironmentComponent`):
            ComfyUI 环境组件表字典

    返回值:
        `list`: ComfyUI 环境组件的依赖文件路径列表
    '''
    requirement_list = []
    for _, details in env_data.items():
        if (
            details.get('has_missing_requires')
            or details.get('has_conflict_requires')
        ):
            requirement_list.append(
                Path(details.get('requirement_path')).as_posix())

    return requirement_list


def statistical_has_conflict_component(
    env_data: ComfyUIEnvironmentComponent,
    conflict_package_list: list
) -> list:
    '''根据 ComfyUI 环境组件表字典中的 has_conflict_requires 字段确认需要安装依赖的列表

    参数:
        env_data (`ComfyUIEnvironmentComponent`):
            ComfyUI 环境组件表字典

    返回值:
        `list`: ComfyUI 环境组件的依赖文件路径列表
    '''
    content = []
    for conflict_package in conflict_package_list:
        conflict_package: str = conflict_package.lower()
        content.append(get_package_name(f'{conflict_package}:'))
        for component_name, details in env_data.items():
            for conflict_component_package in details.get('conflict_requires'):
                if get_package_name(conflict_component_package.lower()) == conflict_package:
                    content.append(
                        f' - {component_name}: {conflict_component_package}')

    return content[:-1] if len(content) > 0 and content[-1] == '' else content


def is_package_installed(package: str) -> bool:
    '''判断 Python 软件包是否已安装在环境中

    参数:
        package (`str`):
            Python 软件包名

    返回值:
        `bool`: 如果 Python 软件包未安装或者未安装正确的版本, 则返回`False`
    '''
    # 分割 Python 软件包名和版本号
    if '===' in package:
        pkg_name, pkg_version = [x.strip() for x in package.split('===')]
    elif '~=' in package:
        pkg_name, pkg_version = [x.strip() for x in package.split('~=')]
    elif '!=' in package:
        pkg_name, pkg_version = [x.strip() for x in package.split('!=')]
    elif '<=' in package:
        pkg_name, pkg_version = [x.strip() for x in package.split('<=')]
    elif '>=' in package:
        pkg_name, pkg_version = [x.strip() for x in package.split('>=')]
    elif '<' in package:
        pkg_name, pkg_version = [x.strip() for x in package.split('<')]
    elif '>' in package:
        pkg_name, pkg_version = [x.strip() for x in package.split('>')]
    elif '==' in package:
        pkg_name, pkg_version = [x.strip() for x in package.split('==')]
    else:
        pkg_name, pkg_version = package.strip(), None

    env_pkg_version = get_package_version_from_library(pkg_name)
    logger.debug(
        '已安装 Python 软件包检测: pkg_name: %s, env_pkg_version: %s, pkg_version: %s',
        pkg_name, env_pkg_version, pkg_version
    )

    if env_pkg_version is None:
        return False

    if pkg_version is not None:
        # ok = env_pkg_version === / == pkg_version
        if '===' in package or '==' in package:
            logger.debug('包含条件: === / ==')
            if is_v1_eq_v2(env_pkg_version, pkg_version):
                logger.debug('%s == %s', env_pkg_version, pkg_version)
                return True

        # ok = env_pkg_version ~= pkg_version
        if '~=' in package:
            logger.debug('包含条件: ~=')
            if is_v1_c_eq_v2(pkg_version, env_pkg_version):
                logger.debug('%s ~= %s', pkg_version, env_pkg_version)
                return True

        # ok = env_pkg_version != pkg_version
        if '!=' in package:
            logger.debug('包含条件: !=')
            if not is_v1_eq_v2(env_pkg_version, pkg_version):
                logger.debug('%s != %s', env_pkg_version, pkg_version)
                return True

        # ok = env_pkg_version <= pkg_version
        if '<=' in package:
            logger.debug('包含条件: <=')
            if is_v1_le_v2(env_pkg_version, pkg_version):
                logger.debug('%s <= %s', env_pkg_version, pkg_version)
                return True

        # ok = env_pkg_version >= pkg_version
        if '>=' in package:
            logger.debug('包含条件: >=')
            if is_v1_ge_v2(env_pkg_version, pkg_version):
                logger.debug('%s >= %s', env_pkg_version, pkg_version)
                return True

        # ok = env_pkg_version < pkg_version
        if '<' in package:
            logger.debug('包含条件: <')
            if is_v1_lt_v2(env_pkg_version, pkg_version):
                logger.debug('%s < %s', env_pkg_version, pkg_version)
                return True

        # ok = env_pkg_version > pkg_version
        if '>' in package:
            logger.debug('包含条件: >')
            if is_v1_gt_v2(env_pkg_version, pkg_version):
                logger.debug('%s > %s', env_pkg_version, pkg_version)
                return True

        logger.debug('%s 需要安装', package)
        return False

    return True


def fitter_has_version_package(package_list: list) -> list:
    '''过滤不包含版本的 Python 软件包, 仅保留包含版本号声明的 Python 软件包

    参数:
        package_list (`list`):
            Python 软件包列表

    返回值:
        `list`: 仅包含版本号的 Python 软件包列表
    '''
    return [
        p for p in package_list
        if is_package_has_version(p)
    ]


def detect_conflict_package(pkg1: str, pkg2: str) -> bool:
    '''检测 Python 软件包版本号声明是否存在冲突

    参数:
        pkg1 (`str`):
            第 1 个 Python 软件包名称

        pkg2 (`str`):
            第 2 个 Python 软件包名称

    返回值:
        `bool`: 如果 Python 软件包版本声明出现冲突则返回`True`
    '''
    # 进行 2 次循环, 第 2 次循环时交换版本后再进行判断
    for i in range(2):
        if i == 1:
            pkg1, pkg2 = pkg2, pkg1

        ver1 = get_package_version(pkg1)
        ver2 = get_package_version(pkg2)
        logger.debug(
            '冲突依赖检测: pkg1: %s, pkg2: %s, ver1: %s, ver2: %s',
            pkg1, pkg2, ver1, ver2)

        # >=, <=
        if '>=' in pkg1 and '<=' in pkg2:
            if is_v1_gt_v2(ver1, ver2):
                logger.debug(
                    '冲突依赖: %s, %s, 版本冲突: %s > %s',
                    pkg1, pkg2, ver1, ver2)
                return True

        # >=, <
        if '>=' in pkg1 and '<' in pkg2 and '=' not in pkg2:
            if is_v1_ge_v2(ver1, ver2):
                logger.debug(
                    '冲突依赖: %s, %s, 版本冲突: %s >= %s',
                    pkg1, pkg2, ver1, ver2)
                return True

        # >, <=
        if '>' in pkg1 and '=' not in pkg1 and '<=' in pkg2:
            if is_v1_ge_v2(ver1, ver2):
                logger.debug(
                    '冲突依赖: %s, %s, 版本冲突: %s >= %s',
                    pkg1, pkg2, ver1, ver2)
                return True

        # >, <
        if '>' in pkg1 and '=' not in pkg1 and '<' in pkg2 and '=' not in pkg2:
            if is_v1_ge_v2(ver1, ver2):
                logger.debug(
                    '冲突依赖: %s, %s, 版本冲突: %s >= %s',
                    pkg1, pkg2, ver1, ver2)
                return True

        # >, ==
        if '>' in pkg1 and '=' not in pkg1 and '==' in pkg2:
            if is_v1_ge_v2(ver1, ver2):
                logger.debug(
                    '冲突依赖: %s, %s, 版本冲突: %s >= %s',
                    pkg1, pkg2, ver1, ver2)
                return True

        # >=, ==
        if '>=' in pkg1 and '==' in pkg2:
            if is_v1_gt_v2(ver1, ver2):
                logger.debug(
                    '冲突依赖: %s, %s, 版本冲突: %s > %s',
                    pkg1, pkg2, ver1, ver2)
                return True

        # <, ==
        if '<' in pkg1 and '=' not in pkg1 and '==' in pkg2:
            if is_v1_le_v2(ver1, ver2):
                logger.debug(
                    '冲突依赖: %s, %s, 版本冲突: %s <= %s',
                    pkg1, pkg2, ver1, ver2)
                return True

        # <=, ==
        if '<=' in pkg1 and '==' in pkg2:
            if is_v1_lt_v2(ver1, ver2):
                logger.debug(
                    '冲突依赖: %s, %s, 版本冲突: %s < %s',
                    pkg1, pkg2, ver1, ver2)
                return True

        # !=, ==
        if '!=' in pkg1 and '==' in pkg2:
            if is_v1_eq_v2(ver1, ver2):
                logger.debug(
                    '冲突依赖: %s, %s, 版本冲突: %s == %s',
                    pkg1, pkg2, ver1, ver2)
                return True

        # >, ~=
        if '>' in pkg1 and '=' not in pkg1 and '~=' in pkg2:
            if is_v1_ge_v2(ver1, ver2):
                logger.debug(
                    '冲突依赖: %s, %s, 版本冲突: %s >= %s',
                    pkg1, pkg2, ver1, ver2)
                return True

        # >=, ~=
        if '>=' in pkg1 and '~=' in pkg2:
            if is_v1_gt_v2(ver1, ver2):
                logger.debug(
                    '冲突依赖: %s, %s, 版本冲突: %s > %s',
                    pkg1, pkg2, ver1, ver2)
                return True

        # <, ~=
        if '<' in pkg1 and '=' not in pkg1 and '~=' in pkg2:
            if is_v1_le_v2(ver1, ver2):
                logger.debug(
                    '冲突依赖: %s, %s, 版本冲突: %s <= %s',
                    pkg1, pkg2, ver1, ver2)
                return True

        # <=, ~=
        if '<=' in pkg1 and '~=' in pkg2:
            if is_v1_lt_v2(ver1, ver2):
                logger.debug(
                    '冲突依赖: %s, %s, 版本冲突: %s < %s',
                    pkg1, pkg2, ver1, ver2)
                return True

        # !=, ~=
        # 这个也没什么必要
        # if '!=' in pkg1 and '~=' in pkg2:
        #     if is_v1_c_eq_v2(ver1, ver2):
        #         logger.debug(
        #             '冲突依赖: %s, %s, 版本冲突: %s ~= %s',
        #             pkg1, pkg2, ver1, ver2)
        #         return True

        # ~=, == / ~=, ===
        if ('~=' in pkg1 and '==' in pkg2) or ('~=' in pkg1 and '===' in pkg2):
            if is_v1_gt_v2(ver1, ver2):
                logger.debug(
                    '冲突依赖: %s, %s, 版本冲突: %s > %s',
                    pkg1, pkg2, ver1, ver2)
                return True

        # ~=, ~=
        # ~= 类似 >= V.N, == V.*, 所以该部分的比较没必要使用
        # if '~=' in pkg1 and '~=' in pkg2:
        #     if not is_v1_c_eq_v2(ver1, ver2):
        #         logger.debug(
        #             '冲突依赖: %s, %s, 版本冲突: %s !~= %s',
        #             pkg1, pkg2, ver1, ver2)
        #         return True

        # ==, == / ===, ===
        if ('==' in pkg1 and '==' in pkg2) or ('===' in pkg1 and '===' in pkg2):
            if not is_v1_eq_v2(ver1, ver2):
                logger.debug(
                    '冲突依赖: %s, %s, 版本冲突: %s != %s',
                    pkg1, pkg2, ver1, ver2)
                return True

    return False


def detect_conflict_package_from_list(package_list: list) -> list:
    '''检测 Python 软件包版本声明列表中存在冲突的软件包

    参数:
        package_list (`list`):
            Python 软件包版本声明列表

    返回值:
        `list`: 冲突的 Python 软件包列表
    '''
    conflict_package = []
    for i in package_list:
        for j in package_list:
            i = i.lower()
            j = j.lower()
            if (
                get_package_name(i) == get_package_name(j)
                and detect_conflict_package(i, j)
            ):
                conflict_package.append(get_package_name(i))

    return remove_duplicate_object_from_list(conflict_package)


def display_comfyui_environment_dict(
    env_data: ComfyUIEnvironmentComponent,
) -> None:
    '''列出 ComfyUI 环境组件字典内容

    参数:
        env_data (`ComfyUIEnvironmentComponent`):
            ComfyUI 环境组件表字典
    '''
    logger.debug('ComfyUI 环境组件表')
    for component_name, details in env_data.items():
        print('Component: {}'.format(component_name))
        print('  requirement_path: {}'.format(details['requirement_path']))
        print('  is_disabled: {}'.format(details['is_disabled']))
        print('  requires: {}'.format(details['requires']))
        print('  has_missing_requires: {}'.format(
            details['has_missing_requires']))
        print('  missing_requires: {}'.format(details['missing_requires']))
        print('  has_conflict_requires: {}'.format(
            details['has_conflict_requires']))
        print('  conflict_requires: {}'.format(details['conflict_requires']))
        print()


def write_content_to_file(
        content: list,
        path: Union[str, Path]
) -> None:
    '''将内容列表写入到文件中

    参数:
        content (`list`):
            内容列表

        path (`str`, `Path`):
            保存内容的路径
    '''
    if len(content) == 0:
        return

    dir_path = os.path.dirname(path)
    if not os.path.exists(dir_path):
        os.makedirs(dir_path, exist_ok=True)

    try:
        logger.debug('写入文件到 %s', path)
        with open(path, 'w', encoding='utf-8') as f:
            for item in content:
                f.write(item + '\n')
    except Exception as e:
        logger.error('写入文件到 %s 时出现了错误: %s', path, e)


def main() -> None:
    comfyui_root_path = COMMAND_ARGS.comfyui_path
    comfyui_conflict_notice = COMMAND_ARGS.conflict_depend_notice_path
    comfyui_requirement_path = COMMAND_ARGS.requirement_list_path
    debug_mode = COMMAND_ARGS.debug_mode

    if not os.path.exists(os.path.join(comfyui_root_path, 'requirements.txt')):
        logger.error('ComfyUI 依赖文件缺失, 请检查 ComfyUI 是否安装完整')
        sys.exit(1)

    if not os.path.exists(os.path.join(comfyui_root_path, 'custom_nodes')):
        logger.error('ComfyUI 自定义节点文件夹未找到, 请检查 ComfyUI 是否安装完整')
        sys.exit(1)

    if not comfyui_conflict_notice or not comfyui_requirement_path:
        logger.error(
            '未配置 --conflict-depend-notice-path / --requirement-list-path, 无法进行环境检测')
        sys.exit(1)

    logger.debug('检测 ComfyUI 环境中')
    env_data = create_comfyui_environment_dict(comfyui_root_path)
    update_comfyui_component_requires_list(env_data)
    update_comfyui_component_missing_requires_list(env_data)
    pkg_list = get_comfyui_component_requires_list(env_data)
    has_version_pkg = fitter_has_version_package(pkg_list)
    conflict_pkg = detect_conflict_package_from_list(has_version_pkg)
    update_comfyui_component_conflict_requires_list(env_data, conflict_pkg)
    req_list = statistical_need_install_require_component(env_data)
    conflict_info = statistical_has_conflict_component(env_data, conflict_pkg)
    write_content_to_file(conflict_info, comfyui_conflict_notice)
    write_content_to_file(req_list, comfyui_requirement_path)
    if debug_mode:
        display_comfyui_environment_dict(env_data)
    logger.debug('ComfyUI 环境检查完成')


if __name__ == '__main__':
    main()
