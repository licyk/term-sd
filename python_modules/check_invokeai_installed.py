from importlib.metadata import version

try:
    tmp = version("invokeai")
    print(True)
except:
    print(False)
