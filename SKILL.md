---
name: awesun-skill
description: 向日葵（AweSun）提供 30+ 个工具。使用场景包括：设备列表管理/远程开关机/远程会话管理/远程桌面控制/远程命令执行/远程摄像头/远程文件传输/端口转发等
---

## 概述

一个跨平台的 Python 工具，让你可以使用 MCP 配置文件来调用 AweSun 的 CLI 功能。

支持的功能：
- **list** - 列出所有可用的 MCP 工具
- **describe** - 查看指定工具的详细参数规范
- **call** - 执行指定工具并获取结果

## AweSun MCP 工具能力

提供以下 30+ 个 MCP 工具，用于远程设备管理、桌面控制、文件传输等场景：

### 1. 设备管理工具

| 工具名 | 描述 |
|--------|------|
| **device_search** | 根据关键词模糊搜索设备列表，返回匹配的设备基本信息（remote_id、设备名等）。搜索关键词支持设备名称模糊匹配。 |
| **device_info** | 查询指定设备的详细信息，包括设备状态、系统信息、网络信息等元数据。 |
| **device_add** | 添加新设备到设备列表，需要远控识别码和密码。 |
| **device_remove** | 从设备列表中移除指定设备。 |
| **device_update** | 更新设备的元数据信息（如设备名称、描述等）。 |
| **device_shutdown** | 远程关闭指定设备（发送关机指令）。 |
| **device_wakeup** | 远程唤醒指定设备（需要设备支持网络唤醒）。 |

**典型使用流程：**
```bash
# 1. 搜索设备获取 remote_id
python scripts/awesun.py call device_search '{"keyword": "办公室", "limit": 10}'

# 2. 查看设备详情
python scripts/awesun.py call device_info '{"remote_id": 12345}'

# 3. 远程关机
python scripts/awesun.py call device_shutdown '{"remote_id": 12345}'
```

### 2. 远程会话管理工具

| 工具名 | 描述 |
|--------|------|
| **control_connect** | 发起与指定设备的远控会话连接。支持多种连接类型：远程桌面(desktop)、远程文件(file)、远程CMD(cmd2)、远程SSH(ssh)、桌面观看(desktop_view)、远程摄像头(newcamera)、端口转发(forward)。返回 session_id 用于后续操作。 |
| **control_disconnect** | 断开指定的远程会话。 |
| **control_connect_state** | 查询远程会话的连接状态。 |
| **control_sessions** | 查询当前所有活跃的远程会话列表，返回 session_id 和会话类型等信息。 |

**连接类型说明：**
- `desktop` - 远程桌面控制（可执行桌面操作）
- `desktop_view` - 桌面观看模式（仅观看，不可操作）
- `file` - 远程文件管理
- `cmd2` - Windows 远程命令行
- `ssh` - Linux/Mac 远程 SSH
- `newcamera` - 远程摄像头
- `forward` - 端口转发

**典型使用流程：**
```bash
# 1. 搜索设备
python scripts/awesun.py call device_search '{"limit": 1}'

# 2. 建立远程桌面连接
python scripts/awesun.py call control_connect '{"type": "desktop", "remote_id": 12345}'
# 返回: {"session_id": "abc123xyz"}

# 3. 查看活跃会话
python scripts/awesun.py call control_sessions '{}'

# 4. 断开连接
python scripts/awesun.py call control_disconnect '{"session_id": "abc123xyz"}'
```

### 3. 桌面控制工具

用于在远程桌面会话中执行自动化操作，坐标必须使用归一化值(0.0-1.0)。

