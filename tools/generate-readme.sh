#!/usr/bin/env bash
set -euo pipefail

# README 生成脚本
# 扫描 skills/*/skill.json，生成 Skills 列表并更新 README.md

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
README_FILE="$REPO_ROOT/README.md"
SKILLS_DIR="$REPO_ROOT/skills"
TEMP_FILE="$REPO_ROOT/.readme_temp"

# 检查 README 文件是否存在
if [[ ! -f "$README_FILE" ]]; then
  echo "错误: README.md 不存在于 $README_FILE"
  exit 1
fi

# 检查哨兵区块是否存在
if ! grep -q "<!-- SKILLS:BEGIN -->" "$README_FILE" || ! grep -q "<!-- SKILLS:END -->" "$README_FILE"; then
  echo "错误: README.md 中缺少 SKILLS 哨兵区块"
  exit 1
fi

# 生成 skills 列表内容到临时文件
generate_skills_list() {
  # 遍历所有 skill 目录
  for skill_dir in "$SKILLS_DIR"/*; do
    if [[ ! -d "$skill_dir" ]]; then
      continue
    fi

    local skill_file="$skill_dir/SKILL.md"
    if [[ ! -f "$skill_file" ]]; then
      continue
    fi

    # 从 YAML front matter 提取元数据
    local in_frontmatter=false
    local name=""
    local desc=""

    while IFS= read -r line; do
      if [[ "$line" == "---" ]]; then
        if [[ "$in_frontmatter" == "true" ]]; then
          break
        fi
        in_frontmatter=true
        continue
      fi

      if [[ "$in_frontmatter" == "true" ]]; then
        if [[ "$line" =~ ^name:[[:space:]]*(.+)$ ]]; then
          name="${BASH_REMATCH[1]}"
        elif [[ "$line" =~ ^description:[[:space:]]*(.+)$ ]]; then
          desc="${BASH_REMATCH[1]}"
        fi
      fi
    done < "$skill_file"

    if [[ -n "$name" ]]; then
      echo "### $name"
      echo ""
      echo "- **描述**: $desc"
      echo ""
    fi
  done
}

# 生成新内容到临时文件
SKILLS_CONTENT_FILE="$REPO_ROOT/.skills_content"
generate_skills_list > "$SKILLS_CONTENT_FILE"

if [[ ! -s "$SKILLS_CONTENT_FILE" ]]; then
  echo "暂无可用的 skills。" > "$SKILLS_CONTENT_FILE"
fi

# 分三段处理 README
sed -n '1,/<!-- SKILLS:BEGIN -->/p' "$README_FILE" > "$TEMP_FILE"
cat "$SKILLS_CONTENT_FILE" >> "$TEMP_FILE"
sed -n '/<!-- SKILLS:END -->/,$p' "$README_FILE" >> "$TEMP_FILE"

# 替换原文件
mv "$TEMP_FILE" "$README_FILE"
rm -f "$SKILLS_CONTENT_FILE"

echo "✓ README.md 已更新"
