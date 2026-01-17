#!/bin/bash
# 修复剩余的乱码提交

cd /e/dcc2025
export LANG=zh_CN.UTF-8
export LC_ALL=zh_CN.UTF-8

echo "开始修复剩余的乱码提交..."

# 修复 e6d8f75 - 删除.vscode/settings.json
echo "修复提交 e6d8f75..."
PARENT=$(git rev-parse e6d8f75^)
GIT_SEQUENCE_EDITOR="sed -i 's/^pick e6d8f75/reword e6d8f75/'" git rebase -i $PARENT
git commit --amend -m "chore: 删除.vscode/settings.json"
git rebase --continue

# 修复 a33272a - 完成竞品对标方案和红队评估+总结报告
echo "修复提交 a33272a..."
PARENT=$(git rev-parse a33272a^)
GIT_SEQUENCE_EDITOR="sed -i 's/^pick a33272a/reword a33272a/'" git rebase -i $PARENT
git commit --amend -m "feat: 完成竞品对标方案和红队评估+总结报告"
git rebase --continue

# 修复 d852f40 - 修改作者信息
echo "修复提交 d852f40 的作者..."
PARENT=$(git rev-parse d852f40^)
GIT_SEQUENCE_EDITOR="sed -i 's/^pick d852f40/edit d852f40/'" git rebase -i $PARENT
git commit --amend --author="MRYGP <mrygp@example.com>" --no-edit
git rebase --continue

echo "修复完成！"