| 工具名 | 描述 |
|--------|------|
| **control_screenshot** | 对远程桌面会话进行截图，返回 Base64 编码的图片数据。用于获取当前屏幕状态，辅助判断操作结果。仅支持 desktop/desktop_view/newcamera 类型的会话。 |
| **desktop_click_mouse** | 模拟鼠标点击操作，支持左键、右键、中键点击及双击。坐标需使用归一化值(x_pixel/屏幕宽度)。 |
| **desktop_move_mouse** | 移动鼠标到指定坐标，不进行点击。 |
| **desktop_drag_mouse** | 模拟鼠标拖拽操作，从起点坐标拖拽到终点坐标。 |
| **desktop_scroll_mouse** | 模拟鼠标滚轮滚动。支持指定滚动方向和距离。 |
| **desktop_typing_text** | 在远程桌面中输入文本内容。 |
| **desktop_typing_keys** | 模拟键盘按键输入，支持组合键（如 Ctrl+C）。 |
| **desktop_press_keys** | 按下并释放指定的按键序列。 |
| **desktop_paste_text** | 将文本粘贴到远程桌面（模拟 Ctrl+V）。 |
| **desktop_waiting** | 在远程桌面操作中插入等待时间，用于界面加载或状态变更后的短暂等待。不建议超过300ms。 |

**坐标归一化说明：**
- 所有鼠标操作坐标必须是 0.0-1.0 的归一化值
- 计算公式：`x_norm = x_pixel / screen_width`, `y_norm = y_pixel / screen_height`
- 例如：屏幕分辨率 1920x1080，坐标 (960, 540) 归一化后为 (0.5, 0.5)

**典型使用流程（自动化操作）：**
```bash
# 1. 建立远程桌面连接获取 session_id
python scripts/awesun.py call control_connect '{"type": "desktop", "remote_id": 12345}'

# 2. 截图查看当前状态
python scripts/awesun.py call control_screenshot '{"session_id": "abc123xyz"}'
# 返回 {"image_path":"xxx.jpg","image_width":1920,"image_height":1080}

# 4. 调用Read工具读取截图内容，识别目标坐标
# 参考文档 references/ui-locator.md 进行用户意图坐标定位

# 3. 点击某个按钮（坐标已归一化）
python scripts/awesun.py call desktop_click_mouse '{
  "session_id": "abc123xyz",
  "coordinates": [0.5, 0.3],
  "button": "left",
  "clicks": 1
}'

# 4. 输入文本
python scripts/awesun.py call desktop_typing_text '{
  "session_id": "abc123xyz",
  "text": "Hello World"
}'

# 5. 按回车键
python scripts/awesun.py call desktop_press_keys '{
  "session_id": "abc123xyz",
  "keys": ["Return"]
}'

# 6. 短暂等待界面响应
python scripts/awesun.py call desktop_waiting '{
  "session_id": "abc123xyz",
  "duration": 200
}'
```

**最佳实践：**
- 首次操作或界面变更后必须截图
- 连续操作且界面未变时，禁止重复截图，基于上一次截图的坐标直接执行
- 单次截图应尽可能识别出当前任务所需的所有目标坐标
- 仅在界面状态变更（如打开窗口、提交表单）后插入短暂 waiting

### 4. 远程文件管理工具

| 工具名 | 描述 |
|--------|------|
| **control_file_list** | 浏览远程设备上的文件目录，支持指定路径和关键词过滤。仅在 type=file 的会话中可用。 |
| **control_file_mkdir** | 在远程设备上创建新文件夹。 |
| **control_file_remove** | 删除远程设备上的文件或文件夹。 |
| **control_file_rename** | 重命名远程设备上的文件或文件夹。 |
| **control_file_transfer** | 创建文件传输任务，支持上传(up)和下载(down)操作。 |
| **control_file_transfer_state** | 查询文件传输任务的状态和进度。传输是异步的，需要定期查询直到完成或失败。 |
| **control_file_transfer_cancel** | 取消正在进行的文件传输任务。 |

**典型使用流程（文件传输）：**
```bash
# 1. 建立文件会话
python scripts/awesun.py call control_connect '{"type": "file", "remote_id": 12345}'
# 返回: {"session_id": "file_session_001"}

# 2. 浏览远程目录
python scripts/awesun.py call control_file_list '{
  "session_id": "file_session_001",
  "path": "/home/user/documents"
}'

# 3. 创建传输任务（下载文件）
python scripts/awesun.py call control_file_transfer '{
  "session_id": "file_session_001",
  "transfer_type": "down",
  "remote_path": "/home/user/documents/report.pdf",
  "local_path": "/Users/local/Downloads/report.pdf"
}'
# 返回: {"transfer_id": "transfer_001"}

# 4. 监控传输进度（循环查询直到完成）
python scripts/awesun.py call control_file_transfer_state '{
  "session_id": "file_session_001",
  "transfer_id": "transfer_001"
}'

# 5. 如需取消传输
python scripts/awesun.py call control_file_transfer_cancel '{
  "session_id": "file_session_001",
  "transfer_id": "transfer_001"
}'
```

