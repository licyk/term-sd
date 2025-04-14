import re
import sys
import subprocess


try:
    output = subprocess.check_output(
        [sys.executable, "-m", "pip", "cache", "info"], text=True)
except:
    output = []

pattern_list = [
    r"^Package index page cache location \(pip v23\.3\+\):\s*(.*)$",
    r"^Package index page cache location \(older pips\):\s*(.*)$",
    r"^Package index page cache size:\s*(.*)$",
    r"^Number of HTTP files:\s*(.*)$",
    r"^Locally built wheels location:\s*(.*)$",
    r"^Locally built wheels size:\s*(.*)$",
    r"^Number of locally built wheels:\s*(.*)$",
]

value_list = []

for p in pattern_list:
    match = re.search(p, output, flags=re.MULTILINE)
    value_list.append(match.group(1)) if match else value_list.append(None)

print(";".join(value_list))
