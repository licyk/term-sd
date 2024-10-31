import os
import argparse
from pathlib import Path



def get_args():
    parser = argparse.ArgumentParser()
    normalized_filepath = lambda filepath: str(Path(filepath).absolute().as_posix())

    parser.add_argument("--venv-bin-path", type = normalized_filepath, default = None, help = "虚拟环境的 bin 路径")
    parser.add_argument("--venv-path", type = normalized_filepath, default = None, help = "虚拟环境的路径")

    return parser.parse_args()


# 打开文件并读取内容
def read_content_from_file(path: str) -> list:
    lines = []
    try:
        with open(path, "r", encoding="utf-8") as file:
            for line in file:
                # 去除每行的换行符并添加到列表中
                lines.append(line.strip())
    except:
        pass
    return lines


# 获取 activate 文件中的虚拟环境路径
def get_virtual_env_sh(content: list) -> str:
    for line in content:
        line = line.strip()
        if line.startswith("VIRTUAL_ENV"):
            line = line.split("VIRTUAL_ENV=\"").pop()[:-1]
            return line

    return None


# 获取 activate.bat 文件中虚拟环境的路径
def get_virtual_env_bat(content: list) -> str:
    for line in content:
        line = line.strip()
        if line.startswith("set VIRTUAL_ENV="):
            line = line.split("set VIRTUAL_ENV=").pop()
            return line

    return None



if __name__ == "__main__":
    args = get_args()
    venv_bin_path = Path(args.venv_bin_path)
    venv_path = Path(args.venv_path)
    activate_sh_path = os.path.join(venv_bin_path, "activate")
    activate_bat_path = os.path.join(venv_bin_path, "activate.bat")
    venv_broken = False

    sh_file_content = read_content_from_file(activate_sh_path)
    bat_file_content = read_content_from_file(activate_bat_path)

    venv_path_sh = get_virtual_env_sh(sh_file_content)
    venv_path_bat = get_virtual_env_bat(bat_file_content)

    if venv_path_sh is not None and Path(venv_path_sh) != Path(venv_path):
        venv_broken = True

    if venv_path_bat is not None and Path(venv_path_bat) != Path(venv_path):
        venv_broken = True

    print(venv_broken)