**注意事项：**
- 文件操作仅在 type=file 的会话中可用
- 删除文件/文件夹前，建议先用 control_file_list 确认路径正确
- 传输任务是异步执行的，创建后必须定期查询状态直到完成或失败
- transfer_type 必须明确指定 down（下载）或 up（上传）

### 5. 远程命令执行工具

| 工具名 | 描述 |
|--------|------|
| **control_command** | 在远程设备上执行命令。支持在 cmd2(Windows) 或 ssh(Linux/Mac) 会话中执行命令。 |

**典型使用流程：**
```bash
python scripts/awesun.py call control_connect '{"type": "cmd2", "remote_id": 12345}'
python scripts/awesun.py call control_command '{
  "session_id": "cmd_session_001",
  "command": "dir C:/Users"
}'
```

### 6. 端口转发工具

| 工具名 | 描述 |
|--------|------|
| **control_portforward** | 建立端口转发隧道，将远程设备的端口映射到本地。用于访问远程设备上的网络服务。 |

**典型使用流程：**
```bash
# 1. 建立端口转发会话
python scripts/awesun.py call control_connect '{"type": "forward", "remote_id": 12345}'
# 返回: {"session_id": "forward_session_001"}

# 2. 配置端口转发（将远程 8080 映射到本地 18080）
python scripts/awesun.py call control_portforward '{
  "session_id": "forward_session_001",
  "remote_port": 8080,
  "local_port": 18080
}'

# 现在可以通过 localhost:18080 访问远程设备的 8080 端口
```

---

## 完整场景示例

### 场景1：远程桌面自动化操作

```bash
# 1. 搜索设备
python scripts/awesun.py call device_search '{"keyword": "办公室电脑", "limit": 1}'
# 假设返回 remote_id: 12345

# 2. 建立远程桌面连接
python scripts/awesun.py call control_connect '{"type": "desktop", "remote_id": 12345}'
# 返回 session_id: desktop_session_001

# 3. 截图查看当前状态
python scripts/awesun.py call control_screenshot '{"session_id": "desktop_session_001"}'
# 返回 {"image_path":"xxx.jpg","image_width":1920,"image_height":1080}

# 4. 调用Read工具读取截图内容，识别目标坐标
# 参考文档 references/ui-locator.md 进行用户意图坐标定位

# 5. 执行一系列自动化操作（基于截图坐标）
# 点击开始菜单
python scripts/awesun.py call desktop_click_mouse '{
  "session_id": "desktop_session_001",
  "coordinates": [0.01, 0.99],
  "button": "left",
  "clicks": 1
}'

# 等待菜单打开
python scripts/awesun.py call desktop_waiting '{"session_id": "desktop_session_001", "duration": 300}'

# 输入"记事本"搜索
python scripts/awesun.py call desktop_typing_text '{
  "session_id": "desktop_session_001",
  "text": "notepad"
}'

# 按回车打开
python scripts/awesun.py call desktop_press_keys '{
  "session_id": "desktop_session_001",
  "keys": ["enter"]
}'

# 5. 完成后断开连接
python scripts/awesun.py call control_disconnect '{"session_id": "desktop_session_001"}'
```

### 场景2：批量文件下载

```bash
# 1. 搜索设备
python scripts/awesun.py call device_search '{"limit": 1}'

# 2. 建立文件会话
python scripts/awesun.py call control_connect '{"type": "file", "remote_id": 12345}'
# 返回 session_id: file_session_001

# 3. 浏览远程日志目录
python scripts/awesun.py call control_file_list '{
  "session_id": "file_session_001",
  "path": "/var/logs"
}'

# 4. 下载日志文件
python scripts/awesun.py call control_file_transfer '{
  "session_id": "file_session_001",
  "transfer_type": "down",
  "remote_path": "/var/logs/app.log",
  "local_path": "/Users/local/Downloads/app.log"
}'
# 返回 transfer_id: transfer_001

# 5. 监控传输状态直到完成
python scripts/awesun.py call control_file_transfer_state '{
  "session_id": "file_session_001",
  "transfer_id": "transfer_001"
}'
```

