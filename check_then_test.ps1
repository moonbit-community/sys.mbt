param(
    [string]$Mode = 'local'
)


$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest
Set-PSDebug -Trace 1

if ($Mode -eq 'local') {
    moon fmt
    moon info --target native
    Remove-Item src/errno/linux/linux.mbti
    Remove-Item src/errno/win32/win32.mbti
    moon check --target native
}

moon test --target native

Set-PSDebug -Trace 0
$ErrorActionPreference = 'Continue'