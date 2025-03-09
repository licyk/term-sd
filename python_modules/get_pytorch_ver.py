from importlib.metadata import version

try:
    print(version('torch'))
except:
    print('无')
