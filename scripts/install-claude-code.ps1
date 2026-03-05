# 为 Claude Code 安装 awesun-remote-control skill (Windows PowerShell版本)
# 作者：AI Assistant
# 日期：2026年3月5日

param(
    [switch]$Force,
    [switch]$Help
)

# 显示帮助信息
if ($Help) {
    Write-Host @"
Claude Code - Awesun Remote Control Skill 安装程序 (Windows)

用法:
    .\install-claude-code.ps1 [-Force] [-Help]

参数:
    -Force    强制覆盖安装（如果已存在）
    -Help     显示此帮助信息

示例:
    .\install-claude-code.ps1
    .\install-claude-code.ps1 -Force

"@
    exit 0
}

# 颜色输出函数
function Write-ColorOutput {
    param(
        [string]$Message,
        [string]$Color = "White"
    )
    
    switch ($Color) {
        "Red"    { Write-Host $Message -ForegroundColor Red }
        "Green"  { Write-Host $Message -ForegroundColor Green }
        "Yellow" { Write-Host $Message -ForegroundColor Yellow }
        "Blue"   { Write-Host $Message -ForegroundColor Blue }
        "Purple" { Write-Host $Message -ForegroundColor Magenta }
        default  { Write-Host $Message }
    }
}

# 错误处理
$ErrorActionPreference = "Stop"

