from importlib.metadata import version

try:
    print(version("xformers"))
except:
    print("无")
