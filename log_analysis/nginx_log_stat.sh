#!/bin/bash
# Nginx日志统计分析脚本（SRE故障排查专用）
LOG_PATH="/var/log/nginx/access.log"

# 校验日志文件是否存在
if [ ! -f "$LOG_PATH" ]; then
    echo "错误：Nginx日志文件 $LOG_PATH 不存在！"
    exit 1
fi

echo -e "\n=== Nginx 访问日志统计报告 ==="
echo "1. 总请求数: $(wc -l < $LOG_PATH)"
echo "2. 状态码分布:"
awk '{count[$9]++} END {for(code in count) print code, count[code]}' $LOG_PATH | sort -rn -k2
echo "3. 访问量TOP10 IP:"
awk '{print $1}' $LOG_PATH | sort | uniq -c | sort -rn | head -10
echo "4. 平均响应时间: $(awk '{sum += $10} END {print sum/NR}' $LOG_PATH | cut -c 1-7) ms"
