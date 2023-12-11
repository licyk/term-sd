#!/bin/bash

list=$(find extra config help install modules task)

for i in $list; do
    dos2unix $i
done

dos2unix term-sd.sh
dos2unix build.sh
dos2unix README.md
echo "完成"
