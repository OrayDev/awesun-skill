---
description: "通过向日葵远程控制(Awesun)访问远端设备，提供22: {\"control_command\":\"在已建立的CMD远程会话中执行命令，目前支持Windows的CMD。返回命令的退出码、标准输出和错误输出。\",\"control_connect\":\"发起与指定设备的远控会话连接，支持远程文件(file)、远程桌面(desktop)、远程CMD(cmd2)、远程SSH(ssh)、桌面观看(desktop_view)、远程摄像头(newcamera)、端口转发(forward)。连接成功后返回会话ID，用于后续的桌面操作、截图、命令执行等。\",\"control_disconnect\":\"终止指定的活跃远控会话，立即断开与该会话的连接。断开后如需再次操作需要重新调用 control_connect 建立连接。建议在不使用会话时及时断开以释放资源。\",\"control_portforward\":\"在已建立的端口转发远程会话中配置端口转发规则（覆盖），需先建立有效的端口转发远程会话，用于实现本地与远程主机端口的双向数据转发。\",\"control_screenshot\":\"对指定的远程桌面会话(desktop/desktop_view)进行截图，返回Base64编码的图片数据及尺寸信息。截图可用于获取远程设备的当前画面状态，辅助判断操作结果。\",\"control_sessions\":\"查询所有当前活跃的远控会话，包括会话ID/会话类型和状态。获取的会话ID可用于截图、执行命令、桌面操作、断开连接等后续操作。\",\"desktop_click_mouse\":\"在远程桌面会话中模拟鼠标点击操作，支持左键、右键、中键点击及双击。坐标需使用归一化值(0.0-1.0)，通过 x_pixel/屏幕宽度 计算。适用于按钮点击、菜单选择等场景。\",\"desktop_drag_mouse\":\"在远程桌面中模拟鼠标拖拽操作，支持按住指定按键(left/right/middle)沿路径移动。可用于文件拖拽、窗口调整大小、选择文本区域等。路径坐标需归一化(0.0-1.0)。\",\"desktop_move_mouse\":\"将鼠标光标移动到远程桌面的指定坐标位置，坐标需归一化(0.0-1.0)。常用于拖拽操作前的定位、悬停触发菜单、或配合截图确定点击位置。仅移动不触发点击。\",\"desktop_paste_text\":\"在远程桌面中通过系统剪贴板粘贴长文本内容，比逐字符输入更高效。适用于输入大段文本、代码、命令等场景。使用前需确保输入框已获取焦点，且被控端支持剪贴板同步。\",\"desktop_press_keys\":\"在远程桌面中精确控制按键的按下或释放操作，适合需要精细控制按键状态的场景。支持单独按下(down)、单独释放(up)，或不指定时自动按下后释放。可用于长按、连击等复杂操作。\",\"desktop_scroll_mouse\":\"在远程桌面的指定位置模拟鼠标滚轮滚动，支持向上(up)或向下(down)滚动指定次数。用于滚动网页、文档、列表等内容查看。坐标需归一化(0.0-1.0)。\",\"desktop_typing_keys\":\"在远程桌面中执行组合快捷键操作，如复制(Ctrl+C)、粘贴(Ctrl+V)、保存(Ctrl+S)等。按顺序按下所有按键，延迟后再按相反顺序释放。适合需要同时按住多个键的场景。\",\"desktop_typing_text\":\"在远程桌面中逐字符模拟键盘输入文本，适合输入短文本内容。输入前需确保输入框已获取焦点。可设置字符间延迟(毫秒)控制输入速度。\",\"desktop_waiting\":\"在远控操作序列中插入暂停等待，用于在关键操作后等待系统响应或页面加载完成。指定持续时间(毫秒)后自动继续执行后续工具。建议在网络延迟或UI渲染场景中使用。\",\"device_add\":\"将新设备添加到设备列表中，可设置设备名称和描述便于管理。添加成功后可通过 device_search 查询该设备。\",\"device_info\":\"查询指定设备的完整详细信息，包括硬件配置（CPU、内存、硬盘、显卡）、网络信息（IP地址、MAC地址）、系统版本、在线状态、支持的插件等。必须先通过 device_search 获取设备ID。\",\"device_remove\":\"从设备列表中删除指定的设备，仅移除列表记录不会影响被控端软件，删除后无法恢复。删除前建议确认设备已不再需要使用。\",\"device_search\":\"根据关键词模糊搜索设备列表中的设备，支持按设备名称检索，返回匹配的设备基本信息列表。常用于查找特定设备以进行后续远控操作。\",\"device_shutdown\":\"向在线的远程设备发送关机指令，设备需处于在线状态且被控端支持关机功能。指令下发后设备将在1-2分钟内完成关机并离线。\",\"device_update\":\"修改指定设备的名称和描述信息，用于更新设备列表中的显示名称和备注，便于设备管理和识别。\",\"device_wakeup\":\"向绑定了开机硬件的设备发送开机指令，需要设备端配置开机棒或主板支持WOL功能。指令下发后设备将在1-2分钟内完成开机并上线。\"}"
name: awesun-remote-control
---

# awesun-remote-control

This skill provides access `Awesun remote control client` by the `awesun-mcp-server` MCP server.

## MCP Server Info

- **Server Version:** 0.0.1.b59df375c89f4aa547851ab762b51c485bf4c8e5
- **Protocol Version:** 2025-06-18
- **Capabilities:** tools, prompts

## Available Tools

This skill provides the following tools:

