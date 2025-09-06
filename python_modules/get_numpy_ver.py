import importlib.metadata
from importlib.metadata import version

try:
    print(version("numpy").split(".")[0])
except importlib.metadata.PackageNotFoundError:
    print("-1")
