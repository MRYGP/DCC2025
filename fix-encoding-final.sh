#!/bin/bash
# 最终修复脚本 - 在Git Bash中运行

set -e

cd /e/dcc2025

# 设置UTF-8编码
export LANG=zh_CN.UTF-8
export LC_ALL=zh_CN.UTF-8

echo "开始修复乱码提交..."

# 查找需要修复的提交
COMMIT_TO_FIX=$(git log --oneline --all | grep -E "æ·|瀹" | head -1 | cut -d' ' -f1)

if [ -z "$COMMIT_TO_FIX" ]; then
    echo "未找到需要修复的乱码提交"
    exit 0
fi

echo "找到需要修复的提交: $COMMIT_TO_FIX"

# 获取该提交的父提交
PARENT=$(git rev-parse ${COMMIT_TO_FIX}^)

# 使用交互式rebase修复
echo "开始交互式rebase..."
GIT_SEQUENCE_EDITOR="sed -i 's/^pick ${COMMIT_TO_FIX}/edit ${COMMIT_TO_FIX}/'" git rebase -i $PARENT

# 修复提交消息
echo "修复提交消息..."
git commit --amend -m "feat: 添加完整分析框架文档"

# 继续rebase
git rebase --continue

echo "修复完成！"
