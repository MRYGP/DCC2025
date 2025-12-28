@echo off
chcp 65001 >nul
echo 删除旧版战略反思文档...
git rm "00_核心文档/战略反思汇总-2025-12-23.md"
if %errorlevel% equ 0 (
    echo ✅ 删除成功
    git commit -m "cleanup: remove old strategic reflection (2025-12-23)"
    echo ✅ 已提交
) else (
    echo ⚠️ 删除失败，可能文件不存在
)
pause

