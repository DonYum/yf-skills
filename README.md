# yf-skills

个人 AI 编程工具（Codex、Claude Code 等）的 skills 仓库。

## 安装

使用安装脚本将白名单内的 skills 安装到本地：

```bash
# 安装到 ~/.codex/skills 和 ~/.claude/skills
bash tools/install-skills.sh

# 仅安装到指定目标
bash tools/install-skills.sh --target codex
bash tools/install-skills.sh --target claude

# 强制覆盖已存在的 skills
bash tools/install-skills.sh -f

# 预览安装计划（不实际写入）
bash tools/install-skills.sh --dry-run
```

## Skills 列表

<!-- SKILLS:BEGIN -->
### demo-hello

- **描述**: 演示 skill 的基本结构和用法

### summary-to-obsidian

- **描述**: Use when user asks to research, investigate, analyze, compare, or summarize a topic and wants results saved as Obsidian notes. Triggers on Chinese keywords like 调研、研究、分析、整理、总结、对比 as well as English equivalents. Creates structured markdown notes in the user's Obsidian research vault.

<!-- SKILLS:END -->

## 开发

### 添加新 Skill

1. 在 `skills/` 下创建新目录（目录名即 skill id）
2. 添加 `SKILL.md` 文件（包含 YAML front matter 元数据）
3. 将 skill id 添加到 `config/whitelist.txt`（或注释掉不需要的）
4. 运行 `bash tools/generate-readme.sh` 更新 README

详细规范见 [docs/skill-format.md](docs/skill-format.md)

