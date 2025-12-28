@echo off
chcp 65001 >nul
echo ========================================
echo 仓库文件清理执行脚本
echo ========================================
echo.

echo [步骤1] 检查当前分支...
git branch --show-current
echo.

echo [步骤2] P0 - 重命名24问文档...
git mv "DCC2025-24问完整答案-v1.0.md" "DCC2025-24问完整答案-v1.1.md"
if %errorlevel% equ 0 (
    echo ✅ 重命名成功
    git commit -m "docs: rename 24Q document from v1.0 to v1.1"
) else (
    echo ⚠️ 重命名失败，可能文件不存在或已重命名
)
echo.

echo [步骤3] P1 - 删除10个临时文件...
git rm "00_核心文档/历史分析/DCC2025项目总协调分析报告-Claude-v0.1.md" 2>nul
git rm "00_核心文档/历史分析/DCC2025项目总协调分析报告-Cursor-总览.md" 2>nul
git rm "00_核心文档/历史分析/DCC2025项目总协调分析报告-Cursor-第1部分.md" 2>nul
git rm "00_核心文档/历史分析/DCC2025项目总协调分析报告-Cursor-第2部分.md" 2>nul
git rm "00_核心文档/历史分析/DCC2025项目总协调分析报告-Cursor-第3部分.md" 2>nul
git rm "00_核心文档/历史分析/DCC2025项目总协调分析报告-Cursor-第4部分.md" 2>nul
git rm "00_核心文档/历史分析/Week1/Week1启动文档-平台清单与任务分配.md" 2>nul
git rm "00_核心文档/历史分析/Week1/Week1完成情况总结-Day1.md" 2>nul
git rm "00_核心文档/历史分析/近期执行计划-资金体检医生模式-第1轮实测.md" 2>nul
git rm "00_核心文档/历史分析/H业务落地记录/H业务落地前期准备方案v1.0.md" 2>nul

echo 检查删除结果...
git status --short
echo.

echo [步骤4] 提交删除操作...
git commit -m "cleanup: remove 10 temporary analysis reports"
echo.

echo [步骤5] 推送到远程...
git push origin master
echo.

echo ========================================
echo 清理完成！
echo ========================================
pause

