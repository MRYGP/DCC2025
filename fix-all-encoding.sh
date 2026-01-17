#!/bin/bash
# 批量修复所有乱码提交

cd /e/dcc2025
export LANG=zh_CN.UTF-8
export LC_ALL=zh_CN.UTF-8

# 创建提交消息修复函数
fix_commit_message() {
    COMMIT_HASH=$(git rev-parse HEAD)
    
    case "$COMMIT_HASH" in
        e6d8f758217634cf00ce193c1f8abd96cecc4a58)
            echo "chore: 删除.vscode/settings.json"
            ;;
        a33272ae5ed55dab530597c0425e26b308da1702)
            echo "feat: 完成竞品对标方案和红队评估+总结报告"
            ;;
        c2c89d3ed708728448a631fb7ff324297505e266)
            echo "fix: 清理红队评估文档中的Git冲突标记"
            ;;
        d852f40062528140b511af062728f87977ef9071)
            # 这个提交需要修改作者，消息保持不变
            cat
            ;;
        *)
            # 保持原消息不变
            cat
            ;;
    esac
}

# 修复作者信息
fix_author() {
    COMMIT_HASH=$(git rev-parse HEAD)
    
    if [ "$COMMIT_HASH" = "d852f40062528140b511af062728f87977ef9071" ]; then
        export GIT_AUTHOR_NAME="MRYGP"
        export GIT_AUTHOR_EMAIL="mrygp@example.com"
        export GIT_COMMITTER_NAME="MRYGP"
        export GIT_COMMITTER_EMAIL="mrygp@example.com"
    fi
}

echo "开始批量修复乱码提交..."
export FILTER_BRANCH_SQUELCH_WARNING=1

# 使用filter-branch修复提交消息和作者
git filter-branch -f --msg-filter 'fix_commit_message' --env-filter 'fix_author' -- --all

echo "修复完成！"
