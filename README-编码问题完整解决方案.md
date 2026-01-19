# Git提交消息乱码问题 - 完整解决方案

## 📋 问题根源

### 为什么会出现乱码？

1. **编码不匹配**：
   - Windows PowerShell默认使用 **GBK/GB2312编码**（代码页936）
   - Git配置为 **UTF-8编码**
   - 当在PowerShell中直接传递中文字符串给Git时，编码不匹配导致乱码

2. **具体表现**：
   ```
   PowerShell: git commit -m "删除文件"
   ↓ (GBK编码传递)
   Git接收: 乱码字符
   ↓ (UTF-8解码)
   GitHub显示: "鏢肺擴" (乱码)
   ```

3. **影响范围**：
   - ✅ 文件内容不受影响（文件本身是UTF-8编码）
   - ❌ 提交消息显示乱码
   - ❌ 历史记录可读性差

## ✅ 解决方案（3种方法）

### 方法1：使用自动化脚本（最推荐）⭐

已创建两个PowerShell脚本，自动处理UTF-8编码：

**提交新更改**：
```powershell
.\git-commit-utf8.ps1 "feat: 你的提交消息"
```

**修改最新提交**：
```powershell
.\git-commit-amend-utf8.ps1 "feat: 修改后的提交消息"
```

**优点**：
- 自动处理编码问题
- 无需手动创建临时文件
- 使用简单，一条命令搞定

### 方法2：手动使用临时文件

```powershell
# 1. 创建临时文件（UTF-8编码）
"feat: 你的提交消息" | Out-File -Encoding UTF8 commit_msg.txt

# 2. 使用文件提交
git commit -F commit_msg.txt

# 3. 删除临时文件
Remove-Item commit_msg.txt
```

**优点**：
- 不依赖脚本
- 完全控制编码

**缺点**：
- 需要手动操作3步
- 容易忘记删除临时文件

### 方法3：在Git Bash中操作

```bash
# 1. 打开Git Bash
cd /e/dcc2025

# 2. 设置编码环境变量
export LANG=zh_CN.UTF-8
export LC_ALL=zh_CN.UTF-8

# 3. 正常提交
git commit -m "feat: 你的提交消息"
```

**优点**：
- Git Bash原生支持UTF-8
- 无需额外配置

**缺点**：
- 需要在Git Bash中操作
- 切换终端环境

## 🛡️ 预防措施

### 1. 配置Git编码（已配置）

```bash
git config --global i18n.commitencoding utf-8
git config --global i18n.logoutputencoding utf-8
git config --global core.quotepath false
```

### 2. 配置PowerShell默认编码（可选）

在PowerShell配置文件中添加：
```powershell
# 设置PowerShell输出编码为UTF-8
$OutputEncoding = [System.Text.Encoding]::UTF8
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
```

### 3. 使用自动化脚本（推荐）

将 `git-commit-utf8.ps1` 和 `git-commit-amend-utf8.ps1` 放在项目根目录，随时使用。

### 4. 建立团队规范

- 统一使用UTF-8编码
- 提交消息包含中文时，使用脚本或临时文件方式
- 代码审查时检查提交消息是否正确

## 🔧 修复历史乱码提交

如果已经有乱码提交，需要在Git Bash中修复：

```bash
# 1. 打开Git Bash
cd /e/dcc2025

# 2. 设置编码
export LANG=zh_CN.UTF-8
export LC_ALL=zh_CN.UTF-8

# 3. 修复最近的提交
git rebase -i HEAD~1
# 在编辑器中，将第一行的 `pick` 改为 `reword`
# 保存退出后，输入正确的提交消息

# 4. 推送到远程（需要强制推送）
git push --force-with-lease origin master
```

## 📊 对比表

| 方法 | 易用性 | 可靠性 | 推荐度 |
|------|--------|--------|--------|
| 自动化脚本 | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ |
| 临时文件 | ⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐ |
| Git Bash | ⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ |

## 🎯 最佳实践

1. **日常提交**：使用 `git-commit-utf8.ps1` 脚本
2. **修改提交**：使用 `git-commit-amend-utf8.ps1` 脚本
3. **修复历史**：在Git Bash中操作
4. **团队协作**：统一使用UTF-8编码，建立规范

## ⚠️ 注意事项

1. **强制推送风险**：修复历史提交需要强制推送，会重写远程历史
2. **团队协作**：确保没有其他人在使用这些提交
3. **备份**：修复前建议创建备份分支
4. **测试**：修复后验证提交消息是否正确显示

## 📝 总结

**问题根源**：PowerShell（GBK）与Git（UTF-8）编码不匹配

**最佳解决方案**：使用自动化脚本 `git-commit-utf8.ps1`

**预防措施**：配置Git编码 + 使用脚本 + 建立团队规范

---

**最后更新**：2026-01-19
