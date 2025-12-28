# 仓库文件清理执行脚本 (PowerShell版本)
# 生成日期：2025-12-28
# 用途：执行文件清理操作

Write-Host "=== 仓库文件清理执行脚本 ===" -ForegroundColor Green
Write-Host ""

# 创建备份分支
Write-Host "步骤1: 创建备份分支..." -ForegroundColor Yellow
git checkout -b backup-before-cleanup-2025-12-28
git checkout master
Write-Host "✅ 备份分支已创建" -ForegroundColor Green
Write-Host ""

# P0: 重命名24问文档
Write-Host "步骤2: 重命名24问文档 (v1.0 → v1.1)..." -ForegroundColor Yellow
$oldName = "DCC2025-24问完整答案-v1.0.md"
$newName = "DCC2025-24问完整答案-v1.1.md"
if (Test-Path $oldName) {
    git mv $oldName $newName
    git commit -m "docs: rename 24Q document to v1.1"
    Write-Host "✅ 24问文档已重命名" -ForegroundColor Green
} else {
    Write-Host "⚠️  文件不存在，跳过" -ForegroundColor Yellow
}
Write-Host ""

# P1: 删除10个临时文件
Write-Host "步骤3: 删除10个临时文件..." -ForegroundColor Yellow
$filesToDelete = @(
    "00_核心文档/历史分析/DCC2025项目总协调分析报告-Claude-v0.1.md",
    "00_核心文档/历史分析/DCC2025项目总协调分析报告-Cursor-总览.md",
    "00_核心文档/历史分析/DCC2025项目总协调分析报告-Cursor-第1部分.md",
    "00_核心文档/历史分析/DCC2025项目总协调分析报告-Cursor-第2部分.md",
    "00_核心文档/历史分析/DCC2025项目总协调分析报告-Cursor-第3部分.md",
    "00_核心文档/历史分析/DCC2025项目总协调分析报告-Cursor-第4部分.md",
    "00_核心文档/历史分析/Week1/Week1启动文档-平台清单与任务分配.md",
    "00_核心文档/历史分析/Week1/Week1完成情况总结-Day1.md",
    "00_核心文档/历史分析/近期执行计划-资金体检医生模式-第1轮实测.md",
    "00_核心文档/历史分析/H业务落地记录/H业务落地前期准备方案v1.0.md"
)

$deletedCount = 0
foreach ($file in $filesToDelete) {
    if (Test-Path $file) {
        git rm $file
        $deletedCount++
    }
}

if ($deletedCount -gt 0) {
    git commit -m "cleanup: remove $deletedCount temporary analysis reports"
    Write-Host "✅ $deletedCount 个临时文件已删除" -ForegroundColor Green
} else {
    Write-Host "⚠️  没有找到需要删除的文件" -ForegroundColor Yellow
}
Write-Host ""

# P2: 创建归档子目录
Write-Host "步骤4: 创建归档子目录..." -ForegroundColor Yellow
$dirs = @(
    "00_核心文档/历史分析/战略反思",
    "00_核心文档/历史分析/规划记录"
)

foreach ($dir in $dirs) {
    if (-not (Test-Path $dir)) {
        New-Item -ItemType Directory -Path $dir -Force | Out-Null
    }
}
Write-Host "✅ 归档子目录已创建" -ForegroundColor Green
Write-Host ""

# P3: 归档3个旧版文档
Write-Host "步骤5: 归档3个旧版文档..." -ForegroundColor Yellow
$filesToArchive = @(
    @{
        Source = "00_核心文档/战略反思汇总-2025-12-23.md"
        Dest = "00_核心文档/历史分析/战略反思/战略反思汇总-2025-12-23.md"
    },
    @{
        Source = "00_核心文档/核心反思-项目需要什么人-2025-12-23.md"
        Dest = "00_核心文档/历史分析/战略反思/核心反思-项目需要什么人-2025-12-23.md"
    },
    @{
        Source = "00_核心文档/下一步规划-三个标准模型与招聘策略-2025-12-23.md"
        Dest = "00_核心文档/历史分析/规划记录/下一步规划-三个标准模型与招聘策略-2025-12-23.md"
    }
)

$archivedCount = 0
foreach ($file in $filesToArchive) {
    if (Test-Path $file.Source) {
        git mv $file.Source $file.Dest
        $archivedCount++
    }
}

if ($archivedCount -gt 0) {
    git commit -m "refactor: archive $archivedCount old versions to history subdirectories"
    Write-Host "✅ $archivedCount 个旧版文档已归档" -ForegroundColor Green
} else {
    Write-Host "⚠️  没有找到需要归档的文件" -ForegroundColor Yellow
}
Write-Host ""

# 验证
Write-Host "步骤6: 验证清理结果..." -ForegroundColor Yellow
Write-Host "当前Git状态:" -ForegroundColor Cyan
git status --short
Write-Host ""
Write-Host "最近5个提交:" -ForegroundColor Cyan
git log --oneline -5
Write-Host ""

Write-Host "=== 清理完成 ===" -ForegroundColor Green
Write-Host ""
Write-Host "下一步: 推送到远程仓库" -ForegroundColor Yellow
Write-Host "git push origin master" -ForegroundColor Cyan

