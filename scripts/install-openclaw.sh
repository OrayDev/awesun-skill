#!/bin/bash

# 为 🦞OpenClaw 安装 awesun-remote-control skill
# 作者：AI Assistant
# 日期：2026年3月5日

set -e

# 颜色输出
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
NC='\033[0m' # No Color

echo -e "${PURPLE}=== 🦞OpenClaw - Awesun Remote Control Skill 安装程序 ===${NC}"
echo

# 检查 OpenClaw 是否存在
if ! command -v openclaw &> /dev/null; then
    echo -e "${RED}❌ 错误：未找到 openclaw 命令${NC}"
    echo -e "${YELLOW}请确保已正确安装 🦞OpenClaw 并添加到 PATH${NC}"
    exit 1
fi

echo -e "${GREEN}✅ 找到 🦞OpenClaw${NC}"

# 检查向日葵客户端
echo "🔍 检查向日葵客户端..."
if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS
    if [ ! -d "/Applications/Sunlogin Client.app" ]; then
        echo -e "${RED}⚠️  警告：未找到向日葵客户端${NC}"
        echo -e "${YELLOW}请从 https://sunlogin.oray.com 下载并安装向日葵客户端 16.3.2 以上版本${NC}"
    else
        echo -e "${GREEN}✅ 找到向日葵客户端${NC}"
    fi
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    # Linux
    if ! command -v sunloginclient &> /dev/null; then
        echo -e "${RED}⚠️  警告：未找到向日葵客户端${NC}"
        echo -e "${YELLOW}请从 https://sunlogin.oray.com 下载并安装向日葵客户端 16.3.2 以上版本${NC}"
    else
        echo -e "${GREEN}✅ 找到向日葵客户端${NC}"
    fi
else
    echo -e "${YELLOW}⚠️  无法自动检测向日葵客户端，请手动确认已安装${NC}"
fi

# 获取 OpenClaw 配置目录
echo "🔍 获取 OpenClaw 配置目录..."
if [[ "$OSTYPE" == "darwin"* ]]; then
    OPENCLAW_CONFIG_DIR="$HOME/Library/Application Support/OpenClaw"
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    OPENCLAW_CONFIG_DIR="$HOME/.config/openclaw"
else
    OPENCLAW_CONFIG_DIR="$HOME/.openclaw"
fi

EXTENSIONS_DIR="$OPENCLAW_CONFIG_DIR/extensions"
SKILLS_DIR="$OPENCLAW_CONFIG_DIR/skills"
TARGET_DIR="$SKILLS_DIR/awesun-remote-control"

echo "📁 Extensions 目录：$EXTENSIONS_DIR"
echo "📁 Skills 目录：$SKILLS_DIR"

# 创建必要目录
echo "📁 创建必要目录..."
mkdir -p "$EXTENSIONS_DIR"
mkdir -p "$SKILLS_DIR"

# 获取脚本所在目录（skill 项目根目录）
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
SOURCE_DIR="$PROJECT_DIR/awesun-remote-control"

echo "📂 源目录：$SOURCE_DIR"
echo "📂 目标目录：$TARGET_DIR"

# 检查源目录是否存在
if [ ! -d "$SOURCE_DIR" ]; then
    echo -e "${RED}❌ 错误：找不到 awesun-remote-control 源目录${NC}"
    echo -e "${YELLOW}请确保在正确的项目目录下运行此脚本${NC}"
    exit 1
fi

# 检查是否已安装
if [ -d "$TARGET_DIR" ]; then
    echo -e "${YELLOW}⚠️  检测到已安装的 awesun-remote-control skill${NC}"
    read -p "是否覆盖安装？[y/N] " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "安装已取消"
        exit 0
    fi
    echo "🗑️  删除旧版本..."
    rm -rf "$TARGET_DIR"
fi

# 复制 skill 文件
echo "📋 复制 skill 文件..."
cp -r "$SOURCE_DIR" "$TARGET_DIR"

# 确保 mcp2skill 可执行
echo "🔧 设置权限..."
chmod +x "$TARGET_DIR/bin/mcp2skill"

