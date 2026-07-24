#!/usr/bin/env bash
# Codespaces/devcontainer 初始化:安装 xlings,再按 .xlings.json 配置课程工具链(mcpp + d2x)
set -euo pipefail

sudo apt-get update
sudo apt-get install -y ncurses-bin libtinfo6 libncursesw6 curl ca-certificates git

if ! command -v xlings >/dev/null 2>&1; then
  curl -fsSL https://raw.githubusercontent.com/openxlings/xlings/main/tools/other/quick_install.sh | bash -s "v0.4.68"
fi

export PATH="$HOME/.xlings/subos/current/bin:$PATH"

xlings update
xlings install -y

# 预热 Provider:把首次构建(含工具链下载)放在环境准备阶段,
# 避免首次进入 d2x checker 时长时间无反馈。
mcpp run -q -p d2x/buildtools -- describe > /dev/null \
  || echo "warning: provider warm-up failed; d2x checker will build it on first run"

echo "d2mcpp environment ready"
