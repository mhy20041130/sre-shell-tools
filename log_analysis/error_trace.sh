#!/bin/bash
# 实时追踪错误日志脚本
LOG_PATH="/var/log/nginx/error.log"
KEYWORD="error|ERROR|warn|WARN"

# 校验日志文件是否存在
if [ ! -f "$LOG_PATH" ]; then
    echo "错误：日志文件 $LOG_PATH 不存在！"
    exit 1
fi

echo -e "实时追踪错误日志（关键词：$KEYWORD），按 Ctrl+C 退出\n"
tail -f "$LOG_PATH" | grep --line-buffered -E "$KEYWORD"
