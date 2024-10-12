import os

print(f"{os.getcwd()}{os.pathsep}{os.environ.get('PYTHONPATH', '')}")