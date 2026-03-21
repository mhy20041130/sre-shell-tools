#!/bin/bash
# 应用一键发布脚本（支持自动回滚）
APP_NAME="my-app"
APP_DIR="/opt/apps/$APP_NAME"
BACKUP_DIR="/opt/backup"
NEW_PACKAGE="./$APP_NAME.jar"

# 前置校验
if [ ! -f "$NEW_PACKAGE" ]; then
    echo "错误：新版本包 $NEW_PACKAGE 不存在！"
    exit 1
fi
mkdir -p "$BACKUP_DIR" "$APP_DIR"

echo "=== 开始发布应用：$APP_NAME ==="
# 1. 停止服务
echo "1. 停止服务..."
systemctl stop $APP_NAME || echo "服务未运行，跳过停止步骤"

# 2. 备份旧版本
echo "2. 备份旧版本..."
cp $APP_DIR/$APP_NAME.jar $BACKUP_DIR/${APP_NAME}_$(date +%Y%m%d%H%M).jar 2>/dev/null || echo "无旧版本，跳过备份"

# 3. 部署新版本
echo "3. 部署新版本..."
cp $NEW_PACKAGE $APP_DIR/

# 4. 启动服务
echo "4. 启动服务..."
systemctl start $APP_NAME

# 5. 校验发布结果
if systemctl is-active --quiet $APP_NAME; then
    echo -e "\n✅ 发布成功：$APP_NAME"
else
    echo -e "\n❌ 发布失败，执行回滚..."
    systemctl stop $APP_NAME
    cp $BACKUP_DIR/$(ls -t $BACKUP_DIR | head -1) $APP_DIR/$APP_NAME.jar 2>/dev/null
    systemctl start $APP_NAME
    echo "✅ 回滚完成，请检查服务状态"
fi
