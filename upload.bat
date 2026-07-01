@echo off
setlocal
chcp 65001 >nul
REM جلوگیری از باز شدن ادیتور هنگام merge
set GIT_MERGE_AUTOEDIT=no
cd /d "%~dp0"

echo ========================================
echo    Upload changes to GitHub
echo ========================================

echo.
echo [1/5] Building project (go build)...
go build ./...
if errorlevel 1 (
  echo.
  echo *** BUILD FAILED - fix errors before uploading. ***
  pause
  exit /b 1
)
echo Build OK.

echo.
set /p MSG=Commit message (press Enter for "Update"): 
if "%MSG%"=="" set MSG=Update

echo.
echo [2/5] Staging changes...
git add -A

echo [3/5] Committing...
git commit -m "%MSG%"

echo [4/5] Pulling remote changes...
git pull origin main --no-rebase
if errorlevel 1 (
  echo.
  echo *** PULL/MERGE CONFLICT - resolve manually, then run: git push origin main ***
  pause
  exit /b 1
)

echo [5/5] Pushing to GitHub...
git push origin main
if errorlevel 1 (
  echo *** PUSH FAILED ***
  pause
  exit /b 1
)

echo.
echo ========================================
echo    Done! Changes uploaded to GitHub.
echo ========================================
pause