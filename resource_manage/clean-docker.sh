#!/bin/bash
# Docker无用资源清理脚本（SRE资源治理专用）
echo "=== 开始清理Docker无用资源 ==="

# 停止并删除所有退出状态的容器
echo "1. 清理退出容器..."
docker ps -a --filter "status=exited" -q | xargs -r docker rm

# 删除未使用的镜像（dangling镜像）
echo "2. 清理悬空镜像..."
docker images -f "dangling=true" -q | xargs -r docker rmi

# 删除未使用的卷
echo "3. 清理未使用卷..."
docker volume ls -f "dangling=true" -q | xargs -r docker volume rm

# 删除未使用的网络
echo "4. 清理未使用网络..."
docker network ls -f "dangling=true" -q | xargs -r docker network rm

echo -e "\n Docker资源清理完成"
echo "当前Docker资源使用情况："
docker system df