---

## 工具调用最佳实践

### 1. ID 依赖与上下文管理

- **信任上下文**：对话历史中已存在的 remote_id 或 session_id 视为绝对有效，除非工具返回明确错误
- **链路完整性**：确保工具调用输出的 ID 准确传递，避免断链
- **异常重试**：仅当工具返回 ID 无效错误时，才重新触发查询流程

### 2. 会话建立准则

- **会话复用优先**：执行远程操作前，先检查上下文是否有有效 session_id
- **桌面类型限制**：仅在 type=desktop 的会话中执行 desktop_* 工具
- **文件类型限制**：仅在 type=file 的会话中执行 control_file_* 工具

### 3. 截图优化策略

- 首次操作或界面变更后：必须调用 control_screenshot
- 连续操作且界面未变时：禁止重复截图，基于上一次截图的坐标直接执行
- 目标识别：单次截图应尽可能识别出当前任务所需的所有目标坐标

### 4. 传输任务监控

- 创建 control_file_transfer 后，必须调用 control_file_transfer_state 监控状态
- 循环查询直到任务完成或失败，不得假设传输立即成功
- 如需中止，调用 control_file_transfer_cancel

## 安装要求

- Python 3.7+
- 已安装 awesun-mcp-server 并配置在 MCP 客户端中

## 使用方法

```bash
# 列出所有工具
python scripts/awesun.py list

# 查看工具详情
python scripts/awesun.py describe device_search

# 执行工具
python scripts/awesun.py call device_search '{"limit": 1}'
```

## 配置文件格式

脚本支持标准的 MCP 配置文件格式（mcp.json）：

```json
{
  "mcpServers": {
    "awesun-mcp-server": {
      "command": "/Applications/AweSun.app/Contents/Helpers/awesun-mcp-server",
      "env": {
        "AWESUN_API_URL": "http://127.0.0.1:8908",
        "AWESUN_API_TOKEN": "your_token_here"
      }
    }
  }
}
```

## 命令详解

### list - 列出所有工具

```bash
python scripts/awesun.py list
```

**输出示例：**
```json
[
  {
    "name": "device_search",
    "description": "搜索设备",
    "input_schema": {
      "type": "object",
      "properties": {
        "keyword": { "type": "string", "description": "搜索关键词" },
        "limit": { "type": "integer", "description": "返回结果数量限制" }
      }
    }
  }
]
```

### describe - 查看工具详情

```bash
python scripts/awesun.py describe <tool_name>

# 示例
python scripts/awesun.py describe device_search
```

**输出示例：**
```json
{
  "name": "device_search",
  "description": "搜索设备",
  "input_schema": {
    "type": "object",
    "properties": {
      "keyword": { "type": "string", "description": "搜索关键词" },
      "limit": { "type": "integer", "description": "返回结果数量限制" }
    }
  }
}
```

### call - 执行工具

```bash
python scripts/awesun.py call <tool_name> '<json_arguments>'

# 示例
python scripts/awesun.py call device_search '{"limit": 1}'
python scripts/awesun.py call device_search '{"keyword": "test", "limit": 5}'
```

**注意：** JSON 参数必须用单引号包裹，防止 shell 解析特殊字符。

## 完整工作流程示例

### 场景：搜索设备

```bash
# 1. 列出所有可用工具
python scripts/awesun.py list

# 2. 查看 device_search 工具的参数
python scripts/awesun.py describe device_search

# 3. 执行搜索
python scripts/awesun.py call device_search '{"limit": 5}'
```

### 常见错误

#### JSON 参数格式无效
**原因：** 提供的 JSON 参数格式不正确。
**解决：** 确保 JSON 参数格式正确，使用单引号包裹：

#### command not found: python
**原因：** 未安装python环境。
**解决：** 如果是macOS系统，尝试使用python3命令，若未安装则先安装python环境。


```bash
# 正确
python scripts/awesun.py call device_search '{"limit": 1}'

# 错误（缺少引号）
python scripts/awesun.py call device_search {"limit": 1}
```
