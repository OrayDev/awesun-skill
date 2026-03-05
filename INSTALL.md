# Awesun Remote Control Skill 安装脚本

本目录包含为三个不同的 Claude 编辑器安装 `awesun-remote-control` skill 的安装脚本。

## 支持的编辑器

- **Claude Code** - Anthropic 官方编辑器
- **Open Code** - 开源版本的 Claude 编辑器  
- **🦞OpenClaw** - 支持 skills 的 AI 编辑器（仅 Unix 系统）

## 快速导航

- **Windows 用户**: 请查看 [Windows-README.md](Windows-README.md) 获取详细的 PowerShell 安装指南
- **Linux/macOS 用户**: 继续阅读本文档

## 安装脚本

| 编辑器 | Linux/macOS | Windows | 说明 |
|--------|-------------|---------|------|
| Claude Code | `install-claude-code.sh` | `install-claude-code.ps1` | 为 Claude Code 安装 skill |
| Open Code | `install-opencode.sh` | `install-opencode.ps1` | 为 Open Code 安装 skill |
| 🦞OpenClaw | `install-openclaw.sh` | - | 为 OpenClaw 安装 skill（仅支持 Unix 系统） |

## 使用方法

### 1. 准备工作

在运行任何安装脚本之前，请确保：

1. **安装向日葵客户端**
   - 下载地址：https://sunlogin.oray.com
   - 要求版本：16.3.2 以上
   - 安装并登录账户

2. **启用 MCP 服务**
   - 打开向日葵客户端
   - 进入设置 -> 高级设置 -> MCP 服务
   - 启用服务并切换到 "Streamable HTTP" 方式

### 2. 运行安装脚本

#### Linux/macOS 用户

```bash
# 进入项目根目录
cd /path/to/awesun-skill

# 根据你使用的编辑器选择对应的脚本

# 为 Claude Code 安装
./scripts/install-claude-code.sh

# 为 Open Code 安装
./scripts/install-opencode.sh

# 为 🦞OpenClaw 安装
./scripts/install-openclaw.sh
```

#### Windows 用户

```powershell
# 以管理员身份运行 PowerShell
# 进入项目根目录
cd C:\path\to\awesun-skill

# 如果是首次运行 PowerShell 脚本，可能需要设置执行策略
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser

# 根据你使用的编辑器选择对应的脚本

# 为 Claude Code 安装
.\scripts\install-claude-code.ps1

# 为 Open Code 安装  
.\scripts\install-opencode.ps1

# 强制覆盖安装（可选）
.\scripts\install-claude-code.ps1 -Force
.\scripts\install-opencode.ps1 -Force

# 查看帮助
.\scripts\install-claude-code.ps1 -Help
.\scripts\install-opencode.ps1 -Help
```

### 3. 安装后配置

安装完成后，按照每个脚本输出的提示完成配置：

1. 确认向日葵客户端已启动并启用 MCP 服务
2. 重启对应的编辑器以加载新的 skill
3. 在编辑器中验证 skill 是否正常工作

## 功能特性

安装完成后，你将获得以下功能：

- **设备管理** (5个工具)：搜索、查看、添加、删除、更新设备
- **远程连接** (3个工具)：建立连接、断开连接、查看会话
- **桌面控制** (8个工具)：鼠标操作、键盘输入、文本粘贴等
- **系统操作** (5个工具)：命令执行、截图、关机、开机等
- **网络工具** (1个工具)：端口转发

共计 22 个远程控制工具。

## 故障排除

### 常见问题

#### 通用问题

1. **"未找到编辑器命令"错误**
   - 确保对应的编辑器已正确安装
   - 确保编辑器的可执行文件已添加到系统 PATH

2. **"未找到向日葵客户端"警告**
   - 从官网下载并安装向日葵客户端
   - 确保版本为 16.3.2 以上

3. **MCP 服务连接失败**
   - 确认向日葵客户端中 MCP 服务已启用
   - 确认服务方式设置为 "Streamable HTTP"
   - 重启向日葵客户端

#### Windows 特定问题

4. **PowerShell 执行策略错误**
   ```powershell
   # 设置执行策略允许运行脚本
   Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
   ```

5. **权限不足**
   - 以管理员身份运行 PowerShell
   - 或者选择用户目录下的安装位置

6. **路径包含中文字符**
   - 确保 PowerShell 支持 UTF-8
   - 或者将项目移动到纯英文路径下

### 手动安装

如果自动安装脚本出现问题，你也可以手动安装：

1. 找到你的编辑器配置目录
2. 创建 `skills` 目录（如果不存在）
3. 复制 `awesun-remote-control` 目录到 `skills` 目录下
4. 确保 `bin/mcp2skill` 文件具有可执行权限

## 更新

要更新 skill 到最新版本：

1. 重新运行对应的安装脚本
2. 选择覆盖安装
3. 重启编辑器

## 卸载

要卸载 skill：

1. 删除编辑器配置目录下的 `skills/awesun-remote-control` 目录
2. 重启编辑器

## 许可证

MIT License - 详见项目根目录的 LICENSE 文件。

## 支持

如有问题，请访问：
- GitHub Issue: https://github.com/OrayDev/awesun-skill/issues
- 向日葵 MCP 服务: https://github.com/OrayDev/awesun-mcp