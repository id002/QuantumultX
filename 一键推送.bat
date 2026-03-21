@echo off
chcp 65001 >nul
title Git 自动同步中...

echo ==========================================
echo   正在检查文件变动...
echo ==========================================
git status

REM 如果没有变动，提示并退出
if %errorlevel% neq 0 (
    echo [错误] 当前目录不是 Git 仓库或 Git 未安装！
    pause
    exit /b
)

git diff --quiet && git diff --cached --quiet
if %errorlevel% equ 0 (
    echo.
    echo [提示] 没有检测到任何文件变动，无需提交。
    echo.
    pause
    exit /b
)

echo.
echo ==========================================
echo   正在添加所有文件到暂存区...
echo ==========================================
git add -A

echo.
echo ==========================================
echo   正在提交更改...
echo ==========================================
REM 自动获取当前时间作为提交信息
for /f "tokens=2 delims==" %%a in ('wmic OS Get localdatetime /value') do set "dt=%%a"
set "YY=%dt:~2,2%" & set "YYYY=%dt:~0,4%" & set "MM=%dt:~4,2%" & set "DD=%dt:~6,2%"
set "HH=%dt:~8,2%" & set "Min=%dt:~10,2%"

git commit -m "auto: update configs %YYYY%-%MM%-%DD% %HH%:%Min%"

echo.
echo ==========================================
echo   正在推送到远程仓库 (GitHub)...
echo ==========================================
git push origin main

echo.
echo ==========================================
echo   [完成] 所有操作已结束！
echo ==========================================
pause