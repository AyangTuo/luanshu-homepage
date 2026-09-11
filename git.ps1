# 简易 git 包装脚本（本机没装全局 git，用的是仓库内的便携版）
# 用法：
#   .\git.ps1 status
#   .\git.ps1 add -A
#   .\git.ps1 commit -m "更新说明"
#   .\git.ps1 push
#   .\git.ps1 log --oneline -n 5
$gitExe = Join-Path $PSScriptRoot '.tools\mingit\cmd\git.exe'
if (-not (Test-Path $gitExe)) {
  Write-Error "找不到便携版 git：$gitExe"
  exit 1
}
& $gitExe -C $PSScriptRoot @args
exit $LASTEXITCODE
