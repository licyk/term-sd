#!/bin/bash
# 没啥用的脚本
term_sd_echo "当前可用扩展脚本列表"
term_sd_print_line
ls -lrh "${START_PATH}/term-sd/extra" --time-style=+"%Y-%m-%d" | awk 'NR>=2 {print "  "$7}' | awk -F '.sh' '{print $1}'
term_sd_print_line
term_sd_echo "提示: 使用 \"--extra\" 启动参数启动扩展脚本选项界面, 或者使用 \"--extra 脚本名\" 直接启动指定的扩展脚本"
