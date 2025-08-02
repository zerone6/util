#!/bin/bash

# 1. 모든 컨테이너 중지 및 제거
docker stop $(docker ps -aq) 2>/dev/null || echo "No containers to stop"
docker rm $(docker ps -aq) 2>/dev/null || echo "No containers to remove"

# 2. 모든 이미지 제거
docker rmi $(docker images -q) 2>/dev/null || echo "No images to remove"

# 3. 모든 볼륨 제거
docker volume rm $(docker volume ls -q) 2>/dev/null || echo "No volumes to remove"

# 4. 모든 네트워크 제거 (기본 네트워크 제외)
docker network rm $(docker network ls -q) 2>/dev/null || echo "No networks to remove"

# 5. Docker 시스템 전체 정리
docker system prune -a --volumes -f

# 6. 기존 앱 디렉토리 백업 및 정리
cd ~/
if [ -d "app" ]; then
    mv app app.backup.$(date +%Y%m%d_%H%M%S)
fi
mkdir -p app

# 7. 상태 확인
echo "=== Docker 초기화 완료 ==="
echo "컨테이너: $(docker ps -a | wc -l) 개"
echo "이미지: $(docker images | wc -l) 개"
echo "볼륨: $(docker volume ls | wc -l) 개"
echo "네트워크: $(docker network ls | wc -l) 개"