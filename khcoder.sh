#!/bin/bash
# プロジェクトディレクトリに移動
cd "$(dirname "$0")"

# 0. 最初にDockerを起動
open -a Docker
sleep 2

# 1. XQuartz の起動確認（未起動なら起動）
open -a XQuartz
sleep 1

# 2. IPアドレスの取得と XQuartz へのアクセス許可
IP=$(ipconfig getifaddr en0)
if [ -z "$IP" ]; then
    # Wi-Fi以外の接続（有線等）を考慮したフォールバック
    IP=$(ipconfig getifaddr en1)
fi

xhost + $IP

# 3. MySQL のバックグラウンド起動
docker compose up -d mysql

# 4. KH Coder の実行
# -w オプションで作業ディレクトリを指定して直接起動
docker compose run --rm \
  -e DISPLAY=$IP:0 \
  -w /KHCoder/khcoder \
  nl2e perl kh_coder.pl

# 5. KH Coder 終了後の後始末（不要なコンテナ停止）
docker compose down
