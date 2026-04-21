#!/usr/bin/env python3
import argparse
import json
import os
import subprocess
import sys
from pathlib import Path


def load_config():
    script_dir = Path(__file__).parent
    config_path = script_dir / "mcp.json"
    if not config_path.exists():
        print(f"错误: 找不到 mcp.json 配置文件 ({config_path})", file=sys.stderr)
        sys.exit(1)
    try:
        with open(config_path, 'r', encoding='utf-8') as f:
            return json.load(f)
    except json.JSONDecodeError as e:
        print(f"错误: mcp.json 格式无效 - {e}", file=sys.stderr)
        sys.exit(1)
    except IOError as e:
        print(f"错误: 无法读取 mcp.json - {e}", file=sys.stderr)
        sys.exit(1)


def get_awesun_config(config):
    mcp_servers = config.get("mcpServers", {})
    for key in ["awesun-mcp-server", "awesun_mcp_server", "awesun"]:
        if key in mcp_servers:
            return mcp_servers[key]
    for key, value in mcp_servers.items():
        if "awesun" in key.lower():
            return value
    print("错误: mcp.json 中找不到 awesun-mcp-server 配置", file=sys.stderr)
    sys.exit(1)


def run_cli(command_path, args, env_vars):
    run_env = os.environ.copy()
    run_env.update(env_vars)
    cmd = [command_path, "--cli"] + args
    try:
        result = subprocess.run(cmd, capture_output=True, text=True, env=run_env)
        if result.returncode != 0:
            print(f"错误: {result.stderr}", file=sys.stderr)
            sys.exit(result.returncode)
        print(result.stdout)
    except FileNotFoundError:
        print(f"错误: 找不到命令 '{command_path}'", file=sys.stderr)
        sys.exit(1)
    except PermissionError:
        print(f"错误: 没有权限执行 '{command_path}'", file=sys.stderr)
        sys.exit(1)


def main():
    parser = argparse.ArgumentParser(
        description="AweSun MCP CLI",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
示例:
  python awesun.py list
  python awesun.py describe device_search
  python awesun.py call device_search '{"limit": 1}'
        """
    )
    
    subparsers = parser.add_subparsers(dest="command", help="命令")
    
    # list
    subparsers.add_parser("list", help="列出所有工具")
    
    # describe
    describe_parser = subparsers.add_parser("describe", help="查看工具详情")
    describe_parser.add_argument("tool_name", help="工具名称")
    
    # call
    call_parser = subparsers.add_parser("call", help="执行工具")
    call_parser.add_argument("tool_name", help="工具名称")
    call_parser.add_argument("tool_args", help="JSON 参数")
    
    args = parser.parse_args()
    
    if not args.command:
        parser.print_help()
        sys.exit(1)
    
    config = load_config()
    awesun_config = get_awesun_config(config)
    command_path = awesun_config.get("command")
    if not command_path:
        print("错误: 配置中缺少 command 字段", file=sys.stderr)
        sys.exit(1)
    
    env_vars = {k: str(v) for k, v in awesun_config.get("env", {}).items()}
    
    if args.command == "list":
        run_cli(command_path, ["list"], env_vars)
    elif args.command == "describe":
        run_cli(command_path, ["describe", args.tool_name], env_vars)
    elif args.command == "call":
        run_cli(command_path, ["call", args.tool_name, args.tool_args], env_vars)


if __name__ == "__main__":
    main()
