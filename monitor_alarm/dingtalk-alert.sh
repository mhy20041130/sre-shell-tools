#!/bin/bash
# 钉钉机器人告警脚本（需替换自己的token）
WEBHOOK_URL="https://oapi.dingtalk.com/robot/send?access_token=你的钉钉机器人token"
TITLE="【SRE运维告警】"
CONTENT="$1"

# 校验参数
if [ -z "$CONTENT" ]; then
    echo "用法：$0 告警内容"
    exit 1
fi

# 发送钉钉告警
curl -s -X POST "$WEBHOOK_URL" \
  -H "Content-Type: application/json" \
  -d "{
    \"msgtype\": \"text\",
    \"text\": {
      \"content\": \"${TITLE}\n${CONTENT}\"
    }
  }" > /dev/null 2>&1

if [ $? -eq 0 ]; then
    echo "✅ 钉钉告警发送成功"
else
    echo "❌ 钉钉告警发送失败"
fi