try {
    Write-ColorOutput "=== Claude Code - Awesun Remote Control Skill 安装程序 (Windows) ===" "Blue"
    Write-Host ""

    # 检查 PowerShell 版本
    Write-ColorOutput "🔍 检查 PowerShell 版本..." "Blue"
    if ($PSVersionTable.PSVersion.Major -lt 5) {
        Write-ColorOutput "❌ 错误：需要 PowerShell 5.0 或更高版本" "Red"
        Write-ColorOutput "当前版本：$($PSVersionTable.PSVersion)" "Yellow"
        exit 1
    }
    Write-ColorOutput "✅ PowerShell 版本检查通过：$($PSVersionTable.PSVersion)" "Green"

    # 检查 Claude Code 是否安装
    Write-ColorOutput "🔍 检查 Claude Code..." "Blue"
    $claudeCodePath = $null
    
    # 尝试多个可能的安装位置
    $possiblePaths = @(
        "$env:LOCALAPPDATA\Programs\Claude Code\Claude Code.exe",
        "$env:PROGRAMFILES\Claude Code\Claude Code.exe",
        "${env:PROGRAMFILES(X86)}\Claude Code\Claude Code.exe"
    )
    
    foreach ($path in $possiblePaths) {
        if (Test-Path $path) {
            $claudeCodePath = $path
            break
        }
    }
    
    # 也检查PATH中是否有claude-code命令
    $claudeCodeCmd = Get-Command "claude-code" -ErrorAction SilentlyContinue
    
    if (-not $claudeCodePath -and -not $claudeCodeCmd) {
        Write-ColorOutput "❌ 错误：未找到 Claude Code" "Red"
        Write-ColorOutput "请从官网下载并安装 Claude Code" "Yellow"
        exit 1
    }
    
    Write-ColorOutput "✅ 找到 Claude Code" "Green"

    # 检查向日葵客户端
    Write-ColorOutput "🔍 检查向日葵客户端..." "Blue"
    $sunloginPaths = @(
        "$env:PROGRAMFILES\Sunlogin\SunloginClient.exe",
        "${env:PROGRAMFILES(X86)}\Sunlogin\SunloginClient.exe",
        "$env:LOCALAPPDATA\Sunlogin\SunloginClient.exe"
    )
    
    $sunloginFound = $false
    foreach ($path in $sunloginPaths) {
        if (Test-Path $path) {
            $sunloginFound = $true
            Write-ColorOutput "✅ 找到向日葵客户端：$path" "Green"
            break
        }
    }
    
    if (-not $sunloginFound) {
        Write-ColorOutput "⚠️  警告：未找到向日葵客户端" "Yellow"
        Write-ColorOutput "请从 https://sunlogin.oray.com 下载并安装向日葵客户端 16.3.2 以上版本" "Yellow"
    }

    # 获取 Claude Code 配置目录
    Write-ColorOutput "🔍 获取 Claude Code 配置目录..." "Blue"
    $claudeConfigDir = "$env:APPDATA\Claude Code"
    
    # 如果标准目录不存在，尝试其他可能位置
    if (-not (Test-Path $claudeConfigDir)) {
        $altPaths = @(
            "$env:LOCALAPPDATA\Claude Code",
            "$env:USERPROFILE\.claude-code"
        )
        
        foreach ($altPath in $altPaths) {
            if (Test-Path $altPath) {
                $claudeConfigDir = $altPath
                break
            }
        }
    }
    
    $skillsDir = Join-Path $claudeConfigDir "skills"
    $targetDir = Join-Path $skillsDir "awesun-remote-control"
    
    Write-ColorOutput "📁 Skills 目录：$skillsDir" "Blue"

    # 创建 skills 目录
    Write-ColorOutput "📁 创建 skills 目录..." "Blue"
    if (-not (Test-Path $skillsDir)) {
        New-Item -ItemType Directory -Path $skillsDir -Force | Out-Null
    }

    # 获取脚本所在目录（skill 项目根目录）
    $scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
    $projectDir = Split-Path -Parent $scriptDir
    $sourceDir = Join-Path $projectDir "awesun-remote-control"

    Write-ColorOutput "📂 源目录：$sourceDir" "Blue"
    Write-ColorOutput "📂 目标目录：$targetDir" "Blue"

    # 检查源目录是否存在
    if (-not (Test-Path $sourceDir)) {
        Write-ColorOutput "❌ 错误：找不到 awesun-remote-control 源目录" "Red"
        Write-ColorOutput "请确保在正确的项目目录下运行此脚本" "Yellow"
        exit 1
    }

    # 检查是否已安装
    if (Test-Path $targetDir) {
        Write-ColorOutput "⚠️  检测到已安装的 awesun-remote-control skill" "Yellow"
        
        if (-not $Force) {
            $response = Read-Host "是否覆盖安装？[y/N]"
            if ($response -notmatch "^[Yy]") {
                Write-ColorOutput "安装已取消" "Yellow"
                exit 0
            }
        }
        
        Write-ColorOutput "🗑️  删除旧版本..." "Yellow"
        Remove-Item -Path $targetDir -Recurse -Force
    }

    # 复制 skill 文件
    Write-ColorOutput "📋 复制 skill 文件..." "Blue"
    Copy-Item -Path $sourceDir -Destination $targetDir -Recurse -Force

    # Windows 不需要特殊的可执行权限设置，但确保文件存在
    $mcpToolPath = Join-Path $targetDir "bin\mcp2skill"
    if (-not (Test-Path $mcpToolPath)) {
        Write-ColorOutput "❌ 警告：未找到 mcp2skill 工具" "Yellow"
    }

    # 验证安装
    Write-ColorOutput "✅ 验证安装..." "Blue"
    $skillMd = Join-Path $targetDir "SKILL.md"
    
    if ((Test-Path $skillMd) -and (Test-Path $mcpToolPath)) {
        Write-ColorOutput "✅ Awesun Remote Control Skill 安装成功！" "Green"
    } else {
        Write-ColorOutput "❌ 安装验证失败" "Red"
        exit 1
    }

    # 输出后续配置提示
    Write-Host ""
    Write-ColorOutput "=== 后续配置步骤 ===" "Blue"
    Write-ColorOutput "1. 启动向日葵客户端并登录" "Yellow"
    Write-ColorOutput "2. 在向日葵客户端中启用 MCP 服务：" "Yellow"
    Write-ColorOutput "   - 打开设置 -> 高级设置 -> MCP 服务" "White"
    Write-ColorOutput "   - 启用服务并切换到 'Streamable HTTP' 方式" "White"
    Write-ColorOutput "3. 重启 Claude Code 以加载新的 skill" "Yellow"
    Write-ColorOutput "4. 在 Claude Code 中即可使用向日葵远程控制功能" "Yellow"
    Write-Host ""
    Write-ColorOutput "安装完成！" "Green"

} catch {
    Write-ColorOutput "❌ 安装过程中出现错误：$($_.Exception.Message)" "Red"
    exit 1
}