import importlib.metadata
import pathlib

package = "pypatchmatch"

try:
    # dist = importlib.metadata.files("ll")
    util = [p for p in importlib.metadata.files(package) if "__init__.py" in str(p)][0]
    path = pathlib.Path(util.locate()).parents[0]
    print(path.as_posix())
except importlib.metadata.PackageNotFoundError:
    print("None")
