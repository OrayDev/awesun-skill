#!/bin/bash

# 为 Claude Code 安装 awesun-remote-control skill
# 作者：AI Assistant
# 日期：2026年3月5日

set -e

# 颜色输出
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}=== Claude Code - Awesun Remote Control Skill 安装程序 ===${NC}"
echo

# 检查 Claude Code 是否存在
if ! command -v claude-code &> /dev/null; then
    echo -e "${RED}❌ 错误：未找到 claude-code 命令${NC}"
    echo -e "${YELLOW}请确保已正确安装 Claude Code 并添加到 PATH${NC}"
    exit 1
fi

echo -e "${GREEN}✅ 找到 Claude Code${NC}"

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

# 获取 Claude Code 配置目录
echo "🔍 获取 Claude Code 配置目录..."
if [[ "$OSTYPE" == "darwin"* ]]; then
    CLAUDE_CONFIG_DIR="$HOME/Library/Application Support/Claude Code"
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    CLAUDE_CONFIG_DIR="$HOME/.config/claude-code"
else
    CLAUDE_CONFIG_DIR="$HOME/.claude-code"
fi

SKILLS_DIR="$CLAUDE_CONFIG_DIR/skills"
TARGET_DIR="$SKILLS_DIR/awesun-remote-control"

echo "📁 Skills 目录：$SKILLS_DIR"

# 创建 skills 目录
echo "📁 创建 skills 目录..."
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

# 验证安装
echo "✅ 验证安装..."
if [ -f "$TARGET_DIR/SKILL.md" ] && [ -x "$TARGET_DIR/bin/mcp2skill" ]; then
    echo -e "${GREEN}✅ Awesun Remote Control Skill 安装成功！${NC}"
else
    echo -e "${RED}❌ 安装验证失败${NC}"
    exit 1
fi

# 输出后续配置提示
echo
echo -e "${BLUE}=== 后续配置步骤 ===${NC}"
echo -e "${YELLOW}1. 启动向日葵客户端并登录${NC}"
echo -e "${YELLOW}2. 在向日葵客户端中启用 MCP 服务：${NC}"
echo -e "   - 打开设置 -> 高级设置 -> MCP 服务"
echo -e "   - 启用服务并切换到 'Streamable HTTP' 方式"
echo -e "${YELLOW}3. 重启 Claude Code 以加载新的 skill${NC}"
echo -e "${YELLOW}4. 在 Claude Code 中即可使用向日葵远程控制功能${NC}"
echo
echo -e "${GREEN}安装完成！${NC}"