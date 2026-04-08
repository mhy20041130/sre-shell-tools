#!/bin/bash
# 应用快速回滚脚本
APP_NAME="my-app"
APP_DIR="/opt/apps/$APP_NAME"
BACKUP_DIR="/opt/backup"

# 前置校验
if [ ! -d "$BACKUP_DIR" ]; then
    echo "错误：备份目录 $BACKUP_DIR 不存在！"
    exit 1
fi

# 获取最新备份包
LATEST_BACKUP=$(ls -t $BACKUP_DIR | head -1)
if [ -z "$LATEST_BACKUP" ]; then
    echo "错误：无可用备份包！"
    exit 1
fi

echo "=== 开始回滚应用：$APP_NAME ==="
echo "回滚版本：$LATEST_BACKUP"

# 1. 停止服务
systemctl stop $APP_NAME || echo "服务未运行，跳过停止步骤"

# 2. 回滚版本
cp $BACKUP_DIR/$LATEST_BACKUP $APP_DIR/$APP_NAME.jar

# 3. 启动服务
systemctl start $APP_NAME

# 4. 校验回滚结果
if systemctl is-active --quiet $APP_NAME; then
    echo -e "\n回滚成功：$APP_NAME"
else
    echo -e "\n回滚失败，请手动检查！"
fi
