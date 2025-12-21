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

# 任务1: 移动单个文件
source1 = base_dir / "00_核心文档" / "外部知识库整合方案-完整版.md"
dest1 = base_dir / "00_核心文档" / "历史分析" / "外部知识库整合方案-完整版.md"
if source1.exists():
    dest1.parent.mkdir(parents=True, exist_ok=True)
    shutil.move(str(source1), str(dest1))
    print(f"[OK] 已移动: {source1.name} -> 历史分析/")
else:
    print(f"[ERROR] 文件不存在: {source1}")

# 任务2: 移动整个目录
source2 = base_dir / "00_核心文档" / "会计实习生"
dest2 = base_dir / "00_核心文档" / "历史分析" / "会计实习生"
if source2.exists():
    dest2.parent.mkdir(parents=True, exist_ok=True)
    shutil.move(str(source2), str(dest2))
    print(f"[OK] 已移动目录: 会计实习生/ -> 历史分析/会计实习生/")
else:
    print(f"[ERROR] 目录不存在: {source2}")

# 任务3: 创建招聘记录目录并移动3个招聘文档
recruit_dir = base_dir / "00_核心文档" / "历史分析" / "招聘记录"
recruit_dir.mkdir(parents=True, exist_ok=True)

files_to_move = [
    ("07_业务运营/合伙人体系/合伙人运营岗-面试记录表v1.1.md", "合伙人运营岗-面试记录表v1.1.md"),
    ("07_业务运营/合伙人体系/合伙人运营岗-面试速查版v1.1.md", "合伙人运营岗-面试速查版v1.1.md"),
    ("07_业务运营/合伙人体系/合伙人运营岗-入职安排v1.1.md", "合伙人运营岗-入职安排v1.1.md"),
]

for source_path, filename in files_to_move:
    source = base_dir / source_path
    dest = recruit_dir / filename
    if source.exists():
        shutil.move(str(source), str(dest))
        print(f"[OK] 已移动: {filename} -> 历史分析/招聘记录/")
    else:
        print(f"[ERROR] 文件不存在: {source}")

# 任务4: 创建合伙人记录目录并移动个人文档
partner_dir = base_dir / "00_核心文档" / "历史分析" / "合伙人记录"
partner_dir.mkdir(parents=True, exist_ok=True)

source4 = base_dir / "07_业务运营" / "合伙人体系" / "宋梦杰-完整版.md"
dest4 = partner_dir / "宋梦杰-完整版.md"
if source4.exists():
    shutil.move(str(source4), str(dest4))
    print(f"[OK] 已移动: 宋梦杰-完整版.md -> 历史分析/合伙人记录/")
else:
    print(f"[ERROR] 文件不存在: {source4}")

print("\n所有文件移动完成！")

