#!/bin/bash
# 过期SSL证书检查与清理脚本
CERT_DIR="/etc/nginx/certs"  # 证书存放目录，可根据实际修改
EXPIRED_DAYS=7  # 提前7天检测即将过期的证书

# 校验证书目录是否存在
if [ ! -d "$CERT_DIR" ]; then
    echo "错误：证书目录 $CERT_DIR 不存在！"
    exit 1
fi

echo -e "=== 开始检测SSL证书（提前$EXPIRED_DAYS天预警）===\n"

# 遍历所有证书文件
for cert in $CERT_DIR/*.pem $CERT_DIR/*.crt; do
    if [ -f "$cert" ]; then
        # 获取证书过期时间（时间戳）
        EXPIRE_DATE=$(openssl x509 -in "$cert" -noout -enddate | awk -F= '{print $2}')
        EXPIRE_TIMESTAMP=$(date -d "$EXPIRE_DATE" +%s)
        NOW_TIMESTAMP=$(date +%s)
        DAYS_LEFT=$(( (EXPIRE_TIMESTAMP - NOW_TIMESTAMP) / 86400 ))

        if [ $DAYS_LEFT -lt 0 ]; then
            echo " 证书已过期：$cert（过期$((-DAYS_LEFT))天）"
            # 注释掉下面一行可自动删除过期证书（建议先确认再开启）
            # rm -f "$cert" && echo "已删除过期证书：$cert"
        elif [ $DAYS_LEFT -lt $EXPIRED_DAYS ]; then
            echo "  证书即将过期：$cert（剩余$DAYS_LEFT天）"
        else
            echo "证书正常：$cert（剩余$DAYS_LEFT天）"
        fi
    fi
done
