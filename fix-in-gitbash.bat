@echo off
REM 在Git Bash中修复乱码提交
echo 请在Git Bash中运行以下命令：
echo.
echo cd /e/dcc2025
echo git rebase -i HEAD~1
echo.
echo 在编辑器中，将第一行的 pick 改为 reword
echo 保存退出后，输入正确的提交消息：
echo feat: 完成竞品对标方案和红队评估（方案B）
echo.
pause
