# yf-skills

个人 AI 编程工具（Codex、Claude Code 等）的 skills 仓库。

## 安装

使用安装脚本将白名单内的 skills 安装到本地。默认使用符号链接，修改仓库中的 skill 后会立即反映到本地安装目录：

```bash
# 安装到 ~/.codex/skills、~/.claude/skills 和 ~/.gemini/skills（默认 link 模式）
bash tools/install-skills.sh

# 仅安装到指定目标
bash tools/install-skills.sh --target codex
bash tools/install-skills.sh --target claude
bash tools/install-skills.sh --target gemini

# 保留旧的复制安装方式
bash tools/install-skills.sh --mode copy

# 强制覆盖已存在的 skills
bash tools/install-skills.sh -f

# 预览安装计划（不实际写入）
bash tools/install-skills.sh --dry-run
```

如果之前已经用 copy 方式安装过，首次切换到 link 模式时请加 `-f`，这样会把已有目录替换为符号链接：

```bash
bash tools/install-skills.sh -f
```

## Skills 列表

<!-- SKILLS:BEGIN -->
### demo-hello

- **描述**: 演示 skill 的基本结构和用法

### karpathy-guidelines

- **描述**: Behavioral guidelines to reduce common LLM coding mistakes. Use when writing, reviewing, or refactoring code to avoid overcomplication, make surgical changes, surface assumptions, and define verifiable success criteria.

### summary-to-obsidian

- **描述**: "Use when the user explicitly wants to save, summarize, capture, or organize information into an Obsidian vault or note, including requests such as 写入 Obsidian, 记笔记, 保存到库里, save to Obsidian, write this down in notes, 整理成笔记, 做个总结存起来, 帮我记录一下. This skill orchestrates multiple Obsidian skills (obsidian-markdown, mermaid-visualizer, excalidraw-diagram, obsidian-canvas-creator, obsidian-bases) to produce rich, well-structured notes with diagrams, canvas maps, and database views as needed. Even if the user just says '保存' or 'save this', if the context involves Obsidian or notes, use this skill."

<!-- SKILLS:END -->

## 开发

### 添加新 Skill

1. 在 `skills/` 下创建新目录（目录名即 skill id）
2. 添加 `SKILL.md` 文件（包含 YAML front matter 元数据）
3. 将 skill id 添加到 `config/whitelist.txt`（或注释掉不需要的）
4. 运行 `bash tools/generate-readme.sh` 更新 README
5. 运行 `bash tests/install-skills.test.sh` 验证安装脚本行为

详细规范见 [docs/skill-format.md](docs/skill-format.md)
