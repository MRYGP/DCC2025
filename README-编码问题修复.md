# Git提交消息编码问题修复说明

## 问题描述

在PowerShell环境下，Git提交消息中的中文可能出现乱码。这是因为PowerShell的编码处理与Git不完全兼容。

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

1. **配置Git编码**（已配置）：
   ```bash
   git config --global i18n.commitencoding utf-8
   git config --global i18n.logoutputencoding utf-8
   ```

2. **使用临时文件提交**：避免在PowerShell命令行中直接传递中文字符串

3. **在Git Bash中提交**：对于包含中文的提交，建议在Git Bash中操作

## 当前状态

- ✅ Git编码配置已设置
- ⚠️ 部分历史提交消息仍有乱码（需要在Git Bash中手动修复）
- ✅ 最新提交已修复

## 注意事项

- 修复历史提交需要强制推送（`--force-with-lease`），会重写远程历史
- 确保没有其他人在使用这些提交，避免影响团队协作
- 建议在修复前创建备份分支
