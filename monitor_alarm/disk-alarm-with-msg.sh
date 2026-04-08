#!/bin/bash
# 磁盘使用率告警+钉钉/企业微信通知脚本
MOUNT_POINT="/"  # 监控的挂载点，可根据实际修改
THRESHOLD=85     # 告警阈值（%）
ALERT_SCRIPT_DIR="./monitor_alarm"  # 告警脚本目录

# 获取磁盘使用率
USED=$(df -h "$MOUNT_POINT" | awk 'NR==2 {print $5}' | tr -d '%')
HOSTNAME=$(hostname)
MSG="服务器【$HOSTNAME】磁盘挂载点【$MOUNT_POINT】使用率达到${USE}%（阈值${THRESHOLD}%），请及时处理！"

echo "当前${MOUNT_POINT}磁盘使用率：${USE}%"

# 使用率超过阈值则告警
if [ "$USED" -ge "$THRESHOLD" ]; then
    echo -e "\n  磁盘使用率超过阈值，开始发送告警..."
    # 调用钉钉告警
    $ALERT_SCRIPT_DIR/dingtalk-alert.sh "$MSG"
    # 调用企业微信告警
    $ALERT_SCRIPT_DIR/wechat-alert.sh "$MSG"

    # 自动清理7天前的日志（尝试释放空间）
    echo -e "\n开始自动清理7天前的日志文件..."
    find /var/log -name "*.log*" -type f -mtime +7 -delete
    echo "日志清理完成！"

    # 再次检查使用率
    NEW_USED=$(df -h "$MOUNT_POINT" | awk 'NR==2 {print $5}' | tr -d '%')
    echo "清理后磁盘使用率：${NEW_USED}%"
fi
