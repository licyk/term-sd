#!/bin/bash
#没啥用的脚本
term_sd_notice "当前可用扩展脚本列表"
print_line_to_shell
ls -lrh "./term-sd/extra" --time-style=+"%Y-%m-%d" | awk 'NR>=2 {print "  "$7}' | awk -F'.sh' '{print $1}'
print_line_to_shell
term_sd_notice "提示:使用\"--extra\"启动参数启动扩展脚本选项界面,或者使用\"--extra 脚本名\"直接启动指定的扩展脚本"
