#!/bin/bash
# 仓库文件清理执行脚本
# 生成日期：2025-12-28
# 用途：执行文件清理操作

echo "=== 仓库文件清理执行脚本 ==="
echo ""

# 创建备份分支
echo "步骤1: 创建备份分支..."
git checkout -b backup-before-cleanup-2025-12-28
git checkout master
echo "✅ 备份分支已创建"
echo ""

# P0: 重命名24问文档
echo "步骤2: 重命名24问文档 (v1.0 → v1.1)..."
git mv "DCC2025-24问完整答案-v1.0.md" "DCC2025-24问完整答案-v1.1.md"
git commit -m "docs: rename 24Q document to v1.1"
echo "✅ 24问文档已重命名"
echo ""

# P1: 删除10个临时文件
echo "步骤3: 删除10个临时文件..."
git rm "00_核心文档/历史分析/DCC2025项目总协调分析报告-Claude-v0.1.md"
git rm "00_核心文档/历史分析/DCC2025项目总协调分析报告-Cursor-总览.md"
git rm "00_核心文档/历史分析/DCC2025项目总协调分析报告-Cursor-第1部分.md"
git rm "00_核心文档/历史分析/DCC2025项目总协调分析报告-Cursor-第2部分.md"
git rm "00_核心文档/历史分析/DCC2025项目总协调分析报告-Cursor-第3部分.md"
git rm "00_核心文档/历史分析/DCC2025项目总协调分析报告-Cursor-第4部分.md"
git rm "00_核心文档/历史分析/Week1/Week1启动文档-平台清单与任务分配.md"
git rm "00_核心文档/历史分析/Week1/Week1完成情况总结-Day1.md"
git rm "00_核心文档/历史分析/近期执行计划-资金体检医生模式-第1轮实测.md"
git rm "00_核心文档/历史分析/H业务落地记录/H业务落地前期准备方案v1.0.md"
git commit -m "cleanup: remove 10 temporary analysis reports"
echo "✅ 10个临时文件已删除"
echo ""

# P2: 创建归档子目录
echo "步骤4: 创建归档子目录..."
mkdir -p "00_核心文档/历史分析/战略反思"
mkdir -p "00_核心文档/历史分析/规划记录"
echo "✅ 归档子目录已创建"
echo ""

# P3: 归档3个旧版文档
echo "步骤5: 归档3个旧版文档..."
git mv "00_核心文档/战略反思汇总-2025-12-23.md" "00_核心文档/历史分析/战略反思/战略反思汇总-2025-12-23.md"
git mv "00_核心文档/核心反思-项目需要什么人-2025-12-23.md" "00_核心文档/历史分析/战略反思/核心反思-项目需要什么人-2025-12-23.md"
git mv "00_核心文档/下一步规划-三个标准模型与招聘策略-2025-12-23.md" "00_核心文档/历史分析/规划记录/下一步规划-三个标准模型与招聘策略-2025-12-23.md"
git commit -m "refactor: archive old versions to history subdirectories"
echo "✅ 3个旧版文档已归档"
echo ""

# 验证
echo "步骤6: 验证清理结果..."
echo "当前Git状态:"
git status --short
echo ""
echo "最近5个提交:"
git log --oneline -5
echo ""

echo "=== 清理完成 ==="
echo ""
echo "下一步: 推送到远程仓库"
echo "git push origin master"

