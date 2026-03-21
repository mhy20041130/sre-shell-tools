# sre-shell-tools
面向 SRE / 运维开发 / DevOps 场景的实用 Shell 脚本工具箱，轻量化、可直接落地生产环境。

## 项目定位
日常运维自动化、故障排查、资源治理、监控自愈、日志分析常用脚本合集。
适合学习、面试展示、CI/CD 集成、服务器巡检使用。

## 功能模块

###  log_analysis 日志分析
- `nginx-log-stat.sh`：Nginx 访问日志统计（请求量、状态码分布、访问 TOP10 IP、平均响应时间）
- `error-trace.sh`：实时追踪错误日志，过滤 ERROR/WARN 关键词

###  auto_ops 自动化运维
- `deploy-app.sh`：应用一键发布 + 发布失败自动回滚
- `rollback-app.sh`：快速回滚到上一个备份版本

###  resource_manage 资源治理
- `clean-docker.sh`：清理 Docker 闲置镜像、容器、卷、网络
- `expired-cert.sh`：SSL 证书过期检查与清理（支持提前预警）

###  monitor_alarm 监控告警
- `dingtalk-alert.sh`：钉钉机器人告警推送
- `wechat-alert.sh`：企业微信机器人告警推送
- `disk-alarm-with-msg.sh`：磁盘使用率告警 + 自动清理旧日志 + 多渠道通知

## 快速开始
```bash
# 克隆项目
git clone https://github.com/你的用户名/sre-shell-tools.git

# 进入目录
cd sre-shell-tools

# 赋予执行权限
chmod +x log_analysis/*.sh auto_ops/*.sh resource_manage/*.sh monitor_alarm/*.sh

# 运行示例：统计 Nginx 日志
./log_analysis/nginx-log-stat.sh
