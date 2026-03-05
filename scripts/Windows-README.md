# Windows PowerShell 安装指南

本指南专门针对 Windows 用户，说明如何使用 PowerShell 脚本安装 Awesun Remote Control Skill。

## 系统要求

- Windows 10 或更高版本
- PowerShell 5.0 或更高版本（Windows 10 自带）
- 管理员权限（推荐）或用户权限

## 快速开始

### 1. 准备 PowerShell 环境

首次运行 PowerShell 脚本时，可能遇到执行策略限制。运行以下命令解除限制：

```powershell
# 以管理员身份运行 PowerShell，然后执行：
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope LocalMachine

# 或者仅为当前用户设置：
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

### 2. 下载项目

```powershell
# 使用 Git（如果已安装）
git clone https://github.com/OrayDev/awesun-skill.git
cd awesun-skill

# 或者手动下载 ZIP 并解压
```

### 3. 运行安装脚本

```powershell
# 为 Claude Code 安装
.\scripts\install-claude-code.ps1

# 为 Open Code 安装
.\scripts\install-opencode.ps1

# 强制覆盖安装（如果已存在）
.\scripts\install-claude-code.ps1 -Force

# 查看帮助信息
.\scripts\install-claude-code.ps1 -Help
```

## 脚本功能特性

### 自动检测
- ✅ PowerShell 版本兼容性
- ✅ 编辑器安装位置（多个路径）
- ✅ 向日葵客户端安装状态
- ✅ 配置目录位置

### 智能安装
- 📁 自动创建必要目录结构
- 📋 复制 skill 文件和配置
- 📝 生成编辑器特定配置文件
- ✅ 验证安装完整性

### 用户友好
- 🎨 彩色输出日志
- ⚠️ 详细错误提示
- 📖 完整的后续配置指导
- 🔄 支持覆盖安装

## 配置目录位置

脚本会自动检测以下配置目录：

### Claude Code
- `%APPDATA%\Claude Code\skills`
- `%LOCALAPPDATA%\Claude Code\skills`  
- `%USERPROFILE%\.claude-code\skills`

### Open Code
- `%APPDATA%\Open Code\skills`
- `%LOCALAPPDATA%\Open Code\skills`
- `%USERPROFILE%\.opencode\skills`

## 编辑器检测

脚本会在以下位置查找编辑器：

### Claude Code
- `%LOCALAPPDATA%\Programs\Claude Code\Claude Code.exe`
- `%PROGRAMFILES%\Claude Code\Claude Code.exe`
- `%PROGRAMFILES(X86)%\Claude Code\Claude Code.exe`
- PATH 环境变量中的 `claude-code` 命令

### Open Code
- `%LOCALAPPDATA%\Programs\Open Code\Open Code.exe`
- `%PROGRAMFILES%\Open Code\Open Code.exe`
- `%PROGRAMFILES(X86)%\Open Code\Open Code.exe`
- `%LOCALAPPDATA%\opencode\opencode.exe`
- PATH 环境变量中的 `opencode` 命令

## 向日葵客户端检测

脚本会检查以下路径：
- `%PROGRAMFILES%\Sunlogin\SunloginClient.exe`
- `%PROGRAMFILES(X86)%\Sunlogin\SunloginClient.exe`
- `%LOCALAPPDATA%\Sunlogin\SunloginClient.exe`

## 故障排除

### 执行策略错误
```
无法加载文件 install-claude-code.ps1，因为在此系统上禁止运行脚本。
```

**解决方案：**
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

### 权限不足
```
拒绝访问路径 'C:\Program Files\...'
```

**解决方案：**
1. 以管理员身份运行 PowerShell
2. 或者编辑器安装在用户目录下

### 编辑器未检测到
```
❌ 错误：未找到 Claude Code
```

**解决方案：**
1. 确认编辑器已正确安装
2. 检查安装路径是否在脚本检测范围内
3. 将编辑器可执行文件添加到 PATH

### 中文路径问题

如果项目路径包含中文字符，可能导致脚本运行异常。

**解决方案：**
1. 移动项目到纯英文路径
2. 或在 PowerShell 中设置：
```powershell
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
```

## 手动安装（备用方案）

如果 PowerShell 脚本无法运行，可以手动安装：

1. **找到编辑器配置目录**
   - 按 `Win + R`，输入 `%APPDATA%`
   - 找到对应編辑器的文件夹
   - 创建 `skills` 子目录（如果不存在）

2. **复制 skill 文件**
   - 复制项目中的 `awesun-remote-control` 文件夹
   - 粘贴到 `skills` 目录下

3. **重启编辑器**
   - 完全关闭编辑器
   - 重新打开以加载 skill

## 卸载

删除对应的 skill 目录：
```powershell
# Claude Code
Remove-Item "$env:APPDATA\Claude Code\skills\awesun-remote-control" -Recurse -Force

# Open Code  
Remove-Item "$env:APPDATA\Open Code\skills\awesun-remote-control" -Recurse -Force
```

## 支持

如果遇到问题，请：
1. 查看脚本输出的错误信息
2. 检查是否满足系统要求
3. 尝试手动安装方案
4. 在 GitHub 提交 Issue：https://github.com/OrayDev/awesun-skill/issues