- **control_command**: 在已建立的CMD远程会话中执行命令，目前支持Windows的CMD。返回命令的退出码、标准输出和错误输出。
- **control_connect**: 发起与指定设备的远控会话连接，支持远程文件(file)、远程桌面(desktop)、远程CMD(cmd2)、远程SSH(ssh)、桌面观看(desktop_view)、远程摄像头(newcamera)、端口转发(forward)。连接成功后返回会话ID，用于后续的桌面操作、截图、命令执行等。
- **control_disconnect**: 终止指定的活跃远控会话，立即断开与该会话的连接。断开后如需再次操作需要重新调用 control_connect 建立连接。建议在不使用会话时及时断开以释放资源。
- **control_portforward**: 在已建立的端口转发远程会话中配置端口转发规则（覆盖），需先建立有效的端口转发远程会话，用于实现本地与远程主机端口的双向数据转发。
- **control_screenshot**: 对指定的远程桌面会话(desktop/desktop_view)进行截图，返回Base64编码的图片数据及尺寸信息。截图可用于获取远程设备的当前画面状态，辅助判断操作结果。
- **control_sessions**: 查询所有当前活跃的远控会话，包括会话ID/会话类型和状态。获取的会话ID可用于截图、执行命令、桌面操作、断开连接等后续操作。
- **desktop_click_mouse**: 在远程桌面会话中模拟鼠标点击操作，支持左键、右键、中键点击及双击。坐标需使用归一化值(0.0-1.0)，通过 x_pixel/屏幕宽度 计算。适用于按钮点击、菜单选择等场景。
- **desktop_drag_mouse**: 在远程桌面中模拟鼠标拖拽操作，支持按住指定按键(left/right/middle)沿路径移动。可用于文件拖拽、窗口调整大小、选择文本区域等。路径坐标需归一化(0.0-1.0)。
- **desktop_move_mouse**: 将鼠标光标移动到远程桌面的指定坐标位置，坐标需归一化(0.0-1.0)。常用于拖拽操作前的定位、悬停触发菜单、或配合截图确定点击位置。仅移动不触发点击。
- **desktop_paste_text**: 在远程桌面中通过系统剪贴板粘贴长文本内容，比逐字符输入更高效。适用于输入大段文本、代码、命令等场景。使用前需确保输入框已获取焦点，且被控端支持剪贴板同步。
- **desktop_press_keys**: 在远程桌面中精确控制按键的按下或释放操作，适合需要精细控制按键状态的场景。支持单独按下(down)、单独释放(up)，或不指定时自动按下后释放。可用于长按、连击等复杂操作。
- **desktop_scroll_mouse**: 在远程桌面的指定位置模拟鼠标滚轮滚动，支持向上(up)或向下(down)滚动指定次数。用于滚动网页、文档、列表等内容查看。坐标需归一化(0.0-1.0)。
- **desktop_typing_keys**: 在远程桌面中执行组合快捷键操作，如复制(Ctrl+C)、粘贴(Ctrl+V)、保存(Ctrl+S)等。按顺序按下所有按键，延迟后再按相反顺序释放。适合需要同时按住多个键的场景。
- **desktop_typing_text**: 在远程桌面中逐字符模拟键盘输入文本，适合输入短文本内容。输入前需确保输入框已获取焦点。可设置字符间延迟(毫秒)控制输入速度。
- **desktop_waiting**: 在远控操作序列中插入暂停等待，用于在关键操作后等待系统响应或页面加载完成。指定持续时间(毫秒)后自动继续执行后续工具。建议在网络延迟或UI渲染场景中使用。
- **device_add**: 将新设备添加到设备列表中，可设置设备名称和描述便于管理。添加成功后可通过 device_search 查询该设备。
- **device_info**: 查询指定设备的完整详细信息，包括硬件配置（CPU、内存、硬盘、显卡）、网络信息（IP地址、MAC地址）、系统版本、在线状态、支持的插件等。必须先通过 device_search 获取设备ID。
- **device_remove**: 从设备列表中删除指定的设备，仅移除列表记录不会影响被控端软件，删除后无法恢复。删除前建议确认设备已不再需要使用。
- **device_search**: 根据关键词模糊搜索设备列表中的设备，支持按设备名称检索，返回匹配的设备基本信息列表。常用于查找特定设备以进行后续远控操作。
- **device_shutdown**: 向在线的远程设备发送关机指令，设备需处于在线状态且被控端支持关机功能。指令下发后设备将在1-2分钟内完成关机并离线。
- **device_update**: 修改指定设备的名称和描述信息，用于更新设备列表中的显示名称和备注，便于设备管理和识别。
- **device_wakeup**: 向绑定了开机硬件的设备发送开机指令，需要设备端配置开机棒或主板支持WOL功能。指令下发后设备将在1-2分钟内完成开机并上线。

## Usage

This skill is automatically invoked when tools from this MCP server are required.

This skill includes an embedded `mcp2skill` binary at `bin/mcp2skill`.
Use `./bin/mcp2skill --help` to see available commands.
Use `./bin/mcp2skill list-tools --server awesun-mcp-server` to list tools.
Use `./bin/mcp2skill call-tool --server awesun-mcp-server --tool <name> --args '<json>'` to call a tool.
Use `./bin/mcp2skill update-skill --skill <skill-dir>` to check for and apply updates to this skill (where <skill-dir> is the path to this skill's directory).
(Note: DO NOT use the `generate-skill` sub-command. It's not supposed to be used under a skill.)

For detailed documentation on each tool's parameters and usage, see [TOOLS.md](references/TOOLS.md).

