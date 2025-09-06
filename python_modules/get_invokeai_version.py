from importlib.metadata import version

try:
    ver = version("invokeai")
except:
    ver = None

print(ver)
