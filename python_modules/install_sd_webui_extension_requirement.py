import os
import sys
import json
import copy
import inspect
import logging
import argparse
import traceback
import subprocess
from pathlib import Path
from typing import Optional


def get_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description='Stable Diffusion WebUI 扩展依赖安装脚本')

    def normalized_filepath(filepath): return str(
        Path(filepath).absolute().as_posix())
    parser.add_argument('--disable-extra-extensions',
                        action='store_true', help='禁用额外 Stable Diffusion WebUI 扩展')
    parser.add_argument('--disable-all-extensions',
                        action='store_true', help='禁用所有 Stable Diffusion WebUI 扩展')
    parser.add_argument('--sd-webui-base-path', type=normalized_filepath,
                        default=os.getcwd(), help='Stable Diffusion WebUI 根目录')
    return parser.parse_args()


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
            seq, levelname, self.COLORS['RESET']
        )
        return super().format(colored_record)


def get_logger(
    name: str | None = None,
    level: int = logging.INFO,
) -> logging.Logger:
    '''获取 Loging 对象

    :param name`(str)`: Logging 名称
    :return `logging.Logger`: Logging 对象
    '''
    stack = inspect.stack()
    calling_filename = os.path.basename(stack[1].filename)
    if name is None:
        name = calling_filename

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
    logger.debug('Logger 初始化完成')

    return logger


logger = get_logger('Term-SD')


def run_cmd(
    command: str | list,
    desc: Optional[str] = None,
    errdesc: Optional[str] = None,
    custom_env: Optional[list] = None,
    live: Optional[bool] = True,
    shell: Optional[bool] = None
) -> str:
    '''执行 Shell 命令

    :param command`(str|list)`: 要执行的命令
    :param desc`(Optional[str])`: 执行命令的描述
    :param errdesc`(Optional[str])`: 执行命令报错时的描述
    :param custom_env`(Optional[str])`: 自定义环境变量
    :param live`Optional[bool]`: 是否实时输出命令执行日志
    :param shell`Optional[bool]`: 是否使用内置 Shell 执行命令
    :return `str`: 命令执行时输出的内容
    '''

    if shell is None:
        shell = sys.platform != 'win32'

    if desc is not None:
        logger.info(desc)

    if custom_env is None:
        custom_env = os.environ

    if live:
        result: subprocess.CompletedProcess = subprocess.run(
            command,
            shell=shell,
            env=custom_env,
        )
        if result.returncode != 0:
            raise RuntimeError(f'''{errdesc or '执行命令时发送错误'}
命令: {command}
错误代码: {result.returncode}''')

        return ''

    result: subprocess.CompletedProcess = subprocess.run(
        command,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        shell=shell,
        env=custom_env
    )

    if result.returncode != 0:
        message = f'''{errdesc or '执行命令时发送错误'}
命令: {command}
错误代码: {result.returncode}
标准输出: {result.stdout.decode(encoding='utf8', errors='ignore') if len(result.stdout) > 0 else ''}
错误输出: {result.stderr.decode(encoding='utf8', errors='ignore') if len(result.stderr) > 0 else ''}
'''
        raise RuntimeError(message)

    return result.stdout.decode(encoding='utf8', errors='ignore')


def run_extension_installer(sd_webui_base_path: Path, extension_dir: Path) -> bool:
    '''执行扩展依赖安装脚本

    :param sd_webui_base_path`(Path)`: SD WebUI 跟目录, 用于导入自身模块
    :param extension_dir`(Path)`: 要执行安装脚本的扩展路径
    :return `bool`: 扩展依赖安装结果
    '''
    path_installer = extension_dir / 'install.py'
    if not path_installer.is_file():
        return

    try:
        env = os.environ.copy()
        py_path = env.get('PYTHONPATH', '')
        env['PYTHONPATH'] = f'{sd_webui_base_path}{os.pathsep}{py_path}'
        run_cmd(
            command=[sys.executable, str(path_installer)],
            custom_env=env,
        )
        return True
    except Exception as e:
        logger.info('执行 %s 扩展依赖安装脚本时发送错误: %s', extension_dir.name, e)
        traceback.print_exc()
        return False


def install_extension_requirements(
    sd_webui_base_path: Path,
    arg_disable_extra_extensions: bool = False,
    arg_disable_all_extensions: bool = False,
) -> None:
    '''安装 SD WebUI 扩展依赖

    :param sd_webui_base_path`(Path)`: SD WebUI 根目录
    :param arg_disable_extra_extensions`(bool)`: 是否禁用 SD WebUI 额外扩展
    :param arg_disable_all_extensions`(bool)`: 是否禁用 SD WebUI 所有扩展
    '''
    settings_file = sd_webui_base_path / 'config.json'
    extensions_dir = sd_webui_base_path / 'extensions'
    builtin_extensions_dir = sd_webui_base_path / 'extensions-builtin'
    ext_install_list = []
    ext_builtin_install_list = []
    settings = {}

    try:
        with open(settings_file, 'r', encoding='utf8') as file:
            settings = json.load(file)
    except Exception as e:
        logger.warning('Stable Diffusion WebUI 配置文件无效: %s', e)

    disabled_extensions = set(settings.get('disabled_extensions', []))
    disable_all_extensions = settings.get('disable_all_extensions', 'none')

    if (
        disable_all_extensions == 'all'
        or arg_disable_all_extensions
    ):
        logger.info('已禁用所有 Stable Diffusion WebUI 扩展, 不执行扩展依赖检查')
        return

    if extensions_dir.is_dir() and disable_all_extensions != 'extra' and not arg_disable_extra_extensions:
        ext_install_list = [
            x
            for x in extensions_dir.glob('*')
            if x.name not in disabled_extensions
            and
            (x / 'install.py').is_file()
        ]

    if builtin_extensions_dir.is_dir():
        ext_builtin_install_list = [
            x
            for x in builtin_extensions_dir.glob('*')
            if x.name not in disabled_extensions
            and
            (x / 'install.py').is_file()
        ]

    install_list = ext_install_list + ext_builtin_install_list
    extension_count = len(install_list)

    if extension_count == 0:
        logger.info('无待安装依赖的 Stable Diffusion WebUI 扩展')
        return

    count = 0
    for ext in install_list:
        count += 1
        ext_name = ext.name
        logger.info('[%s/%s] 执行 %s 扩展的依赖安装脚本中',
                    count, extension_count, ext_name)
        if run_extension_installer(
            sd_webui_base_path=sd_webui_base_path,
            extension_dir=ext,
        ):
            logger.info('[%s/%s] 执行 %s 扩展的依赖安装脚本成功',
                        count, extension_count, ext_name)
        else:
            logger.warning(
                '[%s/%s] 执行 %s 扩展的依赖安装脚本失败, 可能会导致该扩展运行异常',
                count, extension_count, ext_name
            )

    logger.info('[%s/%s] 安装 Stable Diffusion WebUI 扩展依赖结束',
                count, extension_count)


def main() -> None:
    '''主函数'''
    os.environ['WEBUI_LAUNCH_LIVE_OUTPUT'] = '1'
    args = get_args()
    base_path = args.sd_webui_base_path
    if base_path is None:
        logger.error('未通过 --sd-webui-base-path 参数指定 Stable Diffusion WebUI 路径')
        return

    install_extension_requirements(
        sd_webui_base_path=Path(base_path),
        arg_disable_extra_extensions=args.disable_extra_extensions,
        arg_disable_all_extensions=args.disable_all_extensions,
    )


if __name__ == '__main__':
    main()
