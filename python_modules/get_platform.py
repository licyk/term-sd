import sys

p = sys.platform

if p in ["win32", "linux", "darwin"]:
    print(p)
else:
    print("other")
