# This is more of a memo for now


Set-ExecutionPolicy RemoteSigned -scope CurrentUser

# Custom directory for scoop
# [environment]::setEnvironmentVariable('SCOOP','D:\Applications\Scoop','User')
# $env:SCOOP='D:\Applications\Scoop'

Invoke-Expression (new-object net.webclient).downloadstring('https://get.scoop.sh')

# PSReadLine should already be installed on Windows 10
# Win+R
# powershell -noprofile -command "Install-Module PSReadLine -Force -SkipPublisherCheck"

# posh-git
PowerShellGet\Install-Module posh-git -AllowPrerelease -Force -Scope CurrentUser
