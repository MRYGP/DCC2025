# Git提交消息编码问题修复说明

## 问题描述

在PowerShell环境下，Git提交消息中的中文可能出现乱码。

### 问题根源

1. **编码不匹配**：
   - Windows PowerShell默认使用GBK/GB2312编码（代码页936）
   - Git配置为UTF-8编码
   - 当在PowerShell中直接传递中文字符串给Git时，编码不匹配导致乱码

2. **具体表现**：
   - 提交消息在GitHub上显示为乱码（如"鏢肺擴"应该是"删除"）
   - 本地`git log`也可能显示乱码
   - 但文件内容本身不受影响

3. **为什么会出现**：
   - 在PowerShell中直接使用 `git commit -m "中文消息"` 时
   - PowerShell将中文字符串按GBK编码传递给Git
   - Git期望UTF-8编码，导致解码错误

## 解决方案

### 方法1：使用临时文件提交（推荐，适用于新提交）

```bash
# 1. 创建临时文件，写入提交消息（UTF-8编码）
echo "feat: 你的提交消息" > commit_msg.txt

# 2. 使用文件提交
git commit -F commit_msg.txt

# 3. 删除临时文件
del commit_msg.txt
```

### 方法2：在Git Bash中修复历史提交

对于已经存在的乱码提交，需要在Git Bash中修复：

```bash
# 1. 打开Git Bash，进入项目目录
cd /e/dcc2025

# 2. 设置编码环境变量
export LANG=zh_CN.UTF-8
export LC_ALL=zh_CN.UTF-8

# 3. 修复最近的提交
git rebase -i HEAD~1
# 在编辑器中，将第一行的 `pick` 改为 `reword`
# 保存退出后，输入正确的提交消息

# 4. 推送到远程（如果需要）
git push --force-with-lease origin master
```

## 预防措施

### 1. 配置Git编码（已配置）
```bash
git config --global i18n.commitencoding utf-8
git config --global i18n.logoutputencoding utf-8
```

### 2. 使用自动化脚本（推荐）⭐

已创建两个PowerShell脚本，自动处理UTF-8编码：

**提交新更改**：
```powershell
.\git-commit-utf8.ps1 "feat: 你的提交消息"
```

**修改最新提交**：
```powershell
.\git-commit-amend-utf8.ps1 "feat: 修改后的提交消息"
```

这些脚本会自动：
- 设置UTF-8编码
- 创建临时文件（UTF-8编码）
- 使用临时文件提交
- 自动清理临时文件

### 3. 手动使用临时文件

如果不想使用脚本，可以手动操作：
```powershell
# 1. 创建临时文件（UTF-8编码）
"feat: 你的提交消息" | Out-File -Encoding UTF8 commit_msg.txt

# 2. 使用文件提交
git commit -F commit_msg.txt

# 3. 删除临时文件
Remove-Item commit_msg.txt
```

### 4. 在Git Bash中提交

对于包含中文的提交，也可以在Git Bash中操作（推荐用于修复历史提交）

## 当前状态

- ✅ Git编码配置已设置
- ⚠️ 部分历史提交消息仍有乱码（需要在Git Bash中手动修复）
- ✅ 最新提交已修复

## 注意事项

- 修复历史提交需要强制推送（`--force-with-lease`），会重写远程历史
- 确保没有其他人在使用这些提交，避免影响团队协作
- 建议在修复前创建备份分支
