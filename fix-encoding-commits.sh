#!/bin/bash
# 修复乱码提交消息脚本

cd /e/dcc2025

# 设置UTF-8编码
export LANG=zh_CN.UTF-8
export LC_ALL=zh_CN.UTF-8

echo "开始修复乱码提交..."

# 修复 bcb0eba - 删除.vscode/settings.json
echo "修复提交 bcb0eba..."
GIT_SEQUENCE_EDITOR="sed -i 's/^pick bcb0eba/reword bcb0eba/'" git rebase -i bcb0eba^
git commit --amend -m "chore: 删除.vscode/settings.json"
git rebase --continue

# 修复 0f62d1b - 清理红队评估文档中的Git冲突标记
echo "修复提交 0f62d1b..."
GIT_SEQUENCE_EDITOR="sed -i 's/^pick 0f62d1b/reword 0f62d1b/'" git rebase -i 0f62d1b^
git commit --amend -m "fix: 清理红队评估文档中的Git冲突标记"
git rebase --continue

# 修复 a33272a - 完成竞品对标方案和红队评估+总结报告
echo "修复提交 a33272a..."
GIT_SEQUENCE_EDITOR="sed -i 's/^pick a33272a/reword a33272a/'" git rebase -i a33272a^
git commit --amend -m "feat: 完成竞品对标方案和红队评估+总结报告"
git rebase --continue

# 修复 d852f40 - 修改作者信息
echo "修复提交 d852f40 的作者信息..."
GIT_SEQUENCE_EDITOR="sed -i 's/^pick d852f40/edit d852f40/'" git rebase -i d852f40^
git commit --amend --author="MRYGP <mrygp@example.com>" --no-edit
git rebase --continue

echo "修复完成！"
