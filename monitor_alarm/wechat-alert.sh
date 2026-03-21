#!/bin/bash
# 企业微信机器人告警脚本（需替换自己的key）
WEBHOOK_URL="https://qyapi.weixin.qq.com/cgi-bin/webhook/send?key=你的企业微信机器人key"
CONTENT="$1"

# 校验参数
if [ -z "$CONTENT" ]; then
    echo "用法：$0 告警内容"
    exit 1
fi

# 发送企业微信告警
curl -s -X POST "$WEBHOOK_URL" \
  -H "Content-Type: application/json" \
  -d "{
    \"msgtype\": \"text\",
    \"text\": {
      \"content\": \"【SRE运维告警】${CONTENT}\"
    }
  }" > /dev/null 2>&1

if [ $? -eq 0 ]; then
    echo "✅ 企业微信告警发送成功"
else
    echo "❌ 企业微信告警发送失败"
fi
