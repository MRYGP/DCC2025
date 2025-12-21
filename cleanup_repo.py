# -*- coding: utf-8 -*-
import os
import shutil
import sys
from pathlib import Path

# 设置输出编码
if sys.platform == 'win32':
    import io
    sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

# 设置工作目录
base_dir = Path(r"e:\dcc2025")

print("=" * 50)
print("DCC2025 仓库最终清理脚本")
print("=" * 50)
print()

# ===========================================
# 第1步：删除过期临时文件（4个）
# ===========================================
print("第1步：删除过期临时文件...")

files_to_delete = [
    "00_核心文档/近期执行计划-2025年12月第2周.md",
    "00_核心文档/贷查查-阶段1执行指南.md",
    "仓库精简建议报告.md",
    "仓库精简执行总结.md",
]

deleted_count = 0
for file_path in files_to_delete:
    full_path = base_dir / file_path
    if full_path.exists():
        full_path.unlink()
        print(f"[OK] 已删除: {file_path}")
        deleted_count += 1
    else:
        print(f"[SKIP] 文件不存在: {file_path}")

print(f"第1步完成: 删除了 {deleted_count} 个文件\n")

# ===========================================
# 第2步：归档历史版本文件（2个）
# ===========================================
print("第2步：归档历史版本文件...")

# 确保历史分析目录存在
history_dir = base_dir / "00_核心文档" / "历史分析"
history_dir.mkdir(parents=True, exist_ok=True)

files_to_archive = [
    ("00_核心文档/DCC2025-项目总协调蓝本v1.0.md", "DCC2025-项目总协调蓝本v1.0.md"),
    ("00_核心文档/贷查查-商业模式与系统架构说明v1.0.md", "贷查查-商业模式与系统架构说明v1.0.md"),
]

archived_count = 0
for source_path, filename in files_to_archive:
    source = base_dir / source_path
    dest = history_dir / filename
    if source.exists():
        shutil.move(str(source), str(dest))
        print(f"[OK] 已归档: {source_path} -> 历史分析/{filename}")
        archived_count += 1
    else:
        print(f"[SKIP] 文件不存在: {source_path}")

print(f"第2步完成: 归档了 {archived_count} 个文件\n")

# ===========================================
# 第3步：删除空目录
# ===========================================
print("第3步：删除空目录...")

dirs_to_delete = [
    "07_业务运营/H业务/archive",
    "04_案例库/内部测试",
]

deleted_dir_count = 0
for dir_path in dirs_to_delete:
    full_path = base_dir / dir_path
    if full_path.exists() and full_path.is_dir():
        try:
            # 检查目录是否为空
            if not any(full_path.iterdir()):
                full_path.rmdir()
                print(f"[OK] 已删除空目录: {dir_path}")
                deleted_dir_count += 1
            else:
                print(f"[SKIP] 目录不为空: {dir_path}")
        except Exception as e:
            print(f"[ERROR] 删除目录失败 {dir_path}: {e}")
    else:
        print(f"[SKIP] 目录不存在: {dir_path}")

print(f"第3步完成: 删除了 {deleted_dir_count} 个空目录\n")

print("=" * 50)
print("清理脚本执行完成！")
print("=" * 50)
print(f"\n统计:")
print(f"  - 删除文件: {deleted_count} 个")
print(f"  - 归档文件: {archived_count} 个")
print(f"  - 删除空目录: {deleted_dir_count} 个")

