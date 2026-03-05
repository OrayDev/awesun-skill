# 向日葵(Awesun) Skill

基于[向日葵MCP服务](https://github.com/OrayDev/awesun-mcp])，为Claude Code、Open Code、🦞OpenClaw等支持Skills的AI Agent提供渐进式披露的工具调用。

***⚠️配置Skill前请安装符合版本向日葵客户端，并启用向日葵MCP服务，详见：[https://github.com/OrayDev/awesun-mcp](https://github.com/OrayDev/awesun-mcp)***

## 使用帮助

1. 安装向日葵客户端(16.3.2以上)

2. 启用[向日葵MCP服务](https://github.com/OrayDev/awesun-mcp])，并切换到 Streamable HTTP方式

3. 安装本项目

```bash
# 克隆项目
git clone https://github.com/OrayDev/awesun-skill.git
cd awesun-skill

# 根据你使用的编辑器选择对应的安装脚本

# 为 Claude Code 安装
./scripts/install-claude-code.sh

# 为 Open Code 安装  
./scripts/install-opencode.sh

# 为 🦞OpenClaw 安装
./scripts/install-openclaw.sh
```

### Windows 用户

```powershell
# 以管理员身份运行 PowerShell，或在普通用户下运行
# （如果是首次运行 PowerShell 脚本，可能需要设置执行策略）
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser

# 克隆项目
git clone https://github.com/OrayDev/awesun-skill.git
cd awesun-skill

# 根据你使用的编辑器选择对应的 PowerShell 脚本

# 为 Claude Code 安装
.\scripts\install-claude-code.ps1

# 为 Open Code 安装
.\scripts\install-opencode.ps1

# 强制覆盖安装（可选）
.\scripts\install-claude-code.ps1 -Force

# 查看帮助
.\scripts\install-claude-code.ps1 -Help
```

**手动安装（如果脚本无法运行）：**
1. 找到你的编辑器配置目录：
   - Claude Code: `%APPDATA%\Claude Code\skills`
   - Open Code: `%APPDATA%\Open Code\skills`
2. 将 `awesun-remote-control` 文件夹复制到 `skills` 目录下
3. 重启编辑器

## 功能特性

本 skill 提供远程控制工具，分为以下类别：

### 🖥️ 设备管理
- `device_search`: 搜索设备
- `device_info`: 查看设备详情  
- `device_add`: 添加设备
- `device_remove`: 删除设备
- `device_update`: 更新设备信息

### 🔗 远程连接
- `control_connect`: 建立远程连接
- `control_disconnect`: 断开连接
- `control_sessions`: 查看活跃会话

### 🖱️ 桌面控制
- `desktop_click_mouse`: 鼠标点击
- `desktop_move_mouse`: 鼠标移动
- `desktop_drag_mouse`: 鼠标拖拽
- `desktop_scroll_mouse`: 鼠标滚动
- `desktop_typing_text`: 输入文本
- `desktop_typing_keys`: 组合键输入
- `desktop_press_keys`: 按键控制
- `desktop_paste_text`: 粘贴文本

### ⚡ 系统操作
- `control_command`: 执行远程命令
- `control_screenshot`: 远程截图
- `desktop_waiting`: 等待操作
- `device_shutdown`: 关机
- `device_wakeup`: 远程开机

### 🌐 网络工具
- `control_portforward`: 端口转发

## 使用示例

安装完成后，你可以在编辑器中这样使用：

```
帮我连接到办公室的电脑，然后截个图看看桌面状态

搜索一下名为"办公室电脑"的设备，然后建立远程桌面连接

在远程电脑上打开记事本并输入一些文字

关闭远程连接
```

## 安装脚本详情

详细的安装说明和故障排除，请查看：[scripts/README.md](scripts/README.md)

## 注意事项

- 使用前请确保向日葵客户端已启动并登录
- 建议配合 [screenshot-ui-locator](http://github.com/OrayDev/screenshot-ui-locator) Skill 使用以提供更好的桌面操作体验
- 远程操作时请注意网络延迟，适当使用 `desktop_waiting` 工具

## 相关项目

- [awesun-mcp](https://github.com/OrayDev/awesun-mcp) - 向日葵 MCP 服务
- [screenshot-ui-locator](http://github.com/OrayDev/screenshot-ui-locator) - 截图辅助 GUI 理解 Skill