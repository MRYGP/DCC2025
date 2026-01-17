#!/bin/bash
# 修复单个乱码提交

cd /e/dcc2025
export LANG=zh_CN.UTF-8
export LC_ALL=zh_CN.UTF-8

COMMIT_HASH=$1
NEW_MESSAGE=$2

if [ -z "$COMMIT_HASH" ] || [ -z "$NEW_MESSAGE" ]; then
    echo "Usage: $0 <commit-hash> <new-message>"
    exit 1
fi

PARENT=$(git rev-parse ${COMMIT_HASH}^)

GIT_SEQUENCE_EDITOR="sed -i 's/^pick ${COMMIT_HASH}/reword ${COMMIT_HASH}/'" git rebase -i $PARENT
git commit --amend -m "$NEW_MESSAGE"
git rebase --continue

echo "修复完成: $COMMIT_HASH -> $NEW_MESSAGE"