# 创建 OpenClaw skill 清单文件
echo "📝 创建 skill 清单文件..."
cat > "$TARGET_DIR/openclaw.manifest.json" << EOF
{
  "id": "awesun-remote-control",
  "name": "Awesun Remote Control",
  "displayName": "🦞 向日葵远程控制",
  "version": "1.0.0",
  "description": "提供向日葵远程控制功能，包括设备管理、远程桌面、远程命令行、端口转发等22种工具",
  "author": "OrayDev",
  "license": "MIT",
  "homepage": "https://github.com/OrayDev/awesun-skill",
  "repository": "https://github.com/OrayDev/awesun-skill",
  "categories": ["Remote Control", "Productivity", "System"],
  "keywords": ["remote-control", "desktop", "awesun", "mcp", "vnc", "ssh"],
  "engines": {
    "openclaw": ">=1.0.0",
    "mcp": ">=2025-06-18"
  },
  "main": "bin/mcp2skill",
  "mcp_server": "awesun-mcp-server",
  "capabilities": {
    "tools": 22,
    "prompts": 0,
    "resources": 0
  },
  "permissions": [
    "network",
    "clipboard",
    "screenshot",
    "system.remote-control"
  ],
  "dependencies": {
    "awesun-client": ">=16.3.2"
  },
  "icon": "🦞",
  "extensionKind": "skill"
}
EOF

# 创建 OpenClaw 扩展配置
echo "📝 创建扩展配置..."
cat > "$EXTENSIONS_DIR/awesun-remote-control.json" << EOF
{
  "id": "awesun-remote-control",
  "enabled": true,
  "type": "skill",
  "path": "../skills/awesun-remote-control",
  "autoload": true,
  "priority": 1
}
EOF

# 创建工具快速访问配置
echo "📝 创建工具快速访问配置..."
cat > "$TARGET_DIR/tools-quick-access.json" << EOF
{
  "categories": {
    "设备管理": {
      "icon": "🖥️",
      "tools": ["device_search", "device_info", "device_add", "device_remove", "device_update"]
    },
    "远程连接": {
      "icon": "🔗",
      "tools": ["control_connect", "control_disconnect", "control_sessions"]
    },
    "桌面控制": {
      "icon": "🖱️",
      "tools": ["desktop_click_mouse", "desktop_move_mouse", "desktop_drag_mouse", "desktop_scroll_mouse", "desktop_typing_text", "desktop_typing_keys", "desktop_press_keys", "desktop_paste_text"]
    },
    "系统操作": {
      "icon": "⚡",
      "tools": ["control_command", "control_screenshot", "desktop_waiting", "device_shutdown", "device_wakeup"]
    },
    "网络工具": {
      "icon": "🌐",
      "tools": ["control_portforward"]
    }
  }
}
EOF

# 验证安装
echo "✅ 验证安装..."
if [ -f "$TARGET_DIR/SKILL.md" ] && [ -x "$TARGET_DIR/bin/mcp2skill" ] && [ -f "$TARGET_DIR/openclaw.manifest.json" ]; then
    echo -e "${GREEN}✅ Awesun Remote Control Skill 安装成功！${NC}"
else
    echo -e "${RED}❌ 安装验证失败${NC}"
    exit 1
fi

# 输出后续配置提示
echo
echo -e "${PURPLE}=== 后续配置步骤 ===${NC}"
echo -e "${YELLOW}1. 启动向日葵客户端并登录${NC}"
echo -e "${YELLOW}2. 在向日葵客户端中启用 MCP 服务：${NC}"
echo -e "   - 打开设置 -> 高级设置 -> MCP 服务"
echo -e "   - 启用服务并切换到 'Streamable HTTP' 方式"
echo -e "${YELLOW}3. 重启 🦞OpenClaw 以加载新的 skill${NC}"
echo -e "${YELLOW}4. 在 🦞OpenClaw 扩展管理中确认 awesun-remote-control 已启用${NC}"
echo -e "${YELLOW}5. 在 🦞OpenClaw 中即可使用向日葵远程控制功能${NC}"
echo
echo -e "${PURPLE}🦞 特殊功能：${NC}"
echo -e "${GREEN}- 分类工具访问：skills 被分为5个类别便于使用${NC}"
echo -e "${GREEN}- 快速工具栏：常用远程控制工具快速访问${NC}"
echo -e "${GREEN}- 智能提示：基于上下文的工具建议${NC}"
echo
echo -e "${GREEN}安装完成！Enjoy your 🦞OpenClaw experience!${NC}"