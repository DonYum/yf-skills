#!/usr/bin/env bash
set -euo pipefail

# Skills 安装脚本
# 将白名单内的 skills 安装到 ~/.codex/skills、~/.claude/skills 和 ~/.gemini/skills

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
SKILLS_DIR="$REPO_ROOT/skills"
WHITELIST_FILE="$REPO_ROOT/config/whitelist.txt"

# 默认参数
FORCE=false
DRY_RUN=false
TARGET="all"

# 解析命令行参数
while [[ $# -gt 0 ]]; do
  case $1 in
    -f|--force)
      FORCE=true
      shift
      ;;
    --dry-run)
      DRY_RUN=true
      shift
      ;;
    --target)
      TARGET="$2"
      shift 2
      ;;
    *)
      echo "未知参数: $1"
      echo "用法: $0 [-f|--force] [--dry-run] [--target codex|claude|gemini|all]"
      exit 1
      ;;
  esac
done

# 验证 target 参数
if [[ "$TARGET" != "codex" && "$TARGET" != "claude" && "$TARGET" != "gemini" && "$TARGET" != "all" && "$TARGET" != "both" ]]; then
  echo "错误: --target 必须是 codex、claude、gemini、all 或 both"
  exit 1
fi

# 检查白名单文件
if [[ ! -f "$WHITELIST_FILE" ]]; then
  echo "错误: 白名单文件不存在: $WHITELIST_FILE"
  exit 1
fi

# 读取白名单
WHITELIST=""
while IFS= read -r line; do
  # 移除行首尾空白
  line=$(echo "$line" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')

  # 跳过空行和注释行
  if [[ -z "$line" || "$line" =~ ^# ]]; then
    continue
  fi

  WHITELIST="$WHITELIST $line"
done < "$WHITELIST_FILE"

# 移除开头的空格
WHITELIST=$(echo "$WHITELIST" | sed 's/^[[:space:]]*//')

if [[ -z "$WHITELIST" ]]; then
  echo "错误: 白名单为空或解析失败"
  exit 1
fi

echo "白名单 skills: $WHITELIST"
echo ""

# 确定目标目录
TARGETS=()
if [[ "$TARGET" == "all" || "$TARGET" == "both" || "$TARGET" == "codex" ]]; then
  TARGETS+=("$HOME/.codex/skills")
fi
if [[ "$TARGET" == "all" || "$TARGET" == "both" || "$TARGET" == "claude" ]]; then
  TARGETS+=("$HOME/.claude/skills")
fi
if [[ "$TARGET" == "all" || "$TARGET" == "gemini" ]]; then
  TARGETS+=("$HOME/.gemini/skills")
fi

# 安装函数
install_skill() {
  local skill_id="$1"
  local target_dir="$2"
  local skill_source="$SKILLS_DIR/$skill_id"
  local skill_dest="$target_dir/$skill_id"

  if [[ ! -d "$skill_source" ]]; then
    echo "  ⚠ 跳过: $skill_id (源目录不存在)"
    return
  fi

  if [[ ! -f "$skill_source/SKILL.md" ]]; then
    echo "  ⚠ 跳过: $skill_id (SKILL.md 不存在)"
    return
  fi

  # 检查目标是否已存在
  if [[ -d "$skill_dest" ]]; then
    if [[ "$DRY_RUN" == "true" ]]; then
      echo "  [DRY-RUN] 将覆盖: $skill_source -> $skill_dest"
      return
    fi
  fi

  if [[ "$DRY_RUN" == "true" ]]; then
    echo "  [DRY-RUN] 将安装: $skill_source -> $skill_dest"
  else
    mkdir -p "$skill_dest"
    cp "$skill_source/SKILL.md" "$skill_dest/SKILL.md"
    echo "  ✓ 已安装: $skill_id -> $skill_dest"
  fi
}

# 遍历目标和白名单
for target_dir in "${TARGETS[@]}"; do
  echo "目标: $target_dir"

  if [[ "$DRY_RUN" == "false" ]]; then
    mkdir -p "$target_dir"
  fi

  for skill_id in $WHITELIST; do
    install_skill "$skill_id" "$target_dir"
  done

  echo ""
done

if [[ "$DRY_RUN" == "true" ]]; then
  echo "这是预览模式，未实际写入文件。"
  echo "移除 --dry-run 参数以执行实际安装。"
else
  echo "✓ 安装完成"
fi
