import os
import importlib.util
from sd_webui_all_in_one.optimize.cuda_malloc import get_pytorch_cuda_alloc_conf


def main() -> None:
    try:
        version = ""
        torch_spec = importlib.util.find_spec("torch")
        for folder in torch_spec.submodule_search_locations:
            ver_file = os.path.join(folder, "version.py")
            if os.path.isfile(ver_file):
                spec = importlib.util.spec_from_file_location("torch_version_import", ver_file)
                module = importlib.util.module_from_spec(spec)
                spec.loader.exec_module(module)
                version = module.__version__
        if int(version[0]) >= 2:  # enable by default for torch version 2.0 and up
            if "+cu" in version:  # only on cuda torch
                malloc_type = get_pytorch_cuda_alloc_conf()
            else:
                malloc_type = get_pytorch_cuda_alloc_conf(False)
        else:
            malloc_type = None
    except Exception as _:
        malloc_type = None

    print(malloc_type)


if __name__ == "__main__":
    main()
